package com.nevigo.ai_navigo.service;

import com.nevigo.ai_navigo.dao.IF_ForeignPlanDao;
import com.nevigo.ai_navigo.dao.IF_TravelHistoryDao;
import com.nevigo.ai_navigo.dto.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
public class ForeignPlanServiceImpl implements IF_ForeignPlanService {

    @Autowired
    private IF_ForeignPlanDao foreignPlanDao;


    @Autowired
    private RestTemplate restTemplate;

    @Value("${python.server.url}")
    private String pythonServerUrl;

    @Transactional
    @Override
    public Long createPlan(ForeignPlanDTO planDTO) throws Exception {
        try {
            // 1. Prepare Python request payload
            Map<String, Object> pythonRequest = prepareRequestPayload(planDTO);

            // 2. Send request to Python server
            ResponseEntity<Map> response = sendTravelPlanRequest(pythonRequest);

            // 3. Validate and process response
            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                Map<String, Object> responseBody = response.getBody();

                // 4. Validate response contains travel plan data
                if (!responseBody.containsKey("daily_schedule")) {
                    throw new Exception("Invalid travel plan data received");
                }

                // 5. Insert base plan
                int planInsertResult = foreignPlanDao.insertPlan(planDTO);
                if (planInsertResult <= 0) {
                    throw new Exception("Failed to insert travel plan");
                }

                // 6. Process and insert schedules and activities
                processSchedulesAndActivities(planDTO, responseBody);

                // 7. Fetch and save place photos
                List<String> placeNames = extractPlaceNames(responseBody);
                Map<String, String> photos = fetchPlacePhotos(placeNames);

                if (photos != null && !photos.isEmpty()) {
                    savePlacePhotos(planDTO.getPlanId(), photos);
                }

                return planDTO.getPlanId();
            }

            throw new Exception("Failed to retrieve travel plan data");

        } catch (Exception e) {
            log.error("Error creating travel plan", e);
            throw new Exception("Error creating travel plan: " + e.getMessage(), e);
        }
    }

    @Transactional
    @Override
    public Long createPlanFromJson(Map<String, Object> planData, String memberId) throws Exception {
        try {
            // 1. Convert JSON to base plan DTO
            ForeignPlanDTO planDTO = convertJsonToPlanDTO(planData, memberId);

            // 2. Insert base plan
            int planInsertResult = foreignPlanDao.insertPlan(planDTO);
            if (planInsertResult <= 0) {
                throw new Exception("Failed to insert travel plan");
            }

            // 3. Process schedules and activities
            List<Map<String, Object>> dailySchedules =
                    (List<Map<String, Object>>) planData.get("daily_schedule");

            for (Map<String, Object> dailySchedule : dailySchedules) {
                // Create and insert schedule
                ForeignScheduleDTO scheduleDTO = createScheduleDTO(dailySchedule, planDTO.getPlanId());
                foreignPlanDao.insertSchedule(scheduleDTO);

                // Create and insert activities
                List<Map<String, Object>> activities =
                        (List<Map<String, Object>>) dailySchedule.get("activities");

                for (Map<String, Object> activity : activities) {
                    ForeignActivityDTO activityDTO = createActivityDTO(activity, scheduleDTO.getScheduleId());
                    foreignPlanDao.insertActivity(activityDTO);
                }
            }

            return planDTO.getPlanId();
        } catch (Exception e) {
            log.error("Error creating plan from JSON", e);
            throw new Exception("여행 계획 생성 중 오류 발생: " + e.getMessage(), e);
        }
    }

    @Override
    public List<ForeignPlanDTO> getPlanList(String memberId) throws Exception {
        return foreignPlanDao.getPlanList(memberId);
    }

    @Override
    public Map<String, Object> getPlanWithFullDetails(Long planId) throws Exception {
        Map<String, Object> result = new HashMap<>();

        // 1. Retrieve base plan
        ForeignPlanDTO plan = foreignPlanDao.getPlan(planId);
        if (plan == null) {
            throw new Exception("Plan not found");
        }

        result.put("plan", plan);

        // 2. Retrieve schedules
        List<ForeignScheduleDTO> schedules = foreignPlanDao.getSchedulesByPlanId(planId);

        // 3. Retrieve activities for each schedule
        for (ForeignScheduleDTO schedule : schedules) {
            List<ForeignActivityDTO> activities =
                    foreignPlanDao.getActivitiesByScheduleId(schedule.getScheduleId());
            schedule.setActivities(activities);
        }

        result.put("schedules", schedules);

        return result;
    }

    // Helper methods for request preparation and conversion
    private Map<String, Object> prepareRequestPayload(ForeignPlanDTO planDTO) {
        Map<String, Object> pythonRequest = new HashMap<>();
        pythonRequest.put("destination", new HashMap<String, Object>() {{
            put("name", planDTO.getDestination());
            put("lat", planDTO.getDestinationDetail().getLat());
            put("lng", planDTO.getDestinationDetail().getLng());
        }});
        pythonRequest.put("start_date", planDTO.getStartDate().toString());
        pythonRequest.put("end_date", planDTO.getEndDate().toString());
        pythonRequest.put("budget", 2000000);
        pythonRequest.put("themes", planDTO.getThemes());
        pythonRequest.put("travelers", new HashMap<String, Object>() {{
            put("count", planDTO.getTravelers().getCount());
            put("type", planDTO.getTravelers().getType());
        }});

        return pythonRequest;
    }

    private ResponseEntity<Map> sendTravelPlanRequest(Map<String, Object> pythonRequest) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(pythonRequest, headers);

        return restTemplate.exchange(
                pythonServerUrl + "/travel-plan",
                HttpMethod.POST,
                entity,
                Map.class
        );
    }


    private void processSchedulesAndActivities(ForeignPlanDTO planDTO, Map<String, Object> responseBody) throws Exception {
        List<Map<String, Object>> dailySchedules =
                (List<Map<String, Object>>) responseBody.get("daily_schedule");

        for (Map<String, Object> dailySchedule : dailySchedules) {
            // Create Schedule DTO
            ForeignScheduleDTO scheduleDTO = new ForeignScheduleDTO();
            scheduleDTO.setPlanId(planDTO.getPlanId());
            scheduleDTO.setDayNumber((Integer) dailySchedule.get("day"));
            scheduleDTO.setScheduleDate(LocalDate.parse((String) dailySchedule.get("date")));

            // Insert Schedule
            foreignPlanDao.insertSchedule(scheduleDTO);

            // Process Activities
            List<Map<String, Object>> activities =
                    (List<Map<String, Object>>) dailySchedule.get("activities");
            for (Map<String, Object> activity : activities) {
                ForeignActivityDTO activityDTO = convertToActivityDTO(activity,scheduleDTO.getScheduleId(), planDTO);
                foreignPlanDao.insertActivity(activityDTO);
            }
        }
    }

    private List<String> extractPlaceNames(Map<String, Object> responseBody) {
        List<String> placeNames = new ArrayList<>();
        List<Map<String, Object>> dailySchedules =
                (List<Map<String, Object>>) responseBody.get("daily_schedule");

        for (Map<String, Object> dailySchedule : dailySchedules) {
            List<Map<String, Object>> activities =
                    (List<Map<String, Object>>) dailySchedule.get("activities");

            for (Map<String, Object> activity : activities) {
                placeNames.add((String) activity.get("place"));
            }
        }

        return placeNames;
    }

    private Map<String, String> fetchPlacePhotos(List<String> placeNames) {
        try {
            ResponseEntity<Map> response = restTemplate.postForEntity(
                    pythonServerUrl + "/places-photos",
                    new PlaceRequestDTO(placeNames),
                    Map.class
            );

            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                return (Map<String, String>) response.getBody().get("photos");
            }
            return null;
        } catch (Exception e) {
            log.error("사진 가져오기 중 오류 발생", e);
            return null;
        }
    }

    private ForeignActivityDTO convertToActivityDTO(Map<String, Object> activity, Long scheduleId, ForeignPlanDTO planDTO) {
        ForeignActivityDTO activityDTO = new ForeignActivityDTO();
        activityDTO.setScheduleId(scheduleId);
        activityDTO.setPlaceName((String) activity.get("place"));
        activityDTO.setActivityType((String) activity.get("type"));
        activityDTO.setVisitTime(LocalTime.parse((String) activity.get("time")));
        activityDTO.setDuration(Integer.parseInt((String) activity.get("duration")));

        // Null-safe location handling
        Map<String, Object> location = (Map<String, Object>) activity.get("location");
        if (location != null) {
            Double lat = location.get("lat") instanceof Number
                    ? ((Number) location.get("lat")).doubleValue()
                    : null;
            Double lng = location.get("lng") instanceof Number
                    ? ((Number) location.get("lng")).doubleValue()
                    : null;

            if (lat != null && lng != null && lat != 0.0 && lng != 0.0) {
                activityDTO.setLatitude(lat);
                activityDTO.setLongitude(lng);
            } else {
                activityDTO.setLatitude(planDTO.getDestinationDetail().getLat());
                activityDTO.setLongitude(planDTO.getDestinationDetail().getLng());
                log.warn("Invalid or missing location coordinates for activity: {}", activity.get("place"));
            }
        } else {
            activityDTO.setLatitude(planDTO.getDestinationDetail().getLat());
            activityDTO.setLongitude(planDTO.getDestinationDetail().getLng());
            log.warn("No location data found for activity: {}", activity.get("place"));
        }

        activityDTO.setNotes((String) activity.get("notes"));

        return activityDTO;
    }

    private ForeignPlanDTO convertJsonToPlanDTO(Map<String, Object> planData, String memberId) {
        ForeignPlanDTO planDTO = new ForeignPlanDTO();
        planDTO.setMemberId(memberId);

        // Extract destination from JSON
        Map<String, Object> summary = (Map<String, Object>) planData.get("summary");
        String destination = summary.containsKey("destination")
                ? (String) summary.get("destination")
                : "";
        planDTO.setDestination(destination);

        // Set dates from the first daily schedule
        List<Map<String, Object>> dailySchedules =
                (List<Map<String, Object>>) planData.get("daily_schedule");

        if (!dailySchedules.isEmpty()) {
            Map<String, Object> firstSchedule = dailySchedules.get(0);
            LocalDate startDate = LocalDate.parse((String) firstSchedule.get("date"));
            LocalDate endDate = LocalDate.parse((String) dailySchedules.get(dailySchedules.size() - 1).get("date"));

            planDTO.setStartDate(startDate);
            planDTO.setEndDate(endDate);
        }

        return planDTO;
    }

    private ForeignScheduleDTO createScheduleDTO(Map<String, Object> dailySchedule, Long planId) {
        ForeignScheduleDTO scheduleDTO = new ForeignScheduleDTO();
        scheduleDTO.setPlanId(planId);
        scheduleDTO.setDayNumber((Integer) dailySchedule.get("day"));
        scheduleDTO.setScheduleDate(LocalDate.parse((String) dailySchedule.get("date")));

        return scheduleDTO;
    }

    private ForeignActivityDTO createActivityDTO(Map<String, Object> activity, Long scheduleId) {
        ForeignActivityDTO activityDTO = new ForeignActivityDTO();

        Map<String, Object> location = (Map<String, Object>) activity.get("location");
        if (location != null) {
            Double lat = location.get("lat") instanceof Number
                    ? ((Number) location.get("lat")).doubleValue()
                    : null;
            Double lng = location.get("lng") instanceof Number
                    ? ((Number) location.get("lng")).doubleValue()
                    : null;

            // Additional validation to prevent (0,0) coordinates
            if (lat != null && lng != null && lat != 0.0 && lng != 0.0) {
                activityDTO.setLatitude(lat);
                activityDTO.setLongitude(lng);
            } else {
                log.warn("Invalid coordinates for activity: {} - Lat: {}, Lng: {}",
                        activity.get("place"), lat, lng);
            }
        }

        return activityDTO;
    }

    @Transactional
    @Override
    public void savePlacePhotos(Long planId, Map<String, String> photos) throws Exception {
        List<ForeignPlacePhotoDTO> photoEntities = photos.entrySet().stream()
                .map(entry -> {
                    ForeignPlacePhotoDTO photoDto = new ForeignPlacePhotoDTO();
                    photoDto.setPlanId(planId);
                    photoDto.setPlaceName(entry.getKey());
                    photoDto.setPhotoUrl(entry.getValue());
                    return photoDto;
                })
                .collect(Collectors.toList());

        foreignPlanDao.insertPlacePhotos(photoEntities);
    }

    public List<ForeignPlacePhotoDTO> getPlacePhotosByPlanId(Long planId) throws Exception {
        return foreignPlanDao.getPlacePhotosByPlanId(planId);
    }



}
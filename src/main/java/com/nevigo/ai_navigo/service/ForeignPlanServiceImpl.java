package com.nevigo.ai_navigo.service;

import com.nevigo.ai_navigo.dao.IF_ForeignPlanDao;
import com.nevigo.ai_navigo.dto.ForeignActivityDTO;
import com.nevigo.ai_navigo.dto.ForeignPlanDTO;
import com.nevigo.ai_navigo.dto.ForeignScheduleDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ForeignPlanServiceImpl implements IF_ForeignPlanService {

    private final IF_ForeignPlanDao foreignPlanDao;

    private final RestTemplate restTemplate;

    @Value("${python.server.url}")
    private String pythonServerUrl;

    @Override
    public int createPlan(ForeignPlanDTO planDTO) throws Exception {
        try {
            // Python 서버 요청용 데이터 준비
            Map<String, Object> pythonRequest = new HashMap<>();
            pythonRequest.put("destination", new HashMap<String, Object>() {{
                put("name", planDTO.getDestination());
                put("lat", planDTO.getDestinationDetail().getLat());
                put("lng", planDTO.getDestinationDetail().getLng());
            }});
            pythonRequest.put("start_date", planDTO.getStartDate().toString());
            pythonRequest.put("end_date", planDTO.getEndDate().toString());
            pythonRequest.put("budget", planDTO.getBudget());
            pythonRequest.put("themes", planDTO.getThemes());
            pythonRequest.put("travelers", new HashMap<String, Object>() {{
                put("count", planDTO.getTravelers().getCount());
                put("type", planDTO.getTravelers().getType());
            }});

            // Python 서버 호출
            Map<String, Object> pythonResponse = restTemplate.postForObject(
                    pythonServerUrl + "/travel-plan",
                    pythonRequest,
                    Map.class
            );

            if (pythonResponse != null && pythonResponse.containsKey("daily_schedule")) {
                // 1. 먼저 기본 계획 저장
                int planResult = foreignPlanDao.insertPlan(planDTO);

                if (planResult > 0) {
                    // 2. 일정 정보 저장
                    List<Map<String, Object>> dailySchedules =
                            (List<Map<String, Object>>) pythonResponse.get("daily_schedule");

                    for (Map<String, Object> daySchedule : dailySchedules) {
                        // 일정 정보 변환 및 저장
                        ForeignScheduleDTO scheduleDTO = new ForeignScheduleDTO();
                        scheduleDTO.setPlanId(planDTO.getPlanId());
                        scheduleDTO.setDayNumber((Integer) daySchedule.get("day"));
                        scheduleDTO.setScheduleDate(LocalDate.parse((String) daySchedule.get("date")));

                        int scheduleResult = foreignPlanDao.insertSchedule(scheduleDTO);

                        if (scheduleResult > 0) {
                            // 3. 활동 정보 저장
                            List<Map<String, Object>> activities =
                                    (List<Map<String, Object>>) daySchedule.get("activities");

                            for (Map<String, Object> activity : activities) {
                                ForeignActivityDTO activityDTO = new ForeignActivityDTO();
                                activityDTO.setScheduleId(scheduleDTO.getScheduleId());
                                activityDTO.setPlaceName((String) activity.get("place"));

                                Map<String, Double> location =
                                        (Map<String, Double>) activity.get("location");
                                activityDTO.setLatitude(location.get("lat"));
                                activityDTO.setLongitude(location.get("lng"));

                                activityDTO.setVisitTime(
                                        LocalTime.parse((String) activity.get("time"))
                                );
                                activityDTO.setDuration((Integer) activity.get("duration"));
                                activityDTO.setActivityType((String) activity.get("type"));
                                activityDTO.setNotes((String) activity.get("notes"));

                                foreignPlanDao.insertActivity(activityDTO);
                            }
                        }
                    }
                }

                return planDTO.getPlanId().intValue();
            }

            throw new Exception("Failed to process travel plan data");

        } catch (Exception e) {
            throw new Exception("Error creating travel plan: " + e.getMessage());
        }
    }

    @Override
    public ForeignPlanDTO getPlan(Long planId) throws Exception {
        ForeignPlanDTO planDTO = foreignPlanDao.getPlan(planId);
        if (planDTO == null) {
            throw new Exception("Plan not found with ID: " + planId);
        }
        return planDTO;
    }

    @Override
    public List<ForeignPlanDTO> getPlanList(String memberId) throws Exception {
        return foreignPlanDao.getPlanList(memberId);
    }

    @Override
    public Map<String, Object> getPlanWithFullDetails(Long planId) throws Exception {
        Map<String, Object> result = new HashMap<>();

        // 1. 기본 계획 정보 조회
        ForeignPlanDTO plan = foreignPlanDao.getPlan(planId);
        if (plan == null) {
            throw new Exception("Plan not found");
        }
        result.put("plan", plan);

        // 2. 일정 정보 조회
        List<ForeignScheduleDTO> schedules = foreignPlanDao.getSchedulesByPlanId(planId);

        // 3. 각 일정별 활동 정보 조회 및 매핑
        for (ForeignScheduleDTO schedule : schedules) {
            List<ForeignActivityDTO> activities =
                    foreignPlanDao.getActivitiesByScheduleId(schedule.getScheduleId());
            schedule.setActivities(activities);
        }

        result.put("schedules", schedules);

        return result;
    }
}
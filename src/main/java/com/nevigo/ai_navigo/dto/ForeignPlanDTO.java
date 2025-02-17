package com.nevigo.ai_navigo.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@ToString
public class ForeignPlanDTO {
    private Long planId;
    private String memberId;
    private String destination;
    private LocalDate startDate;
    private LocalDate endDate;
    private LocalDateTime createdAt;
    private LocalDateTime uptDate;

    // Python 서버 요청/응답용 필드들 (DB에는 저장되지 않음)
    private DestinationDTO destinationDetail;  // lat, lng 정보를 위한 별도 객체
    private int budget;
    private List<String> themes;
    private TravelersDTO travelers;
    private TravelSummaryDTO summary;
    private List<ForeignScheduleDTO> dailySchedule;
}
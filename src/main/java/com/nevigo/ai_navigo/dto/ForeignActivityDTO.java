package com.nevigo.ai_navigo.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;
import java.time.LocalTime;

@Getter
@Setter
@ToString
public class ForeignActivityDTO {
    private Long activityId;
    private Long scheduleId;
    private String placeName;        // place_name으로 변경
    private double latitude;         // LocationDTO 대신 직접 위도/경도 필드
    private double longitude;
    private LocalTime visitTime;     // TIME 타입에 맞춰 LocalTime 사용
    private int duration;
    private String activityType;     // activity_type으로 변경
    private String notes;
    private LocalDateTime createdAt;
    private LocalDateTime uptDate;
}
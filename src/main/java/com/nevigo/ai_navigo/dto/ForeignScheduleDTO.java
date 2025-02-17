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
public class ForeignScheduleDTO {
    private Long scheduleId;
    private Long planId;
    private int dayNumber;           // day_number로 변경
    private LocalDate scheduleDate;  // schedule_date로 변경
    private LocalDateTime createdAt;
    private LocalDateTime uptDate;

    private List<ForeignActivityDTO> activities;  // 연관된 활동들
}
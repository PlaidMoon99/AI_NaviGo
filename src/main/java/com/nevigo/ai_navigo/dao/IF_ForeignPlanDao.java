package com.nevigo.ai_navigo.dao;

import com.nevigo.ai_navigo.dto.ForeignActivityDTO;
import com.nevigo.ai_navigo.dto.ForeignPlanDTO;
import com.nevigo.ai_navigo.dto.ForeignScheduleDTO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface IF_ForeignPlanDao {
    // 계획 관련
    int insertPlan(ForeignPlanDTO planDTO);
    ForeignPlanDTO getPlan(Long planId);
    List<ForeignPlanDTO> getPlanList(String memberId);

    // 일정 관련
    int insertSchedule(ForeignScheduleDTO scheduleDTO);
    List<ForeignScheduleDTO> getSchedulesByPlanId(Long planId);

    // 활동 관련
    int insertActivity(ForeignActivityDTO activityDTO);
    List<ForeignActivityDTO> getActivitiesByScheduleId(Long scheduleId);
}
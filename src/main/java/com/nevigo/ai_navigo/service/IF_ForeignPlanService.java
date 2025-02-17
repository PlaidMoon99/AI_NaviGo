package com.nevigo.ai_navigo.service;

import com.nevigo.ai_navigo.dto.ForeignPlanDTO;

import java.util.List;
import java.util.Map;

public interface IF_ForeignPlanService {
    // 계획 생성 및 조회
    int createPlan(ForeignPlanDTO planDTO) throws Exception;
    ForeignPlanDTO getPlan(Long planId) throws Exception;
    List<ForeignPlanDTO> getPlanList(String memberId) throws Exception;

    // 추가적인 비즈니스 메서드들
    Map<String, Object> getPlanWithFullDetails(Long planId) throws Exception;  // 계획, 일정, 활동 모두 포함
}
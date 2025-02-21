package com.nevigo.ai_navigo.service;

import com.nevigo.ai_navigo.dto.ForeignPlacePhotoDTO;
import com.nevigo.ai_navigo.dto.ForeignPlanDTO;

import java.util.List;
import java.util.Map;

public interface IF_ForeignPlanService {
    Long createPlan(ForeignPlanDTO planDTO) throws Exception;
    List<ForeignPlanDTO> getPlanList(String memberId) throws Exception;
    Map<String, Object> getPlanWithFullDetails(Long planId) throws Exception;

    // New method to handle JSON-based plan creation
    Long createPlanFromJson(Map<String, Object> planData, String memberId) throws Exception;
    void savePlacePhotos(Long planId, Map<String, String> photos) throws Exception;
    List<ForeignPlacePhotoDTO> getPlacePhotosByPlanId(Long planId) throws Exception;

}
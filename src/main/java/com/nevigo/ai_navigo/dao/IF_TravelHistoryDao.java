package com.nevigo.ai_navigo.dao;

import com.nevigo.ai_navigo.dto.ForeignPlanDTO;

import java.util.List;

public interface IF_TravelHistoryDao {
    // mypage
    public List<ForeignPlanDTO> getPlansByMemberId(String memberId);
    public ForeignPlanDTO getPlanDetail(int planId);

}

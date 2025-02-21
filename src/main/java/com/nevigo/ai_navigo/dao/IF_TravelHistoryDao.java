package com.nevigo.ai_navigo.dao;

import com.nevigo.ai_navigo.dto.ForeignPlanDTO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface IF_TravelHistoryDao {
    // mypage
    public List<ForeignPlanDTO> getPlansByMemberId(String memberId);
    public ForeignPlanDTO getPlanDetail(int planId);

}

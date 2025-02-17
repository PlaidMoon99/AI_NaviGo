package com.nevigo.ai_navigo.dao;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface PreferenceDao {
    String getPreferenceById(@Param("memberId") String memberId);

    void updatePreference(@Param("memberId") String memberId, @Param("preference") String preference);

    void insertPreference(@Param("memberId") String memberId, @Param("preference") String preference);
}

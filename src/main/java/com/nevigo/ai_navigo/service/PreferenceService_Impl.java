package com.nevigo.ai_navigo.service;

import com.nevigo.ai_navigo.dao.PreferenceDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.nevigo.ai_navigo.dao.IF_preferenceDao; // 실제 DAO 경로에 맞게 수정하세요.
import com.nevigo.ai_navigo.dto.UserClickDTO;

@Service
public class PreferenceService_Impl implements IF_preferenceService {

    private final PreferenceDao preferenceDao;  // 실제 DAO 클래스를 주입

    @Autowired
    public PreferenceService_Impl(PreferenceDao preferenceDao) {
        this.preferenceDao = preferenceDao;
    }

    // 사용자 ID로 선호도 정보 가져오기
    @Override
    public String getPreferenceById(String memberId) {
        return preferenceDao.getPreferenceById(memberId);
    }

    @Override
    public void saveOrUpdatePreference(String memberId, String preference) {
        String existingPreference = preferenceDao.getPreferenceById(memberId);
        if (existingPreference != null) {
            preferenceDao.updatePreference(memberId, preference);
        } else {
            preferenceDao.insertPreference(memberId, preference);
        }
        System.out.println("Saving preference for memberId: " + memberId + ", preference: " + preference);
    }

    @Override
    public void clickTravelOne(UserClickDTO userclickdto) throws Exception{
        return;
    };
    @Override
    public String getPopularCat3() throws Exception {
        return null;
    };
}
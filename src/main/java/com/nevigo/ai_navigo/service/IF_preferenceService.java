package com.nevigo.ai_navigo.service;

import com.nevigo.ai_navigo.dto.UserClickDTO;

public interface IF_preferenceService {

    public String getPreferenceById(String memberId) throws Exception;
    public void clickTravelOne(UserClickDTO userclickdto) throws Exception;
    public String getPopularCat3() throws Exception;
    public void saveOrUpdatePreference(String memberId, String preference) throws Exception;
}

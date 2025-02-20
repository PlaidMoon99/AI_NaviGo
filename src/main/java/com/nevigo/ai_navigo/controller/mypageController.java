package com.nevigo.ai_navigo.controller;
import com.nevigo.ai_navigo.dao.IF_changePwDao;
import com.nevigo.ai_navigo.service.ChangePwService;
import com.nevigo.ai_navigo.service.IF_changePwService;
import com.nevigo.ai_navigo.service.PreUpdateService_Impl;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.nevigo.ai_navigo.dto.MemberDTO;
import com.nevigo.ai_navigo.service.IF_preferenceService;

import java.util.Map;

@Controller
@RequestMapping("/mypage")
public class mypageController {

    private final IF_preferenceService preferenceService;
    private final IF_changePwService changePwService;
    private final PreUpdateService_Impl preUpdateService_Impl;

    @Autowired
    public mypageController(IF_changePwService changePwService, IF_preferenceService preferenceService, PreUpdateService_Impl preUpdateService_Impl) {
        this.preferenceService = preferenceService;
        this.changePwService = changePwService;
        this.preUpdateService_Impl = preUpdateService_Impl;

    }

    @Autowired
    HttpSession session;

    // 사용자 ID로 저장된 선호도 가져오기 및 섹션 처리
    @GetMapping
    public String mypage(
            @RequestParam(required = false) String section, // 섹션 값 추가
            Model model,
            HttpSession session
    ) throws Exception {
        // 세션에서 사용자 정보 가져오기
        MemberDTO member = (MemberDTO) session.getAttribute("memberInfo");
        if (member != null) {
            String memberId = member.getMemberId();
            System.out.println("memberId: " + memberId);

            // 선호도 가져오기 (Service를 통해 DB에서 값 가져오기)
            String savedCategory = preferenceService.getPreferenceById(memberId);
            System.out.println("savedCategory: " + savedCategory);

            model.addAttribute("savedCategory", savedCategory != null ? savedCategory : "선택된 카테고리가 없습니다.");
        } else {
            model.addAttribute("savedCategory", "로그인 정보가 없습니다.");
        }

        // section 값 추가
        model.addAttribute("section", section != null ? section : "history"); // 기본값은 "history"

        return "/mypage/mypage"; // mypage.jsp로 이동
    }

    // 여행 preference update
    @PostMapping("/updatePreference")
    @ResponseBody
    public String updatePreference(@RequestBody Map<String, String> preferenceData, HttpSession session) {
        MemberDTO member = (MemberDTO) session.getAttribute("memberInfo");
        if (member != null) {
            String memberId = member.getMemberId();
            String preference = preferenceData.get("selectedCategory");

            // Preference 저장/수정 처리
            try {
                // Preference 저장/수정 처리 - 인스턴스를 사용
                preUpdateService_Impl.saveOrUpdatePreference(memberId, preference);
                return "Preference updated successfully!";
            } catch (Exception e) {
                e.printStackTrace();
                return "Failed to update preference due to an error.";
            }
        }
        return "Failed to update preference. Please log in.";
    }

    // 비밀번호 변경
    @PostMapping("/changePw")
    @ResponseBody
    public String changePw(@RequestParam("currentPw") String currentPw,
                           @RequestParam("newPw") String newPw,
                           @RequestParam("confirmPw") String confirmPw,
                           HttpSession session,
                           Model model) {

        // 세션에서 사용자 정보 가져오기
        String userId = (String) session.getAttribute("userId");
        String sessionPw = (String) session.getAttribute("password"); // 세션에 저장된 비밀번호

        // 새 비밀번호 확인
        if (!newPw.equals(confirmPw)) {
            model.addAttribute("error", "새 비밀번호가 일치하지 않습니다.");
            return "mypage/changePw";
        }

        // 현재 비밀번호 확인
        if (!sessionPw.equals(currentPw)) {
            model.addAttribute("error", "현재 비밀번호가 올바르지 않습니다.");
            return "mypage/changePw";
        }

        try {
            // 비밀번호 변경 처리
            boolean isUpdated = changePwService.updatePassword(userId, currentPw, session);

            if (isUpdated) {
                model.addAttribute("success", "비밀번호가 성공적으로 변경되었습니다.");
                return "mypage/changePw";
            } else {
                model.addAttribute("error", "비밀번호 변경 중 문제가 발생했습니다.");
                return "mypage/changePw";
            }
        } catch (Exception e) {
            model.addAttribute("error", "비밀번호 변경 중 오류가 발생했습니다.");
            return "mypage/changePw";
        }
    }
}

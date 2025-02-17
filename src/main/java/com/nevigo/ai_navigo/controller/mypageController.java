package com.nevigo.ai_navigo.controller;
import com.nevigo.ai_navigo.service.MemberUpdateService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.nevigo.ai_navigo.dto.MemberDTO;
import com.nevigo.ai_navigo.service.IF_preferenceService;
import com.nevigo.ai_navigo.service.PreferenceService_Impl;

import java.util.Map;

@Controller
@RequestMapping("/mypage")
public class mypageController {

    private final MemberUpdateService memberService;
    private final IF_preferenceService preferenceService;
    private final PreferenceService_Impl preferenceService_impl;

    @Autowired
    public mypageController(MemberUpdateService memberService, IF_preferenceService preferenceService, PreferenceService_Impl preferenceService_impl) {
        this.memberService = memberService;
        this.preferenceService = preferenceService;
        this.preferenceService_impl = preferenceService_impl;
    }

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
            preferenceService_impl.saveOrUpdatePreference(memberId, preference);

            return "Preference updated successfully!";
        }
        return "Failed to update preference. Please log in.";
    }

//    @GetMapping("/update")
//    public String update(@RequestParam("memberId") String memberId, Model model) {
//        MemberDTO member = memberService.getMemberById(memberId);  // 서비스 호출
//        model.addAttribute("member", member);
//        return "/updateForm";  // updateForm.jsp로 이동
//    }
//
//    @PostMapping("/update")
//    public String updateMember(@ModelAttribute MemberDTO member, HttpSession session) {
//        String memberId = (String) session.getAttribute("memberId");
//
//        //member.setMemberId(memberId);  // 세션에서 ID를 가져와 설정
//        memberService.updateMember(member);  // 서비스 호출하여 회원 정보 업데이트
//        return "redirect:/mypage/update";  // 업데이트 후 마이페이지로 리다이렉트
//    }


}
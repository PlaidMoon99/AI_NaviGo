package com.nevigo.ai_navigo.controller;
import com.nevigo.ai_navigo.dao.IF_TravelHistoryDao;
import com.nevigo.ai_navigo.dao.IF_changePwDao;
import com.nevigo.ai_navigo.dto.ForeignPlanDTO;
import com.nevigo.ai_navigo.service.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.nevigo.ai_navigo.dto.MemberDTO;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
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

    @Autowired
    private IF_TravelHistoryDao travelHistoryDao;

    // 여행 기록 페이지
    @RequestMapping(value = "/mypage/history", method = RequestMethod.GET)
    public String showHistoryPage(Model model, HttpSession session) {
        // 세션에서 member_id 가져오기
        String memberId = (String) session.getAttribute("member_id");

        if (memberId != null) {
            // memberId로 해당 사용자의 여행 계획 목록을 불러옴
            List<ForeignPlanDTO> planList = travelHistoryDao.getPlansByMemberId(memberId);
            if (planList.isEmpty()) {
                model.addAttribute("message", "여행 계획이 없습니다.");
            } else {
                model.addAttribute("planList", planList);
            }
        } else {
            // 로그인이 안 되어 있으면 로그인 페이지로 리다이렉트
            return "redirect:/login";
        }

        return "redirect:/foreign/plan/{plan_id}"; // JSP 페이지로 반환
    }


    // 상세 여행 계획 보기
    @RequestMapping(value = "/foreign/plan/{plan_id}", method = RequestMethod.GET)
    public String showPlanDetail(@PathVariable("plan_id") int planId, Model model) {
        ForeignPlanDTO planDetail = travelHistoryDao.getPlanDetail(planId);
        model.addAttribute("planDetail", planDetail);
        return "foreign/planDetail";
    }

    // 사용자 ID로 저장된 선호도 가져오기 및 섹션 처리
    @GetMapping
    public String mypage(
            @RequestParam(required = false) String section, // 섹션 값 추가
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) throws Exception {
        // 세션에서 사용자 정보 가져오기
        MemberDTO member = (MemberDTO) session.getAttribute("memberInfo");
        // 로그인이 안 된 경우
        if (member == null) {
            redirectAttributes.addFlashAttribute("loginMessage", "로그인 후 이용 가능합니다.");
            return "redirect:/auth/login"; // 로그인 페이지로 리다이렉트
        } else {
            String memberId = member.getMemberId();
            System.out.println("memberId: " + memberId);

            // 선호도 가져오기 (Service를 통해 DB에서 값 가져오기)
            String savedCategory = preferenceService.getPreferenceById(memberId);
            System.out.println("savedCategory: " + savedCategory);

            model.addAttribute("savedCategory", savedCategory != null ? savedCategory : "선택된 카테고리가 없습니다.");
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


        // 세션에서 회원 정보 가져오기
        MemberDTO memberInfo = (MemberDTO) session.getAttribute("memberInfo");

        // null 체크
        if (memberInfo == null) {
            return "세션이 만료되었습니다. 다시 로그인 해주세요.";
        }

        String memberId = memberInfo.getMemberId();
        String encryptedPw = memberInfo.getMemberPw(); // DB에 저장된 암호화된 비밀번호

        // 현재 비밀번호 확인
        if (!BCrypt.checkpw(currentPw, encryptedPw)) {
            return "현재 비밀번호가 올바르지 않습니다.";
        }

        // 새 비밀번호와 확인 비밀번호가 일치하지 않을 경우
        if (!newPw.equals(confirmPw)) {
            return "새 비밀번호와 확인 비밀번호가 일치하지 않습니다.";
        }

        try {
            // Service 호출하여 비밀번호 변경
            boolean isUpdated = changePwService.updatePassword(memberId, newPw, session);

            if (isUpdated) {
                // 세션 정보 업데이트
                memberInfo.setMemberPw(BCrypt.hashpw(newPw, BCrypt.gensalt()));
                session.setAttribute("memberInfo", memberInfo);

                return "비밀번호가 성공적으로 변경되었습니다.";
            } else {
                return "비밀번호 변경 중 문제가 발생했습니다.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "비밀번호 변경 중 오류가 발생했습니다.";
        }

    }
}
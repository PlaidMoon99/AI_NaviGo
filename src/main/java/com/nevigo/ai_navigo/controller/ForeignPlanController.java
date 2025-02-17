package com.nevigo.ai_navigo.controller;

import com.nevigo.ai_navigo.dto.ForeignPlanDTO;
import com.nevigo.ai_navigo.dto.MemberDTO;
import com.nevigo.ai_navigo.service.IF_ForeignPlanService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequiredArgsConstructor(onConstructor_ = {@Autowired})
@RequestMapping("/foreign")
public class ForeignPlanController {

    private final IF_ForeignPlanService foreignPlanService;

    @Value("${google.foreign.key}")
    private String foreignKey;

    // 생성 페이지 보여주기
    @GetMapping("/create")
    public String showCreateForm(HttpSession session, Model model) {
        if (session.getAttribute("memberInfo") == null) {
            return "redirect:/";
        }
        model.addAttribute("apikey", foreignKey);
        return "foreign/createPlan";
    }

    // 일정 생성 처리
    @PostMapping("/create")
    @ResponseBody
    public Map<String, Object> createPlan(
            @RequestBody ForeignPlanDTO planDTO,
            HttpSession session, Model model) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 세션에서 회원 정보 가져오기
            MemberDTO memberInfo = (MemberDTO) session.getAttribute("memberInfo");
            planDTO.setMemberId(memberInfo.getMemberId());

            // 서비스 호출하여 일정 생성
            int planId = foreignPlanService.createPlan(planDTO);

            response.put("success", true);
            response.put("planId", planId);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        model.addAttribute("apikey", foreignKey);
        return response;
    }

    // 생성된 일정 상세 보기
    @GetMapping("/plan/{planId}")
    public String showPlanDetail(
            @PathVariable Long planId,
            Model model,
            HttpSession session) throws Exception {

        // 로그인 체크
        if (session.getAttribute("memberInfo") == null) {
            return "redirect:/";
        }
        model.addAttribute("apikey", foreignKey);

        // 일정 상세 정보 조회
        Map<String, Object> planDetails = foreignPlanService.getPlanWithFullDetails(planId);
        model.addAttribute("plan", planDetails);
        return "foreign/planDetail";  // planDetail.jsp로 이동
    }
}
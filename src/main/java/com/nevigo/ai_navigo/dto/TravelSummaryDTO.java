package com.nevigo.ai_navigo.dto;


import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.List;

@Getter
@Setter
@ToString
public class TravelSummaryDTO {
    private List<String> mainAttractions;
    private String routeOverview;
}
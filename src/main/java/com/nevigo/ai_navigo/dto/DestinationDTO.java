package com.nevigo.ai_navigo.dto;


import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class DestinationDTO {
    private String name;
    private double lat;
    private double lng;
}

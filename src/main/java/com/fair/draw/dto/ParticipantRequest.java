package com.fair.draw.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.Getter;
import lombok.Setter;

//이벤트 참가 요청 DTO
@Getter
@Setter
public class ParticipantRequest {

    @NotNull(message = "이벤트 ID는 필수입니다.")
    private Long eventId;

    @NotBlank(message = "휴대폰 번호는 필수입니다.")
    @Pattern(regexp = "^01[016789]\\d{7,8}$", message = "올바른 휴대폰 번호 형식이 아닙니다.")
    private String phoneNumber;

    @NotBlank(message = "인증번호는 필수입니다.")
    private String verificationCode;
}
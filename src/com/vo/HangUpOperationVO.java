package com.vo;

import java.io.Serializable;

import com.util.MyUtil;

public class HangUpOperationVO implements Serializable{
	private String idVO;
	private String dailyInfoIDVO;
	private Long operateTimeVO;
	private String operateNotesVO;
	private Boolean hangUpStateVO;
	private String operatorVO;
	private String operatorNickNameVO;
	private Integer operatorAuthorityVO;
	
	private String operatorAuthorityToStringVO;
	private String hangUpStateToStringVO;
	public HangUpOperationVO(){
		super();
	}
	public HangUpOperationVO(String idVO, String dailyInfoIDVO,
			Long operateTimeVO, String operateNotesVO, Boolean hangUpStateVO,
			String operatorVO, String operatorNickNameVO,
			Integer operatorAuthorityVO, String operatorAuthorityToStringVO,
			String hangUpStateToStringVO) {
		super();
		this.idVO = idVO;
		this.dailyInfoIDVO = dailyInfoIDVO;
		this.operateTimeVO = operateTimeVO;
		this.operateNotesVO = operateNotesVO;
		this.hangUpStateVO = hangUpStateVO;
		this.operatorVO = operatorVO;
		this.operatorNickNameVO = operatorNickNameVO;
		this.operatorAuthorityVO = operatorAuthorityVO;
		this.operatorAuthorityToStringVO = operatorAuthorityToStringVO;
		this.hangUpStateToStringVO = hangUpStateToStringVO;
	}
	public HangUpOperationVO(Long operateTime, String operateNotes, 
			Boolean hangUpState, String operator, String operatorNickName, Integer operatorAuthority) {
		super();
		this.operateTimeVO = operateTime;
		this.operateNotesVO = operateNotes;
		this.hangUpStateVO = hangUpState;
		this.operatorVO = operator;
		this.operatorNickNameVO = operatorNickName;
		this.operatorAuthorityVO = operatorAuthority;
	}
	public String getIdVO() {
		return idVO;
	}
	public void setIdVO(String idVO) {
		this.idVO = idVO;
	}
	public String getDailyInfoIDVO() {
		return dailyInfoIDVO;
	}
	public void setDailyInfoIDVO(String dailyInfoIDVO) {
		this.dailyInfoIDVO = dailyInfoIDVO;
	}
	public Long getOperateTimeVO() {
		return operateTimeVO;
	}
	public void setOperateTimeVO(Long operateTimeVO) {
		this.operateTimeVO = operateTimeVO;
	}
	public String getOperateNotesVO() {
		return operateNotesVO;
	}
	public void setOperateNotesVO(String operateNotesVO) {
		this.operateNotesVO = operateNotesVO;
	}
	public Boolean getHangUpStateVO() {
		return hangUpStateVO;
	}
	public void setHangUpStateVO(Boolean hangUpStateVO) {
		this.hangUpStateVO = hangUpStateVO;
	}
	public String getOperatorVO() {
		return operatorVO;
	}
	public void setOperatorVO(String operatorVO) {
		this.operatorVO = operatorVO;
	}
	public String getOperatorNickNameVO() {
		return operatorNickNameVO;
	}
	public void setOperatorNickNameVO(String operatorNickNameVO) {
		this.operatorNickNameVO = operatorNickNameVO;
	}
	public Integer getOperatorAuthorityVO() {
		return operatorAuthorityVO;
	}
	public void setOperatorAuthorityVO(Integer operatorAuthorityVO) {
		this.operatorAuthorityVO = operatorAuthorityVO;
	}
	public String getOperatorAuthorityToStringVO() {
		return MyUtil.AUTHORITY_DES_MAP.get(this.operatorAuthorityVO);
	}
	public void setOperatorAuthorityToStringVO(String operatorAuthorityToStringVO) {
		this.operatorAuthorityToStringVO = operatorAuthorityToStringVO;
	}
	public String getHangUpStateToStringVO() {
		String returnValue = "";
		if(hangUpStateVO != null){
			returnValue = hangUpStateVO ? "挂起":"取消挂起";
		}
		return returnValue;
	}
	public void setHangUpStateToStringVO(String hangUpStateToStringVO) {
		this.hangUpStateToStringVO = hangUpStateToStringVO;
	}
}

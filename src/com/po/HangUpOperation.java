package com.po;

import java.io.Serializable;

public class HangUpOperation implements Serializable{
	private String id;
	private String dailyInfoID;
	private Long operateTime;
	private String operateNotes;
	private Boolean hangUpState;
	private String operator;
	
	private String hangUpStateToString;
	public HangUpOperation(){
		super();
	}
	public HangUpOperation(String id, String dailyInfoID, Long operateTime,
			String operateNotes, boolean hangUpState, String operator) {
		super();
		this.id = id;
		this.dailyInfoID = dailyInfoID;
		this.operateTime = operateTime;
		this.operateNotes = operateNotes;
		this.hangUpState = hangUpState;
		this.operator = operator;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getDailyInfoID() {
		return dailyInfoID;
	}
	public void setDailyInfoID(String dailyInfoID) {
		this.dailyInfoID = dailyInfoID;
	}
	public Long getOperateTime() {
		return operateTime;
	}
	public void setOperateTime(Long operateTime) {
		this.operateTime = operateTime;
	}
	public String getOperateNotes() {
		return operateNotes;
	}
	public void setOperateNotes(String operateNotes) {
		this.operateNotes = operateNotes;
	}
	public Boolean getHangUpState() {
		return hangUpState;
	}
	public void setHangUpState(Boolean hangUpState) {
		this.hangUpState = hangUpState;
	}
	public String getOperator() {
		return operator;
	}
	public void setOperator(String operator) {
		this.operator = operator;
	}
	public String getHangUpStateToString() {
		String returnValue = "";
		if(hangUpState != null){
			returnValue = hangUpState ? "挂起":"取消挂起";
		}
		return returnValue;
	}
	public void setHangUpStateToString(String hangUpStateToString) {
		this.hangUpStateToString = hangUpStateToString;
	}
}

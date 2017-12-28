package com.po;

import java.io.Serializable;

import com.util.MyUtil;

public class SystemLogInfo implements Serializable {
	private String id;
	private Integer infoType;
	private String userInfoId;
	private String infoDetail;
	private Long recordTime;
	
	private String operateUsername;
	private String recordTimeStr;
	private String infoTypeStr;
	
	public SystemLogInfo(){
		
	}
	
	public SystemLogInfo(String id, Integer infoType,
			String infoDetail, Long recordTime, String operateUsername) {
		super();
		this.id = id;
		this.infoType = infoType;
		this.infoDetail = infoDetail;
		this.recordTime = recordTime;
		this.operateUsername = operateUsername;
	}

	public String getOperateUsername() {
		return operateUsername;
	}
	public void setOperateUsername(String operateUsername) {
		this.operateUsername = operateUsername;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getUserInfoId() {
		return userInfoId;
	}
	public void setUserInfoId(String userInfoId) {
		this.userInfoId = userInfoId;
	}
	public Integer getInfoType() {
		return infoType;
	}
	public void setInfoType(Integer infoType) {
		this.infoType = infoType;
	}
	public String getInfoDetail() {
		return infoDetail;
	}
	public void setInfoDetail(String infoDetail) {
		this.infoDetail = infoDetail;
	}
	public Long getRecordTime() {
		return recordTime;
	}
	public void setRecordTime(Long recordTime) {
		this.recordTime = recordTime;
	}
	public String getRecordTimeStr() {
		String returnStr = "";
		if(this.recordTime != null){
			returnStr = MyUtil.formatMillis(this.recordTime);
		}
		return returnStr;
	}
	public String getInfoTypeStr() {
		String returnStr = "";
		if(this.infoType != null){
			if(MyUtil.SYSTEM_LOG_TYPE_LOGIN == this.infoType.intValue()){
				returnStr = "µÇÂ¼";
			}else if(MyUtil.SYSTEM_LOG_TYPE_DELETE_DAILYINFO == this.infoType.intValue()){
				returnStr = "É¾³ý¿óÔË¼ÇÂ¼";
			}else if(MyUtil.SYSTEM_LOG_TYPE_HANGUP == this.infoType.intValue()){
				returnStr = "¹ÒÆð¿óÔË¼ÇÂ¼";
			}
		}
		return returnStr;
	}
}

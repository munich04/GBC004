package com.po;

import java.io.Serializable;
import com.util.MyUtil;

/**
 * ÿ��������ϸ
 */
public class DailyInfo implements Serializable{
	private String id;
	private Long dailyNum;
	private String carIDCardID;
	private String mineName;			//Ʒ��
	private String receiveDept;		//�ջ���λ
	private String departure;			//�����ص�
	private Double grossWeight;	//ë��,���ܻ���CarInfo�м�¼��grossWeight���г���
	private Double tareWeight;		//Ƥ��
	private String operator;				//����Ա
	private String loadingInfo;		//װ��
	private String makingNotes;		//�Ƶ�
	private String notes;					//��ע
	private Long inTime;					//����ʱ��
	private Long outTime;				//���ʱ��
	private Boolean hangUpState;	//����״̬;false����;true������;
	private Integer deleteState;		//����30���Ŀ��˼�¼��Ҫ�����Ϊɾ��
	
	public DailyInfo() {
		super();
	}
	public DailyInfo(String id, Long dailyNum, String carIDCardID,
			String mineName, String receiveDept, String departure,
			Double grossWeight, Double tareWeight, String operator,
			String loadingInfo, String makingNotes, String notes, Long inTime,
			Long outTime, Boolean hangUpState) {
		super();
		this.id = id;
		this.dailyNum = dailyNum;
		this.carIDCardID = carIDCardID;
		this.mineName = mineName;
		this.receiveDept = receiveDept;
		this.departure = departure;
		this.grossWeight = grossWeight;
		this.tareWeight = tareWeight;
		this.operator = operator;
		this.loadingInfo = loadingInfo;
		this.makingNotes = makingNotes;
		this.notes = notes;
		this.inTime = inTime;
		this.outTime = outTime;
		this.hangUpState = hangUpState;
		this.deleteState = MyUtil.DELETE_FALSE;
	}
	public Integer getDeleteState() {
		return deleteState;
	}
	public void setDeleteState(Integer deleteState) {
		this.deleteState = deleteState;
	}
	public Boolean getHangUpState() {
		return hangUpState;
	}
	public void setHangUpState(Boolean hangUpState) {
		this.hangUpState = hangUpState;
	}
	public String getDeparture() {
		return departure;
	}
	public void setDeparture(String departure) {
		this.departure = departure;
	}
	public Long getDailyNum() {
		return dailyNum;
	}
	public void setDailyNum(Long dailyNum) {
		this.dailyNum = dailyNum;
	}
	public String getReceiveDept() {
		return receiveDept;
	}
	public void setReceiveDept(String receiveDept) {
		this.receiveDept = receiveDept;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getCarIDCardID() {
		return carIDCardID;
	}
	public void setCarIDCardID(String carIDCardID) {
		this.carIDCardID = carIDCardID;
	}
	public String getMineName() {
		return mineName;
	}
	public void setMineName(String mineName) {
		this.mineName = mineName;
	}
	public Double getGrossWeight() {
		return grossWeight;
	}
	public void setGrossWeight(Double grossWeight) {
		this.grossWeight = grossWeight;
	}
	public Double getTareWeight() {
		return tareWeight;
	}
	public void setTareWeight(Double tareWeight) {
		this.tareWeight = tareWeight;
	}
	public String getOperator() {
		return operator;
	}
	public void setOperator(String operator) {
		this.operator = operator;
	}
	public String getLoadingInfo() {
		return loadingInfo;
	}
	public void setLoadingInfo(String loadingInfo) {
		this.loadingInfo = loadingInfo;
	}
	public String getMakingNotes() {
		return makingNotes;
	}
	public void setMakingNotes(String makingNotes) {
		this.makingNotes = makingNotes;
	}
	public String getNotes() {
		return notes;
	}
	public void setNotes(String notes) {
		this.notes = notes;
	}
	public Long getInTime() {
		return inTime;
	}
	public void setInTime(Long inTime) {
		this.inTime = inTime;
	}
	public Long getOutTime() {
		return outTime;
	}
	public void setOutTime(Long outTime) {
		this.outTime = outTime;
	}
}

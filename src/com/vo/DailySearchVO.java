package com.vo;

import java.io.Serializable;

import com.util.MyUtil;

public class DailySearchVO implements Serializable{
	private boolean hasFinished = true;	//查询参数,查询列表默认显示已完成的今天的拉矿记录;
	private Long startMillis;				//查询参数,查询的起始时间
	private Long endMillis;					//查询参数,查询的终止时间
	private String startMillisToLocalString;
	private String endMillisToLocalString;
	private String carDept;
	private String carNumber;
	private String carDriver;
	private Double lowerWeight;
	private Double higherWeight;
	private String lowerWeightString;
	private String higherWeightString;
	private Boolean hangUpState;
	public DailySearchVO() {
		super();
	}
	public DailySearchVO(boolean hasFinished, Long startMillis, Long endMillis,
			String startMillisToLocalString, String endMillisToLocalString,
			String carDept, String carNumber, String carDriver,
			Double lowerWeight, Double higherWeight, Boolean hangUpState) {
		super();
		this.hasFinished = hasFinished;
		this.startMillis = startMillis;
		this.endMillis = endMillis;
		this.startMillisToLocalString = startMillisToLocalString;
		this.endMillisToLocalString = endMillisToLocalString;
		this.carDept = carDept;
		this.carNumber = carNumber;
		this.carDriver = carDriver;
		this.lowerWeight = lowerWeight;
		this.higherWeight = higherWeight;
		this.hangUpState = hangUpState;
	}
	public Boolean getHangUpState() {
		return hangUpState;
	}
	public void setHangUpState(Boolean hangUpState) {
		this.hangUpState = hangUpState;
	}
	public String getLowerWeightString() {
		String returnValue = "";
		if(this.lowerWeight != null){
			returnValue = MyUtil.decimalFormat.format(lowerWeight);
		}
		return returnValue;
	}
	public void setLowerWeightString(String lowerWeightString) {
		this.lowerWeightString = lowerWeightString;
	}
	public String getHigherWeightString() {
		String returnValue = "";
		if(this.higherWeight != null){
			returnValue = MyUtil.decimalFormat.format(higherWeight);
		}
		return returnValue;
	}
	public void setHigherWeightString(String higherWeightString) {
		this.higherWeightString = higherWeightString;
	}
	public Double getLowerWeight() {
		return lowerWeight;
	}
	public void setLowerWeight(Double lowerWeight) {
		this.lowerWeight = lowerWeight;
	}
	public Double getHigherWeight() {
		return higherWeight;
	}
	public void setHigherWeight(Double higherWeight) {
		this.higherWeight = higherWeight;
	}
	public String getCarDept() {
		return carDept;
	}
	public void setCarDept(String carDept) {
		this.carDept = carDept;
	}
	public String getCarNumber() {
		return carNumber;
	}
	public void setCarNumber(String carNumber) {
		this.carNumber = carNumber;
	}
	public String getCarDriver() {
		return carDriver;
	}
	public void setCarDriver(String carDriver) {
		this.carDriver = carDriver;
	}
	public String getStartMillisToLocalString() {
		String returnString = "";
		if(this.startMillis != null){
			returnString = MyUtil.formatMillisSecondStyle(this.startMillis);
		}
		return returnString;
	}
	public void setStartMillisToLocalString(String startMillisToLocalString) {
		this.startMillisToLocalString = startMillisToLocalString;
	}
	public String getEndMillisToLocalString() {
		String returnString = "";
		if(this.endMillis != null){
			returnString = MyUtil.formatMillisSecondStyle(this.endMillis);
		}
		return returnString;
	}
	public void setEndMillisToLocalString(String endMillisToLocalString) {
		this.endMillisToLocalString = endMillisToLocalString;
	}
	public boolean isHasFinished() {
		return hasFinished;
	}
	public void setHasFinished(boolean hasFinished) {
		this.hasFinished = hasFinished;
	}
	public Long getStartMillis() {
		return startMillis;
	}
	public void setStartMillis(Long startMillis) {
		this.startMillis = startMillis;
	}
	public Long getEndMillis() {
		return endMillis;
	}
	public void setEndMillis(Long endMillis) {
		this.endMillis = endMillis;
	}
	
}

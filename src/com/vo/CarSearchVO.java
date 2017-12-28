package com.vo;

import com.util.MyUtil;

public class CarSearchVO {
	private String carNumber;
	private String carIDCardID;
	private String carDept;
	private String carDriver;
	private Double carLowerWeight;
	private Double carHigherWeight;
	private String carLowerWeightString;
	private String carHigherWeightString;
	public CarSearchVO() {
		super();
	}
	public CarSearchVO(String carNumber, String carIDCardID, String carDept,
			String carDriver, Double carLowerWeight, Double carHigherWeight) {
		super();
		this.carNumber = carNumber;
		this.carIDCardID = carIDCardID;
		this.carDept = carDept;
		this.carDriver = carDriver;
		this.carLowerWeight = carLowerWeight;
		this.carHigherWeight = carHigherWeight;
	}
	public String getCarNumber() {
		return carNumber;
	}
	public void setCarNumber(String carNumber) {
		this.carNumber = carNumber;
	}
	public String getCarIDCardID() {
		return carIDCardID;
	}
	public void setCarIDCardID(String carIDCardID) {
		this.carIDCardID = carIDCardID;
	}
	public String getCarDept() {
		return carDept;
	}
	public void setCarDept(String carDept) {
		this.carDept = carDept;
	}
	public String getCarDriver() {
		return carDriver;
	}
	public void setCarDriver(String carDriver) {
		this.carDriver = carDriver;
	}
	public Double getCarLowerWeight() {
		return carLowerWeight;
	}
	public void setCarLowerWeight(Double carLowerWeight) {
		this.carLowerWeight = carLowerWeight;
	}
	public Double getCarHigherWeight() {
		return carHigherWeight;
	}
	public void setCarHigherWeight(Double carHigherWeight) {
		this.carHigherWeight = carHigherWeight;
	}
	public String getCarLowerWeightString() {
		String returnValue = "";
		if(this.carLowerWeight != null){
			returnValue = MyUtil.decimalFormat.format(carLowerWeight);
		}
		return returnValue;
	}
	public void setCarLowerWeightString(String carLowerWeightString) {
		this.carLowerWeightString = carLowerWeightString;
	}
	public String getCarHigherWeightString() {
		String returnValue = "";
		if(this.carHigherWeight != null){
			returnValue = MyUtil.decimalFormat.format(carHigherWeight);
		}
		return returnValue;
	}
	public void setCarHigherWeightString(String carHigherWeightString) {
		this.carHigherWeightString = carHigherWeightString;
	}
}

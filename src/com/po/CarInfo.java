package com.po;

import java.io.Serializable;

public class CarInfo implements Serializable{
	private String id;
	private String carIDCardID;
	private String carDept;
	private String carNumber;
	private String carDriver;
	private Double tareWeight;
	private Long recordTime;
	private String carNotes;
	public CarInfo() {
		super();
	}
	public CarInfo(String id, String carIDCardID, String carDept,
			String carNumber, String carDriver, Double tareWeight,
			Long recordTime, String carNotes) {
		super();
		this.id = id;
		this.carIDCardID = carIDCardID;
		this.carDept = carDept;
		this.carNumber = carNumber;
		this.carDriver = carDriver;
		this.tareWeight = tareWeight;
		this.recordTime = recordTime;
		this.carNotes = carNotes;
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
	public Double getTareWeight() {
		return tareWeight;
	}
	public void setTareWeight(Double tareWeight) {
		this.tareWeight = tareWeight;
	}
	public Long getRecordTime() {
		return recordTime;
	}
	public void setRecordTime(Long recordTime) {
		this.recordTime = recordTime;
	}
	public String getCarNotes() {
		return carNotes;
	}
	public void setCarNotes(String carNotes) {
		this.carNotes = carNotes;
	}
}

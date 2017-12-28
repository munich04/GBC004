package com.po;

import java.io.Serializable;

public class PortInfo implements Serializable{
	private String id;
	private Integer port;
	private Long recordTime;
	public PortInfo() {
		super();
	}
	public PortInfo(String id, Integer port, Long recordTime) {
		super();
		this.id = id;
		this.port = port;
		this.recordTime = recordTime;
	}
	public PortInfo(Integer port, Long recordTime) {
		this.port = port;
		this.recordTime = recordTime;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public Integer getPort() {
		return port;
	}
	public void setPort(Integer port) {
		this.port = port;
	}
	public Long getRecordTime() {
		return recordTime;
	}
	public void setRecordTime(Long recordTime) {
		this.recordTime = recordTime;
	}
}

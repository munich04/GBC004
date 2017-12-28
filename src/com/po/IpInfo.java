package com.po;

import java.io.Serializable;

public class IpInfo implements Serializable{
	private String id;
	private String ip;
	private Integer port;
	private Long recordTime;
	public IpInfo() {
		super();
	}
	public IpInfo(String id, String ip, Integer port, Long recordTime) {
		super();
		this.id = id;
		this.ip = ip;
		this.port = port;
		this.recordTime = recordTime;
	}
	public IpInfo(String ip, Integer port, Long recordTime) {
		super();
		this.ip = ip;
		this.port = port;
		this.recordTime = recordTime;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getIp() {
		return ip;
	}
	public void setIp(String ip) {
		this.ip = ip;
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

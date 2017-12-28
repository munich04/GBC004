package com.po;

import java.io.Serializable;

import com.util.MyUtil;

public class MineInfo implements Serializable{
	private String id;
	private String name;
	private String code;
	private Long recordTime;
	private String recordTimeLocaleString;
	public MineInfo() {
		super();
	}
	public MineInfo(String id, String name, String code, Long recordTime) {
		super();
		this.id = id;
		this.name = name;
		this.code = code;
		this.recordTime = recordTime;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public Long getRecordTime() {
		return recordTime;
	}
	public void setRecordTime(Long recordTime) {
		this.recordTime = recordTime;
	}
	public String getRecordTimeLocaleString() {
		return MyUtil.formatMillisSecondStyle(this.recordTime);
	}
	public void setRecordTimeLocaleString(String recordTimeLocaleString) {
		this.recordTimeLocaleString = recordTimeLocaleString;
	}
}

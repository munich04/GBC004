package com.po;

import java.io.Serializable;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import com.util.MyUtil;

public class ExportDateAssistant implements Serializable{
	private String id;
	private Long endTimeOfLastExport;
	private Long recordTime;
	
	private String nextStartTime;
	public ExportDateAssistant(){
	}
	public ExportDateAssistant(String id, Long endTimeOfLastExport, Long recordTime){
		this.id = id;
		this.endTimeOfLastExport = endTimeOfLastExport;
		this.recordTime = recordTime;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public Long getEndTimeOfLastExport() {
		return endTimeOfLastExport;
	}
	public void setEndTimeOfLastExport(Long endTimeOfLastExport) {
		this.endTimeOfLastExport = endTimeOfLastExport;
	}
	public Long getRecordTime() {
		return recordTime;
	}
	public void setRecordTime(Long recordTime) {
		this.recordTime = recordTime;
	}
	public String getNextStartTime() {
		GregorianCalendar gre = new GregorianCalendar();
		gre.setTimeInMillis(endTimeOfLastExport);

		gre.set(Calendar.DAY_OF_MONTH, gre.get(Calendar.DAY_OF_MONTH) + 1);
		gre.set(Calendar.HOUR, 0);
		gre.set(Calendar.MINUTE, 0);

		return MyUtil.formatMillisSecondStyle(gre.getTimeInMillis());
	}
	public void setNextStartTime(String nextStartTime) {
		this.nextStartTime = nextStartTime;
	}
}

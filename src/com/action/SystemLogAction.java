package com.action;

import com.manager.SystemLogManager;
import com.opensymphony.xwork2.ActionContext;
import com.po.SystemLogInfo;

public class SystemLogAction extends BaseAction{
	private SystemLogInfo systemLogInfo = new SystemLogInfo();
	private SystemLogManager systemLogManager;
	
	public SystemLogInfo getSystemLogInfo() {
		return systemLogInfo;
	}
	public void setSystemLogInfo(SystemLogInfo systemLogInfo) {
		this.systemLogInfo = systemLogInfo;
	}
	public SystemLogManager getSystemLogManager() {
		return systemLogManager;
	}
	public void setSystemLogManager(SystemLogManager systemLogManager) {
		this.systemLogManager = systemLogManager;
	}
	
	public String listSystemLog(){
		ActionContext.getContext().put("dataList", systemLogManager.listSystemLog(page, "s.recordTime desc"));
		return SUCCESS;
	}
	
	public String viewSystemLog(){
		setSystemLogInfo(systemLogManager.loadSystemLog(systemLogInfo.getId()));
		return SUCCESS;
	}

	public String deleteSystemLog(){
		systemLogManager.deleteSystemLog(systemLogInfo.getId());
		return SUCCESS;
	}
}

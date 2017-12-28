package com.manager.impl;

import java.util.List;

import com.dao.CarDao;
import com.dao.SystemLogDao;
import com.manager.SystemLogManager;
import com.po.SystemLogInfo;
import com.util.MyUtil;
import com.util.Page;

public class SystemLogManagerImpl implements SystemLogManager{
	private SystemLogDao systemLogDao;
	
	public SystemLogDao getSystemLogDao() {
		return systemLogDao;
	}
	public void setSystemLogDao(SystemLogDao systemLogDao) {
		this.systemLogDao = systemLogDao;
	}
	
	public List<SystemLogInfo> listSystemLog(Page page, String orderBy) {
		return  systemLogDao.listSystemLog(page, orderBy);
	}

	public SystemLogInfo loadSystemLog(String id) {
		SystemLogInfo logInfo = systemLogDao.loadSystemLog(id);
		String userId = logInfo.getUserInfoId();
		if(!MyUtil.amINull(userId)){
			logInfo.setOperateUsername(systemLogDao.loadUsernameByUserId(userId));
		}
		return logInfo;
	}

	public void deleteSystemLog(String id) {
		systemLogDao.deleteSystemLog(id);
	}
	
	public void saveOrUpdateSystemLog(SystemLogInfo systemLog) {
		systemLogDao.saveOrUpdateSystemLog(systemLog);
	}
}

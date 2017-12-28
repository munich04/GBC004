package com.dao;

import java.util.List;

import com.po.SystemLogInfo;
import com.util.Page;

public interface SystemLogDao {

	List<SystemLogInfo> listSystemLog(Page page, String orderBy);

	SystemLogInfo loadSystemLog(String id);

	void deleteSystemLog(String id);

	String loadUsernameByUserId(String userId);

	void saveOrUpdateSystemLog(SystemLogInfo systemLog);

}

package com.manager;

import java.util.List;

import com.po.SystemLogInfo;
import com.util.Page;

public interface SystemLogManager {

	List<SystemLogInfo> listSystemLog(Page page, String orderBy);

	SystemLogInfo loadSystemLog(String id);

	void deleteSystemLog(String id);
	
	void saveOrUpdateSystemLog(SystemLogInfo systemLog);

}

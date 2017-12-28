package com.dao;

import java.util.List;

import com.po.HangUpOperation;
import com.po.SystemLogInfo;
import com.vo.HangUpOperationVO;

public interface HangUpDao {

	void saveOrUpdateHangUp(HangUpOperation hangUpOperation);

	List<HangUpOperationVO> getHangUpOperationsByDailyInfoID(String dailyInfoID);

	void saveOrUpdateSystemLog(SystemLogInfo systemLog);
}

package com.manager;

import java.util.List;

import com.po.HangUpOperation;
import com.vo.HangUpOperationVO;

public interface HangUpManager {

	void saveOrUpdateHangUp(String userId, HangUpOperation hangUpOperation);
	
	void saveHangUpByDWR(String dailyInfoID, String operationNotes, Boolean hangUpState, String operator);

	List<HangUpOperationVO> getHangUpOperationsByDailyInfoID(String dailyInfoID);

	void dealWithExpiredOperation();
	
}

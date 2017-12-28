package com.manager.impl;

import java.util.List;

import com.dao.DailyDao;
import com.dao.HangUpDao;
import com.dao.SystemLogDao;
import com.manager.HangUpManager;
import com.po.DailyInfo;
import com.po.HangUpOperation;
import com.po.SystemLogInfo;
import com.vo.HangUpOperationVO;
import com.util.MyUtil;

public class HangUpManagerImpl implements HangUpManager{
	private HangUpDao hangUpDao;
	private DailyDao dailyDao;
	public HangUpDao getHangUpDao() {
		return hangUpDao;
	}
	public void setHangUpDao(HangUpDao hangUpDao) {
		this.hangUpDao = hangUpDao;
	}
	public DailyDao getDailyDao() {
		return dailyDao;
	}
	public void setDailyDao(DailyDao dailyDao) {
		this.dailyDao = dailyDao;
	}
	public void saveOrUpdateHangUp(String userId, HangUpOperation hangUpOperation) {
		hangUpOperation.setOperateTime(System.currentTimeMillis());
		hangUpDao.saveOrUpdateHangUp(hangUpOperation);
		
		String dailyInfoId = hangUpOperation.getDailyInfoID();
		DailyInfo dailyInfo = dailyDao.loadDailyInfo(dailyInfoId);
		dailyInfo.setHangUpState(hangUpOperation.getHangUpState());
		dailyDao.saveOrUpdateDaily(dailyInfo);
		
		generateHangUpSystemLog(userId, dailyInfo, true);
	}
	
	public void generateHangUpSystemLog(String userId, DailyInfo dailyInfo, boolean hangUpOrCancel){
		SystemLogInfo systemLog = new SystemLogInfo();
		
		systemLog.setUserInfoId(userId);
		systemLog.setRecordTime(System.currentTimeMillis());
		systemLog.setInfoType(MyUtil.SYSTEM_LOG_TYPE_HANGUP);
		
		if(dailyInfo != null){
			String dailyInfoId = dailyInfo.getId();
			String date = MyUtil.sdfSecondStyle.format(dailyInfo.getInTime());
			String dailyNum = String.valueOf(dailyInfo.getDailyNum());
			
			String detail = hangUpOrCancel ? "挂起" : "取消挂起";
			systemLog.setInfoDetail("对 " + date + " 日编号为 " + dailyNum + " 的矿运记录执行了 " + detail + " 操作!\n(实体ID:\n" + dailyInfoId + ")");
		}
		
		hangUpDao.saveOrUpdateSystemLog(systemLog);
	}
	
	//保存挂起或取消挂起操作
	public void saveHangUpByDWR(String dailyInfoID, String operateNotes, Boolean hangUpState, String operator) {
		HangUpOperation hangUpOperation = new HangUpOperation();
		
		hangUpOperation.setDailyInfoID(dailyInfoID);
		hangUpOperation.setOperateNotes(operateNotes);
		hangUpOperation.setHangUpState(hangUpState);
		Long curMillis = System.currentTimeMillis();
		hangUpOperation.setOperateTime(curMillis);
		hangUpOperation.setOperator(operator);
		
		hangUpDao.saveOrUpdateHangUp(hangUpOperation);
		
		DailyInfo dailyInfo = dailyDao.loadDailyInfo(hangUpOperation.getDailyInfoID());
		dailyInfo.setHangUpState(hangUpOperation.getHangUpState());//更改DailyInfo的状态
		//如果是取消挂起,那么要同时更改DailyInfo的出矿时间;
		if(hangUpState != null && !hangUpState){
			dailyInfo.setOutTime(curMillis);
		}
		dailyDao.saveOrUpdateDaily(dailyInfo);
		
		generateHangUpSystemLog(operator, dailyInfo, hangUpState);
	}
	
	//获取某一DailyInfo的所有挂起和取消挂起操作的记录
	public List<HangUpOperationVO> getHangUpOperationsByDailyInfoID(String dailyInfoID) {
		return hangUpDao.getHangUpOperationsByDailyInfoID(dailyInfoID);
	}
	
	//挂起操作超过30天的矿运记录不再显示
	public void dealWithExpiredOperation() {
		List<DailyInfo> dailyList = dailyDao.listHangUpDailyInfo();
		if(dailyList != null && dailyList.size() > 0){
			for (DailyInfo dailyInfo : dailyList) {
				if(checkIfExpired(dailyInfo.getId())){
					dailyInfo.setDeleteState(MyUtil.DELETE_TRUE);
					dailyDao.deleteDailyInfoToRecycledBin(dailyInfo);
				}
			}
		}
	}
	
	private boolean checkIfExpired(String dailyInfoId) {
		boolean bExpired = false;
		List<HangUpOperationVO> operationList = hangUpDao.getHangUpOperationsByDailyInfoID(dailyInfoId);
		if(operationList != null && operationList.size() > 0){
			HangUpOperationVO operation = operationList.get(0);
			if(operation.getHangUpStateVO() && operation.getOperateTimeVO() <= System.currentTimeMillis() - MyUtil.HANGUP_EXPIRED_MILLIS){
				bExpired = true;
			}
		}
		return bExpired;
	}
}

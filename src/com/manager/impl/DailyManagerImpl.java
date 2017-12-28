package com.manager.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import com.dao.DailyDao;
import com.manager.DailyManager;
import com.po.DailyInfo;
import com.po.ExportDateAssistant;
import com.po.SystemLogInfo;
import com.util.ExportToExcel;
import com.util.MyUtil;
import com.util.Page;
import com.util.test.ExportToTxt;
import com.vo.DailyLoadInfoVO;
import com.vo.DailySearchVO;

public class DailyManagerImpl implements DailyManager{
	DailyDao dailyDao;
	
	public DailyDao getDailyDao() {
		return dailyDao;
	}
	public void setDailyDao(DailyDao dailyDao) {
		this.dailyDao = dailyDao;
	}
	
	public List<DailyLoadInfoVO> listDaily(Page page, String orderBy, DailySearchVO dailySearchVO) {
		return dailyDao.listDaily(page, orderBy, dailySearchVO);
	}

	public DailyInfo loadDailyInfo(String id) {
		return dailyDao.loadDailyInfo(id);
	}

	public void saveOrUpdateDaily(DailyInfo dailyInfo) {
		dailyInfo.setInTime(System.currentTimeMillis());
		dailyInfo.setDeleteState(MyUtil.DELETE_FALSE);
		dailyDao.saveOrUpdateDaily(dailyInfo);
	}
	/**
	 * �жϿ���Ҫ����,�������
	 * ���������һ��û�м�¼outTime,�����ó������˽���Ǽ�,����δ�����Ǽ�,��Ϊ�ó������;
	 * 
	 * ��û�������������������,Ҳ�Ǽ���;������ʱ����,��������,Ҫ�������?�������÷���Ӧ�������޸�;
	 */
	public String checkIfTheCarHasnotLeave(String carIDCardID) {
		List<DailyInfo> dailyInfoList = dailyDao.getUnLeftDailyInfoByCarIDCardID(carIDCardID);
		return (dailyInfoList!=null&&dailyInfoList.size()>0) ?  MyUtil.CAR_OUT : MyUtil.CAR_IN;
	}
	
	/**
	 * ����ʱ,�����ձ��;
	 */
	public String calculateDailyNum() {
		Long count = dailyDao.calculateDailyNum();
		return String.valueOf((count.intValue() + 1));
	}
	
	/**
	 * �����ʱ,��ȡ�Ѿ��洢�����ݿ��еĽ����¼ʵ��
	 */
	public DailyInfo loadEnteredDailyInfoByCarIDCardID(String carIDCardID) {
		DailyInfo returnDailyInfo = new DailyInfo();
		
		List<DailyInfo> dailyInfoList = dailyDao.getUnLeftDailyInfoByCarIDCardID(carIDCardID);
		
		if(dailyInfoList!=null && dailyInfoList.size()>0){
			returnDailyInfo = dailyInfoList.get(0);
		}
		
		return returnDailyInfo;
	}
	
	//�õ�����ɻ�Ϊ��ɵĿ��˼�¼����ϸ��Ϣ
	public DailyLoadInfoVO loadDailyLoadInfoVOByID(String idVO, boolean hasFinished) {
		DailyLoadInfoVO returnDailyLoadInfo = new DailyLoadInfoVO();
		
		List<DailyLoadInfoVO> dailyLoadInfoList = dailyDao.loadDailyLoadInfoVOByID(idVO, hasFinished);
		
		if(dailyLoadInfoList!=null && dailyLoadInfoList.size()>0){
			returnDailyLoadInfo = dailyLoadInfoList.get(0);
		}
		
		return returnDailyLoadInfo;
	}
	
	//�õ�ָ��ʱ�������ɵĻ�δ��ɵĿ��˵Ĵ���
	public Long countDailyInfoDuringSpecifidPeroid(Long startMillis, Long endMillis, boolean hasFinished) {
		if(startMillis == null && endMillis == null){
			startMillis = MyUtil.getTodayStartMillis();
		}
		Long tmp = dailyDao.countDailyInfoDuringSpecifidPeroid(startMillis, endMillis, hasFinished);
		return tmp == null ? 0 : tmp;
	}
	
	//�õ�ָ��ʱ��������۳��ĸ��ֿ��������
	public List countWeightOfMineTransferedDuringSpecifidPeroid(Long startMillis, Long endMillis) {
		if(startMillis == null && endMillis == null){
			startMillis = MyUtil.getTodayStartMillis();
		}
		List list = dailyDao.countWeightOfMineTransferedDuringSpecifidPeroid(startMillis, endMillis);
		return list;
	}
	
	public String[] exportDailyInfo(String absoluteFilePath, DailySearchVO dailySearchVO) {
		if(dailySearchVO.getEndMillis() != null){
			ExportDateAssistant exportDateAssistant = new ExportDateAssistant();
			exportDateAssistant.setEndTimeOfLastExport(dailySearchVO.getEndMillis());
			exportDateAssistant.setRecordTime(System.currentTimeMillis());
			dailyDao.saveOrUpdateExportDateAssistant(exportDateAssistant);
		}
		String fileName = absoluteFilePath + File.separator + MyUtil.EXPORT_EXCEL_FILENAME_PREFIX + MyUtil.formatMillisSecondStyle(dailySearchVO.getStartMillis()) + "_" + MyUtil.formatMillisSecondStyle(dailySearchVO.getEndMillis()) + ".xls";
		return ExportToExcel.exportToExcel(fileName, MyUtil.EXCEL_TITLES, dailyDao.listDaily(null, "daily.dailyNum asc", dailySearchVO));
	}
	
	//�ж�����������, ���Ƕ��ι���;
	//��������,���ؿ�; ���ι���,���ؿ���DailyInfo��ID;
	public String goOutNormallyOrWeightAgain(String carIDCardID){
		String returnValue = "";
		List<DailyInfo> dailyList = dailyDao.getFinishedDailyInfoByCarIDCardID(carIDCardID);
		DailyInfo dailyInfo = null;
		if(dailyList != null && dailyList.size() > 0){
			dailyInfo = dailyList.get(0);
			//ͬһ��������������ˢ����ʱ�����2Сʱ,�϶����ڽ���"���ι���"����;
			returnValue = System.currentTimeMillis() - dailyInfo.getOutTime() < MyUtil.SECOND_WEIGHT_TIME_LIMITED ? dailyInfo.getId() : "";
		}
		return returnValue;
	}
	
	public ExportDateAssistant getLastExportDate(){
		ExportDateAssistant exportDateAssistant = null;
		List<ExportDateAssistant> list = dailyDao.getLastExportDate();
		if(list != null && list.size() > 0){
			exportDateAssistant = list.get(0);
		}
		return exportDateAssistant;
	}
	public String[] exportDailyInfoToTxt(String absoluteFilePath, DailySearchVO dailySearchVO) {
		if(dailySearchVO.getEndMillis() != null){
			ExportDateAssistant exportDateAssistant = new ExportDateAssistant();
			exportDateAssistant.setEndTimeOfLastExport(dailySearchVO.getEndMillis());
			exportDateAssistant.setRecordTime(System.currentTimeMillis());
			dailyDao.saveOrUpdateExportDateAssistant(exportDateAssistant);
		}
		String fileName = absoluteFilePath + File.separator + MyUtil.EXPORT_EXCEL_FILENAME_PREFIX + MyUtil.formatMillisSecondStyle(dailySearchVO.getStartMillis()) + "_" + MyUtil.formatMillisSecondStyle(dailySearchVO.getEndMillis()) + ".txt";
		return ExportToTxt.exportToExcel(fileName, MyUtil.EXCEL_TITLES, dailyDao.listDaily(null, "daily.dailyNum asc", dailySearchVO));
	}
	public List<String> listExcelOrTxtFiles(String downloadType, String absoluteFilePath, Page page) {
		List<String> fileNameList = new ArrayList<String>();
		
		String dirPath = null;
		if(MyUtil.amINull(downloadType) || MyUtil.DOWNLOAD_TYPE_EXCEL.equals(downloadType)){
			downloadType = MyUtil.DOWNLOAD_TYPE_EXCEL;
			dirPath = absoluteFilePath + "excels";
		}else{
			dirPath = absoluteFilePath + "txts";
		}
		File dir = new File(dirPath);
		if(dir.exists()){
			File[] files = dir.listFiles();
			
			if(files != null && files.length > 0){
				int len = files.length;
				
				if(page != null){
					
					page.setDataSum(len);
					
					for (int i = page.getFirstData() - 1; i < page.getLastData(); i++) {
						fileNameList.add(files[i].getName());
					}
					
				}	
			}else{
				if(page != null){
					page.setDataSum(0);
				}
			}
		}
		
		return fileNameList;
	}
	
	public void deleteDaily(String userId, String entryID) {
		DailyInfo dailyInfo = dailyDao.loadDailyInfo(entryID);
		dailyInfo.setDeleteState(MyUtil.DELETE_TRUE);
		dailyDao.deleteDailyInfoToRecycledBin(dailyInfo);
		
		this.generateDeleteDailySystemLog(userId, dailyInfo);
	}
	
	private void generateDeleteDailySystemLog(String userId, DailyInfo dailyInfo){
		SystemLogInfo systemLog = new SystemLogInfo();
		
		systemLog.setUserInfoId(userId);
		systemLog.setRecordTime(System.currentTimeMillis());
		systemLog.setInfoType(MyUtil.SYSTEM_LOG_TYPE_DELETE_DAILYINFO);
		
		if(dailyInfo != null){
			String dailyInfoId = dailyInfo.getId();
			String date = MyUtil.sdfSecondStyle.format(dailyInfo.getInTime());
			String dailyNum = String.valueOf(dailyInfo.getDailyNum());
			systemLog.setInfoDetail("�� " + date + " �ձ��Ϊ " + dailyNum + " �Ŀ��˼�¼ִ���� ɾ�� ����!\n(ʵ��ID:\n" + dailyInfoId + ")");
			
		}
		
		dailyDao.saveOrUpdateSystemLog(systemLog);
	}
}

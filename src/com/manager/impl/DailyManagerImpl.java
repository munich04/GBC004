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
	 * 判断矿车是要进矿,还是离矿
	 * 如果其中有一条没有记录outTime,表明该车已做了进矿登记,但还未做离矿登记,认为该车是离矿;
	 * 
	 * 有没有这种情况：车进矿了,也登记了;但是临时有事,放弃拉矿,要马上离矿?如果是则该方法应该做出修改;
	 */
	public String checkIfTheCarHasnotLeave(String carIDCardID) {
		List<DailyInfo> dailyInfoList = dailyDao.getUnLeftDailyInfoByCarIDCardID(carIDCardID);
		return (dailyInfoList!=null&&dailyInfoList.size()>0) ?  MyUtil.CAR_OUT : MyUtil.CAR_IN;
	}
	
	/**
	 * 进矿时,计算日编号;
	 */
	public String calculateDailyNum() {
		Long count = dailyDao.calculateDailyNum();
		return String.valueOf((count.intValue() + 1));
	}
	
	/**
	 * 矿车离矿时,获取已经存储在数据库中的进矿记录实体
	 */
	public DailyInfo loadEnteredDailyInfoByCarIDCardID(String carIDCardID) {
		DailyInfo returnDailyInfo = new DailyInfo();
		
		List<DailyInfo> dailyInfoList = dailyDao.getUnLeftDailyInfoByCarIDCardID(carIDCardID);
		
		if(dailyInfoList!=null && dailyInfoList.size()>0){
			returnDailyInfo = dailyInfoList.get(0);
		}
		
		return returnDailyInfo;
	}
	
	//得到已完成或为完成的矿运记录的详细信息
	public DailyLoadInfoVO loadDailyLoadInfoVOByID(String idVO, boolean hasFinished) {
		DailyLoadInfoVO returnDailyLoadInfo = new DailyLoadInfoVO();
		
		List<DailyLoadInfoVO> dailyLoadInfoList = dailyDao.loadDailyLoadInfoVOByID(idVO, hasFinished);
		
		if(dailyLoadInfoList!=null && dailyLoadInfoList.size()>0){
			returnDailyLoadInfo = dailyLoadInfoList.get(0);
		}
		
		return returnDailyLoadInfo;
	}
	
	//得到指定时间段内完成的或未完成的矿运的次数
	public Long countDailyInfoDuringSpecifidPeroid(Long startMillis, Long endMillis, boolean hasFinished) {
		if(startMillis == null && endMillis == null){
			startMillis = MyUtil.getTodayStartMillis();
		}
		Long tmp = dailyDao.countDailyInfoDuringSpecifidPeroid(startMillis, endMillis, hasFinished);
		return tmp == null ? 0 : tmp;
	}
	
	//得到指定时间段内所售出的各种矿物的重量
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
	
	//判断是正常出矿, 还是二次过磅;
	//正常出矿,返回空; 二次过磅,返回矿运DailyInfo的ID;
	public String goOutNormallyOrWeightAgain(String carIDCardID){
		String returnValue = "";
		List<DailyInfo> dailyList = dailyDao.getFinishedDailyInfoByCarIDCardID(carIDCardID);
		DailyInfo dailyInfo = null;
		if(dailyList != null && dailyList.size() > 0){
			dailyInfo = dailyList.get(0);
			//同一辆货车接连两次刷卡的时间短于2小时,认定是在进行"二次过磅"操作;
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
			systemLog.setInfoDetail("对 " + date + " 日编号为 " + dailyNum + " 的矿运记录执行了 删除 操作!\n(实体ID:\n" + dailyInfoId + ")");
			
		}
		
		dailyDao.saveOrUpdateSystemLog(systemLog);
	}
}

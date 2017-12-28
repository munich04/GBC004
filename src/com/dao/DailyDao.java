package com.dao;

import java.util.List;

import com.po.DailyInfo;
import com.po.ExportDateAssistant;
import com.po.SystemLogInfo;
import com.util.Page;
import com.vo.DailyLoadInfoVO;
import com.vo.DailySearchVO;

public interface DailyDao {
	public int count(Class clazz);
	public List<DailyLoadInfoVO> listDaily(Page page, String orderBy, DailySearchVO dailySearchVO);
	public void saveOrUpdateDaily(DailyInfo DailyInfo);
	public DailyInfo loadDailyInfo(String id);
	//得到"今天的","ID卡号为carIDCardID的"卡车的"未出矿"记录;
	public List<DailyInfo> getUnLeftDailyInfoByCarIDCardID(String carIDCardID);
	//得到"今天的","ID卡号为carIDCardID的"卡车的"已出矿"记录;
	public List<DailyInfo> getFinishedDailyInfoByCarIDCardID(String carIDCardID);
	//计算今天的拉矿日编号
	public Long calculateDailyNum();
	public List<DailyLoadInfoVO> loadDailyLoadInfoVOByID(String idVO, boolean hasFinished);
	public Long countDailyInfoDuringSpecifidPeroid(Long startMillis, Long endMillis, boolean hasFinished);
	public List countWeightOfMineTransferedDuringSpecifidPeroid(Long startMillis, Long endMillis);
	public void saveOrUpdateExportDateAssistant(ExportDateAssistant exportDateAssistant);
	//获取上一次导出数据的截止日期
	public List<ExportDateAssistant> getLastExportDate();
	public List<DailyInfo> listHangUpDailyInfo();
	public void deleteDailyInfoToRecycledBin(DailyInfo dailyInfo);
	public void saveOrUpdateSystemLog(SystemLogInfo systemLog);
}

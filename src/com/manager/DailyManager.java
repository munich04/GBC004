package com.manager;

import java.util.List;

import com.po.DailyInfo;
import com.util.Page;
import com.vo.DailyLoadInfoVO;
import com.vo.DailySearchVO;

public interface DailyManager {

	public void saveOrUpdateDaily(DailyInfo dailyInfo);
	
	public List<DailyLoadInfoVO> listDaily(Page page, String orderBy, DailySearchVO dailySearchVO);

	public DailyInfo loadDailyInfo(String id);
	
	/**
	 * 刷卡后,查询判断本车这次(今天)是要进矿还是离矿;
	 * @param carIDCardID 矿车的ID卡号
	 * @return 'in',卡车要进矿;'out',卡车要离矿
	 */
	public String checkIfTheCarHasnotLeave(String carIDCardID);
	
	public String calculateDailyNum();
	
	//卡车离矿时,通过carIDCardID查询进矿时已填写过的数据,如：进矿时间,进矿时称得的毛重,日编号等
	//存在同样的问题,无法通过"IDCardID","今天","进入时间不为空","离开时间为空"直接通过sql获得精确的DailyInfo数据;
	//关键在于：无法使用SQL判断"离开时间为空"
	public DailyInfo loadEnteredDailyInfoByCarIDCardID(String carIDCardID);

	//从列表页面单击来修改矿运数据;
	//需要联合查表：DailyInfo和CarInfo,这也是VO类DailyLoadInfoVO诞生的原因
	//注意：需要传入参数hasFinished,以指示要查询的是已完成还是为完成的矿运数据;
	public DailyLoadInfoVO loadDailyLoadInfoVOByID(String idVO, boolean hasFinished);

	//查询某时间段内已完成(true)或未完成(false)的矿运次数
	public Long countDailyInfoDuringSpecifidPeroid(Long startMillis, Long endMillis, boolean hasFinished);

	//查询某时间段内未运送的矿物的吨数
	public List countWeightOfMineTransferedDuringSpecifidPeroid(Long startMillis, Long endMillis);

	public String[] exportDailyInfo(String absoluteFilePath, DailySearchVO dailySearchVO);
	
	//2011-7-10实验
	public String[] exportDailyInfoToTxt(String absoluteFilePath, DailySearchVO dailySearchVO);

	public List<String> listExcelOrTxtFiles(String downloadType, String absoluteFilePath, Page page);

	public void deleteDaily(String userId, String entryID);
}	

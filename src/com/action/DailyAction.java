package com.action;

import java.util.List;

import org.apache.struts2.ServletActionContext;

import com.manager.DailyManager;
import com.opensymphony.xwork2.ActionContext;
import com.po.DailyInfo;
import com.po.UserInfo;
import com.util.MyUtil;
import com.vo.DailyLoadInfoVO;
import com.vo.DailySearchVO;

public class DailyAction extends BaseAction{
//	public static Logger logger = Logger.getLogger(DailyAction.class);
	
	private DailyManager dailyManager;
	
	private DailyInfo dailyInfo = new DailyInfo();
	
	private DailyLoadInfoVO dailyLoadInfoVO = new DailyLoadInfoVO();
	
	private DailySearchVO dailySearchVO = new DailySearchVO();
	
	private String downloadType = MyUtil.DOWNLOAD_TYPE_EXCEL;
	
	public String getDownloadType() {
		return downloadType;
	}
	public void setDownloadType(String downloadType) {
		this.downloadType = downloadType;
	}	
	public DailyManager getDailyManager() {
		return dailyManager;
	}
	public void setDailyManager(DailyManager dailyManager) {
		this.dailyManager = dailyManager;
	}
	public DailyInfo getDailyInfo() {
		return dailyInfo;
	}
	public void setDailyInfo(DailyInfo dailyInfo) {
		this.dailyInfo = dailyInfo;
	}
	public DailyLoadInfoVO getDailyLoadInfoVO() {
		return dailyLoadInfoVO;
	}
	public void setDailyLoadInfoVO(DailyLoadInfoVO dailyLoadInfoVO) {
		this.dailyLoadInfoVO = dailyLoadInfoVO;
	}
	public DailySearchVO getDailySearchVO() {
		return dailySearchVO;
	}
	public void setDailySearchVO(DailySearchVO dailySearchVO) {
		this.dailySearchVO = dailySearchVO;
	}
	
	public String searchDaily(){
		//如果起止时间都没有选择,那么默认查询"当天的"记录;
		if(dailySearchVO.getEndMillis() == null && dailySearchVO.getStartMillis() == null){
			dailySearchVO.setStartMillis(MyUtil.getTodayStartMillis());
		}
		//默认查询未挂起的记录
		if(dailySearchVO.isHasFinished() && dailySearchVO.getHangUpState() == null){
			dailySearchVO.setHangUpState(false);
		}
		
		List<DailyLoadInfoVO> list = dailyManager.listDaily(page, null, dailySearchVO);
		
		ActionContext.getContext().put("listHistory", list);
		return SUCCESS;
	}
	
	public String saveOrUpdateDaily(){
		System.out.println(dailyInfo.getDeleteState());
		dailyManager.saveOrUpdateDaily(dailyInfo);
		return SUCCESS;
	}

	public String addDaily(){
		return SUCCESS;
	}

	public String viewDaily(){
		return SUCCESS;
	}
	
	public String deleteDaily(){
		UserInfo loginUser = (UserInfo) getSession().getAttribute("userInfo");
		this.getDailyManager().deleteDaily(loginUser == null ? "" : loginUser.getId(), dailyLoadInfoVO.getIdVO());
		return SUCCESS;
	}
	
	public String exportDaily(){
		String absoluteFilePath = ServletActionContext.getServletContext().getRealPath("/") + "excels";
		String exportInfo[] = dailyManager.exportDailyInfo(absoluteFilePath, dailySearchVO);
		ActionContext.getContext().put("exportInfoFilePath", exportInfo[0]);
		ActionContext.getContext().put("exportInfoErrorInfo", exportInfo[1]);
		return SUCCESS;
	}
	
	public String listAndDownloadExcel(){
		String absoluteFilePath = ServletActionContext.getServletContext().getRealPath("/");
		ActionContext.getContext().put("dataList", dailyManager.listExcelOrTxtFiles(downloadType, absoluteFilePath, page));
		return SUCCESS;
	}
	
	//2011-7-10实验导出txt
	public String exportDailyToTxt(){
		String absoluteFilePath = ServletActionContext.getServletContext().getRealPath("/") + "txts";
		String exportInfo[] = dailyManager.exportDailyInfoToTxt(absoluteFilePath, dailySearchVO);
		ActionContext.getContext().put("exportInfoFilePath", exportInfo[0]);
		ActionContext.getContext().put("exportInfoErrorInfo", exportInfo[1]);
		return SUCCESS;
	}
}

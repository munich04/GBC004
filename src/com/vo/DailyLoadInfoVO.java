package com.vo;

import java.io.Serializable;
import java.util.Calendar;

import com.util.MyUtil;

public class DailyLoadInfoVO implements Serializable{
	private String idVO;
	private Long dailyNumVO;
	private String carIDCardIDVO;
	private String mineCodeVO;		//code
	private String mineNameVO;		//品名Name
	private String receiveDeptVO;		//收货单位
	private Double grossWeightVO;		//毛重,可能会与CarInfo中记录的grossWeight略有出入
	private Double tareWeightVO;		//皮重
	private String operatorVO;		//过磅员
	private String loadingInfoVO;		//装车
	private String makingNotesVO;		//制单
	private String notesVO;			//备注
	private Long inTimeVO;			//进矿时间
	private Long outTimeVO;			//离矿时间
	private Boolean hangUpStateVO;	//挂起状态;false正常;true被挂起;
	private String carDeptVO;
	private String carNumberVO;
	private String carDriverVO;
	private String departureVO;
	private String inTimeVOToLocalString;
	private String yearOfInTime;
	private String monthOfInTime;
	private String dateOfInTime;
	private String netWeightVO;
	private String outTimeVOToLocalString;
	private String outTimeVOToLocalStringSecStyle;
	private String hangUpStateVOToString;
	public DailyLoadInfoVO() {
		super();
	}
	public DailyLoadInfoVO(String idVO, Long dailyNumVO,
			String carIDCardIDVO, String mineCodeVO,String receiveDeptVO, String depatureVO,
			Double grossWeightVO, Double tareWeightVO, String operatorVO,
			String loadingInfoVO, String makingNotesVO, String notesVO,
			Long inTimeVO, Long outTimeVO, String carDeptVO,
			String carNumberVO, String carDriverVO, Boolean hangUpStateVO) {
		super();
		this.idVO = idVO;
		this.dailyNumVO = dailyNumVO;
		this.carIDCardIDVO = carIDCardIDVO;
		this.mineCodeVO = mineCodeVO;
		this.receiveDeptVO = receiveDeptVO;
		this.departureVO = depatureVO;
		this.grossWeightVO = grossWeightVO;
		this.tareWeightVO = tareWeightVO;
		this.operatorVO = operatorVO;
		this.loadingInfoVO = loadingInfoVO;
		this.makingNotesVO = makingNotesVO;
		this.notesVO = notesVO;
		this.inTimeVO = inTimeVO;
		this.outTimeVO = outTimeVO;
		this.carDeptVO = carDeptVO;
		this.carNumberVO = carNumberVO;
		this.carDriverVO = carDriverVO;
		this.hangUpStateVO = hangUpStateVO;
	}
	public DailyLoadInfoVO(String idVO, Long dailyNumVO,
			String carIDCardIDVO, String mineCodeVO, String mineNameVO, String receiveDeptVO, String depatureVO,
			Double grossWeightVO, Double tareWeightVO, String operatorVO,
			String loadingInfoVO, String makingNotesVO, String notesVO,
			Long inTimeVO, Long outTimeVO, String carDeptVO,
			String carNumberVO, String carDriverVO, Boolean hangUpStateVO) {
		super();
		this.idVO = idVO;
		this.dailyNumVO = dailyNumVO;
		this.carIDCardIDVO = carIDCardIDVO;
		this.mineCodeVO = mineCodeVO;
		this.mineNameVO = mineNameVO;
		this.receiveDeptVO = receiveDeptVO;
		this.departureVO = depatureVO;
		this.grossWeightVO = grossWeightVO;
		this.tareWeightVO = tareWeightVO;
		this.operatorVO = operatorVO;
		this.loadingInfoVO = loadingInfoVO;
		this.makingNotesVO = makingNotesVO;
		this.notesVO = notesVO;
		this.inTimeVO = inTimeVO;
		this.outTimeVO = outTimeVO;
		this.carDeptVO = carDeptVO;
		this.carNumberVO = carNumberVO;
		this.carDriverVO = carDriverVO;
		this.hangUpStateVO = hangUpStateVO;
	}
	public DailyLoadInfoVO(String idVO, Long dailyNumVO,
			String carIDCardIDVO, String receiveDeptVO, String departureVO,
			Double grossWeightVO, Double tareWeightVO,
			Long inTimeVO, String carDeptVO,
			String carNumberVO, String carDriverVO, Boolean hangUpStateVO) {
		super();
		this.idVO = idVO;
		this.dailyNumVO = dailyNumVO;
		this.carIDCardIDVO = carIDCardIDVO;
		this.receiveDeptVO = receiveDeptVO;
		this.departureVO = departureVO;
		this.grossWeightVO = grossWeightVO;
		this.tareWeightVO = tareWeightVO;
		this.inTimeVO = inTimeVO;
		this.carDeptVO = carDeptVO;
		this.carNumberVO = carNumberVO;
		this.carDriverVO = carDriverVO;
		this.hangUpStateVO = hangUpStateVO;
	}
	public Boolean getHangUpStateVO() {
		return hangUpStateVO;
	}
	public void setHangUpStateVO(Boolean hangUpStateVO) {
		this.hangUpStateVO = hangUpStateVO;
	}
	public String getIdVO() {
		return idVO;
	}
	public void setIdVO(String idVO) {
		this.idVO = idVO;
	}
	public Long getDailyNumVO() {
		return dailyNumVO;
	}
	public void setDailyNumVO(Long dailyNumVO) {
		this.dailyNumVO = dailyNumVO;
	}
	public String getCarIDCardIDVO() {
		return carIDCardIDVO;
	}
	public void setCarIDCardIDVO(String carIDCardIDVO) {
		this.carIDCardIDVO = carIDCardIDVO;
	}
	public String getMineNameVO() {
		return mineNameVO;
	}
	public void setMineNameVO(String mineNameVO) {
		this.mineNameVO = mineNameVO;
	}
	public String getReceiveDeptVO() {
		return receiveDeptVO;
	}
	public void setReceiveDeptVO(String receiveDeptVO) {
		this.receiveDeptVO = receiveDeptVO;
	}
	public Double getGrossWeightVO() {
		return grossWeightVO;
	}
	public void setGrossWeightVO(Double grossWeightVO) {
		this.grossWeightVO = grossWeightVO;
	}
	public Double getTareWeightVO() {
		return tareWeightVO;
	}
	public void setTareWeightVO(Double tareWeightVO) {
		this.tareWeightVO = tareWeightVO;
	}
	public String getOperatorVO() {
		return operatorVO;
	}
	public void setOperatorVO(String operatorVO) {
		this.operatorVO = operatorVO;
	}
	public String getLoadingInfoVO() {
		return loadingInfoVO;
	}
	public void setLoadingInfoVO(String loadingInfoVO) {
		this.loadingInfoVO = loadingInfoVO;
	}
	public String getMakingNotesVO() {
		return makingNotesVO;
	}
	public void setMakingNotesVO(String makingNotesVO) {
		this.makingNotesVO = makingNotesVO;
	}
	public String getNotesVO() {
		return notesVO;
	}
	public void setNotesVO(String notesVO) {
		this.notesVO = notesVO;
	}
	public Long getInTimeVO() {
		return inTimeVO;
	}
	public void setInTimeVO(Long inTimeVO) {
		this.inTimeVO = inTimeVO;
	}
	public Long getOutTimeVO() {
		return outTimeVO;
	}
	public void setOutTimeVO(Long outTimeVO) {
		this.outTimeVO = outTimeVO;
	}
	public String getCarDeptVO() {
		return carDeptVO;
	}
	public void setCarDeptVO(String carDeptVO) {
		this.carDeptVO = carDeptVO;
	}
	public String getCarNumberVO() {
		return carNumberVO;
	}
	public void setCarNumberVO(String carNumberVO) {
		this.carNumberVO = carNumberVO;
	}
	public String getCarDriverVO() {
		return carDriverVO;
	}
	public void setCarDriverVO(String carDriverVO) {
		this.carDriverVO = carDriverVO;
	}
	public String getInTimeVOToLocalString() {
		return  MyUtil.formatMillisSecondStyle(this.inTimeVO);
	}
	public void setInTimeVOToLocalString(String inTimeVOToLocalString) {
		this.inTimeVOToLocalString = inTimeVOToLocalString;
	}
	public String getYearOfInTime() {
		return String.valueOf(MyUtil.getTimeFiledByMillis(this.outTimeVO, Calendar.YEAR));
	}
	public void setYearOfInTime(String yearOfInTime) {
		this.yearOfInTime = yearOfInTime;
	}
	public String getMonthOfInTime() {
		return String.valueOf(MyUtil.getTimeFiledByMillis(this.outTimeVO, Calendar.MONTH) + 1);
	}
	public void setMonthOfInTime(String monthOfInTime) {
		this.monthOfInTime = monthOfInTime;
	}
	public String getDateOfInTime() {
		return String.valueOf(MyUtil.getTimeFiledByMillis(this.outTimeVO, Calendar.DAY_OF_MONTH));
	}
	public void setDateOfInTime(String dateOfInTime) {
		this.dateOfInTime = dateOfInTime;
	}
	public String getDepartureVO() {
		return departureVO;
	}
	public void setDepartureVO(String departureVO) {
		this.departureVO = departureVO;
	}
	public String getNetWeightVO() {
		String returnStr = "";
		if(this.grossWeightVO != null){
			returnStr = MyUtil.decimalFormat.format(this.grossWeightVO - this.tareWeightVO);
		}
		return returnStr;
	}
	public void setNetWeightVO(String netWeightVO) {
		this.netWeightVO = netWeightVO;
	}
	public String getOutTimeVOToLocalString() {
		String returnStr = "";
		if(this.outTimeVO != null){
			returnStr = MyUtil.formatMillis(this.outTimeVO);
		}
		return returnStr;
	}
	public void setOutTimeVOToLocalString(String outTimeVOToLocalString) {
		this.outTimeVOToLocalString = outTimeVOToLocalString;
	}
	public String getMineCodeVO() {
		return mineCodeVO;
	}
	public void setMineCodeVO(String mineCodeVO) {
		this.mineCodeVO = mineCodeVO;
	}
	public String getHangUpStateVOToString() {
		String returnValue = "";
		if(hangUpStateVO != null){
			returnValue = hangUpStateVO ? "已挂起" : "未挂起";
		}
		return returnValue;
	}
	public void setHangUpStateVOToString(String hangUpStateVOToString) {
		this.hangUpStateVOToString = hangUpStateVOToString;
	}
	public String getOutTimeVOToLocalStringSecStyle() {
		String returnStr = "";
		if(this.outTimeVO != null){
			returnStr = MyUtil.formatMillisThirdStyle(this.outTimeVO);
		}
		return returnStr;
	}
	public void setOutTimeVOToLocalStringSecStyle(String outTimeVOToLocalStringSecStyle) {
		this.outTimeVOToLocalStringSecStyle = outTimeVOToLocalStringSecStyle;
	}
}

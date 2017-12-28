package com.util;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MyUtil {
	public static final String PROJECT_NAME = "Mine0629";
	public static final String[] EXCEL_TITLES = new String[]{
		"编号", "日期", "发货地点", "收货单位", "承运单位", "车牌号", "驾驶员", "品名", 
		"毛重", "皮重", "净重", "单位", "过磅员", "装车", "制单"
	};
	public static final GregorianCalendar gregorianCalendar = new GregorianCalendar();
	public static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	public static final SimpleDateFormat sdfSecondStyle = new SimpleDateFormat("yyyy-MM-dd");
	public static final SimpleDateFormat sdfThridStyle = new SimpleDateFormat("yyyyMMdd");
	public static final double FLUCTUATION = 0.01d;	//两次称重获得的数据值相差超过1,认为改组数据无效;
	public static final int DATA_READ_LENGTH = 6;
	public static final long MAX_WAIT_MILLIS = 5000;	//称重的超时等待时间上限;
	public static final double WEIGHT_CRITERION_ACTIVATE_DWR = 3.0d;		//获得称重数据大于1吨,认为有车上了地磅;
	public static final int GROUP_DATA_COUNT = 8;	//每次称重,每5个数据为一组;
	public static final int GROUP_COUNT = 3;	//总共取5组数据;
	//当矿车走上地磅时,取到稳定称重数据后,弹窗;
	//数据输入完毕,点击保存,弹窗关闭,此时,将收集数据的标志置false,不再收集数据,因为也不再会弹窗;
	//直到矿车开走,意即称重数据降低到0时,重新开始收集数据,等待下一辆矿车的到来;
	//考虑到称重数据不应为负数,所以这里认定：
	//当称重数据足够低,小于标准WEIGHT_CRITERION_TO_NOTIFY_DWR时,重新开始收集数据;
	public static final Double WEIGHT_CRITERION_CAR_LEAVE = 0.5d;	
	public static final String CAR_IN = "in";
	public static final String CAR_OUT = "out";
	public static final String DAILYINFO_PREFIX = "";		//拉矿记录日编号前缀;
	public static final String DAILYINFO_ENDFIX = "";		//拉矿记录日编号后缀;
	public static final Long MILLIS_OF_DAY = new Long(24 * 60 * 60 * 1000);
	public static final String RECEIVEDEPT = "仙福集团炼铁厂";
	public static final String DEPARTURE = "鲁电矿业";
	public static final DecimalFormat decimalFormat = new DecimalFormat("0.000");
	public static final String EXPORT_EXCEL_FILENAME_PREFIX = "XinPingLuDian_";
	public static final String JSON_SENT_DIR = "jsonsSent";
	public static final String JSON_RECEIVED_DIR = "jsonsReceived";
	public static final String JSONFile_PREFIX_CARINFO = "car";
	public static final String JSONFile_PREFIX_DAILYINFO = "daily";
	public static final int LATEST_IP_PORT_COUNT = 5;
	public static final int JSONFILE_DEAL_TIME = 3;	//socketServer成功接收json文件后,如果解析过程出错,则最多重复解析三次;
	public static final int SECOND_WEIGHT_TIME_LIMITED = 2 * 60 * 60 * 1000;	//在两小时之内,同一辆矿车连续出矿,则认为其在进行"二次过磅";此时,不会产生新的矿运记录,而会覆盖当天的该车的上一次的矿运记录的grossWeight和出矿时间;
	public static final int DELETE_TRUE = 1;
	public static final int DELETE_FALSE = 0;
	public static final long HANGUP_EXPIRED_MILLIS = 77760000;	//挂起超过90天自动删除（打删除标记）
	public static final Integer AUTHORITY_SOVEREIGNTY = 0;
	public static final Integer AUTHORITY_HIGH = 1;
	public static final Integer AUTHORITY_MIDDLE = 2;
	public static final Integer AUTHORITY_LOW = 3;
	public static final int SYSTEM_LOG_TYPE_LOGIN = 0;
	public static final int SYSTEM_LOG_TYPE_DELETE_DAILYINFO = 1;
	public static final int SYSTEM_LOG_TYPE_HANGUP = 2;
	public static final Map<Integer, String> AUTHORITY_DES_MAP = new HashMap<Integer, String>();
	static{
		AUTHORITY_DES_MAP.put(AUTHORITY_SOVEREIGNTY, "超级管理员");
		AUTHORITY_DES_MAP.put(AUTHORITY_HIGH, "超级管理员");
		AUTHORITY_DES_MAP.put(AUTHORITY_MIDDLE, "管理员");
		AUTHORITY_DES_MAP.put(AUTHORITY_LOW, "普通用户");
	}
	
	//一下是数据库备份使用到的，2011-7-13日添加
	public static final String DATABASE_USER="root";
	public static final String DATABASE_PASSWORD="1234";
	public static final String DATABASE_BACKUP_FLODER="D:\\mineBackUp\\";

	public static final String DOWNLOAD_TYPE_EXCEL = "excel";
	public static final String DOWNLOAD_TYPE_TXT = "txt";
	
	public static String formatTime(Date date){
		return sdf.format(date);
	}
	
	public static String formatMillis(Long millis){
		return sdf.format(new Date(millis));
	}

	public static String formatMillisSecondStyle(Long millis){
		return millis==null?"":sdfSecondStyle.format(new Date(millis));
	}
	
	public static String formatMillisThirdStyle(Long millis){
		return millis==null?"":sdfThridStyle.format(new Date(millis));
	}
	
	public static Double getAverageValueOfList(List<Double> dataList){
		double averageValue = 0.0d;
		if(dataList != null && dataList.size() > 0){
			double sum = 0.0d;
			for (Double tmpDoubleData : dataList) {
				sum += tmpDoubleData;
			}
			averageValue = sum / dataList.size();
		}
		return averageValue;
	}
	
	public static boolean checkAverageListStable(List<Double> averageDataList){
		boolean flag = true;
		int size = averageDataList.size();
		for (int i = 0; i < size - 1; i++) {
			if (Math.abs(averageDataList.get(i + 1) - averageDataList.get(i)) > MyUtil.FLUCTUATION) {
				flag = false;
				break;
			}
		}
		return flag;
	}

	//得到今天早晨0时0分0秒对应的毫秒值
	public static Long getTodayStartMillis(){
		GregorianCalendar gre = new GregorianCalendar();
		gre.set(Calendar.HOUR_OF_DAY, 0);
		gre.set(Calendar.MINUTE, 0);
		gre.set(Calendar.SECOND, 0);
		gre.set(Calendar.MILLISECOND, 0);
		return gre.getTimeInMillis();
	}
	
	//由一个时间毫秒值得到当天早晨0时0分0秒对应的毫秒值
	public static Long getStartMillisOfOneDay(Long millis){
		GregorianCalendar gre = new GregorianCalendar();
		gre.setTimeInMillis(millis);
		gre.set(Calendar.HOUR_OF_DAY, 0);
		gre.set(Calendar.MINUTE, 0);
		gre.set(Calendar.SECOND, 0);
		gre.set(Calendar.MILLISECOND, 0);
		return gre.getTimeInMillis();
	}
	
	public static Long getEndMillisOfOneDayByStartMillis(Long startMillis){
		return startMillis + MILLIS_OF_DAY;
	}
	
	//得到今晚23时59分59秒对应的毫秒值
	public static Long getTodayEndMillis(){
		GregorianCalendar gre = new GregorianCalendar();
		gre.set(Calendar.HOUR_OF_DAY, 23);
		gre.set(Calendar.MINUTE, 59);
		gre.set(Calendar.SECOND, 59);
		gre.set(Calendar.MILLISECOND, 999);
		return gre.getTimeInMillis();
	}
	
	public static boolean amINull(String strToCheck){
		return strToCheck == null || "".equals(strToCheck);
	}
	
	public static int getTimeFiledByMillis(Long millis, int field){
		int returnStr = 0;
		if(millis != null){
			gregorianCalendar.setTimeInMillis(millis);
			returnStr = gregorianCalendar.get(field);
		}
		return returnStr;
	}
	
	//由时间格式yyyy-MM-dd得到当天的起始时间毫秒值
	public static Long getStartMillisOfOneDay(String dateStr){
		Long returnValue = new Long(0);
		if(dateStr != null && !"".equals(dateStr) && dateStr.indexOf("-") > -1){
			String data[] = dateStr.split("-");
			GregorianCalendar gre = new GregorianCalendar(Integer.parseInt(data[0]), Integer.parseInt(data[1]) - 1, Integer.parseInt(data[2]));
			gre.set(Calendar.HOUR_OF_DAY, 0);
			gre.set(Calendar.MINUTE, 0);
			gre.set(Calendar.SECOND, 0);
			gre.set(Calendar.MILLISECOND, 0);
			returnValue = gre.getTimeInMillis();
		}
		return returnValue;
	}
	
	public static String StringArrayToString(String[] array){
		StringBuilder returnValue = new StringBuilder();
		int len = array.length;
		for (int i = 0; i < len; i++) {
			returnValue.append("'"+array[i]+"'");
			if(i != len - 1){
				returnValue.append(",");
			}
		}
		return returnValue.toString();
	}
}

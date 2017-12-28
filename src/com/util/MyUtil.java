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
		"���", "����", "�����ص�", "�ջ���λ", "���˵�λ", "���ƺ�", "��ʻԱ", "Ʒ��", 
		"ë��", "Ƥ��", "����", "��λ", "����Ա", "װ��", "�Ƶ�"
	};
	public static final GregorianCalendar gregorianCalendar = new GregorianCalendar();
	public static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	public static final SimpleDateFormat sdfSecondStyle = new SimpleDateFormat("yyyy-MM-dd");
	public static final SimpleDateFormat sdfThridStyle = new SimpleDateFormat("yyyyMMdd");
	public static final double FLUCTUATION = 0.01d;	//���γ��ػ�õ�����ֵ����1,��Ϊ����������Ч;
	public static final int DATA_READ_LENGTH = 6;
	public static final long MAX_WAIT_MILLIS = 5000;	//���صĳ�ʱ�ȴ�ʱ������;
	public static final double WEIGHT_CRITERION_ACTIVATE_DWR = 3.0d;		//��ó������ݴ���1��,��Ϊ�г����˵ذ�;
	public static final int GROUP_DATA_COUNT = 8;	//ÿ�γ���,ÿ5������Ϊһ��;
	public static final int GROUP_COUNT = 3;	//�ܹ�ȡ5������;
	//�������ϵذ�ʱ,ȡ���ȶ��������ݺ�,����;
	//�����������,�������,�����ر�,��ʱ,���ռ����ݵı�־��false,�����ռ�����,��ΪҲ���ٻᵯ��;
	//ֱ���󳵿���,�⼴�������ݽ��͵�0ʱ,���¿�ʼ�ռ�����,�ȴ���һ���󳵵ĵ���;
	//���ǵ��������ݲ�ӦΪ����,���������϶���
	//�����������㹻��,С�ڱ�׼WEIGHT_CRITERION_TO_NOTIFY_DWRʱ,���¿�ʼ�ռ�����;
	public static final Double WEIGHT_CRITERION_CAR_LEAVE = 0.5d;	
	public static final String CAR_IN = "in";
	public static final String CAR_OUT = "out";
	public static final String DAILYINFO_PREFIX = "";		//�����¼�ձ��ǰ׺;
	public static final String DAILYINFO_ENDFIX = "";		//�����¼�ձ�ź�׺;
	public static final Long MILLIS_OF_DAY = new Long(24 * 60 * 60 * 1000);
	public static final String RECEIVEDEPT = "�ɸ�����������";
	public static final String DEPARTURE = "³���ҵ";
	public static final DecimalFormat decimalFormat = new DecimalFormat("0.000");
	public static final String EXPORT_EXCEL_FILENAME_PREFIX = "XinPingLuDian_";
	public static final String JSON_SENT_DIR = "jsonsSent";
	public static final String JSON_RECEIVED_DIR = "jsonsReceived";
	public static final String JSONFile_PREFIX_CARINFO = "car";
	public static final String JSONFile_PREFIX_DAILYINFO = "daily";
	public static final int LATEST_IP_PORT_COUNT = 5;
	public static final int JSONFILE_DEAL_TIME = 3;	//socketServer�ɹ�����json�ļ���,����������̳���,������ظ���������;
	public static final int SECOND_WEIGHT_TIME_LIMITED = 2 * 60 * 60 * 1000;	//����Сʱ֮��,ͬһ������������,����Ϊ���ڽ���"���ι���";��ʱ,��������µĿ��˼�¼,���Ḳ�ǵ���ĸó�����һ�εĿ��˼�¼��grossWeight�ͳ���ʱ��;
	public static final int DELETE_TRUE = 1;
	public static final int DELETE_FALSE = 0;
	public static final long HANGUP_EXPIRED_MILLIS = 77760000;	//���𳬹�90���Զ�ɾ������ɾ����ǣ�
	public static final Integer AUTHORITY_SOVEREIGNTY = 0;
	public static final Integer AUTHORITY_HIGH = 1;
	public static final Integer AUTHORITY_MIDDLE = 2;
	public static final Integer AUTHORITY_LOW = 3;
	public static final int SYSTEM_LOG_TYPE_LOGIN = 0;
	public static final int SYSTEM_LOG_TYPE_DELETE_DAILYINFO = 1;
	public static final int SYSTEM_LOG_TYPE_HANGUP = 2;
	public static final Map<Integer, String> AUTHORITY_DES_MAP = new HashMap<Integer, String>();
	static{
		AUTHORITY_DES_MAP.put(AUTHORITY_SOVEREIGNTY, "��������Ա");
		AUTHORITY_DES_MAP.put(AUTHORITY_HIGH, "��������Ա");
		AUTHORITY_DES_MAP.put(AUTHORITY_MIDDLE, "����Ա");
		AUTHORITY_DES_MAP.put(AUTHORITY_LOW, "��ͨ�û�");
	}
	
	//һ�������ݿⱸ��ʹ�õ��ģ�2011-7-13�����
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

	//�õ������糿0ʱ0��0���Ӧ�ĺ���ֵ
	public static Long getTodayStartMillis(){
		GregorianCalendar gre = new GregorianCalendar();
		gre.set(Calendar.HOUR_OF_DAY, 0);
		gre.set(Calendar.MINUTE, 0);
		gre.set(Calendar.SECOND, 0);
		gre.set(Calendar.MILLISECOND, 0);
		return gre.getTimeInMillis();
	}
	
	//��һ��ʱ�����ֵ�õ������糿0ʱ0��0���Ӧ�ĺ���ֵ
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
	
	//�õ�����23ʱ59��59���Ӧ�ĺ���ֵ
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
	
	//��ʱ���ʽyyyy-MM-dd�õ��������ʼʱ�����ֵ
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

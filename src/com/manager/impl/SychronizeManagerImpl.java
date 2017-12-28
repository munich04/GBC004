package com.manager.impl;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import com.dao.SychronizeDao;
import com.google.gson.JsonSyntaxException;
import com.manager.SychronizeManager;
import com.po.CarInfo;
import com.po.DailyInfo;
import com.po.IpInfo;
import com.po.PortInfo;
import com.socket.FileClientSocket;
import com.socket.FileServerSocket;
import com.util.JsonUtil;
import com.util.MyUtil;
/**
 * 1.�豸����ʧ��ʱ�������Ƶĵ����豸����ʧ�ܵİ�ť���ܷ���;
 * 2.json mysql����
 */
public class SychronizeManagerImpl implements SychronizeManager{
	
	SychronizeDao sychronizeDao;
	private int jsonFileAnalyzeTime = 0;
	
	public SychronizeDao getSychronizeDao() {
		return sychronizeDao;
	}
	public void setSychronizeDao(SychronizeDao sychronizeDao) {
		this.sychronizeDao = sychronizeDao;
	}
	
	//����socketServer
	public void startServer(String absoluteFilePath, int port){
		FileServerSocket serverSocket = FileServerSocket.getInstance();
		
		serverSocket.init(port, absoluteFilePath + MyUtil.JSON_RECEIVED_DIR);
		
		serverSocket.service();
		serverSocket.stopService();
	}
	
	//ֹͣsocketServer
	public void stopServer(String absoluteFilePath){
		FileServerSocket.serverWorkingFlag = false;
	} 
	
	public String createJsonFile(String absoluteFilePath, Long startMillis){
		String fileName = absoluteFilePath + MyUtil.JSON_SENT_DIR + File.separator + MyUtil.EXPORT_EXCEL_FILENAME_PREFIX + MyUtil.formatMillisSecondStyle(startMillis) + ".json";

		Long endMillis = MyUtil.getEndMillisOfOneDayByStartMillis(startMillis);
		List<CarInfo> carnfoList = sychronizeDao.getCarInfoAddedAtOneDay(startMillis, endMillis);
		List<DailyInfo> dailyInfoList = sychronizeDao.getDailyInfoAddedAtOneDay(startMillis, endMillis);
		
		String returnFileName = "";
		if(dailyInfoList != null && dailyInfoList.size() > 0){
			returnFileName = JsonUtil.createJsonFile(fileName, carnfoList, dailyInfoList);
		}
		
		return returnFileName;
	}
	
	public void startSychronize(String ip, int port, String fileName){
		//����socket,�������������������;
		FileClientSocket clientSocket = FileClientSocket.getInstance();
		clientSocket.init(ip, port, fileName);
		clientSocket.service();
	}
	
	public String analyzeJsonData(String absoluteFilePath, String fileName){
		String returnValue = "";
		try {
			String filePath = absoluteFilePath + MyUtil.JSON_RECEIVED_DIR + File.separator + fileName;
			
			//���ļ�������������Ҫͬ����һ�������;a fileName example : XinPingLuDian_2011-05-24.json
			String theDateStr = fileName.substring(fileName.indexOf("_")+1, fileName.indexOf("."));
			
			Long startMillis = MyUtil.getStartMillisOfOneDay(theDateStr);
			Long endMillis = MyUtil.getEndMillisOfOneDayByStartMillis(startMillis);
			
			if(!dealWithJsonFile(startMillis, endMillis, filePath)){
				if(jsonFileAnalyzeTime < MyUtil.JSONFILE_DEAL_TIME){
					FileServerSocket.errorInfo.append(addPrefix("���ڽ���json�ļ�..."));
					dealWithJsonFile(startMillis, endMillis, filePath);
					jsonFileAnalyzeTime++;
				}else{
					FileServerSocket.errorInfo.append(addPrefix("json�ļ��Ľ��������ھ������γ��Ժ�,����δ��ȡ�óɹ�!����ϵ����ԱЭ������!"));
					jsonFileAnalyzeTime = 0;
				}
			}
			
		} catch (Exception e){
			e.printStackTrace();
			returnValue = "error";
		}
		return returnValue;
	}
	
	private boolean dealWithJsonFile(Long startMillis, Long endMillis, String filePath) throws JsonSyntaxException, IOException {
		boolean flag = false;
		FileServerSocket.errorInfo.append(addPrefix("���ڽ���json�ļ�..."));
		
		//����ɾ������ļ�¼
		sychronizeDao.deleteCarInfoListOfOneDay(startMillis, endMillis);
		sychronizeDao.deleteDailyInfoListOfOneDay(startMillis, endMillis);
		//����ӽ��������ĵ����¼
		Map<String, List> map = JsonUtil.analyzeJsonData(filePath);
		List<CarInfo> carInfoList = (List<CarInfo>)map.get(MyUtil.JSONFile_PREFIX_CARINFO);
		List<DailyInfo> dailyInfoList = (List<DailyInfo>)map.get(MyUtil.JSONFile_PREFIX_DAILYINFO);
		
		int carLength = carInfoList.size();
		int dailyLength = dailyInfoList.size();
		
		FileServerSocket.errorInfo.append(addPrefix("������" + carLength + "��������¼, " + dailyLength + "�����˼�¼"));
		
		sychronizeDao.addCarInfoListOfOneDay(carInfoList);
		sychronizeDao.addDailyInfoListOfOneDay(dailyInfoList);
		
		FileServerSocket.errorInfo.append(addPrefix("�����ѳɹ��������ݿ�!����У����ȷ��..."));
		
		int recountCarLength = ((Long)sychronizeDao.countCarInfoAddedAtOneDay(startMillis, endMillis).get(0)).intValue();
		int recountDailyLength = ((Long)sychronizeDao.countDailyInfoAddedAtOneDay(startMillis, endMillis).get(0)).intValue();
	
		flag = carLength == recountCarLength && dailyLength == recountDailyLength;

		FileServerSocket.errorInfo.append(addPrefix(flag?"У��ɹ�!":"���ݿ���������쳣,У��ʧ��!"));
		
		FileServerSocket.errorInfo.append(addPrefix(flag?"ͬ����������ȡ�óɹ�!":"ͬ������δ��ȡ�óɹ�,�������³���json�ļ�����..."));
		
		return flag;
	}
	
	public String getClientInfo(){
		return FileClientSocket.errorInfo.toString();
	}
	
	public String getServerInfo() {
		return FileServerSocket.errorInfo.toString();
	}
	
	public String getFileReceivedSuccessInfo(){
		return FileServerSocket.fileReceiveSuccessInfo;
	}
	public List<IpInfo> getLatestUsedIp(Integer number) {
		return sychronizeDao.getLatestUsedIp(number == null ? 1 : number);
	}
	public List<PortInfo> getLatestUsedPort(Integer number) {
		return sychronizeDao.getLatestUsedPort(number == null ? 1 : number);
	}
	public void saveIpInfo(String ip, Integer port) {
		List ipInfoCountList = sychronizeDao.getIpInfoListByIpAndPort(ip, port);
		if(ipInfoCountList != null && ipInfoCountList.size() > 0){
			if(((Long)ipInfoCountList.get(0)).intValue() == 0){
				IpInfo ipInfo = new IpInfo(ip, port, System.currentTimeMillis());
				sychronizeDao.saveIpInfo(ipInfo);
			}
		}
	}
	public void savePortInfo(Integer port) {
		List portInfoCountList = sychronizeDao.getPortInfoListByPort(port);
		if(portInfoCountList != null && portInfoCountList.size() > 0){
			if(((Long)portInfoCountList.get(0)).intValue() == 0){
				PortInfo portInfo = new PortInfo(port, System.currentTimeMillis());
				sychronizeDao.savePortInfo(portInfo);
			}
		}
	}
	public void deleteIpInfoByIpAndPort(String ip, Integer port) {
		sychronizeDao.deleteIpInfoByIpAndPort(ip, port);
	}
	public void deletePortInfoByPort(Integer port) {
		sychronizeDao.deletePortInfoByPort(port);
	}
	private String addPrefix(String data){
		return "<div class='errorInfoStyle1'>"+ MyUtil.formatMillis(System.currentTimeMillis()) + ": " + data + "</div>";
	}
}

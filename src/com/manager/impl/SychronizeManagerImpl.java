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
 * 1.设备连接失败时，无限制的弹出设备连接失败的按钮，很烦啊;
 * 2.json mysql乱码
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
	
	//开启socketServer
	public void startServer(String absoluteFilePath, int port){
		FileServerSocket serverSocket = FileServerSocket.getInstance();
		
		serverSocket.init(port, absoluteFilePath + MyUtil.JSON_RECEIVED_DIR);
		
		serverSocket.service();
		serverSocket.stopService();
	}
	
	//停止socketServer
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
		//启动socket,向服务器发出连接请求;
		FileClientSocket clientSocket = FileClientSocket.getInstance();
		clientSocket.init(ip, port, fileName);
		clientSocket.service();
	}
	
	public String analyzeJsonData(String absoluteFilePath, String fileName){
		String returnValue = "";
		try {
			String filePath = absoluteFilePath + MyUtil.JSON_RECEIVED_DIR + File.separator + fileName;
			
			//由文件名解析出这是要同步哪一天的数据;a fileName example : XinPingLuDian_2011-05-24.json
			String theDateStr = fileName.substring(fileName.indexOf("_")+1, fileName.indexOf("."));
			
			Long startMillis = MyUtil.getStartMillisOfOneDay(theDateStr);
			Long endMillis = MyUtil.getEndMillisOfOneDayByStartMillis(startMillis);
			
			if(!dealWithJsonFile(startMillis, endMillis, filePath)){
				if(jsonFileAnalyzeTime < MyUtil.JSONFILE_DEAL_TIME){
					FileServerSocket.errorInfo.append(addPrefix("正在解析json文件..."));
					dealWithJsonFile(startMillis, endMillis, filePath);
					jsonFileAnalyzeTime++;
				}else{
					FileServerSocket.errorInfo.append(addPrefix("json文件的解析工作在经过三次尝试后,最终未能取得成功!请联系管理员协调处理!"));
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
		FileServerSocket.errorInfo.append(addPrefix("正在解析json文件..."));
		
		//首先删除当天的记录
		sychronizeDao.deleteCarInfoListOfOneDay(startMillis, endMillis);
		sychronizeDao.deleteDailyInfoListOfOneDay(startMillis, endMillis);
		//再添加解析而来的当天记录
		Map<String, List> map = JsonUtil.analyzeJsonData(filePath);
		List<CarInfo> carInfoList = (List<CarInfo>)map.get(MyUtil.JSONFile_PREFIX_CARINFO);
		List<DailyInfo> dailyInfoList = (List<DailyInfo>)map.get(MyUtil.JSONFile_PREFIX_DAILYINFO);
		
		int carLength = carInfoList.size();
		int dailyLength = dailyInfoList.size();
		
		FileServerSocket.errorInfo.append(addPrefix("解析出" + carLength + "条车辆记录, " + dailyLength + "条矿运记录"));
		
		sychronizeDao.addCarInfoListOfOneDay(carInfoList);
		sychronizeDao.addDailyInfoListOfOneDay(dailyInfoList);
		
		FileServerSocket.errorInfo.append(addPrefix("数据已成功插入数据库!正在校验正确性..."));
		
		int recountCarLength = ((Long)sychronizeDao.countCarInfoAddedAtOneDay(startMillis, endMillis).get(0)).intValue();
		int recountDailyLength = ((Long)sychronizeDao.countDailyInfoAddedAtOneDay(startMillis, endMillis).get(0)).intValue();
	
		flag = carLength == recountCarLength && dailyLength == recountDailyLength;

		FileServerSocket.errorInfo.append(addPrefix(flag?"校验成功!":"数据库操作出现异常,校验失败!"));
		
		FileServerSocket.errorInfo.append(addPrefix(flag?"同步工作最终取得成功!":"同步工作未能取得成功,即将重新尝试json文件解析..."));
		
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

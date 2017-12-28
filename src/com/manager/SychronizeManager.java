package com.manager;

import java.util.List;

import com.po.IpInfo;
import com.po.PortInfo;

public interface SychronizeManager{
	//¿ªÆôsocketServer
	public void startServer(String absoluteFilePath, int port);
	
	//Í£Ö¹socketServer
	public void stopServer(String absoluteFilePath);
	
	public String createJsonFile(String absoluteFilePath, Long startMillis);
	
	public void startSychronize(String ip, int port, String fileName);
	
	public String analyzeJsonData(String absoluteFilePath, String fileName);
	
	public String getClientInfo();
	
	public String getServerInfo();
	
	public String getFileReceivedSuccessInfo();
	
	public List<PortInfo> getLatestUsedPort(Integer number);
	
	public List<IpInfo> getLatestUsedIp(Integer number);
	
	public void savePortInfo(Integer port);
	
	public void saveIpInfo(String ip, Integer port);
	
	public void deletePortInfoByPort(Integer port);
	
	public void deleteIpInfoByIpAndPort(String ip, Integer port);
}

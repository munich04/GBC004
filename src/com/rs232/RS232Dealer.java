package com.rs232;

import java.util.Enumeration;
import java.util.TooManyListenersException;

import javax.comm.CommPortIdentifier;
import javax.comm.PortInUseException;
import javax.comm.SerialPort;

public class RS232Dealer{
	
	private static CommPortIdentifier portId = null;	//检测系统中可用的通讯端口类
	private static Enumeration<CommPortIdentifier> portList = null;	//Enumeration 为枚举型类,在java.util中
	public static SerialPort serialPort = null;	//声明RS-232串行端口的成员变量
	
	//响应页面DWR请求,判断是否已经打开串口
	//true: serialPort不为空,已初始化; false:serialPort为空,未初始化;
	public boolean getRS232Status(){
		return !(serialPort == null);
	}
	
	public Double getRS232Data(){
		return RS232Listener.sRS232DoubleData;
	}
	
	//响应页面DWR请求,打开串口
	public boolean initRS232Service(){
		try {
			openSerialPort();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return getRS232Status();
	}
	
	//响应页面DWR请求,关闭串口
	public boolean destroyRS232Service(){
		try {
			closeSerialPort();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return getRS232Status();
	}
	
	//打开串口
	@SuppressWarnings("unchecked")
	private void openSerialPort() throws PortInUseException, TooManyListenersException{
		System.out.println("init SerialPort");
		//获取系统中所有的通讯端口 
		portList = CommPortIdentifier.getPortIdentifiers();
		//用循环结构找出串口
		System.out.println(portList.hasMoreElements());
		while (portList.hasMoreElements()){
			//强制转换为通讯端口类型
			portId = portList.nextElement();
			System.out.println("portId:"+portId);
			if (portId.getPortType() == CommPortIdentifier.PORT_SERIAL) {
				
System.out.println("华丽分割  ---  portId " + portId.getName());

				if(portId.getName().equals("COM3")) {
					if(portId.isCurrentlyOwned()){
						System.out.println("Owener:"+portId.getCurrentOwner());
					}
					serialPort = (SerialPort) portId.open("ReadComm", 2000);

					//设置串口监听器 (先取消,再添加)
					serialPort.removeEventListener();
					serialPort.addEventListener(new RS232Listener(serialPort));
					
System.out.println("华丽分割  ---  监听器加载成功! ");
					
					//侦听到串口有数据,触发串口事件 
					serialPort.notifyOnDataAvailable(true);
				}
			}
		}
	}
	
	//关闭串口
	private void closeSerialPort() {
		if(serialPort != null){
			//关闭serialPort
			serialPort.close();
			
			//清空相关数据
			serialPort = null;
			portId = null;
			portList = null;
		}
	}
}

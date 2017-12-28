package com.rs232;

import java.io.IOException;
import java.io.InputStream;
import java.util.Collection;

import javax.comm.SerialPort;
import javax.comm.SerialPortEvent;
import javax.comm.SerialPortEventListener;
import javax.comm.UnsupportedCommOperationException;
import javax.servlet.ServletContext;

import org.directwebremoting.ServerContext;
import org.directwebremoting.ServerContextFactory;
import org.directwebremoting.WebContextFactory;
import org.directwebremoting.proxy.dwr.Util;

import com.filter.PathFilter;
import com.util.MyUtil;

public class RS232Listener implements SerialPortEventListener{
	
	private InputStream inputStream;
	private SerialPort serialPort = null;	//声明RS-232串行端口的成员变量
	public static Double sRS232DoubleData = null;

	private ServerContext sctx;	//DWR容器
	
	private static boolean activateFlag = true;

	public RS232Listener(){
	}
	
	public RS232Listener(SerialPort serialPort){
		ServletContext servletContext = WebContextFactory.get().getServletContext();
		sctx = ServerContextFactory.get(servletContext);//获取DWR容器
		
		this.serialPort = serialPort;
	}
	
	//串口监听器触发的事件，设置串口通讯参数，读取数据并写到文本区中
	public void serialEvent(SerialPortEvent event) {
		if(serialPort != null && event.getEventType() == SerialPortEvent.DATA_AVAILABLE){
			try {
				//设置串口通讯参数：波特率、数据位、停止位、奇偶校验
				serialPort.setSerialPortParams(1200, SerialPort.DATABITS_8,
						SerialPort.STOPBITS_1, SerialPort.PARITY_NONE);
				
				byte[] readBuffer = new byte[20];
				
				inputStream = serialPort.getInputStream();
				
				//从线路上读取数据流
				while (inputStream.available() > 0) {
					inputStream.read(readBuffer);
				}
				//接收到的数据
				sRS232DoubleData = dealRS232Data(new String(readBuffer));
				
				if(sRS232DoubleData < MyUtil.WEIGHT_CRITERION_CAR_LEAVE){
					activateFlag = true;
System.out.println("华丽分割  ---  车已离开,可以重新弹窗! ");
				}
				
				if(activateFlag && sRS232DoubleData > MyUtil.WEIGHT_CRITERION_ACTIVATE_DWR){
System.out.println("华丽分割  ---  准备激活弹窗! ");
					activateFlag = false;
					//激活弹窗
					activatePageFunction();
				}
			} catch (UnsupportedCommOperationException e) {
				e.printStackTrace();
				sRS232DoubleData = null;
			} catch (IOException e) {
				e.printStackTrace();
				sRS232DoubleData = null;
			} catch (NumberFormatException e) {
				sRS232DoubleData = null;
			} catch (StringIndexOutOfBoundsException e) {
				sRS232DoubleData = null;
			} 
		}
	}
	
	//将读取出来的字符串数据转化为double重量数据;
	private Double dealRS232Data(String sRS232Data) throws NumberFormatException, StringIndexOutOfBoundsException{
		Double tmpDValue = 0.0d;
		
		int startIndex = sRS232Data.indexOf("+") > -1 ? sRS232Data.indexOf("+") : sRS232Data.indexOf("-");
		int beginIndex = startIndex + 1;
		int endIndex = beginIndex + MyUtil.DATA_READ_LENGTH;
		
		double value = Double.parseDouble(sRS232Data.substring(beginIndex,endIndex));
		double scaleValue = Double.parseDouble(sRS232Data.substring(endIndex, endIndex + 1));
		tmpDValue = value / Math.pow(10.0d, scaleValue);
		return tmpDValue;
	}
	
	public void activatePageFunction(){
System.out.println("华丽分割  ---  PathFilter.getPath(): " + PathFilter.getPath());
		Collection<?> sessions = sctx.getScriptSessionsByPage(PathFilter.getPath() + "/main.jsp");
		Util pages = new Util(sessions);
		//调用main.jsp页面中的js方法openTransmitDetailJspByDwr, 并传递参数1,2,3...
		pages.addFunctionCall("openTransmitDetailJspByDwr");
	}
}

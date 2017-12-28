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
	private SerialPort serialPort = null;	//����RS-232���ж˿ڵĳ�Ա����
	public static Double sRS232DoubleData = null;

	private ServerContext sctx;	//DWR����
	
	private static boolean activateFlag = true;

	public RS232Listener(){
	}
	
	public RS232Listener(SerialPort serialPort){
		ServletContext servletContext = WebContextFactory.get().getServletContext();
		sctx = ServerContextFactory.get(servletContext);//��ȡDWR����
		
		this.serialPort = serialPort;
	}
	
	//���ڼ������������¼������ô���ͨѶ��������ȡ���ݲ�д���ı�����
	public void serialEvent(SerialPortEvent event) {
		if(serialPort != null && event.getEventType() == SerialPortEvent.DATA_AVAILABLE){
			try {
				//���ô���ͨѶ�����������ʡ�����λ��ֹͣλ����żУ��
				serialPort.setSerialPortParams(1200, SerialPort.DATABITS_8,
						SerialPort.STOPBITS_1, SerialPort.PARITY_NONE);
				
				byte[] readBuffer = new byte[20];
				
				inputStream = serialPort.getInputStream();
				
				//����·�϶�ȡ������
				while (inputStream.available() > 0) {
					inputStream.read(readBuffer);
				}
				//���յ�������
				sRS232DoubleData = dealRS232Data(new String(readBuffer));
				
				if(sRS232DoubleData < MyUtil.WEIGHT_CRITERION_CAR_LEAVE){
					activateFlag = true;
System.out.println("�����ָ�  ---  �����뿪,�������µ���! ");
				}
				
				if(activateFlag && sRS232DoubleData > MyUtil.WEIGHT_CRITERION_ACTIVATE_DWR){
System.out.println("�����ָ�  ---  ׼�������! ");
					activateFlag = false;
					//�����
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
	
	//����ȡ�������ַ�������ת��Ϊdouble��������;
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
System.out.println("�����ָ�  ---  PathFilter.getPath(): " + PathFilter.getPath());
		Collection<?> sessions = sctx.getScriptSessionsByPage(PathFilter.getPath() + "/main.jsp");
		Util pages = new Util(sessions);
		//����main.jspҳ���е�js����openTransmitDetailJspByDwr, �����ݲ���1,2,3...
		pages.addFunctionCall("openTransmitDetailJspByDwr");
	}
}

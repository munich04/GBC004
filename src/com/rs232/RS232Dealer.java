package com.rs232;

import java.util.Enumeration;
import java.util.TooManyListenersException;

import javax.comm.CommPortIdentifier;
import javax.comm.PortInUseException;
import javax.comm.SerialPort;

public class RS232Dealer{
	
	private static CommPortIdentifier portId = null;	//���ϵͳ�п��õ�ͨѶ�˿���
	private static Enumeration<CommPortIdentifier> portList = null;	//Enumeration Ϊö������,��java.util��
	public static SerialPort serialPort = null;	//����RS-232���ж˿ڵĳ�Ա����
	
	//��Ӧҳ��DWR����,�ж��Ƿ��Ѿ��򿪴���
	//true: serialPort��Ϊ��,�ѳ�ʼ��; false:serialPortΪ��,δ��ʼ��;
	public boolean getRS232Status(){
		return !(serialPort == null);
	}
	
	public Double getRS232Data(){
		return RS232Listener.sRS232DoubleData;
	}
	
	//��Ӧҳ��DWR����,�򿪴���
	public boolean initRS232Service(){
		try {
			openSerialPort();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return getRS232Status();
	}
	
	//��Ӧҳ��DWR����,�رմ���
	public boolean destroyRS232Service(){
		try {
			closeSerialPort();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return getRS232Status();
	}
	
	//�򿪴���
	@SuppressWarnings("unchecked")
	private void openSerialPort() throws PortInUseException, TooManyListenersException{
		System.out.println("init SerialPort");
		//��ȡϵͳ�����е�ͨѶ�˿� 
		portList = CommPortIdentifier.getPortIdentifiers();
		//��ѭ���ṹ�ҳ�����
		System.out.println(portList.hasMoreElements());
		while (portList.hasMoreElements()){
			//ǿ��ת��ΪͨѶ�˿�����
			portId = portList.nextElement();
			System.out.println("portId:"+portId);
			if (portId.getPortType() == CommPortIdentifier.PORT_SERIAL) {
				
System.out.println("�����ָ�  ---  portId " + portId.getName());

				if(portId.getName().equals("COM3")) {
					if(portId.isCurrentlyOwned()){
						System.out.println("Owener:"+portId.getCurrentOwner());
					}
					serialPort = (SerialPort) portId.open("ReadComm", 2000);

					//���ô��ڼ����� (��ȡ��,�����)
					serialPort.removeEventListener();
					serialPort.addEventListener(new RS232Listener(serialPort));
					
System.out.println("�����ָ�  ---  ���������سɹ�! ");
					
					//����������������,���������¼� 
					serialPort.notifyOnDataAvailable(true);
				}
			}
		}
	}
	
	//�رմ���
	private void closeSerialPort() {
		if(serialPort != null){
			//�ر�serialPort
			serialPort.close();
			
			//����������
			serialPort = null;
			portId = null;
			portList = null;
		}
	}
}

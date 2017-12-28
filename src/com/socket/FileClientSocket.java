package com.socket;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.net.Socket;

import com.util.MyUtil;

public class FileClientSocket {
	private static FileClientSocket instance;
	private Socket client;
	private DataInputStream dis;
	private DataOutputStream dos;
	private DataInputStream fileDis;
	private String ip;
	private int port;
	private int count;
	private String filePath;
	
	public static StringBuilder errorInfo = new StringBuilder();
	
	private FileClientSocket(){
	}
	
	public static FileClientSocket getInstance(){
		if(instance == null){
			instance = new FileClientSocket();
		}
		return instance;
	}
	
	public void init(String ip, int port, String filePath){
		FileClientSocket.errorInfo = new StringBuilder();
		this.setIp(ip);
		this.setPort(port);
		this.setFilePath(filePath);
		try {
			errorInfo.append(addPrefix("�������ӷ�����: " + ip + ":" + port + " ..."));
			client = new Socket(ip, port);
			errorInfo.append(addPrefix("������: " + ip + ":" + port + "���ӳɹ�!׼����������ͨ��!"));
		} catch (Exception e) {
			errorInfo.append(addPrefix("������: " + ip + ":" + port + "����ʧ��!���鱾����������, ��ȷ�Ϸ�����IP�Ͷ˿�������ȷ!"));
		}
	}
	
	public boolean doTransmitOnce(){
		boolean flag = false;
		try {
			File file = new File(filePath);
			
			String fileName = file.getName();
			errorInfo.append(addPrefix("����Ҫ������ļ����ļ���: " + fileName));
			dos.writeUTF(fileName);
			
			String fileNameChecked = dis.readUTF();
			
			boolean fileNameOk = fileName.equals(fileNameChecked);
			dos.writeBoolean(fileNameOk);
			if(!fileNameOk){
				errorInfo.append(addPrefix("�ļ�����֤ʧ��!�����¿�ʼ���͹���!"));
				return false;
			}
			errorInfo.append(addPrefix("�ļ�����֤�ɹ�!"));

			long fileLength = file.length();
			errorInfo.append(addPrefix("����Ҫ������ļ��ĳ���: " + fileLength));
			dos.writeLong(fileLength);
			
			long fileLengthChecked = dis.readLong();
			
			boolean fileLengthOk = fileLength == fileLengthChecked;
			dos.writeBoolean(fileLengthOk);
			if(!fileLengthOk){
				errorInfo.append(addPrefix("�ļ�������֤ʧ��!�����¿�ʼ���͹���!"));
				return false;
			}
			errorInfo.append(addPrefix("�ļ�������֤�ɹ�!"));
			
			if(!dis.readBoolean()){
				errorInfo.append(addPrefix("�������ļ�����ʧ��,�޷������ļ�����!"));
				return false;
			}
			errorInfo.append(addPrefix("׼�������ļ�..."));
			
			byte[] buffer = new byte[1024];
			int readCursor = -1;
			while((readCursor = fileDis.read(buffer)) != -1){
				dos.write(buffer, 0, readCursor);
			}

			//�ļ��������,���ݷ������ķ�Ӧ�ж��Ƿ���Ҫ�ط�
			boolean fileOk = dis.readBoolean();
			if(!fileOk){
				errorInfo.append(addPrefix("��������Ϊ���δ���ʧ��,�����ط�!"));
				flag = false;
			}else{
				errorInfo.append(addPrefix("�ļ����ͳɹ�,�����ر�!"));
				flag = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return flag;
	}
	
	public void service(){
		try {
			if(client != null){

				//���������ļ�������
				fileDis = new DataInputStream(new FileInputStream(filePath));
				dis = new DataInputStream(client.getInputStream());
				dos = new DataOutputStream(client.getOutputStream());
				
				if(!doTransmitOnce()){
					if(count < 3){
						doTransmitOnce();
						count++;
					}else{
						errorInfo.append(addPrefix("����3�γ���,���ݴ��Ͷ�������,�������������õ���֤������!"));
					}
				}else{
					errorInfo.append(addPrefix("���δ����ھ��� "+(count+1)+" �γ��Ժ�����ȡ�óɹ�!"));
				}
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally{
			try {
				if(fileDis != null){
					fileDis.close();
					errorInfo.append(addPrefix("�����ļ��������رգ�"));
				}
				if(dos != null){
					dos.close();
					errorInfo.append(addPrefix("socket������ر�!"));
				}
				if(dis != null){
					dis.close();
					errorInfo.append(addPrefix("socket�������ر�!"));
				}
				if(client != null){
					client.close();
					errorInfo.append(addPrefix("socket�ر�!"));
				}
				instance = null;
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	private String addPrefix(String data){
		return "<div class='errorInfoStyle1'>"+ MyUtil.formatMillis(System.currentTimeMillis()) + ": " + data + "</div>";
	}
	
	public String getIp() {
		return ip;
	}
	public void setIp(String ip) {
		this.ip = ip;
	}
	public int getPort() {
		return port;
	}
	public void setPort(int port) {
		this.port = port;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	public String getFilePath() {
		return filePath;
	}
}

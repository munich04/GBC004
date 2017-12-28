package com.socket;

import java.io.BufferedOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.HashSet;
import java.util.Set;

import com.util.MyUtil;

public class FileServerSocket {
	private static FileServerSocket instance;
	
	private ServerSocket server;
	private Socket client;
	
	private int port;
	public static boolean serverWorkingFlag = true;

	public String filePath;
	private DataOutputStream dos;	//socket�����
	private DataInputStream dis;	//socket������
	private BufferedOutputStream fileBos;	//�����ļ������
	
	public static StringBuilder errorInfo = new StringBuilder();	//server������Ϣ����
	
	public static String fileReceiveSuccessInfo = null;	//�ļ��Ƿ���ճɹ��ı�־;
	
	public static Set<Integer> socketServerUsingPortList = new HashSet<Integer>();	//����socketServer�ɹ������Ķ˿�,�����ͬһ�˿ڵ��ظ�����������쳣
	
	private FileServerSocket(){
	}

	public static FileServerSocket getInstance(){
		if(instance == null){
			instance = new FileServerSocket();
		}
		return instance;
	}
	
	public void init(int port, String filePath){
		FileServerSocket.serverWorkingFlag = true;
		fileReceiveSuccessInfo = null;
		FileServerSocket.errorInfo = new StringBuilder();
		
		this.setPort(port);
		this.setFilePath(filePath);
		try {
			if(!socketServerUsingPortList.contains(this.port)){
				server = new ServerSocket(this.port);
				socketServerUsingPortList.add(port);
			}
			errorInfo.append(addPrefix("socket�������ڼ����˿�:"+port+",�ȴ��ͻ�������!"));
		} catch (IOException e) {
			errorInfo.append(addPrefix("socket������ʧ��!��ȷ���˿�: " + port + " δ��ʹ��!����¶˿ں��ٴγ���!"));
		}
	}
	
	public void service(){
		while(serverWorkingFlag){
			if(server != null){
				try {
					client = server.accept();
				} catch (IOException e) {
					errorInfo.append(addPrefix("����IO�쳣,�볢����������ServerSocket"));
				}
			}
			try {
				if(client != null){
					errorInfo.append(addPrefix("�ͻ���: " + client.getInetAddress().getHostAddress()+":"+client.getPort() +" �Ѿ��뱾���ɹ���������!"));
					errorInfo.append(addPrefix("׼����������ͬ��!"));

					dis = new DataInputStream(client.getInputStream());
					dos = new DataOutputStream(client.getOutputStream());
					
					//�������ʧ��,�ڿͻ��˵�Э���½����ļ��ش�
					if(!doReceiveOnce()){
						doReceiveOnce();
					}//���ճɹ�,�Զ��ر�Server
					else{
						serverWorkingFlag = false;	
						errorInfo.append(addPrefix("�ļ�����ɹ�!socket���񼴽��Զ��ر�!"));
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally{
				try {
					if(dos != null){
						dos.close();
					}
					if(dis != null){
						dis.close();
					}
					if(client != null){
						client.close();
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	/**
	 * ��ͻ��˵�һ�ν������̣�
	 * 		1.�����ļ���->�����ļ���->ok:next;error:redo;
	 * 		2.�����ļ�����->�����ļ�����->ok:next;error:redo;
	 * 		3.���������ļ�->�����ɹ�:next;ʧ��:redo;
	 * 		4.�����ļ�->���պ���ļ��ĳ���==�������̲ſ�ʼʱ���յ����ļ�����?"ok:done":"error:redo";
	 * 		5.�������������������3��,3�ξ�ʧ�ܺ�Ķ�����:�رտͻ���socket,������ʾ;
	 */
	public boolean doReceiveOnce() throws IOException{
		boolean flag = false;
		fileReceiveSuccessInfo = null;
		
		String fileName = dis.readUTF();
		dos.writeUTF(fileName);
		errorInfo.append(addPrefix("�ļ�����֤������..."));
		//�ļ�����֤ʧ��,��������
		if(!dis.readBoolean()){
			errorInfo.append(addPrefix("�ļ�����֤ʧ��!׼�����´���!"));
				return false;
			}
			errorInfo.append(addPrefix("�ļ�����֤�ɹ�!"));
			
			errorInfo.append(addPrefix("�ļ�������֤������..."));
			long fileLength = dis.readLong();
			
			dos.writeLong(fileLength);
			//�ļ�����֤ʧ��,��������
			if(!dis.readBoolean()){
				errorInfo.append(addPrefix("�ļ�������֤ʧ��!׼�����´���!"));
				return false;
			}
			errorInfo.append(addPrefix("�ļ�������֤�ɹ�!"));

			//�����ļ�
			File file = null;
			try {
				file = new File(filePath + File.separator + fileName);
				//�ļ������ɹ�,׼������
				dos.writeBoolean(true);	
			} catch (Exception e) {
				//�ļ�����ʧ�ܣ�����һ��
				dos.writeBoolean(false);
				return false;
			}
		
			errorInfo.append(addPrefix("�ļ������ɹ�,׼�������ļ�("+ fileLength +"�ֽ�)..."));

			//���������ļ������
			fileBos = new BufferedOutputStream(new FileOutputStream(file, false));
			byte[] buffer = new byte[1024];
			int readCursor = -1;
			while((readCursor = dis.read(buffer)) != -1){
				fileBos.write(buffer, 0, readCursor);
				errorInfo.append(addPrefix("�ļ�������..."));
				if(readCursor < 1024){
					if(fileBos!=null){
						fileBos.close();
						errorInfo.append(addPrefix("�ļ��������,�رձ����ļ������!"));
					}
					break;
				}
			}
			
			//�ļ��������,��֤���յ����ļ��ĳ���,�粻��ȷ,�ȴ��ط�
			boolean fileOk = file.length() == fileLength;
			dos.writeBoolean(fileOk);
			if(!fileOk){
				flag = false;
				errorInfo.append(addPrefix("������ļ����� �� �ʼ���յ����ļ��ĳ��Ȳ�һ��,�ж����δ���ʧ�ܣ��������´���!"));
			}else{
				flag = true;
				//�ļ�����ɹ���,��fileReceiveSuccessInfo��ֵ,��ҳ�����interval��⵽�����ݵ�ֵ��Ϊ��ʱ,��Ϊ�ļ����ճɹ�,����������ļ��Ľ���
				fileReceiveSuccessInfo = fileName;
			}
			return flag;
	}
	
	public void stopService(){
		if(server != null){
			try {
				server.close();
				if(socketServerUsingPortList.contains(this.port)){
					socketServerUsingPortList.remove(this.port);
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		instance = null;
		errorInfo.append(addPrefix("socket�����Ѿ��ر�!�ȴ���һ������!"));
	}

	public int getPort() {
		return port;
	}
	public void setPort(int port) {
		this.port = port;
	}
	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	
	private String addPrefix(String data){
		return "<div class='errorInfoStyle1'>"+ MyUtil.formatMillis(System.currentTimeMillis()) + ": " + data + "</div>";
	}
}

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
			errorInfo.append(addPrefix("正在连接服务器: " + ip + ":" + port + " ..."));
			client = new Socket(ip, port);
			errorInfo.append(addPrefix("服务器: " + ip + ":" + port + "连接成功!准备进行数据通信!"));
		} catch (Exception e) {
			errorInfo.append(addPrefix("服务器: " + ip + ":" + port + "连接失败!请检查本机网络连接, 并确认服务器IP和端口输入正确!"));
		}
	}
	
	public boolean doTransmitOnce(){
		boolean flag = false;
		try {
			File file = new File(filePath);
			
			String fileName = file.getName();
			errorInfo.append(addPrefix("发送要传输的文件的文件名: " + fileName));
			dos.writeUTF(fileName);
			
			String fileNameChecked = dis.readUTF();
			
			boolean fileNameOk = fileName.equals(fileNameChecked);
			dos.writeBoolean(fileNameOk);
			if(!fileNameOk){
				errorInfo.append(addPrefix("文件名验证失败!将重新开始传送工作!"));
				return false;
			}
			errorInfo.append(addPrefix("文件名验证成功!"));

			long fileLength = file.length();
			errorInfo.append(addPrefix("发送要传输的文件的长度: " + fileLength));
			dos.writeLong(fileLength);
			
			long fileLengthChecked = dis.readLong();
			
			boolean fileLengthOk = fileLength == fileLengthChecked;
			dos.writeBoolean(fileLengthOk);
			if(!fileLengthOk){
				errorInfo.append(addPrefix("文件长度验证失败!将重新开始传送工作!"));
				return false;
			}
			errorInfo.append(addPrefix("文件长度验证成功!"));
			
			if(!dis.readBoolean()){
				errorInfo.append(addPrefix("服务器文件建立失败,无法接收文件数据!"));
				return false;
			}
			errorInfo.append(addPrefix("准备发送文件..."));
			
			byte[] buffer = new byte[1024];
			int readCursor = -1;
			while((readCursor = fileDis.read(buffer)) != -1){
				dos.write(buffer, 0, readCursor);
			}

			//文件传输完毕,根据服务器的反应判断是否需要重发
			boolean fileOk = dis.readBoolean();
			if(!fileOk){
				errorInfo.append(addPrefix("服务器认为本次传输失败,请求重发!"));
				flag = false;
			}else{
				errorInfo.append(addPrefix("文件传送成功,即将关闭!"));
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

				//建立本地文件输入流
				fileDis = new DataInputStream(new FileInputStream(filePath));
				dis = new DataInputStream(client.getInputStream());
				dos = new DataOutputStream(client.getOutputStream());
				
				if(!doTransmitOnce()){
					if(count < 3){
						doTransmitOnce();
						count++;
					}else{
						errorInfo.append(addPrefix("经过3次尝试,数据传送都不完整,请在网络质量得到保证后重试!"));
					}
				}else{
					errorInfo.append(addPrefix("本次传输在经过 "+(count+1)+" 次尝试后最终取得成功!"));
				}
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally{
			try {
				if(fileDis != null){
					fileDis.close();
					errorInfo.append(addPrefix("本地文件输入流关闭！"));
				}
				if(dos != null){
					dos.close();
					errorInfo.append(addPrefix("socket输出流关闭!"));
				}
				if(dis != null){
					dis.close();
					errorInfo.append(addPrefix("socket输入流关闭!"));
				}
				if(client != null){
					client.close();
					errorInfo.append(addPrefix("socket关闭!"));
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

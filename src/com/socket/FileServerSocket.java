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
	private DataOutputStream dos;	//socket输出流
	private DataInputStream dis;	//socket输入流
	private BufferedOutputStream fileBos;	//本地文件输出流
	
	public static StringBuilder errorInfo = new StringBuilder();	//server运行信息反馈
	
	public static String fileReceiveSuccessInfo = null;	//文件是否接收成功的标志;
	
	public static Set<Integer> socketServerUsingPortList = new HashSet<Integer>();	//保存socketServer成功监听的端口,避免对同一端口的重复监听引起的异常
	
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
			errorInfo.append(addPrefix("socket服务正在监听端口:"+port+",等待客户端连接!"));
		} catch (IOException e) {
			errorInfo.append(addPrefix("socket服务建立失败!请确保端口: " + port + " 未被使用!或更新端口后再次尝试!"));
		}
	}
	
	public void service(){
		while(serverWorkingFlag){
			if(server != null){
				try {
					client = server.accept();
				} catch (IOException e) {
					errorInfo.append(addPrefix("发生IO异常,请尝试重新启动ServerSocket"));
				}
			}
			try {
				if(client != null){
					errorInfo.append(addPrefix("客户端: " + client.getInetAddress().getHostAddress()+":"+client.getPort() +" 已经与本机成功建立连接!"));
					errorInfo.append(addPrefix("准备进行数据同步!"));

					dis = new DataInputStream(client.getInputStream());
					dos = new DataOutputStream(client.getOutputStream());
					
					//如果接收失败,在客户端的协调下进行文件重传
					if(!doReceiveOnce()){
						doReceiveOnce();
					}//接收成功,自动关闭Server
					else{
						serverWorkingFlag = false;	
						errorInfo.append(addPrefix("文件传输成功!socket服务即将自动关闭!"));
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
	 * 与客户端的一次交互过程：
	 * 		1.接收文件名->返回文件名->ok:next;error:redo;
	 * 		2.接收文件长度->返回文件长度->ok:next;error:redo;
	 * 		3.建立本地文件->建立成功:next;失败:redo;
	 * 		4.接收文件->接收后的文件的长度==交互过程才开始时接收到的文件长度?"ok:done":"error:redo";
	 * 		5.整个交互过程最多重试3次,3次均失败后的动作是:关闭客户端socket,给出提示;
	 */
	public boolean doReceiveOnce() throws IOException{
		boolean flag = false;
		fileReceiveSuccessInfo = null;
		
		String fileName = dis.readUTF();
		dos.writeUTF(fileName);
		errorInfo.append(addPrefix("文件名验证进行中..."));
		//文件名验证失败,重启接收
		if(!dis.readBoolean()){
			errorInfo.append(addPrefix("文件名验证失败!准备重新传输!"));
				return false;
			}
			errorInfo.append(addPrefix("文件名验证成功!"));
			
			errorInfo.append(addPrefix("文件长度验证进行中..."));
			long fileLength = dis.readLong();
			
			dos.writeLong(fileLength);
			//文件名验证失败,重启接收
			if(!dis.readBoolean()){
				errorInfo.append(addPrefix("文件长度验证失败!准备重新传输!"));
				return false;
			}
			errorInfo.append(addPrefix("文件长度验证成功!"));

			//建立文件
			File file = null;
			try {
				file = new File(filePath + File.separator + fileName);
				//文件建立成功,准备传输
				dos.writeBoolean(true);	
			} catch (Exception e) {
				//文件建立失败，再来一遍
				dos.writeBoolean(false);
				return false;
			}
		
			errorInfo.append(addPrefix("文件建立成功,准备接收文件("+ fileLength +"字节)..."));

			//建立本地文件输出流
			fileBos = new BufferedOutputStream(new FileOutputStream(file, false));
			byte[] buffer = new byte[1024];
			int readCursor = -1;
			while((readCursor = dis.read(buffer)) != -1){
				fileBos.write(buffer, 0, readCursor);
				errorInfo.append(addPrefix("文件接收中..."));
				if(readCursor < 1024){
					if(fileBos!=null){
						fileBos.close();
						errorInfo.append(addPrefix("文件接收完毕,关闭本地文件输出流!"));
					}
					break;
				}
			}
			
			//文件传输完毕,验证接收到的文件的长度,如不正确,等待重发
			boolean fileOk = file.length() == fileLength;
			dos.writeBoolean(fileOk);
			if(!fileOk){
				flag = false;
				errorInfo.append(addPrefix("保存的文件长度 和 最开始接收到的文件的长度不一致,判定本次传输失败，请求重新传送!"));
			}else{
				flag = true;
				//文件传输成功后,给fileReceiveSuccessInfo赋值,当页面监听interval监测到该数据的值不为空时,认为文件接收成功,将随后开启对文件的解析
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
		errorInfo.append(addPrefix("socket服务已经关闭!等待下一步操作!"));
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

package com.socket;

public class Test {
	public static void main(String[] args) {
		FileClientSocket clientSocket = FileClientSocket.getInstance();
		
		clientSocket.init("127.0.0.1", 9999, "C:/Users/bayer/a.txt");
		
		clientSocket.service();
		
	}
}

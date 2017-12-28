package com.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class NetSpeedUtil {
	public static int mockPingToGetDelay(String ip) throws IOException{
		Runtime runtime = Runtime.getRuntime();
		Process process = runtime.exec("ping " + ip);
		
		BufferedReader br = new BufferedReader(new InputStreamReader(process.getInputStream()));
		String data = null;
		String averageValue = null;
		while((data = br.readLine()) != null){
			if(data != null && !"".equals(data)){
				if(data.indexOf("Æ½¾ù") > -1){
					averageValue = data.substring(data.lastIndexOf("=") + 2, data.lastIndexOf("ms"));
				}else if(data.indexOf("average") > -1){
					averageValue = data.substring(data.indexOf("average") + 1, data.lastIndexOf("ms"));
				}
			}
		}
		br.close();
		
		int delay = Integer.MAX_VALUE;
		try {
			delay = Integer.parseInt(averageValue);
		} catch (Exception e) {
		}
		return delay;
	}
}

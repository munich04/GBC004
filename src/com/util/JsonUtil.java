package com.util;

import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;
import com.google.gson.stream.JsonReader;
import com.po.CarInfo;
import com.po.DailyInfo;

public class JsonUtil {

	public static String createJsonFile(String fileName, List<CarInfo> carInfoList, List<DailyInfo> dailyInfoList) {
		File file = new File(fileName);
		if(file.exists()){
			file.delete();
			try {
				file.createNewFile();
			} catch (IOException e) {
				fileName = "";
				e.printStackTrace();
			}
		}
		
		try {
			BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(file));
			JsonObject parent = new JsonObject();
			JsonArray dailyArray = new JsonArray();
			JsonArray carArray = new JsonArray();
			JsonObject jsonObject = null;
			int tmpLength = 0;
			
			if(dailyInfoList != null && dailyInfoList.size() > 0){
				tmpLength = dailyInfoList.size();
				DailyInfo dailyInfo = null;
				
				for (int i = 0; i < tmpLength; i++) {
					jsonObject = new JsonObject();
					dailyInfo = dailyInfoList.get(i);
					
					jsonObject.addProperty("id", dailyInfo.getId());
					jsonObject.addProperty("dailyNum", dailyInfo.getDailyNum());
					jsonObject.addProperty("carIDCardID", dailyInfo.getCarIDCardID());
					jsonObject.addProperty("mineName", dailyInfo.getMineName());
					jsonObject.addProperty("receiveDept", dailyInfo.getReceiveDept());
					jsonObject.addProperty("departure", dailyInfo.getDeparture());
					jsonObject.addProperty("grossWeight", dailyInfo.getGrossWeight());
					jsonObject.addProperty("tareWeight", dailyInfo.getTareWeight());
					jsonObject.addProperty("operator", dailyInfo.getOperator());
					jsonObject.addProperty("loadingInfo", dailyInfo.getLoadingInfo());
					jsonObject.addProperty("makingNotes", dailyInfo.getMakingNotes());
					jsonObject.addProperty("notes", dailyInfo.getNotes());
					jsonObject.addProperty("inTime", dailyInfo.getInTime());
					jsonObject.addProperty("outTime", dailyInfo.getOutTime());
					
					dailyArray.add(jsonObject);
				}
			}
			
			if(carInfoList != null && carInfoList.size() > 0){
				tmpLength = carInfoList.size();
				CarInfo carInfo = null;
				for (int i = 0; i < tmpLength; i++) {
					jsonObject = new JsonObject();
					carInfo = carInfoList.get(i);

					jsonObject.addProperty("id", carInfo.getId());
					jsonObject.addProperty("carIDCardID", carInfo.getCarIDCardID());
					jsonObject.addProperty("carDept", carInfo.getCarDept());
					jsonObject.addProperty("carNumber", carInfo.getCarNumber());
					jsonObject.addProperty("carDriver", carInfo.getCarDriver());
					jsonObject.addProperty("tareWeight", carInfo.getTareWeight());
					jsonObject.addProperty("recordTime", carInfo.getRecordTime());
					jsonObject.addProperty("carNotes", carInfo.getCarNotes());
					
					carArray.add(jsonObject);
				}
			}
			
			parent.add(MyUtil.JSONFile_PREFIX_CARINFO, carArray);
			parent.add(MyUtil.JSONFile_PREFIX_DAILYINFO, dailyArray);
			
			bos.write((parent.toString()).getBytes());
			bos.flush();
			if(bos != null){
				bos.close();
			}
		} catch (Exception e) {
			fileName = "";
		}
		return fileName;
	}

	public static Map<String, List> analyzeJsonData(String filePath) throws JsonSyntaxException, IOException {
		
		BufferedReader br = new BufferedReader(new FileReader(filePath));
		StringBuilder sb = new StringBuilder();
		while(br.ready()){
			sb.append(br.readLine());
		}
		if(br != null){
			br.close();
		}

		Map<String, List> map = new HashMap<String, List>();
		
		List<CarInfo> carInfoList = new ArrayList<CarInfo>();
		List<DailyInfo> dailyInfoList = new ArrayList<DailyInfo>();
		
		JsonReader jsonReader = new JsonReader(new StringReader(sb.toString()));
		jsonReader.beginObject();
		while(jsonReader.hasNext()){
			if(MyUtil.JSONFile_PREFIX_CARINFO.equals(jsonReader.nextName())){
				jsonReader.beginArray();
				while(jsonReader.hasNext()){
					jsonReader.beginObject();
					CarInfo carInfo = null;
					while(jsonReader.hasNext()){
						carInfo = new CarInfo();
						if(jsonReader.nextName().equals("id")){
							carInfo.setId(jsonReader.nextString());
						}
						if(jsonReader.nextName().equals("carIDCardID")){
							carInfo.setCarIDCardID(jsonReader.nextString());
						}
						if(jsonReader.nextName().equals("carDept")){
							carInfo.setCarDept(jsonReader.nextString());
						}
						if(jsonReader.nextName().equals("carNumber")){
							carInfo.setCarNumber(jsonReader.nextString());
						}
						if(jsonReader.nextName().equals("carDriver")){
							carInfo.setCarDriver(jsonReader.nextString());
						}
						if(jsonReader.nextName().equals("tareWeight")){
							carInfo.setTareWeight(jsonReader.nextDouble());
						}
						if(jsonReader.nextName().equals("recordTime")){
							carInfo.setRecordTime(jsonReader.nextLong());
						}
						if(jsonReader.nextName().equals("carNotes")){
							carInfo.setCarNotes(jsonReader.nextString());
						}
					}
					carInfoList.add(carInfo);
					jsonReader.endObject();
				}
				jsonReader.endArray();
			}
			if(MyUtil.JSONFile_PREFIX_DAILYINFO.equals(jsonReader.nextName())){
				jsonReader.beginArray();
				while(jsonReader.hasNext()){
					jsonReader.beginObject();
					DailyInfo dailyInfo = null;
					while(jsonReader.hasNext()){
						dailyInfo = new DailyInfo();
						if(jsonReader.nextName().equals("id")){
							dailyInfo.setId(jsonReader.nextString());
						}
						if(jsonReader.nextName().equals("dailyNum")){
							dailyInfo.setDailyNum(jsonReader.nextLong());
						}
						if(jsonReader.nextName().equals("carIDCardID")){
							dailyInfo.setCarIDCardID(jsonReader.nextString());
						}
						if(jsonReader.nextName().equals("mineName")){
							dailyInfo.setMineName(jsonReader.nextString());
						}
						if(jsonReader.nextName().equals("receiveDept")){
							dailyInfo.setReceiveDept(jsonReader.nextString());
						}
						if(jsonReader.nextName().equals("departure")){
							dailyInfo.setDeparture(jsonReader.nextString());
						}
						if(jsonReader.nextName().equals("grossWeight")){
							dailyInfo.setGrossWeight(jsonReader.nextDouble());
						}
						if(jsonReader.nextName().equals("tareWeight")){
							dailyInfo.setTareWeight(jsonReader.nextDouble());
						}
						if(jsonReader.nextName().equals("operator")){
							dailyInfo.setOperator(jsonReader.nextString());
						}
						if(jsonReader.nextName().equals("loadingInfo")){
							dailyInfo.setLoadingInfo(jsonReader.nextString());
						}
						if(jsonReader.nextName().equals("makingNotes")){
							dailyInfo.setMakingNotes(jsonReader.nextString());
						}
						if(jsonReader.nextName().equals("notes")){
							dailyInfo.setNotes(jsonReader.nextString());
						}
						if(jsonReader.nextName().equals("inTime")){
							dailyInfo.setInTime(jsonReader.nextLong());
						}
						if(jsonReader.nextName().equals("outTime")){
							dailyInfo.setOutTime(jsonReader.nextLong());
						}
					}
					dailyInfoList.add(dailyInfo);
					jsonReader.endObject();
				}
				jsonReader.endArray();
			}
		}
		jsonReader.endObject();
		
		map.put(MyUtil.JSONFile_PREFIX_CARINFO, carInfoList);
		map.put(MyUtil.JSONFile_PREFIX_DAILYINFO, dailyInfoList);
		
		return map;
	}
}

package com.util.test;

import java.io.FileWriter;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import com.vo.DailyLoadInfoVO;

public class ExportToTxt {
	public static String[] exportToExcel(String filePath, String[] titles,
			List<DailyLoadInfoVO> dailyLoadInfoList) {

		String fileName = null;
		String errorInfo = null;

		FileWriter fw=null;
		
		StringBuffer str=null;
		DailyLoadInfoVO infoVO = null;

		try {
			fileName = filePath;
			fw=new FileWriter(fileName);
			str=new StringBuffer();			
			// ����Txt�ı�
	

	   
	       int titleLength = titles.length;
			int listSize = dailyLoadInfoList.size();

		/*		
			 //��ӱ���
			for (int i = 0; i < titleLength; i++) {
				if(i==titleLength-1)
				   str.append(titles[i]+"\r\n");
				else
					str.append(titles[i]+"\t");
			}
			fw.write(str.toString());*/

		
			// �������
			for (int i = 1; i <= listSize; i++) {
				infoVO = dailyLoadInfoList.get(i - 1);
                str=new StringBuffer();
				
                String timeInfo=infoVO.getOutTimeVOToLocalString().substring(0, 10).replace("-", "");
                long num=infoVO.getDailyNumVO();
                //�˵����
                String endTimeInfo="";
                if(num<10){
                	endTimeInfo=timeInfo+"00"+num;
                }else if(num>=10&&num<100){
                	endTimeInfo=timeInfo+"0"+num;
                }else if(num>=100){
                	endTimeInfo=timeInfo+""+num;
                }
               
                
               
                fw.write(String.valueOf(infoVO.getOutTimeVOToLocalString().substring(0, 10))+",");
                fw.write(String.valueOf(endTimeInfo+","));
                fw.write(String.valueOf(infoVO.getCarNumberVO())+",");
                fw.write(String.valueOf(infoVO.getDepartureVO())+",");
                fw.write(String.valueOf(infoVO.getReceiveDeptVO())+",");
                fw.write(String.valueOf(infoVO.getMineNameVO())+",");
                fw.write(String.valueOf(infoVO.getGrossWeightVO())+",");
                fw.write(String.valueOf(infoVO.getTareWeightVO())+",");
                fw.write(String.valueOf(infoVO.getNetWeightVO())+"\r\n");
                
               
			}
            fw.flush();
			
		}catch (IOException e) {
			fileName = null;
			errorInfo = "�ļ���д������رմ򿪵�txt�ı��ļ������ԣ�";
			e.printStackTrace();
		} finally {
			try {
				if(fw != null){
					fw.close();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return new String[] { fileName.replace("\\", "/"), errorInfo };
	}
}

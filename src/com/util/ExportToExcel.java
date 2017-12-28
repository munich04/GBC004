package com.util;

import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;

import jxl.Workbook;
import jxl.write.Label;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import jxl.write.biff.RowsExceededException;

import com.vo.DailyLoadInfoVO;

public class ExportToExcel {
	public static String[] exportToExcel(String filePath, String[] titles,
			List<DailyLoadInfoVO> dailyLoadInfoList) {

		String fileName = null;
		String errorInfo = null;

		BufferedOutputStream bos = null;
		WritableWorkbook wwb = null;
		Label label = null;
		DailyLoadInfoVO infoVO = null;

		try {
			fileName = filePath;
			bos = new BufferedOutputStream(new FileOutputStream(filePath));
			// 创建Excel工作薄

			wwb = Workbook.createWorkbook(bos);

			// 添加第一个工作表并设置第一个Sheet的名字
			WritableSheet sheet = wwb.createSheet("每日清单", 0);

			int titleLength = titles.length;
			int listSize = dailyLoadInfoList.size();

			for (int i = 0; i < titleLength; i++) {
				// Label(x,y,z) 代表单元格的第x+1列，第y+1行, 内容z
				// 在Label对象的子对象中指明单元格的位置和内容

				// 添加标题
				label = new Label(i, 0, titles[i]);
				sheet.addCell(label);
			}

			// 添加数据
			for (int i = 1; i <= listSize; i++) {
				infoVO = dailyLoadInfoList.get(i - 1);

				label = new Label(0, i, String.valueOf(infoVO.getDailyNumVO()));
				sheet.addCell(label);

				label = new Label(1, i, infoVO.getOutTimeVOToLocalString());
				sheet.addCell(label);

				label = new Label(2, i, infoVO.getDepartureVO());
				sheet.addCell(label);

				label = new Label(3, i, infoVO.getReceiveDeptVO());
				sheet.addCell(label);

				label = new Label(4, i, infoVO.getCarDeptVO());
				sheet.addCell(label);

				label = new Label(5, i, infoVO.getCarNumberVO());
				sheet.addCell(label);

				label = new Label(6, i, infoVO.getCarDriverVO());
				sheet.addCell(label);

				label = new Label(7, i, infoVO.getMineNameVO());
				sheet.addCell(label);

				label = new Label(8, i, String.valueOf(infoVO
						.getGrossWeightVO()));
				sheet.addCell(label);

				label = new Label(9, i, String
						.valueOf(infoVO.getTareWeightVO()));
				sheet.addCell(label);

				label = new Label(10, i, String
						.valueOf(infoVO.getNetWeightVO()));
				sheet.addCell(label);

				label = new Label(11, i, "吨");
				sheet.addCell(label);

				label = new Label(12, i, infoVO.getOperatorVO());
				sheet.addCell(label);

				label = new Label(13, i, infoVO.getLoadingInfoVO());
				sheet.addCell(label);

				label = new Label(14, i, infoVO.getMakingNotesVO());
				sheet.addCell(label);
			}

			wwb.write();
			
		} catch (RowsExceededException e) {
			fileName = null;
			e.printStackTrace();
		} catch (WriteException e) {
			fileName = null;
			e.printStackTrace();
		} catch (IOException e) {
			fileName = null;
			errorInfo = "文件读写错误！请关闭打开的Excel文件后重试！";
			e.printStackTrace();
		} finally {
			try {
				if(wwb != null){
					wwb.close();
				}
				if(bos != null){
					bos.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			} catch (WriteException e) {
				e.printStackTrace();
			}
		}
		return new String[] { fileName.replace("\\", "/"), errorInfo };
	}
}

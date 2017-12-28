package com.dao;

import java.util.List;

import com.po.DailyInfo;
import com.po.ExportDateAssistant;
import com.po.SystemLogInfo;
import com.util.Page;
import com.vo.DailyLoadInfoVO;
import com.vo.DailySearchVO;

public interface DailyDao {
	public int count(Class clazz);
	public List<DailyLoadInfoVO> listDaily(Page page, String orderBy, DailySearchVO dailySearchVO);
	public void saveOrUpdateDaily(DailyInfo DailyInfo);
	public DailyInfo loadDailyInfo(String id);
	//�õ�"�����","ID����ΪcarIDCardID��"������"δ����"��¼;
	public List<DailyInfo> getUnLeftDailyInfoByCarIDCardID(String carIDCardID);
	//�õ�"�����","ID����ΪcarIDCardID��"������"�ѳ���"��¼;
	public List<DailyInfo> getFinishedDailyInfoByCarIDCardID(String carIDCardID);
	//�������������ձ��
	public Long calculateDailyNum();
	public List<DailyLoadInfoVO> loadDailyLoadInfoVOByID(String idVO, boolean hasFinished);
	public Long countDailyInfoDuringSpecifidPeroid(Long startMillis, Long endMillis, boolean hasFinished);
	public List countWeightOfMineTransferedDuringSpecifidPeroid(Long startMillis, Long endMillis);
	public void saveOrUpdateExportDateAssistant(ExportDateAssistant exportDateAssistant);
	//��ȡ��һ�ε������ݵĽ�ֹ����
	public List<ExportDateAssistant> getLastExportDate();
	public List<DailyInfo> listHangUpDailyInfo();
	public void deleteDailyInfoToRecycledBin(DailyInfo dailyInfo);
	public void saveOrUpdateSystemLog(SystemLogInfo systemLog);
}

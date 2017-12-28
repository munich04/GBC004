package com.manager;

import java.util.List;

import com.po.DailyInfo;
import com.util.Page;
import com.vo.DailyLoadInfoVO;
import com.vo.DailySearchVO;

public interface DailyManager {

	public void saveOrUpdateDaily(DailyInfo dailyInfo);
	
	public List<DailyLoadInfoVO> listDaily(Page page, String orderBy, DailySearchVO dailySearchVO);

	public DailyInfo loadDailyInfo(String id);
	
	/**
	 * ˢ����,��ѯ�жϱ������(����)��Ҫ���������;
	 * @param carIDCardID �󳵵�ID����
	 * @return 'in',����Ҫ����;'out',����Ҫ���
	 */
	public String checkIfTheCarHasnotLeave(String carIDCardID);
	
	public String calculateDailyNum();
	
	//�������ʱ,ͨ��carIDCardID��ѯ����ʱ����д��������,�磺����ʱ��,����ʱ�Ƶõ�ë��,�ձ�ŵ�
	//����ͬ��������,�޷�ͨ��"IDCardID","����","����ʱ�䲻Ϊ��","�뿪ʱ��Ϊ��"ֱ��ͨ��sql��þ�ȷ��DailyInfo����;
	//�ؼ����ڣ��޷�ʹ��SQL�ж�"�뿪ʱ��Ϊ��"
	public DailyInfo loadEnteredDailyInfoByCarIDCardID(String carIDCardID);

	//���б�ҳ�浥�����޸Ŀ�������;
	//��Ҫ���ϲ��DailyInfo��CarInfo,��Ҳ��VO��DailyLoadInfoVO������ԭ��
	//ע�⣺��Ҫ�������hasFinished,��ָʾҪ��ѯ��������ɻ���Ϊ��ɵĿ�������;
	public DailyLoadInfoVO loadDailyLoadInfoVOByID(String idVO, boolean hasFinished);

	//��ѯĳʱ����������(true)��δ���(false)�Ŀ��˴���
	public Long countDailyInfoDuringSpecifidPeroid(Long startMillis, Long endMillis, boolean hasFinished);

	//��ѯĳʱ�����δ���͵Ŀ���Ķ���
	public List countWeightOfMineTransferedDuringSpecifidPeroid(Long startMillis, Long endMillis);

	public String[] exportDailyInfo(String absoluteFilePath, DailySearchVO dailySearchVO);
	
	//2011-7-10ʵ��
	public String[] exportDailyInfoToTxt(String absoluteFilePath, DailySearchVO dailySearchVO);

	public List<String> listExcelOrTxtFiles(String downloadType, String absoluteFilePath, Page page);

	public void deleteDaily(String userId, String entryID);
}	

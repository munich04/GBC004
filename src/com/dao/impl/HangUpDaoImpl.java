package com.dao.impl;

import java.util.List;

import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.dao.HangUpDao;
import com.po.HangUpOperation;
import com.po.SystemLogInfo;
import com.vo.HangUpOperationVO;

public class HangUpDaoImpl extends HibernateDaoSupport implements HangUpDao{

	public void saveOrUpdateHangUp(HangUpOperation hangUpOperation) {
		getHibernateTemplate().saveOrUpdate(hangUpOperation);
	}

	public List<HangUpOperationVO> getHangUpOperationsByDailyInfoID(String dailyInfoID) {
		return getHibernateTemplate().find("select new com.vo.HangUpOperationVO(hangUp.operateTime, hangUp.operateNotes, hangUp.hangUpState, user.id, user.nickName, user.authority) from com.po.HangUpOperation as hangUp, com.po.UserInfo as user where user.id=hangUp.operator and hangUp.dailyInfoID = ? order by hangUp.operateTime desc", dailyInfoID);
	}

	public void saveOrUpdateSystemLog(SystemLogInfo systemLog) {
		getHibernateTemplate().saveOrUpdate(systemLog);
	}
}

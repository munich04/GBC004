package com.dao.impl;

import java.sql.SQLException;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.dao.SystemLogDao;
import com.po.CarInfo;
import com.po.SystemLogInfo;
import com.po.UserInfo;
import com.util.Page;

public class SystemLogDaoImpl extends HibernateDaoSupport implements SystemLogDao {

	public int count(Class clazz) {
		String queryString = "select count(*) from " + clazz.getName();
		List list = this.getHibernateTemplate().find(queryString);
		return list != null ? ((Long)list.get(0)).intValue() : 0;
	}
	
	@SuppressWarnings("unchecked")
	public List<SystemLogInfo> listSystemLog(final Page page, final String orderBy) {
		return (List<SystemLogInfo>)this.getHibernateTemplate().executeFind(new HibernateCallback(){
			
			public Object doInHibernate(Session session) throws HibernateException, SQLException {
				StringBuilder queryString = new StringBuilder();
				
				queryString.append("from com.po.SystemLogInfo as s, com.po.UserInfo as u where u.id = s.userInfoId ");
			
				Query query = session.createQuery("select count(*) " + queryString.toString());
				if(page != null){
					page.setDataSum(((Long)query.list().get(0)).intValue());
					query = null;
				}

				queryString.append(" order by " + ((orderBy == null || orderBy.equals("")) ? "s.recordTime desc" : orderBy));
				String selectStr = "select new com.po.SystemLogInfo(s.id, s.infoType, s.infoDetail, s.recordTime, u.userName) ";
				query = session.createQuery(selectStr + queryString.toString());
				if(page != null){
					query.setFirstResult(page.getFirstData() - 1);
					query.setMaxResults(page.getPageSize());
				}
				queryString = null;
				
				return query.list();
			}});
	}

	public SystemLogInfo loadSystemLog(String id) {
		return (SystemLogInfo) getHibernateTemplate().load(SystemLogInfo.class, id);
	}

	public void deleteSystemLog(String id) {
		getHibernateTemplate().delete(this.loadSystemLog(id));
	}

	public String loadUsernameByUserId(String userId) {
		String username = "";
		UserInfo userInfo = (UserInfo) getHibernateTemplate().load(UserInfo.class, userId);
		if(userInfo != null){
			username = userInfo.getUserName();
		}
		return username;
	}

	public void saveOrUpdateSystemLog(SystemLogInfo systemLog) {
		getHibernateTemplate().saveOrUpdate(systemLog);
	}
}

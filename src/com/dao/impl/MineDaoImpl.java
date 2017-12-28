package com.dao.impl;

import java.sql.SQLException;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.dao.MineDao;
import com.po.MineInfo;
import com.util.Page;

public class MineDaoImpl extends HibernateDaoSupport implements MineDao{

	public int count(Class clazz) {
		String queryString = "select count(*) from " + clazz.getName();
		List list = this.getHibernateTemplate().find(queryString);
		return list!=null?((Long)list.get(0)).intValue():0;
	}
	
	public void deleteMine(MineInfo mineInfo) {
		getHibernateTemplate().delete(mineInfo);
	}

	@SuppressWarnings("unchecked")
	public List<MineInfo> listMine(final Page page, final String orderBy) {
		if(page != null){
			page.setDataSum(this.count(MineInfo.class));
		}
		return (List<MineInfo>) getHibernateTemplate().execute(new HibernateCallback(){
			public Object doInHibernate(Session session) throws HibernateException, SQLException {
				String queryString = "from com.po.MineInfo order by " + (orderBy != null && !"".equals(orderBy) ? orderBy : "recordTime desc");
			
				Query query = session.createQuery(queryString);
				if(page != null){
					query.setFirstResult(page.getFirstData() - 1);
					query.setMaxResults(page.getPageSize());
				}
				return query.list();
			}});
	}

	public void saveOrUpdateMine(MineInfo mineInfo) {
		getHibernateTemplate().saveOrUpdate(mineInfo);
	}

	public MineInfo loadMineInfo(String id) {
		return (MineInfo) getHibernateTemplate().load(MineInfo.class, id);
	}

	public List<MineInfo> getMineListByMineCode(String mineCode) {
		return getHibernateTemplate().find("from com.po.MineInfo where code = ? order by recordTime asc", mineCode);
	}
}

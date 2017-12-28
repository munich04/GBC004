package com.dao.impl;

import java.sql.SQLException;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.dao.UserDao;
import com.po.UserInfo;
import com.util.MyUtil;
import com.util.Page;
import com.vo.UserSearchVO;

public class UserDaoImpl extends HibernateDaoSupport implements UserDao{
	
	public int count(Class clazz) {
		String queryString = "select count(*) from " + clazz.getName();
		List list = this.getHibernateTemplate().find(queryString);
		return list!=null?((Long)list.get(0)).intValue():0;
	}

	@SuppressWarnings("unchecked")
	public List<UserInfo> listUser(final Page page, final String orderBy, final Integer authority, final UserSearchVO userSearchVO){
		
		return (List<UserInfo>) this.getHibernateTemplate().execute(new HibernateCallback(){

			public Object doInHibernate(Session session) throws HibernateException, SQLException {
				Query query = null;
				
				StringBuilder querySql = new StringBuilder();
				StringBuilder pageSql = new StringBuilder();
				
				querySql.append("from com.po.UserInfo");
				pageSql.append("from com.po.UserInfo");
				
				if(authority == MyUtil.AUTHORITY_SOVEREIGNTY.intValue()){
					querySql.append(" where authority != " + MyUtil.AUTHORITY_SOVEREIGNTY);
					pageSql.append(" where authority != " + MyUtil.AUTHORITY_SOVEREIGNTY);
				}else if(authority == MyUtil.AUTHORITY_HIGH.intValue()){
					querySql.append(" where (authority = " + MyUtil.AUTHORITY_MIDDLE + " or authority = " + MyUtil.AUTHORITY_LOW + ") ");
					pageSql.append(" where (authority = " + MyUtil.AUTHORITY_MIDDLE + " or authority = " + MyUtil.AUTHORITY_LOW + ") ");
				}else if(authority == MyUtil.AUTHORITY_MIDDLE.intValue()){
					querySql.append(" where authority = " + MyUtil.AUTHORITY_LOW);
					pageSql.append(" where authority = " + MyUtil.AUTHORITY_LOW);
				}
				
				if(userSearchVO.getNickNameVO() != null && !"".equals(userSearchVO.getNickNameVO())){
					querySql.append(" and nickName like '%"+ userSearchVO.getNickNameVO() +"%'");
					pageSql.append(" and nickName like '%"+ userSearchVO.getNickNameVO() +"%'");
				}
				if(userSearchVO.getAuthorityVO() != null){
					querySql.append(" and authority = " + userSearchVO.getAuthorityVO());
					pageSql.append(" and authority = " + userSearchVO.getAuthorityVO());
				}
				
				if(page != null){		
					query = session.createQuery("select count(*) " + pageSql.toString());
					page.setDataSum(((Long)query.list().get(0)).intValue());
					query = null;
				}
				
				querySql.append(" order by registerTime desc");
				query = session.createQuery(querySql.toString());
				if(page != null){
					query.setFirstResult(page.getFirstData() - 1);
					query.setMaxResults(page.getPageSize());
				}
				return query.list();
			}});
	}

	public void saveOrUpdateUser(UserInfo userInfo) {
		getHibernateTemplate().saveOrUpdate(userInfo);
	}
	
	public List<UserInfo> loadUserInfoByNamePwd(String userName, String passWord) {
		return getHibernateTemplate().find("from com.po.UserInfo where userName=? and password=?", new Object[]{userName, passWord});
	}

	public void impartAuthorityForUsers(Integer authorityLevel, String[] userIDs) {
		getHibernateTemplate().bulkUpdate("update com.po.UserInfo set authority = ?  where id in ("+ MyUtil.StringArrayToString(userIDs) +")", new Object[]{authorityLevel, });
	}

	public UserInfo loadUserByEntryID(String entryID) {
		return (UserInfo) getHibernateTemplate().load(UserInfo.class, entryID);
	}
}

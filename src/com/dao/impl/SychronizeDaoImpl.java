package com.dao.impl;

import java.sql.SQLException;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.dao.SychronizeDao;
import com.po.CarInfo;
import com.po.DailyInfo;
import com.po.IpInfo;
import com.po.PortInfo;

public class SychronizeDaoImpl extends HibernateDaoSupport implements SychronizeDao{

	public List<DailyInfo> getDailyInfoAddedAtOneDay(Long startMillis, Long endMillis) {
		return getHibernateTemplate().find("from com.po.DailyInfo where inTime > ? and inTime < ? and outTime is not null", new Object[]{startMillis, endMillis});
	}

	public List<CarInfo> getCarInfoAddedAtOneDay(Long startMillis, Long endMillis) {
		return getHibernateTemplate().find("from com.po.CarInfo where recordTime > ? and recordTime < ?", new Object[]{startMillis, endMillis});
	}
	
	public List countCarInfoAddedAtOneDay(Long startMillis, Long endMillis) {
		return getHibernateTemplate().find("select count(*) from com.po.DailyInfo where inTime > ? and inTime < ? and outTime is not null", new Object[]{startMillis, endMillis});
		
	}

	public List countDailyInfoAddedAtOneDay(Long startMillis, Long endMillis) {
		return getHibernateTemplate().find("select count(*) from com.po.DailyInfo where inTime > ? and inTime < ? and outTime is not null", new Object[]{startMillis, endMillis});
	}

	public void deleteDailyInfoListOfOneDay(Long startMillis, Long endMillis) {
		List<DailyInfo> dailyInfoList = this.getDailyInfoAddedAtOneDay(startMillis, endMillis);
		if(dailyInfoList != null && dailyInfoList.size() > 0){
			getHibernateTemplate().deleteAll(dailyInfoList);
		}
	}

	public void deleteCarInfoListOfOneDay(Long startMillis, Long endMillis) {
		List<CarInfo> carInfoList = this.getCarInfoAddedAtOneDay(startMillis, endMillis);
		if(carInfoList != null && carInfoList.size() > 0){
			getHibernateTemplate().deleteAll(carInfoList);
		}
	}
	
	public void addDailyInfoListOfOneDay(List<DailyInfo> dailyInfoList) {
		if(dailyInfoList != null && dailyInfoList.size() > 0){
			for (DailyInfo dailyInfo : dailyInfoList) {
				getHibernateTemplate().save(dailyInfo);
			}
		}
	}
	
	public void addCarInfoListOfOneDay(List<CarInfo> carInfoList) {
		if(carInfoList != null && carInfoList.size() > 0){
			for (CarInfo carInfo : carInfoList) {
				getHibernateTemplate().save(carInfo);
			}
		}
	}

	@SuppressWarnings("unchecked")
	public List<IpInfo> getLatestUsedIp(final Integer number) {
		return getHibernateTemplate().executeFind(new HibernateCallback(){

			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {
				String querySql = "from com.po.IpInfo order by recordTime desc";
				Query query = session.createQuery(querySql);
				query.setMaxResults(number);
				return query.list();
			}});
	}

	@SuppressWarnings("unchecked")
	public List<PortInfo> getLatestUsedPort(final Integer number) {
		return getHibernateTemplate().executeFind(new HibernateCallback(){

			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {
				String querySql = "from com.po.PortInfo order by recordTime desc";
				Query query = session.createQuery(querySql);
				query.setMaxResults(number);
				return query.list();
			}});
	}

	public void saveIpInfo(IpInfo ipInfo) {
		getHibernateTemplate().save(ipInfo);
	}

	public void savePortInfo(PortInfo portInfo) {
		getHibernateTemplate().save(portInfo);
	}

	public List getIpInfoListByIpAndPort(String ip, Integer port) {
		return getHibernateTemplate().find("select count(*) from com.po.IpInfo where ip = ? and port = ?", new Object[]{ip, port});
	}

	public List getPortInfoListByPort(Integer port) {
		return getHibernateTemplate().find("select count(*) from com.po.PortInfo where port = ?", new Object[]{port});
	}

	public void deleteIpInfoByIpAndPort(String ip, Integer port) {
		List<IpInfo> ipInfoList = getHibernateTemplate().find("from com.po.IpInfo where ip = ? and port = ?", new Object[]{ip, port});
		if(ipInfoList != null && ipInfoList.size() > 0){
			getHibernateTemplate().deleteAll(ipInfoList);
		}
	}

	public void deletePortInfoByPort(Integer port) {
		List<PortInfo> portInfoList = getHibernateTemplate().find("from com.po.PortInfo where port = ?", new Object[]{port});
		if(portInfoList != null && portInfoList.size() > 0){
			getHibernateTemplate().deleteAll(portInfoList);
		}
	}
}

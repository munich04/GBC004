package com.dao.impl;

import java.sql.SQLException;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.dao.CarDao;
import com.po.CarInfo;
import com.util.Page;
import com.vo.CarSearchVO;

public class CarDaoImpl extends HibernateDaoSupport implements CarDao{
	
	public int count(Class clazz) {
		String queryString = "select count(*) from " + clazz.getName();
		List list = this.getHibernateTemplate().find(queryString);
		return list!=null?((Long)list.get(0)).intValue():0;
	}

	public void saveOrUpdateCar(CarInfo carInfo) {
		getHibernateTemplate().saveOrUpdate(carInfo);
	}

	@SuppressWarnings("unchecked")
	public List<CarInfo> listCar(final Page page, final String orderBy, final CarSearchVO carSearchVO) {
		
		page.setDataSum(this.count(CarInfo.class));
		
		return (List<CarInfo>)this.getHibernateTemplate().executeFind(new HibernateCallback(){

			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {
				StringBuilder queryString = new StringBuilder();
				
				queryString.append("from com.po.CarInfo where 1=1 ");
				
				if(carSearchVO.getCarNumber() != null && !"".equals(carSearchVO.getCarNumber())){
					queryString.append(" and carNumber like '%" + carSearchVO.getCarNumber() + "%'");
				}
				if(carSearchVO.getCarIDCardID() != null && !"".equals(carSearchVO.getCarIDCardID())){
					queryString.append(" and carIDCardID = '" + carSearchVO.getCarIDCardID() + "'");
				}
				if(carSearchVO.getCarDept() != null && !"".equals(carSearchVO.getCarDept())){
					queryString.append(" and carDept like '%" + carSearchVO.getCarDept() + "%'");
				}
				if(carSearchVO.getCarDriver() != null && !"".equals(carSearchVO.getCarDriver())){
					queryString.append(" and carDriver like '%" + carSearchVO.getCarDriver() + "%'");
				}
				if(carSearchVO.getCarLowerWeight() != null){
					queryString.append(" and tareWeight >= " + carSearchVO.getCarLowerWeight());
				}
				if(carSearchVO.getCarHigherWeight() != null){
					queryString.append(" and tareWeight <= " + carSearchVO.getCarHigherWeight());
				}
				
				queryString.append(" order by " + ((orderBy == null || orderBy.equals("")) ? "recordTime" : orderBy) + " desc");
			
				Query query = session.createQuery("select count(*) " + queryString.toString());
				if(page != null){
					page.setDataSum(((Long)query.list().get(0)).intValue());
					query = null;
				}
				
				query = session.createQuery(queryString.toString());
				if(page != null){
					query.setFirstResult(page.getFirstData() - 1);
					query.setMaxResults(page.getPageSize());
				}
				queryString = null;
				
				return query.list();
			}});
	}

	public CarInfo loadCarInfo(String id) {
		return (CarInfo) getHibernateTemplate().load(CarInfo.class, id);
	}

	public void deleteCar(String id) {
		getHibernateTemplate().delete(loadCarInfo(id));
	}

	public List getCarInfoByCarIDCardID(String carIDCardID) {
		return getHibernateTemplate().find("from com.po.CarInfo where carIDCardID = ?", carIDCardID);
	}
}

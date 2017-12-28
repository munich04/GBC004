package com.dao.impl;

import java.sql.SQLException;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.dao.DailyDao;
import com.po.DailyInfo;
import com.po.ExportDateAssistant;
import com.po.SystemLogInfo;
import com.util.MyUtil;
import com.util.Page;
import com.vo.DailyLoadInfoVO;
import com.vo.DailySearchVO;

public class DailyDaoImpl extends HibernateDaoSupport implements DailyDao{

	public int count(Class clazz) {
		String queryString = "select count(*) from " + clazz.getName();
		List list = this.getHibernateTemplate().find(queryString);
		return list!=null?((Long)list.get(0)).intValue():0;
	}

	@SuppressWarnings("unchecked")
	public List<DailyLoadInfoVO> listDaily(final Page page, final String orderBy, final DailySearchVO dailySearchVO) {
		return (List<DailyLoadInfoVO>)this.getHibernateTemplate().executeFind(new HibernateCallback(){

			public Object doInHibernate(Session session) throws HibernateException, SQLException {
				Query query = null;
				Long startMillis = dailySearchVO.getStartMillis();
				Long endMillis = dailySearchVO.getEndMillis();
				boolean hasFinished = dailySearchVO.isHasFinished();
				String carDriver = dailySearchVO.getCarDriver();
				String carDept = dailySearchVO.getCarDept();
				String carNumber = dailySearchVO.getCarNumber();
				Double lowerWeight = dailySearchVO.getLowerWeight();
				Double higherWeigher = dailySearchVO.getHigherWeight();
				Boolean hangUpState = dailySearchVO.getHangUpState();
				
				StringBuilder fromAndWhereSql = new StringBuilder();
				
				//查询已完成的拉矿记录
				if(hasFinished){
					fromAndWhereSql.append("from com.po.DailyInfo as daily, com.po.CarInfo as car, com.po.MineInfo as mine where daily.carIDCardID = car.carIDCardID and daily.mineName = mine.code and daily.deleteState = " + MyUtil.DELETE_FALSE + " ");
				}//查询未完成的拉矿记录
				else{
					fromAndWhereSql.append("from com.po.DailyInfo as daily, com.po.CarInfo as car where daily.carIDCardID = car.carIDCardID and daily.deleteState = " + MyUtil.DELETE_FALSE + " ");
				}
				
				if(carDriver != null && !"".equals(carDriver)){
					fromAndWhereSql.append(" and car.carDriver like '%" + carDriver + "%' ");
				}
				if(carDept != null && !"".equals(carDept)){
					fromAndWhereSql.append(" and car.carDept like '%" + carDept + "%' ");
				}
				if(carNumber != null && !"".equals(carNumber)){
					fromAndWhereSql.append(" and car.carNumber like '%" + carNumber + "%'");
				}
				if(lowerWeight != null ){
					fromAndWhereSql.append(" and daily.grossWeight-daily.tareWeight >= " + lowerWeight);
				}
				if(higherWeigher != null ){
					fromAndWhereSql.append(" and daily.grossWeight-daily.tareWeight <= " + higherWeigher);
				}
				
				if(hasFinished){
					fromAndWhereSql.append(" and daily.outTime is not null");
					if(startMillis != null ){
						fromAndWhereSql.append(" and daily.outTime > " + startMillis);
					}
					if(endMillis != null ){
						fromAndWhereSql.append(" and daily.outTime < " + endMillis);
					}
				}else{
					fromAndWhereSql.append(" and daily.outTime is null");
					if(startMillis != null ){
						fromAndWhereSql.append(" and daily.inTime > " + startMillis);
					}
					if(endMillis != null ){
						fromAndWhereSql.append(" and daily.inTime < " + endMillis);
					}
				}
				if(hangUpState != null){
					fromAndWhereSql.append(" and daily.hangUpState = " + hangUpState.booleanValue());
				}
				
				if(page != null){			
					query = session.createQuery("select count(*) " + fromAndWhereSql.toString());
					page.setDataSum(((Long)query.list().get(0)).intValue());
					query = null;
				}
				
				String aspectsSql = "";
				if(hasFinished){
					aspectsSql = "daily.id, daily.dailyNum, daily.carIDCardID, daily.mineName, mine.name, daily.receiveDept, daily.departure, daily.grossWeight, daily.tareWeight, daily.operator, daily.loadingInfo, daily.makingNotes, daily.notes, daily.inTime, daily.outTime, car.carDept, car.carNumber, car.carDriver, daily.hangUpState";
				}else{
					aspectsSql = "daily.id, daily.dailyNum, daily.carIDCardID, daily.mineName, daily.receiveDept, daily.departure, daily.grossWeight, daily.tareWeight, daily.operator, daily.loadingInfo, daily.makingNotes, daily.notes, daily.inTime, daily.outTime, car.carDept, car.carNumber, car.carDriver, daily.hangUpState";
				}
				String selectSql = "select new com.vo.DailyLoadInfoVO(" + aspectsSql + ") ";
				String orderBySql = " order by " + ((orderBy == null || orderBy.equals("")) ? "daily.outTime desc, daily.dailyNum desc " : orderBy);
				
				query = session.createQuery(selectSql + fromAndWhereSql.toString() + orderBySql);
				if(page != null){
					query.setFirstResult(page.getFirstData() - 1);
					query.setMaxResults(page.getPageSize());
				}
				
				return query.list();
			}});
	}

	public DailyInfo loadDailyInfo(String id) {
		return (DailyInfo) getHibernateTemplate().load(DailyInfo.class, id);
	}

	public void saveOrUpdateDaily(DailyInfo DailyInfo) {
		getHibernateTemplate().saveOrUpdate(DailyInfo);
	}
	
	//得到"今天的","ID卡号为carIDCardID的"卡车未出库记录;
	public List<DailyInfo> getUnLeftDailyInfoByCarIDCardID(String carIDCardID) {
		return getHibernateTemplate().find("from com.po.DailyInfo where carIDCardID = ? and inTime > ? and outTime is null and deleteState = 0 ", new Object[]{carIDCardID, MyUtil.getTodayStartMillis()});
	}
	
	//得到"今天的","ID卡号为carIDCardID的"卡车的"已出矿"记录;
	public List<DailyInfo> getFinishedDailyInfoByCarIDCardID(String carIDCardID) {
		return getHibernateTemplate().find("from com.po.DailyInfo where carIDCardID = ? and outTime is not null and outTime > ? and deleteState = 0 ", new Object[]{carIDCardID, MyUtil.getTodayStartMillis()});
	}

	public Long calculateDailyNum() {
		return (Long)getHibernateTemplate().find("select count(*) from com.po.DailyInfo where deleteState = 0 and inTime > " + MyUtil.getTodayStartMillis()).get(0);
	}

	//查询矿运的详细信息
	//注意：因为已完成的矿运有"mineName",需要关联到MineInfo查询矿物名称,而为完成的矿运没有"mineName",不需要也不能关联MineInfo进行查询;
	//		所以两种不同类型的矿运的查询sql有很大不同
	public List<DailyLoadInfoVO> loadDailyLoadInfoVOByID(String idVO, boolean hasFinished) {
		String queryString = "";
		if(hasFinished){
			queryString = "select new com.vo.DailyLoadInfoVO(daily.id, daily.dailyNum, daily.carIDCardID, daily.mineName, mine.name, daily.receiveDept, daily.departure, daily.grossWeight, daily.tareWeight, daily.operator, daily.loadingInfo, daily.makingNotes, daily.notes, daily.inTime, daily.outTime, car.carDept, car.carNumber, car.carDriver, daily.hangUpState) from com.po.DailyInfo as daily, com.po.CarInfo as car, com.po.MineInfo as mine where daily.carIDCardID = car.carIDCardID and mine.code=daily.mineName and daily.id=?";
		}else{
			queryString = "select new com.vo.DailyLoadInfoVO(daily.id, daily.dailyNum, daily.carIDCardID, daily.mineName, daily.receiveDept, daily.departure, daily.grossWeight, daily.tareWeight, daily.operator, daily.loadingInfo, daily.makingNotes, daily.notes, daily.inTime, daily.outTime, car.carDept, car.carNumber, car.carDriver, daily.hangUpState) from com.po.DailyInfo as daily, com.po.CarInfo as car where daily.carIDCardID = car.carIDCardID and daily.id=?";
		}
		return getHibernateTemplate().find(queryString, idVO);
	}

	public Long countDailyInfoDuringSpecifidPeroid(Long startMillis, Long endMillis, boolean hasFinished) {
		StringBuilder queryString = new StringBuilder();
		queryString.append("select count(*) from com.po.DailyInfo where hangUpState = false and deleteState = 0 ");
		//查询已完成的矿运的次数
		if(hasFinished){
			queryString.append(" and outTime is not null ");
			if(startMillis != null){
				queryString.append(" and outTime > " + startMillis);
			}
			if(endMillis != null){
				queryString.append(" and outTime < " + endMillis);
			}
		}//查询未完成的矿运的次数
		else{
			queryString.append(" and outTime is null ");
			if(startMillis != null){
				queryString.append(" and inTime > " + startMillis);
			}
			if(endMillis != null){
				queryString.append(" and inTime < " + endMillis);
			}
		}
		
		return (Long) getHibernateTemplate().find(queryString.toString()).get(0);
	}

	public List countWeightOfMineTransferedDuringSpecifidPeroid(final Long startMillis, final Long endMillis) {
		return (List) getHibernateTemplate().execute(new HibernateCallback(){

			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {
				StringBuilder queryString = new StringBuilder();
				queryString.append("select mine.name, sum(daily.grossWeight)-sum(daily.tareweight) from dailyinfo as daily, mineinfo as mine where mine.code = daily.mineName and daily.outTime is not null and daily.hangUpState=false and daily.deleteState = 0 ");
				if(startMillis != null){
					queryString.append(" and outTime > " + startMillis);
				}
				if(endMillis != null){
					queryString.append(" and outTime < " + endMillis);
				}
				queryString.append(" group by daily.mineName");
				Query query = session.createSQLQuery(queryString.toString());
				return query.list();
			}});
	}

	public void saveOrUpdateExportDateAssistant(ExportDateAssistant exportDateAssistant) {
		getHibernateTemplate().save(exportDateAssistant);
	}

	@SuppressWarnings("unchecked")
	public List<ExportDateAssistant> getLastExportDate() {
		return (List<ExportDateAssistant>) getHibernateTemplate().execute(new HibernateCallback(){
			public Object doInHibernate(Session session) throws HibernateException, SQLException {
				String queryString = "from com.po.ExportDateAssistant order by recordTime desc";
				Query query = session.createQuery(queryString);
				query.setMaxResults(1);
				return query.list();
			}});
	}

	public List<DailyInfo> listHangUpDailyInfo() {
		return getHibernateTemplate().find("from com.po.DailyInfo where hangUpState = ? and deleteState = ?", new Object[]{true, MyUtil.DELETE_FALSE});
	}

	public void deleteDailyInfoToRecycledBin(DailyInfo dailyInfo) {
		getHibernateTemplate().saveOrUpdate(dailyInfo);
	}

	public void saveOrUpdateSystemLog(SystemLogInfo systemLog) {
		getHibernateTemplate().saveOrUpdate(systemLog);
	}
}

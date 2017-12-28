package com.manager.impl;

import java.util.List;

import com.dao.CarDao;
import com.manager.CarManager;
import com.po.CarInfo;
import com.util.Page;
import com.vo.CarSearchVO;

public class CarManagerImpl implements CarManager{
	private CarDao carDao;
	
	public CarDao getCarDao() {
		return carDao;
	}
	public void setCarDao(CarDao carDao) {
		this.carDao = carDao;
	}

	public void saveOrUpdateCar(CarInfo carInfo) {
		if(carInfo.getId() == null || "".equals(carInfo.getId())){
			carInfo.setRecordTime(System.currentTimeMillis());
		}
		carDao.saveOrUpdateCar(carInfo);
	}

	public List<CarInfo> listCar(Page page, String orderBy, CarSearchVO carSearchVO) {
		return carDao.listCar(page, orderBy, carSearchVO);
	}
	
	public CarInfo loadCarInfo(String id) {
		return carDao.loadCarInfo(id);
	}
	
	public void deleteCar(String id) {
		carDao.deleteCar(id);
	}
	public CarInfo getCarInfoByCarIDCardID(String carIDCardID) {
		CarInfo carInfo = new CarInfo();
		List carList = carDao.getCarInfoByCarIDCardID(carIDCardID);
		if(carList != null && carList.size() > 0){
			carInfo = (CarInfo) carList.get(0);
		}
		return carInfo;
	}
	public boolean checkIDCardHasUsedByIDCardNum(String carIDCardID) {
		return carDao.getCarInfoByCarIDCardID(carIDCardID).size() > 0 ? true : false;
	}
}

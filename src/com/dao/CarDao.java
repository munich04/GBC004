package com.dao;

import java.util.List;

import com.po.CarInfo;
import com.util.Page;
import com.vo.CarSearchVO;

public interface CarDao {
	public int count(Class clazz);
	public List<CarInfo> listCar(Page page, String orderBy, CarSearchVO carSearchVO);
	public void saveOrUpdateCar(CarInfo carInfo);
	public CarInfo loadCarInfo(String id);
	public void deleteCar(String id);
	public List getCarInfoByCarIDCardID(String carIDCardID);
}

package com.manager;

import java.util.List;

import com.po.CarInfo;
import com.util.Page;
import com.vo.CarSearchVO;

public interface CarManager {

	public void saveOrUpdateCar(CarInfo carInfo);

	public List<CarInfo> listCar(Page page, String orderBy, CarSearchVO carSearchVO);

	public CarInfo loadCarInfo(String id);

	public void deleteCar(String id);

	public CarInfo getCarInfoByCarIDCardID(String carIDCardID);
	
	public boolean checkIDCardHasUsedByIDCardNum(String carIDCardID);

}

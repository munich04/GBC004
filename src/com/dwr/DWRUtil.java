package com.dwr;

import com.manager.CarManager;
import com.po.CarInfo;

public class DWRUtil {
	
	private CarManager carManager;
	
	public CarManager getCarManager() {
		return carManager;
	}
	public void setCarManager(CarManager carManager) {
		this.carManager = carManager;
	}
	
	public CarInfo getCarInfoByCarIDCardID(String carIDCardID){
		return carManager.getCarInfoByCarIDCardID(carIDCardID);
	}
}

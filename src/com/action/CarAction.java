package com.action;

import com.manager.CarManager;
import com.opensymphony.xwork2.ActionContext;
import com.po.CarInfo;
import com.vo.CarSearchVO;

public class CarAction extends BaseAction{
	private CarManager carManager;
	private CarInfo carInfo = new CarInfo();
	private CarSearchVO carSearchVO = new CarSearchVO();
	
	public CarManager getCarManager() {
		return carManager;
	}
	public void setCarManager(CarManager carManager) {
		this.carManager = carManager;
	}
	public CarInfo getCarInfo() {
		return carInfo;
	}
	public void setCarInfo(CarInfo carInfo) {
		this.carInfo = carInfo;
	}
	public CarSearchVO getCarSearchVO() {
		return carSearchVO;
	}
	public void setCarSearchVO(CarSearchVO carSearchVO) {
		this.carSearchVO = carSearchVO;
	}

	public String listCar(){
		ActionContext.getContext().put("listCar", carManager.listCar(page, null, carSearchVO));
		return SUCCESS;
	}
	
	public String saveOrUpdateCar(){
		carManager.saveOrUpdateCar(carInfo);
		return SUCCESS;
	}

	public String addCar(){
		return SUCCESS;
	}

	public String modifyCar(){
		setCarInfo(carManager.loadCarInfo(carInfo.getId()));
		return SUCCESS;
	}
	
	public String viewCar(){
		setCarInfo(carManager.loadCarInfo(carInfo.getId()));
		return SUCCESS;
	}

	public String deleteCar(){
		carManager.deleteCar(carInfo.getId());
		return SUCCESS;
	}
}

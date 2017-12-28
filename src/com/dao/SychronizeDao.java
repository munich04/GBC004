package com.dao;

import java.util.List;

import com.po.CarInfo;
import com.po.DailyInfo;
import com.po.IpInfo;
import com.po.PortInfo;

public interface SychronizeDao {

	public List<DailyInfo> getDailyInfoAddedAtOneDay(Long startMillis, Long endMillis);

	public List<CarInfo> getCarInfoAddedAtOneDay(Long startMillis, Long endMillis);

	public void deleteDailyInfoListOfOneDay(Long startMillis, Long endMillis);

	public void deleteCarInfoListOfOneDay(Long startMillis, Long endMillis);

	public void addDailyInfoListOfOneDay(List<DailyInfo> dailyInfoList);

	public void addCarInfoListOfOneDay(List<CarInfo> carInfoList);

	public List<IpInfo> getLatestUsedIp(Integer number);

	public List<PortInfo> getLatestUsedPort(Integer number);

	public void saveIpInfo(IpInfo ipInfo);

	public void savePortInfo(PortInfo portInfo);

	public List getIpInfoListByIpAndPort(String ip, Integer port);

	public List getPortInfoListByPort(Integer port);

	public void deleteIpInfoByIpAndPort(String ip, Integer port);

	public void deletePortInfoByPort(Integer port);

	public List countCarInfoAddedAtOneDay(Long startMillis, Long endMillis);

	public List countDailyInfoAddedAtOneDay(Long startMillis, Long endMillis);
}

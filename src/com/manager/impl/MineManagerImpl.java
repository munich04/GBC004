package com.manager.impl;

import java.util.List;

import com.dao.MineDao;
import com.manager.MineManager;
import com.po.MineInfo;
import com.util.Page;

public class MineManagerImpl implements MineManager{
	private MineDao mineDao;
	public MineDao getMineDao() {
		return mineDao;
	}
	public void setMineDao(MineDao mineDao) {
		this.mineDao = mineDao;
	}
	
	public void deleteMine(MineInfo mineInfo) {
		mineDao.deleteMine(mineInfo);
	}
	
	public List<MineInfo> listMine(Page page, String orderBy) {
		return mineDao.listMine(page, orderBy);
	}
	
	public List<MineInfo> getAllMine(){
		return mineDao.listMine(null, "recordTime asc");
	}
	
	public void saveOrUpdateMine(MineInfo mineInfo) {
		if(mineInfo.getRecordTime() == null || mineInfo.getRecordTime() == 0){
			mineInfo.setRecordTime(System.currentTimeMillis());
		}
		mineDao.saveOrUpdateMine(mineInfo);
	}
	
	public MineInfo loadMineInfo(String id) {
		return mineDao.loadMineInfo(id);
	}
	
	public String getMineNameByMineCode(String mineCode) {
		String mineName = "";
		MineInfo mineInfo = null;
		List<MineInfo> mineInfoList = mineDao.getMineListByMineCode(mineCode);
		if(mineInfoList != null && mineInfoList.size() > 0){
			mineInfo = mineInfoList.get(0);
			mineName = mineInfo.getName();
		}
		return mineName;
	}
}

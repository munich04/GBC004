package com.action;

import com.manager.MineManager;
import com.opensymphony.xwork2.ActionContext;
import com.po.MineInfo;

public class MineAction extends BaseAction{
	private MineInfo mineInfo;
	private MineManager mineManager;
	public MineInfo getMineInfo() {
		return mineInfo;
	}
	public void setMineInfo(MineInfo mineInfo) {
		this.mineInfo = mineInfo;
	}
	public MineManager getMineManager() {
		return mineManager;
	}
	public void setMineManager(MineManager mineManager) {
		this.mineManager = mineManager;
	}
	public String listMine(){
		ActionContext.getContext().put("listMine", mineManager.listMine(page, null));
		return SUCCESS;
	}
	public String saveOrUpdateMine(){
		mineManager.saveOrUpdateMine(mineInfo);
		return SUCCESS;
	}
	public String addMine(){
		return SUCCESS;
	}
	public String deleteMine(){
		mineManager.deleteMine(mineInfo);
		return SUCCESS;
	}
	public String viewMine(){
		setMineInfo(mineManager.loadMineInfo(mineInfo.getId()));
		return SUCCESS;
	}
	public String modifyMine(){
		setMineInfo(mineManager.loadMineInfo(mineInfo.getId()));
		return SUCCESS;
	}
}

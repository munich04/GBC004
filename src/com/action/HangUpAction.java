package com.action;

import com.manager.HangUpManager;
import com.po.HangUpOperation;
import com.po.UserInfo;
import com.util.MyUtil;

public class HangUpAction extends BaseAction{
	private HangUpManager hangUpManager;
	private HangUpOperation hangUpOperation = new HangUpOperation();
	
	public HangUpManager getHangUpManager() {
		return hangUpManager;
	}
	public void setHangUpManager(HangUpManager hangUpManager) {
		this.hangUpManager = hangUpManager;
	}
	public HangUpOperation getHangUpOperation() {
		return hangUpOperation;
	}
	public void setHangUpOperation(HangUpOperation hangUpOperation) {
		this.hangUpOperation = hangUpOperation;
	}
	
	public String dealHangUp(){
		return SUCCESS;
	}
	
	//保存HangUp操作记录,同时修改相应DailyInfo的状态
	public String saveOrUpdateHangUp(){
		UserInfo loginUser = (UserInfo) getSession().getAttribute("userInfo");
		hangUpManager.saveOrUpdateHangUp(loginUser == null ? "" : loginUser.getId(), hangUpOperation);
		return SUCCESS;
	}

	public String goToLoadHangUp(){
		return SUCCESS;
	}
}

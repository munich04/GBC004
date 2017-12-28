package com.action;

import com.manager.SystemLogManager;
import com.manager.UserManager;
import com.opensymphony.xwork2.ActionContext;
import com.po.SystemLogInfo;
import com.po.UserInfo;
import com.util.MyUtil;
import com.vo.UserSearchVO;

public class UserAction extends BaseAction{
	private UserManager userManager;
	private UserInfo userInfo = new UserInfo();
	private UserSearchVO userSearchVO = new UserSearchVO();
	private SystemLogManager systemLogManager;
	
	public SystemLogManager getSystemLogManager() {
		return systemLogManager;
	}
	public void setSystemLogManager(SystemLogManager systemLogManager) {
		this.systemLogManager = systemLogManager;
	}
	public UserInfo getUserInfo() {
		return userInfo;
	}
	public void setUserInfo(UserInfo userInfo) {
		this.userInfo = userInfo;
	}
	public UserManager getUserManager() {
		return userManager;
	}
	public void setUserManager(UserManager userManager) {
		this.userManager = userManager;
	}
	public UserSearchVO getUserSearchVO() {
		return userSearchVO;
	}
	public void setUserSearchVO(UserSearchVO userSearchVO) {
		this.userSearchVO = userSearchVO;
	}

	public String registerUser(){
		userInfo.setRegisterTime(System.currentTimeMillis());
		userManager.saveOrUpdateUser(userInfo);
		getSession().setAttribute("userInfo", userInfo);
		return SUCCESS;
	}
	
	public String switchUser(){
		getSession().invalidate();
		return SUCCESS;
	}
	
	public String loginUser(){
		UserInfo tmpUserInfo = this.userManager.loadUserInfoByNamePwd(userInfo.getUserName(), userInfo.getPassWord());
		if(tmpUserInfo == null){
			ActionContext.getContext().put("errorMsg", "用户名或密码错误,请重新输入!");
			return ERROR;
		}else{
			setUserInfo(tmpUserInfo);
			getSession().setAttribute("userInfo", userInfo);
			
			userManager.generateLoginLog(tmpUserInfo.getId(), systemLogManager);
			
			return SUCCESS;
		}
	}
	
	public String viewLoginUser(){
		userInfo = (UserInfo) getSession().getAttribute("userInfo");
		return SUCCESS;
	}
	
	public String changeUserPwd(){
		userManager.saveOrUpdateUser(userInfo);
		return SUCCESS;
	}
	
	public String listUser(){
		userInfo = (UserInfo) getSession().getAttribute("userInfo");
		ActionContext.getContext().put("listUser", userManager.listUser(page, "", userInfo, userSearchVO));
		return SUCCESS;
	}
	
	public String viewUser(){
		setUserInfo(userManager.loadUserByEntryID(userInfo.getId()));
		return SUCCESS;
	}
}

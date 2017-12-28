package com.manager.impl;

import java.util.ArrayList;
import java.util.List;

import com.dao.UserDao;
import com.manager.SystemLogManager;
import com.manager.UserManager;
import com.po.SystemLogInfo;
import com.po.UserInfo;
import com.util.MyUtil;
import com.util.Page;
import com.vo.UserSearchVO;

public class UserManagerImpl implements UserManager{
	private UserDao userDao;
	
	public UserDao getUserDao() {
		return userDao;
	}
	public void setUserDao(UserDao userDao) {
		this.userDao = userDao;
	}
	public void saveOrUpdateUser(UserInfo userInfo) {
		userDao.saveOrUpdateUser(userInfo);
	}
	public UserInfo loadUserInfoByNamePwd(String userName, String passWord) {
		UserInfo userInfo = null;
		List<UserInfo> tmpList = userDao.loadUserInfoByNamePwd(userName, passWord);
		if(tmpList != null && tmpList.size() > 0){
			userInfo = tmpList.get(0);
		}
		return userInfo;
	}
	public List<UserInfo> listUser(Page page, String orderBy, UserInfo currentUserInfo, UserSearchVO userSearchVO) {
		List<UserInfo> list = new ArrayList<UserInfo>();
		if(currentUserInfo.getAuthority() == MyUtil.AUTHORITY_SOVEREIGNTY.intValue() || currentUserInfo.getAuthority() == MyUtil.AUTHORITY_HIGH.intValue() || currentUserInfo.getAuthority() == MyUtil.AUTHORITY_MIDDLE.intValue()){
			list = userDao.listUser(page, orderBy, currentUserInfo.getAuthority(), userSearchVO);
		}
		return list;
	}
	
	//为userIDs的用户更改用户权限
	public void impartAuthorityForUsers(Integer authorityLevel, String[] userIDs){
		if(userIDs != null){
			userDao.impartAuthorityForUsers(authorityLevel, userIDs);
		}
	}
	public UserInfo loadUserByEntryID(String entryID) {
		return userDao.loadUserByEntryID(entryID);
	}
	
	public void generateLoginLog(String userId, SystemLogManager systemLogManager) {
		SystemLogInfo systemLog = new SystemLogInfo();
		systemLog.setUserInfoId(userId);
		systemLog.setRecordTime(System.currentTimeMillis());
		systemLog.setInfoType(MyUtil.SYSTEM_LOG_TYPE_LOGIN);
		systemLogManager.saveOrUpdateSystemLog(systemLog);
	}
}

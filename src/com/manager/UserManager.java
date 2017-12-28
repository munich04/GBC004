package com.manager;

import java.util.List;

import com.po.UserInfo;
import com.util.Page;
import com.vo.UserSearchVO;

public interface UserManager {
	public void saveOrUpdateUser(UserInfo userInfo);

	public UserInfo loadUserInfoByNamePwd(String userName, String passWord);

	public List<UserInfo> listUser(Page page, String orderBy, UserInfo currentUserInfo, UserSearchVO userSearchVO);
	
	public UserInfo loadUserByEntryID(String entryID);

	public void generateLoginLog(String userId, SystemLogManager systemLogManager);

}

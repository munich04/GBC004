package com.dao;

import java.util.List;

import com.po.UserInfo;
import com.util.Page;
import com.vo.UserSearchVO;

public interface UserDao {
	public int count(Class clazz);
	public List<UserInfo> listUser(Page page, String orderBy, Integer authority, UserSearchVO userSearchVO);
	public void saveOrUpdateUser(UserInfo userInfo);
	public List<UserInfo> loadUserInfoByNamePwd(String userName, String passWord);
	public void impartAuthorityForUsers(Integer authorityLevel, String[] userIDs);
	public UserInfo loadUserByEntryID(String entryID);
}

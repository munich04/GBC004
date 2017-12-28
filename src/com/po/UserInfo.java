package com.po;

import java.io.Serializable;

import com.util.MyUtil;

public class UserInfo implements Serializable{
	private String id;
	private String userName;
	private String nickName;
	private String passWord;
	private Long registerTime;
	private Integer authority = MyUtil.AUTHORITY_LOW;

	private String registerTimeToLocalString;
	private String authorityToLocalString;
	public UserInfo() {
		super();
	}
	public UserInfo(String id, String userName, String nickName, String passWord,
			Long registerTime, Integer authority) {
		super();
		this.id = id;
		this.userName = userName;
		this.nickName = nickName;
		this.passWord = passWord;
		this.registerTime = registerTime;
		this.authority = authority;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getPassWord() {
		return passWord;
	}
	public void setPassWord(String passWord) {
		this.passWord = passWord;
	}
	public Long getRegisterTime() {
		return registerTime;
	}
	public void setRegisterTime(Long registerTime) {
		this.registerTime = registerTime;
	}
	public String getNickName() {
		return nickName;
	}
	public void setNickName(String nickName) {
		this.nickName = nickName;
	}
	public Integer getAuthority() {
		return authority;
	}
	public void setAuthority(Integer authority) {
		this.authority = authority;
	}
	public String getRegisterTimeToLocalString() {
		if(this.registerTime != null){
			registerTimeToLocalString = MyUtil.formatMillisSecondStyle(registerTime);
		}
		return registerTimeToLocalString;
	}
	public void setRegisterTimeToLocalString(String registerTimeToLocalString) {
		this.registerTimeToLocalString = registerTimeToLocalString;
	}
	public String getAuthorityToLocalString() {
		return MyUtil.AUTHORITY_DES_MAP.get(authority);
	}
	public void setAuthorityToLocalString(String authorityToLocalString) {
		this.authorityToLocalString = authorityToLocalString;
	}
}

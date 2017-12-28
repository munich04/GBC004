package com.vo;

public class UserSearchVO {
	private String nickNameVO;
	private Integer authorityVO;
	public UserSearchVO(){
	}
	public UserSearchVO(String nickNameVO, Integer authorityVO){
		this.nickNameVO = nickNameVO;
		this.authorityVO = authorityVO;
	}
	public String getNickNameVO() {
		return nickNameVO;
	}
	public void setNickNameVO(String nickNameVO) {
		this.nickNameVO = nickNameVO;
	}
	public Integer getAuthorityVO() {
		return authorityVO;
	}
	public void setAuthorityVO(Integer authorityVO) {
		this.authorityVO = authorityVO;
	}
}

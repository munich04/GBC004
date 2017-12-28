package com.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.struts2.ServletActionContext;

import com.opensymphony.xwork2.ActionSupport;
import com.util.Page;

public class BaseAction extends ActionSupport{
	public Page page = new Page();

	public Page getPage() {
		return page;
	}
	public void setPage(Page page) {
		this.page = page;
	}

	public HttpServletRequest getTheRequest(){
		return ServletActionContext.getRequest();
	}
	
	public HttpSession getSession(){
		return getTheRequest().getSession();
	}
	
	public Object getParameter(String parameterName){
		return getTheRequest().getAttribute(parameterName);
	}
}

package com.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginFilter implements Filter{
	private String uncheckURL = null;
	
	public String getUncheckURL() {
		return uncheckURL;
	}
	public void setUncheckURL(String uncheckURL) {
		this.uncheckURL = uncheckURL;
	}

	public void doFilter(ServletRequest arg0, ServletResponse arg1,
			FilterChain chain) throws IOException, ServletException {
		
		HttpServletRequest request = (HttpServletRequest)arg0;
		HttpServletResponse response = (HttpServletResponse) arg1;
		HttpSession session = request.getSession();

		String url = request.getRequestURL().toString();
		String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
		
		boolean flag = true;
		if(url.endsWith(".jsp") || url.endsWith(".action")){
			if(!amIsLegal(url) && session.getAttribute("userInfo") == null){
				flag  = false;
			}
		}
		
		if(flag){
			chain.doFilter(arg0, arg1);
		}else{
			response.sendRedirect(basePath + "index.jsp");
		}
	}

	public void init(FilterConfig chain) throws ServletException {
		uncheckURL = chain.getInitParameter("uncheckURL");
	}
	
	private boolean amIsLegal(String url){
		boolean flag = false;
		String tmps[] = uncheckURL.split(",");
		for (String tmpStr : tmps) {
			if(url.endsWith(tmpStr)){
				flag = true;
				break;
			}
		}
		tmps = null;
		return flag;
	}

	public void destroy() {
		
	}
}

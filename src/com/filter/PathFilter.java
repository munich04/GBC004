package com.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

/**
 * 
 * ��ӡ��
 * ���䣻
 * 
 * @author bayer
 *
 */
public class PathFilter implements Filter{
	
	//ע�⸳ֵ�Լ����ж�
	private static String path = "";

	public void destroy() {
		
	}

	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		
		//synchronized
		synchronized (PathFilter.class) {
			if("".equals(this.path)){
				this.path = ((HttpServletRequest)request).getContextPath();
			}
		}
		//��Ҫ��©
		chain.doFilter(request, response);
	}

	public void init(FilterConfig filterConfig) throws ServletException {
		
	}
	
	//synchronized static
	public synchronized static String getPath() {
		return path;
	}
	
}

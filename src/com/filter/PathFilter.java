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
 * 打印；
 * 传输；
 * 
 * @author bayer
 *
 */
public class PathFilter implements Filter{
	
	//注意赋值以减少判断
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
		//不要遗漏
		chain.doFilter(request, response);
	}

	public void init(FilterConfig filterConfig) throws ServletException {
		
	}
	
	//synchronized static
	public synchronized static String getPath() {
		return path;
	}
	
}

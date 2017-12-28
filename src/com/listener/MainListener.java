package com.listener;

import java.util.Calendar;
import java.util.Timer;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.springframework.web.context.support.WebApplicationContextUtils;

import com.listener.task.SetDataBackUpTask;
import com.manager.HangUpManager;

public class MainListener implements ServletContextListener {

	private Timer timer = null;
	
	public void contextDestroyed(ServletContextEvent sce) {
	}

	public void contextInitialized(ServletContextEvent sce) {
		//doClearExpiredDailyInfo(sce.getServletContext());	//挂起90天以后的操作自动删除（删除到回收站）
		doBackup();	//系统备份任务
	}
	
	private void doClearExpiredDailyInfo(ServletContext ctx){
		HangUpManager hangUpManager = (HangUpManager) getBean(ctx, "hangUpManager");
		hangUpManager.dealWithExpiredOperation();
	}
	
	private void doBackup(){
		timer = new Timer(true);

		/** 在这里设置每天备份时间为每天的17:00:00 */
		Calendar date = Calendar.getInstance();
		date.set(Calendar.HOUR_OF_DAY, 17);

		date.set(Calendar.MINUTE, 00);
		date.set(Calendar.SECOND, 0);

		timer.schedule(new SetDataBackUpTask(), date.getTime());
	}
	
	private Object getBean(ServletContext servletContext, String beanName) {
        return WebApplicationContextUtils.getRequiredWebApplicationContext(servletContext).getBean(beanName);
	}
}
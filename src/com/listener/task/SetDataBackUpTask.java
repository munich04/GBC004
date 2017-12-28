package com.listener.task;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

import com.util.MyUtil;

public class SetDataBackUpTask extends TimerTask {

	@Override
	public void run() {
		try {
			Process ps = Runtime.getRuntime().exec(
					"mysqldump -hlocalhost -u" + MyUtil.DATABASE_USER + " -p" + MyUtil.DATABASE_PASSWORD + " mine");
			InputStream in = ps.getInputStream();

			File parentFile = new File(MyUtil.DATABASE_BACKUP_FLODER);
			if (!parentFile.exists()) {
				parentFile.mkdirs();
			}

			SimpleDateFormat formate = new SimpleDateFormat("yyyy-MM-dd");
			String currentDate = formate.format(new Date());

			File file = new File(parentFile, currentDate + ".sql");

			if (!file.exists()) {
				file.createNewFile();
			}

			FileOutputStream fos = new FileOutputStream(file);

			byte[] buffer = new byte[1024];
			int length = 0;
			while ((length = in.read(buffer)) != -1) {
				fos.write(buffer, 0, length);
			}
			fos.flush();
			fos.close();
			in.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	public static void main(String[] args) {
		new Timer().schedule(new SetDataBackUpTask(), 0);
	}
}
package com.manager;

import java.util.List;

import com.po.MineInfo;
import com.util.Page;

public interface MineManager {

	List<MineInfo> listMine(Page page, String orderBy);

	void saveOrUpdateMine(MineInfo mineInfo);

	void deleteMine(MineInfo mineInfo);

	MineInfo loadMineInfo(String id);
	
	String getMineNameByMineCode(String mineCode);

}

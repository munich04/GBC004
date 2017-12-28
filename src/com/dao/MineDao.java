package com.dao;

import java.util.List;

import com.po.MineInfo;
import com.util.Page;

public interface MineDao {

	void deleteMine(MineInfo mineInfo);

	List<MineInfo> listMine(Page page, String orderBy);

	void saveOrUpdateMine(MineInfo mineInfo);

	MineInfo loadMineInfo(String id);

	List<MineInfo> getMineListByMineCode(String mineCode);

}

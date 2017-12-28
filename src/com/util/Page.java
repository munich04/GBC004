package com.util;

public class Page {
	private int dataSum;//�����ܸ���
	private int pageSum;//ҳ���ܸ���
	private int pageSize = 8;//ҳ����ʾ�����ݸ���
	private int pageNum = 1;//��ǰҳ��
	
	private int pageCount = 10;//ҳ�����ֻ��ʾ10��ҳ���
	
	private int firstData;
	private int lastData;
	
	private int firstPage;
	private int lastPage;

	public Page(){
		
	}
	
	public Page(int dataSum) {
		this.dataSum = dataSum;
		init();
	}
	
	public Page(int dataSum, int pageSize) {
		this.dataSum = dataSum;
		this.pageSize = pageSize;
		init();
	}
	public int getFirstData() {
		return firstData;
	}
	public void setFirstData(int firstData) {
		this.firstData = firstData;
	}
	public int getLastData() {
		return lastData;
	}
	public void setLastData(int lastData) {
		this.lastData = lastData;
	}
	public int getFirstPage() {
		return firstPage;
	}
	public void setFirstPage(int firstPage) {
		this.firstPage = firstPage;
	}
	public int getLastPage() {
		return lastPage;
	}
	public void setLastPage(int lastPage) {
		this.lastPage = lastPage;
	}
	public int getPageNum() {
		return pageNum;
	}
	public void setPageNum(int pageNum) {
		this.pageNum = pageNum;
	}
	public int getPageSize() {
		return pageSize;
	}
	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
		init();
	}
	public int getPageSum() {
		return pageSum;
	}
	public void setPageSum(int pageSum) {
		this.pageSum = pageSum;
	}
	public int getDataSum() {
		return dataSum;
	}
	public void setDataSum(int dataSum) {
		this.dataSum = dataSum;
		init();
	}
	public void init(){
		this.pageSum = (int)Math.ceil((double)this.dataSum/this.pageSize);//�������ҳ��
		
		this.pageNum = Math.max(1, this.pageNum);
		this.pageNum = Math.min(this.pageNum, this.pageSum);
		
		this.firstData = (this.pageNum-1)*this.pageSize + 1;
		this.lastData = Math.min(this.firstData + this.pageSize - 1, this.dataSum);
		
		if(this.pageNum - this.firstPage > this.pageCount/2){
			this.firstPage = this.pageNum - this.pageCount/2;
		}
		if(this.pageSum - this.firstPage < this.pageCount){
			this.firstPage = this.pageSum - this.pageCount + 1;
		}
		this.firstPage = Math.max(this.firstPage, 1);
		this.lastPage = Math.min(this.firstPage + this.pageCount - 1, this.pageSum);
	}
}

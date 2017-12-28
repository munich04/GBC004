package com.taglib;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

import com.util.Page;

public class PageTag extends TagSupport{
	private Page page;
	public Page getPage() {
		return page;
	}
	public void setPage(Page page) {
		this.page = page;
	}
	@Override
	public int doEndTag() throws JspException {
		
		StringBuilder builder = new StringBuilder();
		
		
		//无数据
		if(page.getPageSum() == 0){
			builder.append("<table class='main' style='width:99%; margin: 2px 1px;'><tr><td class='center' colspan='15'>暂无数据</td></tr></table>");
		}//有数据
		else{
			builder.append("<div id=\"pageDiv\">\n");
			builder.append("<a class=\"disable\"><span>共" + page.getDataSum() + "条数据</span></a>&nbsp;");

			if(page.getPageNum() == 1){
				builder.append("<a class=\"disable\" href=\"javascript:void(0);\"><span>首页</span></a>\n<a class=\"disable\" href=\"javascript:void(0);\"><span>上一页</span></a>\n");
			}else{
				builder.append(
						"<a class=\"active\" href=\"javascript:void(0);\" " +
						"onclick=\"document.getElementById('pageNum').value=1;document.getElementById('protoform').submit();\">" +
						"<span>首页</span></a>\n" +
						"<a class=\"active\" href=\"javascript:void(0);\" " +
						"onclick=\"document.getElementById('pageNum').value="+ (page.getPageNum()-1) +";document.getElementById('protoform').submit();\">" +
						"<span>上一页</span></a>\n");
			}

			for (int i = page.getFirstPage(); i <= page.getLastPage(); i++) {
				if(i == page.getPageNum()){
					builder.append("<a class=\"curPage\" href=\"javascript:void(0);\"><span>"+i+"</span></a>\n");
				}else{
					builder.append(
							"<a class=\"active\" href=\"javascript:void(0);\" " +
							"onclick=\"document.getElementById('pageNum').value= " + i + ";document.getElementById('protoform').submit();\">" +
							"<span>"+i+"</span></a>\n");
				}
			}
			
			if(page.getPageNum() == page.getPageSum()){
				builder.append("<a class=\"disable\" href=\"javascript:void(0);\"><span>末页</span></a>\n<a class=\"disable\" href=\"javascript:void(0);\"><span>下一页</span></a>\n");
			}else{
				builder.append(
						"<a class=\"active\" href=\"javascript:void(0);\" " +
						"onclick=\"document.getElementById('pageNum').value="+page.getPageSum()+";document.getElementById('protoform').submit();\">" +
						"<span>末页</span></a>\n" +
						"<a class=\"active\" href=\"javascript:void(0);\" " +
						"onclick=\"document.getElementById('pageNum').value="+ (page.getPageNum()+1) +";document.getElementById('protoform').submit();\">" +
						"<span>下一页</span></a>\n");
			}
			builder.append("</div>");
		}

		try {
			this.pageContext.getOut().println(builder.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return super.doEndTag();
	}
}

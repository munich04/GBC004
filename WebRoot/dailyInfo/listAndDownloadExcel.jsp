<%@page import="com.util.MyUtil"%>
<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%@ taglib prefix="c" uri="/WEB-INF/c.tld"%>
<%@ taglib prefix="test" uri="/WEB-INF/test.tld" %>
<%@ taglib prefix="fn" uri="/WEB-INF/fn.tld" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<title>查询</title>
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/default.css"></link>
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/niceform.css"></link>
<style type="text/css">
	.exportLabelStyle1 {
		width: 78px;
		margin: 3px;
		padding: 5px 10px;
		color: #3D59AB;
		background: #e0eeee;
		cursor: hand;
	}
	.exportLabelStyle2 {
		width: 78px;
		margin: 3px;
		padding: 5px 10px;
		color: orange;
		background: #e0eeee;
		cursor: hand;
	}
	
	.switchBtnInit{
		background:#E8E8E8; padding:5px 10px; cursor:pointer;
	}
	.switchBtnHover{
		background:#DCDCDC; padding:5px 10px; cursor:pointer;
	}
	
	#switchDownloadDiv { margin:10px 0;}
</style>
<script type="text/javascript">
	var basePath = "<%=basePath%>";
</script>
<script type='text/javascript' src='<%=basePath%>js/global.js'></script>
<script type='text/javascript' src='<%=basePath%>js/niceform.js'></script>
<script>
	function doInit(){
		var btnArray = document.getElementById("switchDownloadDiv").childNodes;
		var len = btnArray.length;
		for(var i=0; i<len; i++){
			var obj = btnArray[i];
			obj.onmouseover = function(){ this.className="switchBtnHover";};
			obj.onmouseout = function(){ this.className="switchBtnInit";};
		}
	}
	
	function switchData(_t){
		var downloadType = document.getElementById("downloadType");
		if(_t == "txt"){
			downloadType.value = "<%=MyUtil.DOWNLOAD_TYPE_TXT%>";
		}else if(_t == "excel"){
			downloadType.value = "<%=MyUtil.DOWNLOAD_TYPE_EXCEL%>";
		}
		document.getElementById("protoform").submit();
	}
</script>
</head>
<body onload="doInit();">
<form id="protoform" action="listAndDownloadExcel.action" method="post" style="margin:15px;">
	<input id="pageNum" type="hidden" name="page.pageNum" value="${page.pageNum}" />
	<input id="downloadType" type="hidden" name="downloadType" value="${downloadType}" />
	
	<c:if test="${downloadType=='excel'}">
		<c:set var="dir" value="excels/"/>
		<div id="switchDownloadDiv"><span class="switchBtnInit" onclick="switchData('txt');">切换到Txt格式数据列表</span></div>
	</c:if>
	<c:if test="${downloadType=='txt'}">
		<c:set var="dir" value="txts/"/>
		<div id="switchDownloadDiv"><span class="switchBtnInit" onclick="switchData('excel');">切换到Excel格式数据列表</span></div>
	</c:if>
	
	<table border="0" cellpadding="0" cellspacing="0" class="main" style="width:99%; margin:2px 1px">
   		<caption>
   			<div style="float:left;">
   				<img src="<%=basePath%>pic/ico1.gif" align="absmiddle" alt=""/>导出数据下载
   			</div>
   		</caption>
   		<tr>
   			<th nowrap="nowrap" width="15%">&nbsp;编&nbsp;&nbsp;号&nbsp;</th>
   			<th nowrap="nowrap" width="55%">&nbsp;起&nbsp;止&nbsp;日&nbsp;期&nbsp;</th>
   			<th nowrap="nowrap" width="30%">&nbsp;操&nbsp;&nbsp;作&nbsp;</th>
   		</tr>
   		
   		<c:forEach var="entry" items="${dataList}" varStatus="index">
   		<tr onmouseover="this.className='tr_on';" onmouseout="this.className='';">
   			<td nowrap="nowrap" class="center">${page.firstData + index.index}</td>
   			<td nowrap="nowrap" class="center">${fn:substring(entry, 14, 24)} - ${fn:substring(entry, 25, 35)}</td>
   			<td nowrap="nowrap" class="btnStyle1">
   				<a target="_blank" href="<%=basePath%>${dir}${entry}">下载文件</a>
   			</td>
   		</tr>
   		</c:forEach>
   	</table>
	
	<div id="footer">
		<test:page page="${page}"></test:page>
	</div>
</form>
</body>
</html>
<script>
specifyParentNodeCssStyle("listAndDownloadDaily");
//for niceform.js
function inputsFocusAndBlur(){
	var inputs = document.getElementsByTagName("input");
	for (var i = 0; i < inputs.length; i++) {
		var inputObj = inputs[i];
		if(inputObj.type == "text"){
			inputObj.onfocus = function(){onInputFocus(this)};
			inputObj.onblur = function(){onInputBlur(this)};
		}
	}
}
inputsFocusAndBlur();
</script>
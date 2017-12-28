<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%@ taglib prefix="c" uri="/WEB-INF/c.tld"%>
<%@ taglib prefix="test" uri="/WEB-INF/test.tld" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>系统日志管理</title>
<meta http-equiv="Content-Type" content="text/html; charset=gbk" />
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
</style>
<script type="text/javascript">
	var basePath = "<%=basePath%>";
</script>
<script type='text/javascript' src='<%=basePath%>js/global.js'></script>
<script type="text/javascript">
	function viewSystemLogFunction(id){
		openModelDialog(basePath + "viewSystemLog.action?systemLogInfo.id=" + id, null, 600, 370);
	}
</script>
</head>
<body>
<form action="listSystemLog.action" id="protoform" method="post">
<input id="pageNum" type="hidden" name="page.pageNum" value="${page.pageNum}" />
<input id="hiddenEntryId" type="hidden" name="systemLogInfo.id" />
</form>
<table width="99%" border="0" cellpadding="0" cellspacing="0" class="main">
	<caption>
		<img src="<%=basePath%>pic/ico1.gif" align="absmiddle" alt=""/>系统日志列表	
	<tr>
		<th nowrap="nowrap" width="10%">&nbsp;编&nbsp;&nbsp;号&nbsp;</th>
		<th nowrap="nowrap" width="16%">&nbsp;操&nbsp;作&nbsp;类&nbsp;型&nbsp;</th>
		<th nowrap="nowrap" width="16%">&nbsp;操&nbsp;作&nbsp;用&nbsp;户&nbsp;</th>
		<th nowrap="nowrap" width="20%">&nbsp;操&nbsp;作&nbsp;时&nbsp;间&nbsp;</th>
		<th nowrap="nowrap" width="38%">&nbsp;操&nbsp;作&nbsp;详&nbsp;情&nbsp;</th>
		<th nowrap="nowrap" width="16%">&nbsp;操&nbsp;&nbsp;作&nbsp;</th>
	</tr>
	<c:forEach var="entry" items="${dataList}" varStatus="index">
	<tr onmouseover="this.className='tr_on';" onmouseout="this.className='';">
		<td nowrap="nowrap" class="center">${page.firstData + index.index}</td>
		<td nowrap="nowrap" class="center"><div style="width:100px; overflow:hidden; text-overflow:ellipsis;" title="${entry.infoTypeStr}">${entry.infoTypeStr}</div></td>
		<td nowrap="nowrap" class="center"><div style="width:100px; overflow:hidden; text-overflow:ellipsis;" title="${entry.operateUsername}">${entry.operateUsername}</div></td>
		<td nowrap="nowrap" class="center"><div style="width:150px; overflow:hidden; text-overflow:ellipsis;" title="${entry.recordTimeStr}">${entry.recordTimeStr}</div></td>
		<td nowrap="nowrap" class="center"><div style="width:350px; overflow:hidden; text-overflow:ellipsis;" title="${entry.infoDetail}">${entry.infoDetail}</div></td>
		<td nowrap="nowrap" class="btnStyle1">
			<input type="button" value="查看" onclick="viewSystemLogFunction('${entry.id}');"/>&nbsp;
			<input type="button" value="删除" onclick="submitProtoformWithHiddenValue('hiddenEntryId', '${entry.id}', '<%=basePath%>/deleteSystemLog.action')"/>&nbsp;
		</td>
	</tr>
	</c:forEach>
</table>
<test:page page="${page}"></test:page>
</body>
</html>
<script>
specifyParentNodeCssStyle("listSystemLog");
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

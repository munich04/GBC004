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
<title>车辆查看</title>
<meta http-equiv="Content-Type" content="text/html; charset=gbk" />
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/default.css"></link>
<script type="text/javascript" src="<%=basePath%>js/global.js"></script>
<script type="text/javascript">
</script>
</head>
<body>
<form action="listMine.action" id="protoform" method="post">
<input id="pageNum" type="hidden" name="page.pageNum" value="${page.pageNum}" />
<input id="hiddenEntryId" type="hidden" name="mineInfo.id" />
</form>
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="main">
	<caption>
<div style="float:left;">
	<img src="<%=basePath%>pic/ico1.gif" align="absmiddle" alt=""/>矿种列表	
</div>
<div style="float:right;" class="btnStyle1">
	<input type="button" value="增加新的矿种信息" onclick="submitProtoform('<%=basePath%>+/addMine.action')"/>
</div>
</caption>
<tr>
	<th nowrap="nowrap" width="13%">&nbsp;编&nbsp;&nbsp;号&nbsp;</th>
	<th nowrap="nowrap" width="28%">&nbsp;矿&nbsp;物&nbsp;名&nbsp;称&nbsp;</th>
	<th nowrap="nowrap" width="28%">&nbsp;矿&nbsp;物&nbsp;代&nbsp;码&nbsp;</th>
	<th nowrap="nowrap" width="28%">&nbsp;登&nbsp;记&nbsp;时&nbsp;间&nbsp;</th>
	<th nowrap="nowrap" width="31%">&nbsp;操&nbsp;&nbsp;作&nbsp;</th>
</tr>
<c:forEach var="entry" items="${listMine}" varStatus="index">
<tr onmouseover="this.className='tr_on';" onmouseout="this.className='';">
	<td nowrap="nowrap" class="center">${page.firstData + index.index}</td>
	<td nowrap="nowrap" class="center"><div style="width:150px; overflow:hidden; text-overflow:ellipsis;" title="${entry.name}">${entry.name}</div></td>
	<td nowrap="nowrap" class="center"><div style="width:150px; overflow:hidden; text-overflow:ellipsis;" title="${entry.code}">${entry.code}</div></td>
	<td nowrap="nowrap" class="center"><div style="width:150px; overflow:hidden; text-overflow:ellipsis;" title="${entry.recordTimeLocaleString}">${entry.recordTimeLocaleString}</div></td>
	<td nowrap="nowrap" class="btnStyle1">
		<input type="button" value="修改" onclick="submitProtoformWithHiddenValue('hiddenEntryId', '${entry.id}', '<%=basePath%>/modifyMine.action')"/>&nbsp;
		<input type="button" value="查看" onclick="submitProtoformWithHiddenValue('hiddenEntryId', '${entry.id}', '<%=basePath%>/viewMine.action')"/>&nbsp;
		<input type="button" value="删除" onclick="submitProtoformWithHiddenValue('hiddenEntryId', '${entry.id}', '<%=basePath%>/deleteMine.action')"/>&nbsp;
	</td>
</tr>
</c:forEach>
</table>
<test:page page="${page}"></test:page>
</body>
</html>
<script>
specifyParentNodeCssStyle("listMine");
</script>

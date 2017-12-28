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
	function searchCar(obj){
		obj.blur();
		var innerHTML = "<fieldset>";
		innerHTML += "<legend>查询条件</legend>";
		innerHTML += "<div>";
		innerHTML += "<table style='margin:15px;'>";
		innerHTML += "<tr>";
		innerHTML += "<td width=\"20%\" style=\"text-align:right;\"><label for=\"textinput\">ID卡号:</label></td>";
		innerHTML += "<td width=\"30%\" style=\"text-align:left;\"><input type=\"text\" id=\"idInput\" style='border-top:none; border-left:none; border-right:none; border-bottom:1px solid #123456;' class='textinput'/></td>";
		innerHTML += "<td width=\"20%\" style=\"text-align:right;\"><label for=\"textinput\">车辆单位:</label></td>";
		innerHTML += "<td width=\"30%\" style=\"text-align:left;\"><input type=\"text\" id=\"deptInput\" style='border-top:none; border-left:none; border-right:none; border-bottom:1px solid #123456;' class='textinput'/></td>";
		innerHTML += "</tr>";
		innerHTML += "<tr>";
		innerHTML += "<td width=\"20%\" style=\"text-align:right;\"><label for=\"textinput\">车牌号码:</label></td>";
		innerHTML += "<td width=\"30%\" style=\"text-align:left;\"><input type=\"text\" id=\"numberInput\" style='border-top:none; border-left:none; border-right:none; border-bottom:1px solid #123456;' class='textinput'/></td>";
		innerHTML += "<td width=\"20%\" style=\"text-align:right;\"><label for=\"textinput\">驾驶员:</label></td>";
		innerHTML += "<td width=\"30%\" style=\"text-align:left;\"><input type=\"text\" id=\"driverInput\" style='border-top:none; border-left:none; border-right:none; border-bottom:1px solid #123456;' class='textinput'/></td>";
		innerHTML += "</tr>";
		innerHTML += "<tr>";
		innerHTML += "<td width=\"13%\" style=\"text-align:right;\"><label for=\"textinput\">毛重:</label></td>";
		innerHTML += "<td width=\"33%\" style=\"text-align:left;\" colspan=\"2\"><input id=\"lowerWeightInput\" type=\"text\" style='width:57px; border-top:none; border-left:none; border-right:none; border-bottom:1px solid #123456;' class='textinput'/> — <input id=\"higherWeightInput\" type=\"text\" style='width:57px; border-top:none; border-left:none; border-right:none; border-bottom:1px solid #123456;' class='textinput'/></td>";
		innerHTML += "<td width=\"20%\" style=\"text-align:center;\"><span style=\"background:#e0eeee; padding:5px; color:#123456; cursor:hand; font-size:13px;\" onclick='fillInputAndSubmitForCarSearch();'>&nbsp;&nbsp;&nbsp;查&nbsp;&nbsp;询&nbsp;&nbsp;</span><span style=\"background:#e0eeee; padding:5px; margin:0px 5px; color:#123456; cursor:hand; font-size:13px;\" onclick='clearTipDiv();'>&nbsp;&nbsp;&nbsp;取&nbsp;&nbsp;消&nbsp;&nbsp;</span></td>";
		innerHTML += "</tr>";
		innerHTML += "</table>";
		callParentTip(innerHTML, 580, 90, "查询车辆：");
	}
</script>
</head>
<body>
<form action="listCar.action" id="protoform" method="post">
<input id="pageNum" type="hidden" name="page.pageNum" value="${page.pageNum}" />
<input id="hiddenEntryId" type="hidden" name="carInfo.id" />
<%-- for carSearchVO --%>
<input type="hidden" id="carNumber" name="carSearchVO.carNumber" value="${carSearchVO.carNumber}"/>
<input type="hidden" id="carIDCardID"  name="carSearchVO.carIDCardID" value="${carSearchVO.carIDCardID}"/>
<input type="hidden" id="carDept"  name="carSearchVO.carDept" value="${carSearchVO.carDept}"/>
<input type="hidden" id="carDriver"  name="carSearchVO.carDriver" value="${carSearchVO.carDriver}"/>
<input type="hidden" id="carLowerWeight"  name="carSearchVO.carLowerWeight" value="${carSearchVO.carLowerWeight}"/>
<input type="hidden" id="carHigherWeight"  name="carSearchVO.carHigherWeight" value="${carSearchVO.carHigherWeight}"/>
</form>
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="main">
	<caption>
<div style="float:left;">
	<img src="<%=basePath%>pic/ico1.gif" align="absmiddle" alt=""/>车辆列表	
</div>
<div style="float:right;" class="btnStyle1">
	<input type="button" value="增加新的车辆信息" onclick="submitProtoform('<%=basePath%>/addCar.action')"/>
	<input id="searchCarButton1" type="button" value="车辆查询" onclick="searchCar(this);"/>
</div>
</caption>
<tr>
	<th nowrap="nowrap" width="7%">&nbsp;编&nbsp;&nbsp;号&nbsp;</th>
	<th nowrap="nowrap" width="14%">&nbsp;ID&nbsp;卡&nbsp;号&nbsp;</th>
	<th nowrap="nowrap" width="21%">&nbsp;车&nbsp;辆&nbsp;所&nbsp;属&nbsp;单&nbsp;位&nbsp;</th>
	<th nowrap="nowrap" width="14%">&nbsp;车&nbsp;牌&nbsp;号&nbsp;码&nbsp;</th>
	<th nowrap="nowrap" width="14%">&nbsp;毛&nbsp;&nbsp;重&nbsp;</th>
	<th nowrap="nowrap" width="14%">&nbsp;驾&nbsp;驶&nbsp;员&nbsp;</th>
	<th nowrap="nowrap" width="14%">&nbsp;操&nbsp;&nbsp;作&nbsp;</th>
</tr>
<c:forEach var="entry" items="${listCar}" varStatus="index">
<tr onmouseover="this.className='tr_on';" onmouseout="this.className='';">
	<td nowrap="nowrap" class="center">${page.firstData + index.index}</td>
	<td nowrap="nowrap" class="center"><div style="width:150px; overflow:hidden; text-overflow:ellipsis;" title="${entry.carIDCardID}">${entry.carIDCardID}</div></td>
	<td nowrap="nowrap" class="center"><div style="width:150px; overflow:hidden; text-overflow:ellipsis;" title="${entry.carDept}">${entry.carDept}</div></td>
	<td nowrap="nowrap" class="center"><div style="width:150px; overflow:hidden; text-overflow:ellipsis;" title="${entry.carNumber}">${entry.carNumber}</div></td>
	<td nowrap="nowrap" style="text-align:right;"><div style="width:150px; overflow:hidden; text-overflow:ellipsis;" title="${entry.tareWeight}">${entry.tareWeight}</div></td>
	<td nowrap="nowrap" class="center"><div style="width:150px; overflow:hidden; text-overflow:ellipsis;" title="${entry.carDriver}">${entry.carDriver}</div></td>
	<td nowrap="nowrap" class="btnStyle1">
		<input type="button" value="修改" onclick="submitProtoformWithHiddenValue('hiddenEntryId', '${entry.id}', '<%=basePath%>/modifyCar.action')"/>&nbsp;
		<input type="button" value="查看" onclick="submitProtoformWithHiddenValue('hiddenEntryId', '${entry.id}', '<%=basePath%>/viewCar.action')"/>&nbsp;
		<input type="button" value="删除" onclick="submitProtoformWithHiddenValue('hiddenEntryId', '${entry.id}', '<%=basePath%>/deleteCar.action')"/>&nbsp;
	</td>
</tr>
</c:forEach>
</table>
<test:page page="${page}"></test:page>
</body>
</html>
<script>
specifyParentNodeCssStyle("listCar");
</script>

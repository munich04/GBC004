<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>查看车辆</title>
<meta http-equiv="Content-Type" content="text/html; charset=gbk" />
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/niceform.css"></link>
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/buttonForm.css"></link>
<script type="text/javascript">
	var basePath = "<%=basePath%>";
</script>
<script type="text/javascript" src="<%=basePath%>js/niceform.js"></script>
<script type="text/javascript" src="<%=basePath%>js/global.js"></script>
</head>
<body>
<form id="protoform" action="" method="post" style="margin:15px;">
<input id="pageNum" type="hidden" name="page.pageNum" value="${page.pageNum}" />
<%-- for carSearchVO --%>
<input type="hidden" id="carNumber" name="carSearchVO.carNumber" value="${carSearchVO.carNumber}"/>
<input type="hidden" id="carIDCardID"  name="carSearchVO.carIDCardID" value="${carSearchVO.carIDCardID}"/>
<input type="hidden" id="carDept"  name="carSearchVO.carDept" value="${carSearchVO.carDept}"/>
<input type="hidden" id="carDriver"  name="carSearchVO.carDriver" value="${carSearchVO.carDriver}"/>
<input type="hidden" id="carLowerWeight"  name="carSearchVO.carLowerWeight" value="${carSearchVO.carLowerWeight}"/>
<input type="hidden" id="carHigherWeight"  name="carSearchVO.carHigherWeight" value="${carSearchVO.carHigherWeight}"/>
	<fieldset class="fieldsetStyle1">
		<legend>查看车辆信息</legend>
		<div id="" class="fieldsetDivStyle1">
			<table>
				<tr>
					<td width="20%" style="text-align:right;"><label for="textinput">ID卡号:</label></td>
					<td width="30%" style="text-align:left;"><div class="labelStyle4" style="overflow:hidden; text-overflow:ellipsis;" title="${carInfo.carIDCardID}">${carInfo.carIDCardID}</div></td>
					<td width="20%" style="text-align:right;"><label for="textinput">车辆所属单位:</label></td>
					<td width="30%" style="text-align:left;"><div class="labelStyle4" style="overflow:hidden; text-overflow:ellipsis;" title="${carInfo.carDept}">${carInfo.carDept}</div></td>
				</tr>
				<tr>
					<td width="20%" style="text-align:right;"><label for="textinput">车牌号:</label></td>
					<td width="30%" style="text-align:left;"><div class="labelStyle4" style="overflow:hidden; text-overflow:ellipsis;" title="${carInfo.carNumber}">${carInfo.carNumber}</div></td>
					<td width="20%" style="text-align:right;"><label for="textinput">驾驶员:</label></td>
					<td width="30%" style="text-align:left;"><div class="labelStyle4" style="overflow:hidden; text-overflow:ellipsis;" title="${carInfo.carDriver}">${carInfo.carDriver}</div></td>
				</tr>
			</table>
		</div>
	</fieldset>
	<fieldset class="fieldsetStyle1">
		<legend>重量信息</legend>
		<div id="" class="fieldsetDivStyle1">
			<table>
				<tr>
					<td width="20%" style="text-align:right;" style="line-height:20px;"><label for="textinput">毛重:</label></td>
					<td width="30%" style="text-align:left;"><div class="labelStyle4">${carInfo.tareWeight}</div></td>
					<td width="20%" style="text-align:right;"><label for="textinput">重量单位:</label></td>
					<td width="30%" style="text-align:left;"><div class="labelStyle4">吨</div></td>
				</tr>
			</table>
		</div>
	</fieldset>
	<fieldset class="fieldsetStyle1">
		<legend>备注信息</legend>
		<table>
			<tr>
				<td style="padding-left:110px;">
					<label for="textareainput">备注:</label>
				</td>
			</tr>
			<tr>
				<td style="padding-left:110px; height:140px;">
					<textarea id="carNotes" name="carInfo.carNotes" rows="8" cols="40" readOnly="readOnly">${carInfo.carNotes}</textarea>
				</td>
			</tr>
		</table>
	</fieldset>
	<div style="width:100%;">
		<div class="menu">
			<ul>
				<li>
					<a href="#" onclick="submitProtoform('listCar.action')">&nbsp;&nbsp;返&nbsp;&nbsp;回&nbsp;&nbsp;<br />
						<span></span>
					</a>
				</li>
			</ul>
		</div>
	</div>
	<br/>
</form>
</body>
</html>
<script type="text/javascript">
initInputAndTextarea();
</script>

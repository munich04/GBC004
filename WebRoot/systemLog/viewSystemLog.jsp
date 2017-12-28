<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>查看系统日志</title>
<meta http-equiv="Content-Type" content="text/html; charset=gbk" />
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/niceform.css"></link>
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/buttonForm.css"></link>
<script type="text/javascript">
	var basePath = "<%=basePath%>";
</script>
<script type="text/javascript" src="<%=basePath%>js/niceform.js"></script>
</head>
<body>
<fieldset class="fieldsetStyle1">
	<legend>查看系统日志</legend>
	<div id="" class="fieldsetDivStyle1">
		<table border="0" width="100%">
			<tr>
				<td width="40%" style="text-align:right;"><label for="textinput">操作类型：</label></td>
				<td width="60%" style="text-align:left;"><div class="labelStyle4" style="overflow:hidden; text-overflow:ellipsis;" title="${systemLogInfo.infoTypeStr}">${systemLogInfo.infoTypeStr}</div></td>
			</tr>
			<tr><td width="40%" style="text-align:right;"><label for="textinput">操作用户：</label></td>
				<td width="60%" style="text-align:left;"><div class="labelStyle4" style="overflow:hidden; text-overflow:ellipsis;" title="${systemLogInfo.operateUsername}">${systemLogInfo.operateUsername}</div></td>
			</tr>
			<tr>
				<td width="40%" style="text-align:right;"><label for="textinput">操作时间：</label></td>
				<td width="60%" style="text-align:left;"><div class="labelStyle4" style="overflow:hidden; text-overflow:ellipsis;" title="${systemLogInfo.recordTimeStr}">${systemLogInfo.recordTimeStr}</div></td>
			</tr>
			<tr>
				<td width="40%" style="text-align:right;"><label for="textinput">操作详情：</label></td>
				<td></td>
			</tr>
			<tr>
				<td colspan="2" style="text-align:center;">
					<textarea rows="5" cols="42" readOnly style="border:1px solid #DCDCDC; padding:5px; text-indent:2em;">${systemLogInfo.infoDetail}</textarea>
				</td>
			</tr>
		</table>
	</div>
</fieldset>
<div style="width:360px; text-align:center;">
	<div class="menu">
		<ul>
			<li>
				<a href="#"  onclick="window.close();">&nbsp;&nbsp;确&nbsp;&nbsp;定&nbsp;&nbsp;<br />
					<span></span>
				</a>
			</li>
		</ul>
	</div>
</div>
</body>
</html>
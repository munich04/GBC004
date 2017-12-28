<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%@page import="com.util.MyUtil"%>
<%@page import="com.po.UserInfo"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>查看个人信息</title>
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
	<legend>查看个人信息</legend>
	<div id="" class="fieldsetDivStyle1">
		<table>
			<tr>
				<td width="40%" style="text-align:right;"><label for="textinput">用户名:</label></td>
				<td width="60%" style="text-align:left;"><div class="labelStyle4" style="overflow:hidden; text-overflow:ellipsis;" title="${userInfo.userName}">${userInfo.userName}</div></td>
			</tr>
			<tr><td width="40%" style="text-align:right;"><label for="textinput">昵称:</label></td>
				<td width="60%" style="text-align:left;"><div class="labelStyle4" style="overflow:hidden; text-overflow:ellipsis;" title="${userInfo.nickName}">${userInfo.nickName}</div></td>
			</tr>
			<tr>
				<td width="40%" style="text-align:right;"><label for="textinput">注册时间:</label></td>
				<td width="60%" style="text-align:left;"><div class="labelStyle4" style="overflow:hidden; text-overflow:ellipsis;" title="${userInfo.registerTimeToLocalString}">${userInfo.registerTimeToLocalString}</div></td>
			</tr>
			<tr>
				<%Integer authority = ((UserInfo)session.getAttribute("userInfo")).getAuthority(); %>
				<td width="40%" style="text-align:right;"><label for="textinput">用户权限:</label></td>
				<td width="60%" style="text-align:left;"><div class="labelStyle4" style="overflow:hidden; text-overflow:ellipsis;" title="<%=MyUtil.AUTHORITY_DES_MAP.get(authority)%>"><%=MyUtil.AUTHORITY_DES_MAP.get(authority)%></div></td>
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
<script type="text/javascript">
initInputAndTextarea();
</script>

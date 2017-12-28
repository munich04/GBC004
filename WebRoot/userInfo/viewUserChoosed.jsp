<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>查看用户</title>
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
<%-- for userSearchVO --%>
<input type="hidden" id="carNumber" name="userSearchVO.nickNameVO" value="${userSearchVO.nickNameVO}"/>
<input type="hidden" id="carIDCardID"  name="userSearchVO.authorityVO" value="${userSearchVO.authorityVO}"/>
	<fieldset class="fieldsetStyle1">
		<legend>查看用户信息</legend>
		<div id="" class="fieldsetDivStyle1">
			<table>
				<tr>
					<td width="20%" style="text-align:right;"><label for="textinput">用户名:</label></td>
					<td width="30%" style="text-align:left;"><div class="labelStyle4" style="overflow:hidden; text-overflow:ellipsis;" title="${userInfo.userName}">${userInfo.userName}</div></td>
					<td width="20%" style="text-align:right;"><label for="textinput">昵称:</label></td>
					<td width="30%" style="text-align:left;"><div class="labelStyle4" style="overflow:hidden; text-overflow:ellipsis;" title="${userInfo.nickName}">${userInfo.nickName}</div></td>
				</tr>
				<tr>
					<td width="20%" style="text-align:right;"><label for="textinput">用户权限:</label></td>
					<td width="30%" style="text-align:left;"><div class="labelStyle4" style="overflow:hidden; text-overflow:ellipsis;" title="${userInfo.authorityToLocalString}">${userInfo.authorityToLocalString}</div></td>
					<td width="20%" style="text-align:right;"><label for="textinput">注册日期:</label></td>
					<td width="30%" style="text-align:left;"><div class="labelStyle4" style="overflow:hidden; text-overflow:ellipsis;" title="${userInfo.registerTimeToLocalString}">${userInfo.registerTimeToLocalString}</div></td>
				</tr>
			</table>
		</div>
	</fieldset>
	<div style="width:100%;">
		<div class="menu">
			<ul>
				<li>
					<a href="#" onclick="submitProtoform('listUser.action')">&nbsp;&nbsp;返&nbsp;&nbsp;回&nbsp;&nbsp;<br />
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

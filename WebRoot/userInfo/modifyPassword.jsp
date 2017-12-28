<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<title>修改密码</title>
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/niceform.css"></link>
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/buttonForm.css"></link>
<script type="text/javascript">
	var basePath = "<%=basePath%>";
</script>
<script type='text/javascript' src='<%=basePath%>js/niceform.js'></script>
<script>
	function checkAndSubmit(){
		var oldPasswordObj = document.getElementById("oldPassword");
		var newPasswordObj = document.getElementById("newPassword");
		var newPasswordAgainObj = document.getElementById("newPasswordAgain");
		if(oldPasswordObj.value != '${userInfo.passWord}'){
			alert("旧密码输入错误!请重新输入!");
			oldPasswordObj.value = "";
			oldPasswordObj.focus();
			return;
		}
		if(newPasswordObj.value != null && newPasswordObj.value != ""){
			if(newPasswordObj.value != newPasswordAgainObj.value){
				alert("两次输入的新密码不一致!请核对!");
				newPasswordAgainObj.focus();
				return;
			}
		}
		document.getElementById("protoform").submit();
		window.close();
	}
</script>
</head>
<body>
<form action="changeUserPwd.action" id="protoform" target="hiddenInnerIFrame" method="post">
<input type="hidden" name="userInfo.id" value="${userInfo.id}">
<input type="hidden" name="userInfo.userName" value="${userInfo.userName}">
<input type="hidden" name="userInfo.nickName" value="${userInfo.nickName}">
<input type="hidden" name="userInfo.registerTime" value="${userInfo.registerTime}">
<fieldset class="fieldsetStyle1">
	<legend>修改密码：</legend>
	<div id="" class="fieldsetDivStyle1">
		<table>
			<tr>
				<td width="50%" style="text-align:right;"><label for="textinput">请输入旧密码:</label></td>
				<td width="50%" style="text-align:left;">
					<input type="password" id="oldPassword" size="18"/>
				</td>
			</tr>
			<tr>
				<td width="50%" style="text-align:right;"><label for="textinput">请输入新密码:</label></td>
				<td width="50%" style="text-align:left;">
					<input type="password" id="newPassword" name="userInfo.passWord" size="18"/>
				</td>
			</tr>
			<tr>
				<td width="50%" style="text-align:right;"><label for="textinput">请再次输入新密码:</label></td>
				<td width="50%" style="text-align:left;">
					<input type="password" id="newPasswordAgain" size="18"/>
				</td>
			</tr>
		</table>
	</div>
</fieldset>
</form>
<div style="width:400px; text-align:center;">
	<div class="menu">
		<ul>
			<li>
				<a href="#" onclick="window.close();">&nbsp;&nbsp;取&nbsp;&nbsp;消&nbsp;&nbsp;<br />
					<span></span>
				</a>
			</li>
			<li>
				<a href="#" onclick="checkAndSubmit();">&nbsp;&nbsp;确&nbsp;&nbsp;定&nbsp;&nbsp;<br />
					<span></span>
				</a>
			</li>
		</ul>
	</div>
</div>
<%-- hiddenInnerIFrame for 弹窗窗口提交,无提示自关闭 --%>
<span style="visibility:hidden;">
	<iframe name="hiddenInnerIFrame" width="0" height="0" frameborder="0"></iframe>
</span>
</body>
</html>
<script>
	initInputAndTextarea();
</script>
<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<title>�޸�����</title>
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
			alert("�������������!����������!");
			oldPasswordObj.value = "";
			oldPasswordObj.focus();
			return;
		}
		if(newPasswordObj.value != null && newPasswordObj.value != ""){
			if(newPasswordObj.value != newPasswordAgainObj.value){
				alert("��������������벻һ��!��˶�!");
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
	<legend>�޸����룺</legend>
	<div id="" class="fieldsetDivStyle1">
		<table>
			<tr>
				<td width="50%" style="text-align:right;"><label for="textinput">�����������:</label></td>
				<td width="50%" style="text-align:left;">
					<input type="password" id="oldPassword" size="18"/>
				</td>
			</tr>
			<tr>
				<td width="50%" style="text-align:right;"><label for="textinput">������������:</label></td>
				<td width="50%" style="text-align:left;">
					<input type="password" id="newPassword" name="userInfo.passWord" size="18"/>
				</td>
			</tr>
			<tr>
				<td width="50%" style="text-align:right;"><label for="textinput">���ٴ�����������:</label></td>
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
				<a href="#" onclick="window.close();">&nbsp;&nbsp;ȡ&nbsp;&nbsp;��&nbsp;&nbsp;<br />
					<span></span>
				</a>
			</li>
			<li>
				<a href="#" onclick="checkAndSubmit();">&nbsp;&nbsp;ȷ&nbsp;&nbsp;��&nbsp;&nbsp;<br />
					<span></span>
				</a>
			</li>
		</ul>
	</div>
</div>
<%-- hiddenInnerIFrame for ���������ύ,����ʾ�Թر� --%>
<span style="visibility:hidden;">
	<iframe name="hiddenInnerIFrame" width="0" height="0" frameborder="0"></iframe>
</span>
</body>
</html>
<script>
	initInputAndTextarea();
</script>
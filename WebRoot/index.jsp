<%@ page language="java" import="java.util.*" pageEncoding="gbk"%>
<%@ taglib prefix="c" uri="/WEB-INF/c.tld"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
<head>
<base href="<%=basePath%>">
<title>��¼</title>
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/loginJspCss.css">
<script type="text/javascript">
function checkLogin(){
	var userName = document.getElementById("userName");
	var password = document.getElementById("password");
	if(userName.value == "" || userName.value == null){
		alert("����д�û���!");
		userName.focus();
		return;
	}
	if(password.value == "" || password.value == null){
		alert("����д����!");
		password.focus();
		return;
	}
	document.getElementById("protoform").action="<%=basePath%>loginUser.action";
	document.getElementById("protoform").submit();
}
</script>
</head>
<body>
<form id="protoform" action="" method="post">
<div id="div1">
	<div id="topDiv">��ƽ³��</div>
	<div id="mainDiv">
		<div>
			<span class="spanStyle1">�û�����&nbsp;<input id="userName" type="text" size="17" style="height:25px; padding-top:0.4em;" name="userInfo.userName" class="inputStyle1" value="1"></span>
		</div>
		<div>
			<span class="spanStyle1">��&nbsp;&nbsp;�룺&nbsp;<input id="password" type="password" size="15" name="userInfo.passWord" class="inputStyle1" value="1"></span>
		</div>
		<div style="text-align:right;">
			<span class="spanTxt" onmouseover="this.style.color='rgb(51, 147, 174)';" onmouseout="this.style.color='#515151'" onclick="location='<%=basePath%>register.jsp';">���û�ע��</span>&nbsp;&nbsp;
			<span class="spanBtn" onmouseover="this.style.color='rgb(51, 147, 174)';" onmouseout="this.style.color='#fff';" onclick="checkLogin();">��¼</span>
		</div>
	</div>
</div>
</form>
</body>
</html>
<script>
	<c:if test="${not empty errorMsg}">
		alert('${errorMsg}');
	</c:if>
</script>

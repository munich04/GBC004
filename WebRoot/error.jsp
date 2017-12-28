<%@ page language="java" import="java.util.*" pageEncoding="gbk"%>
<%@ taglib prefix="c" uri="/WEB-INF/c.tld"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
<head>
<base href="<%=basePath%>">
<title>出错啦!</title>
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/loginJspCss.css">
<style>
.mainDiv1 {
	width: 300px;
	height: 100px;
	background-color: #cccccc;
	border-style: double;
	border-color: #C0C0C0;
}
</style>
<script type="text/javascript" src="<%=basePath%>js/global.js"></script>
</head>
<body>
<form id="protoform" action="" method="post">
<div id="div1">
	<div class="mainDiv1">
		<div style="padding:30px; cursor:hand; text-align:left;" onclick="getParent().getElementById('cashButton').click();">
			<div style="magin:5px; color:#123456;">出错啦！</div>
			<div style="magin:5px; color:#123456;">点击返回登录页面！</div>
		</div>
	</div>
</div>
</form>
</body>
</html>

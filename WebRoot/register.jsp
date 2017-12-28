<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>注册</title>
<meta http-equiv="Content-Type" content="text/html; charset=gbk" />
	
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/niceform.css"></link>
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/buttonForm.css"></link>

<script type="text/javascript">
	var basePath = "<%=basePath%>";
</script>
<script type="text/javascript" src="<%=basePath%>js/niceform.js"></script>

<script type="text/javascript" src="<%=basePath%>js/formValidator.js"></script>

<script type="text/javascript">
	function checkAndSubmit(){
		var theForm = document.getElementById("protoform");
		if(validator.validate(theForm)){
			if(document.getElementById("password").value != document.getElementById("passwordAgain").value){
				alert("两次输入的密码不一致,请核对 !");
			}else{
				theForm.action = "<%=basePath%>registerUser.action";
				theForm.submit();
			}
		}
	}
</script>
</head>
<body>
<form id="protoform" action="" method="post" style="margin:15px;">
	<fieldset style="width:800px; height:230px; margin:25px auto; padding:100px 50px 10px 50px;">
		<legend><span style="background:#e0eeee; padding:15px; color:#3D59AB;">用户注册：</span></legend>
		<div id="" class="fieldsetDivStyle1">
			<table>
				<tr>
					<td width="20%" style="text-align:right;"><label for="textinput">用户名:</label></td>
					<td width="30%" style="text-align:left;"><input type="text" id="userName" name="userInfo.userName" size="18" value="" fname="用户名" require="require" maxLength="64"/></td>
				</tr>
				<tr>
					<td width="20%" style="text-align:right;"><label for="textinput">密码:</label></td>
					<td width="30%" style="text-align:left;"><input type="password" id="passWord" name="userInfo.passWord" size="18" value="" fname="密码" require="require" maxLength="64"/></td>
				</tr>
				<tr>
					<td width="20%" style="text-align:right;"><label for="textinput">确认密码:</label></td>
					<td width="30%" style="text-align:left;"><input type="password" id="passWordAgain" name="" fname="确认密码" require="require" size="18"/></td>
				</tr>
				<tr>
					<td width="20%" style="text-align:right;"><label for="textinput">昵称:</label></td>
					<td width="30%" style="text-align:left;"><input type="text" id="nickName" name="userInfo.nickName" size="18" value="" fname="昵称" require="require" maxLength="64"/></td>
				</tr>
			</table>
		</div>
		<div style="width:800px;">
			<div class="menu">
				<ul>
					<li>
						<a href="javascript:void(0);" onclick="submitProtoform('<%=basePath%>index.jsp');">&nbsp;&nbsp;取&nbsp;&nbsp;消&nbsp;&nbsp;<br />
							<span></span>
						</a>
					</li>
					<li>
						<a href="javascript:void(0);" id="submitButton1" onclick="checkAndSubmit();">&nbsp;&nbsp;注&nbsp;&nbsp;册&nbsp;&nbsp;<br />
							<span></span>
						</a>
					</li>
				</ul>
			</div>
		</div>
	</fieldset>
</form>
</body>
</html>
<script type="text/javascript">
initInputAndTextarea();
</script>

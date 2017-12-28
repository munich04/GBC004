<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>ע��</title>
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
				alert("������������벻һ��,��˶� !");
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
		<legend><span style="background:#e0eeee; padding:15px; color:#3D59AB;">�û�ע�᣺</span></legend>
		<div id="" class="fieldsetDivStyle1">
			<table>
				<tr>
					<td width="20%" style="text-align:right;"><label for="textinput">�û���:</label></td>
					<td width="30%" style="text-align:left;"><input type="text" id="userName" name="userInfo.userName" size="18" value="" fname="�û���" require="require" maxLength="64"/></td>
				</tr>
				<tr>
					<td width="20%" style="text-align:right;"><label for="textinput">����:</label></td>
					<td width="30%" style="text-align:left;"><input type="password" id="passWord" name="userInfo.passWord" size="18" value="" fname="����" require="require" maxLength="64"/></td>
				</tr>
				<tr>
					<td width="20%" style="text-align:right;"><label for="textinput">ȷ������:</label></td>
					<td width="30%" style="text-align:left;"><input type="password" id="passWordAgain" name="" fname="ȷ������" require="require" size="18"/></td>
				</tr>
				<tr>
					<td width="20%" style="text-align:right;"><label for="textinput">�ǳ�:</label></td>
					<td width="30%" style="text-align:left;"><input type="text" id="nickName" name="userInfo.nickName" size="18" value="" fname="�ǳ�" require="require" maxLength="64"/></td>
				</tr>
			</table>
		</div>
		<div style="width:800px;">
			<div class="menu">
				<ul>
					<li>
						<a href="javascript:void(0);" onclick="submitProtoform('<%=basePath%>index.jsp');">&nbsp;&nbsp;ȡ&nbsp;&nbsp;��&nbsp;&nbsp;<br />
							<span></span>
						</a>
					</li>
					<li>
						<a href="javascript:void(0);" id="submitButton1" onclick="checkAndSubmit();">&nbsp;&nbsp;ע&nbsp;&nbsp;��&nbsp;&nbsp;<br />
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

<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<title>手输ID卡号</title>
		
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/niceform.css"></link>
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/buttonForm.css"></link>

<script type="text/javascript">
	var basePath = "<%=basePath%>";
</script>
<script type='text/javascript' src='<%=basePath%>js/niceform.js'></script>
<script>
	function giveReturnValue(){
		var obj = document.getElementById("carIDCardID");
		if(obj.value == "" || obj.value == null){
			alert("请重新填写ID卡号!");
			obj.focus();
			return;
		}else if(isNaN(obj.value)){
			alert("ID卡号 为数字,请重新填写!");
			obj.value = "";
			obj.focus();
			return;
		}else{
			window.returnValue = obj.value;
			window.close();
		}
	}
</script>
</head>
<body>
<fieldset class="fieldsetStyle1">
	<legend>请输入ID卡号：</legend>
	<div id="" class="fieldsetDivStyle1">
		<table>
			<tr>
				<td width="30%" style="text-align:right;"><label for="textinput">ID卡号:</label></td>
				<td width="70%" style="text-align:left;">
					<input type="text" id="carIDCardID" size="18"/>
				</td>
			</tr>
		</table>
	</div>
</fieldset>
<div style="width:400px; text-align:center;">
	<div class="menu">
		<ul>
			<li>
				<a href="#" onclick="window.close();">&nbsp;&nbsp;取&nbsp;&nbsp;消&nbsp;&nbsp;<br />
					<span></span>
				</a>
			</li>
			<li>
				<a href="#" onclick="giveReturnValue();">&nbsp;&nbsp;确&nbsp;&nbsp;定&nbsp;&nbsp;<br />
					<span></span>
				</a>
			</li>
		</ul>
	</div>
</div>
</body>
</html>
<script>
	initInputAndTextarea();
</script>
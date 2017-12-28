<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<title>手输重量</title>
		
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/niceform.css"></link>
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/buttonForm.css"></link>

<script type="text/javascript">
	var basePath = "<%=basePath%>";
</script>
<script type='text/javascript' src='<%=basePath%>js/niceform.js'></script>
<script>
	function giveReturnValue(){
		var obj = document.getElementById("weightInput");
		if(obj.value == "" || obj.value == null){
			alert("请重新填写重量!");
			obj.focus();
			return;
		}else if(isNaN(obj.value)){
			alert("重量数据应为数字,请重新填写!");
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
	<legend>手输重量：</legend>
	<div id="" class="fieldsetDivStyle1">
		<table>
			<tr>
				<td width="50%" style="text-align:right;"><label for="textinput">请输入正确的重量数据:</label></td>
				<td width="50%" style="text-align:left;">
					<input type="text" id="weightInput" size="18"/>
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
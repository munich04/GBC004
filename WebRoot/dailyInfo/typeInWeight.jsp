<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<title>��������</title>
		
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
			alert("��������д����!");
			obj.focus();
			return;
		}else if(isNaN(obj.value)){
			alert("��������ӦΪ����,��������д!");
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
	<legend>����������</legend>
	<div id="" class="fieldsetDivStyle1">
		<table>
			<tr>
				<td width="50%" style="text-align:right;"><label for="textinput">��������ȷ����������:</label></td>
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
				<a href="#" onclick="window.close();">&nbsp;&nbsp;ȡ&nbsp;&nbsp;��&nbsp;&nbsp;<br />
					<span></span>
				</a>
			</li>
			<li>
				<a href="#" onclick="giveReturnValue();">&nbsp;&nbsp;ȷ&nbsp;&nbsp;��&nbsp;&nbsp;<br />
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
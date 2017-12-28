<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>添加矿物</title>
<meta http-equiv="Content-Type" content="text/html; charset=gbk" />
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/niceform.css"></link>
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/buttonForm.css"></link>
<script type="text/javascript">
	var basePath = "<%=basePath%>";
</script>
<script type="text/javascript" src="<%=basePath%>js/niceform.js"></script>

<script type="text/javascript" src="<%=basePath%>js/global.js"></script>
<script type="text/javascript" src="<%=basePath%>js/formValidator.js"></script>

<script type='text/javascript' src='<%=basePath%>dwr/interface/RS232Handler.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/interface/carManager.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/engine.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/util.js'></script>
<script type='text/javascript'>
	function doOnCancel(){
		submitProtoform("<%=basePath%>listMine.action");
	}
	
	function doCheckAndSubmit(){
		var en = /^[A-Za-z]+$/;
		var theProtoform = document.getElementById('protoform');
		if(validator.validate(theProtoform)){
			var code = document.getElementById("code");
			if(!en.test(code.value)){
				alert("矿物代码建议使用一个大写英文字母表示!请核对!");
				code.focus();
				return;
			}
			theProtoform.submit();
		}
	}
</script>
</head>
<body onload="document.body.focus();">
<form id="protoform" action="saveOrUpdateMine.action" method="post" class="niceform" style="margin:15px;">
	<fieldset class="fieldsetStyle1">
		<legend>新增矿物信息</legend>
		<div id="" class="fieldsetDivStyle1">
			<table>
				<tr>
					<td width="20%" style="text-align:right; padding-right:5px;"><label for="textinput">矿物名称:</label></td>
					<td width="30%" style="text-align:left; padding-left:5px;"><input type="text" id="name" name="mineInfo.name" size="18" value="" fname="矿物名称" require="require" maxLength="16"/></td>
				</tr>
				<tr>
					<td width="20%" style="text-align:right; padding-right:5px;"><label for="textinput">矿物代码:</label></td>
					<td width="30%" style="text-align:left; padding-left:5px;"><input type="text" id="code" name="mineInfo.code" size="18" value="" fname="矿物代码" require="require" maxLength="1" datatype="en"/></td>
				</tr>
			</table>
		</div>
	</fieldset>
	<div style="width:100%;">
		<div class="menu">
			<ul>
				<li>
					<a href="javascript:void(0);" onclick="doOnCancel();">&nbsp;&nbsp;取&nbsp;&nbsp;消&nbsp;&nbsp;<br />
						<span></span>
					</a>
				</li>
				<li>
					<a href="javascript:void(0);" id="submitButton1" onclick="doCheckAndSubmit();">&nbsp;&nbsp;提&nbsp;&nbsp;交&nbsp;&nbsp;<br />
						<span></span>
					</a>
				</li>
			</ul>
		</div>
	</div>
</form>
</body>
</html>
<script type="text/javascript">
initInputAndTextarea();
</script>

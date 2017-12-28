<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<title></title>
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/niceform.css"></link>
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/buttonForm.css"></link>
<style type="text/css">
	.specialSpan1{
		color:red;
		margin:0px 2px;
	}
</style>
<script type="text/javascript">
	var basePath = "<%=basePath%>";
</script>
<script type='text/javascript' src='<%=basePath%>js/niceform.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/interface/hangUpManager.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/engine.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/util.js'></script>
<script>
	function init(){
		var dailyInfoID = window.dialogArguments[0];
		var dailyNum = window.dialogArguments[1];
		var hangUpState = window.dialogArguments[2];
		
		document.getElementById("hangUpState").value = hangUpState;
		document.getElementById("dailyInfoID").value = dailyInfoID;
		document.getElementById("dailyNumSpan").innerHTML = dailyNum;
		if(hangUpState){
			document.title = "挂起";
			document.getElementById("legendTitleSpan").innerHTML = "挂起";	
			document.getElementById("operationSpan1").innerHTML = "挂起";		
			document.getElementById("operationSpan2").innerHTML = "挂起";		
		}else{
			document.title = "取消挂起";
			document.getElementById("legendTitleSpan").innerHTML = "取消挂起";	
			document.getElementById("operationSpan1").innerHTML = "取消挂起";	
			document.getElementById("operationSpan2").innerHTML = "取消挂起";		
		}
	}

	function checkAndSubmit(){
		var hangUpState = document.getElementById("hangUpState").value;
		var dailyInfoID = document.getElementById("dailyInfoID").value;
		var operateNotes = document.getElementById("operateNotes").value;
		hangUpManager.saveHangUpByDWR(dailyInfoID, operateNotes, hangUpState , '${userInfo.id}',function(){
			window.returnValue = "1";
			window.close();
		});
	}
</script>
</head>
<body>
<form action="saveOrUpdateHangUp.action" id="protoform" target="hiddenInnerIFrame" method="post">
<input type="hidden" id="hangUpState" name="hangUpOperation.hangUpState">
<input type="hidden" id="dailyInfoID" name="hangUpOperation.dailyInfoID">
<input type="hidden" id="operator" name="hangUpOperation.operator" value="${userInfo.nickName}">
<fieldset class="fieldsetStyle1">
	<legend><span id="legendTitleSpan">&nbsp;</span>操作：</legend>
	<div id="" class="fieldsetDivStyle1">
		<table>
			<tr>
				<td style="text-align:left; margin-left:50px;" colspan="2">
					<label for="textinput">您将对运单号为<span class="specialSpan1" id="dailyNumSpan">&nbsp;</span>的矿运记录执行<span class="specialSpan1" id="operationSpan1">&nbsp;</span>操作</label>
				</td>
			</tr>
			<tr>
				<td style="text-align:left;"><label for="textinput"><span id="operationSpan2">&nbsp;</span>原因:</label></td>
			</tr>
			<tr>
				<td style="text-align:left; height:140px;">
					<textarea id="operateNotes" name="hangUpOperation.operateNotes"></textarea>
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
	init();
</script>
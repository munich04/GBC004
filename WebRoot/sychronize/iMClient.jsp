<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%@page import="com.util.MyUtil"%>
<%@ taglib prefix="c" uri="/WEB-INF/c.tld"%>
<%@ taglib prefix="fn" uri="/WEB-INF/fn.tld" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<title>发起数据同步</title>
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/niceform.css"></link>
<style type="text/css">
	.fieldsetStyle1{
		font-size:13px;
		font-family: "微软雅黑";
		margin: 5px auto;
	}
	.fieldsetStyle2{
		font-size:13px;
		font-family: "微软雅黑";
		width:250px;
		height:269px;
		margin: 25px;
		float:left;
	}
	.legendStyle1 {
		font-size:13px;
		font-family: "微软雅黑";
		padding: 0px 5px;
		color: #3D59AB;
		line-height:25px;
	}
	.tipDivStyle1 {
		font-size:13px;
		font-family: "微软雅黑";
		padding: 0px 5px;
		color: #3D59AB;
		line-height:25px;
		margin:15px 15px 15px 50px;
	}
	.tipDivStyle3 {
		font-size:13px;
		font-family: "微软雅黑";
		width: 78px;
		margin: 3px;
		padding: 1px 5px;
		color: #ff0000;
	}
	.tipDivStyle4 {
		font-size:13px;
		font-family: "微软雅黑";
		color: #FF8000;
		cursor: hand;
		background: #f0eeee;
		text-decoration:underline;
	}
	.exportLabelStyle1 {
		margin: 3px;
		padding: 5px 10px;
		color: #3D59AB;
		background: #e0eeee;
		cursor: hand;
	}
	.exportLabelStyle2 {
		margin: 3px;
		padding: 5px 10px;
		color: orange;
		background: #e0eeee;
		cursor: hand;
	}
	.errorInfoStyle1{
		padding:2px 2px; 
		background:#f5f5f5;
		margin:3px 15px;
	}
</style>
<script type="text/javascript">
	var basePath = "<%=basePath%>";
</script>
<script type='text/javascript' src='<%=basePath%>dwr/interface/netUtil.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/interface/sychronizeManager.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/engine.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/util.js'></script>

<script type='text/javascript' src='<%=basePath%>js/global.js'></script>
<script>
	//打开日历控件
	function chooseMyDate(returnInputID, url, parameters, width, height){
		var returnValue = openModelDialog(url, parameters, width, height);
		if(returnValue != undefined && returnValue != null && returnValue != ""){
			dealWithReturnValue(returnValue);
		}
	}

	function dealWithReturnValue(returnValue){
		document.getElementById("startTime").value = returnValue;
		document.getElementById("startTimeMillis").value = changeLocalStringToStartMillis(returnValue);
	}

	//自动填充最近使用过的ip和端口
	function autoFillLatestUserIp(){
		sychronizeManager.getLatestUsedIp(1, function(ipList){
			if(ipList != null && ipList.length > 0){
				document.getElementById("ipInput").value = ipList[0].ip;
				document.getElementById("portInput").value = ipList[0].port;
			}
		})
	}

	var errorInfoInterval;
	
	function getClientInfo(){
		sychronizeManager.getClientInfo(function(data){
			document.getElementById("clientInfoDiv").innerHTML = data;
		});
	}

	function prepareSynchronizeData(){
		ipInput = document.getElementById("ipInput");
		portInput = document.getElementById("portInput");
		if(checkIP(ipInput) && checkPort(portInput)){

			netUtil.mockPingToGetDelay(ipInput.value, function(msDelay){
				//msDelay小于1000ms,认为网络质量可以接受
				if(msDelay >= 0 && msDelay <= 500){
					document.getElementById("clientInfoDiv").innerHTML = "<div class='errorInfoStyle1'>"+getTimeOfNow()+" : 网络平均延迟为 " + msDelay + " ms,可以进行有效传输!</div>";
					startSychronizeData(ipInput, portInput);
				}else{
					if(confirm("网络延迟过大,数据传输质量无法保证,是否继续?")){
						startSychronizeData(ipInput, portInput);
					}
				}
			});
		}
	}
	function startSychronizeData(ipInput, portInput){
		//保存本次输入的IP
		sychronizeManager.saveIpInfo(ipInput.value , portInput.value);
		
		var filePath = '<%=session.getServletContext().getRealPath("/").replace("\\","/")%>';
		//建立json数据文件
		sychronizeManager.createJsonFile(filePath, document.getElementById("startTimeMillis").value, function(fileName){
			//文件建立成功
			if(fileName != null && fileName != ""){
				//启动socket,传输文件
				sychronizeManager.startSychronize(ipInput.value, portInput.value, fileName, function(){
					if(errorInfoInterval != null){
						clearInterval(errorInfoInterval);
					}
					document.getElementById("clientInfoDiv").innerHTML = "&nbsp;";
					errorInfoInterval = setInterval(getClientInfo, 1000);
				});
			}//选定日无数据,提示是否更新?
			else{
				alert(document.getElementById("startTime").value + "没有矿运记录,不需要进行数据同步!");
			}
		});
	}
	
	function checkIP(ipInput){ 
		if(ipInput.value == "" || ipInput.value == null){
			alert("请输入IP地址!");
			ipInput.focus();
			return false;
		}
		var exp=/^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/; 
		var reg = ipInput.value.match(exp); 
		if(reg == null){
			alert("IP地址不合法");
			ipInput.focus();
			return false;
		}else{
			return true;
		}
	}
	function checkPort(portInput){
		if(portInput.value == null || portInput.value == ""){
			alert("请输入端口号!");
			portInput.focus();
			return false;
		}else if(isNaN(portInput.value) || parseInt(portInput.value) > 65535 || parseInt(portInput.value) < 0){
			alert("端口号必须为介于0-65535的整数!请核对!");
			portInput.focus();
			return false;
		}else{
			return true;
		}
	}
	function cancelSynchronizeData(){
		if(errorInfoInterval != null){
			clearInterval(errorInfoInterval);
		}
		document.getElementById("clientInfoDiv").innerHTML = "<div class='errorInfoStyle1'>"+getTimeOfNow()+" : 数据同步已关闭!</div>";
	}
	function selectIp(){
		var url = basePath + 'sychronize/chooseIp.jsp';
		var ipAndPortValue = window.showModalDialog(url, null, "dialogWidth=480px;dialogHeight=200px;status=no;");
		if(ipAndPortValue != undefined){
			document.getElementById("ipInput").value = ipAndPortValue[0];
			document.getElementById("portInput").value = ipAndPortValue[1];
		}
	}
</script>
</head>
<body onload="dealWithReturnValue(getDateOfToday());autoFillLatestUserIp();">
<form id="protoform" action="" method="post">
<input id="startTimeMillis" type="hidden">
<fieldset class="fieldsetStyle1">
	<legend class="legendStyle1">数据同步：</legend>
	<div id="" class="fieldsetDivStyle1">
		<table id="firstTable">
			<tr>
				<td width="12%" style="text-align:right;"><label>选择日期:</label></td>
				<td width="18%" style="text-align:left;" colspan="5">
					<img class='inputCorner' src='<%=basePath%>pic/niceform/input_left.gif'><input type='text' id='startTime' class='textinput' size='12' style='line-height:15px; width:180px;' value="" readonly="readonly" onclick="chooseMyDate(this.id, '<%=basePath%>util/jsCalendar.html', null, 280, 200);" /><img class='inputCorner' src='<%=basePath%>pic/niceform/input_right.gif'>
				</td>
			</tr>
			<tr>
				<td width="12%" style="text-align:right;"><label>请输入IP地址:</label></td>
				<td width="18%" style="text-align:left;">
					<img class='inputCorner' src='<%=basePath%>pic/niceform/input_left.gif'><input type='text' id='ipInput' name="addressInfo.ip" value="${addressInfo.ip}" class='textinput' size='12' style='line-height:15px; width:180px;'/><img class='inputCorner' src='<%=basePath%>pic/niceform/input_right.gif'>
				</td>
				<td width="12%" style="text-align:right;"><label>请输入端口号:</label></td>
				<td width="18%" style="text-align:left;">
					<img class='inputCorner' src='<%=basePath%>pic/niceform/input_left.gif'><input type='text' id='portInput' name="addressInfo.port" value="${addressInfo.port}" class='textinput' size='12' style='line-height:15px; width:180px;'/><img class='inputCorner' src='<%=basePath%>pic/niceform/input_right.gif'>
				</td>
				<td width="38%" style="padding-left:15px;">
					<label class="exportLabelStyle1" onmouseover="this.className='exportLabelStyle2'" onmouseout="this.className='exportLabelStyle1'" for="textinput" onclick="selectIp();">历史常用IP</label>
					<label class="exportLabelStyle1" onmouseover="this.className='exportLabelStyle2'" onmouseout="this.className='exportLabelStyle1'" for="textinput" onclick="prepareSynchronizeData();">开始同步数据</label>
					<label class="exportLabelStyle1" onmouseover="this.className='exportLabelStyle2'" onmouseout="this.className='exportLabelStyle1'" for="textinput" onclick="cancelSynchronizeData();">停止同步数据</label>
				</td>
			</tr>
		</table>
	</div>
</fieldset>
</form>
<fieldset class="fieldsetStyle1">
	<legend><span class="legendStyle1">数据同步日志：</span></legend>
	<div id="clientInfoDiv" style="width:90%; height:380px; overflow:auto;">
		&nbsp;
	</div>
</fieldset>
</body>
</html>
<script>
specifyParentNodeCssStyle("clientSychronize");
</script>
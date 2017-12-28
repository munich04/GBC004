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
<title>数据导出(Excel格式)</title>
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
</style>
<script type="text/javascript">
	var basePath = "<%=basePath%>";
</script>

<script type='text/javascript' src='<%=basePath%>dwr/interface/dailyManager.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/engine.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/util.js'></script>

<script type='text/javascript' src='<%=basePath%>js/global.js'></script>
<script>
	//打开日历控件
	function chooseMyDate(returnInputID, url, parameters, width, height){
		var returnValue = openModelDialog(url, parameters, width, height);
		if(returnValue != undefined && returnValue != null && returnValue != ""){
			document.getElementById("exportInfoDiv").innerHTML = "";
			dealWithReturnValue(returnInputID, returnValue);
		}
	}

	function dealWithReturnValue(returnInputID ,returnValue){
		document.getElementById(returnInputID).value = returnValue;

		var startMillis = document.getElementById("startTime").value;
		var endMillis = document.getElementById("endTime").value;
		
		if(startMillis == null || startMillis == "" || endMillis == null || endMillis == ""){
			return;
		}
		
		startMillis = changeLocalStringToStartMillis(startMillis);
		endMillis = changeLocalStringToEndMillis(endMillis);
		var hasFinished = true;

		if(parseInt(startMillis) > parseInt(endMillis)){
			alert("开始日期应该不大于结束日期!请核对!");
			document.getElementById("finishedCount").innerHTML = "&nbsp;";
			document.getElementById("weightFieldSet").innerHTML = "&nbsp;";
			return;
		}
		
		document.getElementById("startTimeMillis").value = startMillis;
		document.getElementById("endTimeMillis").value = endMillis;
		document.getElementById("hasFinished").value = hasFinished;

		dailyManager.countDailyInfoDuringSpecifidPeroid(startMillis, endMillis, hasFinished, function(finishedCount){
			document.getElementById("finishedCount").innerHTML = !checkNullOfString(finishedCount) ? finishedCount : "0";
		});

		dailyManager.countWeightOfMineTransferedDuringSpecifidPeroid(startMillis, endMillis, function(data){
			if(data != null){
				var weightFieldSet = document.getElementById("weightFieldSet");
				weightFieldSet.innerHTML = "";
				for(var i = 0; i < data.length;i++){
					var tmpDiv = document.createElement("<div class='tipDivStyle1'>");
					tmpDiv.innerHTML = data[i][0] + ":<span id='' class='tipDivStyle3'>&nbsp;" + parseFloat(data[i][1]).toFixed(3) + "</span>吨";
					weightFieldSet.appendChild(tmpDiv);
				}
			}
		});

		document.getElementById("viewButton1").onclick=function(){
			document.getElementById("hangUpState").value = false;
			document.getElementById("protoform").action = basePath + "searchDaily.action";
			document.getElementById("protoform").submit();
		}
	}
	function openFile(obj, url){
		obj.href = url + "?requestMillis=" + new Date().getTime();
		obj.onclick=function(){};
		obj.click();
	}
	function exportToTxt(){
	  var targetform =document.forms[0];
	  targetform.action="exportDailyTotxt.action";
	  targetform.submit();
	}
</script>
</head>
<body>
<form id="protoform" action="exportDaily.action" method="post">
<input id="hasFinished" type="hidden" name="dailySearchVO.hasFinished" value="${dailySearchVO.hasFinished}" />
<input id="startTimeMillis" type="hidden" name="dailySearchVO.startMillis" value="${dailySearchVO.startMillis}">
<input id="endTimeMillis" type="hidden" name="dailySearchVO.endMillis" value="${dailySearchVO.endMillis}" />
<input id="hangUpState" type="hidden" name="dailySearchVO.hangUpState" value="${dailySearchVO.hangUpState}" />
</form>
<fieldset class="fieldsetStyle1" style="width:95%; margin:5px 10px;">
	<legend class="legendStyle1">选择日期：</legend>
	<div id="" class="fieldsetDivStyle1">
		<table id="firstTable">
			<tr>
				<td width="12%" style="text-align:right;"><label>选择开始日期:</label></td>
				<td width="18%" style="text-align:left;" colspan="3">
					<img class='inputCorner' src='<%=basePath%>pic/niceform/input_left.gif'><input type='text' id='startTime' class='textinput' size='12' style='line-height:15px; width:180px;' value="${dailySearchVO.startMillisToLocalString}" readonly="readonly" onclick="chooseMyDate(this.id, '<%=basePath%>util/jsCalendar.html', null, 280, 200);" /><img class='inputCorner' src='<%=basePath%>pic/niceform/input_right.gif'>
				</td>
			</tr>
			<tr>
				<td width="12%" style="text-align:right;"><label>选择结束日期:</label></td>
				<td width="18%" style="text-align:left;">
					<img class='inputCorner' src='<%=basePath%>pic/niceform/input_left.gif'><input type='text' id='endTime' class='textinput' size='12' style='line-height:15px; width:180px;' value="${dailySearchVO.endMillisToLocalString}" readonly="readonly" onclick="chooseMyDate(this.id, '<%=basePath%>util/jsCalendar.html', null, 280, 200);" /><img class='inputCorner' src='<%=basePath%>pic/niceform/input_right.gif'>
				</td>
				<td width="70%" style="padding-left:15px;" colspan="3">
					<label class="exportLabelStyle1" onmouseover="this.className='exportLabelStyle2'" onmouseout="this.className='exportLabelStyle1'" for="textinput" onclick="document.getElementById('protoform').submit();">导出数据为Excel文件</label>
					<label class="exportLabelStyle1" onmouseover="this.className='exportLabelStyle2'" onmouseout="this.className='exportLabelStyle1'" for="textinput" onclick="exportToTxt();">导出数据为txt文件</label>
				</td>
			</tr>
		</table>
	</div>
</fieldset>
<fieldset id="" class="fieldsetStyle1" style="width:95%; margin:5px 10px;">
	<legend><span class="legendStyle1">统计信息：</span></legend>
	<div class="tipDivStyle1">
		该时间段内完成矿运:<span id="finishedCount" class="tipDivStyle3">&nbsp;&nbsp;&nbsp;</span>次&nbsp;(<span id="viewButton1" onmouseover="this.className='tipDivStyle4'" onmouseout="this.className=''">&nbsp;点击查看&nbsp;</span>)
	</div>
	<div id="weightFieldSet"></div>
</fieldset>
<fieldset class="fieldsetStyle1" style="width:95%; height:140px; margin:5px 10px;">
	<legend><span class="legendStyle1">导出信息：</span></legend>
	<div id="exportInfoDiv">
		<c:if test="${not empty exportInfoFilePath}">
				<div class="tipDivStyle1">
					文件已成功保存在：
				</div>
				<div class="tipDivStyle1">
					<div id="exportInfoFilePath" style="margin-left:50px; width:100%;" class="tipDivStyle3">${exportInfoFilePath}&nbsp;</div>
					<div style="margin-left:50px;">
						<% String contextPath = path + "/"; %>
						<c:set var="contextPath" value="<%=contextPath%>"/>
						<a id="openExcel" onmouseover="this.className='tipDivStyle4'" onmouseout="this.className=''" href="javscript:void(0);" onclick="openFile(this, '<%=basePath%>${fn:substringAfter(exportInfoFilePath, contextPath)}')">&nbsp;点击打开文件&nbsp;</a></div>
				</div>
		</c:if>
		<c:if test="${not empty exportInfoErrorInfo}">
				<div class="tipDivStyle1">
					文件保存出错：
				</div>
				<div class="tipDivStyle1">
					<span id="exportInfoErrorInfo" style="margin-left:50px;" class="tipDivStyle3">${exportInfoErrorInfo}</span>&nbsp;(<span id="exportAgain" onmouseover="this.className='tipDivStyle4'" onmouseout="this.className=''" onclick="document.getElementById('protoform').submit();">&nbsp;点击尝试重新导出&nbsp;</span>)
				</div>
		</c:if>
	</div>
</fieldset>
</body>
</html>
<script>
specifyParentNodeCssStyle("exportDaily");
<c:if test="${empty dailySearchVO.startMillis}">
	//由上一次导出的截止日期自动计算出本次导出的起始日期;
	dailyManager.getLastExportDate(function(data){
		if(data !=null && data != ""){
			dealWithReturnValue('startTime', data.nextStartTime);
			dealWithReturnValue('endTime', data.nextStartTime);
		}else{
			dealWithReturnValue('startTime', getDateOfToday());
			dealWithReturnValue('endTime', getDateOfToday());
		}
	});
</c:if>
<c:if test="${!empty dailySearchVO.startMillis}">
dealWithReturnValue('startTime', '${dailySearchVO.startMillisToLocalString}');
dealWithReturnValue('endTime', '${dailySearchVO.endMillisToLocalString}');
</c:if>
</script>
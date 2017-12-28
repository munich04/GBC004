<%@ page language="java" import="java.util.*" pageEncoding="gbk"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">
<title>票据打印</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">    
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<link id="printCssLink" rel="stylesheet" type="text/css" href="<%=basePath%>css/voucherGreen.css">
<link id="printCssLink" rel="stylesheet" type="text/css" href="<%=basePath%>css/buttonPrint.css">
<style type="text/css">
	.operateButtonStyle1{
		background:#e0eeee; 
		padding:8px; 
		cursor:hand; 
		color:#123456; 
		font-size:16px; 
		font-family:宋体; 
		font-weight:bold;
		margin: 0px 5px;
	}
	.operateButtonStyle2{
		background:#e0eeee; 
		padding:8px; 
		cursor:hand; 
		color:#F4A460; 
		font-size:16px; 
		font-family:宋体; 
		font-weight:bold;
		margin: 0px 5px;
	}
</style>
<!--media=print   这个属性可以在打印时有效-->
<style media="print">
	.Noprint{display:none;}
	
</style>
<script type="text/javascript">
	var basePath = "<%=basePath%>";
</script>
<script type='text/javascript' src='<%=basePath%>dwr/interface/dailyManager.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/engine.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/util.js'></script>
<script type='text/javascript' src='<%=basePath%>js/global.js'></script>
<script type="text/javascript"><!--
function maxWindow(){
	window.moveTo(0, 0);
	window.resizeTo(screen.availWidth+1,screen.availHeight+1);
}
function doOnload(){
	
	var curUrl = location.href + "";
	var entryID = curUrl.substr(curUrl.indexOf("=")+1);

	if(entryID!=""){
		dailyManager.loadDailyLoadInfoVOByID(entryID, true, function(dailyLoadInfoVO){
			if(dailyLoadInfoVO!=null){
				document.getElementById("yearSpan").innerHTML = dailyLoadInfoVO.yearOfInTime;
				document.getElementById("monthSpan").innerHTML = dailyLoadInfoVO.monthOfInTime;
				document.getElementById("dateSpan").innerHTML = dailyLoadInfoVO.dateOfInTime;
				document.getElementById("dailyNum1Span").innerHTML = changeDailyNum(dailyLoadInfoVO.dailyNumVO, dailyLoadInfoVO.outTimeVOToLocalStringSecStyle);
				document.getElementById("dailyNum2Span").innerHTML = dailyLoadInfoVO.dailyNumVO;
				document.getElementById("departureSpan").innerHTML = dailyLoadInfoVO.departureVO;
				document.getElementById("receiveDeptSpan").innerHTML = dailyLoadInfoVO.receiveDeptVO;
				document.getElementById("carDeptSpan").innerHTML = dailyLoadInfoVO.carDeptVO;
				document.getElementById("carNumberSpan").innerHTML = dailyLoadInfoVO.carNumberVO;
				document.getElementById("carDriverSpan").innerHTML = dailyLoadInfoVO.carDriverVO;
				document.getElementById("dailyNum2Span").innerHTML = dailyLoadInfoVO.dailyNumVO;
				document.getElementById("mineNameSpan").innerHTML = dailyLoadInfoVO.mineNameVO;
				document.getElementById("tareWeightSpan").innerHTML = dailyLoadInfoVO.tareWeightVO;
				if(dailyLoadInfoVO.grossWeightVO != null){
					document.getElementById("grossWeightSpan").innerHTML = dailyLoadInfoVO.grossWeightVO;
					document.getElementById("netWeightSpan").innerHTML = (parseFloat(dailyLoadInfoVO.grossWeightVO) - parseFloat(dailyLoadInfoVO.tareWeightVO)).toFixed(3);
				}
				document.getElementById("notesSpan").innerHTML = dailyLoadInfoVO.notesVO + "&nbsp;";
				document.getElementById("operatorSpan").innerHTML = dailyLoadInfoVO.operatorVO;
				document.getElementById("loadingInfoSpan").innerHTML = dailyLoadInfoVO.loadingInfoVO;
				document.getElementById("makingNotesSpan").innerHTML = dailyLoadInfoVO.makingNotesVO;

				displayRealPrintContent();
			}
		});
	}
}

function displayRealPrintContent(){
	<%-- 打印控件 需要对IE安全->不安全的active控件->选择提示 --%>
	var printContent = "";
	
	var realContentObj = document.getElementById("realPrintContent");
	
	for ( var i = 0; i < 1; i++) {
		//document.getElementById("realPrintNum").innerHTML = changeNumToChineseWord(i+1);
		if(i!=7){
			var tmpPageNextDiv = document.createElement("<div id='tmpPageNextDiv' class='PageNext'>");
			realContentObj.appendChild(tmpPageNextDiv);
		}
		printContent += "<div style='width:100%;'>";
		printContent += realContentObj.innerHTML;
		printContent += "</div>";
		
		if(document.getElementById("tmpPageNextDiv")){
			realContentObj.removeChild(document.getElementById("tmpPageNextDiv"));
		}
	}
	
	printContent += "<div style=\"width:550px;\" class=\"Noprint\">";
	printContent += "<div class=\"menu\"><ul>";
	//问题：
	//1.取消按钮不起作用？
	//2.每个表单不同颜色？
	//3.查看页面增加打印按钮：在本页面打印功能认可后进行；
	printContent += "<li><a href=\"javascript:void(0);\" onclick=\"window.opener=null;window.close();\">&nbsp;&nbsp;取&nbsp;&nbsp;消&nbsp;<br/><span></span></a></li>"
	printContent += "<li><a href=\"javascript:void(0);\" onclick='document.getElementById(\"WebBrowser\").ExecWB(6,6);'>&nbsp;直接打印&nbsp;<br/><span></span></a></li>";
	printContent += "<li><a href=\"javascript:void(0);\" onclick='document.getElementById(\"WebBrowser\").ExecWB(7,1);'>&nbsp;打印预览&nbsp;<br/><span></span></a></li>";
	printContent += "</ul></div></div>";

	printContent += "<OBJECT id=\"WebBrowser\" classid=\"CLSID:8856F961-340A-11D0-A96B-00C04FD705A2\" height=\"0\" width=\"0\" VIEWASTEXT></OBJECT>";

	document.body.innerHTML = printContent;

	maxWindow();
}

function changeNumToChineseWord(theNum){
	var returnStr = "";
	switch(theNum){
	case 1:returnStr="一";break;
	case 2:returnStr="二";break;
	case 3:returnStr="三";break;
	case 4:returnStr="四";break;
	case 5:returnStr="五";break;
	case 6:returnStr="六";break;
	case 7:returnStr="七";break;
	case 8:returnStr="八";break;
	case 9:returnStr="九";break;
	}
	return returnStr;	
}

function changeDailyNum(dailyNum, prefix){
	var returnValue = prefix;
	var totalLength = 3;
	var dailyNumStrLength = (dailyNum + "").length;
	for(var i=0; i < 3 - dailyNumStrLength; i++){
		returnValue += "0";
	}
	returnValue += dailyNum;
	return returnValue;
}
--></script>
</head>
<body onload="doOnload();">
<div id="realPrintContent" style="width:95%;">
	<div id="voucherDiv">
		<h1 style="margin:5px 0 10px 0;">新平鲁电矿业有限公司</h1>
		<h2 style="margin:8px;">(铁矿)货物运送清单</h2>
		<table id="headerTable" width="90%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="66%">&nbsp;<span id="yearSpan">&nbsp;</span>&nbsp;年&nbsp;<span id="monthSpan">&nbsp;</span>&nbsp;月&nbsp;<span id="dateSpan">&nbsp;</span>&nbsp;日&nbsp;</td>
				<td width="33%">No.<span id="dailyNum1Span">&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;</td>
			</tr>
		</table>
		<table id="mainTable" width="90%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>发货地点</td>
				<td colspan="2"><span id="departureSpan">&nbsp;</span></td>
				<td>收货单位</td>
				<td colspan="3"><span id="receiveDeptSpan" >&nbsp;</span></td>
			</tr>
			<tr>
				<td>承运单位</td>
				<td colspan="2"><span id="carDeptSpan">&nbsp;</span></td>
				<td>车牌号</td>
				<td><font id="carNumberSpan" >&nbsp;</font></td>
				<td>驾驶员</td>
				<td><span id="carDriverSpan" >&nbsp;</span></td>
			</tr>
			<tr>
				<td width="13%">日编号</td>
				<td width="13%">品名</td>
				<td width="13%">单位</td>
				<td width="17%">毛重</td>
				<td width="17%">皮重</td>
				<td width="13%">净重</td>
				<td width="13%">备注</td>
			</tr>
			<tr>
				<td><font id="dailyNum2Span">&nbsp;</font></td>
				<td><span id="mineNameSpan">&nbsp;</span></td>
				<td>吨</td>
				<td><font id="grossWeightSpan" style="width:130px; overflow:hidden;" >&nbsp;</font></td>
				<td><font id="tareWeightSpan" style="width:130px; overflow:hidden;" >&nbsp;</font></td>
				<td><font id="netWeightSpan" >&nbsp;</font></td>
				<td><font id="notesSpan" >&nbsp;</font></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
		</table>
		<table id="bottomTable" width="90%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="33%">过磅员：<span id="operatorSpan">&nbsp;</span></td>
				<td width="33%">装车：<span id="loadingInfoSpan">&nbsp;</span></td>
				<td width="33%">制单：<span id="makingNotesSpan">&nbsp;</span></td>
			</tr>
		</table>
	</div>
	<!-- <div id="rightDiv" name="rightDiv" class="rightDivStyle1" >第<br/><span id="realPrintNum">四</span><br/>联<br/>：<br/>运<br/>费<br/>结<br/>算 </div>  -->
</div>
</body>
</html>
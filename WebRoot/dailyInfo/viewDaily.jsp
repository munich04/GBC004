<%@ page language="java" import="java.util.*" pageEncoding="gbk"%>
<%@page import="com.util.MyUtil"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">
<title>查看明细</title>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">    
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">

<link id="printCssLink" rel="stylesheet" type="text/css" href="<%=basePath%>css/voucherGreen.css">
<link id="printCssLink" rel="stylesheet" type="text/css" href="<%=basePath%>css/buttonPrint.css">

<script type="text/javascript">
	var basePath = "<%=basePath%>";
</script>
<script type='text/javascript' src='<%=basePath%>js/global.js'></script>

<script type='text/javascript' src='<%=basePath%>dwr/interface/hangUpManager.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/interface/dailyManager.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/engine.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/util.js'></script>

<script type="text/javascript">
	var entryID = window.dialogArguments[0];
	var hasFinishedOrNot = window.dialogArguments[1];
	
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
	function initData(){
		if(entryID!=undefined && entryID!=null && entryID!=""){
			dailyManager.loadDailyLoadInfoVOByID(entryID, hasFinishedOrNot, function(dailyLoadInfoVO){
				if(dailyLoadInfoVO!=null){
					document.getElementById("yearSpan").innerHTML = dailyLoadInfoVO.yearOfInTime;
					document.getElementById("monthSpan").innerHTML = dailyLoadInfoVO.monthOfInTime;
					document.getElementById("dateSpan").innerHTML = dailyLoadInfoVO.dateOfInTime;
					document.getElementById("dailyNum1Span").innerHTML = changeDailyNum(dailyLoadInfoVO.dailyNumVO, dailyLoadInfoVO.outTimeVOToLocalStringSecStyle);
					document.getElementById("dailyNum2Span").innerHTML = changeEmptyStrToNBSP(dailyLoadInfoVO.dailyNumVO);
					document.getElementById("departureSpan").innerHTML = changeEmptyStrToNBSP(dailyLoadInfoVO.departureVO);
					document.getElementById("receiveDeptSpan").innerHTML = changeEmptyStrToNBSP(dailyLoadInfoVO.receiveDeptVO);
					document.getElementById("carDeptSpan").innerHTML = changeEmptyStrToNBSP(dailyLoadInfoVO.carDeptVO);
					document.getElementById("carNumberSpan").innerHTML = changeEmptyStrToNBSP(dailyLoadInfoVO.carNumberVO);
					document.getElementById("carDriverSpan").innerHTML = changeEmptyStrToNBSP(dailyLoadInfoVO.carDriverVO);
					document.getElementById("dailyNum2Span").innerHTML = changeEmptyStrToNBSP(dailyLoadInfoVO.dailyNumVO);
					document.getElementById("mineNameSpan").innerHTML = changeEmptyStrToNBSP(dailyLoadInfoVO.mineNameVO);
					document.getElementById("tareWeightSpan").innerHTML = changeEmptyStrToNBSP(dailyLoadInfoVO.tareWeightVO);
					if(dailyLoadInfoVO.grossWeightVO != null){
						document.getElementById("grossWeightSpan").innerHTML = dailyLoadInfoVO.grossWeightVO;
						document.getElementById("netWeightSpan").innerHTML = (parseFloat(dailyLoadInfoVO.grossWeightVO) - parseFloat(dailyLoadInfoVO.tareWeightVO)).toFixed(3);
					}
					document.getElementById("notesSpan").innerHTML = changeEmptyStrToNBSP(dailyLoadInfoVO.notesVO);
					document.getElementById("operatorSpan").innerHTML = changeEmptyStrToNBSP(dailyLoadInfoVO.operatorVO);
					document.getElementById("loadingInfoSpan").innerHTML = changeEmptyStrToNBSP(dailyLoadInfoVO.loadingInfoVO);
					document.getElementById("makingNotesSpan").innerHTML = changeEmptyStrToNBSP(dailyLoadInfoVO.makingNotesVO);
				}
			});
		}
	}

	function changeEmptyStrToNBSP(str){
		if(str == null || str == ""){
			str = "&nbsp;"
		}
		return str;
	}
	
	//切换css样式
	function changeCssLink(){
		var cssLink = document.getElementById("printCssLink");
		var cssLinkOne = "<%=basePath%>css/voucherGreen.css";
		var cssLinkTwo = "<%=basePath%>css/voucherOrange.css";
		cssLink.href = cssLink.href==cssLinkOne ? cssLinkTwo:cssLinkOne;
	}

	function openOperations(){
		openModelDialog("<%=basePath%>goToLoadHangUp.action", entryID, 800 ,550);		
	}
</script>
</head>
<body onload="initData();">
<div style="text-align:right; margin:10px;">
	<div>
		<span style="background:#e0eeee; padding:8px; cursor:hand; color:#123456; font-size:15px; font-family:;微软雅黑; font-weight:bold;" onmouseover="this.style.color='#F4A460'" onmouseout="this.style.color='#123456'" onclick="openOperations();">点击查看挂起操作记录</span>
		<span style="background:#e0eeee; padding:8px; cursor:hand; color:#123456; font-size:15px; font-family:;微软雅黑; font-weight:bold;" onmouseover="this.style.color='#F4A460'" onmouseout="this.style.color='#123456'" onclick="changeCssLink();">切换样式</span>
	</div>
</div>
<div style="width:100%;">
	<div id="voucherDiv">
		<h1 style="margin:5px 0 10px 0;">新平鲁电矿业有限公司</h1>
		<h2 style="margin:8px;">(铁矿)货物运送清单</h2>
		<table id="headerTable" width="90%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="66%" style="font-size:22px;">&nbsp;<span id="yearSpan">&nbsp;</span>&nbsp;年&nbsp;<span id="monthSpan">&nbsp;</span>&nbsp;月&nbsp;<span id="dateSpan">&nbsp;</span>&nbsp;日&nbsp;</td>
				<td width="33%"><span style="font-size:22px;">No.</span><span id="dailyNum1Span">&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;</td>
			</tr>
		</table>
		<table id="mainTable" width="90%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>发货地点</td>
				<td colspan="2"><span id="departureSpan">&nbsp;</span></td>
				<td>收货单位</td>
				<td colspan="3"><span id="receiveDeptSpan">&nbsp;</span></td>
			</tr>
			<tr>
				<td>承运单位</td>
				<td colspan="2"><span id="carDeptSpan">&nbsp;</span></td>
				<td>车牌号</td>
				<td><font id="carNumberSpan">&nbsp;</font></td>
				<td>驾驶员</td>
				<td><span id="carDriverSpan">&nbsp;</span></td>
			</tr>
			<tr>
				<td width="11%">日编号</td>
				<td width="11%">品名</td>
				<td width="11%">单位</td>
				<td width="16%">毛重</td>
				<td width="16%">皮重</td>
				<td width="11%">净重</td>
				<td width="11%">备注</td>
			</tr>
			<tr>
				<td><font id="dailyNum2Span">&nbsp;</font></td>
				<td><span id="mineNameSpan">&nbsp;</span></td>
				<td>吨</td>
				<td><font id="grossWeightSpan" style="width:120px; overflow:hidden;">&nbsp;</font></td>
				<td><font id="tareWeightSpan" style="width:120px; overflow:hidden;">&nbsp;</font></td>
				<td><font id="netWeightSpan">&nbsp;</font></td>
				<td><span id="notesSpan">&nbsp;</span></td>
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
				<td width="33%">过磅员：<span id="operatorSpan">&nbsp;&nbsp;</span></td>
				<td width="33%">装车：<span id="loadingInfoSpan">&nbsp;&nbsp;</span></td>
				<td width="33%">制单：<span id="makingNotesSpan">&nbsp;&nbsp;</span></td>
			</tr>
		</table>
	</div>
	<!-- <div id="rightDiv" name="rightDiv" class="rightDivStyle1">第<br/><span id="realPrintNum">四</span><br/>联<br/>：<br/>运<br/>费<br/>结<br/>算</div> -->
	<div style="width:380px;">
		<div class="menu">
			<ul>
				<li>
					<a href="javascript:void(0);" onclick="window.close();">&nbsp;&nbsp;返&nbsp;&nbsp;回&nbsp;&nbsp;<br />
						<span></span>
					</a>
				</li>
				<li>
					<a href="javascript:void(0);" onclick="toPrint();">&nbsp;&nbsp;打&nbsp;&nbsp;印&nbsp;&nbsp;<br />
						<span></span>
					</a>
				</li>
			</ul>
		</div>
	</div>	
</div>
</body>
</html>
<script>
function toPrint(){
	window.opener = null;
	window.close();
	//传递本次拉矿的DailyInfo的ID, 并打开打印窗口
	var features = "height=" + window.screen.availHeight+"px, width=" + window.screen.availWidth+ "px, top=0, left=0, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no, fullscreen=1";
	window.open("<%=basePath%>dailyInfo/print.jsp?entryID=" + entryID, "_blank", features);
}

</script>

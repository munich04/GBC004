<%@ page language="java" import="java.util.*" pageEncoding="gbk"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">
<title>Ʊ�ݴ�ӡ</title>
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
		font-family:����; 
		font-weight:bold;
		margin: 0px 5px;
	}
	.operateButtonStyle2{
		background:#e0eeee; 
		padding:8px; 
		cursor:hand; 
		color:#F4A460; 
		font-size:16px; 
		font-family:����; 
		font-weight:bold;
		margin: 0px 5px;
	}
</style>
<!--media=print   ������Կ����ڴ�ӡʱ��Ч-->
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
	<%-- ��ӡ�ؼ� ��Ҫ��IE��ȫ->����ȫ��active�ؼ�->ѡ����ʾ --%>
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
	//���⣺
	//1.ȡ����ť�������ã�
	//2.ÿ������ͬ��ɫ��
	//3.�鿴ҳ�����Ӵ�ӡ��ť���ڱ�ҳ���ӡ�����Ͽɺ���У�
	printContent += "<li><a href=\"javascript:void(0);\" onclick=\"window.opener=null;window.close();\">&nbsp;&nbsp;ȡ&nbsp;&nbsp;��&nbsp;<br/><span></span></a></li>"
	printContent += "<li><a href=\"javascript:void(0);\" onclick='document.getElementById(\"WebBrowser\").ExecWB(6,6);'>&nbsp;ֱ�Ӵ�ӡ&nbsp;<br/><span></span></a></li>";
	printContent += "<li><a href=\"javascript:void(0);\" onclick='document.getElementById(\"WebBrowser\").ExecWB(7,1);'>&nbsp;��ӡԤ��&nbsp;<br/><span></span></a></li>";
	printContent += "</ul></div></div>";

	printContent += "<OBJECT id=\"WebBrowser\" classid=\"CLSID:8856F961-340A-11D0-A96B-00C04FD705A2\" height=\"0\" width=\"0\" VIEWASTEXT></OBJECT>";

	document.body.innerHTML = printContent;

	maxWindow();
}

function changeNumToChineseWord(theNum){
	var returnStr = "";
	switch(theNum){
	case 1:returnStr="һ";break;
	case 2:returnStr="��";break;
	case 3:returnStr="��";break;
	case 4:returnStr="��";break;
	case 5:returnStr="��";break;
	case 6:returnStr="��";break;
	case 7:returnStr="��";break;
	case 8:returnStr="��";break;
	case 9:returnStr="��";break;
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
		<h1 style="margin:5px 0 10px 0;">��ƽ³���ҵ���޹�˾</h1>
		<h2 style="margin:8px;">(����)���������嵥</h2>
		<table id="headerTable" width="90%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="66%">&nbsp;<span id="yearSpan">&nbsp;</span>&nbsp;��&nbsp;<span id="monthSpan">&nbsp;</span>&nbsp;��&nbsp;<span id="dateSpan">&nbsp;</span>&nbsp;��&nbsp;</td>
				<td width="33%">No.<span id="dailyNum1Span">&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;</td>
			</tr>
		</table>
		<table id="mainTable" width="90%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>�����ص�</td>
				<td colspan="2"><span id="departureSpan">&nbsp;</span></td>
				<td>�ջ���λ</td>
				<td colspan="3"><span id="receiveDeptSpan" >&nbsp;</span></td>
			</tr>
			<tr>
				<td>���˵�λ</td>
				<td colspan="2"><span id="carDeptSpan">&nbsp;</span></td>
				<td>���ƺ�</td>
				<td><font id="carNumberSpan" >&nbsp;</font></td>
				<td>��ʻԱ</td>
				<td><span id="carDriverSpan" >&nbsp;</span></td>
			</tr>
			<tr>
				<td width="13%">�ձ��</td>
				<td width="13%">Ʒ��</td>
				<td width="13%">��λ</td>
				<td width="17%">ë��</td>
				<td width="17%">Ƥ��</td>
				<td width="13%">����</td>
				<td width="13%">��ע</td>
			</tr>
			<tr>
				<td><font id="dailyNum2Span">&nbsp;</font></td>
				<td><span id="mineNameSpan">&nbsp;</span></td>
				<td>��</td>
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
				<td width="33%">����Ա��<span id="operatorSpan">&nbsp;</span></td>
				<td width="33%">װ����<span id="loadingInfoSpan">&nbsp;</span></td>
				<td width="33%">�Ƶ���<span id="makingNotesSpan">&nbsp;</span></td>
			</tr>
		</table>
	</div>
	<!-- <div id="rightDiv" name="rightDiv" class="rightDivStyle1" >��<br/><span id="realPrintNum">��</span><br/>��<br/>��<br/>��<br/>��<br/>��<br/>�� </div>  -->
</div>
</body>
</html>
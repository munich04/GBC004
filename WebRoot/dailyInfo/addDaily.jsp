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
<title>日常矿运刷卡、称重</title>
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
		font-size:15px; 
		font-family:微软雅黑; 
		font-weight:bold;
		margin: 0px 5px;
	}
	.operateButtonStyle2{
		background:#e0eeee; 
		padding:8px; 
		cursor:hand; 
		color:#F4A460; 
		font-size:15px; 
		font-family:微软雅黑; 
		font-weight:bold;
		margin: 0px 5px;
	}
</style>
<script type="text/javascript">
	var basePath = "<%=basePath%>";
</script>
<script type="text/javascript" src="<%=basePath%>js/global.js"></script>
<script type="text/javascript" src="<%=basePath%>js/formValidator.js"></script>
	
<script type='text/javascript' src='<%=basePath%>dwr/interface/mineManager.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/interface/dailyManager.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/interface/carManager.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/interface/RS232Handler.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/engine.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/util.js'></script>

<script type="text/javascript">
var mineArray = new Array();	//加载所有矿物	
//进入页面就开始读取RS232的数据,在刷卡后,根据情况将该数据填写到表格中;
var rs232DataTimeout;
var inOrOut = "";
var collectDataFlag = true;
function getDataConstantly(){
	rs232DataTimeout = setInterval(getAndSetRS232Data, 1000);
}
function getAndSetRS232Data(){
	RS232Handler.getRS232Data(function(data){
		if(!checkNullOfString(data)){
			if(collectDataFlag){
				var rs232Data = (parseFloat(data)).toFixed(3) ;
				
				document.getElementById("weightContent").innerHTML = rs232Data + " 吨 ";
				if(inOrOut == "in"){
					document.getElementById("tareWeight").value = rs232Data;
					document.getElementById("tareWeightSpan").innerHTML = rs232Data;
				}//出矿和二次过磅时,计算净重
				else if(inOrOut == "out" || inOrOut == "secWeight"){
					document.getElementById("grossWeight").value = rs232Data;
					document.getElementById("grossWeightSpan").innerHTML = rs232Data;

					var tmpTareWeightValue = document.getElementById("tareWeight").value;
					if(!isNaN(tmpTareWeightValue)){
						document.getElementById("netWeightSpan").innerHTML = (rs232Data - parseFloat(tmpTareWeightValue)).toFixed(3);
					}
				}
			}		
		}
	});
}

function doOnCancel(){
	if(rs232DataTimeout!=undefined){
		clearInterval(rs232DataTimeout);
	}
	window.opener=null;
	window.close();
}

var IDCardNum = "";	//该字符串记录刷卡后得到的ID卡号

document.onkeydown=dokeydown;	//键盘监听事件

var ietype = (document.layers) ? 1 : 0;		//判断浏览器类型

//键盘监听事件
function dokeydown(e){              
	var key = (ietype)? e.which : event.keyCode;
	//读卡实际上是自动按键盘来输入,最后以回车(keyCode=13)为结束;
	if(key != '13'){
		IDCardNum += changeKeycodeToNumber(key) + "";
	}else{
		doAfterGetIDCardIDSuccess(IDCardNum);
	}
}

//将keycode转换为数字;键盘0的keycode值为48;键盘9的keycode值为57;
function changeKeycodeToNumber(keycode){
	var numberValue = 0;
	if(keycode >=48 && keycode <= 57){
		numberValue = keycode - 48;
	}
	return numberValue;
}

//成功读取到ID卡号后需要做的事
function doAfterGetIDCardIDSuccess(theIDCardNum){
	//首先清空所有隐藏域的值和显示Span的内容;
	doClearHiddenInputAndSpan();
	
	document.getElementById("carIDCardID").value = theIDCardNum;	//填写卡号;
	
	//填写表单上的年月日
	var curDate = new Date();
	document.getElementById("yearSpan").innerHTML = curDate.getYear();
	document.getElementById("monthSpan").innerHTML = curDate.getMonth() + 1;
	document.getElementById("dateSpan").innerHTML = curDate.getDate();
	
	//根据IDCardNum加载车辆信息;
	loadCarInfoByCarIDCarID(theIDCardNum);
}

//清空所有隐藏域的value和显示Span的内容;
function doClearHiddenInputAndSpan(){
	var inputs = document.getElementsByTagName("input");
	for(var i = 0; i < inputs.length ; i++){
		inputs[i].value = "";
	}
	var spans = document.getElementsByTagName("span");
	for(var i = 0; i < spans.length ; i++){
		var spanObj = spans[i];
		if(spanObj.id.substr(spanObj.id.length-4) == "Span"){
			spanObj.innerHTML = "&nbsp;";
		}
	}
}

//根据IDCardNum加载车辆信息;
//针对有时  因为未知原因  明明数据库里有数据  但是查询出来的结果确实null 的情况,如果查询出null,重新查询;
//如果连查3次还有问题,则请求用户重新刷卡,或手动填写数据;
var maxQueryTime = 0;
function loadCarInfoByCarIDCarID(IDCardNum){
	carManager.getCarInfoByCarIDCardID(IDCardNum, function(carInfo){
		//读取过程发生异常,得到的值若为null
		if(carInfo.carIDCardID == null || carInfo.carDept == null || carInfo.carDriver == null || carInfo.carNumber == null){
			maxQueryTime++;
			if(maxQueryTime < 3){
				loadCarInfoByCarIDCarID(IDCardNum);
			}else{
				alert("获取ID卡信息失败!请重新\"刷卡\"或\"输入卡号\"!");
				maxQueryTime = 0;
			}
		}//读取车辆信息成功,填写信息;
		else{
			document.getElementById("carIDCardID").value = carInfo.carIDCardID;	//隐藏input,读取并填写"ID卡号"
			//填充表单
			document.getElementById("carDeptSpan").innerHTML = carInfo.carDept;			//填写"承运单位"
			document.getElementById("carDriverSpan").innerHTML = carInfo.carDriver;		//填写"驾驶员"
			document.getElementById("carNumberSpan").innerHTML = carInfo.carNumber;		//填写"车牌号"

			//成功读取车辆信息后，下一步要做的工作
			doAfterLoadCarInfoSuccess(IDCardNum);
		}
	});
}

function changeNulltoEmptyString(theValue){
	return theValue == null ? " &nbsp; " : theValue;
}

//成功读取车辆信息后，判断当前操作是"正常进出矿"还是"二次过磅";
function doAfterLoadCarInfoSuccess(theIDCardNum){
	//如何判断二次过磅?同一辆货车接连两次刷卡的时间短于2小时,认定是在进行"二次过磅"操作;
	dailyManager.goOutNormallyOrWeightAgain(theIDCardNum, function(dailyInfoID){
		//二次过磅出矿时要做的事：
		if(dailyInfoID != null && dailyInfoID != ""){ 
			inOrOut = "secWeight";
			doDailyAbnormally(dailyInfoID);
		}//正常进出矿时要做的事：
		else{
			doDailyNormally(theIDCardNum);
		}
	});
}

//二次过磅出矿时要做的事
function doDailyAbnormally(dailyInfoID){
	document.getElementById("submitAndPrintButton").childNodes[0].nodeValue = " 二次过磅 ";
	
	dailyManager.loadDailyLoadInfoVOByID(dailyInfoID, true, function(dailyLoadInfoVO){
		//因为二次过磅是update操作,所以必须加载entryID
		if(document.getElementById("entryID") == undefined){
			var idInput = document.createElement("<input type=\"hidden\" id=\"entryID\" name=\"dailyInfo.id\"/>");
			document.getElementById("protoform").appendChild(idInput);
		}
		document.getElementById("entryID").value = dailyInfoID;
		
		//填写离矿时间
		document.getElementById("outTime").value = new Date().getTime();

		//填写编号信息
		document.getElementById("dailyNum").value = dailyLoadInfoVO.dailyNumVO;//读取并填写日编号
		document.getElementById("dailyNum1Span").innerHTML = changeDailyNum(changeNulltoEmptyString(dailyLoadInfoVO.dailyNumVO));
		document.getElementById("dailyNum2Span").innerHTML = changeNulltoEmptyString(dailyLoadInfoVO.dailyNumVO);

		document.getElementById("inTime").value = dailyLoadInfoVO.inTimeVO;	//读取并填写进入时间

		document.getElementById("receiveDept").value = dailyLoadInfoVO.receiveDeptVO;	//读取并填写收货单位
		document.getElementById("receiveDeptSpan").innerHTML = changeNulltoEmptyString(dailyLoadInfoVO.receiveDeptVO);	

		document.getElementById("departure").value = dailyLoadInfoVO.departureVO;	//读取并填写发货地点
		document.getElementById("departureSpan").innerHTML = changeNulltoEmptyString(dailyLoadInfoVO.departureVO);	
		
		document.getElementById("tareWeight").value = dailyLoadInfoVO.tareWeightVO;	//读取并填写皮重
		document.getElementById("tareWeightSpan").innerHTML = changeNulltoEmptyString(dailyLoadInfoVO.tareWeightVO);

		document.getElementById("operator").value = dailyLoadInfoVO.operatorVO;
		document.getElementById("operatorSpan").innerHTML = changeNulltoEmptyString(dailyLoadInfoVO.operatorVO);

		document.getElementById("hangUpState").value = false;	//未挂起的正常状态
		
		//读取并填写品名
		document.getElementById("mineName").value = dailyLoadInfoVO.mineCodeVO;
		document.getElementById("mineNameSpan").innerHTML = dailyLoadInfoVO.mineNameVO;
		//品名是可以修改的
		document.getElementById("mineNameTd").onmouseover = function(){
			chooseMine(this);
		}
		mineManager.getAllMine(function(data){
			if(data != null){
				//创建可修改的矿种列表
				dealWithMineName(data);
			}
		});
	});

	IDCardNum = "";	//清空IDCardNum

	document.getElementById("submitAndPrintButton").onclick = function(){
		var theProtoform = document.getElementById('protoform');
		if(validator.validate(theProtoform)){
			theProtoform.submit();
			/* 如果是离矿,那么提交后,询问是否打印  */
			if(inOrOut == "secWeight" && confirm("提交成功,是否打印？")){
				dealWithPrint();
			}
			window.returnValue="1";//返回值为"1",则刷新父窗口;
			window.close();
		}
	};
}

//正常进出矿时要做的事
function doDailyNormally(theIDCardNum){
	document.getElementById("submitAndPrintButton").childNodes[0].nodeValue = "  提  交  ";
	//刷卡读取信息成功,判断本车是要进入,还是离开,并做出相应的不同的处理
	//hasEntered=in:没有进入记录,卡车要进入;hasEntered=out:已有进入记录,卡车要离开;
	dailyManager.checkIfTheCarHasnotLeave(theIDCardNum, function(hasEntered){
		//根据是进矿还是出矿,填充皮重或者净重;
		inOrOut = hasEntered;
		
		//进矿时要做的事
		if(hasEntered == 'in'){				
			//填写进矿时间
			document.getElementById("inTime").value = new Date().getTime();

			//填写收货单位
			document.getElementById("receiveDept").value = "<%=MyUtil.RECEIVEDEPT%>";
			document.getElementById("receiveDeptSpan").innerHTML = "<%=MyUtil.RECEIVEDEPT%>";
		
			//填写发货地点
			document.getElementById("departure").value = "<%=MyUtil.DEPARTURE%>";
			//document.getElementById("departure").value = "鲁电矿业";
			document.getElementById("departureSpan").innerHTML = "<%=MyUtil.DEPARTURE%>";
			//document.getElementById("departureSpan").innerHTML = "鲁电矿业";
			
			document.getElementById("operator").value = "${userInfo.nickName}";
			document.getElementById("operatorSpan").innerHTML = "${userInfo.nickName}";
			
			//计算并填写日编号
			dailyManager.calculateDailyNum(function(dailyNumValue){
				document.getElementById("dailyNum").value = dailyNumValue;
				document.getElementById("dailyNum1Span").innerHTML = changeDailyNum(changeNulltoEmptyString(dailyNumValue));
				document.getElementById("dailyNum2Span").innerHTML = changeNulltoEmptyString(dailyNumValue);
			});

			//如果有dailyInfo.entyrID的input,则删除
			if(document.getElementById("entryID") != undefined){
				document.getElementById("protoform").removeChild(document.getElementById("entryID"));
			}
		}//出矿时要做的事
		else if(hasEntered == 'out'){
			//正常出矿时要做的事：							
			//填写离矿时间
			document.getElementById("outTime").value = new Date().getTime();

			document.getElementById("mineNameTd").onmouseover = function(){
				chooseMine(this);
			}
			
			//读取并填写品名
			mineManager.getAllMine(function(data){
				if(data != null){
					//创建可修改的矿种列表
					dealWithMineName(data);
					
					document.getElementById("mineName").value = data[0].code;	
					document.getElementById("mineNameSpan").innerHTML = changeNulltoEmptyString(data[0].name);
				}
			});
			
			//查询并填写日编号等信息
			dailyManager.loadEnteredDailyInfoByCarIDCardID(theIDCardNum, function(dailyInfoEntry){
				if(document.getElementById("entryID") == undefined){
					var idInput = document.createElement("<input type=\"hidden\" id=\"entryID\" name=\"dailyInfo.id\"/>");
					document.getElementById("protoform").appendChild(idInput);
				}
				document.getElementById("entryID").value = dailyInfoEntry.id;
										
				document.getElementById("dailyNum").value = dailyInfoEntry.dailyNum;//读取并填写日编号
				document.getElementById("dailyNum1Span").innerHTML = changeDailyNum(changeNulltoEmptyString(dailyInfoEntry.dailyNum));
				document.getElementById("dailyNum2Span").innerHTML = changeNulltoEmptyString(dailyInfoEntry.dailyNum);
				
				document.getElementById("inTime").value = dailyInfoEntry.inTime;	//读取并填写进入时间

				document.getElementById("receiveDept").value = dailyInfoEntry.receiveDept;	//读取并填写收货单位
				document.getElementById("receiveDeptSpan").innerHTML = changeNulltoEmptyString(dailyInfoEntry.receiveDept);	

				document.getElementById("departure").value = dailyInfoEntry.departure;	//读取并填写发货地点
				document.getElementById("departureSpan").innerHTML = changeNulltoEmptyString(dailyInfoEntry.departure);	
				
				document.getElementById("tareWeight").value = dailyInfoEntry.tareWeight;	//读取并填写皮重
				document.getElementById("tareWeightSpan").innerHTML = changeNulltoEmptyString(dailyInfoEntry.tareWeight);

				document.getElementById("operator").value = dailyInfoEntry.operator;
				document.getElementById("operatorSpan").innerHTML = changeNulltoEmptyString(dailyInfoEntry.operator);

				document.getElementById("hangUpState").value = false;	//未挂起的正常状态
			});
		}
		IDCardNum = "";	//清空IDCardNum
	});
	document.getElementById("submitAndPrintButton").onclick = function(){
		var theProtoform = document.getElementById('protoform');
		if(validator.validate(theProtoform)){
			theProtoform.submit();
			/* 如果是离矿,那么提交后,询问是否打印  */
			if(inOrOut == "out" && confirm("提交成功,是否打印？")){
				dealWithPrint();
			}
			window.returnValue="1";//返回值为"1",则刷新父窗口;
			window.close();
		}
	};
}

//品名是可以选择的,通过浮动div显示其它品名
function chooseMine(tdObj){
	var hiddenDiv = document.getElementById("hiddenDiv1");
	
	var posLeftAndTop = getPosLeftTop(tdObj);
	
	var left = posLeftAndTop[0];
	var top = posLeftAndTop[1] + tdObj.offsetHeight;
	var width = tdObj.offsetWidth;
	var height = 30 * mineArray.length;
	
	hiddenDiv.style.cssText = "position:absolute; left:" + left + "; top:" + top + "; width: " + width + ";height:" + height + "; background:#fff; border:1px solid #FFE384";
	hiddenDiv.style.display = "";
}

//为浮动div加载其它品名数据
function dealWithMineName(data){
	var hiddenDiv = document.getElementById("hiddenDiv1");
	hiddenDiv.innerHTML = "";
	
	for(var i = 0; i < data.length;i++){
		var tmpDiv = document.createElement("<div style='margin: 5px; padding:3px 5px; background:#dcdcdc; color:#123456; font-weight:bold; cursor:hand;>");
		tmpDiv.innerHTML = data[i].name;	
		tmpDiv.setAttribute("mineCode", data[i].code);
		
		tmpDiv.onmouseover = function(){
			this.style.color = "orange";
		}
		tmpDiv.onmouseout = function(){
			this.style.color = "#123456";
		}

		hiddenDiv.appendChild(tmpDiv);
		tmpDiv.onclick = function(){
			document.getElementById("mineName").value = this.getAttribute("mineCode");	
			document.getElementById("mineNameSpan").innerHTML = changeNulltoEmptyString(this.innerHTML);
			hiddenDiv.style.display = "none";
		}
	}
}

//处理打印
function dealWithPrint(){
	//传递本次拉矿的DailyInfo的ID, 并打开打印窗口
	var features = "height=" + window.screen.availHeight+"px, width=" + window.screen.availWidth+ "px, top=0, left=0, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no, fullscreen=1";
	var theEntryID = "";
	if(document.getElementById("entryID")){
		theEntryID = document.getElementById("entryID").value;
	}
	window.open("<%=basePath%>dailyInfo/print.jsp?entryID=" + theEntryID, "_blank", features);
}

//处理日编号
function changeDailyNum(dailyNum){
	var returnValue = getDateOfTodayInSecStyle();;
	var totalLength = 3;
	var dailyNumStrLength = (dailyNum + "").length;
	for(var i=0; i < 3 - dailyNumStrLength; i++){
		returnValue += "0";
	}
	returnValue += dailyNum;
	return returnValue;
}

//切换css样式
function changeCssLink(){
	var cssLink = document.getElementById("printCssLink");
	var cssLinkOne = "<%=basePath%>css/voucherGreen.css";
	var cssLinkTwo = "<%=basePath%>css/voucherOrange.css";
	cssLink.href = cssLink.href==cssLinkOne ? cssLinkTwo:cssLinkOne;
}

//手动输入ID卡号
function typeInIDCardIDByUser(){
	var idCardID = openModelDialog(basePath + "dailyInfo/typeInIDCardID.jsp", null, 500, 180);
	if(idCardID != null && idCardID != "" && idCardID != undefined){
		doAfterGetIDCardIDSuccess(idCardID);
	}
}

//手动输入皮重
function typeInTareWeightByUser(){
	var weightValue = openModelDialog(basePath + "dailyInfo/typeInWeight.jsp", null, 500, 180);
	if(weightValue != null && weightValue != "" && weightValue != undefined){
		document.getElementById("tareWeight").value = weightValue;
		document.getElementById("tareWeightSpan").innerHTML = weightValue;
		
	}
}

//手动输入毛重
function typeInGrossWeightByUser(){
	var weightValue = openModelDialog(basePath + "dailyInfo/typeInWeight.jsp", null, 500, 180);
	if(weightValue != null && weightValue != "" && weightValue != undefined){
		document.getElementById("grossWeight").value = weightValue;
		document.getElementById("grossWeightSpan").innerHTML = weightValue;

		var tareWeightValue = document.getElementById("tareWeight").value;
		if(tareWeightValue!=null && tareWeightValue!="" && !isNaN(tareWeightValue)){
			document.getElementById("netWeightSpan").innerHTML = (parseFloat(weightValue) - parseFloat(tareWeightValue)).toFixed(3);
		}
	}
}

function continueCollectData(){
	collectDataFlag = true;
}

function stopCollectData(){
	collectDataFlag = false;
	if(inOrOut == "in"){
		typeInTareWeightByUser();
	}else if(inOrOut == "out" || inOrOut == "secWeight"){
		typeInGrossWeightByUser();
	}
}
</script>
<style>
</style>
</head>
<body onload="document.body.focus();getDataConstantly();">
<%-- target=hiddenInnerIFrame 是为了让页面提交给自己,而不再让弹出的本窗口再提交表单时再弹出一个新的怪异窗口 --%>
<form id="protoform" action="saveOrUpdateDaily.action" target="hiddenInnerIFrame" method="post">
	<input type="hidden" id="dailyNum" name="dailyInfo.dailyNum" value="${dailyInfo.dailyNum}"/>
	<input type="hidden" id="carIDCardID" name="dailyInfo.carIDCardID" value="${dailyInfo.carIDCardID}"/>
	<input type="hidden" id="mineName" name="dailyInfo.mineName" value="${dailyInfo.mineName}"/>
	<input type="hidden" id="grossWeight" name="dailyInfo.grossWeight" value="${dailyInfo.grossWeight}"/>
	<input type="hidden" id="tareWeight" name="dailyInfo.tareWeight" value="${dailyInfo.tareWeight}"/>
	<input type="hidden" id="receiveDept" name="dailyInfo.receiveDept" value="${dailyInfo.receiveDept}"/>
	<input type="hidden" id="departure" name="dailyInfo.departure" value="${dailyInfo.departure}"/>
	<input type="hidden" id="operator" name="dailyInfo.operator" value="${dailyInfo.operator}"/>
	<input type="hidden" id="loadingInfo" name="dailyInfo.loadingInfo" value="${dailyInfo.loadingInfo}"/>
	<input type="hidden" id="makingNotes" name="dailyInfo.makingNotes" value="${dailyInfo.makingNotes}"/>
	<input type="hidden" id="notes" name="dailyInfo.notes" value="${dailyInfo.notes}"/>
	<input type="hidden" id="inTime" name="dailyInfo.inTime" value="${dailyInfo.inTime}"/>
	<input type="hidden" id="outTime" name="dailyInfo.outTime" value="${dailyInfo.outTime}"/>
	<input type="hidden" id="hangUpState" name="dailyInfo.hangUpState" value="${dailyInfo.hangUpState}"/>
	<input type="hidden" id="deleteState" name="dailyInfo.deleteState" value="<%=MyUtil.DELETE_FALSE%>"/>
</form>
<div class="Noprint">
	<div class="divContainer1" style="float:left; margin-left:160px;">
		<div class="divTitle1">当前重量：</div>
		<div id="weightContent" class="divContent1"></div>
	</div>
	<div style="float:right;padding:10px;">
		<div>
			<span class="operateButtonStyle1" onmouseover="this.className='operateButtonStyle2'" onmouseout="this.className='operateButtonStyle1'" onclick="stopCollectData();">停止自动采集数据而手动填写</span>
			<span class="operateButtonStyle1" onmouseover="this.className='operateButtonStyle2'" onmouseout="this.className='operateButtonStyle1'" onclick="continueCollectData();">重新自动采集数据</span>
			<span class="operateButtonStyle1" onmouseover="this.className='operateButtonStyle2'" onmouseout="this.className='operateButtonStyle1'" onclick="typeInIDCardIDByUser();">手输ID卡号</span>
			<span class="operateButtonStyle1" onmouseover="this.className='operateButtonStyle2'" onmouseout="this.className='operateButtonStyle1'" onclick="changeCssLink();">切换样式</span>
		</div>
	</div>
</div>
<div id="realPrintContent" style="width:100%;">
	<div id="voucherDiv">
		<h1>新平鲁电矿业有限公司</h1>
		<h2>(铁矿)货物运送清单</h2>
		<table id="headerTable" width="95%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="66%" style="font-size:22px;">&nbsp;<span id="yearSpan">&nbsp;</span>&nbsp;年&nbsp;<span id="monthSpan">&nbsp;</span>&nbsp;月&nbsp;<span id="dateSpan">&nbsp;</span>&nbsp;日&nbsp;</td>
				<td width="33%"><span style="font-size:22px;">No.</span><span id="dailyNum1Span" class="numSpan">&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;</td>
			</tr>
		</table>
		<table id="mainTable" width="95%" border="0" cellpadding="0" cellspacing="0">
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
				<td><span id="carNumberSpan">&nbsp;</span></td>
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
				<td><span id="dailyNum2Span">&nbsp;</span></td>
				<td id="mineNameTd"><span id="mineNameSpan">&nbsp;</span></td>
				<td>吨</td>
				<td><span id="grossWeightSpan" style="width:120px; overflow:hidden;">&nbsp;</span></td>
				<td><span id="tareWeightSpan" style="width:120px; overflow:hidden;">&nbsp;</span></td>
				<td><span id="netWeightSpan" style="color:red; font-weight:bold;">&nbsp;</span></td>
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
		<table id="bottomTable" width="95%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="33%">过磅员：<span id="operatorSpan">&nbsp;</span></td>
				<td width="33%">装车：<span id="loadingInfoSpan">&nbsp;</span></td>
				<td width="33%">制单：<span id="makingNotesSpan">&nbsp;</span></td>
			</tr>
		</table>
	</div>
	<!-- <div id="rightDiv" name="rightDiv" class="rightDivStyle1">第<br/><span id="realPrintNum">四</span><br/>联<br/>：<br/>运<br/>费<br/>结<br/>算</div> -->
</div>
<br/>
<div id="submitDiv" style="width:390px;" class="Noprint">
	<div class="menu">
		<ul id="submitUl">
			<li>
				<a href="javascript:void(0);"  onclick="doOnCancel();">&nbsp;&nbsp;取&nbsp;&nbsp;消&nbsp;&nbsp;<br />
					<span></span>
				</a>
			</li>
			<li>
				<a id="submitAndPrintButton" href="javascript:void(0);">&nbsp;&nbsp;提&nbsp;&nbsp;交&nbsp;&nbsp;<br />
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
<%-- 勿删 --%>
<div id="hiddenDiv1" style="display:none;"></div>
</body>
</html>

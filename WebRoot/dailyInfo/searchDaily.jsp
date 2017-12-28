<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%@ taglib prefix="c" uri="/WEB-INF/c.tld"%>
<%@ taglib prefix="test" uri="/WEB-INF/test.tld" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<title>查询</title>
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/default.css"></link>
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/niceform.css"></link>
<style type="text/css">
	.exportLabelStyle1 {
		width: 78px;
		margin: 3px;
		padding: 5px 10px;
		color: #3D59AB;
		background: #e0eeee;
		cursor: hand;
	}
	.exportLabelStyle2 {
		width: 78px;
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
<script type='text/javascript' src='<%=basePath%>dwr/interface/RS232Handler.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/engine.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/util.js'></script>

<script type='text/javascript' src='<%=basePath%>js/global.js'></script>
<script type='text/javascript' src='<%=basePath%>js/niceform.js'></script>
<script>
function restartRS232Service(){
	RS232Handler.getRS232Status(function(data){
		//串口未打开
		if(!data){
			//则打开串口
			RS232Handler.initRS232Service(function(data){
				//串口打开失败
				if(!data){
					alert("串口打开失败!请检查设备连接正确!");
				}
			});
		}
	});
}

//由列表页面"进入",修改DailyInfO,传入DailyInfo.id以在页面载入时读取详细数据;
function goToModifyDailyInfo(dailyVOID){
	restartRS232Service();
	openModelDialog(basePath + "goToModifyByEntryID.action", dailyVOID);
}

//打开日历控件
function chooseMyDate(returnInputID, url, parameters, width, height){
	var returnValue = openModelDialog(url, parameters, width, height);
	if(returnValue != undefined && returnValue != null && returnValue != ""){
		document.getElementById(returnInputID).value = returnValue;
		var tmpMillis;
		if(returnInputID == "startTime"){
			tmpMillis = changeLocalStringToStartMillis(returnValue);
		}else if(returnInputID == "endTime"){
			tmpMillis = changeLocalStringToEndMillis(returnValue);
		}
		document.getElementById(returnInputID + "Millis").value = tmpMillis;
	}
}

//验证表单,并提交进行查询
function checkAndSubmitForm(){
	var startTimeMillisValue = document.getElementById("startTimeMillis").value;
	var endTimeMillisValue = document.getElementById("endTimeMillis").value;
	var lowerWeightValue = document.getElementById("lowerWeightString").value;
	var higherWeightValue = document.getElementById("higherWeightString").value;

	if(startTimeMillisValue != null && startTimeMillisValue != "" &&
			endTimeMillisValue != null && endTimeMillisValue != ""){
		if(parseInt(startTimeMillisValue) >= parseInt(endTimeMillisValue)){
			alert("开始日期 需要 小于 结束日期! 请核对!");
			return;
		}
	}
	document.getElementById("hasFinished").value = document.getElementById("hasFinishedSelect").value;
	
	if(lowerWeightValue != null && lowerWeightValue != ""){
		if(isNaN(lowerWeightValue)){
			alert("净重上限 只能填写数字! 请核对!");
			document.getElementById("lowerWeightString").focus();
			return;
		}
		document.getElementById("lowerWeight").value = lowerWeightValue;
	}else{
		document.getElementById("lowerWeight").value = "";
	}
	
	if(higherWeightValue != null && higherWeightValue != ""){
		if(isNaN(higherWeightValue)){
			alert("净重下限 只能填写数字! 请核对!");
			document.getElementById("higherWeightString").focus();
			return;
		}
		document.getElementById("higherWeight").value = higherWeightValue;
	}else{
		document.getElementById("higherWeight").value = "";
	}
	var theForm_ = document.getElementById("protoform");
	theForm_.action = "<%=basePath%>searchDaily.action";
	theForm_.submit();
}

//清空查询条件,并提交表单进行查询
function clearAndSubmitForm(){
	document.getElementById("startTime").value = "";
	document.getElementById("startTimeMillis").value = "";
	document.getElementById("endTime").value = "";
	document.getElementById("endTimeMillis").value = "";
	document.getElementById("hasFinished").value = true;
	document.getElementById("carNumber").value = "";
	document.getElementById("carDept").value = "";
	document.getElementById("carDriver").value = "";
	document.getElementById("lowerWeight").value = "";
	document.getElementById("higherWeight").value = "";
	document.getElementById("lowerWeightString").value = "";
	document.getElementById("higherWeightString").value = "";
	if(document.getElementById("hangUpState"))
		document.getElementById("hangUpState").value = false;
	
	var theForm_ = document.getElementById("protoform");
	theForm_.action = "<%=basePath%>searchDaily.action";
	theForm_.submit();
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

function doAfterGetIDCardIDSuccess(theIDCardNum){
	
}

//将keycode转换为数字;键盘0的keycode值为48;键盘9的keycode值为57;
function changeKeycodeToNumber(keycode){
	var numberValue = 0;
	if(keycode >=48 && keycode <= 57){
		numberValue = keycode - 48;
	}
	return numberValue;
}

//点击查看Daily详细信息时,除了传递该Daily的ID外,还要传递该Daily"是否已完成"这个信息;
function goToViewDaily(entryID){
	var array = new Array();
	array[array.length] = entryID;
	array[array.length] = "${dailySearchVO.hasFinished}";
	openModelDialog('<%=basePath%>viewDaily.action', array);	
}

//执行挂起操作
function doHangUp(entryID, dailyNum){
	var array = new Array();
	array[array.length] = entryID;
	array[array.length] = dailyNum;
	array[array.length] = true;	//true表明执行的是挂起操作
	var returnValue = openModelDialog("<%=basePath%>dealHangUp.action", array, 500 ,340);		
	if(returnValue != undefined && returnValue != null && returnValue == "1"){
		document.getElementById("protoform").submit();
	}
}

//执行取消挂起操作
function cancelHangUp(entryID, dailyNum){
	var array = new Array();
	array[array.length] = entryID;
	array[array.length] = dailyNum;
	array[array.length] = false;	//false表明执行的是取消挂起操作
	var returnValue = openModelDialog('<%=basePath%>dealHangUp.action', array, 500 ,340);	
	if(returnValue != undefined && returnValue != null && returnValue == "1"){
		document.getElementById("protoform").submit();
	}
}

function hasFinishedChange(selectObj){
	var hangUpTd1 = document.getElementById("hangUpTd1"), hangUpTd2 = document.getElementById("hangUpTd2");
	if(selectObj.value == "false"){
		if(hangUpTd1)
			hangUpTd1.style.display = "none";
		if(hangUpTd2)
			hangUpTd2.style.display = "none";
		document.getElementById("hangUpState").value = "";
	}else{
		if(hangUpTd1)
			hangUpTd1.style.display = "";
		if(hangUpTd2)
			hangUpTd2.style.display = "";
	}
}

function goToDeleteDaily(entryID){
	if(confirm("确认删除？")){
		document.getElementById("hiddenEntryId").value = entryID;
		var theForm = document.getElementById("protoform");
		theForm.action = "deleteDaily.action";
		theForm.submit();
	}
}
</script>
</head>
<body>
<form id="protoform" action="searchDaily.action" method="post" style="margin:15px;">
	<input id="pageNum" type="hidden" name="page.pageNum" value="${page.pageNum}" />
	<input id="hiddenEntryId" type="hidden" name="dailyLoadInfoVO.idVO" />
	<input id="hasFinished" type="hidden" name="dailySearchVO.hasFinished" value="${dailySearchVO.hasFinished}" />
	<input id="startTimeMillis" type="hidden" name="dailySearchVO.startMillis" value="${dailySearchVO.startMillis}">
	<input id="endTimeMillis" type="hidden" name="dailySearchVO.endMillis" value="${dailySearchVO.endMillis}" />
	<fieldset class="fieldsetStyle1" style="width:99%; margin:2px 1px;">
		<legend>设置查询时间</legend>
		<div id="" class="fieldsetDivStyle1">
			<table>
				<tr>
					<td width="19%" style="text-align:right;"><label for="textinput">选择开始日期:</label></td>
					<td width="19%" style="text-align:left;">
						<img class='inputCorner' src='<%=basePath%>pic/niceform/input_left.gif'><input type='text' id='startTime' class='textinput' size='12' style='line-height:15px; width:150px;' value="${dailySearchVO.startMillisToLocalString}" readonly="readonly" onclick="chooseMyDate(this.id, '<%=basePath%>util/jsCalendar.html', null, 280, 200);" /><img class='inputCorner' src='<%=basePath%>pic/niceform/input_right.gif'>
					</td>
					<td width="19%" style="text-align:right;"><label for="textinput">选择结束日期:</label></td>
					<td width="19%" style="text-align:left;">
						<img class='inputCorner' src='<%=basePath%>pic/niceform/input_left.gif'><input type='text' id='endTime' class='textinput' size='12' style='line-height:15px; width:150px;' value="${dailySearchVO.endMillisToLocalString}" readonly="readonly" onclick="chooseMyDate(this.id, '<%=basePath%>util/jsCalendar.html', null, 280, 200);" /><img class='inputCorner' src='<%=basePath%>pic/niceform/input_right.gif'>
					</td>
					<td width="10%" style="text-align:right;"><label for="textinput">类型:</label></td>
					<td width="14%" style="text-align:left;">
						<select size="1" id="hasFinishedSelect" onchange="hasFinishedChange(this)"; name="mySelect2" class="width_160">
							<option style="background:#e0eeee;" value="true" <c:if test="${dailySearchVO.hasFinished}">selected="selected"</c:if>>&nbsp;&nbsp;已完成详单&nbsp;&nbsp;</option>
							<option style="background:#e0eeee;" value="false" <c:if test="${!dailySearchVO.hasFinished}">selected="selected"</c:if>>&nbsp;&nbsp;未完成详单&nbsp;&nbsp;</option>
						</select>
					</td>
				</tr>
				<tr>
					<td width="19%" style="text-align:right;"><label for="textinput">承运单位:</label></td>
					<td width="19%" style="text-align:left;">
						<img class='inputCorner' src='<%=basePath%>pic/niceform/input_left.gif'><input type='text' id='carDept' name="dailySearchVO.carDept" class='textinput' size='12' style='line-height:15px; width:150px;' value="${dailySearchVO.carDept}" /><img class='inputCorner' src='<%=basePath%>pic/niceform/input_right.gif'>
					</td>
					<td width="19%" style="text-align:right;"><label for="textinput">车牌号:</label></td>
					<td width="19%" style="text-align:left;" <c:if test="${!dailySearchVO.hasFinished}">colspan="3"</c:if>>
						<img class='inputCorner' src='<%=basePath%>pic/niceform/input_left.gif'><input type='text' id='carNumber' name="dailySearchVO.carNumber" class='textinput' size='12' style='line-height:15px; width:150px;' value="${dailySearchVO.carNumber}" /><img class='inputCorner' src='<%=basePath%>pic/niceform/input_right.gif'>
					</td>
					<c:if test="${dailySearchVO.hasFinished}">
					<td id="hangUpTd1" width="10%" style="text-align:right;"><label for="textinput">挂起状态:</label></td>
					<td id="hangUpTd2" width="14%" style="text-align:left;">
						<select size="1" id="hangUpState" name="dailySearchVO.hangUpState" class="width_160">
							<option style="background:#e0eeee;" value="true" <c:if test="${dailySearchVO.hangUpState}">selected="selected"</c:if>>&nbsp;&nbsp;已挂起&nbsp;&nbsp;</option>
							<option style="background:#e0eeee;" value="false" <c:if test="${!dailySearchVO.hangUpState}">selected="selected"</c:if>>&nbsp;&nbsp;未挂起&nbsp;&nbsp;</option>
						</select>
					</td>
					</c:if>
				</tr>
				<tr>
					<td width="19%" style="text-align:right;"><label for="textinput">驾驶员:</label></td>
					<td width="19%" style="text-align:left;">
						<img class='inputCorner' src='<%=basePath%>pic/niceform/input_left.gif'><input type='text' id='carDriver' name="dailySearchVO.carDriver" class='textinput' size='12' style='line-height:15px; width:150px;' value="${dailySearchVO.carDriver}" /><img class='inputCorner' src='<%=basePath%>pic/niceform/input_right.gif'>
					</td>
					<td width="19%" style="text-align:right;"><label for="textinput">净重:</label></td>
					<td width="19%" style="text-align:left;" colspan="2">
						<input type='hidden' id='lowerWeight' name="dailySearchVO.lowerWeight" class='textinput' size='12' style='line-height:15px; width:56px;' value="${dailySearchVO.lowerWeight}" />
						<input type='hidden' id='higherWeight' name="dailySearchVO.higherWeight" class='textinput' size='12' style='line-height:15px; width:56px;' value="${dailySearchVO.higherWeight}" />
						<img class='inputCorner' src='<%=basePath%>pic/niceform/input_left.gif'><input type='text' id='lowerWeightString' name="dailySearchVO.lowerWeightString" class='textinput' size='12' style='line-height:15px; width:56px;' value="${dailySearchVO.lowerWeightString}" /><img class='inputCorner' src='<%=basePath%>pic/niceform/input_right.gif'> —  
						<img class='inputCorner' src='<%=basePath%>pic/niceform/input_left.gif'><input type='text' id='higherWeightString' name="dailySearchVO.higherWeightString" class='textinput' size='12' style='line-height:15px; width:56px;' value="${dailySearchVO.higherWeightString}" /><img class='inputCorner' src='<%=basePath%>pic/niceform/input_right.gif'>
					</td>
					<td width="24%" style="text-align:left;">
						<label id="submitButton01" class="exportLabelStyle1" onmouseover="this.className='exportLabelStyle2'" onmouseout="this.className='exportLabelStyle1'" for="textinput" onclick="checkAndSubmitForm();">查询</label>
						<label class="exportLabelStyle1" onmouseover="this.className='exportLabelStyle2'" onmouseout="this.className='exportLabelStyle1'" for="textinput" onclick="clearAndSubmitForm();">清空</label>
					</td>
				</tr>
			</table>
		</div>
	</fieldset>
	<table border="0" cellpadding="0" cellspacing="0" class="main" style="width:99%; margin:2px 1px">
   		<caption>
   			<div style="float:left;">
   				<img src="<%=basePath%>pic/ico1.gif" align="absmiddle" alt=""/>查询结果	
   			</div>
   		</caption>
   		<tr>
   			<th nowrap="nowrap" width="7%">&nbsp;编&nbsp;&nbsp;号&nbsp;</th>
   			<th nowrap="nowrap" width="13%">&nbsp;完&nbsp;成&nbsp;日&nbsp;期&nbsp;</th>
   			<th nowrap="nowrap" width="11%">&nbsp;日&nbsp;编&nbsp;号&nbsp;</th>
   			<th nowrap="nowrap" width="15%">&nbsp;承&nbsp;运&nbsp;单&nbsp;位&nbsp;</th>
   			<th nowrap="nowrap" width="13%">&nbsp;车&nbsp;牌&nbsp;号&nbsp;码&nbsp;</th>
   			<c:if test="${dailySearchVO.hasFinished}">
   				<th nowrap="nowrap" width="11%">&nbsp;净&nbsp;&nbsp;重&nbsp;(吨)</th>
   			</c:if>
   			<c:if test="${!dailySearchVO.hasFinished}">
   				<th nowrap="nowrap" width="11%">&nbsp;皮&nbsp;&nbsp;重&nbsp;(吨)</th>
   			</c:if>
   			<th nowrap="nowrap" width="11%">&nbsp;驾&nbsp;驶&nbsp;员&nbsp;</th>
   			<th nowrap="nowrap" width="10%">&nbsp;挂&nbsp;起&nbsp;状&nbsp;态&nbsp;</th>
   			<th nowrap="nowrap" width="10%">&nbsp;操&nbsp;&nbsp;作&nbsp;</th>
   		</tr>
   		
   		<c:forEach var="entry" items="${listHistory}" varStatus="index">
   		<tr onmouseover="this.className='tr_on';" onmouseout="this.className='';">
   			<td nowrap="nowrap" class="center">${page.firstData + index.index}</td>
   			<td nowrap="nowrap" class="center">${entry.inTimeVOToLocalString}</td>
   			<td nowrap="nowrap" class="center">${entry.dailyNumVO}</td>
   			<td nowrap="nowrap" class="center">${entry.carDeptVO}</td>
   			<td nowrap="nowrap" class="center">${entry.carNumberVO}</td>
   			<c:if test="${dailySearchVO.hasFinished}">
   				<td nowrap="nowrap" style="text-align:right;">${entry.netWeightVO}</td>
   			</c:if>
   			<c:if test="${!dailySearchVO.hasFinished}">
   				<td nowrap="nowrap" style="text-align:right;">${entry.tareWeightVO}</td>
   			</c:if>
   			<td nowrap="nowrap" class="center">${entry.carDriverVO}</td>
   			<td nowrap="nowrap" class="center">${entry.hangUpStateVOToString}</td>
   			<td nowrap="nowrap" class="btnStyle1">
   				<input type="button" value="查看" onclick="goToViewDaily('${entry.idVO}');"/>&nbsp;
   				<c:if test="${userInfo.authority == 0 || userInfo.authority == 1 || userInfo.authority == 2}">
   					<input type="button" value="删除" onclick="goToDeleteDaily('${entry.idVO}');"/>&nbsp;
	   				<c:if test="${entry.hangUpStateVO == false}">
	   					<input type="button" value="挂起" onclick="doHangUp('${entry.idVO}' ,'${entry.dailyNumVO}')"/>&nbsp;
	   				</c:if>
	   				<c:if test="${entry.hangUpStateVO == true}">
	   					<input type="button" value="取消挂起" onclick="cancelHangUp('${entry.idVO}','${entry.dailyNumVO}')"/>&nbsp;
	   				</c:if>
   				</c:if>
   			</td>
   		</tr>
   		</c:forEach>
   	</table>
	
	<div id="footer">
		<test:page page="${page}"></test:page>
	</div>
</form>
</body>
</html>
<script>
specifyParentNodeCssStyle("searchDaily");
//for niceform.js
function inputsFocusAndBlur(){
	var inputs = document.getElementsByTagName("input");
	for (var i = 0; i < inputs.length; i++) {
		var inputObj = inputs[i];
		if(inputObj.type == "text"){
			inputObj.onfocus = function(){onInputFocus(this)};
			inputObj.onblur = function(){onInputBlur(this)};
		}
	}
}
inputsFocusAndBlur();
</script>
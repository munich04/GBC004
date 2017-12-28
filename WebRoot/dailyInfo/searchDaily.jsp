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
<title>��ѯ</title>
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
		//����δ��
		if(!data){
			//��򿪴���
			RS232Handler.initRS232Service(function(data){
				//���ڴ�ʧ��
				if(!data){
					alert("���ڴ�ʧ��!�����豸������ȷ!");
				}
			});
		}
	});
}

//���б�ҳ��"����",�޸�DailyInfO,����DailyInfo.id����ҳ������ʱ��ȡ��ϸ����;
function goToModifyDailyInfo(dailyVOID){
	restartRS232Service();
	openModelDialog(basePath + "goToModifyByEntryID.action", dailyVOID);
}

//�������ؼ�
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

//��֤��,���ύ���в�ѯ
function checkAndSubmitForm(){
	var startTimeMillisValue = document.getElementById("startTimeMillis").value;
	var endTimeMillisValue = document.getElementById("endTimeMillis").value;
	var lowerWeightValue = document.getElementById("lowerWeightString").value;
	var higherWeightValue = document.getElementById("higherWeightString").value;

	if(startTimeMillisValue != null && startTimeMillisValue != "" &&
			endTimeMillisValue != null && endTimeMillisValue != ""){
		if(parseInt(startTimeMillisValue) >= parseInt(endTimeMillisValue)){
			alert("��ʼ���� ��Ҫ С�� ��������! ��˶�!");
			return;
		}
	}
	document.getElementById("hasFinished").value = document.getElementById("hasFinishedSelect").value;
	
	if(lowerWeightValue != null && lowerWeightValue != ""){
		if(isNaN(lowerWeightValue)){
			alert("�������� ֻ����д����! ��˶�!");
			document.getElementById("lowerWeightString").focus();
			return;
		}
		document.getElementById("lowerWeight").value = lowerWeightValue;
	}else{
		document.getElementById("lowerWeight").value = "";
	}
	
	if(higherWeightValue != null && higherWeightValue != ""){
		if(isNaN(higherWeightValue)){
			alert("�������� ֻ����д����! ��˶�!");
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

//��ղ�ѯ����,���ύ�����в�ѯ
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

var IDCardNum = "";	//���ַ�����¼ˢ����õ���ID����
document.onkeydown=dokeydown;	//���̼����¼�
var ietype = (document.layers) ? 1 : 0;		//�ж����������

//���̼����¼�
function dokeydown(e){              
	var key = (ietype)? e.which : event.keyCode;
	//����ʵ�������Զ�������������,����Իس�(keyCode=13)Ϊ����;
	if(key != '13'){
		IDCardNum += changeKeycodeToNumber(key) + "";
	}else{
		doAfterGetIDCardIDSuccess(IDCardNum);
	}
}

function doAfterGetIDCardIDSuccess(theIDCardNum){
	
}

//��keycodeת��Ϊ����;����0��keycodeֵΪ48;����9��keycodeֵΪ57;
function changeKeycodeToNumber(keycode){
	var numberValue = 0;
	if(keycode >=48 && keycode <= 57){
		numberValue = keycode - 48;
	}
	return numberValue;
}

//����鿴Daily��ϸ��Ϣʱ,���˴��ݸ�Daily��ID��,��Ҫ���ݸ�Daily"�Ƿ������"�����Ϣ;
function goToViewDaily(entryID){
	var array = new Array();
	array[array.length] = entryID;
	array[array.length] = "${dailySearchVO.hasFinished}";
	openModelDialog('<%=basePath%>viewDaily.action', array);	
}

//ִ�й������
function doHangUp(entryID, dailyNum){
	var array = new Array();
	array[array.length] = entryID;
	array[array.length] = dailyNum;
	array[array.length] = true;	//true����ִ�е��ǹ������
	var returnValue = openModelDialog("<%=basePath%>dealHangUp.action", array, 500 ,340);		
	if(returnValue != undefined && returnValue != null && returnValue == "1"){
		document.getElementById("protoform").submit();
	}
}

//ִ��ȡ���������
function cancelHangUp(entryID, dailyNum){
	var array = new Array();
	array[array.length] = entryID;
	array[array.length] = dailyNum;
	array[array.length] = false;	//false����ִ�е���ȡ���������
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
	if(confirm("ȷ��ɾ����")){
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
		<legend>���ò�ѯʱ��</legend>
		<div id="" class="fieldsetDivStyle1">
			<table>
				<tr>
					<td width="19%" style="text-align:right;"><label for="textinput">ѡ��ʼ����:</label></td>
					<td width="19%" style="text-align:left;">
						<img class='inputCorner' src='<%=basePath%>pic/niceform/input_left.gif'><input type='text' id='startTime' class='textinput' size='12' style='line-height:15px; width:150px;' value="${dailySearchVO.startMillisToLocalString}" readonly="readonly" onclick="chooseMyDate(this.id, '<%=basePath%>util/jsCalendar.html', null, 280, 200);" /><img class='inputCorner' src='<%=basePath%>pic/niceform/input_right.gif'>
					</td>
					<td width="19%" style="text-align:right;"><label for="textinput">ѡ���������:</label></td>
					<td width="19%" style="text-align:left;">
						<img class='inputCorner' src='<%=basePath%>pic/niceform/input_left.gif'><input type='text' id='endTime' class='textinput' size='12' style='line-height:15px; width:150px;' value="${dailySearchVO.endMillisToLocalString}" readonly="readonly" onclick="chooseMyDate(this.id, '<%=basePath%>util/jsCalendar.html', null, 280, 200);" /><img class='inputCorner' src='<%=basePath%>pic/niceform/input_right.gif'>
					</td>
					<td width="10%" style="text-align:right;"><label for="textinput">����:</label></td>
					<td width="14%" style="text-align:left;">
						<select size="1" id="hasFinishedSelect" onchange="hasFinishedChange(this)"; name="mySelect2" class="width_160">
							<option style="background:#e0eeee;" value="true" <c:if test="${dailySearchVO.hasFinished}">selected="selected"</c:if>>&nbsp;&nbsp;������굥&nbsp;&nbsp;</option>
							<option style="background:#e0eeee;" value="false" <c:if test="${!dailySearchVO.hasFinished}">selected="selected"</c:if>>&nbsp;&nbsp;δ����굥&nbsp;&nbsp;</option>
						</select>
					</td>
				</tr>
				<tr>
					<td width="19%" style="text-align:right;"><label for="textinput">���˵�λ:</label></td>
					<td width="19%" style="text-align:left;">
						<img class='inputCorner' src='<%=basePath%>pic/niceform/input_left.gif'><input type='text' id='carDept' name="dailySearchVO.carDept" class='textinput' size='12' style='line-height:15px; width:150px;' value="${dailySearchVO.carDept}" /><img class='inputCorner' src='<%=basePath%>pic/niceform/input_right.gif'>
					</td>
					<td width="19%" style="text-align:right;"><label for="textinput">���ƺ�:</label></td>
					<td width="19%" style="text-align:left;" <c:if test="${!dailySearchVO.hasFinished}">colspan="3"</c:if>>
						<img class='inputCorner' src='<%=basePath%>pic/niceform/input_left.gif'><input type='text' id='carNumber' name="dailySearchVO.carNumber" class='textinput' size='12' style='line-height:15px; width:150px;' value="${dailySearchVO.carNumber}" /><img class='inputCorner' src='<%=basePath%>pic/niceform/input_right.gif'>
					</td>
					<c:if test="${dailySearchVO.hasFinished}">
					<td id="hangUpTd1" width="10%" style="text-align:right;"><label for="textinput">����״̬:</label></td>
					<td id="hangUpTd2" width="14%" style="text-align:left;">
						<select size="1" id="hangUpState" name="dailySearchVO.hangUpState" class="width_160">
							<option style="background:#e0eeee;" value="true" <c:if test="${dailySearchVO.hangUpState}">selected="selected"</c:if>>&nbsp;&nbsp;�ѹ���&nbsp;&nbsp;</option>
							<option style="background:#e0eeee;" value="false" <c:if test="${!dailySearchVO.hangUpState}">selected="selected"</c:if>>&nbsp;&nbsp;δ����&nbsp;&nbsp;</option>
						</select>
					</td>
					</c:if>
				</tr>
				<tr>
					<td width="19%" style="text-align:right;"><label for="textinput">��ʻԱ:</label></td>
					<td width="19%" style="text-align:left;">
						<img class='inputCorner' src='<%=basePath%>pic/niceform/input_left.gif'><input type='text' id='carDriver' name="dailySearchVO.carDriver" class='textinput' size='12' style='line-height:15px; width:150px;' value="${dailySearchVO.carDriver}" /><img class='inputCorner' src='<%=basePath%>pic/niceform/input_right.gif'>
					</td>
					<td width="19%" style="text-align:right;"><label for="textinput">����:</label></td>
					<td width="19%" style="text-align:left;" colspan="2">
						<input type='hidden' id='lowerWeight' name="dailySearchVO.lowerWeight" class='textinput' size='12' style='line-height:15px; width:56px;' value="${dailySearchVO.lowerWeight}" />
						<input type='hidden' id='higherWeight' name="dailySearchVO.higherWeight" class='textinput' size='12' style='line-height:15px; width:56px;' value="${dailySearchVO.higherWeight}" />
						<img class='inputCorner' src='<%=basePath%>pic/niceform/input_left.gif'><input type='text' id='lowerWeightString' name="dailySearchVO.lowerWeightString" class='textinput' size='12' style='line-height:15px; width:56px;' value="${dailySearchVO.lowerWeightString}" /><img class='inputCorner' src='<%=basePath%>pic/niceform/input_right.gif'> ��  
						<img class='inputCorner' src='<%=basePath%>pic/niceform/input_left.gif'><input type='text' id='higherWeightString' name="dailySearchVO.higherWeightString" class='textinput' size='12' style='line-height:15px; width:56px;' value="${dailySearchVO.higherWeightString}" /><img class='inputCorner' src='<%=basePath%>pic/niceform/input_right.gif'>
					</td>
					<td width="24%" style="text-align:left;">
						<label id="submitButton01" class="exportLabelStyle1" onmouseover="this.className='exportLabelStyle2'" onmouseout="this.className='exportLabelStyle1'" for="textinput" onclick="checkAndSubmitForm();">��ѯ</label>
						<label class="exportLabelStyle1" onmouseover="this.className='exportLabelStyle2'" onmouseout="this.className='exportLabelStyle1'" for="textinput" onclick="clearAndSubmitForm();">���</label>
					</td>
				</tr>
			</table>
		</div>
	</fieldset>
	<table border="0" cellpadding="0" cellspacing="0" class="main" style="width:99%; margin:2px 1px">
   		<caption>
   			<div style="float:left;">
   				<img src="<%=basePath%>pic/ico1.gif" align="absmiddle" alt=""/>��ѯ���	
   			</div>
   		</caption>
   		<tr>
   			<th nowrap="nowrap" width="7%">&nbsp;��&nbsp;&nbsp;��&nbsp;</th>
   			<th nowrap="nowrap" width="13%">&nbsp;��&nbsp;��&nbsp;��&nbsp;��&nbsp;</th>
   			<th nowrap="nowrap" width="11%">&nbsp;��&nbsp;��&nbsp;��&nbsp;</th>
   			<th nowrap="nowrap" width="15%">&nbsp;��&nbsp;��&nbsp;��&nbsp;λ&nbsp;</th>
   			<th nowrap="nowrap" width="13%">&nbsp;��&nbsp;��&nbsp;��&nbsp;��&nbsp;</th>
   			<c:if test="${dailySearchVO.hasFinished}">
   				<th nowrap="nowrap" width="11%">&nbsp;��&nbsp;&nbsp;��&nbsp;(��)</th>
   			</c:if>
   			<c:if test="${!dailySearchVO.hasFinished}">
   				<th nowrap="nowrap" width="11%">&nbsp;Ƥ&nbsp;&nbsp;��&nbsp;(��)</th>
   			</c:if>
   			<th nowrap="nowrap" width="11%">&nbsp;��&nbsp;ʻ&nbsp;Ա&nbsp;</th>
   			<th nowrap="nowrap" width="10%">&nbsp;��&nbsp;��&nbsp;״&nbsp;̬&nbsp;</th>
   			<th nowrap="nowrap" width="10%">&nbsp;��&nbsp;&nbsp;��&nbsp;</th>
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
   				<input type="button" value="�鿴" onclick="goToViewDaily('${entry.idVO}');"/>&nbsp;
   				<c:if test="${userInfo.authority == 0 || userInfo.authority == 1 || userInfo.authority == 2}">
   					<input type="button" value="ɾ��" onclick="goToDeleteDaily('${entry.idVO}');"/>&nbsp;
	   				<c:if test="${entry.hangUpStateVO == false}">
	   					<input type="button" value="����" onclick="doHangUp('${entry.idVO}' ,'${entry.dailyNumVO}')"/>&nbsp;
	   				</c:if>
	   				<c:if test="${entry.hangUpStateVO == true}">
	   					<input type="button" value="ȡ������" onclick="cancelHangUp('${entry.idVO}','${entry.dailyNumVO}')"/>&nbsp;
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
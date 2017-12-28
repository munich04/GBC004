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
<title>�ճ�����ˢ��������</title>
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
		font-family:΢���ź�; 
		font-weight:bold;
		margin: 0px 5px;
	}
	.operateButtonStyle2{
		background:#e0eeee; 
		padding:8px; 
		cursor:hand; 
		color:#F4A460; 
		font-size:15px; 
		font-family:΢���ź�; 
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
var mineArray = new Array();	//�������п���	
//����ҳ��Ϳ�ʼ��ȡRS232������,��ˢ����,�����������������д�������;
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
				
				document.getElementById("weightContent").innerHTML = rs232Data + " �� ";
				if(inOrOut == "in"){
					document.getElementById("tareWeight").value = rs232Data;
					document.getElementById("tareWeightSpan").innerHTML = rs232Data;
				}//����Ͷ��ι���ʱ,���㾻��
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

//��keycodeת��Ϊ����;����0��keycodeֵΪ48;����9��keycodeֵΪ57;
function changeKeycodeToNumber(keycode){
	var numberValue = 0;
	if(keycode >=48 && keycode <= 57){
		numberValue = keycode - 48;
	}
	return numberValue;
}

//�ɹ���ȡ��ID���ź���Ҫ������
function doAfterGetIDCardIDSuccess(theIDCardNum){
	//������������������ֵ����ʾSpan������;
	doClearHiddenInputAndSpan();
	
	document.getElementById("carIDCardID").value = theIDCardNum;	//��д����;
	
	//��д���ϵ�������
	var curDate = new Date();
	document.getElementById("yearSpan").innerHTML = curDate.getYear();
	document.getElementById("monthSpan").innerHTML = curDate.getMonth() + 1;
	document.getElementById("dateSpan").innerHTML = curDate.getDate();
	
	//����IDCardNum���س�����Ϣ;
	loadCarInfoByCarIDCarID(theIDCardNum);
}

//��������������value����ʾSpan������;
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

//����IDCardNum���س�����Ϣ;
//�����ʱ  ��Ϊδ֪ԭ��  �������ݿ���������  ���ǲ�ѯ�����Ľ��ȷʵnull �����,�����ѯ��null,���²�ѯ;
//�������3�λ�������,�������û�����ˢ��,���ֶ���д����;
var maxQueryTime = 0;
function loadCarInfoByCarIDCarID(IDCardNum){
	carManager.getCarInfoByCarIDCardID(IDCardNum, function(carInfo){
		//��ȡ���̷����쳣,�õ���ֵ��Ϊnull
		if(carInfo.carIDCardID == null || carInfo.carDept == null || carInfo.carDriver == null || carInfo.carNumber == null){
			maxQueryTime++;
			if(maxQueryTime < 3){
				loadCarInfoByCarIDCarID(IDCardNum);
			}else{
				alert("��ȡID����Ϣʧ��!������\"ˢ��\"��\"���뿨��\"!");
				maxQueryTime = 0;
			}
		}//��ȡ������Ϣ�ɹ�,��д��Ϣ;
		else{
			document.getElementById("carIDCardID").value = carInfo.carIDCardID;	//����input,��ȡ����д"ID����"
			//����
			document.getElementById("carDeptSpan").innerHTML = carInfo.carDept;			//��д"���˵�λ"
			document.getElementById("carDriverSpan").innerHTML = carInfo.carDriver;		//��д"��ʻԱ"
			document.getElementById("carNumberSpan").innerHTML = carInfo.carNumber;		//��д"���ƺ�"

			//�ɹ���ȡ������Ϣ����һ��Ҫ���Ĺ���
			doAfterLoadCarInfoSuccess(IDCardNum);
		}
	});
}

function changeNulltoEmptyString(theValue){
	return theValue == null ? " &nbsp; " : theValue;
}

//�ɹ���ȡ������Ϣ���жϵ�ǰ������"����������"����"���ι���";
function doAfterLoadCarInfoSuccess(theIDCardNum){
	//����ж϶��ι���?ͬһ��������������ˢ����ʱ�����2Сʱ,�϶����ڽ���"���ι���"����;
	dailyManager.goOutNormallyOrWeightAgain(theIDCardNum, function(dailyInfoID){
		//���ι�������ʱҪ�����£�
		if(dailyInfoID != null && dailyInfoID != ""){ 
			inOrOut = "secWeight";
			doDailyAbnormally(dailyInfoID);
		}//����������ʱҪ�����£�
		else{
			doDailyNormally(theIDCardNum);
		}
	});
}

//���ι�������ʱҪ������
function doDailyAbnormally(dailyInfoID){
	document.getElementById("submitAndPrintButton").childNodes[0].nodeValue = " ���ι��� ";
	
	dailyManager.loadDailyLoadInfoVOByID(dailyInfoID, true, function(dailyLoadInfoVO){
		//��Ϊ���ι�����update����,���Ա������entryID
		if(document.getElementById("entryID") == undefined){
			var idInput = document.createElement("<input type=\"hidden\" id=\"entryID\" name=\"dailyInfo.id\"/>");
			document.getElementById("protoform").appendChild(idInput);
		}
		document.getElementById("entryID").value = dailyInfoID;
		
		//��д���ʱ��
		document.getElementById("outTime").value = new Date().getTime();

		//��д�����Ϣ
		document.getElementById("dailyNum").value = dailyLoadInfoVO.dailyNumVO;//��ȡ����д�ձ��
		document.getElementById("dailyNum1Span").innerHTML = changeDailyNum(changeNulltoEmptyString(dailyLoadInfoVO.dailyNumVO));
		document.getElementById("dailyNum2Span").innerHTML = changeNulltoEmptyString(dailyLoadInfoVO.dailyNumVO);

		document.getElementById("inTime").value = dailyLoadInfoVO.inTimeVO;	//��ȡ����д����ʱ��

		document.getElementById("receiveDept").value = dailyLoadInfoVO.receiveDeptVO;	//��ȡ����д�ջ���λ
		document.getElementById("receiveDeptSpan").innerHTML = changeNulltoEmptyString(dailyLoadInfoVO.receiveDeptVO);	

		document.getElementById("departure").value = dailyLoadInfoVO.departureVO;	//��ȡ����д�����ص�
		document.getElementById("departureSpan").innerHTML = changeNulltoEmptyString(dailyLoadInfoVO.departureVO);	
		
		document.getElementById("tareWeight").value = dailyLoadInfoVO.tareWeightVO;	//��ȡ����дƤ��
		document.getElementById("tareWeightSpan").innerHTML = changeNulltoEmptyString(dailyLoadInfoVO.tareWeightVO);

		document.getElementById("operator").value = dailyLoadInfoVO.operatorVO;
		document.getElementById("operatorSpan").innerHTML = changeNulltoEmptyString(dailyLoadInfoVO.operatorVO);

		document.getElementById("hangUpState").value = false;	//δ���������״̬
		
		//��ȡ����дƷ��
		document.getElementById("mineName").value = dailyLoadInfoVO.mineCodeVO;
		document.getElementById("mineNameSpan").innerHTML = dailyLoadInfoVO.mineNameVO;
		//Ʒ���ǿ����޸ĵ�
		document.getElementById("mineNameTd").onmouseover = function(){
			chooseMine(this);
		}
		mineManager.getAllMine(function(data){
			if(data != null){
				//�������޸ĵĿ����б�
				dealWithMineName(data);
			}
		});
	});

	IDCardNum = "";	//���IDCardNum

	document.getElementById("submitAndPrintButton").onclick = function(){
		var theProtoform = document.getElementById('protoform');
		if(validator.validate(theProtoform)){
			theProtoform.submit();
			/* ��������,��ô�ύ��,ѯ���Ƿ��ӡ  */
			if(inOrOut == "secWeight" && confirm("�ύ�ɹ�,�Ƿ��ӡ��")){
				dealWithPrint();
			}
			window.returnValue="1";//����ֵΪ"1",��ˢ�¸�����;
			window.close();
		}
	};
}

//����������ʱҪ������
function doDailyNormally(theIDCardNum){
	document.getElementById("submitAndPrintButton").childNodes[0].nodeValue = "  ��  ��  ";
	//ˢ����ȡ��Ϣ�ɹ�,�жϱ�����Ҫ����,�����뿪,��������Ӧ�Ĳ�ͬ�Ĵ���
	//hasEntered=in:û�н����¼,����Ҫ����;hasEntered=out:���н����¼,����Ҫ�뿪;
	dailyManager.checkIfTheCarHasnotLeave(theIDCardNum, function(hasEntered){
		//�����ǽ����ǳ���,���Ƥ�ػ��߾���;
		inOrOut = hasEntered;
		
		//����ʱҪ������
		if(hasEntered == 'in'){				
			//��д����ʱ��
			document.getElementById("inTime").value = new Date().getTime();

			//��д�ջ���λ
			document.getElementById("receiveDept").value = "<%=MyUtil.RECEIVEDEPT%>";
			document.getElementById("receiveDeptSpan").innerHTML = "<%=MyUtil.RECEIVEDEPT%>";
		
			//��д�����ص�
			document.getElementById("departure").value = "<%=MyUtil.DEPARTURE%>";
			//document.getElementById("departure").value = "³���ҵ";
			document.getElementById("departureSpan").innerHTML = "<%=MyUtil.DEPARTURE%>";
			//document.getElementById("departureSpan").innerHTML = "³���ҵ";
			
			document.getElementById("operator").value = "${userInfo.nickName}";
			document.getElementById("operatorSpan").innerHTML = "${userInfo.nickName}";
			
			//���㲢��д�ձ��
			dailyManager.calculateDailyNum(function(dailyNumValue){
				document.getElementById("dailyNum").value = dailyNumValue;
				document.getElementById("dailyNum1Span").innerHTML = changeDailyNum(changeNulltoEmptyString(dailyNumValue));
				document.getElementById("dailyNum2Span").innerHTML = changeNulltoEmptyString(dailyNumValue);
			});

			//�����dailyInfo.entyrID��input,��ɾ��
			if(document.getElementById("entryID") != undefined){
				document.getElementById("protoform").removeChild(document.getElementById("entryID"));
			}
		}//����ʱҪ������
		else if(hasEntered == 'out'){
			//��������ʱҪ�����£�							
			//��д���ʱ��
			document.getElementById("outTime").value = new Date().getTime();

			document.getElementById("mineNameTd").onmouseover = function(){
				chooseMine(this);
			}
			
			//��ȡ����дƷ��
			mineManager.getAllMine(function(data){
				if(data != null){
					//�������޸ĵĿ����б�
					dealWithMineName(data);
					
					document.getElementById("mineName").value = data[0].code;	
					document.getElementById("mineNameSpan").innerHTML = changeNulltoEmptyString(data[0].name);
				}
			});
			
			//��ѯ����д�ձ�ŵ���Ϣ
			dailyManager.loadEnteredDailyInfoByCarIDCardID(theIDCardNum, function(dailyInfoEntry){
				if(document.getElementById("entryID") == undefined){
					var idInput = document.createElement("<input type=\"hidden\" id=\"entryID\" name=\"dailyInfo.id\"/>");
					document.getElementById("protoform").appendChild(idInput);
				}
				document.getElementById("entryID").value = dailyInfoEntry.id;
										
				document.getElementById("dailyNum").value = dailyInfoEntry.dailyNum;//��ȡ����д�ձ��
				document.getElementById("dailyNum1Span").innerHTML = changeDailyNum(changeNulltoEmptyString(dailyInfoEntry.dailyNum));
				document.getElementById("dailyNum2Span").innerHTML = changeNulltoEmptyString(dailyInfoEntry.dailyNum);
				
				document.getElementById("inTime").value = dailyInfoEntry.inTime;	//��ȡ����д����ʱ��

				document.getElementById("receiveDept").value = dailyInfoEntry.receiveDept;	//��ȡ����д�ջ���λ
				document.getElementById("receiveDeptSpan").innerHTML = changeNulltoEmptyString(dailyInfoEntry.receiveDept);	

				document.getElementById("departure").value = dailyInfoEntry.departure;	//��ȡ����д�����ص�
				document.getElementById("departureSpan").innerHTML = changeNulltoEmptyString(dailyInfoEntry.departure);	
				
				document.getElementById("tareWeight").value = dailyInfoEntry.tareWeight;	//��ȡ����дƤ��
				document.getElementById("tareWeightSpan").innerHTML = changeNulltoEmptyString(dailyInfoEntry.tareWeight);

				document.getElementById("operator").value = dailyInfoEntry.operator;
				document.getElementById("operatorSpan").innerHTML = changeNulltoEmptyString(dailyInfoEntry.operator);

				document.getElementById("hangUpState").value = false;	//δ���������״̬
			});
		}
		IDCardNum = "";	//���IDCardNum
	});
	document.getElementById("submitAndPrintButton").onclick = function(){
		var theProtoform = document.getElementById('protoform');
		if(validator.validate(theProtoform)){
			theProtoform.submit();
			/* ��������,��ô�ύ��,ѯ���Ƿ��ӡ  */
			if(inOrOut == "out" && confirm("�ύ�ɹ�,�Ƿ��ӡ��")){
				dealWithPrint();
			}
			window.returnValue="1";//����ֵΪ"1",��ˢ�¸�����;
			window.close();
		}
	};
}

//Ʒ���ǿ���ѡ���,ͨ������div��ʾ����Ʒ��
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

//Ϊ����div��������Ʒ������
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

//�����ӡ
function dealWithPrint(){
	//���ݱ��������DailyInfo��ID, ���򿪴�ӡ����
	var features = "height=" + window.screen.availHeight+"px, width=" + window.screen.availWidth+ "px, top=0, left=0, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no, fullscreen=1";
	var theEntryID = "";
	if(document.getElementById("entryID")){
		theEntryID = document.getElementById("entryID").value;
	}
	window.open("<%=basePath%>dailyInfo/print.jsp?entryID=" + theEntryID, "_blank", features);
}

//�����ձ��
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

//�л�css��ʽ
function changeCssLink(){
	var cssLink = document.getElementById("printCssLink");
	var cssLinkOne = "<%=basePath%>css/voucherGreen.css";
	var cssLinkTwo = "<%=basePath%>css/voucherOrange.css";
	cssLink.href = cssLink.href==cssLinkOne ? cssLinkTwo:cssLinkOne;
}

//�ֶ�����ID����
function typeInIDCardIDByUser(){
	var idCardID = openModelDialog(basePath + "dailyInfo/typeInIDCardID.jsp", null, 500, 180);
	if(idCardID != null && idCardID != "" && idCardID != undefined){
		doAfterGetIDCardIDSuccess(idCardID);
	}
}

//�ֶ�����Ƥ��
function typeInTareWeightByUser(){
	var weightValue = openModelDialog(basePath + "dailyInfo/typeInWeight.jsp", null, 500, 180);
	if(weightValue != null && weightValue != "" && weightValue != undefined){
		document.getElementById("tareWeight").value = weightValue;
		document.getElementById("tareWeightSpan").innerHTML = weightValue;
		
	}
}

//�ֶ�����ë��
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
<%-- target=hiddenInnerIFrame ��Ϊ����ҳ���ύ���Լ�,�������õ����ı��������ύ��ʱ�ٵ���һ���µĹ��촰�� --%>
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
		<div class="divTitle1">��ǰ������</div>
		<div id="weightContent" class="divContent1"></div>
	</div>
	<div style="float:right;padding:10px;">
		<div>
			<span class="operateButtonStyle1" onmouseover="this.className='operateButtonStyle2'" onmouseout="this.className='operateButtonStyle1'" onclick="stopCollectData();">ֹͣ�Զ��ɼ����ݶ��ֶ���д</span>
			<span class="operateButtonStyle1" onmouseover="this.className='operateButtonStyle2'" onmouseout="this.className='operateButtonStyle1'" onclick="continueCollectData();">�����Զ��ɼ�����</span>
			<span class="operateButtonStyle1" onmouseover="this.className='operateButtonStyle2'" onmouseout="this.className='operateButtonStyle1'" onclick="typeInIDCardIDByUser();">����ID����</span>
			<span class="operateButtonStyle1" onmouseover="this.className='operateButtonStyle2'" onmouseout="this.className='operateButtonStyle1'" onclick="changeCssLink();">�л���ʽ</span>
		</div>
	</div>
</div>
<div id="realPrintContent" style="width:100%;">
	<div id="voucherDiv">
		<h1>��ƽ³���ҵ���޹�˾</h1>
		<h2>(����)���������嵥</h2>
		<table id="headerTable" width="95%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="66%" style="font-size:22px;">&nbsp;<span id="yearSpan">&nbsp;</span>&nbsp;��&nbsp;<span id="monthSpan">&nbsp;</span>&nbsp;��&nbsp;<span id="dateSpan">&nbsp;</span>&nbsp;��&nbsp;</td>
				<td width="33%"><span style="font-size:22px;">No.</span><span id="dailyNum1Span" class="numSpan">&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;</td>
			</tr>
		</table>
		<table id="mainTable" width="95%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>�����ص�</td>
				<td colspan="2"><span id="departureSpan">&nbsp;</span></td>
				<td>�ջ���λ</td>
				<td colspan="3"><span id="receiveDeptSpan">&nbsp;</span></td>
			</tr>
			<tr>
				<td>���˵�λ</td>
				<td colspan="2"><span id="carDeptSpan">&nbsp;</span></td>
				<td>���ƺ�</td>
				<td><span id="carNumberSpan">&nbsp;</span></td>
				<td>��ʻԱ</td>
				<td><span id="carDriverSpan">&nbsp;</span></td>
			</tr>
			<tr>
				<td width="11%">�ձ��</td>
				<td width="11%">Ʒ��</td>
				<td width="11%">��λ</td>
				<td width="16%">ë��</td>
				<td width="16%">Ƥ��</td>
				<td width="11%">����</td>
				<td width="11%">��ע</td>
			</tr>
			<tr>
				<td><span id="dailyNum2Span">&nbsp;</span></td>
				<td id="mineNameTd"><span id="mineNameSpan">&nbsp;</span></td>
				<td>��</td>
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
				<td width="33%">����Ա��<span id="operatorSpan">&nbsp;</span></td>
				<td width="33%">װ����<span id="loadingInfoSpan">&nbsp;</span></td>
				<td width="33%">�Ƶ���<span id="makingNotesSpan">&nbsp;</span></td>
			</tr>
		</table>
	</div>
	<!-- <div id="rightDiv" name="rightDiv" class="rightDivStyle1">��<br/><span id="realPrintNum">��</span><br/>��<br/>��<br/>��<br/>��<br/>��<br/>��</div> -->
</div>
<br/>
<div id="submitDiv" style="width:390px;" class="Noprint">
	<div class="menu">
		<ul id="submitUl">
			<li>
				<a href="javascript:void(0);"  onclick="doOnCancel();">&nbsp;&nbsp;ȡ&nbsp;&nbsp;��&nbsp;&nbsp;<br />
					<span></span>
				</a>
			</li>
			<li>
				<a id="submitAndPrintButton" href="javascript:void(0);">&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;<br />
					<span></span>
				</a>
			</li>
		</ul>
	</div>
</div>	
<%-- hiddenInnerIFrame for ���������ύ,����ʾ�Թر� --%>
<span style="visibility:hidden;">
	<iframe name="hiddenInnerIFrame" width="0" height="0" frameborder="0"></iframe>
</span>
<%-- ��ɾ --%>
<div id="hiddenDiv1" style="display:none;"></div>
</body>
</html>

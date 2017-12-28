<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>���ӳ���</title>
<meta http-equiv="Content-Type" content="text/html; charset=gbk" />
	
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/niceform.css"></link>
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/buttonForm.css"></link>

<script type="text/javascript">
	var basePath = "<%=basePath%>";
</script>
<script type="text/javascript" src="<%=basePath%>js/niceform.js"></script>

<script type="text/javascript" src="<%=basePath%>js/global.js"></script>
<script type="text/javascript" src="<%=basePath%>js/formValidator.js"></script>

<script type='text/javascript' src='<%=basePath%>dwr/interface/RS232Handler.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/interface/carManager.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/engine.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/util.js'></script>

<script type='text/javascript'>
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
		carManager.checkIDCardHasUsedByIDCardNum(IDCardNum, function(data){
			if(!data){
				document.getElementById("carIDCardID").value = IDCardNum;
			}else{
				alert("����Ϊ\""+IDCardNum+"\"��ID���Ѿ���ʹ��,�����ظ�ʹ��!");
			}
			IDCardNum = "";
		});
	}
}

function amIChecked(){
	 var a=0,b=0;
	 for(var i=0; i<5; i++) {
		a++;
	 }
	 for(var i=0;i<5;i++){
		b++;
	 }
	return a;
}

//��keycodeת��Ϊ����;����0��keycodeֵΪ48;����9��keycodeֵΪ57;
function changeKeycodeToNumber(keycode){
	var numberValue = 0;
	if(keycode >=48 && keycode <= 57){
		numberValue = keycode - 48;
	}
	return numberValue;
}

//����ҳ��Ϳ�ʼ��ȡRS232������,��ˢ����,�����������������д��������;
var rs232DataTimeout;
var collectDataFlag = true;
function getDataConstantly(){
	rs232DataTimeout = setInterval(getAndSetRS232Data, 500);
}
function getAndSetRS232Data(){
	RS232Handler.getRS232Data(function(data){
		if(!checkNullOfString(data)){
			if(collectDataFlag){
				document.getElementById("tareWeight").value = (parseFloat(data)).toFixed(3);
			}
		}
	});
}
function doOnCancel(){
	if(rs232DataTimeout!=undefined){
		clearInterval(rs232DataTimeout);
	}
	submitProtoform('<%=basePath%>listCar.action');
}
function doCheckAndSubmit(){
	var theProtoform = document.getElementById('protoform');
	if(validator.validate(theProtoform)){
		//id���ظ����
		var idCardIDInputValue = document.getElementById("carIDCardID").value;
		carManager.checkIDCardHasUsedByIDCardNum(idCardIDInputValue, function(data){
			if(data){
				alert("����Ϊ\""+idCardIDInputValue+"\"��ID���Ѿ���ʹ��,�벻Ҫ�ظ�ʹ��!");
			}else{
				var tareWeightValue = document.getElementById("tareWeight").value;
				if(tareWeightValue!="" && tareWeightValue!=null && !isNaN(tareWeightValue)){
					theProtoform.submit();
				}else{
					alert("Ƥ�ز���Ϊ��,��ֻ����д����!��˶�!");
				}
			}
		});
	}
}
function continueCollectData(){
	collectDataFlag = true;
	document.getElementById("tareWeight").readOnly = true;
}
function stopCollectData(){
	collectDataFlag = false;
	document.getElementById("tareWeight").readOnly = false;
}
</script>
	
</head>
<body onload="document.body.focus();getDataConstantly();">
<form id="protoform" action="saveOrUpdateCar.action" method="post" class="niceform" style="margin:15px;">
	<fieldset class="fieldsetStyle1">
		<legend>����������Ϣ</legend>
		<div id="" class="fieldsetDivStyle1">
			<table>
				<tr>
					<td width="20%" style="text-align:right;"><label for="textinput">ID����:</label></td>
					<td width="30%" style="text-align:left;"><input type="text" id="carIDCardID" name="carInfo.carIDCardID" size="18" value="" fname="ID����" require="require" maxLength="10"/></td>
					<td width="20%" style="text-align:right;"><label for="textinput">����������λ:</label></td>
					<td width="30%" style="text-align:left;"><input type="text" id="carDept" name="carInfo.carDept" size="18" value="" fname="����������λ" require="require" maxLength="128"/></td>
				</tr>
				<tr>
					<td width="20%" style="text-align:right;"><label for="textinput">���ƺ�:</label></td>
					<td width="30%" style="text-align:left;"><input type="text" id="carNumber" name="carInfo.carNumber" size="18" value="" fname="���ƺ�" require="require" maxLength="32"/></td>
					<td width="20%" style="text-align:right;"><label for="textinput">��ʻԱ:</label></td>
					<td width="30%" style="text-align:left;"><input type="text" id="carDriver" name="carInfo.carDriver" size="18" value="" fname="��ʻԱ" require="require" maxLength="128"/></td>
				</tr>
			</table>
		</div>
	</fieldset>
	<fieldset class="fieldsetStyle1">
		<legend>������Ϣ</legend>
		<div id="" class="fieldsetDivStyle1">
			<table>
				<tr>
					<td width="20%" style="text-align:right;" style="line-height:20px;"><label for="textinput">Ƥ��:</label></td>
					<td width="30%" style="text-align:left;"><input type="text" id="tareWeight" name="carInfo.tareWeight" size="18" value="" fname="Ƥ��" require="require" maxLength="10" readonly="readonly"/></td>
					<td width="20%" style="text-align:right;"><label for="textinput">������λ:</label></td>
					<td width="30%" style="text-align:left;" colspan="3"><label for="textinput" >��</label></td>
				</tr>
				<tr>
					<td width="20%" style="text-align:right;"><label for="textinput">����:</label></td>
					<td width="30%" style="text-align:left;" colspan="3">
						<label id="weightAgainButton" for="textinput" class="labelStyle1" onmouseover="this.className='labelStyle2'" onmouseout="this.className='labelStyle1'" onclick="stopCollectData();">&nbsp;&nbsp;ֹͣ�ɼ�����&nbsp;&nbsp;</label>
						<label id="detailButton" for="textinput" class="labelStyle1" onmouseover="this.className='labelStyle2'" onmouseout="this.className='labelStyle1'" onclick="continueCollectData();">&nbsp;&nbsp;���²ɼ�����&nbsp;&nbsp;</label>
					</td>
				</tr>
			</table>
		</div>
	</fieldset>
	<fieldset class="fieldsetStyle1">
		<legend>��ע��Ϣ</legend>
		<table>
			<tr>
				<td style="padding-left:110px;">
					<label for="textareainput">��ע:</label>
				</td>
			</tr>
			<tr>
				<td style="padding-left:110px; height:140px;">
					<textarea id="carNotes" name="carInfo.carNotes" rows="8" cols="40"></textarea>
				</td>
			</tr>
		</table>
	</fieldset>
	<div style="width:100%;">
		<div class="menu">
			<ul>
				<li>
					<a href="javascript:void(0);" onclick="doOnCancel();">&nbsp;&nbsp;ȡ&nbsp;&nbsp;��&nbsp;&nbsp;<br />
						<span></span>
					</a>
				</li>
				<li>
					<a href="javascript:void(0);" id="submitButton1" onclick="doCheckAndSubmit();">&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;<br />
						<span></span>
					</a>
				</li>
			</ul>
		</div>
	</div>
</form>
</body>
</html>
<script type="text/javascript">
initInputAndTextarea();
</script>
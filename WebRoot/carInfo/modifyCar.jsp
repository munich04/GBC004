<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>�޸ĳ���</title>
<meta http-equiv="Content-Type" content="text/html; charset=gbk" />
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/niceform.css"></link>
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/buttonForm.css"></link>
<script type="text/javascript">
	/*�����ҳ��һ��Ҫ��ǰ����ñ���,����js��ָ��ϵͳ����·��*/
	var basePath = "<%=basePath%>"; 
</script>
<script type="text/javascript" src="<%=basePath%>js/niceform.js"></script>
<script type="text/javascript" src="<%=basePath%>js/global.js"></script>
<script type="text/javascript" src="<%=basePath%>js/formValidator.js"></script>

<script type='text/javascript' src='<%=basePath%>dwr/interface/RS232Handler.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/engine.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/util.js'></script>

<script type="text/javascript">
//����ҳ��Ϳ�ʼ��ȡRS232������,��ˢ����,�����������������д�������;
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
	submitProtoform("<%=basePath%>listCar.action");
}
function submitModify(){
	var theProtoform = document.getElementById('protoform');
	if(validator.validate(theProtoform)){
		var tareWeightValue = document.getElementById("tareWeight").value;
		if(tareWeightValue!="" && tareWeightValue!=null && !isNaN(tareWeightValue)){
			theProtoform.submit();
		}else{
			alert("Ƥ�ز���Ϊ��,��ֻ����д����!��˶�!");
		}
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
<body onload="getDataConstantly();">
<form id="protoform" action="saveOrUpdateCar.action" method="post" style="margin:15px;">
<input id="hiddenEntryId" type="hidden" name="carInfo.id" value="${carInfo.id}"/>
<%-- for carSearchVO --%>
<input type="hidden" id="carNumber" name="carSearchVO.carNumber" value="${carSearchVO.carNumber}"/>
<input type="hidden" id="carIDCardID"  name="carSearchVO.carIDCardID" value="${carSearchVO.carIDCardID}"/>
<input type="hidden" id="carDept"  name="carSearchVO.carDept" value="${carSearchVO.carDept}"/>
<input type="hidden" id="carDriver"  name="carSearchVO.carDriver" value="${carSearchVO.carDriver}"/>
<input type="hidden" id="carLowerWeight"  name="carSearchVO.carLowerWeight" value="${carSearchVO.carLowerWeight}"/>
<input type="hidden" id="carHigherWeight"  name="carSearchVO.carHigherWeight" value="${carSearchVO.carHigherWeight}"/>
	<fieldset class="fieldsetStyle1">
		<legend>�޸ĳ�����Ϣ</legend>
		<div id="" class="fieldsetDivStyle1">
			<table>
				<tr>
					<td width="20%" style="text-align:right;"><label for="textinput">ID����:</label></td>
					<td width="30%" style="text-align:left;"><input type="text" id="carIDCardID" name="carInfo.carIDCardID" size="18" value="${carInfo.carIDCardID}" fname="ID����" require="require" maxLength="10"/></td>
					<td width="20%" style="text-align:right;"><label for="textinput">����������λ:</label></td>
					<td width="30%" style="text-align:left;"><input type="text" id="carDept" name="carInfo.carDept" size="18" value="${carInfo.carDept}" fname="����������λ" require="require"/></td>
				</tr>
				<tr>
					<td width="20%" style="text-align:right;"><label for="textinput">���ƺ�:</label></td>
					<td width="30%" style="text-align:left;"><input type="text" id="carNumber" name="carInfo.carNumber" size="18" value="${carInfo.carNumber}" fname="���ƺ�" require="require"/></td>
					<td width="20%" style="text-align:right;"><label for="textinput">��ʻԱ:</label></td>
					<td width="30%" style="text-align:left;"><input type="text" id="carDriver" name="carInfo.carDriver" size="18" value="${carInfo.carDriver}" fname="��ʻԱ" require="require"/></td>
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
					<td width="30%" style="text-align:left;">	
						<input type="text" id="tareWeight" class='textinput' name="carInfo.tareWeight" style="line-height:15px; width:180px;" size="18" value="${carInfo.tareWeight}" fname="Ƥ��" require="require" maxLength="10" readOnly="readOnly"/>
					</td>
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
					<textarea id="carNotes" name="carInfo.carNotes" rows="8" cols="40">${carInfo.carNotes}</textarea>
				</td>
			</tr>
		</table>
	</fieldset>
	<div style="width:100%;">
		<div class="menu">
			<ul>
				<li>
					<a href="#" onclick="doOnCancel();">&nbsp;&nbsp;ȡ&nbsp;&nbsp;��&nbsp;&nbsp;<br />
						<span></span>
					</a>
				</li>
				<li>
					<a href="#" id="submitButton1" onclick="submitModify();">&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;<br />
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

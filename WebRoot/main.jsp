<%@ page language="java" import="java.util.*" pageEncoding="gbk"%>
<%@page import="com.util.MyUtil"%>
<%@page import="com.po.UserInfo"%>
<%@ taglib prefix="c" uri="/WEB-INF/c.tld"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
   <title>��ƽ³���ɽ����ϵͳ</title>
   
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">    
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">

<link rel="stylesheet" type="text/css" href="<%=basePath%>css/default.css">
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/mainJspCss.css">
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/alarmTip.css"></link>

<script type="text/javascript">
	var basePath = "<%=basePath%>";
</script>
<script type="text/javascript" src="<%=basePath%>js/alarmTip.js"></script>
<script type="text/javascript" src="<%=basePath%>js/global.js"></script>

<script type='text/javascript' src='<%=basePath%>dwr/interface/carManager.js'> </script>
<script type='text/javascript' src='<%=basePath%>dwr/interface/RS232Handler.js'> </script>
<script type='text/javascript' src='<%=basePath%>dwr/engine.js'> </script>
<script type='text/javascript' src='<%=basePath%>dwr/util.js'> </script>

<script type="text/javascript">
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
		carManager.getCarInfoByCarIDCardID(IDCardNum, function(data){
			if(data != null){
				document.getElementById("idInput").value = IDCardNum;
				document.getElementById("numberInput").value = changeNulltoEmptyString(data.carNumber);	
				document.getElementById("driverInput").value = changeNulltoEmptyString(data.carDriver);
				document.getElementById("deptInput").value = changeNulltoEmptyString(data.carDept);
			}else{
				
			}
			IDCardNum = "";
		});
	}
}
function changeNulltoEmptyString(theValue){
	return theValue == null ? "" : theValue;
}
//��keycodeת��Ϊ����;����0��keycodeֵΪ48;����9��keycodeֵΪ57;
function changeKeycodeToNumber(keycode){
	var numberValue = 0;
	if(keycode >=48 && keycode <= 57){
		numberValue = keycode - 48;
	}
	return numberValue;
}

var liColorMouseOver = "orange";
var liColorMouseOut = "#191970";

function doClick(theObj, theSrc, theTitle){
	theObj.style.color = "orange";
	setMenuLiDefaultCssStyle(document.body, theObj);
	
	var container = document.getElementById("frameContainer");
	
	if(theSrc != null && theSrc != "" && theSrc != undefined){
		theSrc += "?requestMillis=" + new Date().getTime();
	}
	container.src = theSrc;

	document.getElementById("titleSpan").innerHTML = theTitle;
}
function openTransmitDetailJspByDwr(){
	openModelDialog(basePath + "addDaily.action", null);
}
function switchUser(){
	document.getElementById("protoform").action = "<%=basePath%>switchUser.action";
	document.getElementById("protoform").submit();
}
</script>
</head>
<body onload="dwr.engine.setActiveReverseAjax(true);" onmousemove="doCursorMove();">
<form action="" method="post" id="protoform">
</form>
    <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td id="headerTd" colspan="3">
				<ul>
					<li onmouseover="this.style.color=liColorMouseOver;" onmouseout="this.style.color=liColorMouseOut;" onclick="window.close();">�˳�ϵͳ</li>
					<li onmouseover="this.style.color=liColorMouseOver;" onmouseout="this.style.color=liColorMouseOut;" onclick="switchUser();">���µ�½</li>
					<li onmouseover="this.style.color=liColorMouseOver;" onmouseout="this.style.color=liColorMouseOut;" onclick="openModelDialog(basePath + 'userInfo/modifyPassword.jsp', null, 500, 230);">�޸�����</li>
					<li onmouseover="this.style.color=liColorMouseOver;" onmouseout="this.style.color=liColorMouseOut;" onclick="openModelDialog(basePath + 'viewLoginUser.action', null, 550, 230);">������Ϣ</li>
				</ul>
			</td>
		</tr>
		<tr>
			<td id="menuTd">
				<div id="menus">
					<div id="mainMenu1" class="mainMenuClass1" onclick="this.className =	
						 this.className=='mainMenuClass1'?'mainMenuClass2':'mainMenuClass1';
						 this.nextSibling.style.display=this.nextSibling.style.display==''?'none':'';"><span>�ճ�ҵ��</span></div>  
					<div id="subMenu1" class="subMenus">
						<li id="cashButton" onclick="doClick(this,'cash.jsp','�ճ�ҵ��->ˢ��');">ˢ��</li>
						<li id="searchDaily" onclick="doClick(this,'searchDaily.action','�ճ�ҵ��->��ѯ');">��ѯ</li>
					</div>
					
					<c:if test="${userInfo.authority == 0 || userInfo.authority == 1}">
					<div id="mainMenu2" class="mainMenuClass1" onclick="this.className =	
						 this.className=='mainMenuClass1'?'mainMenuClass2':'mainMenuClass1';
						 this.nextSibling.style.display=this.nextSibling.style.display==''?'none':'';"><span>����ͬ��</span></div>  
					<div id="subMenu2" class="subMenus">
						<li id="exportDaily" onclick="doClick(this,'dailyInfo/exportToExcel.jsp','����ͬ��->���ݵ���');">���ݵ���</li>
						<li id="listAndDownloadDaily" onclick="doClick(this,'listAndDownloadExcel.action','����ͬ��->��������');">��������</li>
						<li id="serverSychronize" onclick="doClick(this,'sychronize/iMServer.jsp','����ͬ��->��������ͬ��');">��������ͬ��</li>
						<li id="clientSychronize" onclick="doClick(this,'sychronize/iMClient.jsp','����ͬ��->��������ͬ��');">��������ͬ��</li>
					</div>
					</c:if>
					
					<div id="mainMenu3" class="mainMenuClass1" onclick="this.className =	
						 this.className=='mainMenuClass1'?'mainMenuClass2':'mainMenuClass1';
						 this.nextSibling.style.display=this.nextSibling.style.display==''?'none':'';"><span>ϵͳ����</span></div>  
					<div id="subMenu3" class="subMenus">
						<c:if test="${userInfo.authority == 0 || userInfo.authority == 1}">
							<li id="listMine" onclick="doClick(this,'listMine.action','ϵͳ����->���ֹ���');">���ֹ���</li>
							<li id="listSystemLog" onclick="doClick(this,'listSystemLog.action','ϵͳ����->��־����');">��־����</li>
						</c:if>
						<li id="listCar" onclick="doClick(this,'listCar.action','ϵͳ����->��������');">��������</li>
						<c:if test="${userInfo.authority == 0 || userInfo.authority == 1 || userInfo.authority == 2}">
							<li id="listUser" onclick="doClick(this,'listUser.action','ϵͳ����->�û�����');">�û�����</li>
						</c:if>
					</div>

				</div>
			</td>
			<td id="barTd" onclick="
					var menuImg1 = document.getElementById('menuImg1');
					var menuImg1src = menuImg1.src.substring(menuImg1.src.lastIndexOf('/')+1);
					menuImg1.src=menuImg1src=='tri2.jpg'?'pic/tri1.jpg':'pic/tri2.jpg';
					var menuTd1 = document.getElementById('menuTd');
					menuTd1.style.display=menuTd1.style.display==''?'none':'';">
				<img id="menuImg1" src="pic/tri1.jpg" />
			</td>
			<td>
				<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td id="welcomeTd">
							<img src="pic/broadcast.gif" align="absmiddle" alt="" />
							<%Integer authority = ((UserInfo)session.getAttribute("userInfo")).getAuthority(); %>
							��ӭ����${userInfo.nickName}&nbsp;(<%=MyUtil.AUTHORITY_DES_MAP.get(authority)%>)&nbsp;|&nbsp;&nbsp;��ǰλ�ã�<span id="titleSpan">&nbsp;</span>
						</td>
					</tr>
					<tr>
						<td>
							<iframe id="frameContainer" frameborder="0" scrolling="auto" src=""></iframe>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<%-- for IFrame to operate parent`s DOM element --%>
	<input type="hidden" id="invisibleInput" onclick="createTipDiv(this.value, document.getElementById('invisibleInputWidth').value, document.getElementById('invisibleInputHeight').value, document.getElementById('invisibleInputTitle').value);">
	<input type="hidden" id="invisibleInputWidth">
	<input type="hidden" id="invisibleInputHeight">
	<input type="hidden" id="invisibleInputTitle">
</body>
</html>
<script>
	document.getElementById("cashButton").click();
	function fillInputAndSubmitForCarSearch(){
		var lowerWeightInputValue = document.getElementById("lowerWeightInput").value;
		var higherWeightInputValue = document.getElementById("higherWeightInput").value;

		if(isNaN(lowerWeightInputValue)){
			document.getElementById("lowerWeightInput").value = "";
			document.getElementById("lowerWeightInput").focus();
			alert("ë������ֻ����д����,��˶�!");
			return;
		}else if(isNaN(higherWeightInputValue)){
			document.getElementById("higherWeightInput").value = "";
			document.getElementById("higherWeightInput").focus();
			alert("ë������ֻ����д����,��˶�!");
			return;
		}
		window.frames['frameContainer'].document.getElementById('carIDCardID').value = document.getElementById("idInput").value;

		window.frames['frameContainer'].document.getElementById('carNumber').value = document.getElementById("numberInput").value;
	
		window.frames['frameContainer'].document.getElementById('carDriver').value = document.getElementById("driverInput").value;
	
		window.frames['frameContainer'].document.getElementById('carDept').value = document.getElementById("deptInput").value;
	
		window.frames['frameContainer'].document.getElementById('carLowerWeight').value = lowerWeightInputValue;
	
		window.frames['frameContainer'].document.getElementById('carHigherWeight').value = higherWeightInputValue;
		
		window.frames['frameContainer'].document.getElementById('protoform').submit();
		clearTipDiv();
	}
</script>
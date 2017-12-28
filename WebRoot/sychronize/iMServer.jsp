<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<title>��������ͬ��</title>
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/niceform.css"></link>
<style type="text/css">
	.fieldsetStyle1{
		font-size:13px;
		font-family: "΢���ź�";
		margin: 5px auto;
	}
	.fieldsetStyle2{
		font-size:13px;
		font-family: "΢���ź�";
		width:250px;
		height:269px;
		margin: 25px;
		float:left;
	}
	.legendStyle1 {
		font-size:13px;
		font-family: "΢���ź�";
		padding: 0px 5px;
		color: #3D59AB;
		line-height:25px;
	}
	.tipDivStyle1 {
		font-size:13px;
		font-family: "΢���ź�";
		padding: 0px 5px;
		color: #3D59AB;
		line-height:25px;
		margin:15px 15px 15px 50px;
	}
	.tipDivStyle3 {
		font-size:13px;
		font-family: "΢���ź�";
		margin: 3px;
		padding: 15px;
		color: #123456;
	}
	.tipDivStyle4 {
		font-size:13px;
		font-family: "΢���ź�";
		color: #FF8000;
		cursor: hand;
		background: #f0eeee;
		text-decoration:underline;
	}
	.exportLabelStyle1 {
		margin: 3px;
		padding: 5px 10px;
		color: #3D59AB;
		background: #e0eeee;
		cursor: hand;
	}
	.exportLabelStyle2 {
		margin: 3px;
		padding: 5px 10px;
		color: orange;
		background: #e0eeee;
		cursor: hand;
	}
	.exportLabelStyle3 {
		margin: 3px;
		padding: 5px 5px 5px 10px;
		color: #e0eeee;
		background: #123456;
		cursor: hand;
	}
	.exportLabelStyle4 {
		margin: 3px;
		padding: 5px 5px 5px 10px;
		color: orange;
		background: #123456;
		cursor: hand;
	}
	.errorInfoStyle1{
		padding:2px 2px; 
		background:#f5f5f5;
		margin:2px 15px;
	}
</style>
<script type="text/javascript">
	var basePath = "<%=basePath%>";
</script>
<script type='text/javascript' src='<%=basePath%>dwr/interface/sychronizeManager.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/engine.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/util.js'></script>

<script type='text/javascript' src='<%=basePath%>js/global.js'></script>
<script>
	var errorInfoInterval;	//socketServer������,ÿ��1��,���1��socketServer��������־��Ϣ;
	var fileReceivedSuccessListener;	//socketServer������,ÿ��3��,����ļ��Ƿ���ճɹ�,�����,��������json�ļ��Ľ��������ݿ����;
	function doStartFileServerSocket(){
		var portObj = document.getElementById("portInput");
		if(portObj.value == "" || portObj.value == null){
			alert("����д�˿ں�!");
			portObj.focus();
			return;
		}else if(isNaN(portObj.value) || parseInt(portObj.value) > 65535 || parseInt(portObj.value) < 0){
			alert("�˿ںű���Ϊ����0-65535������!��˶�!");
			portObj.focus();
			return;
		}
		//���汾�������Port
		sychronizeManager.savePortInfo(portObj.value);
		
		//�õ���Ŀ�ڱ��ش��̵ľ���·��,��д���ļ���ָ��λ��
		var filePath = '<%=session.getServletContext().getRealPath("/").replace("\\","/")%>';
		//����socketServer
		sychronizeManager.startServer(filePath, portObj.value);

		//����errorInfoInterval����1���Ƶ�ʻ�ȡsocketServer��������־
		if(errorInfoInterval != null){
			clearInterval(errorInfoInterval);
		}
		document.getElementById("serverInfoDiv").innerHTML = "&nbsp;";
		errorInfoInterval = setInterval(getErrorInfo, 1000);
		
		//����fileReceivedSuccessListener�Լ����ļ��Ƿ���ɹ�
		if(fileReceivedSuccessListener != null){
			clearInterval(fileReceivedSuccessListener);
		}
		fileReceivedSuccessListener = setInterval(getSuccessFlag, 3000);
	}
	function doStopFileServerSocket(){
		//�ر�socketServer
		sychronizeManager.stopServer();
		//�ر�socketServer������־����
		if(errorInfoInterval != null){
			clearInterval(errorInfoInterval);
		}
		//�ر�fileReceivedSuccessListener
		if(fileReceivedSuccessListener != null){
			clearInterval(fileReceivedSuccessListener);
		}
		document.getElementById("serverInfoDiv").innerHTML = "<div class='errorInfoStyle1'>"+getTimeOfNow()+" : ����ͬ���ѹر�!</div>";
	}

	function getErrorInfo(){
		sychronizeManager.getServerInfo(function(data){
			serverInfoDiv.innerHTML = data;
		});
	}
	//����socketServer�����ļ��Ƿ�ɹ�,���ɹ�,�����ؽ��յ���json�ļ���;����⵽��ֵʱ,�����Խ��յ����ļ��Ĵ���;
	function getSuccessFlag(){
		sychronizeManager.getFileReceivedSuccessInfo(function(fileName){
			if(fileName != null && fileName != ""){
				//�ļ����ճɹ�,���ȹرռ���
				if(fileReceivedSuccessListener != null){
					clearInterval(fileReceivedSuccessListener);
				}
				//��ʼ�Ը�json�ļ����н���
				doAnalyzeJsonData(fileName);
			}
		});
	}

	function doAnalyzeJsonData(fileName){
		var filePath = '<%=session.getServletContext().getRealPath("/").replace("\\","/")%>';
		sychronizeManager.analyzeJsonData(filePath, fileName, function(data){
			if(data == "" || data == null){
				alert("�ļ���������ӳɹ�!");	
			}else{
				alert("�ļ�����ʧ��,�����ҳ���·�����ʾ����! ����ϵ����ԱЭ�����!");
				document.getElementById("fileDealFieldset1").style.display = "";
			}
		});
	}
	//�Զ�������ʹ�ù��Ķ˿�
	function autoFillLatestUserPort(){
		sychronizeManager.getLatestUsedPort(1, function(portList){
			if(portList != null && portList.length > 0){
				document.getElementById("portInput").value = portList[0].port;
			}
		})
	}

	function selectPort(){
		var url = basePath + 'sychronize/choosePort.jsp';
		var portValue = window.showModalDialog(url, null, "dialogWidth=480px;dialogHeight=200px;status=no;");
		if(portValue != undefined){
			document.getElementById("portInput").value = portValue;
		}
	}
</script>
</head>
<body onload="autoFillLatestUserPort();">
<fieldset class="fieldsetStyle1" style="width:95%; margin:5px;">
	<legend class="legendStyle1">����ͬ������</legend>
	<div id="" class="fieldsetDivStyle1">
		<table id="firstTable">
			<tr>
				<td width="12%" style="text-align:right;"><label>������˿ں�:</label></td>
				<td width="18%" style="text-align:left;">
					<img class='inputCorner' src='<%=basePath%>pic/niceform/input_left.gif'><input type='text' id='portInput' class='textinput' size='12' style='line-height:15px; width:180px;' value="" /><img class='inputCorner' src='<%=basePath%>pic/niceform/input_right.gif'>
				</td>
				<td width="70%" style="padding-left:15px;">
					<label class="exportLabelStyle1" onmouseover="this.className='exportLabelStyle2'" onmouseout="this.className='exportLabelStyle1'" for="textinput" onclick="selectPort();">��ʷ���ö˿�</label>
					<label class="exportLabelStyle1" onmouseover="this.className='exportLabelStyle2'" onmouseout="this.className='exportLabelStyle1'" for="textinput" onclick="doStartFileServerSocket();">��ʼͬ������</label>
					<label class="exportLabelStyle1" onmouseover="this.className='exportLabelStyle2'" onmouseout="this.className='exportLabelStyle1'" for="textinput" onclick="doStopFileServerSocket();">ֹͣͬ������</label>
				</td>
			</tr>
		</table>
	</div>
</fieldset>
<fieldset class="fieldsetStyle1" style="width:95%; margin:5px;">
	<legend><span class="legendStyle1">��������־��</span></legend>
	<div id="serverInfoDiv" style="height:350px; overflow:auto;">
		&nbsp;
	</div>
</fieldset>
<fieldset id="fileDealFieldset1" class="fieldsetStyle1" style="width:95%; margin:5px;  display:none;;">
	<legend><span class="legendStyle1">ͬ���ļ�������Ϣ��</span></legend>
	<div id="" style="height:70px; overflow:auto;">
		<div style="padding:15px 50px;">
			<span style="background:#d5d5d5; padding-left:5px;">�ļ��Ѿ��ɹ�����!���ڴ�������г����쳣!������ѡ��
				<label class="exportLabelStyle3" onmouseover="this.className='exportLabelStyle4'" onmouseout="this.className='exportLabelStyle3'" for="textinput" onclick="doStartFileServerSocket();">
					���´����ļ�
				</label>��
				<label class="exportLabelStyle3" onmouseover="this.className='exportLabelStyle4'" onmouseout="this.className='exportLabelStyle3'" for="textinput" onclick="doStartFileServerSocket();">
				����ͬ������
				</label>
			</span>
		</div>
	</div>
</fieldset>

</body>
</html>
<script>
specifyParentNodeCssStyle("serverSychronize");
</script>
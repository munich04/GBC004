<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<title>开启数据同步</title>
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/niceform.css"></link>
<style type="text/css">
	.fieldsetStyle1{
		font-size:13px;
		font-family: "微软雅黑";
		margin: 5px auto;
	}
	.fieldsetStyle2{
		font-size:13px;
		font-family: "微软雅黑";
		width:250px;
		height:269px;
		margin: 25px;
		float:left;
	}
	.legendStyle1 {
		font-size:13px;
		font-family: "微软雅黑";
		padding: 0px 5px;
		color: #3D59AB;
		line-height:25px;
	}
	.tipDivStyle1 {
		font-size:13px;
		font-family: "微软雅黑";
		padding: 0px 5px;
		color: #3D59AB;
		line-height:25px;
		margin:15px 15px 15px 50px;
	}
	.tipDivStyle3 {
		font-size:13px;
		font-family: "微软雅黑";
		margin: 3px;
		padding: 15px;
		color: #123456;
	}
	.tipDivStyle4 {
		font-size:13px;
		font-family: "微软雅黑";
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
	var errorInfoInterval;	//socketServer启动后,每隔1秒,输出1次socketServer的运行日志信息;
	var fileReceivedSuccessListener;	//socketServer启动后,每隔3秒,检查文件是否接收成功,如果是,则启动对json文件的解析和数据库操作;
	function doStartFileServerSocket(){
		var portObj = document.getElementById("portInput");
		if(portObj.value == "" || portObj.value == null){
			alert("请填写端口号!");
			portObj.focus();
			return;
		}else if(isNaN(portObj.value) || parseInt(portObj.value) > 65535 || parseInt(portObj.value) < 0){
			alert("端口号必须为介于0-65535的整数!请核对!");
			portObj.focus();
			return;
		}
		//保存本次输入的Port
		sychronizeManager.savePortInfo(portObj.value);
		
		//得到项目在本地磁盘的绝对路径,以写入文件到指定位置
		var filePath = '<%=session.getServletContext().getRealPath("/").replace("\\","/")%>';
		//启动socketServer
		sychronizeManager.startServer(filePath, portObj.value);

		//启动errorInfoInterval以以1秒的频率获取socketServer的运行日志
		if(errorInfoInterval != null){
			clearInterval(errorInfoInterval);
		}
		document.getElementById("serverInfoDiv").innerHTML = "&nbsp;";
		errorInfoInterval = setInterval(getErrorInfo, 1000);
		
		//启动fileReceivedSuccessListener以监听文件是否传输成功
		if(fileReceivedSuccessListener != null){
			clearInterval(fileReceivedSuccessListener);
		}
		fileReceivedSuccessListener = setInterval(getSuccessFlag, 3000);
	}
	function doStopFileServerSocket(){
		//关闭socketServer
		sychronizeManager.stopServer();
		//关闭socketServer运行日志监听
		if(errorInfoInterval != null){
			clearInterval(errorInfoInterval);
		}
		//关闭fileReceivedSuccessListener
		if(fileReceivedSuccessListener != null){
			clearInterval(fileReceivedSuccessListener);
		}
		document.getElementById("serverInfoDiv").innerHTML = "<div class='errorInfoStyle1'>"+getTimeOfNow()+" : 数据同步已关闭!</div>";
	}

	function getErrorInfo(){
		sychronizeManager.getServerInfo(function(data){
			serverInfoDiv.innerHTML = data;
		});
	}
	//监听socketServer接收文件是否成功,若成功,将返回接收到的json文件名;当监测到该值时,开启对接收到的文件的处理;
	function getSuccessFlag(){
		sychronizeManager.getFileReceivedSuccessInfo(function(fileName){
			if(fileName != null && fileName != ""){
				//文件接收成功,首先关闭监听
				if(fileReceivedSuccessListener != null){
					clearInterval(fileReceivedSuccessListener);
				}
				//开始对该json文件进行解析
				doAnalyzeJsonData(fileName);
			}
		});
	}

	function doAnalyzeJsonData(fileName){
		var filePath = '<%=session.getServletContext().getRealPath("/").replace("\\","/")%>';
		sychronizeManager.analyzeJsonData(filePath, fileName, function(data){
			if(data == "" || data == null){
				alert("文件解析并添加成功!");	
			}else{
				alert("文件处理失败,请参照页面下方的提示重试! 或联系管理员协助解决!");
				document.getElementById("fileDealFieldset1").style.display = "";
			}
		});
	}
	//自动填充最近使用过的端口
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
	<legend class="legendStyle1">开启同步服务：</legend>
	<div id="" class="fieldsetDivStyle1">
		<table id="firstTable">
			<tr>
				<td width="12%" style="text-align:right;"><label>请输入端口号:</label></td>
				<td width="18%" style="text-align:left;">
					<img class='inputCorner' src='<%=basePath%>pic/niceform/input_left.gif'><input type='text' id='portInput' class='textinput' size='12' style='line-height:15px; width:180px;' value="" /><img class='inputCorner' src='<%=basePath%>pic/niceform/input_right.gif'>
				</td>
				<td width="70%" style="padding-left:15px;">
					<label class="exportLabelStyle1" onmouseover="this.className='exportLabelStyle2'" onmouseout="this.className='exportLabelStyle1'" for="textinput" onclick="selectPort();">历史常用端口</label>
					<label class="exportLabelStyle1" onmouseover="this.className='exportLabelStyle2'" onmouseout="this.className='exportLabelStyle1'" for="textinput" onclick="doStartFileServerSocket();">开始同步数据</label>
					<label class="exportLabelStyle1" onmouseover="this.className='exportLabelStyle2'" onmouseout="this.className='exportLabelStyle1'" for="textinput" onclick="doStopFileServerSocket();">停止同步数据</label>
				</td>
			</tr>
		</table>
	</div>
</fieldset>
<fieldset class="fieldsetStyle1" style="width:95%; margin:5px;">
	<legend><span class="legendStyle1">服务器日志：</span></legend>
	<div id="serverInfoDiv" style="height:350px; overflow:auto;">
		&nbsp;
	</div>
</fieldset>
<fieldset id="fileDealFieldset1" class="fieldsetStyle1" style="width:95%; margin:5px;  display:none;;">
	<legend><span class="legendStyle1">同步文件处理信息：</span></legend>
	<div id="" style="height:70px; overflow:auto;">
		<div style="padding:15px 50px;">
			<span style="background:#d5d5d5; padding-left:5px;">文件已经成功接收!但在处理过程中出现异常!您可以选择
				<label class="exportLabelStyle3" onmouseover="this.className='exportLabelStyle4'" onmouseout="this.className='exportLabelStyle3'" for="textinput" onclick="doStartFileServerSocket();">
					重新处理文件
				</label>或
				<label class="exportLabelStyle3" onmouseover="this.className='exportLabelStyle4'" onmouseout="this.className='exportLabelStyle3'" for="textinput" onclick="doStartFileServerSocket();">
				重新同步数据
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
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
<title>日常业务-刷卡</title>
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/buttonCash.css">
<style type="text/css">
.fieldsetStyle1{
	font-size:13px;
	font-family: "微软雅黑";
	margin: 25px auto;
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
	background: #f0f0f0;
	line-height:25px;
}
.tipDivStyle1 {
	font-size:13px;
	font-family: "微软雅黑";
	padding: 0px 5px;
	color: #3D59AB;
	background: #f0eeee;
	line-height:25px;
	margin:15px 15px 15px 50px;
}
.tipDivStyle3 {
	font-size:13px;
	font-family: "微软雅黑";
	width: 78px;
	margin: 3px;
	padding: 1px 5px;
	color: #ff0000;
}
.tipDivStyle4 {
	font-size:13px;
	font-family: "微软雅黑";
	color: #FF8000;
	cursor: hand;
	background: #f0eeee;
	text-decoration:underline;
}
</style>
<script type="text/javascript">
	var basePath = "<%=basePath%>";
</script>
<script type="text/javascript" src="<%=basePath%>js/global.js"></script>

<script type='text/javascript' src='<%=basePath%>dwr/interface/dailyManager.js'> </script>
<script type='text/javascript' src='<%=basePath%>dwr/interface/RS232Handler.js'> </script> 
<script type='text/javascript' src='<%=basePath%>dwr/engine.js'> </script>
<script type='text/javascript' src='<%=basePath%>dwr/util.js'> </script>

<script type="text/javascript">
	function openRS232Service(){
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
			}//串口已打开
			else{
				RS232Handler.destroyRS232Service(function(closeFlag){
					//成功关闭;
					if(closeFlag){
						//重新打开串口
						RS232Handler.initRS232Service(function(openFlag){
							//串口打开失败
							if(!openFlag){
								alert("串口打开失败!请检查设备连接正确!");
							}
						});
					}
				});
			}
		});
	}
	function openTransmitDetailByUser(){
		openRS232Service();
		var returnValue = openModelDialog(basePath + "addDaily.action", null);
		if(returnValue == "1"){
			location.reload();
		}
	}

	//计算统计数据,如果出现NaN,将再查一次(最多查3次)
	var computeCount = 0;
	function computeSumValues(){
		dailyManager.countDailyInfoDuringSpecifidPeroid(null, null, true, function(finishedCount){
			if(!checkNullOfString(finishedCount)){
				document.getElementById("finishedCount").innerHTML = finishedCount;

				dailyManager.countDailyInfoDuringSpecifidPeroid(null, null, false, function(unFinishedCount){
					if(!checkNullOfString(unFinishedCount)){
						document.getElementById("unFinishedCount").innerHTML = unFinishedCount;

						var finishedCountValue = document.getElementById("finishedCount").innerHTML;
						if(!checkNullOfString(finishedCountValue)){
							document.getElementById("totalCount").innerHTML = parseInt(finishedCountValue) + parseInt(unFinishedCount);
						}
						
						dailyManager.countWeightOfMineTransferedDuringSpecifidPeroid(null, null, function(data){
							var weightFieldSet = document.getElementById("weightFieldSet");
							if(data != null && data != ""){
								weightFieldSet.innerHTML = "&nbsp;";
								var innerStr = "";
								for(var i = 0; i < data.length;i++){
									innerStr += "<div class='tipDivStyle1'>" + data[i][0] + " :<span id='' class='tipDivStyle3'>&nbsp;" + parseFloat(data[i][1]).toFixed(3) + "</span>吨</div>";
								}
								weightFieldSet.innerHTML = innerStr;
							}else{
								weightFieldSet.innerHTML = "<div class='tipDivStyle1'>菱铁矿：<span id='' class='tipDivStyle3'>0</span>吨</div>";
							}

							if(!checkInitDataCorrect()){
								computeCount++;
								if(computeCount < 3){
									computeSumValues();
								}else{
									computeCount = 0;
									document.getElementById("finishedCount").innerHTML = "0";
									document.getElementById("unFinishedCount").innerHTML = "0";
									document.getElementById("totalCount").innerHTML = "0";
								}
							}
						});
					}
				});
			}
		});
	}

	function checkInitDataCorrect(){
		return checkIsNumber("finishedCount") && checkIsNumber("unFinishedCount") &&checkIsNumber("totalCount");
	}

	function searchFinishedDaily(){
		document.getElementById("hangUpState").value = false;
		submitProtoformWithHiddenValue('hasFinished', true, '<%=basePath%>searchDaily.action')
	}
</script>
</head>
<body onload="openRS232Service();computeSumValues();">
<form action="" method="post" id="protoform">
	<input type="hidden" id="startMillis" name="dailySearchVO.startMillis">
	<input type="hidden" id="endMillis" name="dailySearchVO.endMillis">
	<input type="hidden" id="hasFinished" name="dailySearchVO.hasFinished">
	<input type="hidden" id="hangUpState" name="dailySearchVO.hangUpState">
</form>
<div>
	<div style="width:500px; float:left;">
		<fieldset class="fieldsetStyle1">
			<legend><span  class="legendStyle1">今日信息：</span></legend>
			<div class="tipDivStyle1">
				今日已有<span id="totalCount" class="tipDivStyle3">&nbsp;&nbsp;&nbsp;</span>辆矿车进入矿场
			</div>
			<div class="tipDivStyle1">
				其中<span id="finishedCount" class="tipDivStyle3">&nbsp;&nbsp;&nbsp;</span>辆完成拉矿&nbsp;(<span onmouseover="this.className='tipDivStyle4'" onmouseout="this.className=''" onclick="searchFinishedDaily()">&nbsp;点击查看&nbsp;</span>)
			</div>
			<div class="tipDivStyle1">
				还有<span id="unFinishedCount" class="tipDivStyle3">&nbsp;&nbsp;&nbsp;</span>辆未出矿场&nbsp;(<span onmouseover="this.className='tipDivStyle4'" onmouseout="this.className=''" onclick="submitProtoformWithHiddenValue('hasFinished', false, '<%=basePath%>searchDaily.action')">&nbsp;点击查看&nbsp;</span>)
			</div>
		</fieldset>
		<fieldset id="" class="fieldsetStyle1">
			<legend><span  class="legendStyle1">今日售出：</span></legend>
			<div id="weightFieldSet" class="">
				<div class="tipDivStyle1">菱铁矿：<span id='' class='tipDivStyle3'>0</span>吨</div>
			</div>
		</fieldset>
	</div>
	<fieldset class="fieldsetStyle2">
		<legend><span  class="legendStyle1">可用操作：</span></legend>
		<div class="menu">
			<ul>
				<li>
					<a href="#" onclick="restartRS232Service();">重启服务<br />
						<span></span>
					</a>
				</li>
				<li>
					<a href="#" onclick="openTransmitDetailByUser();">手动弹窗<br />
						<span></span>
					</a>
				</li>
				<li>
					<a href="#" onclick="clickParentNode('searchDaily')">清单查询<br />
						<span></span>
					</a>
				</li>
			</ul>
		</div>
	</fieldset>
</div>
</body>
</html>
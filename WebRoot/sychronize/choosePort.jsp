<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%@page import="com.util.MyUtil"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>选择端口</title>
<meta http-equiv="Content-Type" content="text/html; charset=gbk" />
<style type="text/css">
	.spanBtnStyle1{
		background:#e0eeee;
		color:#123456;
		cursor:hand;
		padding:5px 7px;
		font-family: "微软雅黑";
		font-size: 13px;
		margin-right:8px;
	}
	.spanBtnStyle2{
		background:#e0eeee;
		color:orange;
		cursor:hand;
		padding:5px 7px;
		font-family: "微软雅黑";
		font-size: 13px;
		margin-right:8px;
	}
</style>
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/niceform.css"></link>
<script type="text/javascript">
	var basePath = "<%=basePath%>";
</script>
<script type='text/javascript' src='<%=basePath%>dwr/interface/sychronizeManager.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/engine.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/util.js'></script>
<script type="text/javascript">
	function deletePort(port, index){
		sychronizeManager.deletePortInfoByPort(port, function(){
			document.getElementById("tr"+index).style.display = "none";
			changeOtherTRIndex(index);
		});
	}	

	function changeOtherTRIndex(index){
		var trs = document.getElementById("portTable").getElementsByTagName("tr");
		for(var i=index;i<trs.length;i++){
			var obj = trs[i].firstChild.firstChild;
			var theValue = parseInt(obj.innerHTML.replace(".",""));
			obj.innerHTML = (theValue - 1) + ".";
		}
	}

	function getLatestPorts(){
		sychronizeManager.getLatestUsedPort(<%=MyUtil.LATEST_IP_PORT_COUNT%>, function(portList){
			if(portList != null && portList.length > 0){
				var table = document.getElementById("portTable");
				for(var i = 0; i < portList.length; i++){
					var tr = document.createElement("<tr style='display:'>");
					tr.id = "tr"+i;
					
					var td1 = document.createElement("<td width='10%' style='text-align:center;'>");
					var div1 = document.createElement("<div class='labelStyle4' style='width:10px'>");
					div1.innerHTML = (i + 1) + ".";
					td1.appendChild(div1);

					var td2 = document.createElement("<td width='60%' style='text-align:center;'>");
					var div2 = document.createElement("<div class='labelStyle4' style='width:150px'>");
					div2.innerHTML = portList[i].port;
					td2.appendChild(div2);

					var td3 = document.createElement("<td width='30%' style='text-align:center;'>");
					var div3 = document.createElement("<div>");
					var div3InnerStr = "<span class=\"spanBtnStyle1\" onmouseover=\"this.className='spanBtnStyle2'\" onmouseout=\"this.className='spanBtnStyle1'\" onclick=\"deletePort('"+portList[i].port+"','"+i+"')\">删除</span><span class=\"spanBtnStyle1\" onmouseover=\"this.className='spanBtnStyle2'\" onmouseout=\"this.className='spanBtnStyle1'\" onclick=\"choose('"+portList[i].port+"')\">选择</span>"
					div3.innerHTML = div3InnerStr;
					td3.appendChild(div3);

					tr.appendChild(td1);
					tr.appendChild(td2);
					tr.appendChild(td3); 

					table.firstChild.appendChild(tr);
				}
			}else{
				var tr = document.createElement("<tr>");
				var td = document.createElement("<td width='100%' style='text-align:center;'>");
				var div = document.createElement("<div class='labelStyle4' style='width:150px'>");
				div.innerHTML = "暂    无    数    据!";
				td.appendChild(div);
				tr.appendChild(td);
				document.getElementById("portTable").firstChild.appendChild(tr);
			}
		});
	}
	function choose(port){
		window.returnValue = port;
		window.close();
	}
</script>
</head>
<body onload="getLatestPorts();">
<fieldset class="fieldsetStyle1">
	<legend>最近使用的端口</legend>
	<div id="" class="fieldsetDivStyle1">
		<table id="portTable" style="width:100%;">
		</table>
	</div>
</fieldset>
</body>
</html>

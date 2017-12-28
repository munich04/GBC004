<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%@page import="com.util.MyUtil"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>选择IP</title>
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
	function deleteIp(ip, port, index){
		sychronizeManager.deleteIpInfoByIpAndPort(ip, port, function(){
			document.getElementById("tr"+index).style.display = "none";
			changeOtherTRIndex(index);
		});
	}

	function changeOtherTRIndex(index){
		var trs = document.getElementById("ipTable").getElementsByTagName("tr");
		for(var i=index;i<trs.length;i++){
			var obj = trs[i].firstChild.firstChild;
			var theValue = parseInt(obj.innerHTML.replace(".",""));
			obj.innerHTML = (theValue - 1) + ".";
		}
	}
	
	function getLatestIps(){
		sychronizeManager.getLatestUsedIp(<%=MyUtil.LATEST_IP_PORT_COUNT%>, function(ipList){
			if(ipList != null && ipList.length > 0){
				var table = document.getElementById("ipTable");
				for(var i = 0; i < ipList.length; i++){
					var tr = document.createElement("<tr style='display:'>");
					tr.id = "tr"+i;
					
					var td1 = document.createElement("<td width='10%' style='text-align:center;'>");
					var div1 = document.createElement("<div class='labelStyle4' style='width:10px'>");
					div1.innerHTML = (i + 1) + ".";
					td1.appendChild(div1);

					var td2 = document.createElement("<td width='30%' style='text-align:center;'>");
					var div2 = document.createElement("<div class='labelStyle4' style='width:150px'>");
					div2.innerHTML = ipList[i].ip;
					td2.appendChild(div2);

					var td3 = document.createElement("<td width='30%' style='text-align:center;'>");
					var div3 = document.createElement("<div class='labelStyle4' style='width:100px'>");
					div3.innerHTML = ipList[i].port;
					td3.appendChild(div3);

					var td4 = document.createElement("<td width='30%' style='text-align:center;'>");
					var div4 = document.createElement("<div>");
					var div4InnerStr = "<span class=\"spanBtnStyle1\" onmouseover=\"this.className='spanBtnStyle2'\" onmouseout=\"this.className='spanBtnStyle1'\" onclick=\"deleteIp('"+ipList[i].ip+"', '"+ipList[i].port+"','"+i+"')\">删除</span><span class=\"spanBtnStyle1\" onmouseover=\"this.className='spanBtnStyle2'\" onmouseout=\"this.className='spanBtnStyle1'\" onclick=\"choose('"+ipList[i].ip+"','"+ipList[i].port+"')\">选择</span>"
					div4.innerHTML = div4InnerStr;
					td4.appendChild(div4);

					tr.appendChild(td1);
					tr.appendChild(td2);
					tr.appendChild(td3);
					tr.appendChild(td4);

					table.firstChild.appendChild(tr);
				}
			}else{
				var tr = document.createElement("<tr>");
				var td = document.createElement("<td width='100%' style='text-align:center;'>");
				var div = document.createElement("<div class='labelStyle4' style='width:150px'>");
				div.innerHTML = "  暂    无    数    据  !  ";
				td.appendChild(div);
				tr.appendChild(td);
				document.getElementById("ipTable").firstChild.appendChild(tr);
			}
		});
	}
	function choose(ip, port){
		var array = new Array();
		array[array.length] = ip;
		array[array.length] = port;
		window.returnValue = array;
		window.close();
	}
</script>
</head>
<body onload="getLatestIps();">
<fieldset class="fieldsetStyle1">
	<legend>最近使用的IP地址和端口</legend>
	<div id="" class="fieldsetDivStyle1">
		<table id="ipTable" style="width:100%;">
		</table>
	</div>
</fieldset>
</body>
</html>

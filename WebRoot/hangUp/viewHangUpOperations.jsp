<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%@ taglib prefix="c" uri="/WEB-INF/c.tld"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>查看操作记录</title>
<meta http-equiv="Content-Type" content="text/html; charset=gbk" />
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/niceform.css"></link>
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/buttonForm.css"></link>
<style type="text/css">
	.divStyle01{
		margin:3px 3px 3px 20px; width:99%; background:#f5f5f5; padding:3px; cursor:hand;
		font-family: "微软雅黑"; color:#123456;
	}
	.divStyle02{
		margin:3px 3px 3px 20px; width:99%; background:#dcdcdc; padding:3px; cursor:hand;
		font-family: "微软雅黑"; color:#123456;
	}
</style>
<script type="text/javascript">
	var basePath = "<%=basePath%>";
</script>
<script type="text/javascript" src="<%=basePath%>js/niceform.js"></script>
<script type="text/javascript" src="<%=basePath%>js/global.js"></script>

<script type='text/javascript' src='<%=basePath%>dwr/interface/hangUpManager.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/engine.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/util.js'></script>

<script type="text/javascript">
	function init(){
		var entryID = window.dialogArguments;
		document.getElementById("dailyInfoID").value = entryID;

		hangUpManager.getHangUpOperationsByDailyInfoID(entryID, function(data){
			var obj = document.getElementById("mainDataTable").firstChild;
			if(data != null && data != ""){
				var innerStr = "";
				for(var i = 0;i < data.length; i++){
					var tr1 = document.createElement("tr");
					var td1 = document.createElement("td");
					td1.innerHTML = "<div class='divStyle01' onmouseover='this.className=\"divStyle02\"' onmouseout='this.className=\"divStyle01\"'>"+(i+1)+". "+data[i].operatorAuthorityToStringVO + " " +data[i].operatorNickNameVO+" 于 "+changeMillisToLocalString(data[i].operateTimeVO)+" 执行了 <font style='color:red;'>"+data[i].hangUpStateToStringVO+" </font>操作.</div><div class='divStyle01' onmouseover='this.className=\"divStyle02\"' onmouseout='this.className=\"divStyle01\"' title='缘由："+data[i].operateNotesVO+"'>缘由："+data[i].operateNotesVO+"</div>";
					tr1.appendChild(td1);
					obj.appendChild(tr1);
				}
			}else{
				var tr1 = document.createElement("tr");
				var td1 = document.createElement("td");
				td1.innerHTML = "<div style='width:99%; text-align:center;'>&nbsp;&nbsp;暂&nbsp;无&nbsp;记&nbsp;录&nbsp;&nbsp;</div>";
				tr1.appendChild(td1);
				obj.appendChild(tr1);
			}
		});
	}
</script>
</head>
<body onload="init();">
<fieldset class="fieldsetStyle1" style="width:99%;">
	<legend>查看操作记录</legend>
	<div id="" class="">
		<table id="mainDataTable" width="99%;">
		</table>
	</div>
</fieldset>
<div style="width:500px; text-align:center;">
	<div class="menu">
		<ul>
			<li>
				<a href="#"  onclick="window.close();">&nbsp;&nbsp;返&nbsp;&nbsp;回&nbsp;&nbsp;<br />
					<span></span>
				</a>
			</li>
		</ul>
	</div>
</div>
<form action="" method="post" id="protoform">
	<input type="hidden" id="dailyInfoID" name="hangUpOperation.dailyInfoID"/>
</form>
</body>
</html>
<script type="text/javascript">
initInputAndTextarea();
</script>

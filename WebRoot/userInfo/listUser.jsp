<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%@ taglib prefix="c" uri="/WEB-INF/c.tld"%>
<%@ taglib prefix="test" uri="/WEB-INF/test.tld" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>用户管理</title>
<meta http-equiv="Content-Type" content="text/html; charset=gbk" />
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/default.css"></link>
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/niceform.css"></link>
<style type="text/css">
	.exportLabelStyle1 {
		width: 78px;
		margin: 3px;
		padding: 5px 10px;
		color: #3D59AB;
		background: #e0eeee;
		cursor: hand;
	}
	.exportLabelStyle2 {
		width: 78px;
		margin: 3px;
		padding: 5px 10px;
		color: orange;
		background: #e0eeee;
		cursor: hand;
	}
</style>
<script type="text/javascript">
	var basePath = "<%=basePath%>";
</script>
<script type='text/javascript' src='<%=basePath%>dwr/interface/userManager.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/engine.js'></script>
<script type='text/javascript' src='<%=basePath%>dwr/util.js'></script>
<script type='text/javascript' src='<%=basePath%>js/global.js'></script>
<script type='text/javascript' src='<%=basePath%>js/niceform.js'></script>
<script type="text/javascript">
	function checkAndSubmitForm(){
		document.getElementById("protoform").submit();
	}
	function clearAndSubmitForm(){
		document.getElementById("nickNameVO").value = "";
		<c:if test="${userInfo.authority == 0 || userInfo.authority == 1}">
		document.getElementById("authorityVO").value = "";
		</c:if>
		document.getElementById("protoform").submit();
	}
	function checkAll(){
		var boxes = document.getElementsByName("cbox1");
		for(var i=1; i<boxes.length; i++){
			boxes[i].checked = !boxes[i].checked;
		}
	}
	function impartAuthority(authorityLevel){
		var entryIDArray = new Array();
		var boxes = document.getElementsByName("cbox1");
		var length = boxes.length;
		for(var i=1; i<length; i++){
			if(boxes[i].checked){
				var boxid = boxes[i].id;
				entryIDArray[entryIDArray.length] = boxid.substr(8);
			}
		}
		if(entryIDArray.length < 1){
			alert("请先选中要授予权限的用户!");
			return;
		}
		if(confirm("将为选中的"+(entryIDArray.length)+"人授予权限,是否继续？")){
			userManager.impartAuthorityForUsers(authorityLevel, entryIDArray, function(){
				document.getElementById("protoform").submit();
			});
		}
	}
</script>
</head>
<body>
<form action="listUser.action" id="protoform" method="post">
<input id="pageNum" type="hidden" name="page.pageNum" value="${page.pageNum}" />
<input id="hiddenEntryId" type="hidden" name="userInfo.id" />
<fieldset class="fieldsetStyle1" style="width:99%; margin:2px 1px;">
	<legend>查询用户</legend>
	<div id="" class="fieldsetDivStyle1">
		<table>
			<tr>
				<td width="10%" style="text-align:right;"><label for="textinput">昵称:</label></td>
				<td width="12%" style="text-align:left;">
					<img class='inputCorner' src='<%=basePath%>pic/niceform/input_left.gif' /><input type='text' id="nickNameVO" name="userSearchVO.nickNameVO" value="${userSearchVO.nickNameVO}" class='textinput' size='12' style='line-height:15px; width:150px;' /><img class='inputCorner' src='<%=basePath%>pic/niceform/input_right.gif' />
				</td>
				<c:if test="${userInfo.authority == 0 || userInfo.authority == 1}">
				<td width="10%" style="text-align:right;"><label for="textinput">用户权限:</label></td>
				<td width="12%" style="text-align:left;">
					<select size="1" id="authorityVO" name="userSearchVO.authorityVO" class="width_160">
						<option style="background:#e0eeee;" value="" <c:if test="${userSearchVO.authorityVO == null}">selected="selected"</c:if>>&nbsp;&nbsp;全部&nbsp;&nbsp;</option>
						<c:if test="${userInfo.authority == 0}">
							<option style="background:#e0eeee;" value="1" <c:if test="${userSearchVO.authorityVO == 1}">selected="selected"</c:if>>&nbsp;&nbsp;超级管理员&nbsp;&nbsp;</option>
						</c:if>
						<option style="background:#e0eeee;" value="2" <c:if test="${userSearchVO.authorityVO == 2}">selected="selected"</c:if>>&nbsp;&nbsp;管理员&nbsp;&nbsp;</option>
						<option style="background:#e0eeee;" value="3" <c:if test="${userSearchVO.authorityVO == 3}">selected="selected"</c:if>>&nbsp;&nbsp;普通用户&nbsp;&nbsp;</option>
					</select>
				</td>
				</c:if>
				<td style="text-align:left; padding-left:20px;">
					<label id="submitButton01" class="exportLabelStyle1" onmouseover="this.className='exportLabelStyle2'" onmouseout="this.className='exportLabelStyle1'" for="textinput" onclick="checkAndSubmitForm();">查询</label>
					<label class="exportLabelStyle1" onmouseover="this.className='exportLabelStyle2'" onmouseout="this.className='exportLabelStyle1'" for="textinput" onclick="clearAndSubmitForm();">清空</label>
				</td>
			</tr>
		</table>
	</div>
</fieldset>
</form>
<table width="99%" border="0" cellpadding="0" cellspacing="0" class="main">
	<caption>
<div style="float:left;">
	<img src="<%=basePath%>pic/ico1.gif" align="absmiddle" alt=""/>用户列表	
</div>
<div style="float:right;" class="btnStyle1">
	<c:if test="${userInfo.authority == 0}">
		<c:if test="${userSearchVO.authorityVO != 1}">
			<input id="searchCarButton1" type="button" value="授予超级管理员权限" onclick="impartAuthority(1);"/>
		</c:if>
	</c:if>
	<c:if test="${userInfo.authority == 0 || userInfo.authority == 1}">
		<c:if test="${userSearchVO.authorityVO != 2}">
			<input id="searchCarButton1" type="button" value="授予管理员权限" onclick="impartAuthority(2);"/>
		</c:if>
		<c:if test="${userSearchVO.authorityVO != 3}">
			<input id="searchCarButton1" type="button" value="授予普通用户权限" onclick="impartAuthority(3);"/>
		</c:if>
	</c:if>
</div>
</caption>
<tr>
	<th nowrap="nowrap" width="5%"><input name="cbox1" type="checkbox" style="border:none;" onclick="checkAll();"/></th>
	<th nowrap="nowrap" width="11%">&nbsp;编&nbsp;&nbsp;号&nbsp;</th>
	<th nowrap="nowrap" width="17%">&nbsp;用&nbsp;户&nbsp;名&nbsp;</th>
	<th nowrap="nowrap" width="17%">&nbsp;昵&nbsp;&nbsp;称&nbsp;</th>
	<th nowrap="nowrap" width="17%">&nbsp;注&nbsp;册&nbsp;时&nbsp;间&nbsp;</th>
	<th nowrap="nowrap" width="17%">&nbsp;权&nbsp;&nbsp;限&nbsp;</th>
	<th nowrap="nowrap" width="14%">&nbsp;操&nbsp;&nbsp;作&nbsp;</th>
</tr>
<c:forEach var="entry" items="${listUser}" varStatus="index">
<tr onmouseover="this.className='tr_on';" onmouseout="this.className='';">
	<td nowrap="nowrap" class="center"><input id="entryID_${entry.id}" name="cbox1" type="checkbox" style="border:none;"/></td>
	<td nowrap="nowrap" class="center">${page.firstData + index.index}</td>
	<td nowrap="nowrap" class="center"><div style="width:100px; overflow:hidden; text-overflow:ellipsis;" title="${entry.userName}">${entry.userName}</div></td>
	<td nowrap="nowrap" class="center"><div style="width:100px; overflow:hidden; text-overflow:ellipsis;" title="${entry.nickName}">${entry.nickName}</div></td>
	<td nowrap="nowrap" class="center"><div style="width:100px; overflow:hidden; text-overflow:ellipsis;" title="${entry.registerTimeToLocalString}">${entry.registerTimeToLocalString}</div></td>
	<td nowrap="nowrap" class="center"><div style="width:100px; overflow:hidden; text-overflow:ellipsis;" title="${entry.authorityToLocalString}">${entry.authorityToLocalString}</div></td>
	<td nowrap="nowrap" class="btnStyle1">
		<input type="button" value="查看" onclick="submitProtoformWithHiddenValue('hiddenEntryId', '${entry.id}', '<%=basePath%>/viewUser.action')"/>&nbsp;&nbsp;
	</td>
</tr>
</c:forEach>
</table>
<test:page page="${page}"></test:page>
</body>
</html>
<script>
specifyParentNodeCssStyle("listUser");
//for niceform.js
function inputsFocusAndBlur(){
	var inputs = document.getElementsByTagName("input");
	for (var i = 0; i < inputs.length; i++) {
		var inputObj = inputs[i];
		if(inputObj.type == "text"){
			inputObj.onfocus = function(){onInputFocus(this)};
			inputObj.onblur = function(){onInputBlur(this)};
		}
	}
}
inputsFocusAndBlur();
</script>

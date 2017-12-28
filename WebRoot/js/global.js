/**
 * 得到父窗口document元素
 */
function getParent() {
	return window.parent.document;
}

/**
 * 在IFrame中,通过父窗口中元素的id获得其对象实体;
 * 
 * @param parentElementId
 *            父窗口中元素的id
 * @return 父窗口中id为parentElementId的对象实体
 */
function getParentElement(parentElementId) {
	return getParent().getElementById(parentElementId);
}

/**
 * 触发main.jsp页面的事件以实现tip提示时的全屏效果;
 * 
 * @param tipInfoStr
 *            错误的提示信息;
 */
function callParentTip(tipInfoStr, width, height, titleInfo) {
	var obj = getParentElement("invisibleInput");
	obj.value = tipInfoStr;
	if(width!=undefined && width!=null && width!=""){
		getParentElement("invisibleInputWidth").value = width;
	}
	if(height!=undefined && height!=null && height!=""){
		getParentElement("invisibleInputHeight").value = height;
	}
	if(titleInfo!=undefined && titleInfo!=null && titleInfo!=""){
		getParentElement("invisibleInputTitle").value = titleInfo;
	}
	obj.click();
}

/**
 * IFrame中调用,以点击父窗口的左侧菜单按钮
 * 
 * @param nodeName
 *            菜单li元素的id;
 */
function clickParentNode(nodeName) {
	var obj = getParentElement(nodeName);
	if (obj) {
		obj.click();
	}
}

function specifyParentNodeCssStyle(nodeName) {
	// 本页面对应的左侧菜单变为选中色
	var obj = getParentElement(nodeName);
	obj.style.color = "orange";
	// 左侧菜单的其它li全部变为未选中色
	setMenuLiDefaultCssStyle(getParent(), obj);
}

function setMenuLiDefaultCssStyle(containerObj, curObj) {
	var liSets = containerObj.getElementsByTagName("li");
	var liSetsLength = liSets.length;
	for ( var i = 0; i < liSetsLength; i++) {
		if (liSets[i] != curObj) {
			liSets[i].style.color = "#191970";
		}
	}
}

/**
 * 指定表单Action,并提交表单
 */
function submitProtoform(strAction) {
	var theForm = document.getElementById("protoform");
	theForm.action = strAction;
	theForm.submit();
}

/**
 * 为隐藏表单域赋值,并提交表单到指定的Action
 * 
 * @param hiddenInputName
 *            隐藏表单Input的id
 * @param hiddenInputValue
 *            隐藏表单Input的value
 * @param strAction
 *            要提交到的Action
 */
function submitProtoformWithHiddenValue(hiddenInputName, hiddenInputValue,
		strAction) {
	document.getElementById(hiddenInputName).value = hiddenInputValue;
	var theForm = document.getElementById("protoform");
	theForm.action = strAction;
	theForm.submit();
}

/**
 * showModalDialog弹窗
 * 
 * @param url
 *            弹窗窗口要显示的页面
 * @param parameters
 *            传递给弹窗窗口的参数(注意:这里传递的参数是需要用到的数据,而不是弹窗本身的参数)
 * @param width
 *            弹窗窗口的宽度(弹窗本身的参数)
 * @param width
 *            弹窗窗口的高度(弹窗本身的参数)
 */
function openModelDialog(url, parameters, width, height) {
	if (width == null || width == "" || width == undefined) {
		width = window.screen.availWidth;
	}
	if (height == null || height == "" || height == undefined) {
		height = window.screen.availHeight;
	}
	var returnValue = window.showModalDialog(url, parameters, "dialogWidth="
			+ width + "px;dialogHeight=" + height + "px;status=no;");
	return returnValue;
}

// 将时间毫秒值转换为"x年x月x日 HH:mm"的形式
function changeMillisToLocalString(millis) {
	var tmpDate = new Date(parseInt(millis));
	var minuteValue = tmpDate.getMinutes() < 10 ? "0" + tmpDate.getMinutes()
			: tmpDate.getMinutes();
	var returnStr = tmpDate.getYear() + "年" + (tmpDate.getMonth() + 1) + "月"
			+ tmpDate.getDate() + "日 " + tmpDate.getHours() + ":" + minuteValue;
	return returnStr;
}

//得到今天的日期:格式yyyy-MM-dd
function getDateOfToday() {
	var tmpDate = new Date();
	var monthValue = tmpDate.getMonth() + 1;
	monthValue = monthValue < 10 ? "0" + monthValue : monthValue;
	var returnStr = tmpDate.getYear() + "-" + monthValue + "-" + tmpDate.getDate();
	return returnStr;
}

//得到今天的日期:格式yyyyMMdd
function getDateOfTodayInSecStyle() {
	var tmpDate = new Date();
	var monthValue = tmpDate.getMonth() + 1;
	monthValue = monthValue < 10 ? "0" + monthValue : monthValue;
	var dateValue = tmpDate.getDate();
	dateValue = dateValue < 10 ? "0" + dateValue : dateValue
	var returnStr = tmpDate.getYear() + "" + monthValue + "" + dateValue;
	return returnStr;
}

//得到当前的日期+时间:格式yyyy-MM-dd HH:mm
function getTimeOfNow() {
	var tmpDate = new Date();
	var monthValue = tmpDate.getMonth() + 1;
	monthValue = monthValue < 10 ? "0" + monthValue : monthValue;
	var hourValue = tmpDate.getHours() < 10 ? "0" + tmpDate.getHours() : tmpDate.getHours();
	var minuteValue = tmpDate.getMinutes() < 10 ? "0" + tmpDate.getMinutes() : tmpDate.getMinutes();
	var returnStr = tmpDate.getYear() + "-" + monthValue + "-" + tmpDate.getDate() + " " + hourValue + ":" + minuteValue;
	return returnStr;
}

//将格式为"年-月-日"的时间转换为当天开始时刻的毫秒值
function changeLocalStringToStartMillis(dateString) {
	if (dateString != "" && dateString != null && dateString != undefined) {
		var tmpArray = dateString.split("-");
		var tmpDate = new Date();
		tmpDate.setYear(parseInt(tmpArray[0], 10));
		tmpDate.setMonth(parseInt(tmpArray[1] - 1, 10));
		tmpDate.setDate(parseInt(tmpArray[2], 10));
		tmpDate.setHours(0);
		tmpDate.setMinutes(0);
		return tmpDate.getTime();
	}
}

//将格式为"年-月-日"的时间转换为当天结束时刻的日期毫秒值
function changeLocalStringToEndMillis(dateString) {
	if (dateString != "" && dateString != null && dateString != undefined) {
		var tmpArray = dateString.split("-");
		var tmpDate = new Date();
		tmpDate.setYear(parseInt(tmpArray[0], 10));
		tmpDate.setMonth(parseInt(tmpArray[1] - 1, 10));
		tmpDate.setDate(parseInt(tmpArray[2], 10));
		tmpDate.setHours(23);
		tmpDate.setMinutes(59);
		return tmpDate.getTime();
	}
}

function checkNullOfString(theValue) {
	return theValue == null || theValue == undefined;
}

function checkIsNumber(spanObjID) {
	return !isNaN(document.getElementById(spanObjID).innerHTML);
}

function getPosLeftTop(obj1){
	var array = new Array();
	var toppos =0,leftpos=0, left=0, top=0;
	var tar = obj1;
	do{
		tar = tar.offsetParent;
		toppos += tar.offsetTop;
		leftpos += tar.offsetLeft;
	}while(tar.tagName!="BODY")
	left = leftpos + obj1.offsetLeft;
	top = toppos + obj1.offsetTop;
	array[array.length]=left;
	array[array.length]=top;
	return array;
}
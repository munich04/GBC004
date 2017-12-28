/**
 * �õ�������documentԪ��
 */
function getParent() {
	return window.parent.document;
}

/**
 * ��IFrame��,ͨ����������Ԫ�ص�id��������ʵ��;
 * 
 * @param parentElementId
 *            ��������Ԫ�ص�id
 * @return ��������idΪparentElementId�Ķ���ʵ��
 */
function getParentElement(parentElementId) {
	return getParent().getElementById(parentElementId);
}

/**
 * ����main.jspҳ����¼���ʵ��tip��ʾʱ��ȫ��Ч��;
 * 
 * @param tipInfoStr
 *            �������ʾ��Ϣ;
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
 * IFrame�е���,�Ե�������ڵ����˵���ť
 * 
 * @param nodeName
 *            �˵�liԪ�ص�id;
 */
function clickParentNode(nodeName) {
	var obj = getParentElement(nodeName);
	if (obj) {
		obj.click();
	}
}

function specifyParentNodeCssStyle(nodeName) {
	// ��ҳ���Ӧ�����˵���Ϊѡ��ɫ
	var obj = getParentElement(nodeName);
	obj.style.color = "orange";
	// ���˵�������liȫ����Ϊδѡ��ɫ
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
 * ָ����Action,���ύ��
 */
function submitProtoform(strAction) {
	var theForm = document.getElementById("protoform");
	theForm.action = strAction;
	theForm.submit();
}

/**
 * Ϊ���ر���ֵ,���ύ����ָ����Action
 * 
 * @param hiddenInputName
 *            ���ر�Input��id
 * @param hiddenInputValue
 *            ���ر�Input��value
 * @param strAction
 *            Ҫ�ύ����Action
 */
function submitProtoformWithHiddenValue(hiddenInputName, hiddenInputValue,
		strAction) {
	document.getElementById(hiddenInputName).value = hiddenInputValue;
	var theForm = document.getElementById("protoform");
	theForm.action = strAction;
	theForm.submit();
}

/**
 * showModalDialog����
 * 
 * @param url
 *            ��������Ҫ��ʾ��ҳ��
 * @param parameters
 *            ���ݸ��������ڵĲ���(ע��:���ﴫ�ݵĲ�������Ҫ�õ�������,�����ǵ�������Ĳ���)
 * @param width
 *            �������ڵĿ��(��������Ĳ���)
 * @param width
 *            �������ڵĸ߶�(��������Ĳ���)
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

// ��ʱ�����ֵת��Ϊ"x��x��x�� HH:mm"����ʽ
function changeMillisToLocalString(millis) {
	var tmpDate = new Date(parseInt(millis));
	var minuteValue = tmpDate.getMinutes() < 10 ? "0" + tmpDate.getMinutes()
			: tmpDate.getMinutes();
	var returnStr = tmpDate.getYear() + "��" + (tmpDate.getMonth() + 1) + "��"
			+ tmpDate.getDate() + "�� " + tmpDate.getHours() + ":" + minuteValue;
	return returnStr;
}

//�õ����������:��ʽyyyy-MM-dd
function getDateOfToday() {
	var tmpDate = new Date();
	var monthValue = tmpDate.getMonth() + 1;
	monthValue = monthValue < 10 ? "0" + monthValue : monthValue;
	var returnStr = tmpDate.getYear() + "-" + monthValue + "-" + tmpDate.getDate();
	return returnStr;
}

//�õ����������:��ʽyyyyMMdd
function getDateOfTodayInSecStyle() {
	var tmpDate = new Date();
	var monthValue = tmpDate.getMonth() + 1;
	monthValue = monthValue < 10 ? "0" + monthValue : monthValue;
	var dateValue = tmpDate.getDate();
	dateValue = dateValue < 10 ? "0" + dateValue : dateValue
	var returnStr = tmpDate.getYear() + "" + monthValue + "" + dateValue;
	return returnStr;
}

//�õ���ǰ������+ʱ��:��ʽyyyy-MM-dd HH:mm
function getTimeOfNow() {
	var tmpDate = new Date();
	var monthValue = tmpDate.getMonth() + 1;
	monthValue = monthValue < 10 ? "0" + monthValue : monthValue;
	var hourValue = tmpDate.getHours() < 10 ? "0" + tmpDate.getHours() : tmpDate.getHours();
	var minuteValue = tmpDate.getMinutes() < 10 ? "0" + tmpDate.getMinutes() : tmpDate.getMinutes();
	var returnStr = tmpDate.getYear() + "-" + monthValue + "-" + tmpDate.getDate() + " " + hourValue + ":" + minuteValue;
	return returnStr;
}

//����ʽΪ"��-��-��"��ʱ��ת��Ϊ���쿪ʼʱ�̵ĺ���ֵ
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

//����ʽΪ"��-��-��"��ʱ��ת��Ϊ�������ʱ�̵����ں���ֵ
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
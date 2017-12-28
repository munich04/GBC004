var picBasePath = basePath + "pic/niceform/";
function initInputAndTextarea(){
	var textareas = document.body.getElementsByTagName("textarea");
	for(var i=0; i < textareas.length; i++){
		var textareaObj = textareas[i];
		var attrs = textareaObj.attributes;
		textareaObj.parentNode.innerHTML = createTextarea(textareaObj.id, textareaObj.name, textareaObj.value, textareaObj.readOnly);
	}
	var inputs = document.body.getElementsByTagName("input");
	for(var i=0; i < inputs.length; i++){
		var inputObj = inputs[i];
		if(inputObj.getAttribute("type") == "text" || inputObj.getAttribute("type") == "password"){
			inputObj.parentNode.innerHTML = createInput(inputObj.id, inputObj.type, inputObj.name, inputObj.value, inputObj.fname, inputObj.require, inputObj.maxLength, inputObj.readOnly);
		}
	}
}
function createTextarea(id, name, value, readOnly){
	return "<div class='txtarea' style='width:320px;height:120px'><div class='tr'><img class='txt_corner' height='5' src='"+picBasePath+"txtarea_tl.gif' width='5'></div><div class='cntr'><div class='cntr_l' style='height:112px;'></div><textarea onfocus='onTextareaFocus(this)' onblur='onTextareaBlur(this)'  id='"+id+"' name='"+name+"' style='width:300px;height:100px' rows='10' cols='30' "+ (readOnly!=null&&readOnly!=undefined&&readOnly!=""?"readOnly=readOnly":"") +" >"+value+"</textarea></div><div class='br'><img class='txt_corner' height='5' src='"+picBasePath+"txtarea_bl.gif' width='5'></div></div>";
}
function onTextareaFocus(obj){
	var parent = obj.parentNode;
	var preObj = parent.previousSibling;
	var nextObj = parent.nextSibling;
	preObj.className = "tr_xon";
	preObj.firstChild.src= picBasePath + "txtarea_tl_xon.gif";
	parent.className = "cntr_xon";
	parent.firstChild.className = "cntr_l_xon";
	nextObj.className = "br_xon";
	nextObj.firstChild.src= picBasePath + "txtarea_bl_xon.gif";
}
function onTextareaBlur(obj){
	var parent = obj.parentNode;
	var preObj = parent.previousSibling;
	var nextObj = parent.nextSibling;
	preObj.className = "tr";
	parent.className = "cntr";
	parent.firstChild.className = "cntr_l";
	nextObj.className = "br";
}

function createInput(inputId, inputType, inputName, inputValue, inputFname, inputRequire, inputMaxLength, inputReadOnly){
	return "<img class='inputCorner' src='" + picBasePath + "input_left.gif' />" + 
		"<input class='textinput' type='"+ inputType +"' id='" + inputId + "' name='" + inputName + "' value='" + 
		inputValue+ "' size='18'  style='line-height:15px; width:180px;' fname='" + (inputFname!=null&&inputFname!=undefined&&inputFname!=""?inputFname:"") + "'" + 
		" maxLength='"+ (inputMaxLength!=null&&inputMaxLength!=undefined&&inputMaxLength!=""?inputMaxLength:"") +"'"+
		" require='"+ (inputRequire!=null&&inputRequire!=undefined&&inputRequire!=""?inputRequire:"") +"' " + 
		(inputReadOnly!=undefined&&inputReadOnly!=null&&inputReadOnly!=""?" readOnly='readOnly'":"b=b") +
		" onfocus='onInputFocus(this)' onblur='onInputBlur(this)'/>"+
		"<img class='inputCorner' src='" + picBasePath + "input_right.gif' />";
}
function onInputFocus(inputObj){
		inputObj.previousSibling.src = picBasePath + "input_left_xon.gif";
		inputObj.nextSibling.src = picBasePath + "input_right_xon.gif";
		inputObj.className = "textinputHovered";
}
function onInputBlur(inputObj){
		inputObj.previousSibling.src = picBasePath + "input_left.gif";
		inputObj.nextSibling.src = picBasePath + "input_right.gif";
		inputObj.className = "textinput";
}
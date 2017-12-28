/**
 * 错误消息提示Tip的js 务必和css/alarmTip.css一起使用
 */
var tAlarmOut = null;
var tAlarmCount = 0;

//for 拖拽Drag Start
var curX = 0;	//定义当前鼠标横坐标
var curY = 0;	//定义当前鼠标纵坐标
var delatX = 0;	//定义鼠标点击点和目标对象posLeft的距离
var delatY = 0; //定义鼠标点击点和目标对象posTop的距离
function doCursorMove(){	//鼠标移动则更新坐标
	curX = event.x;
	curY = event.y;
}
//for 拖拽Drag End

//开启阴影背景
function createAlarm(){
	var alarmDiv = document.createElement("<div id='alarmDiv' class='alarmDiv'>");
	document.body.appendChild(alarmDiv);
	alarmDiv.style.width = document.body.clientWidth;
	alarmDiv.style.height = document.body.clientHeight;
	alarmDiv.style.filter = "alpha(opacity=60)";
	tAlarmCount = 0;
	changeAlphaOpactiy();
}
//阴影背景渐变色
function changeAlphaOpactiy(){
	/*
	tAlarmCount += 5;
	alarmDiv.style.filter = "alpha(opacity="+tAlarmCount+")";
	tAlarmOut = setTimeout(changeAlphaOpactiy, 1);
	if(tAlarmCount>60){
		clearTimeout(tAlarmOut);
	}
	*/
}
//清除阴影背景
function clearAlarm(){
	if(document.getElementById("alarmDiv")==undefined || document.getElementById("alarmDiv")==null)
		return;
	var alarmDiv = document.getElementById("alarmDiv");
	document.body.removeChild(alarmDiv);
}

var divMoveFromTopToCenterTimeout;
function divMove(objID, endTop){
	document.getElementById(objID).style.posTop += 25;
	divMoveFromTopToCenterTimeout = setTimeout("divMove('"+objID+"', '"+endTop+"')", 1);
	if(parseInt(document.getElementById(objID).style.posTop) > parseInt(endTop)){
		clearTimeout(divMoveFromTopToCenterTimeout);
		divMoveFromTopToCenterTimeout = null;
	}

}
//创建提示信息
function createTipDiv(tipInfoStr, theWidth, theHeight, theTitle){

	createAlarm();//开启阴影背景
	//添加提示信息div
	var thePosLeftValue = (document.body.clientWidth-250)/2;
	if(theWidth!=undefined && theWidth!=null && theWidth!=""){
		thePosLeftValue = (document.body.clientWidth-parseInt(theWidth))/2;
	}
	
	var tipDiv = document.createElement("<div id='tipDiv' class='tipDiv' style='top:0; left:"+thePosLeftValue+"; width:"+ (theWidth!=undefined?theWidth+"px":"") +";'>");
	document.body.appendChild(tipDiv);

	divMove("tipDiv", (document.body.clientHeight-tipDiv.offsetHeight)/2);
	
	var tipTitleDiv = document.createElement("<div id='tipTitleDiv' class='tipTitleDiv'>");
	tipTitleDiv.innerHTML = theTitle==undefined?"提示信息：":theTitle;
	tipDiv.appendChild(tipTitleDiv);
	
	
	var tipElseDiv = document.createElement("<div>");
	var innerStr = "<div id='tipInfoDiv' class='tipInfoDiv'>"+tipInfoStr+"</div>";
	if(theTitle == undefined){
		innerStr += "<div id='tipCloseDiv' class='tipCloseDiv'><span onclick='clearTipDiv();'>确定</span></div>";
	}
	
	tipElseDiv.innerHTML = innerStr;
	tipDiv.appendChild(tipElseDiv);
	tipDiv.focus();
	
	//for 拖拽Drag
	tipDiv.firstChild.onmousedown = function(){
		deltaX = curX - tipDiv.style.posLeft;
		deltaY = curY - tipDiv.style.posTop;
		document.onmousemove = function(){
			tipDiv.style.posLeft = curX - deltaX;
			tipDiv.style.posTop = curY - deltaY;
			tipDiv.firstChild.style.cursor = "move";
		}
		document.onmouseup = function(){
			document.onmousemove = null;
		}
	}
	
}
//清除提示信息
function clearTipDiv(){
	if(document.getElementById("tipDiv")==undefined || document.getElementById("tipDiv")==null)
		return;
	var tipDiv = document.getElementById("tipDiv");
	document.body.removeChild(tipDiv);//清除提示信息
	clearAlarm();//清除阴影背景
}
/**
 * ������Ϣ��ʾTip��js ��غ�css/alarmTip.cssһ��ʹ��
 */
var tAlarmOut = null;
var tAlarmCount = 0;

//for ��קDrag Start
var curX = 0;	//���嵱ǰ��������
var curY = 0;	//���嵱ǰ���������
var delatX = 0;	//������������Ŀ�����posLeft�ľ���
var delatY = 0; //������������Ŀ�����posTop�ľ���
function doCursorMove(){	//����ƶ����������
	curX = event.x;
	curY = event.y;
}
//for ��קDrag End

//������Ӱ����
function createAlarm(){
	var alarmDiv = document.createElement("<div id='alarmDiv' class='alarmDiv'>");
	document.body.appendChild(alarmDiv);
	alarmDiv.style.width = document.body.clientWidth;
	alarmDiv.style.height = document.body.clientHeight;
	alarmDiv.style.filter = "alpha(opacity=60)";
	tAlarmCount = 0;
	changeAlphaOpactiy();
}
//��Ӱ��������ɫ
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
//�����Ӱ����
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
//������ʾ��Ϣ
function createTipDiv(tipInfoStr, theWidth, theHeight, theTitle){

	createAlarm();//������Ӱ����
	//�����ʾ��Ϣdiv
	var thePosLeftValue = (document.body.clientWidth-250)/2;
	if(theWidth!=undefined && theWidth!=null && theWidth!=""){
		thePosLeftValue = (document.body.clientWidth-parseInt(theWidth))/2;
	}
	
	var tipDiv = document.createElement("<div id='tipDiv' class='tipDiv' style='top:0; left:"+thePosLeftValue+"; width:"+ (theWidth!=undefined?theWidth+"px":"") +";'>");
	document.body.appendChild(tipDiv);

	divMove("tipDiv", (document.body.clientHeight-tipDiv.offsetHeight)/2);
	
	var tipTitleDiv = document.createElement("<div id='tipTitleDiv' class='tipTitleDiv'>");
	tipTitleDiv.innerHTML = theTitle==undefined?"��ʾ��Ϣ��":theTitle;
	tipDiv.appendChild(tipTitleDiv);
	
	
	var tipElseDiv = document.createElement("<div>");
	var innerStr = "<div id='tipInfoDiv' class='tipInfoDiv'>"+tipInfoStr+"</div>";
	if(theTitle == undefined){
		innerStr += "<div id='tipCloseDiv' class='tipCloseDiv'><span onclick='clearTipDiv();'>ȷ��</span></div>";
	}
	
	tipElseDiv.innerHTML = innerStr;
	tipDiv.appendChild(tipElseDiv);
	tipDiv.focus();
	
	//for ��קDrag
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
//�����ʾ��Ϣ
function clearTipDiv(){
	if(document.getElementById("tipDiv")==undefined || document.getElementById("tipDiv")==null)
		return;
	var tipDiv = document.getElementById("tipDiv");
	document.body.removeChild(tipDiv);//�����ʾ��Ϣ
	clearAlarm();//�����Ӱ����
}
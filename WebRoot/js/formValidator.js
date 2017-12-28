/**
 * by zengjy 2007.10.25
 * ����֤
 * ������������ �����Զ�Ϊ��ѡ������ʹ�á�
 *    ����֤ require���� - checkNull                                        ��������
 *      <input type="text" name="userInfo.userName" fname="�û���" value="" require>
 *    ��С�ַ�����֤ min���� - checkMin                                      ��������
 *      <input type="text" name="userInfo.userName" fname="�û���" value="" min="6">
 *    ����ַ�����֤ max���� - checkMax                                         ����������
 *      <textarea name="userInfo.description" fname="����" cols="40" rows="10" max="10">
 *    ȷ��ֵ��ȷ�����룩��֤ to���� - checkTo                            ��������������������������
 *      <input type="text" name="repassword" fname="ȷ������" value="" to="userInfo.password">
 *    ������֤ datatype����ֵ��num�� - checkDataType                         ������������������
 *      <input type="text" name="userInfo.userName" fname="�û���" value="" datatype="num">
 *    С����֤ datatype����ֵ��decimal�� - checkDataType                     ����������������������
 *      <input type="text" name="userInfo.userName" fname="�û���" value="" datatype="decimal">
 *    ������֤ datatype����ֵ��cn�� - checkDataType                          ����������������
 *      <input type="text" name="userInfo.userName" fname="�û���" value="" datatype="cn">
 *    Ӣ����֤ datatype����ֵ��en�� - checkDataType                           ����������������
 *       <input type="text" name="userInfo.userName" fname="�û���" value="" datatype="en">
 *    ��ȫ������֤ datatype����ֵ��pwd�� - checkDataType                       ����������������
 *       <input type="text" name="userInfo.userName" fname="�û���" value="" datatype="pwd">
 *    �ļ�������֤ datatype����ֵ��file�� - checkDataType                        ��������������������������������������������������
 *       <input type="file" name="userInfo.media" fname="�û�ý����Ϣ" value="" datatype="file" postfix="doc,text,pdf,log">
 *    ���ڸ�ʽ�� datatype����ֵ��date�� - checkDataType                       ��������������������������������������������������������
 *       <input type="text" name="userInfo.userName" fname="�û���" value="" datatype="date" datevalue="userInfo.createTime">
 *    ���ݵ��ظ�����֤��ajax�� datatype����ֵ�������� -  checkAjaxRepeat        ������������������������
 *       <input type="text" name="userInfo.userName" fname="�û���" value="" ajaxrepeat="UserInfo">
 *       ���� ��update����ʱ���Լ��ϲ�ѯ���� ���б�����entity����д����           ��������������������������������������������������������������������������
 *       <input type="text" name="userInfo.userName" fname="�û���" value="" ajaxrepeat="UserInfo_(entity.entityID<>'${userInfo.entityID}')">
 * ˵����������
 *   1����Ҫ�� form�� onsubmit�¼���ʹ�ñ���֤����ΪĿǰ���еġ������б���ť������ͨ�����ύ�ķ�ʽ����ҳ����ת�ġ�
 *   2������Ҫ���б���֤�İ�ť����� onclick�¼�  onclick="return js.validator.validate(document.all.protoform);"
 *
 *   3��Ŀǰ�Ĵ����������޷�׼ȷ�����ɱ���֤����ش��룬������Ҫ�ֶ���Ӹ� input����֤���ԡ�
 *   4�����ű����ִ������� /doc/1-develop/reference-manual/Validator.chm��
 *      �������ΪĿǰ����֤�������������Բο�����ļ����Ѹ������֤������ӽ�����
 */


String.prototype.getBytesLength = function() {
    var cArr = this.match(/[^\x00-\xff]/ig);
    return this.length + (cArr == null ? 0 : cArr.length);
}

validator =  {
  
  validate : function(p_theForm) {
    try {
     
      var theForm = p_theForm || event.srcElement;

//      this.disabledSubmit(theForm, true);
//      window.setTimeout(this._disabledSubmit(this.disabledSubmit, theForm, false), 1000);

	  var inputChildSets = theForm.getElementsByTagName("input");
      var count = inputChildSets.length;
      for(var i=0; i<count; i++){
        var theInput = inputChildSets[i];
        // ���صĿؼ�������֤
        if(theInput.style.display == "none") continue;
        // ȥ�ո�
        theInput.value = this.trim(theInput.value);
        // У�� ����Ϊ��
        if(!this.checkNull(theInput)) return false;
        // ����ǷǱ����� ������ �յ�
        if(!this.getHasRequire(theInput) && this.isNullString(theInput.value)) {
          if(this.getHasDataType(theInput)
              && (theInput.getAttribute("datatype") == "num" || theInput.getAttribute("datatype") == "decimal" || theInput.getAttribute("datatype") == "decimal10"  )) {
            theInput.value = "0";
          }
          else if(this.getHasDataType(theInput)
              && (theInput.getAttribute("datatype") == "numNot0" )){
              theInput.value = "";
          }
          continue;
        }

        // У�� ��С�ַ���
        if(!this.checkMin(theInput)) return false;

        // У�� ����ַ���
        if(!this.checkMax(theInput)) return false;

        // У�� �ظ�ֵ repeat password
        if(!this.checkTo(theInput)) return false;

        // У�� ��������
        if(!this.checkDataType(theInput)) return false;

        // У�� ���ݵ��ظ��ԣ�ajax��
        if(!this.checkAjaxRepeat(theInput)) return false;
      }

//      this.disabledSubmit(theForm, false);
      return true;
    }
    catch(e){ alert("FormValidator.js - validate() :: " + e.description); return false;}
  },

  /** -- ��ʼ -- У�� ------------------------------------------------------------- **/

  /**
  * У�� ����Ϊ��
  *   ��Ҫ���� require����
  */
  checkNull : function(p_theInput) {
    try {
      if(!this.getHasRequire(p_theInput)) return true;

      if(this.isNullString(p_theInput.value)) {
        alert("����д " + this.getFName(p_theInput) + " !");
        if(p_theInput.getAttribute("readonly")) {
          p_theInput.onclick();
        }
        else {
          p_theInput.focus();
        }
        return false
      }
      return true;
    }
    catch(e){
      //alert("FormValidator.js - checkNull() :: " + e.description);
      return false;
    }
  },

  /**
  * У�� ��С�ַ���
  *   ��Ҫ���� min����
  */
  checkMin : function(p_theInput) {
    try {
      if(!this.getHasMin(p_theInput)) return true;

      with(p_theInput) {
        var minValue = Number(getAttribute("min"));
        var valueLength = value.getBytesLength();
        if(valueLength > 0 && valueLength < minValue) {
          alert(this.getFName(p_theInput) + " ���Ȳ�����Ҫ������" + minValue + "���֣�����" + valueLength + "���֡��벹�䣡");
          this.textSelect(p_theInput, valueLength, valueLength);
          p_theInput.focus();
          return false;
        }
      }
      return true;
    }
    catch(e){
      //alert("FormValidator.js - checkMin() :: " + e.description);
      return false;
    }
  },

  /**
  * У�� ����ַ���
  *   ��Ҫ���� max����
  */
  checkMax : function(p_theInput) {
    try {
      if(!this.getHasMax(p_theInput)) return true;

      with(p_theInput) {
        var maxValue = Number(getAttribute("max"));
        var valueLength = value.getBytesLength();
        if(valueLength > maxValue) {
        /* -- ����ִ������ȱ�עһ��ʱ,�糤�ȳ�����Χ��ȷ���󣬽��Զ���׽�Ķ�������;���Ӷ��������к���ʱ���� --*/
            var step_ = 0;
	        var countCN = 0;//ǰ���������ֽ����ж��ٸ��֣��������ֺ��ַ�
	        var totalDataCount = 0;
	        var countAll = 0;//�����������ж��ٸ��֣��������ֺ��ַ�
			var checkChinese = /^[\u0391-\uFFE5]+$/;
	        do{
	        	checkChinese.test(value.charAt(countCN))?(step_ += 2):(step_ += 1);
	            if(step_<=maxValue){
	            	countCN++;
	            }
	        }while(step_<=maxValue);
	        do{
	          	checkChinese.test(value.charAt(countAll))?(totalDataCount += 2):(totalDataCount += 1);
	            countAll++;
	        }while(totalDataCount!=valueLength);
	      /* -- --*/
          alert(this.getFName(p_theInput) + " ���ݹ��������" + maxValue + "���ֽڣ�����" + countAll + "���֣���" +valueLength+ "�ֽڡ�");
          /*--this.textSelect(p_theInput, maxValue, valueLength);--*/
          this.textSelect(p_theInput, countCN, valueLength);
          p_theInput.focus();
          return false;
        }
      }
      return true;
    }
    catch(e){
      //alert("FormValidator.js - checkMax() :: " + e.description);
      return false;
    }
  },

  /**
  * У�� �ظ�ֵ repeat
  *   ��Ҫ���� to����
  */
  checkTo : function(p_theInput) {
    try {
      if(!this.getHasTo(p_theInput)) return true;

      with(p_theInput) {
        var repeat = document.getElementsByName(getAttribute('to'))[0];
        if(value != repeat.value) {
          alert(this.getFName(p_theInput) + " �� " + this.getFName(repeat) + " ������");
          this.textSelect(p_theInput, value.length, value.length);
          p_theInput.focus();
          return false;
        }
      }
      return true;
    }
    catch(e){
      //alert("FormValidator.js - checkTo() :: " + e.description);
      return false;
    }
  },

  /**
  * У�� ��������
  *   ��Ҫ���� datatype����
  *   CN  || EN   || NUM || PWD
  *   ���� || Ӣ�� || ���� || ��ȫ����
  */
  checkChinese : /^[\u0391-\uFFE5]+$/,
  checkEnglish : /^[A-Za-z]+$/,
  checkNumber : /^\d+$/,
  checkDecimal : /^\-?[0-9]+\.?[0-9]{0,10}$/,
  checkDecimal0 :/^(0|[1-9]\d*)\.?(\d+)$/,
  checkUnSafe : /^(([A-Z]*|[a-z]*|\d*|[-_\~!@#\$%\^&\*\.\(\)\[\]\{\}<>\?\\\/\'\"]*)|.{0,5})$|\s/,
  checkDataType : function(p_theInput) {
  try {
      if(!this.getHasDataType(p_theInput)) return true;

      with(p_theInput) {
        var dataType = getAttribute("datatype");
        var isRight = true;
        if(dataType == "num" && !this.checkNumber.test(value)) {
          alert(this.getFName(p_theInput) + " ֻ����д������"); isRight = false;
        }else if(dataType == "numNot0" && !this.checkNumber.test(value)) {
        	alert(this.getFName(p_theInput) + " ֻ����д������"); isRight = false;
        }else if(dataType == "decimal") {
          if(!this.checkDecimal.test(value)) {
        	  alert(this.getFName(p_theInput) + " ֻ����д���֣�"); isRight = false;
          }
          else {
            var newValue = Math.round(p_theInput.value * 100)/100;
            if(newValue != p_theInput.value) {
              if(confirm(this.getFName(p_theInput) + " ��"+p_theInput.value+"�������������뱣����λС����Ϊ��"+newValue+"������Ҫ������")) {
                p_theInput.value = newValue;
              }
              else {
                isRight = false;
              }
            }
          }
        }else if(dataType == "decimal10") {
          if(!this.checkDecimal0.test(value)) {
            alert(this.getFName(p_theInput) + " ֻ����д���֣�"); isRight = false;
          }else {
            var newValue = Math.round(p_theInput.value * 10000000000)/10000000000;
            if(newValue != p_theInput.value) {
             // if(confirm(this.getFName(p_theInput) + " ��"+p_theInput.value+"�������������뱣��ʮλС����Ϊ��"+newValue+"������Ҫ������")) {
                p_theInput.value = newValue;
              //}
              //else {
             //   isRight = false;
              //}
            }
          }
        }
        else if(dataType == "en" && !this.checkEnglish.test(value)) {
          alert(this.getFName(p_theInput) + " ֻ����дӢ�ģ�"); isRight = false;
        }
        else if(dataType == "cn" && !this.checkChinese.test(value)) {
          alert(this.getFName(p_theInput) + " ֻ����д���ģ�"); isRight = false
        }
        else if(dataType == "pwd" && this.checkUnSafe.test(value)) {
          if(!confirm(this.getFName(p_theInput) + " ����ʹ�� Ӣ����ĸ�����֡����� �Ļ�ϣ�\n\n          ��Ҫ�����ύ��")) {
            isRight = false;
          }
        }
        else if(dataType == "date") {
          var dateValueInput = document.getElementsByName(getAttribute('datevalue'))[0];
          dateValueInput.value = parseDate(value).getTime();
        }
        else if(dataType == "file") {
          var postfixAr = this.getPostfixAr(p_theInput);
          if(postfixAr != null && postfixAr.length) {
            var has = false;
            var theTrim = null;
            for(var i=0; i<postfixAr.length; i++) {
              theTrim = this.trim(postfixAr[i]);
              if(theTrim == "") continue;
              if(value.toLowerCase().indexOf("."+theTrim) >= 0) {
                has = true;
                break;
              }
            }
            if(!has) {
              var message = " �ļ����Ͳ���ȷ�����ϴ��������͵��ļ���\n";
              for(var i=0; i<postfixAr.length; i++) message += " - [ ."+postfixAr[i] + " ]\n";
              alert(this.getFName(p_theInput) + message);
              isRight = false;
            }
          }
        }
        if(!isRight) {
          this.textSelect(p_theInput, 0, p_theInput.value.length);
          p_theInput.focus();
          return false;
        }
        return true;
      }
    }
    catch(e){
      //callParentTip("FormValidator.js - checkDataType() :: " + e.description);
      return false;
    }
  },

  /**
  * У�� ���ݵ��ظ�����֤��ajax��
  */
  checkAjaxRepeat : function(p_theInput) {
    try {
      if(!this.getHasAjaxRepeat(p_theInput)) return true;

      with(p_theInput) {
        var ajaxrepeat = getAttribute("ajaxrepeat");
        var strAjaxrepeat = ajaxrepeat + "";
        var clazzSimpleName = "";
        var conditions;
        if(strAjaxrepeat.indexOf("_") > -1){
	        clazzSimpleName = strAjaxrepeat.substring(0, strAjaxrepeat.indexOf("_"));
	        conditions = strAjaxrepeat.substring(strAjaxrepeat.indexOf("_")+1, strAjaxrepeat.length);
        }else{
        	clazzSimpleName = strAjaxrepeat;
        }
        var fieldName = null;
        if(typeof(p_theInput.field) != "undefined") {
          fieldName = p_theInput.field;
        }
        else {
          fieldName = p_theInput.name;
        }
        var fieldValue = p_theInput.value;
        var reqURL = v_ctx + "/module/volidateRepeatData.do";
        reqURL += "?clazzSimpleName=" + clazzSimpleName;
        reqURL += "&fieldName=" + fieldName;
        reqURL += "&fieldValue=" + fieldValue;
        if(conditions && typeof(conditions) != "undefined") {
          reqURL += "&conditions=" + conditions;
        }
        if( this.ajaxRequest(reqURL) > 0) {
          alert(this.getFName(p_theInput) + "��"+p_theInput.value+"�������ݿ����Ѿ����ڣ��������");
          p_theInput.select();
          p_theInput.focus();
          return false;
        }
      }
      return true;
    }
    catch(e){
      alert("formValidator.js - checkAjaxRepeat() :: " + e.description);
      return false;
    }
  },

  /** -- ���� -- У�� ------------------------------------------------------------- **/


  /** -- ��ʼ -- UTILS ----------------------------------------------------------- **/

  /**
  * �õ�һ�� Input�ؼ��� fname����ֵ
  *   ��� fname���Բ����ڣ��򷵻� name����ֵ
  */
  getFName : function(p_theInput) {
    try {
      var attrFName = p_theInput.getAttribute("fname");
      var attrName = p_theInput.getAttribute("name");
      return attrFName && attrFName != null ? attrFName : (attrName && attrName != null ? attrName : "");
    }
    catch(e){
      //alert("formValidator.js - getFName() :: " + e.description);
      return "";
    }
  },

  /**
  * �õ��Ƿ����ˡ�require�����ԣ��� ������
  */
  getHasRequire : function(p_theInput) {
    try {
      return typeof(p_theInput.require) != "undefined";
    }
    catch(e){
      //alert("formValidator.js - getHasRequire() :: " + e.description);
      return false;
    }
  },

  /**
  * �õ��Ƿ����ˡ�min�����ԣ��� ��С�ַ���
  */
  getHasMin : function(p_theInput) {
    try {
      return typeof(p_theInput.min) != "undefined";
    }
    catch(e){
      //alert("formValidator.js - getHasMin() :: " + e.description);
      return false;
    }
  },

  /**
  * �õ��Ƿ����ˡ�max�����ԣ��� ����ַ���
  */
  getHasMax : function(p_theInput) {
    try {
      return typeof(p_theInput.max) != "undefined";
    }
    catch(e){
      //alert("formValidator.js - getHasMax() :: " + e.description);
      return false;
    }
  },

  /**
  * �õ��Ƿ����ˡ�to�����ԣ��� ֵͬУ��
  */
  getHasTo : function(p_theInput) {
    try {
      return typeof(p_theInput.to) != "undefined";
    }
    catch(e){
      //alert("formValidator.js - getHasTo() :: " + e.description);
      return false;
    }
  },

  /**
  * �õ��Ƿ����ˡ�datatype�����ԣ��� ��������
  */
  getHasDataType : function(p_theInput) {
    try {
      if(typeof(p_theInput.datatype) == "undefined") return false;
      if(p_theInput.datatype == null) return false;
      if(p_theInput.datatype == "cn" || p_theInput.datatype == "en"
        || p_theInput.datatype == "num" || p_theInput.datatype == "numNot0" || p_theInput.datatype == "decimal" || p_theInput.datatype == "decimal10"
        || p_theInput.datatype == "pwd" || p_theInput.datatype == "date" || p_theInput.datatype == "file") return true;
      else return false;
    }
    catch(e){
      //alert("formValidator.js - getHasDataType() :: " + e.description);
      return false;
    }
  },

  /**
   * �õ�����ġ�postfix������ֵ�á�,���и�ɵ�����
   */
  getPostfixAr : function(p_theInput) {
    try {
      if(typeof(p_theInput.postfix) == "undefined") return null;
      var trimString = this.trim(p_theInput.postfix);
      if(trimString == "") return null;
      return trimString.split(",");
    }
    catch(e){
      //alert("formValidator.js - getPostfixAr() :: " + e.description);
      return false;
    }
  },

  /**
  * �õ��Ƿ����ˡ�ajaxrepeat�����ԣ��� ʹ�� ajax���������ظ���֤
  */
  getHasAjaxRepeat : function(p_theInput) {
    try {
      return typeof(p_theInput.ajaxrepeat) != "undefined";
    }
    catch(e){
      //alert("formValidator.js - getHasAjaxRepeat() :: " + e.description);
      return false;
    }
  },

  /**
   * ȥ�� source�ַ���ǰ��ո�
   */
  trim : function (source) {
    if (source.length == 0) {
      return "";
    }
    while (source.length > 0 && source.charAt(0) == ' ') {
      source = source.substring(1, source.length);
    }
    while (source.length > 0 && source.charAt(source.length-1) == ' ') {
      source = source.substring(0, source.length-1);
    }
    return source;
  },

  /**
  * �ж�һ�������ֵ�Ƿ�Ϊ�� ���� �ǳ���Ϊ����ַ���
  */
  isNullString : function(p_varia) {
    try {
      return !p_varia || p_varia == null && p_varia == "";
    }
    catch(e){
      //alert("formValidator.js - isNullString() :: " + e.description);
      return "";
    }
  },

  /**
   * ѡ��һ���ı�
   */
  textSelect : function (p_object, p_startIndex, p_endIndex) {
    var objRange = p_object.createTextRange();
    objRange.moveEnd("character", -p_object.value.getBytesLength());
    objRange.moveStart("character", -p_object.value.getBytesLength());
    objRange.collapse(true);
    objRange.moveStart("character", p_startIndex);
    objRange.moveEnd("character", p_endIndex);
    objRange.select();
  },

  /**
   * �ύ ajax���󣬽��������ظ�����֤ʹ��
   */
  ajaxRequest : function(p_requestURL) {
    try {
      var resultCount = 0;

      var activXObject = null;
      if(window.XMLHttpRequest) {
        activXObject = new XMLHttpRequest();
        if(activXObject.overrideMimeType) {
          activXObject.overrideMimeType("text/xml");
        }
        if(activXObject.readyState == null) {
          activXObject.readyState = 1;
          activXObject.addEventListener("load", function() {
              request.readyState = 4;
              if(typeof request.onreadystatechange == "function")
              request.onreadystatechange();
            }, false);
        }
      }
      else if(window.ActiveXObject) {
        var prefixes = ["MSXML2", "Microsoft", "MSXML", "MSXML3"];
        for (var i = 0; i < prefixes.length; i++) {
          try { activXObject = new ActiveXObject(prefixes[i] + ".XMLHTTP"); break;
          } catch (ex) { continue; };
        }
      }

      var nowTime = new Date();
      var timeTag = nowTime.getYear() + "" + nowTime.getMonth() + "" + nowTime.getDate();
      timeTag = timeTag + "" + nowTime.getHours() + "" + nowTime.getMinutes() + "" + nowTime.getSeconds();

      var requestURL = p_requestURL + "&t=" + timeTag;
      activXObject.open("GET", p_requestURL, false);
      activXObject.onreadystatechange = function() {
        if(activXObject.readyState == 4 && activXObject.status == 200) {
          var xmldoc = activXObject.responseXML;
          var results = xmldoc.getElementsByTagName("result");
          resultCount = Number(results[0].getAttribute("size"));
        }
      };
      activXObject.send(null);

      return resultCount;
    }
    catch(e){
      //alert("formValidator.js - ajaxRequest() :: " + e.description);
      return 0;
    }
  },

  /**
   * ��������֤�Ѿ�ͨ����׼���ύ form��ʱ��
   * Ϊ�����ظ��ύ�����ٰ���λس�����Ҫ�������е� submit�� button
   */
  disabledSubmit : function(p_theForm, v_isDisabled) {
      var inputAr = p_theForm.getElementsByTagName("input");
      if(inputAr && inputAr.length) {
        var inputCount = inputAr.length;
        for(var i=0; i<inputCount; i++) {
          if(inputAr[i].tagName && inputAr[i].tagName == "INPUT"
                  && inputAr[i].type && (inputAr[i].type == "submit" || inputAr[i].type == "button")) {
            inputAr[i].disabled = v_isDisabled;
          }
        }
      }
  },
  _disabledSubmit : function(p_theFunction, p_theForm, v_isDisabled) {
    return function(){p_theFunction(p_theForm, v_isDisabled)};
  },
    /**
   * �ύ ajax����
   * asynchronize �Ƿ��첽����
   * xmlData �Ƿ񷵻�xml����
   */
  ajaxRequestCommon : function(p_requestURL,asynchronize,xmlData) {
	if(asynchronize == undefined)
	   asynchronize = false;
	if(xmlData == undefined){
	   xmlData = false;
	}
    try {
      var resultCount = null;

      var activXObject = null;
      if(window.XMLHttpRequest) {
        activXObject = new XMLHttpRequest();
      }else if(window.ActiveXObject) {
        var prefixes = ["MSXML2", "Microsoft", "MSXML", "MSXML3"];
        for (var i = 0; i < prefixes.length; i++) {
          try { activXObject = new ActiveXObject(prefixes[i] + ".XMLHTTP"); break;
          } catch (ex) { continue; };
        }
      }

      var nowTime = new Date();
      var timeTag = nowTime.getYear() + "" + nowTime.getMonth() + "" + nowTime.getDate();
      timeTag = timeTag + "" + nowTime.getHours() + "" + nowTime.getMinutes() + "" + nowTime.getSeconds();

      var requestURL = p_requestURL + "&t=" + timeTag;
      activXObject.open("GET", p_requestURL, asynchronize);
      activXObject.onreadystatechange = function() {
        if(activXObject.readyState == 4 && activXObject.status == 200) {
	        if(!asynchronize){
		        if(xmlData){
		          resultCount = activXObject.responseXML;
		        }else{
		          resultCount = activXObject.responseText;
		        }
	        }
        }
      };
      activXObject.send(null);

      return resultCount;
    }
    catch(e){
      //alert("formValidator.js - ajaxRequestCommon() :: " + e.description);
      return '';
    }
  }


  /** -- ���� -- UTILS ----------------------------------------------------------- **/
}

/**
 * by zengjy 2007.10.25
 * 表单验证
 * 用例：：：： 各属性都为可选项，可组合使用。
 *    空验证 require属性 - checkNull                                        ↓↓↓↓
 *      <input type="text" name="userInfo.userName" fname="用户名" value="" require>
 *    最小字符数验证 min属性 - checkMin                                      ↓↓↓↓
 *      <input type="text" name="userInfo.userName" fname="用户名" value="" min="6">
 *    最大字符数验证 max属性 - checkMax                                         ↓↓↓↓↓
 *      <textarea name="userInfo.description" fname="描述" cols="40" rows="10" max="10">
 *    确认值（确认密码）验证 to属性 - checkTo                            ↓↓↓↓↓↓↓↓↓↓↓↓↓
 *      <input type="text" name="repassword" fname="确认密码" value="" to="userInfo.password">
 *    整数验证 datatype属性值“num” - checkDataType                         ↓↓↓↓↓↓↓↓↓
 *      <input type="text" name="userInfo.userName" fname="用户名" value="" datatype="num">
 *    小数验证 datatype属性值“decimal” - checkDataType                     ↓↓↓↓↓↓↓↓↓↓↓
 *      <input type="text" name="userInfo.userName" fname="用户名" value="" datatype="decimal">
 *    中文验证 datatype属性值“cn” - checkDataType                          ↓↓↓↓↓↓↓↓
 *      <input type="text" name="userInfo.userName" fname="用户名" value="" datatype="cn">
 *    英文验证 datatype属性值“en” - checkDataType                           ↓↓↓↓↓↓↓↓
 *       <input type="text" name="userInfo.userName" fname="用户名" value="" datatype="en">
 *    安全密码验证 datatype属性值“pwd” - checkDataType                       ↓↓↓↓↓↓↓↓
 *       <input type="text" name="userInfo.userName" fname="用户名" value="" datatype="pwd">
 *    文件类型验证 datatype属性值“file” - checkDataType                        ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
 *       <input type="file" name="userInfo.media" fname="用户媒体信息" value="" datatype="file" postfix="doc,text,pdf,log">
 *    日期格式化 datatype属性值“date” - checkDataType                       ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
 *       <input type="text" name="userInfo.userName" fname="用户名" value="" datatype="date" datevalue="userInfo.createTime">
 *    数据的重复性验证（ajax） datatype属性值“表名” -  checkAjaxRepeat        ↓↓↓↓↓↓↓↓↓↓↓↓
 *       <input type="text" name="userInfo.userName" fname="用户名" value="" ajaxrepeat="UserInfo">
 *       或者 在update数据时可以加上查询条件 其中别名“entity”是写死的           ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
 *       <input type="text" name="userInfo.userName" fname="用户名" value="" ajaxrepeat="UserInfo_(entity.entityID<>'${userInfo.entityID}')">
 * 说明：：：：
 *   1、不要在 form的 onsubmit事件中使用表单验证！因为目前所有的“返回列表”按钮，都是通过表但提交的方式进行页面跳转的。
 *   2、在需要进行表单验证的按钮上添加 onclick事件  onclick="return js.validator.validate(document.all.protoform);"
 *
 *   3、目前的代码生成器无法准确的生成表单验证的相关代码，所以需要手动添加个 input的验证属性。
 *   4、本脚本部分代码来自 /doc/1-develop/reference-manual/Validator.chm，
 *      如果你认为目前的验证不够完整，可以参考这个文件，把更多的验证功能添加近来。
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
        // 隐藏的控件不做验证
        if(theInput.style.display == "none") continue;
        // 去空格
        theInput.value = this.trim(theInput.value);
        // 校验 不能为空
        if(!this.checkNull(theInput)) return false;
        // 如果是非必添项 而且是 空的
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

        // 校验 最小字符数
        if(!this.checkMin(theInput)) return false;

        // 校验 最大字符数
        if(!this.checkMax(theInput)) return false;

        // 校验 重复值 repeat password
        if(!this.checkTo(theInput)) return false;

        // 校验 数据类型
        if(!this.checkDataType(theInput)) return false;

        // 校验 数据的重复性（ajax）
        if(!this.checkAjaxRepeat(theInput)) return false;
      }

//      this.disabledSubmit(theForm, false);
      return true;
    }
    catch(e){ alert("FormValidator.js - validate() :: " + e.description); return false;}
  },

  /** -- 开始 -- 校验 ------------------------------------------------------------- **/

  /**
  * 校验 不能为空
  *   需要定义 require属性
  */
  checkNull : function(p_theInput) {
    try {
      if(!this.getHasRequire(p_theInput)) return true;

      if(this.isNullString(p_theInput.value)) {
        alert("请填写 " + this.getFName(p_theInput) + " !");
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
  * 校验 最小字符数
  *   需要定义 min属性
  */
  checkMin : function(p_theInput) {
    try {
      if(!this.getHasMin(p_theInput)) return true;

      with(p_theInput) {
        var minValue = Number(getAttribute("min"));
        var valueLength = value.getBytesLength();
        if(valueLength > 0 && valueLength < minValue) {
          alert(this.getFName(p_theInput) + " 长度不够！要求最少" + minValue + "个字，现有" + valueLength + "个字。请补充！");
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
  * 校验 最大字符数
  *   需要定义 max属性
  */
  checkMax : function(p_theInput) {
    try {
      if(!this.getHasMax(p_theInput)) return true;

      with(p_theInput) {
        var maxValue = Number(getAttribute("max"));
        var valueLength = value.getBytesLength();
        if(valueLength > maxValue) {
        /* -- 输入执行情况等备注一栏时,如长度超出范围，确定后，将自动捕捉的多余字体;增加对输入中有汉字时处理 --*/
            var step_ = 0;
	        var countCN = 0;//前１２８个字节中有多少个字，包括汉字和字符
	        var totalDataCount = 0;
	        var countAll = 0;//所有输入中有多少个字，包括汉字和字符
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
          alert(this.getFName(p_theInput) + " 内容过长！最大" + maxValue + "个字节，现有" + countAll + "个字，共" +valueLength+ "字节。");
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
  * 校验 重复值 repeat
  *   需要定义 to属性
  */
  checkTo : function(p_theInput) {
    try {
      if(!this.getHasTo(p_theInput)) return true;

      with(p_theInput) {
        var repeat = document.getElementsByName(getAttribute('to'))[0];
        if(value != repeat.value) {
          alert(this.getFName(p_theInput) + " 与 " + this.getFName(repeat) + " 不符！");
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
  * 校验 数据类型
  *   需要定义 datatype属性
  *   CN  || EN   || NUM || PWD
  *   中文 || 英文 || 数字 || 安全密码
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
          alert(this.getFName(p_theInput) + " 只能填写整数！"); isRight = false;
        }else if(dataType == "numNot0" && !this.checkNumber.test(value)) {
        	alert(this.getFName(p_theInput) + " 只能填写整数！"); isRight = false;
        }else if(dataType == "decimal") {
          if(!this.checkDecimal.test(value)) {
        	  alert(this.getFName(p_theInput) + " 只能填写数字！"); isRight = false;
          }
          else {
            var newValue = Math.round(p_theInput.value * 100)/100;
            if(newValue != p_theInput.value) {
              if(confirm(this.getFName(p_theInput) + " “"+p_theInput.value+"”将被四舍五入保留两位小数变为“"+newValue+"”，你要继续吗？")) {
                p_theInput.value = newValue;
              }
              else {
                isRight = false;
              }
            }
          }
        }else if(dataType == "decimal10") {
          if(!this.checkDecimal0.test(value)) {
            alert(this.getFName(p_theInput) + " 只能填写数字！"); isRight = false;
          }else {
            var newValue = Math.round(p_theInput.value * 10000000000)/10000000000;
            if(newValue != p_theInput.value) {
             // if(confirm(this.getFName(p_theInput) + " “"+p_theInput.value+"”将被四舍五入保留十位小数变为“"+newValue+"”，你要继续吗？")) {
                p_theInput.value = newValue;
              //}
              //else {
             //   isRight = false;
              //}
            }
          }
        }
        else if(dataType == "en" && !this.checkEnglish.test(value)) {
          alert(this.getFName(p_theInput) + " 只能填写英文！"); isRight = false;
        }
        else if(dataType == "cn" && !this.checkChinese.test(value)) {
          alert(this.getFName(p_theInput) + " 只能填写中文！"); isRight = false
        }
        else if(dataType == "pwd" && this.checkUnSafe.test(value)) {
          if(!confirm(this.getFName(p_theInput) + " 建议使用 英文字母、数字、符号 的混合！\n\n          您要继续提交吗？")) {
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
              var message = " 文件类型不正确！请上传以下类型的文件：\n";
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
  * 校验 数据的重复性验证（ajax）
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
          alert(this.getFName(p_theInput) + "“"+p_theInput.value+"”在数据库中已经存在，请更换！");
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

  /** -- 结束 -- 校验 ------------------------------------------------------------- **/


  /** -- 开始 -- UTILS ----------------------------------------------------------- **/

  /**
  * 得到一个 Input控件的 fname属性值
  *   如果 fname属性不存在，则返回 name属性值
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
  * 得到是否定义了“require”属性，即 必填项
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
  * 得到是否定义了“min”属性，即 最小字符数
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
  * 得到是否定义了“max”属性，即 最大字符数
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
  * 得到是否定义了“to”属性，即 同值校验
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
  * 得到是否定义了“datatype”属性，即 数据类型
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
   * 得到定义的“postfix”属性值用“,”切割成的数组
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
  * 得到是否定义了“ajaxrepeat”属性，即 使用 ajax进行数据重复验证
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
   * 去除 source字符串前后空格
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
  * 判断一个对象的值是否为空 或者 是长度为零的字符串
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
   * 选中一段文本
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
   * 提交 ajax请求，仅供数据重复性验证使用
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
   * 当所有验证已经通过，准备提交 form的时候
   * 为避免重复提交（快速按多次回车），要禁用所有的 submit和 button
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
   * 提交 ajax请求
   * asynchronize 是否异步请求
   * xmlData 是否返回xml数据
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


  /** -- 结束 -- UTILS ----------------------------------------------------------- **/
}

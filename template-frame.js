﻿window.addEventListener("load", function () {
    // startClick();
    laodJq();
});

var weekday = new Array(7);
weekday[0] = "Sunday";
weekday[1] = "Monday";
weekday[2] = "Tuesday";
weekday[3] = "Wednesday";
weekday[4] = "Thursday";
weekday[5] = "Friday";
weekday[6] = "Saturday";
var clcRestHourArea = [];
// var clcSiteUrl = "http://localhost:52208/";
// var clcSiteUrl = "http://localhost:52319/";
var clcSiteUrl = "https://i.clickatable.co.il/";
// check and load jquery
function laodJq() {
    //if (typeof jQuery == 'undefined') {
    //    var script = document.createElement('script');
    //    script.type = "text/javascript";
    //    script.src = "http://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js";
    //    document.getElementsByTagName('head')[0].appendChild(script);
    //}

    (function () {
        // Load the script
        //if (typeof jQuery == 'undefined') {
        if (!window.jQuery) {
            console.log("a x")
            var script = document.createElement("SCRIPT");
            script.src = 'https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js';
            script.type = 'text/javascript';
            script.onload = function () {
                var $ = window.jQuery;

                // load main function 
                startClick();
                // clcOpenDays = clcGetDays();
                // call datepicker
                // main script // יצא ליצירת שעות סגורות
                //var calScript = document.createElement('script');
                //calScript.type = "text/javascript";
                //calScript.src = "https://code.jquery.com/ui/1.12.1/jquery-ui.js";
                //document.getElementsByTagName('head')[0].appendChild(calScript);
                //calScript.onload = function () {
                //    // שפת לוח שנה // lang script
                //    if (clcLang == "he") {
                //        var calScriptHeb = document.createElement('script');
                //        calScriptHeb.type = "text/javascript";
                //        calScriptHeb.src = clcSiteUrl + "cal-he.js";
                //        document.getElementsByTagName('head')[0].appendChild(calScriptHeb);
                //        calScriptHeb.onload = function () {
                //            startDatePicker();
                //        }
                //    }
                //    else
                //    {
                //        startDatePicker();
                //    }
                //}



            };
            document.getElementsByTagName("head")[0].appendChild(script);
        }
        else {
            console.log("b x")

            window.jQuery(document).ready(function () {
                console.log("c x")
                var $ = window.jQuery;
                startClick();
            });
        }

    })();
}
// end jquery
var clcOpenDays = [] // בגלל שינוי בסדר טעינה
function startDatePicker() {
    // check service for open days and hours
    // var clcOpenDays = [];//["2018-11-21", "2018-11-24", "2018-11-27"]
    // clcOpenDays = clcGetDays(); // הועבר רמה מעל
    // update min date ?
    // if no hourse today - disable today, move next day. rec

    // last date
    var clcToday = new Date();
    var clcLastDate = new Date();
    clcLastDate.setDate(clcToday.getDate() + 60);
    if (clcIsClosedToday)
        clcToday.setDate(+1);
    jQuery("#datepicker").datepicker({
        setDate: clcToday,
        minDate: clcToday,//"11/06/2018"),
        maxDate: clcLastDate,
        // dateFormat: "D dd/mm/yy",
        dateFormat: "dd/mm/yy",
        // block dates
        beforeShowDay: function (date) {
            var clcDOFY = new Date(date);
            var clcDPDate = jQuery.datepicker.formatDate('yy-mm-dd', date);
            var clcIsShowDay = false;

            // check specific day of week
            if (clcOpenDaysOfWeek.indexOf(clcDOFY.getDay()) == -1)
                clcIsShowDay = true;
            // check specific date
            if (clcOpenDays.indexOf(clcDPDate) > -1)
                clcIsShowDay = false;
            //alert(clcDOFY.getDay());

            return [clcIsShowDay];

        },
        onSelect: function (date) {

            // new
            var tmpDate = new Date();
            var clcToday = new Date();
            tmpDate.setFullYear(date.split("/")[2]);
            tmpDate.setMonth(date.split("/")[1] - 1);
            tmpDate.setDate(date.split("/")[0]);
            var clcHMSelect = document.getElementById("Hour");
            for (i = 0; i < clcHours.length; i++) {
                var tmpD = tmpDate.getDay() + 1;
                if (clcHours[i].Day == tmpD) {
                    // בדיקה אם היום

                    var tmpHour = tmpDate.getHours();
                    var tmpMin = tmpDate.getMinutes() / 60;
                    var tmpHourCheck = tmpHour + tmpMin + (rest.MinMinutesFromNowToOrder / 60);
                    // var clcHMSelect = document.getElementById("Hour");

                    for (clcJ = 0; clcJ < clcHMSelect.options.length; clcJ + 1) {
                        clcHMSelect.options[clcJ] = null;
                    }
                    for (j = 0; j < clcHours[i].Minutes.length; j = j + 1) {
                        var tmpMinCheck = Number(clcHours[i].Minutes[j].split(":")[0]) + Number(clcHours[i].Minutes[j].split(":")[1] / 60);
                        if (tmpDate.getDate() == clcToday.getDate()) {
                            if (tmpMinCheck >= tmpHourCheck) {
                                var opt = document.createElement('option');
                                opt.innerHTML = clcHours[i].Minutes[j];
                                clcHMSelect.appendChild(opt);
                            }
                        }
                        else {
                            var opt = document.createElement('option');
                            opt.innerHTML = clcHours[i].Minutes[j];
                            clcHMSelect.appendChild(opt);
                        }
                    }
                }
            }
            // הוספת הודעה בין שעות
            for (i = 0; i < clcHMSelect.length; i++) {
                clcHMSelect
                // פירוק שעות ודקות. 
                // אם יש קפיצת דקות - עדכון 
                if (i > 0 && clcHMSelect.options[i - 1].innerText.indexOf("-") == -1) {
                    var lastMin = parseInt(clcHMSelect.options[i - 1].innerText.split(":")[1]) + (parseInt(clcHMSelect.options[i - 1].innerText.split(":")[0]) * 60);
                    var thisMin = parseInt(clcHMSelect.options[i].innerText.split(":")[1]) + (parseInt(clcHMSelect.options[i].innerText.split(":")[0]) * 60);
                    //if (thisMin == 00)
                    //    thisMin = 60;
                    //if (lastMin == 00)
                    //    lastMin = 60;
                    // console.log(lastMin);
                    if (thisMin - lastMin != 15) {
                        // הוספת אופציה במיקום זה
                        var opt = document.createElement('option');
                        opt.innerHTML = "- הזמנות סגורות " + clcHMSelect.options[i - 1].innerText + " - " + clcHMSelect.options[i].innerText;
                        clcHMSelect.appendChild(opt);
                        opt.setAttribute("disabled", "disabled");
                        // jQuery("#Hour").eq(2).before(jQuery("<option></option>").val("").text("Select"));
                        var clcSelHour = document.getElementById("Hour");
                        clcSelHour.add(opt, i);
                    }
                    //console.log((lastMin - thisMin) + "::" + clcHMSelect.options[i].innerText.split(":")[1]);
                }
            }
            // end new
        }
    });
}
// test cookie
function createCookie(name, value, days) {
    if (days) {
        var date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        var expires = "; expires=" + date.toGMTString();
    }
    else var expires = "";
    document.cookie = name + "=" + value + expires + "; path=/";
}
function readCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') c = c.substring(1, c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
    }
    return null;
}
function eraseCookie(name) {
    createCookie(name, "", -1);
}
// end cookie

function conversiontag() {
    // set header fb / ads code
    if (rest.PixelThankYouHeaderSrc != undefined) {
        var clcJsThxHeaderSrc = document.createElement("script");
        clcJsThxHeaderSrc.setAttribute("type", "text/javascript");
        clcJsThxHeaderSrc.setAttribute("src", rest.PixelOnOpenHeaderSrc);
        document.getElementsByTagName("head")[0].appendChild(clcJsThxHeaderSrc);
    }
    if (rest.PixelThankYouHeader != undefined) {
        var clcJsThxHeader = document.createElement("script");
        clcJsThxHeader.setAttribute("type", "text/javascript");
        clcJsThxHeader.innerHTML = rest.PixelOnOpenHeader;
        document.getElementsByTagName("head")[0].appendChild(clcJsThxHeader);
    }
    // set body start fb / ads code
    if (rest.PixelThankYouBodySrc != undefined) {
        var clcJsThxBodyOpen = document.createElement("script");
        clcJsThxBodyOpen.setAttribute("type", "text/javascript");
        clcJsThxBodyOpen.setAttribute("src", rest.PixelOnOpenBodySrc);
        document.getElementsByTagName("body")[0].appendChild(clcJsThxBodyOpen);
    }
    if (rest.PixelThankYouBody != undefined) {
        var clcJsThxBodyOpen = document.createElement("script");
        clcJsThxBodyOpen.setAttribute("type", "text/javascript");
        clcJsThxBodyOpen.innerHTML = rest.PixelOnOpenBody;
        document.getElementsByTagName("body")[0].appendChild(clcJsThxBodyOpen);
    }
}

formParant = document.getElementById("clcFCont");
//function onloaded() {
//    n = new Date();
//    //getRestDetails();
//    setAreas();
//}
function getRestDetails() {
    var RestaurantID = clcRestId;
    // var url = "http://restorun.info/ClickATableApi/GetRestDetails";
    var url = "https://restorun.info/ClickATableApi/Restaurant";
    var obj = new Object();
    obj.RestaurantID = RestaurantID;

    var jsonString = JSON.stringify(obj);

    var xhr = new XMLHttpRequest();
    xhr.open('POST', url, true);
    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded'); //Set type values to be sended by header
    xhr.setRequestHeader('Access-Control-Allow-Origin', 'https://restorun.info');
    xhr.setRequestHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    xhr.send(jsonString);
    xhr.onreadystatechange = createRestCallback();
}
var restImgs;
var rest;
var clcRestLogo = ""; var clcRestLogoBG = "";

function createRestCallback() {
    return function () {
        if (this.readyState == 4 && (this.status == 200)) {
            var Data = JSON.parse(this.responseText);
            console.log(Data);
            // var rest = Data.Restaurant;
            rest = Data.Restaurant;
            restImgs = Data.ImagesData;
            clcOpenDays = clcGetDays();
            // set header fb / ads code
            // rest imaged defaults
            if (typeof clcTopImg == "undefined") {
                if (restImgs.Logo != "")
                    clcRestLogo = restImgs.Logo;
                else
                    clcRestLogo = clcSiteUrl + "/images/default-logo.png";
            }
            else {
                clcRestLogo = clcTopImg;
            }
            if (typeof clcTopImgBg == "undefined") {
                if (restImgs.Image != "")
                    clcRestLogoBG = restImgs.Image;
                else
                    clcRestLogoBG = clcSiteUrl + "/images/default-top.jpg";
            }
            else
                clcRestLogoBG = clcTopImgBg;

            jQuery("#clcHeader").css("background-image", "url(" + clcRestLogoBG + ")");
            jQuery("#clcRestLogo").attr("src", clcRestLogo);

            if (rest.PixelOnOpenHeaderSrc != undefined) {
                var clcJsHeaderSrc = document.createElement("script");
                clcJsHeaderSrc.setAttribute("type", "text/javascript");
                clcJsHeaderSrc.setAttribute("src", rest.PixelOnOpenHeaderSrc);
                document.getElementsByTagName("head")[0].appendChild(clcJsHeaderSrc);
            }
            if (rest.PixelOnOpenHeader != undefined) {
                var clcJsHeader = document.createElement("script");
                clcJsHeader.setAttribute("type", "text/javascript");
                clcJsHeader.innerHTML = rest.PixelOnOpenHeader;
                document.getElementsByTagName("head")[0].appendChild(clcJsHeader);
            }
            // set body start fb / ads code
            if (rest.PixelOnOpenBodySrc != undefined) {
                var clcJsBodyOpen = document.createElement("script");
                clcJsBodyOpen.setAttribute("type", "text/javascript");
                clcJsBodyOpen.setAttribute("src", rest.PixelOnOpenBodySrc);
                document.getElementsByTagName("body")[0].appendChild(clcJsBodyOpen);
            }
            if (rest.PixelOnOpenBody != undefined) {
                var clcJsBodyOpen = document.createElement("script");
                clcJsBodyOpen.setAttribute("type", "text/javascript");
                clcJsBodyOpen.innerHTML = rest.PixelOnOpenBody;
                document.getElementsByTagName("body")[0].appendChild(clcJsBodyOpen);
            }

            // console.log(rest);
            // alert(rest.Name);
            // alert(rest.City);
            // image defaults
            //clcRestLogo = rest.;
            //clcRestLogoBg = rest.;
            if (clcLang == "en") {
                jQuery("#clcRestName").text(rest.NameEnUS);
                jQuery("#clcRestCity").text(rest.AddressEnUS);
            }
            else {
                jQuery("#clcRestName").text(rest.Name);
                jQuery("#clcRestCity").text(rest.Address);
            }
            // rest.MinPartySize
            addOptsToObj(rest.MinPartySize, rest.MaxPartyPerReservation, 1, document.getElementById("PartySize"));
            if (rest.MinPartySize <= 2)
                jQuery("#PartySize").val("2");

            if (rest.HasSmokingArea == false)
                jQuery("#clcSmoking").addClass("clcHide");
            if (rest.IsRestorunLite == true)
                jQuery("#clcAreaCont").addClass("clcHide");
            // rest remark
            // alert(rest.Notes);
            if (rest.PreliminarRemark != null) {
                document.getElementById("clcBtmRemDin").innerText = rest.PreliminarRemark;
            }
            //document.getElementById("PartySize").options[2].select;

            if (rest.MaxDaysFromNowToOrder != undefined) {
                var cclcLastDate = new Date();
                cclcLastDate.setDate(new Date().getDate() + rest.MaxDaysFromNowToOrder);
                // jQuery("#datepicker").datepicker('option', 'maxDate', cclcLastDate); // נקרא בלי המתנה לתוצאות, דיטפיקר לא מאותחל
            }

            // is rest lite
            // hours for not lite 
            if (!rest.IsRestorunLite) {
                // get restaurant lite hours 
                // setRestOpeningHours();
            }
        }
        else {
            // Error getting Data
        }

    };
}

//
function setRestOpeningHours() {
    // var restorun = document.getElementById('clickFormReg').getAttribute('action').split("/", 5); //Form action value
    // var RestaurantID = restorun[restorun.length - 1];

    var RestaurantID = clcRestId;// "6bcd8f60-1392-45e4-81b0-3ecf3bbbc259";
    var url = "https://restorun.info/ClickATableApi/OpenHours";
    var obj = new Object();
    obj.RestaurantID = RestaurantID;

    var jsonString = JSON.stringify(obj);

    var xhr = new XMLHttpRequest();
    xhr.open('POST', url, true);
    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded'); //Set type values to be sended by header
    xhr.setRequestHeader('Access-Control-Allow-Origin', 'https://restorun.info');
    xhr.setRequestHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    xhr.send(jsonString);
    xhr.onreadystatechange = createHoursCallback();
}
function createHoursCallback() {
    return function () {
        // alert(this.responseText);
        if (this.readyState == 4 && (this.status == 200)) {
            var Data = JSON.parse(this.responseText);

            var OpenHoursList = Data.OpenHoursList;

            // update hours by dates ? 
            // datepicker on date change check date hours and update hours 
            alert(OpenHoursList);
        }
        else
            alert(this.status);
    };
}
//

function setAreas() {
    // var restorun = document.getElementById('clickFormReg').getAttribute('action').split("/", 5); //Form action value
    // var RestaurantID = restorun[restorun.length - 1];
    var RestaurantID = clcRestId;//"6bcd8f60-1392-45e4-81b0-3ecf3bbbc259";

    var url = "https://restorun.info/ClickATableApi/Areas/" + RestaurantID;


    var xhr = new XMLHttpRequest();
    xhr.open('POST', url, true);
    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded'); //Set type values to be sended by header
    xhr.setRequestHeader('Access-Control-Allow-Origin', 'https://restorun.info');
    xhr.setRequestHeader('Access-Control-Allow-Methods', 'POST, PUT, DELETE, OPTIONS');
    xhr.send();
    xhr.onreadystatechange = createAreasCallback();
}
function createAreasCallback() {
    return function () {
        if (this.readyState == 4 && (this.status == 200)) {
            var Data = JSON.parse(this.responseText);

            var areas = Data.AreasList;

            if (areas != "undefined")
                setAreasValue(areas);
        }
    };
}

function setAreasValue(areas) {

    var select = document.getElementById("Area");
    opt = document.createElement("option");
    opt.value = '00000000-0000-0000-0000-000000000000';
    opt.textContent = "לא משנה";
    select.appendChild(opt);

    for (var i = 0; i < areas.length; i++) {
        opt = document.createElement("option");
        opt.value = areas[i].AreaID;
        opt.textContent = areas[i].AreaName;
        select.appendChild(opt);
    }
}

if (typeof clickOptions == "undefined") {
    var clickOptions = [];
}
var emailerror1 = "דוא\"ל - חובה";
var emailerror2 = "ערך דוא\"ל אינו תקין";
var result = false;
var fromOptions = false;

function valid_fname() {
    if (document.getElementById('FirstName').value === '') {
        jQuery("#error_FirstName").removeClass("clcHide");
        jQuery("#FirstName").addClass("clcError");
        jQuery('#FirstName').removeClass("clcOk")
        document.getElementById('FirstName').focus();
        return false;
    } else {
        jQuery("#error_FirstName").addClass("clcHide");
        jQuery("#FirstName").removeClass("clcError");
        jQuery('#FirstName').addClass("clcOk")
        return true;
    }
}

function valid_lastname() {
    if (document.getElementById('LastName').value === '') {
        document.getElementById('LastName').focus();
        jQuery("#error_LastName").removeClass("clcHide");
        jQuery("#LastName").addClass("clcError");
        jQuery("#LastName").removeClass("clcOk");
        return false;
    } else {
        jQuery("#error_LastName").addClass("clcHide");
        jQuery("#LastName").removeClass("clcError");
        jQuery('#LastName').addClass("clcOk")
        return true;
    }
}

function valid_email() {
    var email = document.getElementById('email').value;
    if (email == '') {
        jQuery("#error_Email").removeClass("clcHide");
        jQuery("#email").addClass("clcError");
        jQuery("#email").removeClass("clcOk");
        document.getElementById('email').focus();
        return false;
    } else if (email.indexOf("@") == -1) {
        jQuery("#error_Email").removeClass("clcHide");
        jQuery("#email").addClass("clcError");
        jQuery("#email").removeClass("clcOk");
        document.getElementById('email').focus();
        return false;
    } else if (email.indexOf(".") == -1) {
        jQuery("#error_Email").removeClass("clcHide");
        jQuery("#email").addClass("clcError");
        jQuery("#email").removeClass("clcOk");
        document.getElementById('email').focus();
        return false;
    } else {
        jQuery("#error_Email").addClass("clcHide");
        jQuery("#email").removeClass("clcError");
        jQuery("#email").addClass("clcOk");
        return true;
    }
}
function valid_mobile() {
    if (clcLang == "en") {
        jQuery("#Number").removeClass("clcError");
        jQuery("#Number").addClass("clcOk");
        return true;
    }
    var phoneno = /^\d{7}$/;
    if (document.getElementById('Number').value === '') {
        jQuery("#error_ReqPhoneNumber").removeClass("clcHide");
        jQuery("#error_PhoneArea").removeClass("clcHide");
        jQuery("#Number").addClass("clcError");
        jQuery("#Number").removeClass("clcOk");
        document.getElementById('Number').focus();
        return false;
    }
    else if (!(document.getElementById('Number').value.match(phoneno))) {
        jQuery("#error_PhoneNumber").removeClass("clcHide");
        jQuery("#error_ReqPhoneNumber").addClass("clcHide");
        jQuery("#error_PhoneArea").removeClass("clcHide");
        jQuery("#Number").addClass("clcError");
        jQuery("#Number").removeClass("clcOk");
        document.getElementById('Number').focus();
        return false;
    }
    else {
        jQuery("#error_PhoneNumber").addClass("clcHide");
        jQuery("#error_ReqPhoneNumber").addClass("clcHide");
        jQuery("#error_PhoneArea").addClass("clcHide");
        jQuery("#Number").removeClass("clcError");
        jQuery("#Number").addClass("clcOk");
        return true;
    }
    return false;
}


function valid_date() {
    var tmpRet = true;
    var clcTmpDate = new Date();
    var mClcDate = document.getElementById("datepicker").value.split("/");
    var mClcHour = document.getElementById("Hour").value.split(":");

    if (mClcDate[2] < clcTmpDate.getFullYear()) {
        tmpRet = false;
    }
    else if (mClcDate[2] == clcTmpDate.getFullYear()) {
        // השנה הזו
        // בדיקה אם עבר חודש
        if (mClcDate[1] - 1 < clcTmpDate.getMonth()) {
            tmpRet = false;
        }
        else if (mClcDate[1] - 1 == clcTmpDate.getMonth()) {
            // בדיקה אם אותו החודש אם עבר יום
            if (mClcDate[0] < clcTmpDate.getDate()) {
                tmpRet = false;
            }
        }
    }
    else
        tmpRet = true;
    if (!tmpRet) {
        alert("ניתן להזמין לתאריך עתידי בלבד.");
        return tmpRet;
    }
    else {

        // בדיקת שעה
        if (mClcDate[2] == clcTmpDate.getFullYear() && mClcDate[1] - 1 == clcTmpDate.getMonth() && mClcDate[0] == clcTmpDate.getDate()) {
            var clcHh = mClcHour[0];
            // var clcMin = mClcHour[1];
            if (clcHh <= clcTmpDate.getHours() && mClcHour[1] <= clcTmpDate.getMinutes()) {
                alert("נא לבחור שעה מאוחרת יותר.");
                tmpRet = false;
            }
        }
    }
    return tmpRet;

}
function ValidatorStepA() {
    result = valid_date();
    if (!result) {
        return false;
    }
    else
        return true;
}
var txtErrMsgs = [];

function Validator() {
    var tmpErrMsg = "";
    var tmpRes = true;
    result = valid_fname();
    if (!result) {
        tmpErrMsg += lang[clcLang].fNameMandatory; // "* נא למלא שם פרטי.\n";
        tmpRes = false;
    }
    //if (result)
    result = valid_lastname();
    if (!result) {
        tmpErrMsg += lang[clcLang].lNameMandatory; //"* נא למלא שם משפחה.\n";
        tmpRes = false;
    }
    // if (result)
    result = valid_email();
    if (!result) {
        tmpErrMsg += lang[clcLang].emailMandatory; //"* נא למלא כתובת מייל תקינה.\n";
        tmpRes = false;
    }
    // if (result)
    result = valid_mobile();
    if (!result) {
        tmpErrMsg += lang[clcLang].phoneNumbersOnly; //"* נא למלא מספרים בלבד, ללא קידומת.\n";
        tmpRes = false;
    }
    if (tmpRes) {
        result = Connection();
        // alert("Data Has Been Sent To Server")
        waitingForResult();
    }
    else {
        tmpErrMsg += lang[clcLang].msgFillRedFields; //"* אנא מלאו את השדות המסומנים באדום.\n";

    }

    //if (tmpErrMsg.length > 0)
    //    alert(tmpErrMsg);
    return false;
}

function closeError(id) {
    var obj = document.getElementById(id);
    obj.style.display = "none";
    document.getElementById(id + '_message').innerText = '';

}
function waitingForResult() {
    jQuery("#clcBtnReSubmit").addClass("clcHide");
    jQuery("#clcBtnSub").addClass("clcHide");
    jQuery(".clcLoadingIcn").removeClass("clcHide");
    // הוספת תמונת גיף טעינה
    // הצגת הערה עם אפשרות לחזרה או הצגת אישור
    // CSS לסלולאר
    result = false;
}

var dates = new Array('1|31', '2|28', '3|31', '4|30', '5|31', '6|30', '7|31', '8|31', '9|30', '10|31', '11|30', '12|31');
function setDays(dd, trg) {
    var month = dd.options[dd.selectedIndex].value;
    if (dd.selectedIndex == 0 || dd.selectedIndex == -1)
        return;
    var target = document.getElementById(trg);
    var lastS = target.selectedIndex;
    target.options.length = 0;
    var i;

    for (i = 0; i < dates.length; i++) {
        string = dates[i].split('|');
        if (parseInt(string[0]) == parseInt(month)) {
            target.options[0] = new Option('--', '--');
            for (var j = 1; j <= parseInt(string[1]); j++) {
                target.options[j] = new Option(j, j);
            }
        }
    }
    if (target.options.length >= lastS) {
        target.selectedIndex = lastS;
    } else {
        target.selectedIndex = 0;
    }

}

function Connection() {

    document.getElementById('ErrorMessage').style.display = "none";
    document.getElementById('OutMessage').style.display = "none";

    var area = document.getElementById('Area').value;
    var mClcDate = document.getElementById("datepicker").value.split("/");
    var mClcHour = document.getElementById("Hour").value.split(":");

    var clcSelYear = mClcDate[2];
    var clcSelMonth = mClcDate[1];
    var clcSelDay = mClcDate[0];

    var clcHh = mClcHour[0];
    var clcMin = mClcHour[1];

    var clcSelectedBtndate = new Date(
        clcSelYear,
        clcSelMonth - 1,
        clcSelDay,
        clcHh,
        clcMin
    );

    makeReservation(area, clcSelectedBtndate);
}

function sendOptionFunction() {

    document.getElementById('OutMessage').innerText = "";

    var radios = document.getElementsByName('choice');

    for (var i = 0, length = radios.length; i < length; i++) {
        if (radios[i].checked == true) {

            var area = clickOptions[i].areaIDField;
            var selecteddate = clickOptions[i].dateTimeField;

            document.getElementById('Area').value = clickOptions[i].areaIDField;
            document.getElementById('SelectedDateTime').value = clickOptions[i].dateTimeField;


            makeReservation(area, selecteddate);

            document.getElementById('clcBack').style.display = "none";
            document.getElementById('optionsForm').style.display = "none";
            break;
        }
    }
}

function createCallback() {
    return function () {
        // hide loading icon
        jQuery(".clcLoadingIcn").addClass("clcHide");
        jQuery("#clcBtnSub").removeClass("clcHide");

        document.getElementById('ErrorMessage').innerText = "";
        document.getElementById('OutMessage').innerText = "";

        if (this.readyState == 4 && (this.status == 200)) {
            var Data = JSON.parse(this.responseText);

            var reservation = Data.Reservation;
            var Customer = Data.Customer;
            var Restorun = Data.Restorun;

            var clcOutMsgHead = "";

            if (Data.Status.StatusCode == 1) {
                fromOptions = false;
                var parts = reservation.DateTime.match(/(\d+)/g);
                var dt = new Date(parts[0], parts[1] - 1, parts[2], parts[3], parts[4]); // months are 0-based
                var datestring = dt.getDate() + "-" + (dt.getMonth() + 1) + "-" + dt.getFullYear() + " " + dt.getHours() + ":" + (dt.getMinutes() < 10 ? '0' : '') + dt.getMinutes();
                clcOutMsgHead = lang[clcLang].orderSuccess + " - ";// "ההזמנה בוצעה בהצלחה - ";
                // outMessage = "הזמנה בוצעה בהצלחה - ";
                // outMessage += Data.Status.StatusDescription + "\n";
                outMessage = Data.Status.StatusDescription + "\n";
                outMessage += "<br/><strong>" + lang[clcLang].orderDate + ": </strong>" + datestring + "\n"; //תאריך ההזמנה
                outMessage += "<br/><strong>" + lang[clcLang].orderArea + ": </strong>" + reservation.Area.areaNameField + "\n"; //אזור במסעדה
                outMessage += "<br/><strong>" + lang[clcLang].orderName + ": </strong>" + Customer.FirstName + " " + Customer.LastName + "\n"; //הזמנה על שם
                outMessage += "<br/><strong>" + lang[clcLang].orderCount + ": </strong>" + reservation.PartySize + "\n"; //כמות הסועדים
                outMessage += "<br/><strong>" + lang[clcLang].restaurantEt + " </strong>" + Restorun.Name + "\n"; //מסעדת
                outMessage += "<br/><strong>" + lang[clcLang].address + ": </strong>" + Restorun.Address + " " + Restorun.City + "\n"; //כתובת
                outMessage += "<br/><strong>" + lang[clcLang].restaurantPhone + ": </strong>" + Restorun.Phone; //טלפון במסעדה
                //console.log(Restorun);
                //console.log(reservation);
                //console.log(Customer);
                //if (reservation.IsTimeLimited) {
                //    var clcResLimit = Date(reservation.TimeLimit); // reservation.TimeLimit;
                //    // לפרסר
                //    // alert(reservation.TimeLimit.getHours());
                //    // outMessage += "<br/><strong>" + lang[clcLang].restaurantTimeForOrder + ": </strong>" + clcResLimit.getHours() + ":" + clcResLimit.getMinutes(); //זמן במסעדה
                //}
                if (Restorun.IsTimeLimited) {
                    outMessage += "<br/><strong>" + lang[clcLang].restaurantTimeForOrder + ": </strong>" + Restorun.TimeLimit; //זמן במסעדה
                }
                jQuery("#stepd").addClass("clcHide");

                document.getElementById('optionsForm').style.display = "none";
                conversiontag();
                //gtag('event', 'conversion', { 'send_to': 'AW-1012410180/7g34CIerp4sBEMTO4OID' });
            }
            else if (Data.Status.StatusCode == 2) {
                fromOptions = false;
                var parts = reservation.DateTime.match(/(\d+)/g);
                var dt = new Date(parts[0], parts[1] - 1, parts[2], parts[3], parts[4]); // months are 0-based
                var datestring = dt.getDate() + "-" + (dt.getMonth() + 1) + "-" + dt.getFullYear() + " " + dt.getHours() + ":" + (dt.getMinutes() < 10 ? '0' : '') + dt.getMinutes();
                clcOutMsgHead = lang[clcLang].msgNotYetApproved; // "בקשתך להזמנת מקום התקבלה בהצלחה אך טרם אושרה.";
                outMessage = Data.Status.StatusDescription + "\n";
                outMessage += "<br/><strong>" + lang[clcLang].requestDateRequest + ": </strong>" + datestring + "\n"; // תאריך הבקשה
                outMessage += "<br/><strong>" + lang[clcLang].orderArea + ": </strong>" + reservation.Area.areaNameField + "\n"; // אזור במסעדה
                outMessage += "<br/><strong>" + lang[clcLang].orderName + ": </strong>" + Customer.FirstName + " " + Customer.LastName + "\n"; // בקשה על שם
                outMessage += "<br/><strong>" + lang[clcLang].orderCount + ": </strong>" + reservation.PartySize + "\n"; // כמות הסועדים
                outMessage += "<br/><strong>" + lang[clcLang].restaurantEt + " </strong>" + Restorun.Name + "\n"; // מסעדת
                outMessage += "<br/><strong>" + lang[clcLang].address + ": </strong>" + Restorun.Address + " " + Restorun.City + "\n"; // כתובת
                outMessage += "<br/><strong>" + lang[clcLang].restaurantPhone + ": </strong>" + Restorun.Phone; // טלפון במסעדה
                if (Restorun.IsTimeLimited) {
                    outMessage += "<br/><strong>" + lang[clcLang].restaurantTimeForOrder + ": </strong>" + Restorun.TimeLimit; //זמן במסעדה
                }

                document.getElementById('optionsForm').style.display = "none";
                jQuery("#stepd").addClass("clcHide");

                jQuery("#clcBack").addClass("clcHide");
                conversiontag();
                //gtag('event', 'conversion', { 'send_to': 'AW-1012410180/7g34CIerp4sBEMTO4OID' });
            }
            else if (Data.Status.StatusCode == 3) {
                // לא נמצא מקום - הצעת מקומות חדשים
                jQuery("#optionsForm").removeClass("clcHide");
                jQuery("#clcBack").addClass("clcHide");

                // fromOptions = true;
                clickOptions = [];
                outMessage = Data.Status.StatusDescription;
                // var label = document.createElement('label');
                var options = Data.Options;

                // כותרות, שורות
                // var clcNewTimesHead = document.createElement("div");
                // clcNewTimesHead.innerText = "באפשרותך לבחור שעה אחרת"
                var clcRowNewTimesCont = document.createElement("div");
                var clcRowNewAreaHead = document.createElement("div");
                clcRowNewAreaHead.innerText = "בחירת אזור";
                var clcRowNewAreaCont = document.createElement("div");
                // var clcRowUpdateBtnCont = document.createElement("div");

                var clcNewTimes = document.createElement("div");
                var clcNewAreas = document.createElement("div");
                var clcResHours = []; // האם יכולה לחזור שעה כפולה? 
                var clcResAreas = [];
                var clcStepD = document.createElement("div");

                for (var i = 0; i < options.length; i++) {
                    var parts = options[i].dateTimeField.match(/(\d+)/g);
                    var dt = new Date(parts[0], parts[1] - 1, parts[2], parts[3], parts[4]); // months are 0-based
                    var datestring = dt.getDate() + "-" + (dt.getMonth() + 1) + "-" + dt.getFullYear() + " " + dt.getHours() + ":" + dt.getMinutes();

                    var clcMyHour = dt.getHours() + ":" + (dt.getMinutes() < 10 ? '0' : '') + dt.getMinutes();

                    var clcOpBtn = document.createElement("input");
                    clcOpBtn.setAttribute("type", "button");
                    clcOpBtn.setAttribute("onclick", "javascript:clcSelectAreaByHour(this);");
                    clcOpBtn.value = clcMyHour;//dt.getHours() + ":" + (dt.getMinutes() < 10 ? '0' : '') + dt.getMinutes();// dt.getMinutes();
                    if (!clcResHours.includes(clcMyHour)) {
                        clcResHours.push(clcMyHour);
                        addRegClassId(clcOpBtn, "clcBtnUdHour", "", clcNewTimes);
                    }

                    var clcAreaBtn = document.createElement("input");
                    clcAreaBtn.setAttribute("type", "button");
                    clcAreaBtn.setAttribute("onclick", "javascript:clcSelectAreaAndSubmit(this, '" + options[i].areaField.areaIDField + "');");
                    clcAreaBtn.setAttribute("selVal", options[i].areaField.areaIDField);
                    clcAreaBtn.value = options[i].areaField.areaNameField;

                    // clcRestHourArea.push({ "hour": clcOpBtn.value, "area": options[i].areaField.areaNameField });
                    clcRestHourArea.push({ "hour": clcOpBtn.value, "area": options[i].areaField.areaNameField });

                    if (!clcResAreas.includes(clcAreaBtn.value)) {
                        clcResAreas.push(clcAreaBtn.value);
                        addRegClassId(clcAreaBtn, "clcBtnUDArea", "", clcNewAreas);
                    }

                    addRegClassId(clcNewTimes, "clcRow center clcBtnsCont", "", clcRowNewTimesCont);
                    addRegClassId(clcRowNewAreaHead, "clcRow center clcBtnsCont", "", clcRowNewAreaCont);
                    addRegClassId(clcNewAreas, "clcRow center clcBtnsCont", "", clcRowNewAreaCont);

                    addRegClassId(clcRowNewTimesCont, "clcFrmRow center", "", clcStepD);
                    addRegClassId(clcRowNewAreaCont, "clcFrmRow center", "", clcStepD);
                    //if (i == options.length) {
                    //    // clcOpBtn.click();
                    //    clcSelectAreaByHour(clcOpBtn);
                    //    // clcSelectAreaAndSubmit(clcOpBtn, '" + options[i].areaField.areaIDField + "');
                    //}
                }

                // רישום לקונטיינר
                //document.getElementById("RegistForm").append(clcRowNewTimesCont)
                //document.getElementById("RegistForm").append(clcRowNewAreaCont)

                // הוספת כפתור שמבצע עדכון נתונים לפי הנבחרים, ומבצע את ההזמנה
                var clcRowUpdateBtnCont = document.createElement("div");
                var clcResubmitButton = document.createElement("input");
                clcResubmitButton.setAttribute("type", "button");
                clcResubmitButton.setAttribute("onclick", "clcUpdateAndResubmit()");
                clcResubmitButton.id = "clcBtnReSubmit";
                clcResubmitButton.value = lang[clcLang].updateOrder + " >";// "עדכון הזמנה >";
                addRegClassId(clcResubmitButton, "clcBtnSub", "", clcRowUpdateBtnCont);
                clcRowUpdateBtnCont.className = "clcRow center clcBtnUdCont clcHide";

                // אייקון טעינה
                var clcLoadingIcnB = document.createElement("img");
                clcLoadingIcnB.src = clcSiteUrl + "/images/loading2.gif";
                clcLoadingIcnB.className = "clcLoadingIcn clcHide";
                addRegClassId(clcLoadingIcnB, "", "", clcRowUpdateBtnCont);

                addRegClassId(clcRowUpdateBtnCont, "clcFrmRow center", "", clcStepD);
                // remove old date
                jQuery("#stepd").remove();
                addRegClassId(clcStepD, "", "stepd", RegistForm);
                // document.getElementById("RegistForm").append(clcRowUpdateBtnCont);
                // בחירת אזור ראשון
                if (jQuery(".clcBtnUdHour").length > 0) {
                    jQuery(".clcBtnUdHour")[0].click();
                }
            }

            else if (Data.Status.StatusCode == 0) {
                outMessage = Data.Status.StatusDescription;
                document.getElementById('optionsForm').style.display = "none";
            }

            document.getElementById('ErrorMessage').style.display = "none";


            // document.getElementById('tableform').style.display = "none";

            document.getElementById('OutMessage').innerHTML = "<h2>" + clcOutMsgHead + "</h2><div>" + outMessage + "</div>";
            document.getElementById('OutMessage').style.display = "block";
        }
        else {
            document.getElementById('optionsForm').style.display = "none";

            // document.getElementById('tableform').style.display = "none";
            document.getElementById('ErrorMessage').innerText = "עברת את מכסת ההזמנות";
            document.getElementById('ErrorMessage').style.display = "block";
        }

        document.getElementById('clcBack').innerHTML = "< " + lang[clcLang].backToDate;// "חזור לבחירת תאריך >";
        document.getElementById('clcBack').setAttribute("onclick", "javascript:clcSwitchForm('stepa');");
        document.getElementById('clcBack').style.display = "block";
        clcSwitchForm('stepc');
    };
}
function makeReservation(area, date) {
    var url = "https://restorun.info/ClickATableApi/ClickAPI";
    var obj = new Object();

    // var restorun = document.getElementById('clickFormReg').getAttribute('action').split("/", 5); //Form action value
    // obj.RestaurantID = restorun[restorun.length - 1];
    obj.RestaurantID = clcRestId; // "6bcd8f60-1392-45e4-81b0-3ecf3bbbc259";

    obj.FirstName = document.getElementById('FirstName').value;
    obj.LastName = document.getElementById('LastName').value;
    obj.AreaCode = document.getElementById('AreaCode').value;
    obj.Number = document.getElementById('Number').value;
    obj.Email = document.getElementById('email').value;
    obj.Remark = document.getElementById('Remark').value;
    obj.PartySize = document.getElementById('PartySize').value;
    // obj.SelectedDateTime = new Date(document.getElementById('Year').value, document.getElementById('Month').value, document.getElementById('Day').value, document.getElementById('Hour').value, document.getElementById('Minutes').value);

    obj.SelectedDateTime = date;
    obj.Smoking = document.getElementById('Smoking').value;
    obj.Area = area;
    obj.IsConsentToMarketingInformation = document.getElementById("clcCboxCommer").checked;

    obj.Culture = lang[clcLang].clcCalture;
    var jsonString = JSON.stringify(obj);

    var xhr = new XMLHttpRequest();
    xhr.open('POST', url, true);
    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded'); //Set type values to be sended by header
    xhr.setRequestHeader('Access-Control-Allow-Origin', 'https://restorun.info');
    xhr.setRequestHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    xhr.send(jsonString);

    var outMessage = "";
    xhr.onreadystatechange = createCallback();
}
function backFunction() {
    var xx = document.getElementById('clcBack').innerHTML;
    if (document.getElementById('clcBack').innerHTML == "חזרה") {
        document.getElementById('ErrorMessage').style.display = "none";
        document.getElementById('OutMessage').style.display = "none";
        document.getElementById('clcBack').innerHTML = "קדימה";
        document.getElementById('optionsForm').style.display = "none";
    }
    else {
        if (fromOptions) {
            document.getElementById('optionsForm').style.display = "block";
        }
        document.getElementById('clcBack').innerHTML = "חזור לבחירת תאריך";
        document.getElementById('clcBack').setAttribute("onclick", "javascript:clcSwitchForm('stepa');");

        if (document.getElementById('ErrorMessage').innerText == "עברת את מכסת ההזמנות") {
            document.getElementById('ErrorMessage').style.display = "block";
        }
        else {
            document.getElementById('OutMessage').style.display = "block";
        }
    }
}


// split
function fillTime(clcOpen, clcClose, obj) {
    //for (clcJ = 0; clcJ < obj.options.length; clcJ + 1) {
    //    obj.options[clcJ] = null;
    //}
    // alert("start");
    // alert(clcOpen.getHours());
    var addOnStart = false;
    select = obj;
    if (select.length > 0) {
        addOnStart = true;
    }
    var clcthisHour = new Date();
    var myclcMinHour = "20"// clcthisHour.getHours() + 2;
    minHour = clcOpen.getHours();

    minMinute = clcOpen.getMinutes();
    // איפוס כשמגיע לא בקפיצות של 15
    if (minMinute > 0 && minMinute < 15)
        minMinute = 15;
    if (minMinute > 15 && minMinute < 30)
        minMinute = 30;
    if (minMinute > 30 && minMinute < 45)
        minMinute = 45;
    if (minMinute > 45 && minMinute < 60) {
        minMinute = 00;
        minHour = minHour + 1;
    }

    maxHour = clcClose.getHours();
    maxMinute = clcClose.getMinutes();
    totalHours = (clcClose - clcOpen) / 60 / 60 / 1000;
    // alert(totalHours);
    //for (var i = minHour; i <= maxHour; i++) {
    var ij = 0;
    for (var i = 0; i <= totalHours; i++) {

        var minMin = 0;
        // if (i == minHour) {
        if (i == 0) {
            minMin = minMinute;
        }
        // alert(maxMinute);
        for (var j = minMin; j <= 45; j += 15, ij += 1) {

            var opt = document.createElement('option');
            // opt.value = i;
            if (minHour == maxHour && j > maxMinute) {
                continue;
            }
            if (minHour < 10) {
                if (j < 9) {
                    opt.innerHTML = "0" + minHour + ":0" + j;
                }
                else {
                    opt.innerHTML = "0" + minHour + ":" + j;
                }
            }
            else {
                if (j < 9) {
                    opt.innerHTML = minHour + ":0" + j;
                }
                else {
                    opt.innerHTML = minHour + ":" + j;
                }
            }
            //if (i == myclcMinHour && j == 0)
            //    opt.setAttribute("selected", "selected");
            if (addOnStart) {
                select.add(opt, ij);
            }
            else
                select.appendChild(opt);
        }
        minHour = minHour + 1;
        if (minHour == 24)
            minHour = 0;
    }
}
function addOptsToObj(min, max, jump, obj) {

    select = obj;

    for (var i = min; i <= max; i += jump) {
        var opt = document.createElement('option');
        opt.value = i;
        opt.innerHTML = i;
        select.appendChild(opt);
    }
}
// window.onload = function () {
var clcRest;
function startClick() {
    if (typeof clcLang == "undefined") {
        clcLang = "he";
    }

    // get restaurant details 
    getRestDetails();

    // create elements 
    var myclickFormReg = document.createElement("form");

    // creating page elements containers
    var clcIPutContA = document.createElement("div");
    var clcIPutContB = document.createElement("div");
    var clcIPutContC = document.createElement("div");
    var clcIPutContD = document.createElement("div");

    var clcIPutContCD = document.createElement("div");

    var clcIPutContE = document.createElement("div");
    var clcIPutContF = document.createElement("div");
    var clcIPutContG = document.createElement("div");
    var clcIPutContH = document.createElement("div");
    var clcIPutContI = document.createElement("div");
    var clcIPutContIb = document.createElement("div");
    var clcIPutContJ = document.createElement("div");
    var clcIPutContK = document.createElement("div");
    var clcIPutContL = document.createElement("div");

    var clcRowContLogoLang = document.createElement("div");
    var clcLangCont = document.createElement("div");

    var clcRowContA = document.createElement("div");
    var clcRowContB = document.createElement("div");
    var clcRowContC = document.createElement("div");
    var clcRowContD = document.createElement("div");
    var clcRowContE = document.createElement("div");
    var clcRowContF = document.createElement("div");
    var clcRowContG = document.createElement("div");
    var clcRowContH = document.createElement("div");
    var clcRowContI = document.createElement("div"); // remarks

    var clcReturnCont = document.createElement("div");

    var clcStepA = document.createElement("div");
    var clcStepB = document.createElement("div");
    var clcStepC = document.createElement("div");
    // var clcStepD = document.createElement("div");

    // check if paranat exist
    if (document.getElementById(formParant) != null) {
    }
    else {
        // add element to body;
        var tmpClcFCont = document.createElement("div");
        tmpClcFCont.id = "clcFCont";
        document.body.appendChild(tmpClcFCont);
        formParant = document.getElementById("clcFCont");
    }

    // defaults;

    var clcShowTop = true;
    //var clcRestLogo = ""; var clcRestLogoBG = "";
    //if (typeof clcTopImg == "undefined") {
    //    if (restImgs.Logo != "undefined")
    //        clcRestLogo = restImgs.Logo;
    //    else
    //        clcRestLogo = clcSiteUrl + "/images/default-logo.png";
    //}
    //else {
    //    clcRestLogo = clcTopImg;
    //}
    //if (typeof clcTopImgBg == "undefined") {
    //    if (restImgs.Image != "undefined")
    //        clcRestLogoBG = restImgs.Image;
    //    else
    //        clcRestLogoBG = clcSiteUrl + "/images/default-top.jpg";
    //}
    //else
    //    clcRestLogoBG = clcTopImgBg;
    if (typeof clcShowHeader == "undefined")
        clcShowTop = true;
    else
        clcShowTop = clcShowHeader;
    if (typeof "hideHeader" == "undefined")
        hideHeader = false;
    if (typeof clcStyle == "undefined") {
        // 
        clcStyle = clcSiteUrl + "/clicksheet.css?1=" + Math.random();
    }

    // css
    var head = document.head;
    var link = document.createElement("link");

    link.type = "text/css";
    link.rel = "stylesheet";
    link.href = clcStyle;

    head.appendChild(link);
    // dp css
    var head = document.head;
    var link = document.createElement("link");
    link.type = "text/css";
    link.rel = "stylesheet";
    link.href = "//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css";
    head.appendChild(link);
    // clear all css

    if (typeof clcResetSiteStyle != "undefined" && clcResetSiteStyle == true) {
        var head = document.head;
        var link = document.createElement("link");
        link.type = "text/css";
        link.rel = "stylesheet";
        link.href = clcSiteUrl + "clearStyle.css?1=" + Math.random();
        head.appendChild(link);
    }
    // css end

    // head
    var myclcHead = document.createElement("h2");
    myclcHead.id = "fStepHead";
    myclcHead.innerText = lang[clcLang].headPartA;// "להזמנת שולחן במסעדה מלא את הטופס ונמצא עבורך שולחן מתאים"; // "headPartA":
    if (typeof clcHead != "undefined") {
        myclcHead.innerText = clcHead;
    }

    // head step 2 
    var myclcHeadStepB = document.createElement("h2");
    myclcHeadStepB.innerText = lang[clcLang].headPartB;//"פרטי הלקוח הינם לצורך אישור ההזמנה בלבד."; // 
    myclcHeadStepB.id = "secStepHead"
    if (typeof clcHeadStepB != "undefined") {
        myclcHeadStepB.innerText = clcHeadStepB;
    }

    //   window.addEventListener("load", function() {
    var myFormCont = document.createElement("div");
    myFormCont.className = "container-form";
    var mycustRegister = document.createElement("div");

    // more
    var myback = document.createElement("a");
    myback.setAttribute("href", "#");
    //var myoptionsForm = document.createElement("div");
    //myoptionsForm.id = "optionsForm";
    var myErrorMessage = document.createElement("div");
    var myOutMessage = document.createElement("div");
    myOutMessage.id = "OutMessage";

    // מציגי הודעות - כפתורים
    try {

        //clcReturnCont.appendChild(myoptionsForm);
        addRegClassId(myErrorMessage, "red", "ErrorMessage", clcReturnCont);
        // clcReturnCont.appendChild(myOutMsgHead);
        clcReturnCont.appendChild(myOutMessage);
        addRegClassId(myback, "clcBtnSub", "clcBack", clcReturnCont);
        addRegClassId(clcReturnCont, "clcRetCont", "clcRetCont", clcRowContG);
        addRegClassId(clcRowContG, "clcFrmRow center", "", clcStepC);

    }
    catch (err) {
        alert(err);
    }
    // end




    myclickFormReg.name = "RegistForm";
    myclickFormReg.id = "RegistForm";
    myclickFormReg.setAttribute("onsubmit", "return Validator()");

    var myDateLbl = document.createElement("label");
    myDateLbl.innerText = lang[clcLang].date;
    myDateLbl.id = "lblDate";
    myDateLbl.setAttribute("for", "datePicker");


    var myDate = document.createElement("input");
    myDate.setAttribute("style", "background-image: url(" + clcSiteUrl + "/images/cal.png);background-repeat: no-repeat; background-position: 5% 50%;");
    var clcToday = new Date();

    myDate.setAttribute("placeholder", lang[clcLang].chooseDate);
    myDate.setAttribute("readonly", "readonly");

    myDate.value = clcToday.getDate() + '/' + (clcToday.getMonth() + 1) + '/' + clcToday.getFullYear();//"19/11/2018";

    var myHourlbl = document.createElement("label");
    myHourlbl.innerText = lang[clcLang].hour;
    myHourlbl.setAttribute("for", "Hour");
    myHourlbl.id = "lblHour";
    var myHour = document.createElement("select");

    myHour.setAttribute("name", "Hour");
    myHour.setAttribute("id", "Hour");
    // fillTime(myHour);

    var myMin = document.createElement("select");

    myMin.setAttribute("name", "Minutes");
    myMin.setAttribute("id", "Minutes");
    addOptsToObj(0, 45, 15, myMin);

    var myUserNameLbl = document.createElement("label");
    myUserNameLbl.id = "lblFirstName";
    myUserNameLbl.innerHTML = lang[clcLang].firstName;//  + " <span class='red'>*</span>";
    myUserNameLbl.setAttribute("for", "FirstName");
    var myUserName = document.createElement("input");
    myUserName.setAttribute("name", "FirstName");
    myUserName.setAttribute("id", "FirstName");
    var myErrUserName = document.createElement("span");
    myErrUserName.innerText = lang[clcLang].firstNameMandatory;

    var myUserFNamelbl = document.createElement("label");
    myUserFNamelbl.innerHTML = lang[clcLang].lastName;//  + " <span class='red'>*</span>";
    myUserFNamelbl.setAttribute("for", "LastName");
    myUserFNamelbl.id = "lblLastName";
    var myUserFName = document.createElement("input");
    myUserFName.setAttribute("name", "LastName");
    myUserFName.setAttribute("id", "LastName");
    var myErrLastName = document.createElement("span");
    myErrLastName.innerText = lang[clcLang].lastNameMandatory;

    var myUserEmaillbl = document.createElement("label");
    myUserEmaillbl.innerHTML = lang[clcLang].email;//  + " <span class='red'>*</span>";
    myUserEmaillbl.setAttribute("for", "email");
    myUserEmaillbl.id = "lblEmail";
    var myUserEmail = document.createElement("input");
    myUserEmail.setAttribute("name", "email");
    myUserEmail.setAttribute("id", "email");
    var myErrEmail = document.createElement("span");
    myErrEmail.innerText = lang[clcLang].emailisMandatory;

    var myUserPhonelbl = document.createElement("label");
    myUserPhonelbl.innerHTML = lang[clcLang].cellPhone;//  + " <span class='red'>*</span>";
    myUserPhonelbl.setAttribute("for", "Number");
    myUserPhonelbl.id = "lblNumber";
    var myUserPhone = document.createElement("input");
    myUserPhone.setAttribute("name", "Phone");
    myUserPhone.setAttribute("id", "Number");
    var myErrReqPhone = document.createElement("span");
    myErrReqPhone.innerText = lang[clcLang].cellPhoneMandatory;

    var myErrPhone = document.createElement("span");
    myErrPhone.innerText = lang[clcLang].cellPhoneErrMsg;

    var myRedDotA = document.createElement("span");
    myRedDotA.innerHTML = "*";
    addRegClassId(myRedDotA, "red", "", myUserNameLbl);
    var myRedDotB = document.createElement("span");
    myRedDotB.innerHTML = "*";
    addRegClassId(myRedDotB, "red", "", myUserFNamelbl);
    var myRedDotC = document.createElement("span");
    myRedDotC.innerHTML = "*";
    addRegClassId(myRedDotC, "red", "", myUserEmaillbl);
    if (clcLang == "he") {
        var myRedDotD = document.createElement("span");
        myRedDotD.innerHTML = "*";
        addRegClassId(myRedDotD, "red", "", myUserPhonelbl);
    }
    var myUserPhoneCodelbl = document.createElement("label");
    myUserPhoneCodelbl.innerText = lang[clcLang].areaCode;
    myUserPhoneCodelbl.setAttribute("for", "AreaCode");
    myUserPhoneCodelbl.id = "lblPhoneCode";
    var myUserPhoneCode = document.createElement("select");
    myUserPhoneCode.setAttribute("name", "AreaCode");
    myUserPhoneCode.setAttribute("id", "AreaCode");
    var myErrPhoneArea = document.createElement("span");
    myErrPhoneArea.innerText = ".";

    var optPhone = document.createElement('option');
    optPhone.value = "050";
    optPhone.innerHTML = "050";
    myUserPhoneCode.appendChild(optPhone);
    var optPhoneb = document.createElement('option');
    optPhoneb.value = "052";
    optPhoneb.innerHTML = "052";
    myUserPhoneCode.appendChild(optPhoneb);

    var optPhonec = document.createElement('option');
    optPhonec.value = "053";
    optPhonec.innerHTML = "053";
    myUserPhoneCode.appendChild(optPhonec);

    var optPhoned = document.createElement('option');
    optPhoned.value = "054";
    optPhoned.innerHTML = "054";
    myUserPhoneCode.appendChild(optPhoned);

    var optPhonee = document.createElement('option');
    optPhonee.value = "055";
    optPhonee.innerHTML = "055";
    myUserPhoneCode.appendChild(optPhonee);

    var optPhonef = document.createElement('option');
    optPhonef.value = "056";
    optPhonef.innerHTML = "056";
    myUserPhoneCode.appendChild(optPhonef);

    var optPhoneg = document.createElement('option');
    optPhoneg.value = "057";
    optPhoneg.innerHTML = "057";
    myUserPhoneCode.appendChild(optPhoneg);

    var optPhoneh = document.createElement('option');
    optPhoneh.value = "058";
    optPhoneh.innerHTML = "058";
    myUserPhoneCode.appendChild(optPhoneh);
    var optPhonei = document.createElement('option');
    optPhonei.value = "059";
    optPhonei.innerHTML = "059";
    myUserPhoneCode.appendChild(optPhonei);

    var myUserPartySizelbl = document.createElement("label");
    myUserPartySizelbl.innerText = lang[clcLang].numberDiners;
    myUserPartySizelbl.setAttribute("for", "PartySize");
    myUserPartySizelbl.setAttribute("id", "lblPartySize");
    var myUserPartySize = document.createElement("select");
    myUserPartySize.setAttribute("name", "PartySize");
    myUserPartySize.setAttribute("id", "PartySize");
    // addOptsToObj(2, 12, 1, myUserPartySize);



    var myUserSmokinglbl = document.createElement("label");
    myUserSmokinglbl.innerText = lang[clcLang].smokingArea;
    myUserSmokinglbl.setAttribute("for", "Smoking");
    myUserSmokinglbl.id = "lblSmoking";
    var myUserSmoking = document.createElement("select");
    myUserSmoking.setAttribute("name", "Smoking");
    myUserSmoking.setAttribute("id", "Smoking");

    var optSmokea = document.createElement('option');
    optSmokea.value = "0";
    optSmokea.innerHTML = lang[clcLang].no;
    myUserSmoking.appendChild(optSmokea);
    var optSmokeb = document.createElement('option');
    optSmokeb.value = "1";
    optSmokeb.innerHTML = lang[clcLang].yes;
    myUserSmoking.appendChild(optSmokeb);
    var optSmokec = document.createElement('option');
    optSmokec.value = "2";
    optSmokec.setAttribute("selected", "selected");
    optSmokec.innerHTML = lang[clcLang].neverMind;
    myUserSmoking.appendChild(optSmokec);

    var myUserArealbl = document.createElement("label");
    myUserArealbl.innerText = lang[clcLang].area;
    myUserArealbl.setAttribute("for", "Area");
    myUserArealbl.id = "lblArea";
    var myUserArea = document.createElement("select");
    myUserArea.setAttribute("name", "Area");
    myUserArea.setAttribute("id", "Area")

    var myUserRemarklbl = document.createElement("label");
    myUserRemarklbl.innerText = lang[clcLang].remarks;
    myUserRemarklbl.setAttribute("for", "Remark");
    myUserRemarklbl.id = "lblRemark";
    var myUserRemark = document.createElement("textarea");
    myUserRemark.setAttribute("name", "Remark");
    myUserRemark.setAttribute("id", "Remark")

    // 
    var myUserAllowCommerlbl = document.createElement("label");
    myUserAllowCommerlbl.innerText = lang[clcLang].iWantads;
    myUserAllowCommerlbl.setAttribute("for", "clcCboxCommer");
    myUserAllowCommerlbl.id = "lblCboxCoomer";
    var myUserAllowCommer = document.createElement("input");
    myUserAllowCommer.setAttribute("type", "checkbox");
    myUserAllowCommer.setAttribute("name", "IsConsent");
    myUserAllowCommer.setAttribute("id", "clcCboxCommer")
    //
    // selects containers 
    var clcHourSelCont = document.createElement("div");
    var clcPartySelCont = document.createElement("div");
    var clcSmokSelCont = document.createElement("div");
    var clcAreaSelCont = document.createElement("div");
    var clcAreaCodeSelCont = document.createElement("div");

    clcHourSelCont.setAttribute("class", "select-style");
    clcPartySelCont.setAttribute("class", "select-style");
    clcSmokSelCont.setAttribute("class", "select-style");
    clcAreaSelCont.setAttribute("class", "select-style");
    clcAreaCodeSelCont.setAttribute("class", "select-style");
    // for iphone
    if (clcIsIphone()) { //clcIsIphone()
        // css

        var head = document.head;
        var link = document.createElement("link");

        link.type = "text/css";
        link.rel = "stylesheet";
        link.href = clcSiteUrl + "/iphone.css?1=" + Math.random();

        head.appendChild(link);
        clcHourSelCont.setAttribute("style", "background-image: url('" + clcSiteUrl + "images/down_arrow.png');");
        clcPartySelCont.setAttribute("style", "background-image: url('" + clcSiteUrl + "images/down_arrow.png')");
        clcSmokSelCont.setAttribute("style", "background-image: url('" + clcSiteUrl + "images/down_arrow.png')");
        clcAreaSelCont.setAttribute("style", "background-image: url('" + clcSiteUrl + "images/down_arrow.png')");
        clcAreaCodeSelCont.setAttribute("style", "background-image: url('" + clcSiteUrl + "images/down_arrow.png')");
        // background: #fafafa url("images/down_arrow.png") no-repeat 90% 50%
    }
    clcIPutContA.appendChild(myDateLbl)
    addRegClassId(myDate, "clcDPicker clcIPutWide", "datepicker", clcIPutContA);

    clcIPutContB.appendChild(myHourlbl);
    clcHourSelCont.appendChild(myHour);
    clcIPutContB.appendChild(clcHourSelCont);
    // clcIPutContB.appendChild(myHour);


    // same line !! 
    // {
    clcIPutContC.appendChild(myUserPartySizelbl);
    clcPartySelCont.appendChild(myUserPartySize);
    clcIPutContC.appendChild(clcPartySelCont);

    clcIPutContD.appendChild(myUserSmokinglbl);
    clcSmokSelCont.appendChild(myUserSmoking);
    clcIPutContD.appendChild(clcSmokSelCont);

    // end same line }
    clcIPutContE.appendChild(myUserArealbl);
    clcAreaSelCont.appendChild(myUserArea);
    addRegClassId(clcAreaSelCont, "clcIPutWide select-style", "", clcIPutContE);
    //addRegClassId(myUserArea, "clcIPutWide", "", clcIPutContE);
    // clcIPutContE.appendChild(myUserArea);

    clcIPutContF.appendChild(myUserNameLbl);
    clcIPutContF.appendChild(myUserName);
    addRegClassId(myErrUserName, "redErr clcHide", "error_FirstName", clcIPutContF);

    clcIPutContG.appendChild(myUserFNamelbl);
    clcIPutContG.appendChild(myUserFName);
    addRegClassId(myErrLastName, "redErr clcHide", "error_LastName", clcIPutContG);

    clcIPutContH.appendChild(myUserEmaillbl);
    clcIPutContH.appendChild(myUserEmail);
    addRegClassId(myErrEmail, "redErr clcHide", "error_Email", clcIPutContH);
    clcIPutContI.appendChild(myUserPhonelbl);
    clcIPutContI.appendChild(myUserPhone);
    addRegClassId(myErrReqPhone, "redErr clcHide", "error_ReqPhoneNumber", clcIPutContI);
    addRegClassId(myErrPhone, "redErr clcHide", "error_PhoneNumber", clcIPutContI);

    // myErrPhone
    clcIPutContIb.appendChild(myUserPhoneCodelbl);
    // clcIPutContIb.appendChild(myUserPhoneCode);
    clcAreaCodeSelCont.appendChild(myUserPhoneCode);
    clcIPutContIb.appendChild(clcAreaCodeSelCont);

    addRegClassId(myErrPhoneArea, "redErr clcHide", "error_PhoneArea", clcIPutContIb);


    clcIPutContJ.appendChild(myUserRemarklbl);
    clcIPutContJ.appendChild(myUserRemark);
    clcIPutContK.appendChild(myUserAllowCommer);
    clcIPutContK.appendChild(myUserAllowCommerlbl);

    // build header
    // logo and language bar
    var clcLogo = document.createElement("img");
    clcLogo.setAttribute("src", clcSiteUrl + "/images/clickatable-logo.png");
    clcLogo.setAttribute("alt", lang[clcLang].clickatacle);
    clcLogo.setAttribute("class", "clcLogo");

    var clcHeImg = document.createElement("img");
    clcHeImg.setAttribute("src", clcSiteUrl + "/images/he.png");
    clcHeImg.setAttribute("alt", "החלף שפה לעברית");
    var clcHeBtn = document.createElement("a");
    clcHeBtn.setAttribute("href", "javascript: setLang('he');");
    addRegClassId(clcHeImg, "clcLogo", "", clcHeBtn);

    var clcEnImg = document.createElement("img");
    clcEnImg.setAttribute("src", clcSiteUrl + "/images/en.png");
    clcEnImg.setAttribute("alt", "Change Language to English");
    var clcEnBtn = document.createElement("a");
    clcEnBtn.setAttribute("href", "javascript: setLang('en');");

    addRegClassId(clcEnImg, "clcLogo", "", clcEnBtn);

    addRegClassId(clcLogo, "clcLogo", "", clcRowContLogoLang);
    addRegClassId(clcHeBtn, "clcLangBtn", "", clcLangCont);
    addRegClassId(clcEnBtn, "clcLangBtn", "", clcLangCont);
    addRegClassId(clcLangCont, "clcLogoBtns", "", clcRowContLogoLang);
    addRegClassId(clcRowContLogoLang, "clcTopRowCont", "", myclickFormReg);

    if (clcShowTop) {
        var clcTopLogo = document.createElement("img");
        var clcHeaderImgCont = document.createElement("div");

        // clcTopLogo.src = clcRestLogo
        addRegClassId(clcTopLogo, "clcTopLogo center", "clcRestLogo", clcHeaderImgCont);

        // restaurant name + city? 
        var clcRestName = document.createElement("strong");
        var clcRestCity = document.createElement("p");
        clcRestName.innerText = ""; // שם המסעדה
        // clcRestCity.innerText = "עיר";

        var clcHeaderTextCont = document.createElement("div");
        addRegClassId(clcRestName, "", "clcRestName", clcHeaderTextCont);
        addRegClassId(clcRestCity, "", "clcRestCity", clcHeaderTextCont);

        addRegClassId(clcHeaderImgCont, "clcHeadRow clcHLogoCont", "", clcRowContA);
        addRegClassId(clcHeaderTextCont, "clcHeadRow clcHTxtCont", "", clcRowContA);

        // reg header container
        // clcRowContA.setAttribute("style", "background-image: url(" + clcRestLogoBG + ");");
        addRegClassId(clcRowContA, "center", "clcHeader", myclickFormReg);
    }
    // add elements
    addRegClassId(myclcHead, "clcH center", "", clcRowContC);

    // clcFrmRows
    addRegClassId(clcIPutContA, "clcIPutCont", "", clcRowContC);
    addRegClassId(clcIPutContB, "clcIPutCont", "", clcRowContC);
    // same line
    addRegClassId(clcIPutContC, "clcIPutCont", "clcParty", clcRowContC);
    addRegClassId(clcIPutContD, "clcIPutCont", "clcSmoking", clcRowContC);

    // end same line
    addRegClassId(clcIPutContE, "clcIPutCont", "clcAreaCont", clcRowContC);

    addRegClassId(clcRowContC, "clcFrmRow center", "", clcStepA);


    // כפתור חלק ראשון
    var myUserFClcBtn = document.createElement("input");
    myUserFClcBtn.setAttribute("type", "button");
    myUserFClcBtn.setAttribute("onclick", "checkStepAAndCont()");
    myUserFClcBtn.value = " " + lang[clcLang].findaPlace + " >";

    // myUserFClcBtn
    addRegClassId(myUserFClcBtn, "clcBtnSub", "clcBtnFind", clcRowContD);


    // inner line container for step b lines
    var clcStepBContA = document.createElement("div");
    var clcStepBContB = document.createElement("div");

    // addRegClassId(clcRowContD, "clcFrmRow center", "", myclickFormReg);
    addRegClassId(clcRowContD, "clcFrmRow center", "", clcStepA);
    // הוספת חלק ראשון לטופס
    addRegClassId(clcStepA, "", "stepa", myclickFormReg);

    addRegClassId(myclcHeadStepB, "clcH center", "", clcStepBContA);

    addRegClassId(clcIPutContF, "clcIPutCont", "", clcStepBContA);
    addRegClassId(clcIPutContG, "clcIPutCont", "", clcStepBContA);
    addRegClassId(clcIPutContH, "clcIPutCont", "", clcStepBContA);
    addRegClassId(clcIPutContI, "clcIPutCont clcPhoneCont clcPhone", "", clcStepBContA);
    addRegClassId(clcIPutContIb, "clcIPutCont clcPhoneCont clcPhoneArea", "", clcStepBContA);



    // inputs step b
    addRegClassId(clcStepBContA, "clcRowIPutsCont", "", clcRowContE);
    addRegClassId(clcRowContE, "clcFrmRow center", "", clcStepB); // input line


    // textarea
    addRegClassId(clcIPutContJ, "clcIPutCont", "", clcStepBContB);
    // checkbox
    addRegClassId(clcIPutContK, "clcIPutCont clcOneLine clcCBCont", "", clcStepBContB);

    // inputs step b
    // addRegClassId(clcStepBContB, "clcRowIPutsCont", "", clcRowContF);
    addRegClassId(clcStepBContB, "clcRowIPutsCont", "", clcRowContE);
    addRegClassId(clcRowContF, "clcFrmRow center", "", clcStepB); // remarks line


    //addRegClassId(clcIPutContB, "clcIPutCont", "", clcRowContC);


    var myUserRestID = document.createElement("input");
    myUserRestID.setAttribute("type", "hidden");
    myUserRestID.setAttribute("value", clcRestId);// "6bcd8f60-1392-45e4-81b0-3ecf3bbbc259");
    myUserRestID.setAttribute("name", "RestaurantID");
    myUserRestID.setAttribute("id", "RestaurantID");


    // כפתור הזמנה סופי
    var myUserSubmit = document.createElement("input");
    myUserSubmit.setAttribute("type", "submit");
    myUserSubmit.value = " " + lang[clcLang].orderTable + " >";
    addRegClassId(myUserSubmit, "clcBtnSub", "clcBtnSub", clcIPutContL);
    // loading img
    var clcLoadingIcn = document.createElement("img");
    clcLoadingIcn.src = clcSiteUrl + "/images/loading2.gif";
    addRegClassId(clcLoadingIcn, "clcLoadingIcn clcHide", "", clcIPutContL);
    addRegClassId(clcIPutContL, "clcFrmRow center", "", clcStepB);



    // clcIPutContH.appendChild(myUserSubmit);

    // הוספת חלק שני לטופס
    addRegClassId(clcStepB, "clcHide", "stepb", myclickFormReg);

    // הוספת חלק שלישי - תוצאות - לטופס
    addRegClassId(clcStepC, "clcHide", "stepc", myclickFormReg);

    myclickFormReg.setAttribute("method", "post");



    mycustRegister.appendChild(myclickFormReg);
    myFormCont.appendChild(mycustRegister);

    formParant.appendChild(myFormCont);

    // small form
    var myoptionsForm = document.createElement("form");
    myoptionsForm.id = "optionsForm";
    // myoptionsForm.setAttribute("style", "display: none;");
    myoptionsForm.setAttribute("class", "clcHide");

    var myanswersBox = document.createElement("div");
    myanswersBox.id = "answersBox";
    var mysendBox = document.createElement("div");
    mysendBox.id = "sendBox";

    var mySBSubmit = document.createElement("input");
    mySBSubmit.setAttribute("type", "button");
    mySBSubmit.value = lang[clcLang].doOrder;
    mySBSubmit.setAttribute("onclick", "javascript:sendOptionFunction()");
    mySBSubmit.id = "btnDoOrder";
    mysendBox.appendChild(mySBSubmit);
    myoptionsForm.appendChild(myanswersBox);
    myoptionsForm.appendChild(mysendBox);
    formParant.appendChild(myoptionsForm);

    // back button
    var clcBackBtn = document.createElement("input");
    clcBackBtn.setAttribute("type", "button");
    clcBackBtn.value = "< " + lang[clcLang].backToStart;
    clcBackBtn.setAttribute("onclick", "javascript:clcSwitchForm('stepa');");
    // clcRowContH
    addRegClassId(clcBackBtn, "clcBackBtn", "clcBackBtn", clcRowContH);
    addRegClassId(clcRowContH, "clcRow center clcHide", "clcBackCont", myclickFormReg);

    // clcRowContI
    var bottomeRemark = document.createElement("p");
    // bottomeRemark.id = "";
    var bottomeRemarkDin = document.createElement("p");
    bottomeRemark.innerText = lang[clcLang].markWillDoOurBest;
    addRegClassId(bottomeRemark, "clcBtmRem", "clcBtmRem", clcRowContI);
    addRegClassId(bottomeRemarkDin, "clcBtmRem", "clcBtmRemDin", clcRowContI);
    addRegClassId(clcRowContI, "clcRow center", "clcBtmRemCont", RegistForm);

    // small form end

    // http://restorun.info/ClickATableApi/Restaurant
    // onloaded();
    setAreas();
    setLang(clcLang);
}

function checkStepAAndCont() {
    if (ValidatorStepA())
        clcSwitchForm('stepb');
}
function addRegClassId(obj, newClass, newId, newCont, atBegin) {
    if (newId != "")
        obj.id = newId;
    if (newClass != "")
        obj.className = newClass;
    if (atBegin) {
        newCont.insertBefore(obj, newCont.firstChild)
    }
    else
        newCont.appendChild(obj);
}
function addRegClassIdById(obj, newClass, newId, newCont, atBegin) {
    if (newId != "")
        obj.id = newId;

    if (newClass != "")
        obj.className = newClass;
    if (atBegin) {
        document.getElementById(newCont).insertBefore(obj, newCont.firstChild)
    }
    else
        document.getElementById(newCont).append(obj);


}
function clcSelectAreaByHour(obj) {
    // בדיקה במערך באיזה איזור קיימת השעה הזו
    // clcRestHourArea.push(clcOpBtn.value + ":" + options[i].areaField.areaNameField)
    // obj == selected hour
    //clcRestHourArea.forEach(function (element) {
    //    {
    // hour // areaid
    // alert(element);
    // alert(element.obj);
    // if (element.obj != undefined) { }
    // let
    var tmpAH = [];
    clcRestHourArea.forEach(function (cra) {
        if (cra.hour == obj.value)
            tmpAH.push(cra);
    });
    var sres = tmpAH;//clcRestHourArea.filter(ah => ah.hour == obj.value);
    // הסתרת כל האזורים, והצגת רק מה שברשימה
    // עבור כל כפתור של אזור
    ////if (sres.includes(jQuery(".clcBtnUDArea").value)) {
    ////    //alert(jQuery(".clcBtnUDArea").value);
    ////    alert("hey");
    ////}

    var clcShowButton = false;

    jQuery(".clcBtnUdHour").removeAttr("selected");
    jQuery(".clcBtnUdHour").removeClass("clcSelectedBtn");
    // ניקוי גם אזור נבחר
    jQuery(".clcBtnUDArea").removeAttr("selected");
    jQuery(".clcBtnUDArea").removeClass("clcSelectedBtn");

    $(obj).attr("selected", "selected");
    $(obj).addClass("clcSelectedBtn");
    var iSelHour = 0;
    jQuery(".clcBtnUDArea").each(function () {
        //alert(this.value)
        $(this).removeClass("clcHide");
        var clcTmp = this;
        sres.forEach(function (rh) {
            //alert(rh.area);
            //alert(clcTmp.value);
            if (clcTmp.value == rh.area) {
                clcShowButton = true;
                // alert("equal");
            }

        });
        if (clcShowButton == false)
            $(this).addClass("clcHide");
        else {
            if (iSelHour == 0) {
                $(this).attr("selected", "selected");
                $(this).addClass("clcSelectedBtn");
                iSelHour = iSelHour + 1;
            }
        }
        clcShowButton = false

    });
    //sres.forEach(function (rh) {
    //            alert(rh.area)
    //        });
    //   // }
    // });
    // alert(obj);

}
function clcSelectAreaAndSubmit(obj, objValue) {
    // alert(obj);
    // הוספת סלקטד
    jQuery(".clcBtnUDArea").removeAttr("selected");
    jQuery(".clcBtnUDArea").removeClass("clcSelectedBtn");

    $(obj).attr("selected", "selected");
    $(obj).addClass("clcSelectedBtn");

    // בחירת השעות המתאימות לאזור זה בלבד


    // הוספת כפתור העדכון
    jQuery(".clcBtnUdCont").removeClass("clcHide");


}
// update form with hour / area buttons and resubmit form
function clcUpdateAndResubmit() {
    waitingForResult();
    // הוצאת כפתורים עם selected, עדכון שדות ושליחה. 
    // כפתור הזמן שולחן עם טעינה? 
    // הוצאת ערכים מעודכנים
    var clcMyNewHour = jQuery(".clcBtnUdHour.clcSelectedBtn").val();
    // var clcMyNewArea = jQuery(".clcBtnUDArea.clcSelectedBtn").val();
    // var clcMyNewArea = jQuery(".clcBtnUDArea.clcSelectedBtn").val();
    var clcMyNewArea = jQuery(".clcBtnUDArea.clcSelectedBtn").attr("selVal");

    //alert(clcMyNewArea);
    // clcMyNewHour = clcMyNewHour.replace(":"," : ");
    jQuery("#Hour").val(clcMyNewHour);
    jQuery("#Area").val(clcMyNewArea);
    // alert(clcMyNewHour);
    // ??
    jQuery("#clcBtnSub").submit();

}

function clcSwitchForm(showNext) {
    // alert(showThis);
    var isErr = false;
    switch (showNext) {
        case 'stepb':
            // check validated date
            // check not null

            //var clcUserDate = document.getElementById("datepicker");
            var clcUserDate = document.getElementById("datepicker");
            if (clcUserDate.value == "") {
                // raise date error 
                isErr = true;
                isErrText = lang[clcLang].chooseDate;
                clcUserDate.focus();
                jQuery('#datepicker').addClass("clcError");
                jQuery('#datepicker').removeClass("clcOk")
                alert(isErrText);
                //clcRaisError("datepicker");
                return false;
            }
            else {
                jQuery('#datepicker').removeClass("clcError");
                jQuery('#datepicker').addClass("clcOk");
            }
            // check noly numbers and slash
            // alert(isErr);
            var clcDTTExt = clcUserDate.value;
            var reGoodDate = new RegExp("^((0?[1-9]|1[012])[- /.](0?[1-9]|[12][0-9]|3[01])[- /.](19|20)?[0-9]{2})*$");
            //if (clcDTTExt.match(/(\d+)/g) == false)
            if (clcDTTExt.match(reGoodDate) == false) {
                isErr = true;
                isErrText = lang[clcLang].dateFormatError;
                alert(isErrText);
                clcUserDate.focus();
                jQuery('#datepicker').addClass("clcError");
                jQuery('#datepicker').removeClass("clcError")
                alert(isErrText);
                return false;
            }
            else {
                jQuery('#datepicker').addClass("clcOk")
                jQuery('#datepicker').removeClass("clcError")
            }

            if (rest.MaxDaysFromNowToOrder != undefined) {
                var cclcLastDate = new Date();
                cclcLastDate.setDate(new Date().getDate() + rest.MaxDaysFromNowToOrder);
                jQuery("#datepicker").datepicker('option', 'maxDate', cclcLastDate);
            }
            // check today and next days only

            // שנה .. חודש .. אם החודש - יום. אם חודש הבא .. 

            jQuery('#stepa').addClass("clcHide");
            jQuery('#stepb').removeClass("clcHide");
            jQuery('#clcBackCont').removeClass("clcHide");
            jQuery('#stepd').addClass("clcHide");
            // jQuery("html, body").animate({ scrollTop: $(document).height() }, 1000);
            break;
        case 'stepa':
            jQuery('#stepb').addClass("clcHide");
            jQuery('#stepa').removeClass("clcHide");
            jQuery('#stepc').addClass("clcHide");
            jQuery('#clcBackCont').addClass("clcHide")
            jQuery('#stepd').addClass("clcHide");
            break;
        case 'stepc':
            jQuery('#stepb').addClass("clcHide");
            jQuery('#stepc').removeClass("clcHide");
            // jQuery('#stepd').addClass("clcHide");
            break;
    }

}
// שירותים נפרדים לא טובים - מחייבים המתנה לכל השירותים כדי שהטופס ייטען כמו שצריך.
// דוג' - המתנה לשעות שבהן המסעדה סגורה כדי לעבור ליום הבא. 
function clcGetDays() {
    getRestHours()
    // get closed time 
    getRestClosedHours()
    // return ["2018-12-21", "2018-12-24", "2018-12-27"];
    return [];
}
function getRestClosedHours() {
    var RestaurantID = clcRestId;//"6bcd8f60-1392-45e4-81b0-3ecf3bbbc259";

    var url = "https://restorun.info/ClickATableApi/SpecialDates/" + RestaurantID;

    var xhr = new XMLHttpRequest();
    xhr.open('POST', url, true);
    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded'); //Set type values to be sended by header
    xhr.setRequestHeader('Access-Control-Allow-Origin', 'https://restorun.info');
    xhr.setRequestHeader('Access-Control-Allow-Methods', 'POST, PUT, DELETE, OPTIONS');
    xhr.send();
    xhr.onreadystatechange = createClosedHourCallback();

}
function initDatePicker() {
    var calScript = document.createElement('script');
    calScript.type = "text/javascript";
    calScript.src = "https://code.jquery.com/ui/1.12.1/jquery-ui.js";
    document.getElementsByTagName('head')[0].appendChild(calScript);
    calScript.onload = function () {
        // שפת לוח שנה // lang script
        if (clcLang == "he") {
            var calScriptHeb = document.createElement('script');
            calScriptHeb.id = "clcDpHe";
            calScriptHeb.type = "text/javascript";
            calScriptHeb.src = clcSiteUrl + "cal-he.js";
            document.getElementsByTagName('head')[0].appendChild(calScriptHeb);
            calScriptHeb.onload = function () {
                startDatePicker();
            }
        }
        else {
            startDatePicker();
        }
    }
}
var clcClosedHours = [];
var clcCHData;
function createClosedHourCallback() {
    return function () {

        if (this.readyState == 4 && (this.status == 200)) {
            console.log(this.readyState + ":::" + this.responseText);
            clcCHData = JSON.parse(this.responseText);
            clcClosedHours = clcCHData.SpecialDatesList;
            //for (i = 0; i < clcHours.length; i++) {
            //    var tmpDate = new Date();
            //    var tmpD = tmpDate.getDay() + 1;
            //    if (clcHours[i].Day == tmpD) {
            //        tmpHour = tmpDate.getHours();
            //        tmpMin = tmpDate.getMinutes() / 60;
            //        var tmpHourCheck = tmpHour + tmpMin + (rest.MinMinutesFromNowToOrder / 60);
            //        var clcHMSelect = document.getElementById("Hour");
            //        for (clcJ = 0; clcJ < clcHMSelect.options.length; clcJ + 1) {
            //            obj.options[clcJ] = null;
            //        }
            //        for (j = 0; j < clcHours[i].Minutes.length; j = j + 1) {
            //            var tmpMinCheck = Number(clcHours[i].Minutes[j].split(":")[0]) + Number(clcHours[i].Minutes[j].split(":")[1] / 60);
            //            if (tmpMinCheck >= tmpHourCheck) {
            //                var opt = document.createElement('option');
            //                opt.innerHTML = clcHours[i].Minutes[j];
            //                clcHMSelect.appendChild(opt);
            //            }
            //        }
            //    }
            //}
            // רק כאן לאתחל דייטפיקר? 
            // initDatePicker(); עבר לשעות פתיחה
        }
    }
}

function getRestHours() {
    var RestaurantID = clcRestId;//"6bcd8f60-1392-45e4-81b0-3ecf3bbbc259";

    var url = "https://restorun.info/ClickATableApi/OpenHours/" + RestaurantID;

    var xhr = new XMLHttpRequest();
    xhr.open('POST', url, true);
    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded'); //Set type values to be sended by header
    xhr.setRequestHeader('Access-Control-Allow-Origin', 'https://restorun.info');
    xhr.setRequestHeader('Access-Control-Allow-Methods', 'POST, PUT, DELETE, OPTIONS');
    xhr.send();
    xhr.onreadystatechange = createOpenHourCallback();

}
// openhours array
var clcHours = [];
var clcOpenDaysOfWeek = [1, 2, 3, 4, 5, 6, 7];
var clcIsClosedToday = false;
// טעינת ימים
function createOpenHourCallback() {

    return function () {
        if (this.readyState == 4 && (this.status == 200)) {
            var clcOHData = JSON.parse(this.responseText);
            clcHours = clcOHData.OpenMinsList;
            var clcHMSelect = document.getElementById("Hour");
            console.log(clcHours);
            for (i = 0; i < clcHours.length; i++) {
                var tmpDate = new Date();
                var tmpD = tmpDate.getDay() + 1;
                // הסרת ימים קיימים ממערך ימים לא קיימים
                var iRemove = clcOpenDaysOfWeek.indexOf(clcHours[i].Day - 1);
                if (iRemove > -1) {
                    clcOpenDaysOfWeek.splice(iRemove, 1);
                }
                // סוף הסרת ימים

                if (clcHours[i].Day == tmpD) {
                    tmpHour = tmpDate.getHours();
                    tmpMin = tmpDate.getMinutes() / 60;
                    var tmpHourCheck = tmpHour + tmpMin + (rest.MinMinutesFromNowToOrder / 60);
                    // var clcHMSelect = document.getElementById("Hour");
                    for (clcJ = 0; clcJ < clcHMSelect.options.length; clcJ + 1) {
                        obj.options[clcJ] = null;
                    }
                    for (j = 0; j < clcHours[i].Minutes.length; j = j + 1) {
                        var tmpMinCheck = Number(clcHours[i].Minutes[j].split(":")[0]) + Number(clcHours[i].Minutes[j].split(":")[1] / 60);
                        if (tmpMinCheck >= tmpHourCheck) {
                            var opt = document.createElement('option');
                            opt.innerHTML = clcHours[i].Minutes[j];
                            clcHMSelect.appendChild(opt);
                        }
                    }
                }

                //console.log("X");
                //// הוספת הודעה בין שעות
                //console.log("X");
                //for (j = 0; j < clcHours[i].Minutes.length; j++) {
                //    clcHMSelect
                //    // פירוק שעות ודקות. 
                //    // אם יש קפיצת דקות - עדכון
                //    if (j > 0) {
                //        var lastMin = parseInt(clcHours[i].Minutes[j - 1].innerText.split(":")[1]) + (parseInt(clcHours[i].Minutes[j - 1].innerText.split(":")[0]) * 60);
                //        var thisMin = parseInt(clcHours[i].Minutes[j].innerText.split(":")[1]) + (parseInt(clcHours[i].Minutes[j].innerText.split(":")[0]) * 60);
                //        if (thisMin == 00)
                //            thisMin = 60;
                //        if (lastMin == 00)
                //            lastMin = 60;
                //        // console.log(lastMin);
                //        if (thisMin - lastMin != 15) {
                //            // הוספת אופציה במיקום זה
                //        }
                //        console.log((lastMin - thisMin) + "::" + clcHours[i].Minutes[j].innerText.split(":")[1]);
                //    }
                //}
                //console.log("Y");
            }
            // no hours today, now day only

            if (clcHMSelect.length == 0) {
                clcIsClosedToday = true;
                //var opt = document.createElement('option');
                //opt.innerHTML = "------";
                //opt.setAttribute("disabled", "disabled");
                //clcHMSelect.appendChild(opt);
            }
        }
        initDatePicker();
    }
    console.log(clcOpenDaysOfWeek);
}

function OldcreateOpenHourCallback() {

    return function () {
        //alert(this.readyState )
        if (this.readyState == 4 && (this.status == 200)) {
            // document.write(this.responseText);
            var clcOHData = JSON.parse(this.responseText);
            clcHours = clcOHData.OpenHoursList;

            for (i = 0; i < clcHours.length; i = i + 1) {
                var tmpOh = new Date(clcHours[i].OpenHour);
                var tmpCh = new Date(clcHours[i].CloseHour);
                if (tmpCh.getDay() != tmpOh.getDay()) {

                    var addHoursForTommorow = tmpCh.getHours();
                    var tmpNewOpenHour = new Date(tmpOh.setHours(0, 0));
                    var tmpNewCloseHour = new Date(tmpOh.setHours(addHoursForTommorow, tmpCh.getMinutes()));

                    // tmpCh.setHours(24, 0);
                    tmpCh.setHours(0, 0);
                    clcHours[i].CloseHour = new Date(tmpCh);

                    var tmpNextDay = clcHours[i].Day;
                    //alert("h:");

                    if (tmpNextDay == 7)
                        tmpNextDay = 0;
                    clcHours.push({ "Day": +tmpNextDay + 1, "DayName": weekday[tmpNextDay], "OpenHour": tmpNewOpenHour, "CloseHour": tmpNewCloseHour });
                }
            }


            // בטעינה ראשונית - התאמה לשעות הפתיחה של היום בלבד
            var clcDate = new Date();

            for (i = 0; i < clcHours.length; i++) {
                var tmpDate = new Date();

                var tmpD = tmpDate.getDay() + 1;
                // alert(clcHours[i].Day + " ? " + tmpD);
                if (clcHours[i].Day == tmpD) { // && tmpDate.getDate() == 21 && date.getDate()

                    var o = new Date(clcHours[i].OpenHour);
                    var c = new Date(clcHours[i].CloseHour);
                    // לבדוק אם התאריך הוא של היום
                    if (true) { //clcToday.getDay() + 1 == tmpD && tmpDate.getDate() == clcToday.getDate()

                        // אם שעת הפתיחה פחות או שווה לעכשיו ועוד מינ' זמן - לשנות את שעת הפתיחה
                        var tmpHCheck = new Date();
                        tmpHCheck.setMinutes(tmpHCheck.getMinutes() + rest.MinMinutesFromNowToOrder);
                        if (o.getHours() <= tmpHCheck.getHours()) {
                            o.setHours(tmpDate.getHours());
                            o.setMinutes(tmpDate.getMinutes() + rest.MinMinutesFromNowToOrder);
                        }
                    }

                    var myHour = document.getElementById("Hour");
                    //for (clcJ = 0; clcJ < myHour.options.length; clcJ + 1) {
                    //    //myHour.options[clcJ] = null;
                    //}
                    fillTime(o, c, myHour);
                }
            }

            // כתיבת מה שהתקבל על המסך
            var lbl = document.createElement("div");
            lbl.id = "sd";
            lbl.innerHTML = "open houser:<br/>";
            for (i = 0; i < clcHours.length; i++) {
                // if (clcHours[i].Day == clcDate.getDay()) {
                lbl.innerHTML += clcHours[i].Day + "<br/>";
                lbl.innerHTML += clcHours[i].DayName + "<br/>";
                lbl.innerHTML += clcHours[i].OpenHour + "<br/>";
                lbl.innerHTML += clcHours[i].CloseHour + "<br/>";
                // alert(clcHours[i].OpenHour);
                // alert(clcHours[i].CloseHour);
                // }
            }
            document.getElementById("stepa").appendChild(lbl);


        }
        else {
            // Error getting Data
            // alert("oh ;( ready state: " + this.readyState + ", status: " + this.status);//  == 4 && (this.status == 200)

            // alert("oh ;( ")
        }

    };
}
function setLang(clang) {
    // alert(lang);
    // טעינת קובץ שפה
    //var scriptLang = document.createElement("SCRIPT");
    //scriptLang.src = clcSiteUrl + 'lang.' + lang + '.js';
    //scriptLang.type = 'text/javascript';
    //scriptLang.onload = function () {
    //    // לשים טקסטים במקום
    //    alert(lang.greeting);
    //};
    //document.getElementsByTagName("head")[0].appendChild(scriptLang);

    if (clang == "en") {
        this.clcLang = "en";
        jQuery("#clcFCont").addClass("clcLtr");
        jQuery("#clcRestName").text(rest.NameEnUS);
        jQuery("#clcRestCity").text(rest.AddressEnUS);
        jQuery("#clcBtmRemDin").text(lang[clcLang].PreliminarRemarkEnUS);
        if (rest.PreliminarRemarkEnUS != null) {
            jQuery("#clcBtmRemDin").text(rest.PreliminarRemarkEnUS);
        }
        else
            jQuery("#clcBtmRemDin").text("");
        // hide area
        jQuery("#clcAreaCont").addClass("clcHide");
    }
    else {
        this.clcLang = "he";
        jQuery("#clcFCont").removeClass("clcLtr");
        // טעינה של קובץ טקסטים עברית
        // jQuery("#clcRestName").text(rest.Name);
        jQuery("#clcRestCity").text(rest.Address);
        if (rest.PreliminarRemark != null) {
            jQuery("#clcBtmRemDin").text(rest.PreliminarRemark);
        }
        else
            jQuery("#clcBtmRemDin").text("");
        jQuery("#clcAreaCont").removeClass("clcHide");
    }

    // עדכון כל הפקדים שכוללים טקסט לפי זהויות או פתרון אחר.
    // להוסיף הצמדת זהויות לכל הפקדים שכוללים טקסט

    jQuery("#fStepHead").text(lang[clcLang].headPartA);
    jQuery("#secStepHead").text(lang[clcLang].headPartB);

    jQuery("#clcBtnSub").val(lang[clcLang].orderTable + " >");

    jQuery("#lblFirstName").text(lang[clcLang].firstName);// + " <span class='red'>*</span>");
    jQuery("#lblLastName").text(lang[clcLang].lastName);// + " <span class='red'>*</span>");
    jQuery("#error_FirstName").text(lang[clcLang].firstNameMandatory);
    jQuery("#error_LastName").text(lang[clcLang].lastNameMandatory);
    jQuery("#lblEmail").text(lang[clcLang].email);// + " <span class='red'>*</span>");
    jQuery("#lblSmoking").text(lang[clcLang].Smoking);
    jQuery("#lblArea").text(lang[clcLang].area);
    jQuery("#lblPhoneCode").text(lang[clcLang].areaCode);
    jQuery("#lblNumber").text(lang[clcLang].cellPhone);// + " <span class='red'>*</span>");
    // red dots
    var myRedDotA = document.createElement("span");
    myRedDotA.innerHTML = "*";
    addRegClassIdById(myRedDotA, "red", "", "lblFirstName");
    var myRedDotB = document.createElement("span");
    myRedDotB.innerHTML = "*";
    addRegClassIdById(myRedDotB, "red", "", "lblLastName");
    var myRedDotC = document.createElement("span");
    myRedDotC.innerHTML = "*";
    addRegClassIdById(myRedDotC, "red", "", "lblEmail");
    if (clcLang == "he") {
        var myRedDotD = document.createElement("span");
        myRedDotD.innerHTML = "*";
        addRegClassIdById(myRedDotD, "red", "", "lblNumber");
    }
    jQuery("#lblDate").text(lang[clcLang].date);
    jQuery("#lblHour").text(lang[clcLang].hour);
    jQuery("#lblPartySize").text(lang[clcLang].numberDiners);
    jQuery("#lblSmoking").text(lang[clcLang].smokingArea);
    jQuery("#lblRemark").text(lang[clcLang].remarks);

    jQuery("#lblCboxCoomer").text(lang[clcLang].iWantads);
    // להפריד כפתורים? 
    // jQuery("#clcBtnSub").val(lang[clcLang].orderTable + " > ");
    // jQuery("#clcBtnSub").val(lang[clcLang].backToDate + " > ");
    jQuery("#clcBtnFind").val(lang[clcLang].findaPlace + " > ");

    jQuery("#btnDoOrder").val(lang[clcLang].doOrder + " > ");
    jQuery("#clcBackBtn").val("< " + lang[clcLang].backToStart);
    jQuery("#clcBack").text("< " + lang[clcLang].backToDate);

    jQuery("#error_Email").text(lang[clcLang].emailisMandatory);
    jQuery("#error_ReqPhoneNumber").text(lang[clcLang].cellPhoneMandatory);
    jQuery("#error_PhoneNumber").text(lang[clcLang].cellPhoneErrMsg);
    jQuery("#clcBtmRem").text(lang[clcLang].markWillDoOurBest);

    // jQuery("").text("");
    // להוסיף הודעות שליחה תקלה וכו'
    // lblRemark
    jQuery('#Smoking option[value="0"]').text(lang[clcLang].no);
    jQuery('#Smoking option[value="1"]').text(lang[clcLang].yes);
    jQuery('#Smoking option[value="2"]').text(lang[clcLang].neverMind);
    // datepicker
    $("#datepicker").datepicker("option", $.datepicker.regional[clcLang]);
}
// isiphone
function clcIsIphone() {
    var clcIDevice = [
        'iPad Simulator',
        'iPad',
        'iPhone Simulator',
        'iPhone',
        'iPod Simulator',
        'iPod'
    ];

    if (!!navigator.platform) {
        while (clcIDevice.length) {
            if (navigator.platform === clcIDevice.pop()) { return true; } //alert(navigator.platform);
        }
    }

    return false;
}

var lang = {
    "he": {
        "clcCalture": "he-IL",
        "headPartA": "להזמנת שולחן במסעדה מלא את הטופס ונמצא עבורך שולחן מתאים",
        "headPartB": "פרטי הלקוח הינם לצורך אישור ההזמנה בלבד.",
        "chooseDate": "בחירת תאריך",
        "hour": "שעה",
        "date": "תאריך",
        "firstName": "שם פרטי",
        "firstNameMandatory": "שם פרטי - חובה",
        "lastName": "משפחה",
        "lastNameMandatory": "שם משפחה - חובה",
        "email": "אימייל",
        "emailMandatory": "אימייל - חובה",
        "cellPhone": "טלפון נייד",
        "cellPhoneMandatory": "טלפון נייד - חובה",
        "cellPhoneErrMsg": "נא למלא טלפון תקין",
        "areaCode": "קידומת",
        "numberDiners": "מספר סועדים",
        "smokingArea": "אזור עישון",
        "no": "לא",
        "yes": "כן",
        "neverMind": "לא משנה",
        "area": "אזור ישיבה",
        "remarks": "הערות",
        "iWantads": "אני מעוניין לקבל מידע על מבצעים מהמסעדה",
        "clickatacle": "קליק א טייבל",
        "retaurantName": "שם המסעדה",
        "findaPlace": "מצא מקום",
        "doOrder": "בצע הזמנה",
        "backToStart": "עדכון פרטי ההזמנה",
        "markWillDoOurBest": "הערה: המסעדה אינה מתחייבת להקצות שולחן באיזור הנבחר אך תשתדל לעשות כן.",
        "dateFormatError": "התאריך לא תקני",
        "emailisMandatory": "אימייל - חובה",
        // "emailIsWrong": "ערך דואר אלקטרוני אינו תקין",
        "canOrderFutureOnly": "ניתן להזמין לתאריך עתידי בלבד.",
        "selectLaterHour": "נא לבחור שעה מאוחרת יותר.",
        "fNameMandatory": "נא למלא שם פרטי.",
        "lNameMandatory": "נא למלא שם משפחה.",
        "emailIsWrong": "נא למלא כתובת מייל תקינה.",
        "phoneNumbersOnly": "נא למלא מספרים בלבד, ללא קידומת",
        "msgFillRedFields": "אנא מלאו את השדות המסומנים באדום.",
        "orderSuccess": "ההזמנה בוצעה בהצלחה",
        "orderDate": "תאריך ההזמנה",
        "orderArea": "אזור במסעדה",
        "orderName": "הזמנה על שם",
        "orderCount": "כמות הסועדים",
        "restaurantEt": "מסעדת",
        "address": "כתובת",
        "restaurantPhone": "טלפון במסעדה",
        "msgNotYetApproved": "בקשתך להזמנת מקום התקבלה בהצלחה אך טרם אושרה.",
        "requestDateRequest": "תאריך הבקשה",
        "requestName": "בקשה על שם",
        "errTooMuchRequests": "עברת את מכסת ההזמנות",
        "backToDate": "חזור לבחירת תאריך",
        "back": "חזרה",
        "forward": "קדימה",
        "orderTable": "הזמן שולחן",
        "updateOrder": "עדכון הזמנה",
        "restaurantTimeForOrder": "השולחן שמור במסעדה ל"
    },
    "en": {
        "clcCalture": "en-US",
        "headPartA": "Please fill out the following reservation form with your table preferences",
        "headPartB": "Customer details are for booking confirmation only",
        "chooseDate": "Reservation Date",
        "hour": "Time",
        "date": "Date",
        "firstName": "First Name",
        "firstNameMandatory": "Required",
        "lastName": "Last Name",
        "lastNameMandatory": "Required",
        "email": "Email",
        "emailMandatory": "Please Fill Your Email",
        "cellPhone": "Cell Phone",
        "cellPhoneMandatory": "Required",
        "cellPhoneErrMsg": "Please enter corect phone number",
        "areaCode": "Area Code",
        "numberDiners": "Party Size",
        "smokingArea": "Smoking Area",
        "no": "no",
        "yes": "yes",
        "neverMind": "Don't Mind",
        "area": "Sitting Area",
        "remarks": "Remarks",
        "iWantads": "I would like to receive information and  promotions from the restaurant",
        "clickatacle": "Click A Table",
        "retaurantName": "Restaurant Name",
        "findaPlace": "Find a Place",
        "doOrder": "Make a Reservation",
        "backToStart": "Change Date",
        "markWillDoOurBest": "Note:  The restaurant does not undertake to assign a table in the chosen area but will try to do so",
        "dateFormatError": "Required",
        "emailisMandatory": "Required",
        "canOrderFutureOnly": "Please select a Future reservation date.",
        "selectLaterHour": "Please try a different later hour.",
        "fNameMandatory": "Required",
        "lNameMandatory": "Required",
        "emailIsWrong": "Please fill in a valid email address.",
        "phoneNumbersOnly": "Please fill in numbers only, without a prefix",
        "msgFillRedFields": "Please fill out the fields marked with red.",
        "orderSuccess": "Your order has been successfully placed",
        "orderDate": "Date of order",
        "orderArea": "Restaurant area",
        "orderName": "Invitation to name",
        "orderCount": "Number of diners",
        "restaurantEt": "Restaurant",
        "address": "Address",
        "restaurantPhone": "A phone in the restaurant",
        "msgNotYetApproved": "Your request to place a reservation has been successfully accepted but has not yet been approved",
        "requestDateRequest": "Date of application",
        "requestName": "Request Name",
        "errTooMuchRequests": "You have exceeded the order quota",
        "backToDate": "Update Reservation",
        "back": "Back",
        "forward": "Forward",
        "orderTable": "Order a Table",
        "updateOrder": "Update Order",
        "restaurantTimeForOrder": "Reservation time Limit"

    }
};

// old onselect date
// check wich day of week & send fill day of week times
//var tmpDate = new Date();
//tmpDate.setFullYear(date.split("/")[2]);
//tmpDate.setMonth(date.split("/")[1] - 1);
//tmpDate.setDate(date.split("/")[0]);
//// alert(tmpDate.getDay());
//var myHour = document.getElementById("Hour");
//// alert(myHour.options.length)
//for (clcJ = 0; clcJ < myHour.options.length; clcJ + 1) {
//    myHour.options[clcJ] = null;
//}
//for (i = 0; i < clcHours.length; i++) {
//    // alert(clcHours[i].OpenHour);
//    var tmpD = tmpDate.getDay() + 1;
//    // alert(clcHours[i].Day + " ? " + tmpD);
//    if (clcHours[i].Day == tmpD) { // && tmpDate.getDate() == 21 && date.getDate()

//        var o = new Date(clcHours[i].OpenHour);
//        var c = new Date(clcHours[i].CloseHour);
//        // לבדוק אם התאריך הוא של היום
//        if (clcToday.getDay() + 1 == tmpD && tmpDate.getDate() == clcToday.getDate()) {

//            // אם שעת הפתיחה פחות או שווה לעכשיו ועוד מינ' זמן - לשנות את שעת הפתיחה
//            // clcDate.setMinutes(clcDate.getMinutes() + rest.MinMinutesFromNowToOrder);
//            // clcToday.setMinutes(clcToday.getMinutes() + rest.MinMinutesFromNowToOrder);
//            var tmpHCheck = new Date();
//            tmpHCheck.setMinutes(tmpHCheck.getMinutes() + rest.MinMinutesFromNowToOrder);
//            if (o.getHours() <= tmpHCheck.getHours()) {
//                o.setHours(clcToday.getHours());
//                o.setMinutes(clcToday.getMinutes() + rest.MinMinutesFromNowToOrder);
//            }
//        }


//        // alert(o);
//        //alert(c);
//        // var myHour = document.getElementById("Hour");
//        // alert(myHour.options.length)
//        //for (clcJ = 0; clcJ < myHour.options.length; clcJ + 1) {
//        //    myHour.options[clcJ] = null;
//        //}
//        // myMin.setAttribute("id", "Minutes");
//        // alert("filltime");
//        fillTime(o, c, myHour);
//    }
//}
////alert(date);
////alert(tmpDate);
//// clcHours
//opt.setAttribute("disabled", "disabled");
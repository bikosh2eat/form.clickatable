// function test() {
    document.write("<br/>js_Start<br/>");
    
    var miniAgentContainer = document.createElement("div");

    var chatIfrmContainer = document.createElement("div");
    var chatIfrm = document.createElement("iframe");
    var chatWin = document.createElement("div");

    miniAgentContainer.innerHTML = "<b>new</b> test"
    miniAgentContainer.setAttribute("id", "miniAgentContainer");
    miniAgentContainer.setAttribute("onclick", "ShowChatWin(event);");
    document.body.appendChild(miniAgentContainer);

    document.write("<br/>js_End<br/>");
//}


    function InitAgentUI() {

        // var hrefParam = encodeURIComponent(location.href);
        // var titleParam = encodeURI(document.title);

        // long hebrew title can exceed the maxmimum url length (2048)
        //if (titleParam.length > 2000) {
        //    titleParam = titleParam.substring(0, 1800);
        //}

        // var chatWinUrl = "//StarAgent.co.il/chatsys/ChatPage.aspx?agentId=30905&trigPageUrl=" + hrefParam + "&trigPageTitle=" + titleParam;
        // var chatWinUrl = "//clickiframe.clickatable.co.il/SearchPage.aspx?restaurantID=af1e2e86-78a9-419f-9789-0eda577d2f8a&redirected=1&tColor1=bd202d&tColor2=262526&tColor3=262526&tColor4=262526&ShowHeader=false&ShowHeaderMenu=false&ShowRemarks=false&width=290px&fontSize=14&showImage=false&color=none&ShowClickPoints=false;showrestuarantName=false&";
        var chatWinUrl = "http://aviva-moving.co.il/X";
        // Set reference to agent style sheet
        //try {
        //    var s = document.getElementsByTagName('script')[0];
        //    var cssStyle = document.createElement('link');
        //    cssStyle.type = 'text/css';

        //    cssStyle.setAttribute("rel", "Stylesheet");
        //    cssStyle.setAttribute("href", "//StarAgent.co.il/StarUsersFiles/55893/Agents/30905/Style/chatSys.min.css?ver=636213864948000000");

        //    s.parentNode.insertBefore(cssStyle, s);
        //}
        //catch (e) {
        //    alert(e);
        //}

        // remove cookie to display the small banner
        //if (closeSmallBanner == 0 &&
        //    GetCookie("disableShowChatAuto") != null) {
        //    DeleteCookie("disableShowChatAuto");
        //}

        //if (GetCookie("disableShowChatAuto") == null)
        //    miniAgentContainer.setAttribute("id", "miniAgentContainer");

        //if (IsInMobileDevice() == true) {
        //    miniMobileAgent.setAttribute("id", "miniMobileAgent");
        //    miniMobileAgent.setAttribute("href", chatWinUrl);
        //    miniMobileAgent.setAttribute("target", "_blank");

        //    if (GetCookie("disableShowChatAuto") == null)
        //        miniMobileAgent.appendChild(miniAgentContainer);

        //    document.body.appendChild(miniMobileAgent);
        //}
        //else {
        //    if (GetCookie("disableShowChatAuto") == null)
        //        miniAgentContainer.setAttribute("onclick", "ShowChatWin(event);");

        //    document.body.appendChild(miniAgentContainer);
        //}

        //if (GetCookie("disableShowChatAuto") == null) {
        //    // small agent pic
        //    miniAgent.setAttribute("id", "miniAgent");
        //    miniAgentContainer.appendChild(miniAgent);

        //    // x pic
        //    removeMiniAgent.setAttribute("id", "removeMiniAgent");
        //    removeMiniAgent.setAttribute("onclick", "RemoveChatAgent(event);");

        //    if (isLtrLayout == true) {
        //        miniAgentContainer.setAttribute("class", "ltr-layout");
        //    }

        //    miniAgentContainer.appendChild(removeMiniAgent);

        //    // banner bottom message
        //    agentAwaitsMessages.setAttribute("id", "agentAwaitsMessages");
        //    miniAgentContainer.appendChild(agentAwaitsMessages);
        //}

        //agentAwaitsMsg.innerHTML = "הנציגה ממתינה לך";
        //clickHereMsg.innerHTML = "לחץ כאן לשיחה";

        //// alternate banner messages
        //agentAwaitsMsg.setAttribute("id", "agentAwaitsMsg");
        //agentAwaitsMessages.appendChild(agentAwaitsMsg);

        //clickHereMsg.setAttribute("id", "clickHereMsg");
        //agentAwaitsMessages.appendChild(clickHereMsg);

        //// chat window container
        //chatWin.setAttribute("id", "chatWin");

        //if (isLtrLayout == true) {
        //    chatWin.setAttribute("class", "ltr-layout");
        //}

        //chatIfrmContainer.setAttribute("id", "chatIfrmContainer");

        chatIfrm.setAttribute("id", "chatIfrm");
        chatIfrm.setAttribute("scroll", "no");
        chatIfrm.setAttribute("border", "0");
        chatIfrm.setAttribute("frameBorder", "0");
        chatIfrm.setAttribute("scroll", "auto");
        chatIfrm.setAttribute("allowTransparency", "1");
        chatIfrm.setAttribute("src", chatWinUrl);
        chatIfrm.setAttribute("height", "500px");
        chatIfrm.setAttribute("width", "600px");

        //if (IsInMobileDevice() == false) {
        //    hideChatWin.setAttribute("id", "hideChatWin");
        //    hideChatWin.setAttribute("onclick", "HideChatWin();");

        //    chatMiniAgent.setAttribute("id", "chatMiniAgent");
        //    chatLogo.setAttribute("id", "chatLogo");
        //}
    }

    function ShowChatWin(e) {
        // document.write("a");
        // alert("a");
        // clearTimeout(openChatAuto);

        chatIfrmContainer.appendChild(chatIfrm);
        chatWin.appendChild(chatIfrmContainer);
        

        //if (IsInMobileDevice() == false) {
        //    chatWin.appendChild(hideChatWin);
        //    chatWin.appendChild(chatMiniAgent);
        //    chatWin.appendChild(chatLogo);
        //}
        document.body.appendChild(chatWin);

        if (typeof (e) != "undefined") {
            SetCookie("userOpenedChatWin", "true", 1);
        }
        else {
            DeleteCookie("userOpenedChatWin");
        }

        // SetDemoAgent();

        // window.clearInterval(replaceAgentMsgsInterval);

        //if (IsInMobileDevice() == true)
        //    document.body.removeChild(miniMobileAgent);
        //else
            // document.body.removeChild(miniAgentContainer);

        //document.write("a");
        InitAgentUI();
        // document.write("X");
    }
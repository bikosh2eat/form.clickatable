

// Set UI controls

// set the minimize agent
var miniAgentContainer          = document.createElement("div");
var miniAgent                   = document.createElement("div");
var removeMiniAgent             = document.createElement("div");
var agentAwaitsMessages         = document.createElement("div");
var agentAwaitsMsg              = document.createElement("span");
var clickHereMsg                = document.createElement("span");
var chatWin                     = document.createElement("div");
var chatIfrmContainer           = document.createElement("div");
var chatIfrm                    = document.createElement("iframe");
var hideChatWin                 = document.createElement("div");
var chatMiniAgent               = document.createElement("div");
var chatLogo                    = document.createElement("div");
var miniMobileAgent             = document.createElement("a");
//var thankYouPageLink;

var openChatTimeout             = 4;            // default 1
var maxAutoShowChatTimes        = -1;         // default -1 (e.g. not limitd)
var closeSmallBanner            = 0;             // default 0 (e.g. current page)
var openChatAuto;
var replaceAgentMsgsTimeout     = 2000;                             // 2 sec
var replaceAgentMsgsInterval;
var isLtrLayout                 = false;

var maleAgentAwaitsMsg          = "##MaleAgentAwaitsMsg##";
var maleAgentChatTitle          = "";
var femaleAgentAwaitsMsg        = "##FemaleAgentAwaitsMsg##";
var femaleAgentChatTitle        = "";
//var thankYouPageUrl             = "##ThankYouPageUrl##";

function InitAgentUI()
{   
    var hrefParam   = encodeURIComponent(location.href);
    var titleParam  = encodeURI(document.title);

    // long hebrew title can exceed the maxmimum url length (2048)
    if (titleParam.length > 2000)
    {
        titleParam  = titleParam.substring(0, 1800);
    }

    var chatWinUrl  = "//StarAgent.co.il/chatsys/ChatPage.aspx?agentId=30905&trigPageUrl=" + hrefParam + "&trigPageTitle=" + titleParam;

    // Set reference to agent style sheet
    try 
    {   
        var s           = document.getElementsByTagName('script')[0];     
        var cssStyle    = document.createElement('link');
        cssStyle.type   = 'text/css';

        cssStyle.setAttribute("rel",            "Stylesheet");        
        cssStyle.setAttribute("href",           "//StarAgent.co.il/StarUsersFiles/55893/Agents/30905/Style/chatSys.min.css?ver=636213864948000000");
        
        s.parentNode.insertBefore(cssStyle, s);
    }
    catch (e) 
    {
        alert(e);
    }

    // remove cookie to display the small banner
    if (closeSmallBanner                    == 0 && 
        GetCookie("disableShowChatAuto")    != null)
    {        
        DeleteCookie("disableShowChatAuto");
    }

    if (GetCookie("disableShowChatAuto") == null)
        miniAgentContainer.setAttribute("id",       "miniAgentContainer");
    
    if(IsInMobileDevice() == true)
    {
        miniMobileAgent.setAttribute("id",          "miniMobileAgent");
        miniMobileAgent.setAttribute("href",        chatWinUrl);
        miniMobileAgent.setAttribute("target",      "_blank");
        
        if (GetCookie("disableShowChatAuto") == null)
            miniMobileAgent.appendChild(miniAgentContainer);

        document.body.appendChild(miniMobileAgent);
    }
    else
    {
        if (GetCookie("disableShowChatAuto") == null)
            miniAgentContainer.setAttribute("onclick",  "ShowChatWin(event);");

        document.body.appendChild(miniAgentContainer);
    }

    if (GetCookie("disableShowChatAuto") == null)
    {
        // small agent pic
        miniAgent.setAttribute("id",                "miniAgent");
        miniAgentContainer.appendChild(miniAgent);

        // x pic
        removeMiniAgent.setAttribute("id",          "removeMiniAgent");
        removeMiniAgent.setAttribute("onclick",     "RemoveChatAgent(event);");
        
        if (isLtrLayout == true) 
        {
            miniAgentContainer.setAttribute("class", "ltr-layout");
        }

        miniAgentContainer.appendChild(removeMiniAgent);
    
        // banner bottom message
        agentAwaitsMessages.setAttribute("id",      "agentAwaitsMessages");
        miniAgentContainer.appendChild(agentAwaitsMessages);
    }

    agentAwaitsMsg.innerHTML                    = "הנציגה ממתינה לך";
    clickHereMsg.innerHTML                      = "לחץ כאן לשיחה";

    // alternate banner messages
    agentAwaitsMsg.setAttribute("id",           "agentAwaitsMsg");
    agentAwaitsMessages.appendChild(agentAwaitsMsg);

    clickHereMsg.setAttribute("id",             "clickHereMsg");
    agentAwaitsMessages.appendChild(clickHereMsg); 

    /*
    if (thankYouPageUrl != '') 
    {
        thankYouPageLink = document.createElement("a");
        thankYouPageLink.setAttribute("id",             "thankYouPageLink");
        //thankYouPageLink.setAttribute("href",           "http://" + thankYouPageUrl);
        thankYouPageLink.setAttribute("href",           "javascript:void(0);");
        //thankYouPageLink.setAttribute("onclick",        "$(this).stopPropagation();");
        //thankYouPageLink.setAttribute("onclick",        "$(a).click(function(e){e.stopPropagation();});");
        //thankYouPageLink.setAttribute("onclick",        "function(e){e.stopPropagation();};");
        thankYouPageLink.setAttribute("onclick",        "window.location='http://" + thankYouPageUrl + "';");
        
        //miniAgentContainer.appendChild(thankYouPageLink);
        document.body.appendChild(thankYouPageLink);
        chatIfrm.setAttribute("show-thank-you-page",  "true");
    }
    */

    // chat window container
    chatWin.setAttribute("id",                  "chatWin");

    if (isLtrLayout == true) 
    {
        chatWin.setAttribute("class",           "ltr-layout");
    }

    chatIfrmContainer.setAttribute("id",        "chatIfrmContainer");

    chatIfrm.setAttribute("id",                 "chatIfrm");
    chatIfrm.setAttribute("scroll",             "no");
    chatIfrm.setAttribute("border",             "0");
    chatIfrm.setAttribute("frameBorder",        "0");
    chatIfrm.setAttribute("scroll",             "no");
    chatIfrm.setAttribute("allowTransparency",  "1");
    chatIfrm.setAttribute("src",                chatWinUrl);  

    if (IsInMobileDevice() == false) 
    {
        hideChatWin.setAttribute("id",          "hideChatWin");
        hideChatWin.setAttribute("onclick",     "HideChatWin();");

        chatMiniAgent.setAttribute("id",        "chatMiniAgent");
        chatLogo.setAttribute("id",             "chatLogo");
    }
}

function ShowChatWin(e)
{     
    clearTimeout(openChatAuto);

    chatIfrmContainer.appendChild(chatIfrm);
    chatWin.appendChild(chatIfrmContainer);

    if (IsInMobileDevice() == false) 
    {
        chatWin.appendChild(hideChatWin); 
        chatWin.appendChild(chatMiniAgent); 
        chatWin.appendChild(chatLogo); 
    }

    document.body.appendChild(chatWin);    

    if (typeof(e) != "undefined")
    {
        SetCookie("userOpenedChatWin", "true", 1);
    }
    else 
    {
        DeleteCookie("userOpenedChatWin");
    }

    SetDemoAgent();

    window.clearInterval(replaceAgentMsgsInterval);

    if(IsInMobileDevice() == true)
        document.body.removeChild(miniMobileAgent);
    else
        document.body.removeChild(miniAgentContainer);    
}

function HideChatWin()
{
    if(IsInMobileDevice() == true)
        document.body.appendChild(miniMobileAgent);
    else
    {
        document.body.appendChild(miniAgentContainer); 
    
        document.body.removeChild(chatWin);
    }

    SetDemoAgent();
    
    SetAgentAwaitsMsgsReplaceInterval();
}

function RemoveChatAgent(e)
{    
    window.clearInterval(replaceAgentMsgsInterval);

    if (document.body.contains(miniMobileAgent) == true)
    {
        document.body.removeChild(miniMobileAgent);

        e.preventDefault();
    }
    else 
    {
        document.body.removeChild(miniAgentContainer);
    }
    
    //e.preventDefault(); 
    e.stopPropagation();

    if (closeSmallBanner == 1)
        SetCookie("disableShowChatAuto", "1", 1);

    //return false;
}


function ShowChatAutomatically()
{
    var currentAutoShowChatTimes = 0;

    clearTimeout(openChatAuto);

    if(IsInMobileDevice() == false)
    {
        // get the current times the chat windows was opened "automatically"
        if(GetCookie("currentAutoShowChatTimes") != null)
            currentAutoShowChatTimes = Number(GetCookie("currentAutoShowChatTimes"));

        // check if the user closed the agent banner (e.g disabling opening the chat window "automatically"),
        // and the
        if(GetCookie("disableShowChatAuto") == null && 
          (maxAutoShowChatTimes             == -1   || 
           currentAutoShowChatTimes         < maxAutoShowChatTimes))
        {        
            ShowChatWin();

            currentAutoShowChatTimes++;

            SetCookie("currentAutoShowChatTimes", currentAutoShowChatTimes, 1);
        }
    }
}

function ReplaceAgentAwaitsMessages()
{
    if(document.getElementById("agentAwaitsMsg")            != null &&
       typeof(document.getElementById("agentAwaitsMsg"))    != "undefined")
    {
        if(document.getElementById("agentAwaitsMsg").style.display == "" || 
           document.getElementById("agentAwaitsMsg").style.display == "block")
        {
            document.getElementById("agentAwaitsMsg").style.display = "none";
            document.getElementById("clickHereMsg").style.display   = "block";
        }
        else
        {
            document.getElementById("agentAwaitsMsg").style.display = "block";
            document.getElementById("clickHereMsg").style.display   = "none";
        }
    }
}

// Set time out to replace between the agent awaits messages
function SetAgentAwaitsMsgsReplaceInterval()
{
    replaceAgentMsgsInterval = setInterval(ReplaceAgentAwaitsMessages, replaceAgentMsgsTimeout);
}


function IsInMobileDevice()
{
    var isMobile = false;

    if (typeof (jsRef)                              != "undefined" && 
        typeof (jsRef.src)                          != "undefined" && 
        jsRef.src.toLowerCase().indexOf("ismobile") != -1)
    {
        isMobile = true;
    }

    return isMobile;
}

InitAgentUI();

// Set time out to open the chat window "automatically"
if(openChatTimeout > 0)
{
    openChatAuto = setTimeout(function() {
                            ShowChatAutomatically();
                         }, openChatTimeout * 1000);
}

SetAgentAwaitsMsgsReplaceInterval();
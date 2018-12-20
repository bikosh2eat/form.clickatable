<%@ Page Language="C#" AutoEventWireup="true" CodeFile="iframe.aspx.cs" Inherits="iframe" StylesheetTheme="" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        body, form {
            width: 100%;
            direction:rtl;
            text-align:right;
        }
    </style>
    <asp:Literal runat="server" ID="litHeadCont"></asp:Literal>
</head>
<body>
    <div id="clcFCont"></div>
    <form id="form1" runat="server">
        <asp:Literal runat="server" ID="litPageContent"></asp:Literal>
    </form>
</body>
</html>

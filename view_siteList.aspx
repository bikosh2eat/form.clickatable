<%@ Page Language="C#" MasterPageFile="~/admin.master" AutoEventWireup="true" CodeFile="view_siteList.aspx.cs"
    Inherits="view_siteList" Title="ניהול אתרים" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:Repeater runat="server" ID="rptSiteList">
        <HeaderTemplate>
            <table class="tblLists">
                <tr>
                    <th colspan="8">
                        <asp:Button runat="server" ID="btnEditMe" Text="ערוך אתר זה" OnClick="btnEditMe_Click" />
                    </th>
                    <th>
                        חפש לפי שם אתר
                    </th>
                </tr>
                <tr>
                    <th>
                    </th>
                    <th>
                        שם האתר
                    </th>
                    <th>
                        תחת 2eat
                    </th>
                    <th>
                        כתובת
                    </th>
                    <th>
                        פעיל
                    </th>
                    <th>
                        סוג
                    </th>
                    <th>
                        גירסא
                    </th>
                    <th>
                        <asp:ImageButton runat="server" ID="ibtnAddSite" SkinID="com_New" OnClick="ibtnAddSite_Click" Enabled='<%# globalFunctions.CheckVisabilityForAdmin("#d") %>' Visible='<%# globalFunctions.CheckVisabilityForAdmin("#d") %>' />
                    </th>
                    <th>
                        <asp:TextBox runat="server" ID="tboxSearchSite" Width="120"></asp:TextBox>
                        <asp:DropDownList runat="server" ID="ddlSrcSiteTemp" DataSourceID="sdsTemplates"
                            DataTextField="tName" DataValueField="id">
                        </asp:DropDownList>
                        <asp:CheckBox runat="server" ID="cboxShowOffSites" Text="הצג גם אתרים כבויים" />
                        <asp:Button runat="server" ID="btnSeaerchSite" Text="חפש" OnClick="btnSeaerchSite_Click"
                            OnLoad="btnSeaerchSite_Load" />
                    </th>
                </tr>
        </HeaderTemplate>
        <ItemTemplate>
            <tr>
                <td>
                    <asp:ImageButton runat="server" ID="ibtnDeleteSite" SkinID="com_Del" OnClientClick="return confirm('האם אתה בטוח?')"
                        OnClick="ibtnDeleteSite_Click" CommandArgument='<%# Eval("id") %>' />
                </td>
                <td>
                    <%# Eval("sName") %>
                </td>
                <td>
                    <asp:CheckBox runat="server" ID="cboxUnderToeat" Enabled="false" Checked='<%# Eval("sUndertoeat") %>' />
                </td>
                <td>
                    <asp:Label runat="server" ID="lblSMainD" Text='<%# Eval("sMainDomain")%>'></asp:Label>
                    &nbsp;
                    <asp:HyperLink runat="server" ID="hlShowSite" NavigateUrl='<%# Eval("sMainDomain") %>'
                        Target="_blank" OnPreRender="hlShowSite_PreRender" Text="הצג"></asp:HyperLink>
                </td>
                <td>
                    <asp:CheckBox runat="server" ID="cboxIsOn" Checked='<%# Eval("sIsOn") %>' Enabled="false" />
                </td>
                <td>
                    <%# Eval("sTemplate")%>
                </td>
                <td>
                    <%# Eval("sVer") %>
                </td>
                <td>
                    <asp:ImageButton runat="server" ID="ibtnEditSite" SkinID="com_edit" OnClick="ibtnEditSite_Click"
                        CommandArgument='<%# Eval("id") %>' />
                </td>
                <td>
                    <asp:Button runat="server" ID="btnSelectThisSite" CommandArgument='<%# Eval("id") %>'
                        OnClick="btnSelectThisSite_Click" Text="עבור לעריכת אתר זה" />
                </td>
            </tr>
        </ItemTemplate>
        <FooterTemplate>
            </table>
        </FooterTemplate>
    </asp:Repeater>
    <asp:SqlDataSource ID="sdsSites" runat="server" ConnectionString="<%$ ConnectionStrings:mainConnString %>"
        SelectCommand="SELECT id,sName,sMainDomain,sIsOn,sTemplate,sVer,sUndertoeat FROM [sitesPref] ORDER BY [sName]">
    </asp:SqlDataSource>
    <asp:DetailsView ID="dviewEditSite" runat="server" Visible="False" AutoGenerateRows="False"
        DataSourceID="odsSitePref" Width="950px" CellPadding="4" ForeColor="#333333"
        GridLines="None" OnItemCommand="dviewEditSite_ItemCommand" OnItemDeleted="dviewEditSite_ItemDeleted"
        OnItemDeleting="dviewEditSite_ItemDeleting" OnItemInserted="dviewEditSite_ItemInserted"
        OnItemInserting="dviewEditSite_ItemInserting" OnItemUpdated="dviewEditSite_ItemUpdated"
        OnItemUpdating="dviewEditSite_ItemUpdating">
        <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
        <FooterTemplate>
            <asp:Button runat="server" ID="btnReturnToSiteList" OnClick="btnReturnToSiteList_Click"
                Text="חזור לרשימת האתרים" />
        </FooterTemplate>
        <CommandRowStyle BackColor="#E2DED6" Font-Bold="True" />
        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" HorizontalAlign="Right" />
        <FieldHeaderStyle Font-Bold="True" Width="150px" />
        <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
        <Fields>
            <%--<asp:CheckBoxField DataField="sBasketBtn" HeaderText="יש חנות וכפתור סל" InsertVisible="false" />
            <asp:BoundField ConvertEmptyStringToNull="False" DataField="sBasketBtnStyle" HeaderText="עיצוב כפתור סל" SortExpression="sBasketBtnStyle" InsertVisible="False" >
                <ControlStyle Width="250px" />
            </asp:BoundField>--%>
            <asp:TemplateField>
                <HeaderTemplate>
                    <u>הגדרות אתר</u>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:HiddenField runat="server" ID="hfSiteId" Value='<%# Bind("id") %>' />
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:BoundField ConvertEmptyStringToNull="False" DataField="sName" HeaderText="שם האתר"
                SortExpression="sName" />
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="תיקייה" SortExpression="sDir">
                <EditItemTemplate>
                    <%--<asp:TextBox ID="tboxDir" runat="server" Text='<%# Bind("sDir") %>'></asp:TextBox>--%>
                    <asp:Label ID="tboxDir" runat="server" Text='<%# Bind("sDir") %>' ToolTip="שינוי התיקייה נחסם. אין צורך להחליף שם תיקיות."></asp:Label>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="tboxDir" runat="server" Text='<%# Bind("sDir") %>'></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="tboxDir"
                        ErrorMessage="*חובה"></asp:RequiredFieldValidator>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label6" runat="server" Text='<%# Bind("sDir") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="אתר ללא דומיין">
                <InsertItemTemplate>
                    <asp:CheckBox runat="server" ID="unserToeat" Checked='<%# Bind("sUndertoeat") %>'
                        Text="האתר יישב תחת 2eat" OnInit="CBoxDefaultToChecked" />
                </InsertItemTemplate>
                <EditItemTemplate>
                    <asp:CheckBox runat="server" ID="unserToeat" Checked='<%# Bind("sUndertoeat") %>'
                        Text="האתר יישב תחת 2eat" />
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:CheckBox runat="server" ID="unserToeat" Enabled="false" Checked='<%# Eval("sUndertoeat") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="זהות ב2eat" SortExpression="toeatID">
                <HeaderTemplate>
                    זהות ב2eat<br />
                    <asp:UpdatePanel ID="upGet2eatId" runat="server">
                        <ContentTemplate>
                            <asp:TextBox ID="tboxFind2eatId" runat="server" Width="120px"></asp:TextBox>
                            <asp:Button ID="btnFind2eatId" runat="server" Text="הצע זהויות" OnClick="btnFind2eatId_Click">
                            </asp:Button>
                            <asp:Button ID="btnClearFind2eatId" runat="server" Text="נקה" OnClick="btnClearFind2eatId_Click">
                            </asp:Button>
                            <asp:Repeater ID="rptFind2eatId" runat="server">
                                <HeaderTemplate>
                                    <table cellpadding="0" cellspacing="5px">
                                        <tr>
                                            <th>
                                                שם
                                            </th>
                                            <th>
                                                זהות
                                            </th>
                                            <th style="width: 80px;">
                                                טלפון
                                            </th>
                                            <th>
                                                כתובת
                                            </th>
                                            <th>
                                                עיר
                                            </th>
                                        </tr>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr style="background-color: #dbbebe;">
                                        <td>
                                            <%# Eval("restTitle") %>
                                        </td>
                                        <td>
                                            <%# Eval("restId") %>
                                        </td>
                                        <td>
                                            <%# Eval("restPhone") %>
                                        </td>
                                        <td>
                                            <%# Eval("restAddress") %>
                                        </td>
                                        <td>
                                            <%# Eval("subName") %>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <AlternatingItemTemplate>
                                    <tr style="background-color: #d3c4c4;">
                                        <td>
                                            <%# Eval("restTitle") %>
                                        </td>
                                        <td>
                                            <%# Eval("restId") %>
                                        </td>
                                        <td>
                                            <%# Eval("restPhone") %>
                                        </td>
                                        <td>
                                            <%# Eval("restAddress") %>
                                        </td>
                                        <td>
                                            <%# Eval("subName") %>
                                        </td>
                                    </tr>
                                </AlternatingItemTemplate>
                                <FooterTemplate>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox15" runat="server" Text='<%# Bind("toeatID") %>'></asp:TextBox><br />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox15" runat="server" Text='<%# Bind("toeatID") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label15" runat="server" Text='<%# Bind("toeatID") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:CheckBoxField DataField="sIsOn" HeaderText="פעיל" SortExpression="sIsOn" />
            <asp:TemplateField ConvertEmptyStringToNull="False" SortExpression="sMainDomain">
                <HeaderTemplate>
                    דומיין ראשי<br />
                    <span style="font-size: 8px">במידה ותחת 2eat - יש לציין את שמו בלבד.</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox16" runat="server" Text='<%# Bind("sMainDomain") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="tboxInsMainDomain" runat="server" Text='<%# Bind("sMainDomain") %>'></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="tboxInsMainDomain"
                        ErrorMessage="*חובה"></asp:RequiredFieldValidator>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label16" runat="server" Text='<%# Bind("sMainDomain") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:CheckBoxField HeaderText="אל תחייב תחילית www<br /><span style='font-size: 8px'>במקרה של אתר עם דומיין פרטי בלבד</span>"
                DataField="sNoForcewww" />
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="דומיינים נוספים (מופרד בפסיקים)"
                SortExpression="sDomains">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" TextMode="multiLine" SkinID="tboxMultiline3"
                        Text='<%# Bind("sDomains") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" TextMode="multiLine" SkinID="tboxMultiline3"
                        Text='<%# Bind("sDomains") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("sDomains") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="רקע כללי לאתר" SortExpression="sBGImageFile"
                InsertVisible="False">
                <EditItemTemplate>
                    <asp:FileUpload ID="fuBackImg" runat="server" /><br />
                    <asp:Image ID="imgBack" runat="server" Height="200px" Visible='<%# globalFunctions.hasValue(Eval("sBGImageFile")) %>'
                        Width="200px" ImageUrl='<%# globalFunctions.FixedImageUrl(Eval("sBGImageFile"),Eval("sMainDomain")) %>' /><br />
                    <asp:CheckBox ID="cbRemoveBackImg" runat="server" Text="הסר תמונה" Visible='<%# globalFunctions.hasValue(Eval("sBGImageFile")) %>' />
                    <asp:HiddenField ID="hfBackImg" runat="server" Value='<%# Eval("sBGImageFile") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("sBGImageFile") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("sBGImageFile") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="גלריית רקעים" InsertVisible="false">
                <EditItemTemplate>
                    <asp:DropDownList runat="server" ID="ddlBGGal" AppendDataBoundItems="True" SelectedValue='<%# Bind("sBGGalleryID") %>'
                        DataSourceID="odsBGGal" DataTextField="GalTitle" DataValueField="GalleryId">
                        <asp:ListItem Value="" Text="-בחר-"></asp:ListItem>
                    </asp:DropDownList>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:DropDownList runat="server" ID="ddlBGGal" AppendDataBoundItems="True" SelectedValue='<%# Bind("sBGGalleryID") %>'
                        DataSourceID="odsBGGal" DataTextField="GalTitle" DataValueField="GalleryId">
                        <asp:ListItem Value="" Text="-בחר-"></asp:ListItem>
                    </asp:DropDownList>
                </InsertItemTemplate>
                <ItemTemplate>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="לוגו אתר<br />(jpg/gif/swf)"
                SortExpression="sLogoFile" InsertVisible="False">
                <EditItemTemplate>
                    <asp:FileUpload ID="fuLogoImg" runat="server" /><br />
                    <asp:Image ID="imgLogo" runat="server" Visible='<%# globalFunctions.hasValue(Eval("sLogoFile")) %>'
                        Width="150px" ImageUrl='<%# globalFunctions.FixedImageUrl(Eval("sLogoFile"),Eval("sMainDomain")) %>' />
                    <asp:Literal runat="server" ID="litFlash" Text='<%# Eval("logoFlashSize") %>' OnDataBinding="litFlash_DataBinding"></asp:Literal>
                    <br />
                    <asp:CheckBox ID="cbRemoveLogoImg" runat="server" Text="הסר תמונה" Visible='<%# globalFunctions.hasValue(Eval("sLogoFile")) %>' />
                    <asp:HiddenField ID="hfLogoImg" runat="server" Value='<%# Eval("sLogoFile") %>' />
                    <br />
                    <b>פלאש בלבד: (בפיקסלים)</b><br />
                    רוחב:
                    <asp:TextBox runat="server" ID="tBoxlogoFlashWidth" Text='<%# Eval("logoFlashWidth") %>'
                        Width="100px"></asp:TextBox>
                    גובה:
                    <asp:TextBox runat="server" ID="tBoxlogoFlashHeight" Text='<%# Eval("logoFlashHeight") %>'
                        Width="100px"></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox3" runat="server" Text='<%# Bind("sLogoFile") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("sLogoFile") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField ConvertEmptyStringToNull="False" DataField="sLogoAlt" HeaderText="תיאור ללוגו"
                SortExpression="sLogoAlt" InsertVisible="False">
                <ControlStyle Width="500px" />
            </asp:BoundField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="הדר אתר" SortExpression="sHeaderFile"
                InsertVisible="False">
                <EditItemTemplate>
                    <asp:FileUpload ID="fuHeadImg" runat="server" />
                    <asp:Image ID="imgHead" runat="server" Visible='<%# globalFunctions.hasValue(Eval("sHeaderFile")) %>'
                        Width="500px" ImageUrl='<%# globalFunctions.FixedImageUrl(Eval("sHeaderFile"),Eval("sMainDomain")) %>' />
                    <asp:CheckBox ID="cbRemoveHeadImg" runat="server" Text="הסר תמונה" Visible='<%# globalFunctions.hasValue(Eval("sHeaderFile")) %>' />
                    <asp:HiddenField ID="hfHeadImg" runat="server" Value='<%# Eval("sHeaderFile") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox4" runat="server" Text='<%# Bind("sHeaderFile") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label4" runat="server" Text='<%# Bind("sHeaderFile") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" SortExpression="sBGImageFile"
                InsertVisible="False">
                <HeaderTemplate>
                    רקע לטבלא ראשית
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:FileUpload ID="fuMainBgImg" runat="server" /><br />
                    <asp:Image ID="imgMainBg" runat="server" Height="200px" Visible='<%# globalFunctions.hasValue(Eval("sMainBgFile")) %>'
                        Width="200px" ImageUrl='<%# globalFunctions.FixedImageUrl(Eval("sMainBgFile"),Eval("sMainDomain")) %>' /><br />
                    <asp:CheckBox ID="cbRemoveMainBg" runat="server" Text="הסר תמונה" Visible='<%# globalFunctions.hasValue(Eval("sMainBgFile")) %>' />
                    <asp:HiddenField ID="hfMainBg" runat="server" Value='<%# Eval("sMainBgFile") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="tbMbgf" runat="server" Text='<%# Bind("sMainBgFile") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblMbgf" runat="server" Text='<%# Bind("sMainBgFile") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="טמפלייט" SortExpression="sTemplate">
                <EditItemTemplate>
                    <asp:DropDownList ID="ddlTemplate" runat="server" SelectedValue='<%# Bind("sTemplate") %>'
                        DataSourceID="sdsTemplates" DataTextField="tName" DataValueField="id">
                        <asp:ListItem Value="1">ימין</asp:ListItem>
                        <asp:ListItem Value="2">מרכז</asp:ListItem>
                        <asp:ListItem Value="0">לא נבחר</asp:ListItem>
                    </asp:DropDownList>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:DropDownList ID="ddlTemplate" runat="server" SelectedValue='<%# Bind("sTemplate") %>'
                        DataSourceID="sdsTemplates" DataTextField="tName" DataValueField="id" Enabled="False">
                        <asp:ListItem Value="1">ימין</asp:ListItem>
                        <asp:ListItem Value="2">מרכז</asp:ListItem>
                        <asp:ListItem Value="0">לא נבחר</asp:ListItem>
                    </asp:DropDownList>
                </ItemTemplate>
                <InsertItemTemplate>
                    <asp:DropDownList ID="ddlTemplate" runat="server" SelectedValue='<%# Bind("sTemplate") %>'
                        DataSourceID="sdsTemplates" DataTextField="tName" DataValueField="id">
                        <asp:ListItem Value="1">ימין</asp:ListItem>
                        <asp:ListItem Value="2">מרכז</asp:ListItem>
                        <asp:ListItem Value="0">לא נבחר</asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="ReqValTemplate" runat="server" ControlToValidate="ddlTemplate"
                        InitialValue="0" ErrorMessage="*חובה"></asp:RequiredFieldValidator>
                </InsertItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="דף ראשי" SortExpression="sOpenPage" InsertVisible="False">
                <EditItemTemplate>
                    <asp:DropDownList ID="ddlOpenPage" runat="server" DataTextField="pname" DataValueField="id"
                        OnDataBinding="ddlOpenPage_DataBinding" SelectedValue='<%# Bind("sOpenPage") %>'>
                    </asp:DropDownList>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:DropDownList ID="ddlOpenPage" runat="server" DataTextField="pname" DataValueField="id"
                        OnDataBinding="ddlOpenPage_DataBinding" SelectedValue='<%# Bind("sOpenPage") %>'>
                    </asp:DropDownList>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:DropDownList ID="ddlOpenPage" runat="server" DataTextField="pname" DataValueField="id"
                        OnDataBinding="ddlOpenPage_DataBinding" SelectedValue='<%# Bind("sOpenPage") %>'>
                    </asp:DropDownList>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="דף ראשי בסלולאר" SortExpression="sMobileFirstPage" InsertVisible="False">
                <EditItemTemplate>
                    <asp:DropDownList ID="ddlOpenMobiPage" runat="server" DataTextField="pname" DataValueField="id"
                        OnDataBinding="ddlOpenMobiPage_DataBinding" SelectedValue='<%# Bind("sMobileFirstPage") %>'>
                    </asp:DropDownList>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:DropDownList ID="ddlOpenMobiPage" runat="server" DataTextField="pname" DataValueField="id"
                        OnDataBinding="ddlOpenMobiPage_DataBinding" SelectedValue='<%# Bind("sMobileFirstPage") %>'>
                    </asp:DropDownList>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:DropDownList ID="ddlOpenMobiPage" runat="server" DataTextField="pname" DataValueField="id"
                        OnDataBinding="ddlOpenMobiPage_DataBinding" SelectedValue='<%# Bind("sMobileFirstPage") %>'>
                    </asp:DropDownList>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField>
                <HeaderTemplate>
                    <u>קידום במנועי חיפוש</u>
                </HeaderTemplate>
            </asp:TemplateField>
           <%-- <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="כותרת ברירת מחדל"
                SortExpression="sSeoDefaultTitle">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox3" runat="server" Text='<%# Bind("sSeoDefaultTitle") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox5" runat="server" Text='<%# Bind("sSeoDefaultTitle") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label5" runat="server" Text='<%# Bind("sSeoDefaultTitle") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="תיאור ברירת מחדל"
                SortExpression="sSeoDefaultDesc">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox20" runat="server" TextMode="MultiLine" SkinID="tboxMultiline3"
                        Text='<%# Bind("sSeoDefaultDesc") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox20" runat="server" TextMode="MultiLine" SkinID="tboxMultiline3"
                        Text='<%# Bind("sSeoDefaultDesc") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label20" runat="server" Text='<%# Bind("sSeoDefaultDesc") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="מילים ברירת מחדל"
                SortExpression="sSeoDefaultKeywords">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox19" runat="server" TextMode="MultiLine" SkinID="tboxMultiline3"
                        Text='<%# Bind("sSeoDefaultKeywords") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox19" runat="server" TextMode="MultiLine" SkinID="tboxMultiline3"
                        Text='<%# Bind("sSeoDefaultKeywords") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label19" runat="server" Text='<%# Bind("sSeoDefaultKeywords") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>--%>
            <asp:TemplateField>
                <HeaderTemplate>
                </HeaderTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="קוד אנליטיקס" SortExpression="sGoogleAnalitics"
                InsertVisible="False">
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="TextBox7" runat="server"
                        TextMode="MultiLine" SkinID="tboxMultiline3" Text='<%# Bind("sGoogleAnalitics") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="TextBox7" runat="server"
                        TextMode="MultiLine" SkinID="tboxMultiline3" Text='<%# Bind("sGoogleAnalitics") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label7" runat="server" Text='<%# Bind("sGoogleAnalitics") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="טקסט לפוטר" SortExpression="sFooterText"
                InsertVisible="False">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox8" runat="server" TextMode="MultiLine" SkinID="tboxMultiline3"
                        Text='<%# Bind("sFooterText") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox8" runat="server" TextMode="MultiLine" SkinID="tboxMultiline3"
                        Text='<%# Bind("sFooterText") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label8" runat="server" Text='<%# Bind("sFooterText") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="לוגו\תמונה תחתונה"
                SortExpression="sFooterLogoFile" InsertVisible="False">
                <EditItemTemplate>
                    <asp:FileUpload ID="fuLogoFooterImg" runat="server" />
                    <asp:Image ID="imgLogoFooter" runat="server" Visible='<%# globalFunctions.hasValue(Eval("sFooterLogoFile")) %>'
                        Width="200px" Height="200px" ImageUrl='<%# globalFunctions.FixedImageUrl(Eval("sFooterLogoFile"),Eval("sMainDomain")) %>' />
                    <asp:CheckBox ID="cbRemoveLogoFooterImg" runat="server" Text="הסר תמונה" Visible='<%# globalFunctions.hasValue(Eval("sFooterLogoFile")) %>' />
                    <asp:HiddenField ID="hfLogoFooterImg" runat="server" Value='<%# Eval("sFooterLogoFile") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox9" runat="server" Text='<%# Bind("sFooterLogoFile") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label9" runat="server" Text='<%# Bind("sFooterLogoFile") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField ConvertEmptyStringToNull="False" DataField="sFooterLogoAlt" HeaderText="תיאור לוגו לפוטר"
                SortExpression="sFooterLogoAlt" InsertVisible="False">
                <ControlStyle Width="500px" />
            </asp:BoundField>
            <asp:TemplateField InsertVisible="False">
                <HeaderTemplate>
                    <u>עיצובים</u>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:CheckBox runat="server" ID="btnReloadDefaultSettings" Text="אזהרה: מוחק כל עיצוב קיים וכן טקסט מבזקים וחדשות!"
                        onclick="return confirm('אשר טעינת ברירות מחדל');" Checked='<%# Bind("LoadDefaultSiteSettings") %>' /><br />
                    *מתעלם מכל שינוי עיצוב שיוכנסו בשמירה זו.
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" SortExpression="sStyle" InsertVisible="False">
                <HeaderTemplate>
                    עיצובים כלליים <span class="styles">כאן שמים את כל מה שאין לו הגדרה במקום אחר</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="TextBox17" SkinID="tboxMultiline10X800"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sStyle") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="TextBox17" SkinID="tboxMultiline10X800"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sStyle") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label17" runat="server" Text='<%# Bind("sStyle") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" SortExpression="sStyle" InsertVisible="False">
                <HeaderTemplate>
                    עיצוב טבלא ראשית <span class="styles">#Main</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tbMainStl" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sMainStyle") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tbMainStl" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sMainStyle") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lbMainStl" runat="server" Text='<%# Bind("sMainStyle") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" SortExpression="sBodyStyle" InsertVisible="False">
                <HeaderTemplate>
                    עיצוב <span class="styles">body</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxBody" SkinID="tboxMultiline10X800"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sBodyStyle") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxBody" SkinID="tboxMultiline10X800"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sBodyStyle") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblBody" runat="server" Text='<%# Bind("sBodyStyle") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" SortExpression="sLinkStyle" InsertVisible="False">
                <HeaderTemplate>
                    עיצוב לינקים\קישורים <span class="styles">a</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="TextBox18" runat="server"
                        Text='<%# Bind("sLinkStyle") %>' onchange="this.style=this.text"></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="TextBox18" runat="server"
                        Text='<%# Bind("sLinkStyle") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label18" runat="server" Text='<%# Bind("sLinkStyle") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField InsertVisible="False">
                <HeaderTemplate>
                    <u>סרגלים וכפתורים</u>
                </HeaderTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" SortExpression="sRightNavStyle"
                InsertVisible="False">
                <HeaderTemplate>
                    עיצוב בר ימין <span class="styles">.RNavCont</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxRNavContStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sRightNavStyle") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxRNavContStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sRightNavStyle") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblRNavContStyle" runat="server" Text='<%# Bind("sRightNavStyle") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="רקע תמונה לבר ימני"
                SortExpression="sRightNavBGImage" InsertVisible="False">
                <EditItemTemplate>
                    <asp:FileUpload ID="fuRNavBGImage" runat="server" />
                    <asp:Image ID="imgRNavBGImage" runat="server" Visible='<%# globalFunctions.hasValue(Eval("sRightNavBGImage")) %>'
                        Width="200px" Height="200px" ImageUrl='<%# globalFunctions.FixedImageUrl(Eval("sRightNavBGImage"),Eval("sMainDomain")) %>' />
                    <asp:CheckBox ID="cbRemoveRNavBGImage" runat="server" Text="הסר תמונה" Visible='<%# globalFunctions.hasValue(Eval("sRightNavBGImage")) %>' />
                    <asp:HiddenField ID="hfRNavBGImage" runat="server" Value='<%# Eval("sRightNavBGImage") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="tboxRNavBGImage" runat="server" Text='<%# Bind("sRightNavBGImage") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblRNavBGImage" runat="server" Text='<%# Bind("sRightNavBGImage") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" SortExpression="sRNavStyle" InsertVisible="False">
                <HeaderTemplate>
                    עיצוב כפתורי בר ימין <span class="styles">.RNav a, .RNav a:link</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxRNavStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sRNavStyle") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxRNavStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sRNavStyle") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblRNavStyle" runat="server" Text='<%# Bind("sRNavStyle") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="תמונת רקע לכפתור בר ימין"
                SortExpression="sRNavBG" InsertVisible="False">
                <EditItemTemplate>
                    <asp:FileUpload ID="fuRNavButtonBG" runat="server" />
                    <asp:Image ID="imgRNavButtonBG" runat="server" Visible='<%# globalFunctions.hasValue(Eval("sRNavBG")) %>'
                        Width="200px" Height="200px" ImageUrl='<%# globalFunctions.FixedImageUrl(Eval("sRNavBG"),Eval("sMainDomain")) %>' />
                    <asp:CheckBox ID="cbRemoveRNavButtonBG" runat="server" Text="הסר תמונה" Visible='<%# globalFunctions.hasValue(Eval("sRNavBG")) %>' />
                    <asp:HiddenField ID="hfRNavButtonBG" runat="server" Value='<%# Eval("sRNavBG") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="tboxRNavButtonBG" runat="server" Text='<%# Bind("sRNavBG") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblRNavButtonBG" runat="server" Text='<%# Bind("sRNavBG") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" SortExpression="sUNavStyle" InsertVisible="False">
                <HeaderTemplate>
                    עיצוב כפתורי בר עליון <span class="styles">#navbar a, #navbar a:link, #navbar a:visited</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxUNavStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sUNavStyle") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxUNavStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sUNavStyle") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblUNavStyle" runat="server" Text='<%# Bind("sUNavStyle") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="תמונת רקע לכפתור בר עליון"
                SortExpression="sUNavBG" InsertVisible="False">
                <EditItemTemplate>
                    <asp:FileUpload ID="fuUNavButtonBG" runat="server" />
                    <asp:Image ID="imgUNavButtonBG" runat="server" Visible='<%# globalFunctions.hasValue(Eval("sUNavBG")) %>'
                        Width="200px" Height="200px" ImageUrl='<%# globalFunctions.FixedImageUrl(Eval("sUNavBG"),Eval("sMainDomain")) %>' />
                    <asp:CheckBox ID="cbRemoveUNavButtonBG" runat="server" Text="הסר תמונה" Visible='<%# globalFunctions.hasValue(Eval("sUNavBG")) %>' />
                    <asp:HiddenField ID="hfUNavButtonBG" runat="server" Value='<%# Eval("sUNavBG") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="tboxUNavBGImage" runat="server" Text='<%# Bind("sUNavBG") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblUNavBGImage" runat="server" Text='<%# Bind("sUNavBG") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" SortExpression="sBNavStyle" InsertVisible="False">
                <HeaderTemplate>
                    עיצוב כפתורי בר תחתון <span class="styles">.BNav</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxBNavStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sBNavStyle") %>'></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" SortExpression="sRNavHoverStyle"
                InsertVisible="False">
                <HeaderTemplate>
                    כפתורי בר ימני במעבר עכבר<span class="styles">.RNav a:hover</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxRNavHoverStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sRNavHoverStyle") %>'></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" SortExpression="sUNavHoverStyle"
                InsertVisible="False">
                <HeaderTemplate>
                    כפתורי בר עליון במעבר עכבר<span class="styles">#navbar a:hover</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxUNavHoverStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sUNavHoverStyle") %>'></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" SortExpression="sBNavHoverStyle"
                InsertVisible="False">
                <HeaderTemplate>
                    כפתורי בר תחתון במעבר עכבר<span class="styles">.BNav a:Hover</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxBNavHoverStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sBNavHoverStyle") %>'></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" SortExpression="sRSubNavStyle"
                InsertVisible="False">
                <HeaderTemplate>
                    כפתורי תת תפריט בר ימני<span class="styles">.RNav a.subMenu</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxRSubNavStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sRSubNavStyle") %>'></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" SortExpression="sUSubNavStyle"
                InsertVisible="False">
                <HeaderTemplate>
                    כפתורי תת תפריט בר עליון<span class="styles">.USubNavStyle</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxUSubNavStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sUSubNavStyle") %>'></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" InsertVisible="False" SortExpression="sRSubNavHoverStyle">
                <HeaderTemplate>
                    כפתורי תת תפריט בר ימני במעבר עכבר <span class="styles">.RNav a.subMenu:hover</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxRSNHS" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server"
                        Text='<%# Bind("sRSubNavHoverStyle") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label14" runat="server" Text='<%# Bind("sRSubNavHoverStyle") %>'></asp:Label>
                </ItemTemplate>
                
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" InsertVisible="False" SortExpression="sUSubNavHoverStyle">
                <HeaderTemplate>
                    כפתורי תת תפריט בר עליון במעבר עכבר <span class="styles">.USubNav:Hover</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxusnhs" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server"
                        Text='<%# Bind("sUSubNavHoverStyle") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label21" runat="server" Text='<%# Bind("sUSubNavHoverStyle") %>'></asp:Label>
                </ItemTemplate>
                
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" InsertVisible="False" SortExpression="sRNavSeperatorStyle">
                <HeaderTemplate>
                    עיצוב מפריד בר ימין <span class="styles">.RNavSeperatorStyle</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="TextBox6" runat="server"
                        Text='<%# Bind("sRNavSeperatorStyle") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label22" runat="server" Text='<%# Bind("sRNavSeperatorStyle") %>'></asp:Label>
                </ItemTemplate>
                
            </asp:TemplateField>
            <asp:BoundField ConvertEmptyStringToNull="False" DataField="sUNavSeperator" HeaderText="מפריד בר עליון"
                SortExpression="sUNavSeperator" InsertVisible="False">
                
            </asp:BoundField>
            <asp:TemplateField ConvertEmptyStringToNull="False" SortExpression="sNewsTextStyle"
                InsertVisible="False">
                <HeaderTemplate>
                    עיצוב טקסט מבזקים <span class="styles">.NewsTextStyle</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxNewsTextStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sNewsTextStyle") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxNewsTextStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sNewsTextStyle") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblNewsTextStyle" runat="server" Text='<%# Bind("sNewsTextStyle") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" InsertVisible="False" SortExpression="sNewsSeperatorStyle">
                <HeaderTemplate>
                    עיצוב מפריד מבזקים <span class="styles">.NewsSeperatorStyle</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="TextBoxnss" runat="server"
                        Text='<%# Bind("sNewsSeperatorStyle") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label23" runat="server" Text='<%# Bind("sNewsSeperatorStyle") %>'></asp:Label>
                </ItemTemplate>
                
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" InsertVisible="False" SortExpression="sNewsBorderStyle">
                <HeaderTemplate>
                    עיצוב גבול מבזקים <span class="styles">.NewsBorderStyle</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxnbs" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server"
                        Text='<%# Bind("sNewsBorderStyle") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label24" runat="server" Text='<%# Bind("sNewsBorderStyle") %>'></asp:Label>
                </ItemTemplate>
                
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" SortExpression="sNewsHeaderStyle"
                InsertVisible="False">
                <HeaderTemplate>
                    עיצוב כותרת מבזקים <span class="styles">.NewsHeaderStyle</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxNewsHeadStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sNewsHeaderStyle") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxNewsHeadStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sNewsHeaderStyle") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblNewsHeadStyle" runat="server" Text='<%# Bind("sNewsHeaderStyle") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField ConvertEmptyStringToNull="False" DataField="sNewsHeaderText" HeaderText="טקסט לכותרת מבזקים"
                SortExpression="sNewsHeaderText" InsertVisible="False">
                <ControlStyle Width="250px" />
            </asp:BoundField>
            <asp:BoundField ConvertEmptyStringToNull="False" DataField="sContactUsHeadText" HeaderText="טקסט לכותרת צור קשר"
                SortExpression="sContactUsHeadText" InsertVisible="False">
                <ControlStyle Width="250px" />
            </asp:BoundField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="טקסט לפוטר של צור קשר"
                SortExpression="sContactFooterText" InsertVisible="False">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox12" runat="server" Text='<%# Bind("sContactFooterText") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox12" runat="server" Text='<%# Bind("sContactFooterText") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label12" runat="server" Text='<%# Eval("sContactFooterText") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" InsertVisible="False" SortExpression="sContactUsHeadStyle">
                <HeaderTemplate>
                    עיצוב לכותרת צור קשר <span class="styles">.cuHead</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="TextBox14" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server"
                        Text='<%# Bind("sContactUsHeadStyle") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label25" runat="server" Text='<%# Bind("sContactUsHeadStyle") %>'></asp:Label>
                </ItemTemplate>
                
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" InsertVisible="False" SortExpression="sContactUsFooterStyle">
                <HeaderTemplate>
                    עיצוב לפוטר צור קשר <span class="styles">.cuFoot</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="TextBox21" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server"
                        Text='<%# Bind("sContactUsFooterStyle") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label26" runat="server" Text='<%# Bind("sContactUsFooterStyle") %>'></asp:Label>
                </ItemTemplate>
                
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" SortExpression="sContactUsStyle"
                InsertVisible="False">
                <HeaderTemplate>
                    עיצוב צור קשר <span class="styles"></span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxCUStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sContactUsStyle") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxCUStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sContactUsStyle") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:TextBox ID="tboxCUStyle" runat="server" Text='<%# Bind("sContactUsStyle") %>'></asp:TextBox>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" InsertVisible="False" SortExpression="sSendButtonStyle">
                <HeaderTemplate>
                    עיצוב כפתור בסיסי <span class="styles">.btn</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="TextBox22" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server"
                        Text='<%# Bind("sSendButtonStyle") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label27" runat="server" Text='<%# Bind("sSendButtonStyle") %>'></asp:Label>
                </ItemTemplate>
                
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" SortExpression="sTextContStyle"
                InsertVisible="False">
                <HeaderTemplate>
                    עיצוב מכיל הטקסט בדפים <span class="styles">.innerDiv</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxTextCont" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sTextContStyle") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxTextCont" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sTextContStyle") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblTextCont" runat="server" Text='<%# Bind("sTextContStyle") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" SortExpression="sH1BG" InsertVisible="False">
                <HeaderTemplate>
                    רקע למכיל הטקסט
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:FileUpload ID="fuTextContBG" runat="server" />
                    <asp:Image ID="imgTextContBG" runat="server" Height="300px" Visible='<%# globalFunctions.hasValue(Eval("sTextContBG")) %>'
                        Width="300px" ImageUrl='<%# globalFunctions.FixedImageUrl(Eval("sTextContBG"),Eval("sMainDomain")) %>' />
                    <asp:CheckBox ID="cbRemoveTextContBG" runat="server" Text="הסר תמונה" Visible='<%# globalFunctions.hasValue(Eval("sTextContBG")) %>' />
                    <asp:HiddenField ID="hfTextContBG" runat="server" Value='<%# Eval("sTextContBG") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="tboxTextContBG" runat="server" Text='<%# Bind("sTextContBG") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblTextContBG" runat="server" Text='<%# Bind("sTextContBG") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" SortExpression="sInnerStyle"
                InsertVisible="False">
                <HeaderTemplate>
                    עיצוב לטקסט בדפים <span class="styles">.InnerStyle</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxTextStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sInnerStyle") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxTextStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sInnerStyle") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblStyle" runat="server" Text='<%# Bind("sInnerStyle") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField InsertVisible="False">
                <HeaderTemplate>
                    <u>כותרות</u>
                </HeaderTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" InsertVisible="False" SortExpression="sH2">
                <HeaderTemplate>
                    ראשיות <span class="styles">H1</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="TextBoxH1" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server"
                        Text='<%# Bind("sH1") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label28" runat="server" Text='<%# Bind("sH1") %>'></asp:Label>
                </ItemTemplate>
                
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="רקע לכותרות ראשיות"
                SortExpression="sH1BG" InsertVisible="False">
                <EditItemTemplate>
                    <asp:FileUpload ID="fuH1BGImg" runat="server" />
                    <asp:Image ID="imgH1BGImg" runat="server" Height="300px" Visible='<%# globalFunctions.hasValue(Eval("sH1BG")) %>'
                        Width="300px" ImageUrl='<%# globalFunctions.FixedImageUrl(Eval("sH1BG"),Eval("sMainDomain")) %>' />
                    <asp:CheckBox ID="cbRemovesH1BGBGImg" runat="server" Text="הסר תמונה" Visible='<%# globalFunctions.hasValue(Eval("sH1BG")) %>' />
                    <asp:HiddenField ID="hfH1BGImg" runat="server" Value='<%# Eval("sH1BG") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="tboxH1BGImg" runat="server" Text='<%# Bind("sH1BG") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblH1BGImg" runat="server" Text='<%# Bind("sH1BG") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" InsertVisible="False" SortExpression="sH2">
                <HeaderTemplate>
                    משניות <span class="styles">H2</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="TextBox23" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server"
                        Text='<%# Bind("sH2") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="LabelH2" runat="server" Text='<%# Bind("sH2") %>'></asp:Label>
                </ItemTemplate>
                
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" InsertVisible="False" SortExpression="sH3">
                <HeaderTemplate>
                    שלישיות <span class="styles">H3</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="TextBox24" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server"
                        Text='<%# Bind("sH3") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label29" runat="server" Text='<%# Bind("sH3") %>'></asp:Label>
                </ItemTemplate>
                
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" InsertVisible="False" SortExpression="sH4">
                <HeaderTemplate>
                    רביעיות <span class="styles">H4</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="TextBox25" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server"
                        Text='<%# Bind("sH4") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label30" runat="server" Text='<%# Bind("sH4") %>'></asp:Label>
                </ItemTemplate>
                
            </asp:TemplateField>
            <asp:TemplateField HeaderText="4 מבנים לא בשימוש"></asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" SortExpression="sRecipteStyle"
                InsertVisible="False">
                <HeaderTemplate>
                    דפי מתכון <span class="styles">מקום כללי לעיצוב מתכונים</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxRecipeStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sRecipteStyle") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxRecipeStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sRecipteStyle") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="tboxRecipeStyle" runat="server" Text='<%# Eval("sRecipteStyle") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" SortExpression="sEventStyle"
                InsertVisible="False">
                <HeaderTemplate>
                    דפי סדנה <span class="styles">מקום כללי לעיצוב סדנאות</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxEventStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sEventStyle") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxEventStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sEventStyle") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="tboxEventStyle" runat="server" Text='<%# Eval("sEventStyle") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" SortExpression="sContactStyle"
                InsertVisible="False">
                <HeaderTemplate>
                    דף צור קשר <span class="styles">מקום כללי לעיצוב צור קשר</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxContactStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sContactStyle") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxContactStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sContactStyle") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="tboxContactStyle" runat="server" Text='<%# Eval("sContactStyle") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" SortExpression="sTablesStyles"
                InsertVisible="False">
                <HeaderTemplate>
                    הגדרות טבלא <span class="styles">מקום כללי לעיצוב טבלאות</span>
                </HeaderTemplate>
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxTableStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sTablesStyles") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxTableStyle" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sTablesStyles") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="tboxTableStyle" runat="server" Text='<%# Eval("sTablesStyles") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="רקע לטקסט בדפים"
                SortExpression="sInnerBGTextImage" InsertVisible="False">
                <EditItemTemplate>
                    <asp:FileUpload ID="fuInnerBGImg" runat="server" />
                    <asp:Image ID="imgInnerBG" runat="server" Height="300px" Visible='<%# globalFunctions.hasValue(Eval("sInnerBGTextImage")) %>'
                        Width="300px" ImageUrl='<%# globalFunctions.FixedImageUrl(Eval("sInnerBGTextImage"),Eval("sMainDomain")) %>' />
                    <asp:CheckBox ID="cbRemoveInnerBGImg" runat="server" Text="הסר תמונה" Visible='<%# globalFunctions.hasValue(Eval("sInnerBGTextImage")) %>' />
                    <asp:HiddenField ID="hfInnerBGImg" runat="server" Value='<%# Eval("sInnerBGTextImage") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox10" runat="server" Text='<%# Bind("sInnerBGTextImage") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label10" runat="server" Text='<%# Bind("sInnerBGTextImage") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField InsertVisible="False">
                <HeaderTemplate>
                    עיצוב לוחות שנה
                </HeaderTemplate>
            </asp:TemplateField>
            <asp:BoundField InsertVisible="False" ConvertEmptyStringToNull="False" DataField="sCalHeadBgColor"
                HeaderText="רקע לכותרת" SortExpression="sCalHeadBgColor" />
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="צבע הקודם\הבא" InsertVisible="False"
                SortExpression="sCalNextPrevColor">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox26" runat="server" Text='<%# Bind("sCalNextPrevColor") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label31" runat="server" Text='<%# Bind("sCalNextPrevColor") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="צבע רקע יש תוכן"
                InsertVisible="False" SortExpression="sCalHasItemBgColor">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox27" runat="server" Text='<%# Bind("sCalHasItemBgColor") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label32" runat="server" Text='<%# Bind("sCalHasItemBgColor") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField InsertVisible="False">
                <HeaderTemplate>
                    חנות
                </HeaderTemplate>
            </asp:TemplateField>
            <asp:TemplateField InsertVisible="false">
                <HeaderTemplate>
                    סוג החנות
                </HeaderTemplate>
                <InsertItemTemplate>
                    <asp:DropDownList runat="server" ID="ddlStoreType" SelectedValue='<%# Bind("sStoreType") %>'>
                        <asp:ListItem Value="0" Text="-- ללא חנות --" Selected="True"></asp:ListItem>
                        <asp:ListItem Value="1" Text="חנות ללא מכירה"></asp:ListItem>
                        <asp:ListItem Value="2" Text="חנות עם מכירה"></asp:ListItem>
                    </asp:DropDownList>
                </InsertItemTemplate>
                <EditItemTemplate>
                    <asp:DropDownList runat="server" ID="ddlStoreType" SelectedValue='<%# Bind("sStoreType") %>'>
                        <asp:ListItem Value="0" Text="-- ללא חנות --"></asp:ListItem>
                        <asp:ListItem Value="1" Text="חנות ללא מכירה"></asp:ListItem>
                        <asp:ListItem Value="2" Text="חנות עם מכירה"></asp:ListItem>
                    </asp:DropDownList>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:DropDownList runat="server" ID="ddlStoreType" SelectedValue='<%# Bind("sStoreType") %>'
                        Enabled="false">
                        <asp:ListItem Value="0" Text="-- ללא חנות --"></asp:ListItem>
                        <asp:ListItem Value="1" Text="חנות ללא מכירה"></asp:ListItem>
                        <asp:ListItem Value="2" Text="חנות עם מכירה"></asp:ListItem>
                    </asp:DropDownList>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="טקסט תצוגה בסיום קניה וקוד תודה" InsertVisible="false">
                <InsertItemTemplate>
                    <asp:TextBox runat="server" ID="tboxSaleThanks" SkinID="tboxMultiline3" TextMode="MultiLine"
                        Text='<%# Bind("sSaleThanksText") %>'></asp:TextBox>
                </InsertItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox runat="server" ID="tboxSaleThanks" SkinID="tboxMultiline3" TextMode="MultiLine"
                        Text='<%# Bind("sSaleThanksText") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:TextBox runat="server" ID="tboxSaleThanks" SkinID="tboxMultiline3" TextMode="MultiLine"
                        Text='<%# Eval("sSaleThanksText") %>' Enabled="false"></asp:TextBox>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="מיקום כפתור סל" InsertVisible="false">
                <InsertItemTemplate>
                    <asp:DropDownList runat="server" ID="ddlBasketPlace" SelectedValue='<%# Bind("sBasketPlace") %>'>
                        <asp:ListItem Value="0" Text="לא מופיע"></asp:ListItem>
                        <asp:ListItem Value="1" Text="בדפי חנות בלבד"></asp:ListItem>
                        <asp:ListItem Value="2" Text="לא קיים עדיין"></asp:ListItem>
                    </asp:DropDownList>
                </InsertItemTemplate>
                <EditItemTemplate>
                    <asp:DropDownList runat="server" ID="ddlBasketPlace" SelectedValue='<%# Bind("sBasketPlace") %>'>
                        <asp:ListItem Value="0" Text="לא מופיע"></asp:ListItem>
                        <asp:ListItem Value="1" Text="בדפי חנות בלבד"></asp:ListItem>
                        <asp:ListItem Value="2" Text="לא קיים עדיין"></asp:ListItem>
                    </asp:DropDownList>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:DropDownList runat="server" ID="ddlBasketPlace" SelectedValue='<%# Bind("sBasketPlace") %>'>
                        <asp:ListItem Value="0" Text="לא מופיע"></asp:ListItem>
                        <asp:ListItem Value="1" Text="בדפי חנות בלבד"></asp:ListItem>
                        <asp:ListItem Value="2" Text="לא קיים עדיין"></asp:ListItem>
                    </asp:DropDownList>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField>
                <HeaderTemplate>
                    נתונים מ2eat
                </HeaderTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="קבל כתובת מכרטיסיה">
                <InsertItemTemplate>
                    <asp:CheckBox runat="server" ID="cboxToeatAddress" Checked='<%# Bind("stoeatAddress") %>'
                        OnInit="CBoxDefaultToChecked" />
                </InsertItemTemplate>
                <EditItemTemplate>
                    <asp:CheckBox runat="server" ID="cboxToeatAddress" Checked='<%# Bind("stoeatAddress") %>' />
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:CheckBox runat="server" ID="cboxToeatAddress" Enabled="false" Checked='<%# Eval("stoeatAddress") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="הצג כפתורי ביקורות">
                <InsertItemTemplate>
                    <asp:CheckBox runat="server" ID="cboxToeatCriticisem" Checked='<%# Bind("stoeatCriticisem") %>'
                        OnInit="CBoxDefaultToChecked" />
                </InsertItemTemplate>
                <EditItemTemplate>
                    <asp:CheckBox runat="server" ID="cboxToeatCriticisem" Checked='<%# Bind("stoeatCriticisem") %>' />
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:CheckBox runat="server" ID="cboxToeatCriticisem" Enabled="false" Checked='<%# Eval("stoeatCriticisem") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="הצג מאפיינים">
                <InsertItemTemplate>
                    <asp:CheckBox runat="server" ID="cboxToeatProps" Checked='<%# Bind("stoeatProperties") %>'
                        OnInit="CBoxDefaultToChecked" />
                </InsertItemTemplate>
                <EditItemTemplate>
                    <asp:CheckBox runat="server" ID="cboxToeatProps" Checked='<%# Bind("stoeatProperties") %>' />
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:CheckBox runat="server" ID="cboxToeatProps" Enabled="false" Checked='<%# Eval("stoeatProperties") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="הצג כתבות">
                <InsertItemTemplate>
                    <asp:CheckBox runat="server" ID="cboxToeatArts" Checked='<%# Bind("sToeatArts") %>'
                        OnInit="CBoxDefaultToChecked" />
                </InsertItemTemplate>
                <EditItemTemplate>
                    <asp:CheckBox runat="server" ID="cboxToeatArts" Checked='<%# Bind("sToeatArts") %>' />
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:CheckBox runat="server" ID="cboxToeatArts" Enabled="false" Checked='<%# Eval("sToeatArts") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="הצג מתכונים">
                <InsertItemTemplate>
                    <asp:CheckBox runat="server" ID="cboxToeatRecipes" Checked='<%# Bind("sToeatRecipes") %>'
                        OnInit="CBoxDefaultToChecked" />
                </InsertItemTemplate>
                <EditItemTemplate>
                    <asp:CheckBox runat="server" ID="cboxToeatRecipes" Checked='<%# Bind("sToeatRecipes") %>' />
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:CheckBox runat="server" ID="cboxToeatRecipes" Enabled="false" Checked='<%# Eval("sToeatRecipes") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="כפתורי 2eat: ביקורות, קופונים, TV">
                <InsertItemTemplate>
                    <asp:CheckBox runat="server" ID="cboxToeatButtons" Checked='<%# Bind("stoeatButtons") %>'
                        Text="הצג כפתורי 2eat אוטומטיים" OnInit="CBoxDefaultToChecked" />
                </InsertItemTemplate>
                <EditItemTemplate>
                    <asp:CheckBox runat="server" ID="cboxToeatButtons" Checked='<%# Bind("stoeatButtons") %>'
                        Text="הצג כפתורי 2eat אוטומטיים" />
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:CheckBox runat="server" ID="cboxToeatButtons" Enabled="false" Checked='<%# Eval("stoeatButtons") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="ClickATable">
                <InsertItemTemplate>
                    <asp:CheckBox runat="server" ID="cboxClickButtons" Checked='<%# Bind("sShowClickButtons") %>'
                        Text="כפתור הזמנת שולחן" OnInit="CBoxDefaultToChecked" />
                </InsertItemTemplate>
                <EditItemTemplate>
                    <asp:CheckBox runat="server" ID="cboxClickButtons" Checked='<%# Bind("sShowClickButtons") %>'
                        Text="כפתור הזמנת שולחן" />
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:CheckBox runat="server" ID="cboxClickButtons" Enabled="false" Checked='<%# Bind("sShowClickButtons") %>'
                        Text="כפתור הזמנת שולחן" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="כפתור חלופי להזמנת מקום"
                SortExpression="sAlterClickBtn" InsertVisible="False">
                <EditItemTemplate>
                    <asp:FileUpload ID="fuAltClick" runat="server" /><br />
                    <asp:Image ID="AltClick" runat="server" Height="200px" Visible='<%# globalFunctions.hasValue(Eval("sAlterClickBtn")) %>'
                        Width="200px" ImageUrl='<%# globalFunctions.FixedImageUrl(Eval("sAlterClickBtn"),Eval("sMainDomain")) %>' /><br />
                    <asp:CheckBox ID="cbRemoveAltClick" runat="server" Text="הסר תמונה" Visible='<%# globalFunctions.hasValue(Eval("sAlterClickBtn")) %>' />
                    <asp:HiddenField ID="hfAltClick" runat="server" Value='<%# Eval("sAlterClickBtn") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                </InsertItemTemplate>
                <ItemTemplate>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="פריים הזמנת מקום">
                <InsertItemTemplate>
                    <asp:CheckBox runat="server" ID="cboxAllowClickFrame" Checked='<%# Bind("sAllowClickInFrame") %>'
                        Text="מציג פריים מלא של הזמנת מקום כאשר מגיע מפרסום גוגל" OnInit="CBoxDefaultToChecked" />
                </InsertItemTemplate>
                <EditItemTemplate>
                    <asp:CheckBox runat="server" ID="cboxAllowClickFrame" Checked='<%# Bind("sAllowClickInFrame") %>'
                        Text="מציג פריים מלא של הזמנת מקום כאשר מגיע מפרסום גוגל" />
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:CheckBox runat="server" ID="cboxAllowClickFrame" Enabled="false" Checked='<%# Bind("sAllowClickInFrame") %>'
                        Text="מציג פריים מלא של הזמנת מקום כאשר מגיע מפרסום גוגל" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="מיקום כפתורים בסרגל">
                <InsertItemTemplate>
                    <asp:DropDownList runat="server" ID="ddlButtonPlace" SelectedValue='<%# Bind("stoeatButtonsPlace") %>'>
                        <asp:ListItem Value="1">סרגל ימין</asp:ListItem>
                        <asp:ListItem Value="2">סרגל עליון</asp:ListItem>
                    </asp:DropDownList>
                </InsertItemTemplate>
                <EditItemTemplate>
                    <asp:DropDownList runat="server" ID="ddlButtonPlace" SelectedValue='<%# Bind("stoeatButtonsPlace") %>'>
                        <asp:ListItem Value="1">סרגל ימין</asp:ListItem>
                        <asp:ListItem Value="2">סרגל עליון</asp:ListItem>
                    </asp:DropDownList>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:DropDownList runat="server" Enabled="false" ID="ddlButtonPlace" SelectedValue='<%# Bind("stoeatButtonsPlace") %>'>
                        <asp:ListItem Value="1">סרגל ימין</asp:ListItem>
                        <asp:ListItem Value="2">סרגל עליון</asp:ListItem>
                    </asp:DropDownList>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="פייסבוק"></asp:TemplateField>
            <asp:TemplateField HeaderText="סוג הלחצן" InsertVisible="false">
                <ItemTemplate>
                    <asp:DropDownList runat="server" ID="ddlFBType" SelectedValue='<%# Bind("sFBType") %>'
                        Enabled="false">
                        <asp:ListItem Value="0">אוהב</asp:ListItem>
                        <asp:ListItem Value="1">המלץ</asp:ListItem>
                        <asp:ListItem Value="2">אוהב קאונטר בלבד</asp:ListItem>
                        <asp:ListItem Value="3">ממליץ קאונטר בלבד</asp:ListItem>
                    </asp:DropDownList>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:DropDownList runat="server" ID="ddlFBType" SelectedValue='<%# Bind("sFBType") %>'>
                        <asp:ListItem Value="0">אוהב</asp:ListItem>
                        <asp:ListItem Value="1">המלץ</asp:ListItem>
                        <asp:ListItem Value="2">אוהב קאונטר בלבד</asp:ListItem>
                        <asp:ListItem Value="3">המלץ קאונטר בלבד</asp:ListItem>
                        <asp:ListItem Value="4">אוהב + תמונות</asp:ListItem>
                        <asp:ListItem Value="5">המלץ + תמונות</asp:ListItem>
                    </asp:DropDownList>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="מיקום הלחצן" InsertVisible="false">
                <ItemTemplate>
                    <asp:DropDownList runat="server" ID="ddlFBPlace" SelectedValue='<%# Bind("sFBPlace") %>'
                        Enabled="false">
                        <asp:ListItem Value="0">לא מציג כפתור</asp:ListItem>
                        <asp:ListItem Value="1">אזור עליון בשורה של קליק</asp:ListItem>
                        <asp:ListItem Value="2">אזור מאפייני 2eat</asp:ListItem>
                    </asp:DropDownList>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:DropDownList runat="server" ID="ddlFBPlace" SelectedValue='<%# Bind("sFBPlace") %>'>
                        <asp:ListItem Value="0">לא מציג כפתור</asp:ListItem>
                        <asp:ListItem Value="1">אזור עליון בשורה של קליק</asp:ListItem>
                        <asp:ListItem Value="2">אזור מאפייני 2eat</asp:ListItem>
                    </asp:DropDownList>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:BoundField InsertVisible="False" DataField="sFBAdmins" HeaderText="זהויות מנהלים בפייסבוק מופרדות בפסיקים" />
            <asp:BoundField DataField="sFBWidth" HeaderText="רוחב הכפתור והכיתוב" InsertVisible="false" />
            <asp:CheckBoxField DataField="sFBEachPageLike" HeaderText="לייק לכל דף" SortExpression="sFBEachPageLike"
                Text="יוצר לייק שונה לכל דף באתר, מיועד לאתרים גדולים בלבד." InsertVisible="false" />
            <asp:TemplateField HeaderText="לייק לדף חיצוני" InsertVisible="false">
                <InsertItemTemplate>
                    <asp:TextBox runat="server" ID="tboxsFBLikeUrl" SkinID="tboxMultiline3" TextMode="MultiLine"
                        Text='<%# Bind("sFBLikeUrl") %>'></asp:TextBox>
                </InsertItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox runat="server" ID="tboxsFBLikeUrl" SkinID="tboxMultiline3" TextMode="MultiLine"
                        Text='<%# Bind("sFBLikeUrl") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:TextBox runat="server" ID="tboxsFBLikeUrl" SkinID="tboxMultiline3" TextMode="MultiLine"
                        Text='<%# Eval("sFBLikeUrl") %>' Enabled="false"></asp:TextBox>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:CheckBoxField DataField="sShowCaptchaOnContactForms" HeaderText="חייב קפצ'ה בכל סוגי צור קשר באתר" />
            

            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="HTML להוספה בסוף טור ימני"
                SortExpression="srNavFooterHtml" InsertVisible="False">
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxsrNavFooterHtml"
                        runat="server" Text='<%# Bind("srNavFooterHtml") %>' SkinID="tboxMultiline3"
                        TextMode="multiLine"></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxsrNavFooterHtml"
                        runat="server" Text='<%# Bind("srNavFooterHtml") %>' SkinID="tboxMultiline3"
                        TextMode="multiLine"></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblContactThankCode" runat="server" Text='<%# Eval("srNavFooterHtml") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>

           <%-- <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="תוספת HTML בתחילת BODY"
                SortExpression="srNavFooterHtml" InsertVisible="False">
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxAddTB"
                        runat="server" Text='<%# Bind("sAddHtmlTopBody") %>' SkinID="tboxMultiline3"
                        TextMode="multiLine"></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxAddTB"
                        runat="server" Text='<%# Bind("sAddHtmlTopBody") %>' SkinID="tboxMultiline3"
                        TextMode="multiLine"></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lbltboxAddTB" runat="server" Text='<%# Eval("sAddHtmlTopBody") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>--%>

            <asp:CheckBoxField DataField="sShowContactUs" HeaderText="הצג רכיב צור קשר בכל האתר"
                SortExpression="sShowContactUs" />
            <asp:TemplateField HeaderText ="מיקום טופס צור קשר בדפי האתר">
                <EditItemTemplate>
                     <asp:DropDownList runat="server" ID="ddlCFPlace" AppendDataBoundItems="True" SelectedValue='<%# Bind("sContactFormPlace") %>'>
                        <asp:ListItem Value="0" Text="סרגל ימין"></asp:ListItem>
                         <asp:ListItem Value="1" Text="סרגל תחתון"></asp:ListItem>
                    </asp:DropDownList>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:DropDownList runat="server" ID="ddlCFPlace" AppendDataBoundItems="True" SelectedValue='<%# Bind("sContactFormPlace") %>'>
                        <asp:ListItem Value="0" Text="סרגל ימין"></asp:ListItem>
                         <asp:ListItem Value="1" Text="סרגל תחתון"></asp:ListItem>
                    </asp:DropDownList>
                </InsertItemTemplate>
                <ItemTemplate>
                     <asp:DropDownList runat="server" ID="ddlCFPlace" AppendDataBoundItems="True" SelectedValue='<%# Bind("sContactFormPlace") %>' Enabled="false">
                        <asp:ListItem Value="0" Text="סרגל ימין"></asp:ListItem>
                         <asp:ListItem Value="1" Text="סרגל תחתון"></asp:ListItem>
                    </asp:DropDownList>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="אימייל ברירת מחדל לצור קשר"
                SortExpression="sDefaultContactEmail">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox11" runat="server" Text='<%# Bind("sDefaultContactEmail") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox11" runat="server" Text='<%# Bind("sDefaultContactEmail") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label11" runat="server" Text='<%# Bind("sDefaultContactEmail") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="טקסט תודה וקוד המרה לרכיב צור קשר בכל האתר"
                SortExpression="sContactThankCode" InsertVisible="False">
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxContactThankCode"
                        runat="server" Text='<%# Bind("sContactThankCode") %>' SkinID="tboxMultiline3"
                        TextMode="multiLine"></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxContactThankCode"
                        runat="server" Text='<%# Bind("sContactThankCode") %>' SkinID="tboxMultiline3"
                        TextMode="multiLine"></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblContactThankCode" runat="server" Text='<%# Eval("sContactThankCode") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="טקסט תודה וקוד תודה  ב&#34;מ לדף מסוג צור קשר"
                SortExpression="sContactThankCode" InsertVisible="False">
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxCpdtc" runat="server"
                        Text='<%# Bind("sContactPageDefThankCode") %>' SkinID="tboxMultiline3" TextMode="multiLine"></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxCpdtc" runat="server"
                        Text='<%# Bind("sContactPageDefThankCode") %>' SkinID="tboxMultiline3" TextMode="multiLine"></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="tboxCpdtc" runat="server" Text='<%# Eval("sContactPageDefThankCode") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="טקסט תודה וקוד תודה  ליוצרים קשר בטופס בתוך סדנא\מופע"
                SortExpression="sContactThankCode" InsertVisible="False">
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxCetc" runat="server"
                        Text='<%# Bind("sContactEventThankCode") %>' SkinID="tboxMultiline3" TextMode="multiLine"></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxCetc" runat="server"
                        Text='<%# Bind("sContactEventThankCode") %>' SkinID="tboxMultiline3" TextMode="multiLine"></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="tboxCetc" runat="server" Text='<%# Eval("sContactEventThankCode") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="טקסט תודה וקוד תודה לרישום סדנה ללא תשלום"
                SortExpression="sContactThankCode" InsertVisible="False">
                <EditItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxErtc" runat="server"
                        Text='<%# Bind("sEventRegisterThankCode") %>' SkinID="tboxMultiline3" TextMode="multiLine"></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox Style="direction: ltr; text-align: left;" ID="tboxErtc" runat="server"
                        Text='<%# Bind("sEventRegisterThankCode") %>' SkinID="tboxMultiline3" TextMode="multiLine"></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="tboxErtc" runat="server" Text='<%# Eval("sEventRegisterThankCode") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="אימייל להזמנות" SortExpression="sOrderEmail"
                InsertVisible="False">
                <EditItemTemplate>
                    <asp:TextBox ID="tboxOEmail" runat="server" Text='<%# Bind("sOrderEmail") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="tboxOEmail" runat="server" Text='<%# Bind("sOrderEmail") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblEmail" runat="server" Text='<%# Eval("sOrderEmail") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="הגבלות לביצוע הזמנה"
                SortExpression="sOrderRules" InsertVisible="False">
                <EditItemTemplate>
                    <asp:TextBox ID="tboxORules" runat="server" Text='<%# Bind("sOrderRules") %>' SkinID="tboxMultiline10X800"
                        TextMode="multiLine"></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="tboxORules" runat="server" Text='<%# Bind("sOrderRules") %>' SkinID="tboxMultiline10X800"
                        TextMode="multiLine"></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblORules" runat="server" Text='<%# Eval("sOrderRules") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="תקנון לתצוגה באישור רכישה"
                SortExpression="sOrderRules" InsertVisible="False">
                <EditItemTemplate>
                    <asp:TextBox ID="tboxStoreRedulations" runat="server" Text='<%# Bind("sStoreRegulations") %>'
                        SkinID="tboxMultiline10X800" TextMode="multiLine"></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="tboxStoreRedulations" runat="server" Text='<%# Bind("sStoreRegulations") %>'
                        SkinID="tboxMultiline10X800" TextMode="multiLine"></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblStoreRedulations" runat="server" Text='<%# Eval("sStoreRegulations") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:CheckBoxField DataField="sShowAccessButtons" Text="הצג כפתורי נגישות באתר" />
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="הצהרת נגישות לאתר"
                SortExpression="sSiteAccessDeclare" InsertVisible="False">
                <EditItemTemplate>
                    <asp:TextBox ID="tboxASD" runat="server" Text='<%# Bind("sSiteAccessDeclare") %>'
                        SkinID="tboxMultiline10X800" TextMode="multiLine"></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="tboxASD" runat="server" Text='<%# Bind("sSiteAccessDeclare") %>'
                        SkinID="tboxMultiline10X800" TextMode="multiLine"></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="tboxASD" runat="server" Text='<%# Eval("sSiteAccessDeclare") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            
            
            <asp:TemplateField HeaderText="תוספות לheader של ה html" InsertVisible="false">
                <InsertItemTemplate>
                    <asp:TextBox runat="server" Style="direction: ltr;" ID="tboxsHCode" SkinID="tboxMultiline10X800"
                        TextMode="MultiLine" Text='<%# Bind("sHeaderCode") %>'></asp:TextBox>
                </InsertItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox runat="server" ID="tboxsHCode" Style="direction: ltr;" SkinID="tboxMultiline10X800"
                        TextMode="MultiLine" Text='<%# Bind("sHeaderCode") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:TextBox runat="server" ID="tboxsHCode" SkinID="tboxMultiline10X800" TextMode="MultiLine"
                        Text='<%# Eval("sHeaderCode") %>' Enabled="false"></asp:TextBox>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="HTML חופשי בתחילת ה body" InsertVisible="false">
                <InsertItemTemplate>
                    <asp:TextBox runat="server" Style="direction: ltr;" ID="tboxsBodyTop" SkinID="tboxMultiline10X800"
                        TextMode="MultiLine" Text='<%# Bind("sAddHtmlTopBody") %>'></asp:TextBox>
                </InsertItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox runat="server" ID="tboxsBodyTop" Style="direction: ltr;" SkinID="tboxMultiline10X800"
                        TextMode="MultiLine" Text='<%# Bind("sAddHtmlTopBody") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:TextBox runat="server" ID="tboxsBodyTop" SkinID="tboxMultiline10X800" TextMode="MultiLine"
                        Text='<%# Eval("sAddHtmlTopBody") %>' Enabled="false"></asp:TextBox>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="HTML חופשי לצד לוגו" InsertVisible="false">
                <InsertItemTemplate>
                    <asp:TextBox runat="server" Style="direction: ltr;" ID="tboxsHTMLLogo" SkinID="tboxMultiline10X800"
                        TextMode="MultiLine" Text='<%# Bind("sAddHtmlToLogoLine") %>'></asp:TextBox>
                </InsertItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox runat="server" ID="tboxsHTMLLogo" Style="direction: ltr;" SkinID="tboxMultiline10X800"
                        TextMode="MultiLine" Text='<%# Bind("sAddHtmlToLogoLine") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:TextBox runat="server" ID="tboxsHTMLLogo" SkinID="tboxMultiline10X800" TextMode="MultiLine"
                        Text='<%# Eval("sAddHtmlToLogoLine") %>' Enabled="false"></asp:TextBox>
                </ItemTemplate>
            </asp:TemplateField>
             <asp:TemplateField HeaderText="טמפלייט מייל לגולש לאחר ביצוע הזמנה" InsertVisible="false">
                <InsertItemTemplate>
                    <asp:TextBox runat="server" ID="tboxsThankEmail" SkinID="tboxMultiline10X800"
                        TextMode="MultiLine" Text='<%# Bind("sThankYouEmailTemplateText") %>'></asp:TextBox>
                </InsertItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox runat="server" ID="tboxsThankEmail" SkinID="tboxMultiline10X800"
                        TextMode="MultiLine" Text='<%# Bind("sThankYouEmailTemplateText") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:TextBox runat="server" ID="tboxsThankEmail" SkinID="tboxMultiline10X800" TextMode="MultiLine"
                        Text='<%# Eval("sThankYouEmailTemplateText") %>' Enabled="false"></asp:TextBox>
                </ItemTemplate>
                 <HeaderTemplate>
                     טמפלייט מייל לגולש שביצע הזמנה<br />
                     {cFirstName} - שם המזמין<br />
                     {siteName} - שם האתר<br />
                     {orderNumberId} - זהות הזמנה<br />
                     {totalItems} - סה"כ מוצרים<br />
                     {totalPrice} - סה"כ מחיר<br />
                     {orderTable} - טבלת מוצרים<br />
                 </HeaderTemplate>
            </asp:TemplateField>
            
            <asp:CheckBoxField DataField="sRefferHideCopyrightDomains" HeaderText="הסתרת לוגו 2eat (*בהפניה מאתרים שהוגדרו מראש)"
                SortExpression="sRefferHideCopyrightDomains" />
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="שורה חלופית עבור הלוגו של 2eat"
                SortExpression="sAlternateCopyright" InsertVisible="False">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox13" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sAlternateCopyright") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox13" SkinID="tboxMultiline3"
                        TextMode="MultiLine" runat="server" Text='<%# Bind("sAlternateCopyright") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label13" runat="server" Text='<%# Bind("sAlternateCopyright") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="אייקון למועדפים"
                SortExpression="sAlterClickBtn" InsertVisible="False">
                <EditItemTemplate>
                    <asp:FileUpload ID="fuIcon" runat="server" /><br />
                    <asp:Image ID="imgIcon" runat="server" Height="200px" Visible='<%# globalFunctions.hasValue(Eval("sSiteIcon")) %>'
                        Width="200px" ImageUrl='<%# globalFunctions.FixedImageUrl("../favicon.ico",Eval("sMainDomain")) %>' /><br />
                    <asp:CheckBox ID="cbRemoveIcon" runat="server" Text="הסר תמונה" Visible='<%# globalFunctions.hasValue(Eval("sSiteIcon")) %>' />
                    <asp:HiddenField ID="hfIcon" runat="server" Value='<%# Eval("sSiteIcon") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                </InsertItemTemplate>
                <ItemTemplate>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="נייד \ Mobile"></asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="לוגו לאתר מובייל<br />(jpg/gif/png)"
                InsertVisible="False">
                <EditItemTemplate>
                    <asp:FileUpload ID="fuLogoImgMob" runat="server" /><br />
                    <asp:Image ID="imgLogoMob" runat="server" Visible='<%# globalFunctions.hasValue(Eval("sMobileLogo")) %>'
                        Width="150px" ImageUrl='<%# globalFunctions.FixedImageUrl(Eval("sMobileLogo"),Eval("sMainDomain")) %>' />
                    <br />
                    <asp:CheckBox ID="cbRemoveLogoImgMob" runat="server" Text="הסר תמונה" Visible='<%# globalFunctions.hasValue(Eval("sMobileLogo")) %>' />
                    <asp:HiddenField ID="hfLogoImgMob" runat="server" Value='<%# Eval("sMobileLogo") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox28" runat="server" Text='<%# Bind("sMobileLogo") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label33" runat="server" Text='<%# Bind("sMobileLogo") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="לוגו תחתון לאתר מובייל<br />(jpg/gif/png)"
                InsertVisible="False">
                <EditItemTemplate>
                    <asp:FileUpload ID="fuLogoImgBtmMob" runat="server" /><br />
                    <asp:Image ID="imgLogoBtmMob" runat="server" Visible='<%# globalFunctions.hasValue(Eval("sMobileBottomLogo")) %>'
                        Width="150px" ImageUrl='<%# globalFunctions.FixedImageUrl(Eval("sMobileBottomLogo"),Eval("sMainDomain")) %>' />
                    <br />
                    <asp:CheckBox ID="cbRemoveLogoImgBtmMob" runat="server" Text="הסר תמונה" Visible='<%# globalFunctions.hasValue(Eval("sMobileBottomLogo")) %>' />
                    <asp:HiddenField ID="hfLogoImgBtmMob" runat="server" Value='<%# Eval("sMobileBottomLogo") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox29" runat="server" Text='<%# Bind("sMobileBottomLogo") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label34" runat="server" Text='<%# Bind("sMobileBottomLogo") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="רקע לאתר מובייל<br />(jpg/gif/png)"
                InsertVisible="False">
                <EditItemTemplate>
                    <asp:FileUpload ID="fuBackMob" runat="server" /><br />
                    <asp:Image ID="imgBackMob" runat="server" Visible='<%# globalFunctions.hasValue(Eval("sMobileSiteBG")) %>'
                        Width="150px" ImageUrl='<%# globalFunctions.FixedImageUrl(Eval("sMobileSiteBG"),Eval("sMainDomain")) %>' />
                    <br />
                    <asp:CheckBox ID="cbRemoveBackMob" runat="server" Text="הסר תמונה" Visible='<%# globalFunctions.hasValue(Eval("sMobileSiteBG")) %>' />
                    <asp:HiddenField ID="hfBacMob" runat="server" Value='<%# Eval("sMobileSiteBG") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox30" runat="server" Text='<%# Bind("sMobileSiteBG") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label35" runat="server" Text='<%# Bind("sMobileSiteBG") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="גלריית רקעים לנייד" InsertVisible="false">
                <EditItemTemplate>
                    <asp:DropDownList runat="server" ID="ddlBGGalMob" AppendDataBoundItems="True" SelectedValue='<%# Bind("sMobileBgGal") %>'
                        DataSourceID="odsBGGal" DataTextField="GalTitle" DataValueField="GalleryId">
                        <asp:ListItem Value="" Text="-בחר-"></asp:ListItem>
                    </asp:DropDownList>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:DropDownList runat="server" ID="ddlBGGalMob" AppendDataBoundItems="True" SelectedValue='<%# Bind("sMobileBgGal") %>'
                        DataSourceID="odsBGGal" DataTextField="GalTitle" DataValueField="GalleryId">
                        <asp:ListItem Value="" Text="-בחר-"></asp:ListItem>
                    </asp:DropDownList>
                </InsertItemTemplate>
                <ItemTemplate>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="רקעים מאוחדים לשימוש ידני<br />(jpg/gif/png)"
                InsertVisible="False">
                <EditItemTemplate>
                    <asp:FileUpload ID="fuRbtnMob" runat="server" /><br />
                    <asp:Image ID="imgRbtnMob" runat="server" Visible='<%# globalFunctions.hasValue(Eval("sMobilerBtnBg")) %>'
                        Width="150px" ImageUrl='<%# globalFunctions.FixedImageUrl(Eval("sMobilerBtnBg"),Eval("sMainDomain")) %>' />
                    <br />
                    <asp:CheckBox ID="cbRemoveRbtnMob" runat="server" Text="הסר תמונה" Visible='<%# globalFunctions.hasValue(Eval("sMobilerBtnBg")) %>' />
                    <asp:HiddenField ID="hfRbtnMob" runat="server" Value='<%# Eval("sMobilerBtnBg") %>' />
                    <p>יחליף מילת קוד בCSS וישים במקומה נתיב לקובץ.<br />מילת קוד: #mobcssbgs#</p>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox31" runat="server" Text='<%# Bind("sMobilerBtnBg") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label36" runat="server" Text='<%# Bind("sMobilerBtnBg") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            
            <asp:CheckBoxField DataField="sShowWazeButtonOnMobileMenu" HeaderText="כפתור ווייז באתר סלולארי" SortExpression="sShowWazeButtonOnMobileMenu" />
            <asp:TemplateField HeaderText="XY למפת וייז">
                <EditItemTemplate>
                    <asp:Label runat="server" AssociatedControlID="tbLon">Y למפה</asp:Label>
                    <asp:TextBox runat="server" ID="tbLon" Text='<%# Bind("sSiteLon") %>'></asp:TextBox>
                    <asp:Label runat="server" AssociatedControlID="tbLan">X למפה</asp:Label>
                    <asp:TextBox runat="server" ID="tbLan" Text='<%# Bind("sSiteLan") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:Label runat="server" AssociatedControlID="tbLon">Y למפה</asp:Label>
                    <asp:TextBox runat="server" ID="tbLon" Text='<%# Bind("sSiteLon") %>'></asp:TextBox>
                    <asp:Label runat="server" AssociatedControlID="tbLan">X למפה</asp:Label>
                    <asp:TextBox runat="server" ID="tbLan" Text='<%# Bind("sSiteLan") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Literal runat="server" ID="tbLon" Text='<%# Eval("sSiteLon") %>'></asp:Literal>
                    <asp:Literal runat="server" ID="tbLan" Text='<%# Eval("sSiteLan") %>'></asp:Literal>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:CheckBoxField DataField="sForcePageType" HeaderText="אכוף סוגי דפים - הפניות אוט'" SortExpression="sForcePageType" />
            <asp:CheckBoxField DataField="sAutoCanonicalAndAlterLink" HeaderText="צור תגיות קנוניקל ואלטר אוט'" SortExpression="sAutoCanonicalAndAlterLink" />
            <asp:CheckBoxField DataField="sCreateXmlOnceADay" Text="צור מפת XML מדי יום -בדרישת לקוח בלבד" />
            <asp:CheckBoxField DataField="sShowBreadcrumbs" Text="הצג פירורי לחם" />
            <asp:CheckBoxField DataField="sShowAutoOpenGraphMeta" Text="הוסף תגיות Open Graph אוטומטיות" />
            <asp:CheckBoxField DataField="sMobileIsOn" HeaderText="סלולארי פעיל" SortExpression="sMobileIsOn" />
            
            <asp:TemplateField HeaderText="כל העיצובים לנייד" InsertVisible="false">
                <InsertItemTemplate>
                    <asp:TextBox runat="server" Style="direction: ltr;" ID="tboxsMobStyle" SkinID="tboxMultiline10X800"
                        TextMode="MultiLine" Text='<%# Bind("sMobileStyle") %>'></asp:TextBox>
                </InsertItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox runat="server" ID="tboxsMobStyle" Style="direction: ltr;" SkinID="tboxMultiline10X800"
                        TextMode="MultiLine" Text='<%# Bind("sMobileStyle") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:TextBox runat="server" ID="tboxsMobStyle" SkinID="tboxMultiline10X800" TextMode="MultiLine"
                        Text='<%# Eval("sMobileStyle") %>' Enabled="false"></asp:TextBox>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="תוספת לHead לנייד" InsertVisible="false">
                <InsertItemTemplate>
                    <asp:TextBox runat="server" Style="direction: ltr;" ID="tboxsMobHCode" SkinID="tboxMultiline10X800"
                        TextMode="MultiLine" Text='<%# Bind("sMobileAddToHeader") %>'></asp:TextBox>
                </InsertItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox runat="server" ID="tboxsMobHCode" Style="direction: ltr;" SkinID="tboxMultiline10X800"
                        TextMode="MultiLine" Text='<%# Bind("sMobileAddToHeader") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:TextBox runat="server" ID="tboxsMobHCode" SkinID="tboxMultiline10X800" TextMode="MultiLine"
                        Text='<%# Eval("sMobileAddToHeader") %>' Enabled="false"></asp:TextBox>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="תוספת לFooter לנייד" InsertVisible="false">
                <InsertItemTemplate>
                    <asp:TextBox runat="server" Style="direction: ltr;" ID="tboxsMobFCode" SkinID="tboxMultiline10X800"
                        TextMode="MultiLine" Text='<%# Bind("sMobileAddToFooter") %>'></asp:TextBox>
                </InsertItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox runat="server" ID="tboxsMobFCode" Style="direction: ltr;" SkinID="tboxMultiline10X800"
                        TextMode="MultiLine" Text='<%# Bind("sMobileAddToFooter") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:TextBox runat="server" ID="tboxsMobFCode" SkinID="tboxMultiline10X800" TextMode="MultiLine"
                        Text='<%# Eval("sMobileAddToFooter") %>' Enabled="false"></asp:TextBox>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="גירסת האתר" SortExpression="sVer">
                <EditItemTemplate>
                    <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="sdsVersions" DataTextField="verSmallDescription"
                        DataValueField="version" SelectedValue='<%# Bind("sVer") %>'>
                    </asp:DropDownList>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="sdsVersions" DataTextField="verSmallDescription"
                        DataValueField="version" SelectedValue='<%# Bind("sVer") %>'>
                    </asp:DropDownList>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="sdsVersions" DataTextField="verSmallDescription"
                        DataValueField="version" SelectedValue='<%# Bind("sVer") %>'>
                    </asp:DropDownList>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField>
                <HeaderTemplate>
                </HeaderTemplate>
                <InsertItemTemplate>
                    <asp:ImageButton ID="IbtnInsert" runat="server" SkinID="com_Insert" CommandName="insert" />
                    <asp:ImageButton ID="IbtnCancel" runat="server" SkinID="com_Cancel" CommandName="cancel" />
                </InsertItemTemplate>
                <EditItemTemplate>
                    <asp:Button ID="btnSaveAndBack" runat="server" CommandName="update" Text="שמור וחזור לעריכה"
                        OnClick="btnUpdate_Click"  CommandArgument='<%# Eval("id") %>' />
                    <asp:ImageButton ID="IbtnUpdate" runat="server" SkinID="com_Update" CommandName="update"
                        OnClick="IbtnUpdate_Click" />
                    <asp:ImageButton ID="IbtnCancel" runat="server" SkinID="com_Cancel" CommandName="cancel" />
                    <div style="position: fixed;bottom: 50%; margin-right: 820px; width: 45px; background-color: rgba(0,0,0,0.8); padding: 5px; text-align: center; border: 3px solid #cbc9c3;" right="0" left="0">
                        <asp:Button ID="btnSaveAndBack2" runat="server" CommandName="update" Text="שמור"
                        OnClick="btnUpdate_Click"  CommandArgument='<%# Eval("id") %>' /><br />
                        <asp:ImageButton ID="IbtnUpdate2" runat="server" SkinID="com_Update" CommandName="update"
                        OnClick="IbtnUpdate_Click" /><br />
                        <asp:ImageButton ID="IbtnCancel2" runat="server" SkinID="com_Cancel" CommandName="cancel" />
                    </div>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:ImageButton ID="IbtnInsert" runat="server" SkinID="com_Insert" CommandName="insert" />
                </ItemTemplate>
                <FooterTemplate>
                </FooterTemplate>
            </asp:TemplateField>
        </Fields>
        <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
    </asp:DetailsView>
    <asp:Literal runat="server" ID="litTotal"></asp:Literal>
    <asp:ObjectDataSource ID="odsSitePref" runat="server" TypeName="site" SelectMethod="GetSite"
        DataObjectTypeName="site" DeleteMethod="DeleteSite" UpdateMethod="UpdateSite"
        InsertMethod="SetSite">
        <SelectParameters>
            <asp:Parameter Name="siteId" Type="Object" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="siteId" Type="Object" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="site" Type="Object" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="site" Type="Object" />
        </InsertParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsVersions" runat="server" ConnectionString="<%$ ConnectionStrings:mainConnString %>"
        SelectCommand="SELECT [version], [verSmallDescription] FROM [tbl_versions] ORDER BY [version]">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsTemplates" runat="server" ConnectionString="<%$ ConnectionStrings:mainConnString %>"
        SelectCommand="SELECT 0 AS id, ' בחר סוג ' AS tName, NULL AS tDirectory FROM tbl_templates UNION SELECT id AS id1, tName AS tname1, tDirectory AS tdirectory1 FROM tbl_templates AS tbl_templates1 ORDER BY tName">
    </asp:SqlDataSource>
    <asp:ObjectDataSource ID="odsBGGal" runat="server" SelectMethod="GetGallerisBySiteId"
        TypeName="BGGallery">
        <SelectParameters>
            <asp:Parameter Name="siteId" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
</asp:Content>

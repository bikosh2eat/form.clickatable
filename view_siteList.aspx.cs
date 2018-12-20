using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;

public partial class view_siteList : System.Web.UI.Page
{
    private int EditSiteId;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (globalFunctions.isInt(Request.QueryString["site"]))
            {
                int.TryParse(Request.QueryString["site"], out EditSiteId);
                this.odsSitePref.SelectParameters["siteId"].DefaultValue = EditSiteId.ToString();
                this.odsBGGal.SelectParameters["siteId"].DefaultValue = EditSiteId.ToString();
                this.odsSitePref.DataBind();
                this.dviewEditSite.ChangeMode(DetailsViewMode.Edit);
                this.rptSiteList.Visible = false;
                this.dviewEditSite.Visible = true;
            }

            CreateSiteRepeater();
        }
    }
    private void CreateSiteRepeater()
    {
        //dbConn dbc = new dbConn("select id,sName,sMainDomain,sIsOn,sTemplate,sVer,sUndertoeat from sitesPref order by sName");
        //this.rptSiteList.DataSource = dbc.sds();
        site[] sites = new site[0];//new site().getSitesListForList();
        this.rptSiteList.DataSource = sites;
        this.rptSiteList.DataBind();
    }
    protected void btnEditMe_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/view_sitelist.aspx?site=" + this.Session["site"].ToString());
    }
    protected void ibtnAddSite_Click(object sender, ImageClickEventArgs e)
    {
        this.dviewEditSite.ChangeMode(DetailsViewMode.Insert);
        this.rptSiteList.Visible = false;
        this.dviewEditSite.Visible = true;
    }
    protected void ibtnEditSite_Click(object sender, ImageClickEventArgs e)
    {
        this.odsSitePref.SelectParameters["siteId"].DefaultValue = ((ImageButton)sender).CommandArgument;
        this.odsBGGal.SelectParameters["siteId"].DefaultValue = ((ImageButton)sender).CommandArgument;
        int.TryParse(((ImageButton)sender).CommandArgument, out this.EditSiteId);
        this.odsSitePref.DataBind();
        this.dviewEditSite.ChangeMode(DetailsViewMode.Edit);
        //((ImageButton)this.dviewEditSite.FindControl("IbtnUpdate")).CommandArgument = this.EditSiteId.ToString();
        this.rptSiteList.Visible = false;
        this.dviewEditSite.Visible = true;
    }
    protected void ibtnDeleteSite_Click(object sender, ImageClickEventArgs e)
    {
        string sid = ((ImageButton)sender).CommandArgument;
        new site().DeleteSite(sid);
        CreateSiteRepeater();
        //(site)this.odsSitePref.DeleteParameters["siteId"].DefaultValue = s;
        //this.odsSitePref.DeleteParameters["siteId"].DefaultValue = sid;
        //this.odsSitePref.Delete();
    }
    private void CreateNewSite()
    {

    }
    protected void dviewEditSite_ItemCommand(object sender, DetailsViewCommandEventArgs e)
    {
        if (e.CommandName == "cancel")
        {
            this.rptSiteList.Visible = true;
            this.dviewEditSite.Visible = false;
        }
    }
    protected void dviewEditSite_ItemDeleted(object sender, DetailsViewDeletedEventArgs e)
    {
        this.rptSiteList.Visible = true;
        this.dviewEditSite.Visible = false;
    }
    protected void dviewEditSite_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
    {
        this.rptSiteList.Visible = true;
        this.dviewEditSite.Visible = false;
        CreateSiteRepeater();
    }
    protected void dviewEditSite_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
    {
        this.rptSiteList.Visible = true;
        this.dviewEditSite.Visible = false;
        //((DetailsView)sender).ChangeMode(DetailsViewMode.Edit);
        if (ViewState["saveandreturn"] != "return")
        {
            // CreateSiteRepeater();
            Response.Redirect("~/view_sitelist.aspx"); //?site=" + e.NewValues["id"].ToString());
        }
        else
            Response.Redirect("~/view_sitelist.aspx?site=" + e.NewValues["id"].ToString());
        
    }
    protected void dviewEditSite_ItemDeleting(object sender, DetailsViewDeleteEventArgs e)
    {

    }
    protected void dviewEditSite_ItemInserting(object sender, DetailsViewInsertEventArgs e)
    {
        bool cancelEvent = false;
        string cancelMessage = "";
        // מחיצה לשמירת נתונים עבור אתר: צריך לוודא שקיימת, אם לא - להקים.
        // כאן מבוצעות רק בדיקות. הפעולה בפועל מתבצעת בSITE.CS
        if (e.Values["sDir"] != null && e.Values["sDir"].ToString() != "")
        {

            string newDir = e.Values["sDir"].ToString();
            site s = new site();
            if (!s.CheckAvilabilityForNewDir(newDir))
            {
                cancelEvent = true;
                cancelMessage = "חובה לתת שם תיקיה";
            }
        }
        else
        {
            cancelEvent = true;
        }
        if (cancelEvent)
        {
            e.Cancel = true;
            globalFunctions.alert(cancelMessage, this.Page);
        }
    }

    protected void dviewEditSite_ItemUpdating(object sender, DetailsViewUpdateEventArgs e)
    {

        // כאן רק מריץ בדיקות, הפעולה מתבצעת בSITE.CS
        // יצירת אובייקט מסוג אתר, 
        // הרצת בדיקות רלוונטיות. 
        // אם לא נופל עדכון אתר.
        site CSite = new site().GetSite(e.OldValues["id"].ToString());

        if (!CSite.CheckAvilabilityForNewDir(e.NewValues["sDir"].ToString()))
        {
            e.Cancel = true;
            globalFunctions.alert("תקלה - התיקייה שנבחרה כבר קיימת במערכת", this.Page);
        }

        if (!CSite.VerExists(e.NewValues["sVer"].ToString()))
        {
            e.Cancel = true;
            globalFunctions.alert("תקלה - הגרסה שנבחרה לא קיימת", this.Page);
        }
        if (e.Cancel)
            return;
        DetailsView dv = ((DetailsView)sender);
        string SaveDir = "\\" + ((Label)dv.FindControl("tboxDir")).Text;

        FileUpload fu; HiddenField hf; CheckBox cb;
        fu = (FileUpload)(dv.FindControl("fuBackImg"));
        hf = (HiddenField)(dv.FindControl("hfBackImg"));
        cb = (CheckBox)(dv.FindControl("cbRemoveBackImg"));
        e.NewValues["sBGImageFile"] = globalFunctions.SaveImageAndDeleteOld(hf.Value, cb.Checked, ref fu, SaveDir + "\\images", "SiteBG");

        fu = (FileUpload)(dv.FindControl("fuLogoImg"));
        hf = (HiddenField)(dv.FindControl("hfLogoImg"));
        cb = (CheckBox)(dv.FindControl("cbRemoveLogoImg"));
        e.NewValues["sLogoFile"] = globalFunctions.SaveImageAndDeleteOld(hf.Value, cb.Checked, ref fu, SaveDir + "\\images", "Logo");

        fu = (FileUpload)(dv.FindControl("fuHeadImg"));
        hf = (HiddenField)(dv.FindControl("hfHeadImg"));
        cb = (CheckBox)(dv.FindControl("cbRemoveHeadImg"));
        e.NewValues["sHeaderFile"] = globalFunctions.SaveImageAndDeleteOld(hf.Value, cb.Checked, ref fu, SaveDir + "\\images", "Header");

        fu = (FileUpload)(dv.FindControl("fuMainBgImg"));
        hf = (HiddenField)(dv.FindControl("hfMainBg"));
        cb = (CheckBox)(dv.FindControl("cbRemoveMainBg"));
        e.NewValues["sMainBgFile"] = globalFunctions.SaveImageAndDeleteOld(hf.Value, cb.Checked, ref fu, SaveDir + "\\images", "MainBG");

        fu = (FileUpload)(dv.FindControl("fuLogoFooterImg"));
        hf = (HiddenField)(dv.FindControl("hfLogoFooterImg"));
        cb = (CheckBox)(dv.FindControl("cbRemoveLogoFooterImg"));
        e.NewValues["sFooterLogoFile"] = globalFunctions.SaveImageAndDeleteOld(hf.Value, cb.Checked, ref fu, SaveDir + "\\images", "FLogo");

        fu = (FileUpload)(dv.FindControl("fuTextContBG"));
        hf = (HiddenField)(dv.FindControl("hfTextContBG"));
        cb = (CheckBox)(dv.FindControl("cbRemoveTextContBG"));
        e.NewValues["sTextContBG"] = globalFunctions.SaveImageAndDeleteOld(hf.Value, cb.Checked, ref fu, SaveDir + "\\images", "tCont");

        fu = (FileUpload)(dv.FindControl("fuH1BGImg"));
        hf = (HiddenField)(dv.FindControl("hfH1BGImg"));
        cb = (CheckBox)(dv.FindControl("cbRemovesH1BGBGImg"));
        e.NewValues["sH1BG"] = globalFunctions.SaveImageAndDeleteOld(hf.Value, cb.Checked, ref fu, SaveDir + "\\images", "h1");

        fu = (FileUpload)(dv.FindControl("fuInnerBGImg"));
        hf = (HiddenField)(dv.FindControl("hfInnerBGImg"));
        cb = (CheckBox)(dv.FindControl("cbRemoveInnerBGImg"));
        e.NewValues["sInnerBGTextImage"] = globalFunctions.SaveImageAndDeleteOld(hf.Value, cb.Checked, ref fu, SaveDir + "\\images", "InnerBG");

        fu = (FileUpload)(dv.FindControl("fuRNavBGImage"));
        hf = (HiddenField)(dv.FindControl("hfRNavBGImage"));
        cb = (CheckBox)(dv.FindControl("cbRemoveRNavBGImage"));
        e.NewValues["sRightNavBGImage"] = globalFunctions.SaveImageAndDeleteOld(hf.Value, cb.Checked, ref fu, SaveDir + "\\images", "RNavBG");

        fu = (FileUpload)(dv.FindControl("fuRNavButtonBG"));
        hf = (HiddenField)(dv.FindControl("hfRNavButtonBG"));
        cb = (CheckBox)(dv.FindControl("cbRemoveRNavButtonBG"));
        e.NewValues["sRNavBG"] = globalFunctions.SaveImageAndDeleteOld(hf.Value, cb.Checked, ref fu, SaveDir + "\\images", "RNavBtnBG");

        fu = (FileUpload)(dv.FindControl("fuUNavButtonBG"));
        hf = (HiddenField)(dv.FindControl("hfUNavButtonBG"));
        cb = (CheckBox)(dv.FindControl("cbRemoveUNavButtonBG"));
        e.NewValues["sUNavBG"] = globalFunctions.SaveImageAndDeleteOld(hf.Value, cb.Checked, ref fu, SaveDir + "\\images", "UNavBtnBG");

        fu = (FileUpload)(dv.FindControl("fuAltClick"));
        hf = (HiddenField)(dv.FindControl("hfAltClick"));
        cb = (CheckBox)(dv.FindControl("cbRemoveAltClick"));
        e.NewValues["sAlterClickBtn"] = globalFunctions.SaveImageAndDeleteOld(hf.Value, cb.Checked, ref fu, SaveDir + "\\images", "altClick");

        // favicon.ico
        fu = (FileUpload)(dv.FindControl("fuIcon"));
        hf = (HiddenField)(dv.FindControl("hfIcon"));
        cb = (CheckBox)(dv.FindControl("cbRemoveIcon"));
        if (cb.Checked && !string.IsNullOrEmpty(hf.Value))
        {
            globalFunctions.removeFile("", "favicon.ico");
            e.NewValues["sSiteIcon"] = string.Empty;
        }
        else if (fu.HasFile && fu.PostedFile.ContentType == "image/x-icon")
        {
            fu.SaveAs(ConfigurationManager.AppSettings["SitesMainFolder"].ToString() + "\\" + SaveDir + "\\" + "favicon.ico");
            e.NewValues["sSiteIcon"] = "favicon.ico";//globalFunctions.SaveFileAndDeleteOld(ref fu, SaveDir + "\\", "altClick");
        }
        else
            e.NewValues["sSiteIcon"] = hf.Value;

        // mobile images

        fu = (FileUpload)(dv.FindControl("fuLogoImgMob"));
        hf = (HiddenField)(dv.FindControl("hfLogoImgMob"));
        cb = (CheckBox)(dv.FindControl("cbRemoveLogoImgMob"));
        e.NewValues["sMobileLogo"] = globalFunctions.SaveImageAndDeleteOld(hf.Value, cb.Checked, ref fu, SaveDir + "\\images", "LogoMob");

        fu = (FileUpload)(dv.FindControl("fuLogoImgBtmMob"));
        hf = (HiddenField)(dv.FindControl("hfLogoImgBtmMob"));
        cb = (CheckBox)(dv.FindControl("cbRemoveLogoImgBtmMob"));
        e.NewValues["sMobileBottomLogo"] = globalFunctions.SaveImageAndDeleteOld(hf.Value, cb.Checked, ref fu, SaveDir + "\\images", "FLogoMob");

        fu = (FileUpload)(dv.FindControl("fuBackMob"));
        hf = (HiddenField)(dv.FindControl("hfBacMob"));
        cb = (CheckBox)(dv.FindControl("cbRemoveBackMob"));
        e.NewValues["sMobileSiteBG"] = globalFunctions.SaveImageAndDeleteOld(hf.Value, cb.Checked, ref fu, SaveDir + "\\images", "BGMob");

        fu = (FileUpload)(dv.FindControl("fuRbtnMob"));
        hf = (HiddenField)(dv.FindControl("hfRbtnMob"));
        cb = (CheckBox)(dv.FindControl("cbRemoveRbtnMob"));
        e.NewValues["sMobilerBtnBg"] = globalFunctions.SaveImageAndDeleteOld(hf.Value, cb.Checked, ref fu, SaveDir + "\\images", "MobBgs");


        // logo flash
        string FlashWidth = ((TextBox)((DetailsView)sender).FindControl("tBoxlogoFlashWidth")).Text;
        string FlashHeight = ((TextBox)((DetailsView)sender).FindControl("tBoxlogoFlashHeight")).Text;
        if (globalFunctions.isInt(FlashWidth) && globalFunctions.isInt(FlashHeight))
        {
            e.NewValues["logoFlashSize"] = FlashWidth.Trim() + ";" + FlashHeight.Trim();
        }
        else
            e.NewValues["logoFlashSize"] = "";
        // יצירת סייטמפ בסיסי אם לא היה קודם
        if (e.OldValues["sShowBreadcrumbs"].ToString() != e.NewValues["sShowBreadcrumbs"].ToString() && bool.Parse(e.NewValues["sShowBreadcrumbs"].ToString()) == true )
        {
            string updateDate = "update sitespref set [sLastXmlDateDay] = @sLastXmlDateDay";
            System.Data.SqlClient.SqlParameter[] sdp = new System.Data.SqlClient.SqlParameter[1];
            sdp[0] = new System.Data.SqlClient.SqlParameter("sLastXmlDateDay", DateTime.Now.Date.Day - 1);
            using (dbConn dbc = new dbConn(""))
            {
                dbc.DbParams = sdp;
                dbc.FreeCommand(updateDate);
            }
            // בניית עץ ריק אם לא קיים
            string fileDirectory = ConfigurationManager.AppSettings["SitesMainFolder"].ToString();
            string fileName = "web.sitemap";

            //using (StreamWriter sw = new StreamWriter(fileDirectory + "\\" + CSite.sDir + "\\" + fileName, false, System.Text.Encoding.UTF8))
            //{
            //    sw.WriteLine("<?xml version=\"1.0\" encoding=\"utf-8\" ?><siteMap xmlns=\"http://schemas.microsoft.com/AspNet/SiteMap-File-1.0\">" + Environment.NewLine + "<siteMapNode title=\"ראשי\"  description=\"\" url=\"~/\">" + Environment.NewLine + "</siteMapNode></siteMap>");
            //    sw.Flush();
            //    sw.Close();
            //    sw.Dispose();
            //}
            if (File.Exists(fileDirectory + "\\" + CSite.sDir + "\\" + fileName))
                File.Delete(fileDirectory + "\\" + CSite.sDir + "\\" + fileName);
        }
    }
    protected void btnFind2eatId_Click(object sender, EventArgs e)
    {
        string strText = this.tboxFind2eatId.Text;
        string strSql;
        if (globalFunctions.hasValue(strText))
        {
            strText = strText.Replace("\"", "&#39;").Replace("'", "&#34;").Trim();
            strSql = "select top 30 restTitle,restId,restPhone,restAddress,subName FROM tblrestaurant INNER JOIN tblLocSub ON tblrestaurant.restLocSub = tblLocSub.subid WHERE restTitle LIKE '%" + strText + "%' OR restErrorTitle Like '%" + strText + "%' ORDER BY [restTitle]";
        }
        else
        {
            strSql = "";
        }
        _2eatConnector db = new _2eatConnector(strSql);
        //DataTable dt = db.dt();
        //if (dt.Rows.Count > 0)
        if (db.dt().Rows.Count > 0)
        {
            this.rptFind2eatId.DataSource = db.sds();
        }
        else
            globalFunctions.alert("אין הצעות", this.Page);
        this.rptFind2eatId.DataBind();

    }
    protected void btnClearFind2eatId_Click(object sender, EventArgs e)
    {
        this.tboxFind2eatId.Text = "";
        btnFind2eatId_Click(sender, e);
    }
    protected void ddlOpenPage_DataBinding(object sender, EventArgs e)
    {
        // מחזיר רק את הדפים הקיימים ודף לא קיים מובנה=0
        //string strSql = "SELECT '' as [id], 'לא נבחר' as [pname] FROM [pages] UNION SELECT [id] as id2, [pname] as pname2 FROM [pages] WHERE (([pSiteId] = @pSiteId) AND ([ptype] = @ptype)) ORDER BY pname";

        // מחזיר את הדפים הקיימים, הדפים הלא קיימים ודף מובנה לא קיים=0
        //string strSql = "SELECT '0' as [id], 'לא נבחר' as [pname] FROM [pages] UNION SELECT [sOpenPage] as id1, 'הדף לא קיים * נא לבחור חדש' as pname1 FROM [sitesPref] as pages1 WHERE [sOpenPage] > 0 AND [id] = @pSiteId AND NOT sOpenPage IN (SELECT [id] as id3 FROM [pages] WHERE (([pSiteId] = @pSiteId) AND ([ptype] = @ptype))) UNION SELECT [id] as id2, [pname] as pname2 FROM [pages] WHERE (([pSiteId] = @pSiteId) AND (([ptype] = @ptype) OR ([ptype] = @ptypeb) OR ([ptype] = @ptypec))) ORDER BY pname";
        // מחזיר את כל סוגי הדפים הקיימים
        string strSql = "SELECT '0' as [id], ' - לא נבחר - ' as [pname] FROM [pages] UNION SELECT [sOpenPage] as id1, 'הדף לא קיים * נא לבחור חדש' as pname1 FROM [sitesPref] as pages1 WHERE [sOpenPage] > 0 AND [id] = @pSiteId AND NOT sOpenPage IN (SELECT [id] as id3 FROM [pages] WHERE (([pSiteId] = @pSiteId))) UNION SELECT [id] as id2, [pname] as pname2 FROM [pages] WHERE (([pSiteId] = @pSiteId)) ORDER BY pname";

        // מחזיר רק את הדפים הקיימים ודף לא קיים. אין מובנה לא קיים
        //string strSql = "SELECT [sOpenPage] as id, 'הדף לא קיים' as pname FROM [sitesPref] as pages1 WHERE id = " + this.EditSiteId.ToString() + " AND NOT sOpenPage IN (SELECT [id] as id3 FROM [pages] WHERE (([pSiteId] = @pSiteId) AND ([ptype] = @ptype))) UNION SELECT [id] as id2, [pname] as pname2 FROM [pages] WHERE (([pSiteId] = @pSiteId) AND ([ptype] = @ptype)) ORDER BY pname";

        System.Data.SqlClient.SqlParameter[] sp = new System.Data.SqlClient.SqlParameter[1];
        sp[0] = new System.Data.SqlClient.SqlParameter("pSiteId", this.EditSiteId.ToString());
        //sp[1] = new System.Data.SqlClient.SqlParameter("ptype", "3");
        //sp[2] = new System.Data.SqlClient.SqlParameter("ptypeb", "16");
        //sp[3] = new System.Data.SqlClient.SqlParameter("ptypec", "18");
        dbConn dbc = new dbConn(strSql, sp);
        int d = dbc.dt().Rows.Count;
        ((DropDownList)sender).DataSource = dbc.sds();
    }

    protected void ddlOpenMobiPage_DataBinding(object sender, EventArgs e)
    {
        string strSql = "SELECT '0' as [id], ' - לא נבחר - ' as [pname] FROM [pages] UNION SELECT [sMobileFirstPage] as id1, 'הדף לא קיים * נא לבחור חדש' as pname1 FROM [sitesPref] as pages1 WHERE [sMobileFirstPage] > 0 AND [id] = @pSiteId AND NOT sMobileFirstPage IN (SELECT [id] as id3 FROM [pages] WHERE (([pSiteId] = @pSiteId))) UNION SELECT [id] as id2, [pname] as pname2 FROM [pages] WHERE (([pSiteId] = @pSiteId)) ORDER BY pname";

        System.Data.SqlClient.SqlParameter[] sp = new System.Data.SqlClient.SqlParameter[1];
        sp[0] = new System.Data.SqlClient.SqlParameter("pSiteId", this.EditSiteId.ToString());
        dbConn dbc = new dbConn(strSql, sp);
        int d = dbc.dt().Rows.Count;
        ((DropDownList)sender).DataSource = dbc.sds();
    }
    
    protected void btnReturnToSiteList_Click(object sender, EventArgs e)
    {
        //this.rptSiteList.Visible = true;
        //this.dviewEditSite.Visible = false;
        //CreateSiteRepeater();
    }
    protected void IbtnUpdate_Click(object sender, ImageClickEventArgs e)
    {
        int.TryParse(((ImageButton)sender).CommandArgument, out this.EditSiteId);
        ViewState["saveandreturn"] = "normal";
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        int.TryParse(((Button)sender).CommandArgument, out this.EditSiteId);
        ViewState["saveandreturn"] = "return";
    }
    
    protected void CBoxDefaultToChecked(object sender, EventArgs e)
    {
        ((CheckBox)sender).Checked = true;
    }
    protected void hlShowSite_PreRender(object sender, EventArgs e)
    {
        if (((CheckBox)(((HyperLink)sender).Parent.FindControl("cboxUnderToeat"))).Checked)
        {
            ((HyperLink)sender).NavigateUrl = "http://www.2eat.co.il/" + ((HyperLink)sender).NavigateUrl;
        }
        else
        {
            ((HyperLink)sender).NavigateUrl = globalFunctions.fixLink(((HyperLink)sender).NavigateUrl);
        }
    }
    protected void btnSelectThisSite_Click(object sender, EventArgs e)
    {
        int SelectThisId;
        if (int.TryParse(((Button)sender).CommandArgument, out SelectThisId))
        {
            // הכנסה לסשן
            this.Session["site"] = SelectThisId.ToString();
            this.Session["siteDomain"] = ((Label)(((Button)sender).Parent).FindControl("lblSMainD")).Text;
            // הכנסה לקוקי
            HttpCookie c = Request.Cookies["Manage"];
            if (this.Session["user"] != null)
            {
                c.Values["s"] = SelectThisId.ToString();
            }
            c.Expires = DateTime.Now.AddDays(1);
            Response.Cookies.Add(c);
            Response.Redirect("~/default.aspx");
        }
        else
            globalFunctions.alert("תקלה, לא השתנה האתר", this.Page);
    }
    protected void litFlash_DataBinding(object sender, EventArgs e)
    {
        Image img = ((Image)((Literal)sender).Parent.FindControl("imgLogo"));
        if (img.ImageUrl.Contains(".swf"))
        {
            img.Visible = false;
            string wh = ((Literal)sender).Text;
            if (!wh.Contains(";"))
            {
                ((Literal)sender).Text = "כדי ליצור תצוגה עבור קובץ פלאש חובה להכניס רוחב וגובה מתאימים";
            }
            else
            {
                string w = wh.Split(';').GetValue(0).ToString();
                string h = wh.Split(';').GetValue(1).ToString();

                string s = "<object id=\"detectme\" width=\"" + w + "px\" height=\"" + h + "px\" classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\" codebase=\"http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0\" >" +
                "<param name=\"movie\" value=\"" + img.ImageUrl + "\">" +
                "<param name=\"quality\" value=\"high\">" +
                    //"<param name=\"allowscriptaccess\" value=\"samedomain\">" +
                "<embed src=\"" + img.ImageUrl.Remove(0, 2) + "\" name=\"detectme\"" +// swliveconnect=\"true\" " +
                "quality=\"high\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\" type=\"application/x-shockwave-flash\">" +
                "</embed>" +
                "</object>";
                ((Literal)sender).Text = s;
            }
        }
    }
    protected void btnSeaerchSite_Click(object sender, EventArgs e)
    {
        string siteName = ((TextBox)(((Button)sender).Parent.FindControl("tboxSearchSite"))).Text;
        //sites s = (sites)this.rptSiteList.DataSource;
        sites s = new sites();
        s.siteName = siteName;
        if (
        ((DropDownList)(((Button)sender).Parent.FindControl("ddlSrcSiteTemp"))).SelectedIndex != -1 && !string.IsNullOrEmpty(((DropDownList)(((Button)sender).Parent.FindControl("ddlSrcSiteTemp"))).SelectedValue))
            s.sTemplateId = int.Parse(((DropDownList)(((Button)sender).Parent.FindControl("ddlSrcSiteTemp"))).SelectedValue);
        if(int.Parse(Session["level"].ToString()) > 3)
        {
            s.userId = int.Parse(Session["user"].ToString());
        }

        if (((CheckBox)(((Button)sender).Parent.FindControl("cboxShowOffSites"))).Checked == false)
        {
            s.isOn = true;
        }
        site[] sitesRes = s.GetSites();
        this.rptSiteList.DataSource = sitesRes;
        this.rptSiteList.DataBind();
        if (sitesRes.Length > 25)
            this.litTotal.Text = sitesRes.Length.ToString();
        else
            this.litTotal.Text = "";
    }
    protected void btnSeaerchSite_Load(object sender, EventArgs e)
    {
        this.Master.Page.Form.DefaultButton = ((Button)sender).UniqueID;
        this.Master.Page.Form.DefaultFocus = ((TextBox)(((Button)sender).Parent.FindControl("tboxSearchSite"))).UniqueID;
    }
}
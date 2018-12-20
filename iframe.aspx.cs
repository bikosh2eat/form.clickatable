using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class iframe : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
        if(Request.QueryString["restId"] != null)
        {
            string HeadString = "<script type=\"text/javascript\">var clcRestId = \"" + Request.QueryString["restId"] + "\";</script><script src=\"https://i.clickatable.co.il/template-frame.js\" type=\"text/javascript\"></script>";
            this.litHeadCont.Text = HeadString;

        }
    }
}
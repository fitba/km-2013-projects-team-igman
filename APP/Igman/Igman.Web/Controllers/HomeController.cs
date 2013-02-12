using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace Igman.Web.Controllers
{
    public class HomeController : Controller
    {
        //
        // GET: /Home/

        public ActionResult Index()
        {
            return RedirectToAction("index", "wellcome");
            
        }

        public ActionResult LogOut()
        {
            Session.Clear();
            FormsAuthentication.SignOut();
            return RedirectToAction("Index");
        }

    }
}

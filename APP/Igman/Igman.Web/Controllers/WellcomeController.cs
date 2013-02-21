using Igman.DB.BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using auth = Igman.Web.Autorizacija;

namespace Igman.Web.Controllers
{
    public class WellcomeController : Controller
    {
        //
        // GET: /Wellcome/

        public ActionResult Index()
        {
            DB.DAL.User a = auth.Autorizacija.GetCurrentUser(this.HttpContext);
            if (a != null)
                TempData["user"] = a;
            using (DBBL Baza = new DBBL())
            {
                TempData["br_User"] = Baza.GetBrojUsera();
                TempData["br_Wiki"] = Baza.GetBrojWiki();
                TempData["br_QA"] = Baza.GetBrojQA();
               
            }
            return View();
        }
        public string GetAI(string args)
        {
            LuceneEngine.LuceneDbEngine ldbe = new LuceneEngine.LuceneDbEngine();
            List<DB.DAL.Article> lista = null;
            List<int> ids = ldbe.AiComplete(args);
            args = GetIds(ids);
            using (DBBL Baza = new DBBL())
            {
                lista = Baza.GetAI(args);
            }
            return Newtonsoft.Json.JsonConvert.SerializeObject(lista);
        }
        internal string GetIds(List<int> a)
        {

            if (a.Count == 0)
                return "";
            string s = "";
            foreach (var item in a)
            {
                s += string.Format("{0},",item);
            }
            return s.Remove(s.Count() - 1);
        }

     

    }
}

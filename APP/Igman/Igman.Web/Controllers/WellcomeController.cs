using Igman.DB.BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.Entity;
using auth = Igman.Web.Autorizacija;
using PagedList;
using Igman.DB.DAL;
namespace Igman.Web.Controllers
{
    public class WellcomeController : Controller
    {
        //
        // GET: /Wellcome/

        public ActionResult Index(string tab, int page=1)
        {
            DB.DAL.User a = auth.Autorizacija.GetCurrentUser(this.HttpContext);
            if (a != null)
                TempData["user"] = a;
            using (DBBL Baza = new DBBL())
            {
                TempData["br_User"] = Baza.GetBrojUsera();
                TempData["br_Wiki"] = Baza.GetBrojWiki();
                TempData["br_QA"] = Baza.GetBrojQA();
                var listaTopPitanja = Baza.context.Questions.OrderByDescending(q => q.NumOfViews).Take(7).ToList();
                var listaTopWiki = Baza.context.Articles.OrderByDescending(q => q.Views).Take(7).ToList();

                HttpContext.Cache.Insert("TopListaWiki", listaTopWiki);
                HttpContext.Cache.Insert("TopListaPitanja", listaTopPitanja);

                ViewBag.Kategorija = Baza.GetKatogorije();
                ViewBag.AllCategory = Baza.context.Categories.ToList();
                ViewBag.brojKomentara = Baza.context.Questions.Count();
                var tagovi = Baza.context.Tags.Include(q=>q.Questions).OrderByDescending(q => q.Questions.Count).Take(50).ToList();
                var randomLista = tagovi.OrderBy(q => q.TagID).ToList();
                HttpContext.Cache.Insert("TopListaTagova", randomLista);
    


                if (tab == "popularno")
                {
                    var questions = Baza.context.Questions.Include(q => q.Categories).Include(q => q.User).Include(q => q.QuestionLikes).Include(q => q.Tags).Include(q => q.Answers).OrderByDescending(q => q.Likes);

                    if (Request.IsAjaxRequest())
                    {
                        return PartialView("_render_questions", questions.ToList().ToPagedList(page, 5));
                    }

                    return View(questions.ToList().ToPagedList(page, 2));
                }

                if (tab == "najcitanije")
                {
                    var questions = Baza.context.Questions.Include(q => q.Categories).Include(q => q.User).Include(q => q.Tags).Include(q=>q.QuestionLikes).Include(q => q.Answers).OrderByDescending(q => q.NumOfViews);

                    if (Request.IsAjaxRequest())
                    {
                        return PartialView("_render_questions", questions.ToList().ToPagedList(page, 5));
                    }

                    return View(questions.ToList().ToPagedList(page, 5));
                }
                else
                {

                    var questions = Baza.context.Questions.Include(q => q.Categories).Include(q => q.User).Include(q => q.Tags).Include(q => q.Answers).Include(q=>q.QuestionLikes).OrderByDescending(q => q.CreatedDate);
                    if (Request.IsAjaxRequest())
                    {
                        return PartialView("_render_questions", questions.ToList().ToPagedList(page, 5));
                    }

                    return View(questions.ToList().ToPagedList(page, 5));
                }

            }
            

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

        
        public ActionResult get_questions_by_kategory(int id, int page = 1)
        {
            using (DBBL Baza = new DBBL())
            {
                List<int> listaIdPitanja = Baza.get_questionsIDs(id).ToList();
                List<Question> lista = new List<Question>();
                foreach (var item in listaIdPitanja)
                {

                    Question p = Baza.context.Questions.Include(q => q.Categories).Include(q => q.QuestionLikes).Include(q => q.Answers).Include(q=>q.Tags).Include(q=>q.User).Where(i => i.QuestionID == item).SingleOrDefault();
                    lista.Add(p);
                }             
                return PartialView("_render_questions", lista.ToPagedList(page, 5));
            }
        }


        public ActionResult get_questions_by_tag(int id, int page = 1)
        {
            using (DBBL Baza = new DBBL())
            {

                List<int> listaIdPitanja = Baza.get_questionsIDsTags(id).ToList();
                List<Question> lista = new List<Question>();
                foreach (var item in listaIdPitanja)
                {

                    Question p = Baza.context.Questions.Include(q => q.Categories).Include(q => q.QuestionLikes).Include(q => q.Answers).Include(q => q.Tags).Include(q => q.User).Where(i => i.QuestionID == item).SingleOrDefault();
                    lista.Add(p);
                }



                return PartialView("_render_questions", lista.ToPagedList(page, 5));

            }
        }

     

    }
}

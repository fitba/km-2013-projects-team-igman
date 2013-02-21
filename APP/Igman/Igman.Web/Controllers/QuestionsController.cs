using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Igman.DB.DAL;
using Igman.DB.BLL;
using PagedList;
using System.Data.Entity;
using Igman.Infrastructure.Extend;
using System.Diagnostics;
using Igman.Infrastructure.Recommender.ExtrenalBase;
using Igman.Web.Models.Json;


namespace Igman.Web.Controllers
{
    public class QuestionsController : Controller
    {
        private DBBL _db = new DBBL();

        public ActionResult Index(string tab, int page = 1)
        {

            User a = Autorizacija.Autorizacija.GetCurrentUser(this.HttpContext);
            if (a != null)
                TempData["user"] = a;

            if (tab == "TopRated")
            {
                var questions = _db.context.Questions.Include(q => q.Categories).Include(q => q.User).Include(q => q.Tags).Include(q => q.Answers).OrderByDescending(q => q.Likes);
                ViewBag.brojKomentara = questions.Count();
                if (Request.IsAjaxRequest())
                {
                    return PartialView("_questions", questions.ToList().ToPagedList(page, 5));
                }

                return View(questions.ToList().ToPagedList(page, 5));
            }

            else if (tab == "MostViewed")
            {

                var questions = _db.context.Questions.Include(q => q.Categories).Include(q => q.User).Include(q => q.Tags).OrderByDescending(q => q.NumOfViews);
               
                if (Request.IsAjaxRequest())
                {
                    return PartialView("_questions", questions.ToList().ToPagedList(page, 5));
                }
                ViewBag.brojKomentara = questions.Count();
                return View(questions.ToList().ToPagedList(page, 5));
            }

            else if (tab == "MostAnswered")
            {

                var questions = _db.context.Questions.Include(q => q.Categories).Include(q => q.User).Include(q => q.Tags).OrderByDescending(q => q.Answers.Count);
                if (Request.IsAjaxRequest())
                {
                    return PartialView("_questions", questions.ToList().ToPagedList(page, 5));
                }
                ViewBag.brojKomentara = questions.Count();
                return View(questions.ToList().ToPagedList(page, 5));
            }
            else if (tab == "Week")
            {

                var questions = _db.context.Questions.Where(q => q.CreatedDate.Value > System.Data.Objects.EntityFunctions.AddDays(DateTime.Now, -7));
                if (Request.IsAjaxRequest())
                {
                    return PartialView("_questions", questions.ToList().ToPagedList(page, 5));
                }
                ViewBag.brojKomentara = questions.Count();
                return View(questions.ToList().ToPagedList(page, 5));
            }
            else if (tab == "Month")
            {

                var questions = _db.context.Questions.Where(q => q.CreatedDate.Value > System.Data.Objects.EntityFunctions.AddDays(DateTime.Now, -30));
                if (Request.IsAjaxRequest())
                {
                    return PartialView("_questions", questions.ToList().ToPagedList(page, 5));
                }
                ViewBag.brojKomentara = questions.Count();
                return View(questions.ToList().ToPagedList(page, 5));
            }
            else if (tab == "UnAnswered")
            {

                var questions = _db.context.Questions.Where(q => q.Answers.Count==0);
                if (Request.IsAjaxRequest())
                {
                    return PartialView("_questions", questions.ToList().ToPagedList(page, 5));
                }
                ViewBag.brojKomentara = questions.Count();

                return View(questions.ToList().ToPagedList(page, 5));
            }

            else
            {


                var questions = _db.context.Questions.OrderByDescending(q => q.QuestionID);
                if (Request.IsAjaxRequest())
                {
                    return PartialView("_questions", questions.ToList().ToPagedList(page, 5));
                }
                ViewBag.brojKomentara = questions.Count();

                return View(questions.ToList().ToPagedList(page, 5));
            }






        }


        public ActionResult Like(int id)
        {

            Question question = _db.context.Questions.Find(id);
            var like = question.Likes;
            var like_new = like + 1;
            question.Likes = like_new;
            _db.Update_Question(question);

            return Json(new { likes = like_new, id = id }, JsonRequestBehavior.AllowGet);
        }
        //
        // GET: /Questions/Details/5

        public ActionResult Details(int id)
        {

            User a = Autorizacija.Autorizacija.GetCurrentUser(this.HttpContext);
            if (a != null)
                TempData["user"] = a;

            ViewBag.ListaKomentara = _db.GetComments(id);
            ViewBag.RelatedQuestios = _db.context.Questions.Take(5).OrderByDescending(q => q.CreatedDate);

            var question = _db.context.Questions.Find(id);
            if (question == null)
            {
                return HttpNotFound();
            }
            QuestionExteranlBase eb = new QuestionExteranlBase(question.Tags.ToList());

            TempData["ExteranlQuestions"] = eb.PreporuciPitanja();


            var views = question.NumOfViews;
            var views_new = views + 1;
            question.NumOfViews = views_new;
            _db.Update_Question(question);
            ViewBag.QuestionID = question.QuestionID;
            return View(question);
        }

        //
        // GET: /Questions/Create
        //[Autorizacija.Autorizacija]
        public ActionResult Create()
        {

            ViewBag.Kategorije = _db.GetKatogorije();

            DB.DAL.User a = Autorizacija.Autorizacija.GetCurrentUser(this.HttpContext);
            if (a != null)
                TempData["user"] = a;
            return View();

        }

        //
        // POST: /Questions/Create

        [HttpPost]
        public ActionResult Create(string Naslov, string Content, string jsonTagQuestion, string jsonKatQuestion)
        {


            Question pitanje = new Question();
            pitanje.User = Autorizacija.Autorizacija.GetCurrentUser(this.HttpContext);
            pitanje.CreatedDate = DateTime.Now;
            pitanje.QuestionBody = Server.HtmlDecode(Content).Replace("'", "&#39;");
            pitanje.QuestionTitle = Naslov;
            pitanje.GUID = Guid.NewGuid();


            var ListaTagova = Newtonsoft.Json.JsonConvert.DeserializeObject<List<Models.Json.Tag>>(jsonTagQuestion);
            var ListaKategorija = Newtonsoft.Json.JsonConvert.DeserializeObject<List<Models.Json.Kategorija>>(jsonKatQuestion);

            List<Igman.DB.DAL.Tag> listTempTag = SinhronyzeWithDB(ListaTagova.Where(x => x.TagID == "-1").ToList(), ListaTagova.Where(x => x.TagID != "-1").ToList());
            List<Category> listaKategorija = SinhronyzeWithDB(ListaKategorija);

            pitanje.Categories = listaKategorija;
            pitanje.Tags = listTempTag;
            _db.AddQuestion(pitanje);


            return RedirectToAction("index", "Questions");
        }


        private List<Category> SinhronyzeWithDB(List<Models.Json.Kategorija> ListaKategorija)
        {
            List<Category> ltl = new List<Category>();
            foreach (var lista in ListaKategorija)
            {
                Category a = new Category();
                a.CategoryID = lista.KategorijaID.ToInt();
                ltl.Add(a);
            }
            return ltl;
        }

        private List<Igman.DB.DAL.Tag> SinhronyzeWithDB(List<Models.Json.Tag> list, List<Models.Json.Tag> insideList)
        {
            var lTag = new List<Igman.DB.DAL.Tag>();

            foreach (var tag in list)
            {
                Igman.DB.DAL.Tag t = new Igman.DB.DAL.Tag();
                t.Name = tag.Naziv;
                t.GUID = Guid.NewGuid();
                lTag.Add(_db.AddTag(t));
            }

            foreach (var tag in insideList)
            {
                Igman.DB.DAL.Tag t = new Igman.DB.DAL.Tag();
                t.Name = tag.Naziv;
                t.GUID = Guid.NewGuid();
                t.TagID = tag.TagID.ToInt();
                lTag.Add(t);
            }
            return lTag;

        }

        [Autorizacija.Autorizacija]
        public ActionResult Answer(string Content, int questionID)
        {
            Answer odgovor = new Answer();
            odgovor.AnswerBody = Server.HtmlDecode(Content).Replace("'", "&#39;");
            odgovor.CreatorID = Autorizacija.Autorizacija.GetCurrentUser(this.HttpContext).UserID;
            odgovor.CreatedID = DateTime.Now;
            odgovor.GUID = Guid.NewGuid();
            odgovor.QuestionID = questionID;
            odgovor.IsSpam = false;
            odgovor.Likes = 0;
            odgovor.User = Autorizacija.Autorizacija.GetCurrentUser(this.HttpContext);
            _db.Add_Answer(odgovor);

            return RedirectToAction("Details", "Questions", new { id = questionID });
        }



        public ActionResult CommentAnswer(string Komentar, int id)
        {
            Comment comment = new Comment();
            comment.AnswerID = id;
            comment.Body = Server.HtmlDecode(Komentar).Replace("'", "&#39;");
            comment.GUID = Guid.NewGuid();
            comment.Created = DateTime.Now;
            comment.CreatorUserAgent = this.HttpContext.Request.UserAgent;
            comment.CreatorIP = this.HttpContext.Request.GetIpAdresa();
            comment.CreatorName = Autorizacija.Autorizacija.GetCurrentUser(this.HttpContext).FirstName;
            comment.CreatorEmail = Autorizacija.Autorizacija.GetCurrentUser(this.HttpContext).Email;
            comment.CreatedByUserID = Autorizacija.Autorizacija.GetCurrentUser(this.HttpContext).UserID;
            comment.IsActive = true;
            comment.IsSpam = false;
            var Url = Request.UrlReferrer;
            _db.Add_Comment(comment);
            TempData["KomentSuccess"] = true;

            return Redirect(Url.ToString());
        }
        public ActionResult Answers(int id, string tab = "TopRated")
        {

            var mod = _db.context.Answers.OrderByDescending(a => a.CreatedID).ToList();
            if (tab == "TopRated")
            {
                var model = _db.context.Answers.Where(a => a.QuestionID == id).OrderByDescending(a => a.Comments.Count).ToList();
                ViewBag.QuestionID = id;
                ViewBag.ListaKomentara = _db.GetComments(id);
                return PartialView("_odgovori", model);
            }
            else if (tab == "Latest")
            {
                var model = _db.context.Answers.Where(a => a.QuestionID == id).OrderByDescending(a => a.CreatedID).ToList();
                ViewBag.QuestionID = id;
                ViewBag.ListaKomentara = _db.GetComments(id);
                return PartialView("_odgovori", model);
            }
            else if (tab == "Oldest")
            {
                var model = _db.context.Answers.Where(a => a.QuestionID == id).OrderBy(a => a.CreatedID).ToList();
                ViewBag.QuestionID = id;
                ViewBag.ListaKomentara = _db.GetComments(id);
                return PartialView("_odgovori", model);
            }


            return PartialView("_odgovori", mod);

        }


        public ActionResult Search(string args, int page=1)
        {
            CheckUser();
            Stopwatch st = new Stopwatch();
            st.Start();
            if (string.IsNullOrEmpty(args) || string.IsNullOrWhiteSpace(args))
            {
                return View();
            }
            if (args.Count() > 35)
            {
                TempData["err"] = "Maximalan upit do 35 karaktera";
                return View();
            }
            args = Formatiraj(args);
            
            #region Lucine
            //if (!strana.HasValue)
            //    strana = 1;
            //args = Formatiraj(args);
            //LuceneEngine.LuceneDbEngine ldbe = new LuceneEngine.LuceneDbEngine();
            //List<Rezultat> ids = ldbe.GetArticleIDByArg(args, false);
            //string idsParams = GetIds(ids);
            //string scores = GetScore(ids);
            //List<DB.DalHelpClass.ArticleSerch.ArticleSerchModel> listaNadjenih;
            #endregion
            using (DBBL Baza = new DBBL())
            {
               var listaNadjenih = Baza.GetPitanja(args);

                st.Stop();
                var br_rez = listaNadjenih.Count();
                if (br_rez > 0)
                {
                    TempData["stat"] = st.ElapsedMilliseconds / (double)1000;
                    TempData["lp"] = listaNadjenih;
                    TempData["args"] = args;
                    TempData["br_rez"] = br_rez;

                }

                else
                {
                    List<Igman.DB.DAL.Tag> mislilac = Baza.GetDaliSteMilili(args);
                    TempData["args"] = args;
                    TempData["mislilac"] = mislilac;

              
                }

                if (Request.IsAjaxRequest()) {

                    return PartialView("_QAPretraga", listaNadjenih.ToPagedList(page, 5));
                }
                return View(listaNadjenih.ToPagedList(page,5));
            }
           
         

        }

        #region Help
        internal string Formatiraj(string args)
        {
            string[] a = args.Split(" "[0]);
            args = "";
            foreach (var str in a)
            {
                if (str != "")
                    args += " " + str.Trim();
            }
            return args.Trim();
        }
        internal string GetIds(List<Rezultat> a)
        {

            if (a.Count == 0)
                return "";
            string s = "";
            foreach (var item in a)
            {
                s += string.Format("{0},", item.Id);
            }
            return s.Remove(s.Count() - 1);
        }
        internal string GetScore(List<Rezultat> a)
        {

            if (a.Count == 0)
                return "";
            string s = "";
            foreach (var item in a)
            {
                s += string.Format("{0},", item.Score);
            }
            return s.Remove(s.Count() - 1);
        }
        private void CheckUser()
        {
            DB.DAL.User a = Autorizacija.Autorizacija.GetCurrentUser(this.HttpContext);
            if (a != null)
                TempData["user"] = a;
        }
        #endregion
        protected override void Dispose(bool disposing)
        {
            _db.Dispose();
            base.Dispose(disposing);
        }

    }
}

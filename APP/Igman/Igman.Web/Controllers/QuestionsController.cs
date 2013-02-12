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

                return View(questions.ToList().ToPagedList(page, 5));
            }

            else if (tab == "MostAnswered")
            {

                var questions = _db.context.Questions.Include(q => q.Categories).Include(q => q.User).Include(q => q.Tags).OrderByDescending(q => q.Answers.Count);
                if (Request.IsAjaxRequest())
                {
                    return PartialView("_questions", questions.ToList().ToPagedList(page, 5));
                }

                return View(questions.ToList().ToPagedList(page, 5));
            }
            else if (tab == "Week")
            {

                var questions = _db.context.Questions.Where(q => q.CreatedDate.Value > System.Data.Objects.EntityFunctions.AddDays(DateTime.Now, -7));
                if (Request.IsAjaxRequest())
                {
                    return PartialView("_questions", questions.ToList().ToPagedList(page, 5));
                }

                return View(questions.ToList().ToPagedList(page, 5));
            }
            else if (tab == "Month")
            {

                var questions = _db.context.Questions.Where(q => q.CreatedDate.Value > System.Data.Objects.EntityFunctions.AddDays(DateTime.Now, -30));
                if (Request.IsAjaxRequest())
                {
                    return PartialView("_questions", questions.ToList().ToPagedList(page, 5));
                }

                return View(questions.ToList().ToPagedList(page, 5));
            }

            else
            {


                var questions = _db.context.Questions.OrderByDescending(q => q.QuestionID);
                if (Request.IsAjaxRequest())
                {
                    return PartialView("_questions", questions.ToList().ToPagedList(page, 5));
                }

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

            List<Tag> listTempTag = SinhronyzeWithDB(ListaTagova.Where(x => x.TagID == "-1").ToList(), ListaTagova.Where(x => x.TagID != "-1").ToList());
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

        private List<Tag> SinhronyzeWithDB(List<Models.Json.Tag> list, List<Models.Json.Tag> insideList)
        {
            var lTag = new List<Tag>();

            foreach (var tag in list)
            {
                Tag t = new Tag();
                t.Name = tag.Naziv;
                t.GUID = Guid.NewGuid();
                lTag.Add(_db.AddTag(t));
            }

            foreach (var tag in insideList)
            {
                Tag t = new Tag();
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



        protected override void Dispose(bool disposing)
        {
            _db.Dispose();
            base.Dispose(disposing);
        }

    }
}

using Igman.DB.BLL;
using Igman.DB.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Igman.Infrastructure.Extend;
using System.Diagnostics;
using Igman.Web.Models.Json;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Preporuke = Igman.Infrastructure.Recommender.ItemBase;
using Igman.DB.DalHelpClass;
using Igman.Infrastructure.Recommender.ItemBase;

namespace Igman.Web.Controllers
{
    [Autorizacija.Autorizacija(Autorizacija.TipKorsnika.User)]
    public class ArticlesController : Controller
    {

        public ActionResult Index()
        {
            using (DBBL Baza = new DBBL())
            {
                ViewBag.Kategorije = Baza.GetKatogorije();
            }
            CheckUser();
            return View();
        }
        public JsonResult GetTags(string arg)
        {
            List<Igman.DB.DAL.Tag> tags;
            using (DBBL Baza = new DBBL())
            {
                tags = Baza.GetTags(arg);
            }
            return Json(tags);
        }

        #region KMSBaseAlg
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult EditWiki(string Naslov, string Content, string jsonTag, string jsonKat, int? WikiId)
        {
            if (WikiId.HasValue)
            {
                using (DBBL Baza = new DBBL())
                {
                    Article a = Baza.GetWikiByID(WikiId.Value);
                    a.Name = Naslov;
                    a.Content = Server.HtmlDecode(Content).Replace("'", "&#39;").Trim();
                    a.CreatorIP = this.HttpContext.Request.GetIpAdresa();
                    a.CreatorUserAgent = this.HttpContext.Request.UserAgent;
                    a.DatePublish = DateTime.Now;
                    a.GUID = Guid.NewGuid();
                    a.IsActive = true;
                    a.Views = 0;
                    a.IsPublish = true;
                    a.UserID = Autorizacija.Autorizacija.GetCurrentUser(this.HttpContext).UserID;

                    var ListaTagova = Newtonsoft.Json.JsonConvert.DeserializeObject<List<Models.Json.Tag>>(jsonTag);
                    var ListaKategorija = Newtonsoft.Json.JsonConvert.DeserializeObject<List<Models.Json.Kategorija>>(jsonKat);

                    List<Igman.DB.DAL.Tag> listTempTag = SinhronyzeWithDB(ListaTagova.Where(x => x.TagID == "-1").ToList(), ListaTagova.Where(x => x.TagID != "-1").ToList());
                    List<Category> listaKategorija = SinhronyzeWithDB(ListaKategorija);

                    a.Categories = listaKategorija;
                    a.Tags = listTempTag;


                    a = Baza.EditWiki(a);



                    #region Lucine
                    LuceneEngine.LuceneDbEngine ldbe = new LuceneEngine.LuceneDbEngine();
                    ldbe.UpdateWiki(a);
                    #endregion

                    TempData["wikiSuccess"] = true;
                    return RedirectToRoute("Wiki-Edit", new { id = a.ArticlesID });
                }
               
            }
            return RedirectToAction("index", "Articles");
        }
        public ActionResult WikiEdit(int? id)
        {
            if (id.HasValue)
            {
                using (DBBL Baza = new DBBL())
                {
                    ViewBag.Kategorije = Baza.GetKatogorije();
                    Article w = Baza.GetWikiByID(id.Value);
                    TempData["w"] = w;
                    TempData["w-tag"] = w.Tags.ToList();
                    TempData["w-cat"] = w.Categories.ToList();
                }
                CheckUser();
                return View();
            }
            else
                return View("index");
        }

        #endregion

        #region Utli
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult AddKoment(string Komenatar, int? aid)
        {
            User user = Autorizacija.Autorizacija.GetCurrentUser(this.HttpContext);
            if (!aid.HasValue && string.IsNullOrEmpty(Komenatar))
                return RedirectToAction("Index", "Wellcome");
            int ArticlesID = aid.Value;
            try
            {

                Comment c = new Comment();

                c.CreatorName = user.FirstName + " " + user.LastName;
                c.CreatorUserAgent = this.Request.UserAgent;
                c.CreatorIP = this.Request.GetIpAdresa();
                c.GUID = Guid.NewGuid();
                c.IsActive = true;
                c.IsSpam = false;
                c.CreatorEmail = user.Email;
                c.Created = DateTime.Now;
                c.CreatedByUserID = user.UserID;
                c.Body = Komenatar;
                c.ArticleID = ArticlesID;

                using (DBBL Baza = new DBBL())
                {
                    Baza.AddKomentar(c);
                }

            }
            catch (Exception) { }
            return RedirectToRoute("GetWikiRoute", new { id = ArticlesID });

        }
        public ActionResult Tag(int? id, int? strana)
        {
            CheckUser();
            if (!strana.HasValue)
                strana = 1;
            if (id.HasValue)
            {
                using (DBBL Baza = new DBBL())
                {
                    List<DB.DalHelpClass.ArticleSerch.ArticleSerchModel> listaFromTag = Baza.GetTagByIDWikis(strana.Value, id.Value);
                    if (listaFromTag.Count == 0)
                        return RedirectToAction("index", "wellcome");
                    TempData["artcles"] = listaFromTag;
                    return View();
                }
            }
            return RedirectToAction("index", "wellcome");
        }
        #endregion

        #region GetWiki
        public string Rating(int? id, int? score)
        {

            Article a = null;
            int Uid = Autorizacija.Autorizacija.GetCurrentUser(this.HttpContext).UserID;
            string rating = "";
            if (id.HasValue && score.HasValue)
            {
                using (DBBL Baza = new DBBL())
                {

                    ArticlesRating ar = new ArticlesRating()
                    {
                        ArticlesID = id.Value,
                        UserID = Uid,
                        GUID = Guid.NewGuid(),
                        DateRating = DateTime.Now,
                        Score = score
                    };
                    try
                    {
                        Baza.AddRating(ar);
                    }
                    catch (Exception)
                    {

                        return "False";
                    }

                    a = Baza.GetWikiByID(id.Value);
                    int suma = 0;
                    foreach (var rat in a.ArticlesRatings.ToList())
                    {
                        suma += rat.Score.Value;
                    }
                    rating = (suma / a.ArticlesRatings.Count).ToString();
                }

            }
            return rating;
        }
        public string Like(int? id)
        {
            CheckUser();
            Article a = null;
            int Uid = Autorizacija.Autorizacija.GetCurrentUser(this.HttpContext).UserID;
            string likes = "";
            if (id.HasValue)
            {
                using (DBBL Baza = new DBBL())
                {

                    ArticlesLike al = new ArticlesLike()
                    {
                        ArticleID = id.Value,
                        UserID = Uid,
                        GUID = Guid.NewGuid(),
                        DateLike = DateTime.Now,
                        CreatorIP = this.Request.GetIpAdresa()
                    };
                    try
                    {
                        Baza.IncetrementLikes(al);
                    }
                    catch (Exception)
                    {

                        return "False";
                    }

                    a = Baza.GetWikiByID(id.Value);
                    likes = a.ArticlesLikes.Count.ToString();
                }

            }
            return likes;
        }
        public ActionResult Wiki(int? id)
        {
            CheckUser();
            if (id.HasValue)
            {
                using (DBBL Baza = new DBBL())
                {
                    Article a = Baza.GetWikiByID(id.Value);
                    int rating = 0;
                    if (a != null)
                    {

                        int suma = 0;
                        if (a.ArticlesRatings.Count > 0)
                        {
                            foreach (var rat in a.ArticlesRatings.ToList())
                            {
                                suma += rat.Score.Value;
                            }

                            rating = (suma / a.ArticlesRatings.Count);
                        }


                        TempData["wiki"] = a;
                        TempData["tags"] = a.Tags.ToList();
                        TempData["grup"] = a.Categories.ToList();
                        TempData["likes"] = a.ArticlesLikes.ToList().Count;
                        TempData["rating"] = rating;
                        TempData["Kom"] = a.Comments.OrderByDescending(x => x.CommentID).ToList();
                        Baza.IncremenViews(a.ArticlesID);


                        TempData["RecWiki"] = GetPreporuka(a);
                        return View();
                    }
                }
            }
            return RedirectToAction("Index", "Wellcome");
        }

        private List<ArticleRecommender> GetPreporuka(Article a)
        {
            Preporuke.ItemPreporuka ip = new Preporuke.ItemPreporuka(a);
            return ip.GetArtikliPreporucine();
        }


        #endregion

        #region Pretraga


        public ActionResult Search(string args, int? strana)
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
            if (!strana.HasValue)
                strana = 1;
            args = Formatiraj(args);

            LuceneEngine.LuceneDbEngine ldbe = new LuceneEngine.LuceneDbEngine();

            List<Rezultat> ids = ldbe.GetArticleIDByArg(args, false);

            string idsParams = GetIds(ids);
            string scores = GetScore(ids);
            List<DB.DalHelpClass.ArticleSerch.ArticleSerchModel> listaNadjenih;
            using (DBBL Baza = new DBBL())
            {
                listaNadjenih = Baza.PretragaWiki(idsParams, scores, strana.Value);

                st.Stop();
                if (listaNadjenih.Count > 0)
                {
                    TempData["stat"] = st.ElapsedMilliseconds / (double)1000;
                    TempData["lp"] = listaNadjenih;
                    TempData["args"] = args;
                }
                else
                {
                    List<Igman.DB.DAL.Tag> mislilac = Baza.GetDaliSteMilili(args);
                    TempData["mislilac"] = mislilac;
                }
            }
            return View();

        }


        #endregion

        #region AddWiki
        public ActionResult AddWiki()
        {
            return RedirectToAction("index", "Articles");
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult AddWiki(string Naslov, string Content, string jsonTag, string jsonKat)
        {

            Article a = new Article();
            a.Name = Server.HtmlDecode(Naslov).Replace("'", "&#39;").Trim();
            a.Content = Server.HtmlDecode(Content).Replace("'", "&#39;").Trim();
            a.CreatorIP = this.HttpContext.Request.GetIpAdresa();
            a.CreatorUserAgent = this.HttpContext.Request.UserAgent;
            a.DatePublish = DateTime.Now;
            a.GUID = Guid.NewGuid();
            a.IsActive = true;
            a.Views = 0;
            a.IsPublish = true;
            a.UserID = Autorizacija.Autorizacija.GetCurrentUser(this.HttpContext).UserID;

            var ListaTagova = Newtonsoft.Json.JsonConvert.DeserializeObject<List<Models.Json.Tag>>(jsonTag);
            var ListaKategorija = Newtonsoft.Json.JsonConvert.DeserializeObject<List<Models.Json.Kategorija>>(jsonKat);

            List<Igman.DB.DAL.Tag> listTempTag = SinhronyzeWithDB(ListaTagova.Where(x => x.TagID == "-1").ToList(), ListaTagova.Where(x => x.TagID != "-1").ToList());
            List<Category> listaKategorija = SinhronyzeWithDB(ListaKategorija);

            a.Categories = listaKategorija;
            a.Tags = listTempTag;

            using (DBBL Baza = new DBBL())
            {
                a = Baza.AddWiki(a);
            }


            #region Lucine
            LuceneEngine.LuceneDbEngine ldbe = new LuceneEngine.LuceneDbEngine();
            ldbe.InsertWiki(a);
            #endregion

            TempData["wikiSuccess"] = true;
            return RedirectToAction("index", "Articles");
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
            using (DBBL Baza = new DBBL())
            {
                foreach (var tag in list)
                {
                    Igman.DB.DAL.Tag t = new Igman.DB.DAL.Tag();
                    t.Name = tag.Naziv;
                    t.GUID = Guid.NewGuid();
                    lTag.Add(Baza.AddTag(t));
                }
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
        #endregion

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
    }
}

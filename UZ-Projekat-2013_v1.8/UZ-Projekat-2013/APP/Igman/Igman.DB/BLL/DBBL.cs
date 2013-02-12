using Igman.DB.DAL;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Igman.DB.BLL
{
    public class DBBL : IDisposable
    {

        public DBEntities context;

        #region Start
        public DBBL()
        {
            context = new DBEntities();
            context.Database.Connection.Open();
        }

        public void Dispose()
        {
            context.Database.Connection.Close();
            context.Dispose();
        }
        #endregion

        #region Korisnici
        public User GetUserByUserAndPass(string User, string Pass)
        {
            return context.Users.Where(x => x.Email == User && x.Password == Pass).SingleOrDefault();
        }
        public Role usp_GetRoleByUserID(int UserID)
        {
            string cmd = string.Format("EXEC dbo.GetRoleByUserID {0}", UserID);
            return context.Database.SqlQuery<Role>(cmd).FirstOrDefault();
        }
        public Role GetRoleByID(int p)
        {
            return context.Roles.Where(x => x.RoleID == p).SingleOrDefault();
        }

        public User AddUser(User u)
        {
            string cmd = string.Format("EXEC [dbo].[usp_UserInsert] '{0}','{1}','{2}',null,null,null,null,null,'{3}',null,null,'{4}','{5}',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null", u.GUID, u.FirstName, u.LastName, u.Password, u.Email, u.LoweredEmail);
            u = context.Database.SqlQuery<User>(cmd).SingleOrDefault();

            string cmdRole = string.Format("EXEC [dbo].[usp_UserRoleInsert] {0},{1}", 1, u.UserID);
            context.Database.ExecuteSqlCommand(cmdRole);

            return u;
        }
        public User GetUserByEmail(string p)
        {
            return context.Users.Where(x => x.Email == p || x.LoweredEmail == p).FirstOrDefault();
        }
        #endregion




        #region Kategorije
        public List<Category> GetKatogorije()
        {
            return context.Categories.OrderBy(x => x.Name).ToList();
        }
        #endregion


        public List<Tag> GetTags(string query)
        {
            return context.Database.SqlQuery<Tag>("EXEC dbo.GetTags '"+query+"'").ToList();
        }

        public Tag AddTag(Tag t)
        {
            string cmd = string.Format("EXEC dbo.usp_TagInsert '{0}','{1}'", t.GUID, t.Name);
            return context.Database.SqlQuery<Tag>(cmd).SingleOrDefault();
        }
        public Article AddWiki(Article a)
        {
            List<Tag> tags = a.Tags.ToList();
            List<Category> kate = a.Categories.ToList();

            string cmd = string.Format("EXEC dbo.usp_ArticlesInsert '{0}',null,'{1}','{2}','{3}','{4}',{5},'{6}','{7}',null,'{8}',null,{9}", a.Name, a.Content, a.DatePublish.Value.ToString("MM/dd/yyyy HH:mm:ss", CultureInfo.InvariantCulture), a.IsPublish, a.IsActive, a.Views, a.GUID, a.CreatorIP, a.CreatorUserAgent, a.UserID);
            a = context.Database.SqlQuery<Article>(cmd).SingleOrDefault();

            foreach (var tag in tags)
            {
                context.Database.ExecuteSqlCommand("EXEC dbo.usp_TagInArticleInsert "+a.ArticlesID+","+tag.TagID);
            }
            foreach (var cat in kate)
            {
                context.Database.ExecuteSqlCommand("EXEC [dbo].[usp_ArticlesInCategoryInsert] " + a.ArticlesID + "," + cat.CategoryID);
            }
            return a;
        }

        public List<Igman.DB.DalHelpClass.ArticleSerch.ArticleSerchModel> PretragaWiki(string args,string scor,int strana)
        {
            string cmd = string.Format("EXEC [dbo].GetPretragaWiki {0},2,'{1}','{2}'",strana,args,scor);
            return context.Database.SqlQuery<Igman.DB.DalHelpClass.ArticleSerch.ArticleSerchModel>(cmd).ToList();
        }

        public Article GetWikiByID(int p)
        {
            return context.Articles.Where(x => x.ArticlesID == p).SingleOrDefault();
        }

        public void IncetrementLikes(ArticlesLike al)
        {
            context.Database.ExecuteSqlCommand(String.Format("EXEC dbo.usp_ArticlesLikesInsert {0},{1},'{2}','{3}','{4}'",al.ArticleID,al.UserID,al.DateLike,al.CreatorIP,al.GUID));
        }

        public void IncremenViews(int p)
        {
            context.Database.ExecuteSqlCommand("EXEC dbo.IncerementViews " + p);
        }

        public List<Tag> GetDaliSteMilili(string args)
        {
            return context.Database.SqlQuery<Tag>(string.Format("EXEC dbo.PreoprukaTaga '{0}'",args.Replace("'",""))).ToList();
        
        }

        public Tag GetTagByID(int p)
        {
            return context.Tags.Where(x => x.TagID == p).FirstOrDefault();
        }

        public List<DalHelpClass.ArticleSerch.ArticleSerchModel> GetTagByIDWikis(int strana,int  p)
        {
            string cmd = string.Format("EXEC dbo.PagingTagWiki {0},2,{1}",strana,p);
            return context.Database.SqlQuery<Igman.DB.DalHelpClass.ArticleSerch.ArticleSerchModel>(cmd).ToList();
        }

        public List<Article> GetAI(string args)
        {
            return context.Database.SqlQuery<Article>(string.Format("EXEC dbo.GetAiComplete '{0}'", args)).ToList();
        }

        public void AddRating(ArticlesRating ar)
        {
            string cmd = string.Format("EXEC [dbo].[usp_ArticlesRatingInsert] {0},{1},'{2}',null,'{3}',{4}", ar.ArticlesID, ar.UserID, ar.DateRating, ar.GUID, ar.Score);
            context.Database.ExecuteSqlCommand(cmd);
        }

        public void AddKomentar(Comment c)
        {
            context.Comments.Add(c);
            context.SaveChanges();
        }

        public int GetBrojUsera()
        {
            return context.Users.Count();
        }
        public int GetBrojWiki()
        {
            return context.Articles.Count();
        }
        public int GetBrojQA()
        {
            return context.Questions.Count();
        }

        public List<Article> GetAllWikis()
        {
            return context.Articles.ToList();
        }

        public Article EditWiki(Article a)
        {
            context.Database.ExecuteSqlCommand("EXEC dbo.DeleteTagInCategory " + a.ArticlesID);
            context.Database.ExecuteSqlCommand("EXEC dbo.DeleteTagInArticles " + a.ArticlesID);
            context.Database.ExecuteSqlCommand("EXEC  dbo.DeleteRating " + a.ArticlesID);
            context.Database.ExecuteSqlCommand("EXEC [dbo].[usp_ArticlesDelete] " + a.ArticlesID);
           
            return AddWiki(a);
        }

        //QA modul


        public void AddQuestion(Question pitanje)
        {
            List<Tag> tags = pitanje.Tags.ToList();
            List<Category> kate = pitanje.Categories.ToList();

            string cmd = string.Format("EXEC [dbo].[usp_QuestionsInsert] '{0}',{1},'{2}','{3}','{4}',{5},{6}", pitanje.QuestionBody, pitanje.User.UserID, pitanje.CreatedDate.Value.ToString("MM/dd/yyyy H:m:s:f", CultureInfo.InvariantCulture), pitanje.GUID, pitanje.QuestionTitle, 0, 0);
            pitanje = context.Database.SqlQuery<Question>(cmd).SingleOrDefault();

            foreach (var tag in tags)
            {
                context.Database.ExecuteSqlCommand("EXEC dbo.usp_TagInQuestionInsert " + pitanje.QuestionID + "," + tag.TagID);
            }
            foreach (var cat in kate)
            {
                context.Database.ExecuteSqlCommand("EXEC [dbo].[usp_QuestionsInCategoryInsert] " + pitanje.QuestionID + "," + cat.CategoryID);
            }

        }

        public void Update_Question(Question q)
        {


            context.Database.ExecuteSqlCommand("EXEC [dbo].[usp_QuestionsUpdate] {0},{1},{2},{3},{4},{5},{6}", q.QuestionID, q.QuestionBody, q.User.UserID, q.CreatedDate, q.GUID, q.Likes, q.NumOfViews);
        }


        public void Add_Answer(Answer a)
        {


            context.Database.ExecuteSqlCommand("EXEC [dbo].[usp_AnswersInsert] {0},{1},{2},{3},{4},{5},{6}", a.AnswerBody, a.IsSpam, a.CreatorID, a.CreatedID, a.QuestionID, a.GUID, a.Likes);
        }


        public void Add_Comment(Comment c)
        {
            context.Database.ExecuteSqlCommand("EXEC [dbo].[usp_CommentInsert] {0},{1},{2},{3},{4},null,{5},{6},{7},{8},{9},null,null,null,{10}", c.GUID, c.CreatorIP, c.CreatorUserAgent, c.CreatorEmail, c.CreatorName, c.Body, c.IsActive, c.IsSpam, c.Created, c.CreatedByUserID, c.AnswerID);
        }

        public IEnumerable<Comment> GetComments(int id)
        {
            string cmd = string.Format("EXEC [dbo].[usp_SelectComments] {0}", id);
            return context.Database.SqlQuery<Comment>(cmd).ToList();


        }

    }
}
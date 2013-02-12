using Igman.DB.BLL;
using Igman.DB.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Igman.Web.Autorizacija
{
    public enum TipKorsnika
    {
        Administrator = 1,
        User = 2
    }

    [AttributeUsageAttribute(AttributeTargets.Class | AttributeTargets.Method)]
    public class Autorizacija : AuthorizeAttribute, System.Web.Mvc.IAuthorizationFilter
    {
        public TipKorsnika Tip { get; set; }
        public Autorizacija(TipKorsnika tip = TipKorsnika.User)
        {
            this.Tip = tip;
        }
      
        public void OnAuthorization(AuthorizationContext filterContext)
        {
            if (filterContext.HttpContext.Session["user"] != null)
            {
                DB.DAL.User loginUser = filterContext.HttpContext.Session["user"] as DB.DAL.User;
                switch (this.Tip)
                {
                    case TipKorsnika.Administrator:
                        {
                            if (!CheckRoleByUser(loginUser, TipKorsnika.Administrator))
                            {
                                filterContext.Result = new RedirectResult("/Home/");
                            }
                        } break;
                    case TipKorsnika.User:
                        {
                            if (!CheckRoleByUser(loginUser, TipKorsnika.User))
                            {
                                filterContext.Result = new RedirectResult("/Home/");
                            }
                        } break;

                    default:
                        break;
                }

            }
            else
                filterContext.Result = new RedirectResult("/Home/");
        }

        private bool CheckRoleByUser(User loginUser, TipKorsnika tipKorsnika)
        {
            using (DBBL Baza = new DBBL())
            {
               
                Role r = Baza.usp_GetRoleByUserID(loginUser.UserID);
                if (r.RoleID == (int)tipKorsnika)
                    return true;
                return false;
            }


        }
        public static User GetCurrentUser(HttpContext httpContext)
        {
            if (httpContext.Session["user"] != null)
                return httpContext.Session["user"] as User;
            return null;
        }
        public static User GetCurrentUser(HttpContextBase hc)
        {
           if (hc.Session["user"] != null)
                return hc.Session["user"] as User;
            return null;
        }
        internal static void AddUserLogin(User u, HttpContextBase hc)
        {
            hc.Session.Add("user", u);
        }
        internal static void AddUserLogin(User u, HttpContext hc)
        {
            hc.Session.Add("user", u);
        }
    }
}
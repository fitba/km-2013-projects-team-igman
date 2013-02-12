using Igman.DB.BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Igman.Web.Controllers
{
    public class RegistrationController : Controller
    {
        [ValidateAntiForgeryToken]
        public ActionResult Registration(Models.Registartion r)
        {
            if (ModelState.IsValid)
            {
                using (DBBL DB = new DBBL())
                {
                    //check postojeceg usera
                    Igman.DB.DAL.User u;

                    u = DB.GetUserByEmail(r.Email);
                    if (u != null)
                    {
                        TempData["ExistUser"] = u;
                        return RedirectToAction("index", "wellcome");
                    }
                    u = new Igman.DB.DAL.User();

                    u.FirstName = r.FirstName;
                    u.LastName = r.LastName;

                    u.LoweredEmail = r.Email.ToLower();
                    u.Email = r.Email;

                    u.Password = r.Password;
                    u.GUID = Guid.NewGuid();

                    u.IsApproved = true;
                    u.LastLogin = DateTime.Now;

                    u.Roles.Add(DB.GetRoleByID(2)); // User (2)

                    u = DB.AddUser(u);
                    Autorizacija.Autorizacija.AddUserLogin(u, this.HttpContext);
                }
            }
            return RedirectToAction("index", "wellcome");
        }
        [ValidateAntiForgeryToken]
        public ActionResult Login(string User, string Pass)
        {
            using (DBBL DB = new DBBL())
            {
                Igman.DB.DAL.User u = DB.GetUserByUserAndPass(User, Pass);
                if (u != null)
                    Autorizacija.Autorizacija.AddUserLogin(u, this.HttpContext);
                else
                    TempData["wrongPass"] = true;
            }
            return RedirectToAction("index", "wellcome");
        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace Igman.Web
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");
            routes.MapRoute(
             name: "GetUtli",
             url: "Wiki-Show-Util/{id}/{strana}",
             defaults: new { controller = "Articles", action = "Tag", id = UrlParameter.Optional, strana = UrlParameter.Optional }
         );
            routes.MapRoute(
              name: "Wiki-Edit",
              url: "Wiki-Edit/{id}",
              defaults: new { controller = "Articles", action = "WikiEdit", id = UrlParameter.Optional }
          );
            routes.MapRoute(
               name: "GetWikiRoute",
               url: "Wiki-Show/{id}",
               defaults: new { controller = "Articles", action = "Wiki", id = UrlParameter.Optional }
           );
            routes.MapRoute(
               name: "PagingRoute",
               url: "Articles/{action}/{args}/{strana}",
               defaults: new { controller = "Articles", action = "Index", args = UrlParameter.Optional, strana = UrlParameter.Optional }
           );
            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
                defaults: new { controller = "Home", action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}
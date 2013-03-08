using System.Web;
using System.Web.Optimization;

namespace Igman.Web
{
    public static class BundleConfig
    {
        // For more information on Bundling, visit http://go.microsoft.com/fwlink/?LinkId=254725
        public static void RegisterBundles(BundleCollection bundles)
        {



            //// Use the development version of Modernizr to develop with and learn from. Then, when you're
            //// ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Content/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/jquery")
                              .Include("~/Content/Scripts/jquery-{version}.js")
                              .Include("~/Content/Scripts/jquery-ui-{version}.js")
                              );


            bundles.Add(new ScriptBundle("~/bundles/js")
                              .Include("~/Content/Scripts/jquery.unobtrusive*")
                              .Include("~/Content/Scripts/jquery.validate*")
                              .Include("~/Content/Scripts/HtmlEditor/lib/js/wysihtml5-0.3.0.js")
                              .Include("~/Content/Scripts/HtmlEditor/src/bootstrap-wysihtml5.js")
                              .Include("~/Content/Scripts/jquery.fullbg.js")
                              .Include("~/Content/Scripts/startBG.js")
                              .Include("~/Content/Scripts/Igman.Core.js")
                              .Include("~/Content/Scripts/jquery.nicescroll.js")
                              .Include("~/Content/Template/bootstrap/js/bootstrap.js")
                              .Include("~/Content/Scripts/bootstrap-typeahead.js")
                              .Include("~/Content/Scripts/Wizzard/js/jquery.smartWizard.js")
                              .Include("~/Content/Scripts/jquery.tagcloud.js")
                              .Include("~/Content/Scripts/jquery.wijmo.wijutil.js")
                              .Include("~/Content/Scripts/jquery.wijmo.wijmenu.js")
                       );




            //bundles.Add(new StyleBundle("~/Content/css")
            //    .Include("~/Content/Template/css/Igman.Core.css")
            //    .Include("~/Content/Template/bootstrap/css/bootstrap.css")
            //    .Include("~/Content/Scripts/HtmlEditor/src/bootstrap-wysihtml5.css")             
            //    .Include("~/Content/Scripts/HtmlEditor/lib/css/wysiwyg-color.css")
            //    .Include("~/Content/Scripts/Wizzard/styles/smart_wizard.css")
            //    .Include("~/Content/themes/base/jquery-ui.css") 
            //    );

            //bundles.Add(new StyleBundle("~/Content/themes/base/css").Include(
            //            "~/Content/themes/base/jquery.ui.core.css",
            //            "~/Content/themes/base/jquery.ui.resizable.css",
            //            "~/Content/themes/base/jquery.ui.selectable.css",
            //            "~/Content/themes/base/jquery.ui.accordion.css",
            //            "~/Content/themes/base/jquery.ui.autocomplete.css",
            //            "~/Content/themes/base/jquery.ui.button.css",
            //            "~/Content/themes/base/jquery.ui.dialog.css",
            //            "~/Content/themes/base/jquery.ui.slider.css",
            //            "~/Content/themes/base/jquery.ui.tabs.css",
            //            "~/Content/themes/base/jquery.ui.datepicker.css",
            //            "~/Content/themes/base/jquery.ui.progressbar.css",
            //            "~/Content/themes/base/jquery.ui.theme.css"));
        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;

namespace Igman.Infrastructure.Extend
{
    public static class ExtendMethod
    {
        public static int ToInt(this string str)
        {
            try
            {
                return int.Parse(str);
            }
            catch (Exception)
            {

                throw new Exception("Problem konverziji");
            }
        }
        
        public static double ToDouble(this string str)
        {
            try
            {
                return double.Parse(str);
            }
            catch (Exception)
            {

                throw new Exception("Problem konverziji");
            }
        }

        public static string GetIpAdresa(this HttpRequestBase zahtjev)
        {
            string ip;
            try
            {
                ip = zahtjev.ServerVariables["HTTP_X_FORWARDED_FOR"];
                if (!string.IsNullOrEmpty(ip))
                {
                    if (ip.IndexOf(",") > 0)
                    {
                        string[] ipRange = ip.Split(',');
                        int le = ipRange.Length - 1;
                        ip = ipRange[le];
                    }
                }
                else
                {
                    ip = zahtjev.UserHostAddress;
                }
            }
            catch { ip = null; }

            return ip;
        }

        public static MvcHtmlString Pager(this HtmlHelper helper, long? totalRows, long? pageSize, long? pageIndex, int pageButtons, string currentLocation)
        {
            Int64 pageCount = totalRows.Value / pageSize.Value;
            if (totalRows % pageSize > 0)
                pageCount++;

            Int64 min = pageIndex.Value - pageButtons;
            Int64 max = pageIndex.Value + pageButtons;
            if (max > pageCount)
                min -= max - pageCount;
            else if (min < 1)
                max += 1 - min;

            StringBuilder sb = new StringBuilder();
            sb.Append(@"<div class=""pagination"">");
            sb.Append(@"<ul>");

            if (pageIndex > 1)
            {
                sb.AppendFormat(string.Format("<li class='btn-pager'><a href='{0}/{1}'>Predhodna</a></li>", currentLocation, pageIndex - 1));
               
            }

            bool needDiv = false;
            for (int i = 1; i <= pageCount; i++)
            {

                if (i <= 2 || i > pageCount - 2 || (min <= i && i <= max))
                {
                    if (i == pageIndex)
                    {
                        sb.AppendFormat(string.Format("<li class='active'><a href='{0}/{1}'>{2}</a></li>", currentLocation, i, i));
                        
                    }
                    else if (i == 1 && pageIndex == 0)
                    {
                        sb.AppendFormat(string.Format("<li class='active'><a href='{0}/{1}'>{2}</a></li>", currentLocation, i, i));
                        
                    }
                    else
                    {
                        sb.AppendFormat(string.Format("<li class='btn-pager'><a href='{0}/{1}'>{2}</a></li>", currentLocation, i, i));
                      
                    }
                    needDiv = true;
                }
                else if (needDiv)
                {
                    sb.AppendFormat("<li class='btn-pager'><a href=''>...</a></li>");
                   
                    needDiv = false;
                }
            }

            if (pageIndex < pageCount)
            {
                if (pageIndex > 0)
                    sb.AppendFormat(string.Format("<li class='btn-pager'><a href='{0}/{1}'>Sljedeća</a></li>", currentLocation, pageIndex + 1));
             
                else
                    sb.AppendFormat(string.Format("<li class='btn-pager'><a href='{0}/{1}'>Predhodna</a></li>", currentLocation, pageIndex + 2));
               
            }

            sb.Append(@"</ul></div>");
            sb.Append(@"<div class=""Paged-info"">");
            if (pageIndex > 0 && pageIndex <= pageCount)
            {
                sb.AppendFormat(string.Format(@"Nalazite se na {0} starnici od {1} ukupno. Ukupno objavljenih {2}", pageIndex, pageCount, totalRows));
            }
            else
            {
                sb.AppendFormat(string.Format(@"Nalazite se na {0} starnici od {1} ukupno. Ukupno objavljenih {2}", 1, pageCount, totalRows));
            }
            sb.Append(@"</div>");

            return new MvcHtmlString(sb.ToString());
        }

        public static string BoldTermin(this string text, string rijec, bool full = true)
        {
            if (text == String.Empty || rijec == String.Empty)
                return text;
            var rijeci = rijec.Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            if (!full)
                return rijeci.Select(word => word.Trim()).Aggregate(text,
                             (str_1, sablon) =>
                             Regex.Replace(str_1,
                                             sablon,
                                               string.Format("<strong>{0}</strong>",

                                    "$0"),
                                    RegexOptions.IgnoreCase));
            return rijeci.Select(word => "\\b" + word.Trim() + "\\b")
                        .Aggregate(text, (str_1, sablon) =>
                                  Regex.Replace(str_1,
                                  sablon,
                                    string.Format("<strong>{0}</strong>",

                                    "$0"),
                                    RegexOptions.IgnoreCase));
        }

        
        public static string ModIdToInt(this List<int> a)
        {
            if (a.Count == 0)
                return "";
            string s = "";
            foreach (var item in a)
            {
                s += string.Format("{0},", item);
            }
            return s.Remove(s.Count() - 1);
        }

        public static string OcistiHtml(this string text)
        {
            return Regex.Replace
              (text, "<(.|\\n)+?>", string.Empty).Replace("&nbsp;", " ");
        }

        private static List<int> IndexOfAll(string interni, string externi, StringComparison kompresija)
        {
            int pos;
            int of = 0;
            int duzina = externi.Length;
            List<int> pozicija = new List<int>();
            while ((pos = interni.IndexOf(externi, of, kompresija)) != -1)
            {
                pozicija.Add(pos);
                of = pos + duzina;
            }
            return pozicija;
        }
        public static string PretragaRadius(this string text, string[] rijeci, int duzina)
        {
            string final = "";
            List<int> lokacija = new List<int>();

           
            for (int i = 0; i < rijeci.Count(); i++)
                lokacija.AddRange(IndexOfAll(text, rijeci[i], StringComparison.CurrentCultureIgnoreCase));

  
            lokacija.Sort();

    
            if (lokacija.Count > 1)
            {
                bool potreba = true;
                while (potreba)
                {
                    potreba = false;
                    for (int i = lokacija.Count - 1; i > 0; i--)
                        if (lokacija[i] - lokacija[i - 1] < duzina / 2)
                        {
                            lokacija[i - 1] = (lokacija[i] + lokacija[i - 1]) / 2;

                            lokacija.RemoveAt(i);

                            potreba = true;
                        }
                }
            }

    
            if (lokacija.Count > 0 && lokacija[0] - duzina / 2 > 0)
                final = "... ";
            foreach (int i in lokacija)
            {
                int start = Math.Max(0, i - duzina / 2);
                int kraj = Math.Min(i + duzina / 2, text.Length);
                int duzinaFinall = Math.Min(kraj - start, text.Length - start);
                final += text.Substring(start, duzinaFinall);
                if (kraj < text.Length) final += " ... ";
                if (final.Length > 200) break;
            }

            return final;

        }
        public static string ToRelativeDateString(this DateTime value, bool approximate)
        {
            StringBuilder sb = new StringBuilder();

            string suffix = (value > DateTime.Now) ? " Sada" : "Prije ";

            TimeSpan timeSpan = new TimeSpan(Math.Abs(DateTime.Now.Subtract(value).Ticks));

            if (timeSpan.Days > 0)
            {
                sb.AppendFormat("{0} {1}", timeSpan.Days,
                  (timeSpan.Days > 1) ? "dana" : "dan");
                if (approximate) return suffix + sb.ToString();
            }
            if (timeSpan.Hours > 0)
            {
                sb.AppendFormat("{0}{1} {2}", (sb.Length > 0) ? ", " : string.Empty,
                  timeSpan.Hours, (timeSpan.Hours > 1) ? "sati" : "sat");
                if (approximate) return suffix + sb.ToString();
            }
            if (timeSpan.Minutes > 0)
            {
                sb.AppendFormat("{0}{1} {2}", (sb.Length > 0) ? ", " : string.Empty,
                  timeSpan.Minutes, (timeSpan.Minutes > 1) ? "minute" : "minutu");
                if (approximate) return suffix + sb.ToString();
            }
            if (timeSpan.Seconds > 0)
            {
                sb.AppendFormat("{0}{1} {2}", (sb.Length > 0) ? ", " : string.Empty,
                  timeSpan.Seconds, (timeSpan.Seconds > 1) ? "sekunde" : "sekundu");
                if (approximate) return suffix + sb.ToString();
            }
            if (sb.Length == 0) return "Upravo sada";

            sb.Append(suffix);
            return sb.ToString();
        }
    }
}

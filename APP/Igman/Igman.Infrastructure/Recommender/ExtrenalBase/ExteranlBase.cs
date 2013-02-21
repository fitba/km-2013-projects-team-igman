using Igman.DB.DalHelpClass;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace Igman.Infrastructure.Recommender.ExtrenalBase
{
    public class ExteranlBase
    {
        public string[] args { get; set; }
        List<WikiExtrenal> lista;
        public ExteranlBase(string[] args)
        {
            this.args = args;
            lista = new List<WikiExtrenal>();
        }

        public ExteranlBase(List<DB.DAL.Tag> list)
        {
            this.args = new string[list.Count];
           for (int i = 0; i < list.Count; i++)
			{
			    this.args[i] = list[i].Name;
			}
           this.lista = new List<WikiExtrenal>();
        }
        public List<WikiExtrenal> Preporuci()
        {
            Parallel.ForEach(args, (arg) => this.lista.AddRange(GetOdgovor(arg)));
            return this.lista;
        }
        IEnumerable<WikiExtrenal> GetOdgovor(string a)
        {
            List<WikiExtrenal> ls = new List<WikiExtrenal>();
            HttpWebRequest request
                = WebRequest.Create("http://en.wikipedia.org/w/api.php?action=opensearch&search=" + a + "&limit=10&namespace=0&format=xml") as HttpWebRequest;
            request.UserAgent = "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)";

            string odg;
            using (StreamReader reader = new StreamReader(request.GetResponse().GetResponseStream()))
            {
                odg = reader.ReadToEnd();
                ls.AddRange(GetWikiByXml(odg));
            }
            return ls;

        }
        IEnumerable<WikiExtrenal> GetWikiByXml(string a)
        {

            using (StringReader textReader = new StringReader(a))
            {
                using (XmlReader xmlReader = XmlReader.Create(textReader))
                {
                    while (xmlReader.Read())
                    {
                        WikiExtrenal we = new WikiExtrenal();
                        if (xmlReader.Name == "Image")
                            we.Slika = xmlReader.ReadInnerXml();
                        if (xmlReader.Name == "Text")
                            we.Naziv = xmlReader.ReadInnerXml();
                        if (xmlReader.Name == "Description")
                            we.Opis = xmlReader.ReadInnerXml();
                        if (xmlReader.Name == "Url")
                            we.Url = xmlReader.ReadInnerXml();
                        if (we.Naziv == null || we.Url == null)
                            continue;
                        yield return we;
                    }
                      
                }
                yield break;
            }
        }
        #region preporukaPitanja


        public object PreporuciPitanja()
        {
            Parallel.ForEach(args, (arg) => this.lista.AddRange(GetPitanja(arg)));
            return this.lista;
        }

        IEnumerable<WikiExtrenal> GetPitanja(string a)
        {
            List<WikiExtrenal> ls = new List<WikiExtrenal>();
            HttpWebRequest request
                = WebRequest.Create("http://api.stackoverflow.com/1.1/search?intitle=" + a + "&pagesize=10&sort=votes") as HttpWebRequest;
            request.UserAgent = "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)";

            string odg;
            using (StreamReader reader = new StreamReader(request.GetResponse().GetResponseStream()))
            {
                odg = reader.ReadToEnd();
                ls.AddRange(GetQuestionsFromJson(odg));
            }
            return ls;

        }


        IEnumerable<WikiExtrenal> GetQuestionsFromJson(string a)
        {

            using (StringReader textReader = new StringReader(a))
            {
                using (XmlReader xmlReader = XmlReader.Create(textReader))
                {
                    while (xmlReader.Read())
                    {
                        WikiExtrenal we = new WikiExtrenal();
                        if (xmlReader.Name == "Image")
                            we.Slika = xmlReader.ReadInnerXml();
                        if (xmlReader.Name == "Text")
                            we.Naziv = xmlReader.ReadInnerXml();
                        if (xmlReader.Name == "Description")
                            we.Opis = xmlReader.ReadInnerXml();
                        if (xmlReader.Name == "Url")
                            we.Url = xmlReader.ReadInnerXml();
                        if (we.Naziv == null || we.Url == null)
                            continue;
                        yield return we;
                    }

                }
                yield break;
            }
        }

        #endregion;
    }
}

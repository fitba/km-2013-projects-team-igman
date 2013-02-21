using Igman.DB.DalHelpClass;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Diagnostics.Contracts;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using Igman.Infrastructure.Extend;
using System.Xml.Linq;
using System.Web;
using System.Web.Script.Serialization;


namespace Igman.Infrastructure.Recommender.ExtrenalBase
{
    public class QuestionExteranlBase
    {
        public string[] args { get; set; }
        List<QuestionsExternal> lista;
        public QuestionExteranlBase(string[] args)
        {
            this.args = args;
            lista = new List<QuestionsExternal>();
        }

        public QuestionExteranlBase(List<DB.DAL.Tag> list)
        {
            this.args = new string[list.Count];
            for (int i = 0; i < list.Count; i++)
            {
                this.args[i] = list[i].Name;
            }
            this.lista = new List<QuestionsExternal>();
        }

        public object PreporuciPitanja()
        {
            Parallel.ForEach(args, (arg) => this.lista.AddRange(GetPitanja(arg)));
            return this.lista;
        }

        IEnumerable<QuestionsExternal> GetPitanja(string a)
        {
            List<QuestionsExternal> ls = new List<QuestionsExternal>();

            string url = "http://api.stackoverflow.com/1.1/search?intitle=" + HttpUtility.UrlEncode(a) + "&pagesize=5&sort=votes";
            var request = (HttpWebRequest)WebRequest.Create(url);
            var response = request.GetResponse();

            string json = ExtractJsonResponse(response);

            JavaScriptSerializer js = new JavaScriptSerializer();
            dynamic d = js.Deserialize<dynamic>(json);


            dynamic[] questions = d["questions"];
            for (int i = 0; i < questions.Length; i++)
            {
                QuestionsExternal q = new QuestionsExternal();
                q.question_timeline_url = questions[i]["question_timeline_url"];
                q.title = questions[i]["title"];
                ls.Add(q);
            }

            return ls;
        }

        private string ExtractJsonResponse(WebResponse response)
        {
            string json;
            using (var outStream = new MemoryStream())
            using (var zipStream = new GZipStream(response.GetResponseStream(),
                CompressionMode.Decompress))
            {
                zipStream.CopyTo(outStream);
                outStream.Seek(0, SeekOrigin.Begin);
                using (var reader = new StreamReader(outStream, Encoding.UTF8))
                {
                    json = reader.ReadToEnd();
                }
            }
            return json;
        }



    }
}


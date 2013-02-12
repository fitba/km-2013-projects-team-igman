using Igman.DB.DAL;
using Lucene.Net.Analysis.Standard;
using Lucene.Net.Documents;
using Lucene.Net.Index;
using Lucene.Net.QueryParsers;
using Lucene.Net.Search;
using Lucene.Net.Store;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Folder = Lucene.Net.Store.Directory;
using Igman.Infrastructure.Extend;
using Lucene.Net.Analysis;
using Igman.Web.Models.Json;

namespace Igman.Web.LuceneEngine
{
    public class LuceneDbEngine
    {
        public StandardAnalyzer anliza { get; set; }
        Folder folder { get; set; }

        public LuceneDbEngine(string PutanjaRelativna = "//App_Data")
        {
            string full = HttpContext.Current.Server.MapPath("/App_Data");
            full += "//DB_Wiki";

            folder = FSDirectory.Open(new DirectoryInfo(full));
            anliza = new StandardAnalyzer(Lucene.Net.Util.Version.LUCENE_30);
        }

        public bool InsertWiki(Article wiki)
        {
            try
            {
                IndexWriter iw = new IndexWriter(this.folder, this.anliza, IndexWriter.MaxFieldLength.UNLIMITED);
                var WikiDocument = new Document();

                WikiDocument.Add(new Field("ArticlesID", wiki.ArticlesID.ToString(), Field.Store.YES, Field.Index.ANALYZED));
                WikiDocument.Add(new Field("Name", wiki.Name, Field.Store.YES, Field.Index.ANALYZED));
                WikiDocument.Add(new Field("Content", wiki.Content.OcistiHtml(), Field.Store.YES, Field.Index.ANALYZED));

                iw.AddDocument(WikiDocument);
                iw.Optimize();
                iw.Commit();
                iw.Dispose();

                return true;

            }
            catch (Exception)
            {

                return false;
            }

        }
        public bool DeleteWiki(Article wiki)
        {
            try
            {
                IndexWriter iw = new IndexWriter(this.folder, this.anliza, IndexWriter.MaxFieldLength.UNLIMITED);
                Term t = new Term("ArticlesID", wiki.ArticlesID.ToString());
                iw.DeleteDocuments(t);

                iw.Optimize();
                iw.Commit();
                iw.Dispose();

                return true;
            }
            catch (Exception)
            {

                return false;
            }
        }
        public bool UpdateWiki(Article wiki)
        {
            try
            {
                if (DeleteWiki(wiki))
                    if (InsertWiki(wiki))
                        return true;
                return false;
            }
            catch (Exception)
            {

                return false;
            }
        }
        public List<Rezultat> GetArticleIDByArg(string args, bool full)
        {
            List<Rezultat> list = new List<Rezultat>();

            try
            {
                IndexReader citac = IndexReader.Open(this.folder, true);

                var seracher = new IndexSearcher(citac);

                var queryParser = new QueryParser(Lucene.Net.Util.Version.LUCENE_30, "Content", this.anliza);

                queryParser.AllowLeadingWildcard = true;

                var query = queryParser.Parse(args);
                TopDocs result = seracher.Search(query, 10000);
                var lista = result.ScoreDocs.OrderByDescending(x => x.Score) ;

                
                foreach (var hint in lista)
                {

                    var h = seracher.Doc(hint.Doc);

                    list.Add(new Rezultat ()
                    {
                        Id = h.Get("ArticlesID").ToInt(),
                        Score = hint.Score
                    });
                }

            }
            catch (Exception)
            {


            }
            return list;
        }
        public List<int> AiComplete(string args)
        {
            List<int> list = new List<int>();

            try
            {
                IndexReader citac = IndexReader.Open(this.folder, true);

                var seracher = new IndexSearcher(citac);

                var queryParser = new QueryParser(Lucene.Net.Util.Version.LUCENE_30, "Content", new KeywordAnalyzer());

                queryParser.AllowLeadingWildcard = true;

                var query = queryParser.Parse(args+"*");
                TopDocs result = seracher.Search(query, 5);
                var lista = result.ScoreDocs;


                foreach (var hint in lista)
                {

                    var h = seracher.Doc(hint.Doc);

                    list.Add(h.Get("ArticlesID").ToInt());
                }

            }
            catch (Exception)
            {


            }
            return list;
        }
    }
}
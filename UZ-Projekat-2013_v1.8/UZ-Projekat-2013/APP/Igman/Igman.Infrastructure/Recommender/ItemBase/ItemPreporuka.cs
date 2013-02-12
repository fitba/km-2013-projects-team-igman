using Igman.DB.BLL;
using Igman.DB.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Igman.Infrastructure.Recommender.ItemBase
{
    public class ItemPreporuka
    {
        public Article wiki { get; set; }
        public ItemPreporuka(Article a)
        {
            wiki = a;
        }
        public List<ArticleRecommender> GetArtikliPreporucine(double ElasticnostFinal = 0.65, double ElasticnostTag = 0.65, double ElasticnostKategorije = 0.65, double ElasticnostOcjene = 0.35)
        {
            List<Article> la = new List<Article>();
            List<ArticleRecommender> listaPreporuka = new List<ArticleRecommender>();

            using (DBBL Baza = new DBBL())
            {
                la = Baza.GetAllWikis();
                wiki = Baza.GetWikiByID(wiki.ArticlesID);

                VektorskaDuzina<Tag> vektorTagDomaci = new VektorskaDuzina<Tag>(wiki.Tags.ToArray());
                VektorskaDuzina<Category> vektorKategorijeDomaci = new VektorskaDuzina<Category>(wiki.Categories.ToArray());
                VektorskaDuzina<ArticlesRating> vektorRatingDomaci = new VektorskaDuzina<ArticlesRating>(wiki.ArticlesRatings.ToArray());


                foreach (var w in la)
                {
                    VektorskaDuzina<Tag> vektorTagExterni = new VektorskaDuzina<Tag>(w.Tags.ToArray());
                    ItemBase<Tag> ibTag = new ItemBase<Tag>(vektorTagDomaci, vektorTagExterni);

                    VektorskaDuzina<Category> vektorKategorijeExterni = new VektorskaDuzina<Category>(w.Categories.ToArray());
                    ItemBase<Category> ibKategorije = new ItemBase<Category>(vektorKategorijeDomaci, vektorKategorijeExterni);

                    VektorskaDuzina<ArticlesRating> vektorRatingExterni = new VektorskaDuzina<ArticlesRating>(w.ArticlesRatings.ToArray());
                    ItemBase<ArticlesRating> ibRating = new ItemBase<ArticlesRating>(vektorRatingDomaci, vektorRatingExterni);

                    double tpr = ibTag.GetSlicnost(false);
                    double kpr = ibKategorije.GetSlicnost(false);
                    double rpr = ibRating.GetSlicnost(false);
                    double pr = (tpr + kpr ) * 1/(double)2;
                    if (pr >= ElasticnostFinal && w != wiki)
                    {
                        listaPreporuka.Add(new ArticleRecommender()
                        {
                            Name = w.Name,
                            Score = pr,
                            WikiID = w.ArticlesID
                        });
                    }
                        

                }
                return listaPreporuka.OrderByDescending(x=>x.Score).Take(10).ToList();

            }
        }
    }
}

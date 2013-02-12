using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Igman.Infrastructure.Recommender.ItemBase
{
    public class ArticleRecommender
    {
        public int WikiID { get; set; }
        public string  Name { get; set; }
        public double Score { get; set; }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Igman.Infrastructure.Recommender.ItemBase
{
   public class QuestionRecommender
    {
        public int QuestionID { get; set; }
        public int CreatorID { get; set; }
        public string Name { get; set; }
        public double Score { get; set; }
    }
}

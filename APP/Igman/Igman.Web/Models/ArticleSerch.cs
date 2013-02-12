using Igman.DB.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Igman.DB
{
    public class ArticleSerch
    {
        public partial class Article
        {
            public Article()
            {
                this.Comments = new HashSet<Comment>();
                this.Categories = new HashSet<Category>();
                this.Tags = new HashSet<Tag>();
            }

            public int ArticlesID { get; set; }
            public string Name { get; set; }
            public string Summary { get; set; }
            public string Content { get; set; }
            public Nullable<System.DateTime> DatePublish { get; set; }
            public Nullable<bool> IsPublish { get; set; }
            public Nullable<bool> IsActive { get; set; }
            public Nullable<int> Views { get; set; }
            public Nullable<int> Likes { get; set; }
            public Nullable<System.Guid> GUID { get; set; }
            public string CreatorIP { get; set; }
            public string ModiferIP { get; set; }
            public string CreatorUserAgent { get; set; }
            public Nullable<int> CategoryID { get; set; }
            public Nullable<long> RedID { get; set; }
            public Nullable<int> BrojRedova { get; set; }
            public virtual ICollection<Comment> Comments { get; set; }
            public virtual ICollection<Category> Categories { get; set; }
            public virtual ICollection<Tag> Tags { get; set; }
        }
    }
}
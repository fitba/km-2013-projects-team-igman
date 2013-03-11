//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Igman.DB.DAL
{
    using System;
    using System.Collections.Generic;
    
    public partial class Category
    {
        public Category()
        {
            this.Articles = new HashSet<Article>();
            this.Questions = new HashSet<Question>();
        }
    
        public int CategoryID { get; set; }
        public Nullable<System.Guid> GUID { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
    
        public virtual ICollection<Article> Articles { get; set; }
        public virtual ICollection<Question> Questions { get; set; }

        public override bool Equals(object obj)
        {
            var ex = obj as Category;
            if (ex.Name == this.Name && this.CategoryID == ex.CategoryID)
                return true;
            else
                return false;
        }
    }
}

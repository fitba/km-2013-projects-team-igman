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
    
    public partial class ArticlesRating
    {
        public int ArticlesID { get; set; }
        public int UserID { get; set; }
        public Nullable<System.DateTime> DateRating { get; set; }
        public Nullable<System.DateTime> CreatorIP { get; set; }
        public Nullable<System.Guid> GUID { get; set; }
        public Nullable<int> Score { get; set; }
    
        public virtual Article Article { get; set; }
        public virtual User User { get; set; }

        public override bool Equals(object obj)
        {
            var ex = obj as ArticlesRating;
            if (ex.Score == this.Score)
                return true;
            return false;
        }
    }
}

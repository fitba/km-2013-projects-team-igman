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
    
    public partial class Answer
    {
        public Answer()
        {
            this.Comments = new HashSet<Comment>();
        }
    
        public int AnswerID { get; set; }
        public string AnswerBody { get; set; }
        public Nullable<bool> IsSpam { get; set; }
        public Nullable<int> CreatorID { get; set; }
        public Nullable<System.DateTime> CreatedID { get; set; }
        public Nullable<int> QuestionID { get; set; }
        public Nullable<System.Guid> GUID { get; set; }
        public Nullable<int> Likes { get; set; }
    
        public virtual Question Question { get; set; }
        public virtual User User { get; set; }
        public virtual ICollection<Comment> Comments { get; set; }
    }
}
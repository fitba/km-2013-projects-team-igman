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
    
    public partial class Question
    {
        public Question()
        {
            this.Answers = new HashSet<Answer>();
            this.QuestionLikes = new HashSet<QuestionLike>();
            this.QuestionsRatings = new HashSet<QuestionsRating>();
            this.Categories = new HashSet<Category>();
            this.Tags = new HashSet<Tag>();
        }
    
        public int QuestionID { get; set; }
        public string QuestionTitle { get; set; }
        public string QuestionBody { get; set; }
        public Nullable<int> CreatorID { get; set; }
        public Nullable<System.DateTime> CreatedDate { get; set; }
        public Nullable<System.Guid> GUID { get; set; }
        public Nullable<int> Likes { get; set; }
        public Nullable<int> NumOfViews { get; set; }
    
        public virtual ICollection<Answer> Answers { get; set; }
        public virtual ICollection<QuestionLike> QuestionLikes { get; set; }
        public virtual User User { get; set; }
        public virtual ICollection<QuestionsRating> QuestionsRatings { get; set; }
        public virtual ICollection<Category> Categories { get; set; }
        public virtual ICollection<Tag> Tags { get; set; }
        public override bool Equals(object obj)
        {
            var ex = obj as Question;
            if (ex.QuestionTitle == this.QuestionTitle && this.QuestionID == ex.QuestionID)
                return true;
            else
                return false;
        }
    }
}

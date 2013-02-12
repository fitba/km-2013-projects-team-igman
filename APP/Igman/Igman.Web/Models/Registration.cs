using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Igman.Web.Models
{
    public class Registartion
    {
        [Required]
        public string Email { get; set; }
        [Required]
        [Compare("Email")]
        public string EmailAgain { get; set; }
        [Required]
        public string FirstName { get; set; }
        [Required]
        public string LastName { get; set; }
        [Required]
        public string Password { get; set; }
        public string Gander { get; set; }
    }
}
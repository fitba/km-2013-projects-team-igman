using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Igman.Web.Models.Json
{
    public class Kategorija
    {
        public string KategorijaID { get; set; }
        public string Naziv { get; set; }
    }
    public class Tag
    {
        public string TagID { get; set; }
        public string Naziv { get; set; }
    }
}
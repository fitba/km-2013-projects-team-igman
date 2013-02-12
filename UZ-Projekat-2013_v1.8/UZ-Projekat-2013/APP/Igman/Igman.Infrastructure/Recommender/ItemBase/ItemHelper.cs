using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Igman.Infrastructure.Recommender.ItemBase
{
    public class ItemBase<T> where T : class
    {
       
        private VektorskaDuzina<T> _vektorA { get; set; }
        private VektorskaDuzina<T> _vektorB { get; set; }

        public ItemBase(VektorskaDuzina<T> _v1, VektorskaDuzina<T> _v2)
        {
            this._vektorA = _v1;
            this._vektorB = _v2;
        }
        public double GetSlicnost(bool Procenat = true)
        {
            int m = 0;
            foreach (var v1 in this._vektorA.duzina)
            {
                foreach (var v2 in this._vektorB.duzina)
                {
                    if (v1.Equals(v2))
                    {
                        m++;
                    }
                }
            }
            if (m == 0)
                return 0;
            else
            {
                double rez = (1 / (double)3) * ((m / (double)this._vektorA.duzina.Length) + (m / (double)this._vektorB.duzina.Length) + 1);
                if (Procenat)
                    return Math.Round((rez * 100), 2);
                return rez;
            }
        }
    }


}

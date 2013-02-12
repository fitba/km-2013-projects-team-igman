using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Igman.Infrastructure.Recommender.ItemBase
{
    
    public class VektorskaDuzina<T>
    {
        public T[] duzina { get; set; }
        public VektorskaDuzina(T[] tip)
        {
            duzina = tip;
        }
        public T GetLement(int index)
        {
            return this.duzina[index];
        }
        public T Ubaci(T el)
        {
            T[] temp = new T[this.duzina.Length + 1];
            temp[this.duzina.Length] = el;
            this.duzina = temp;
            return el;
        }
    }
}

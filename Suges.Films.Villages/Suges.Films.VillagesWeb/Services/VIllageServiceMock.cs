using Suges.Films.VillagesWeb.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Suges.Films.VillagesWeb.Models;
using FizzWare.NBuilder;

namespace Suges.Films.VillagesWeb.Services
{
    public class VillageServiceMock : IVillageService
    {
        IList<Village> villageCollection;
        public VillageServiceMock()
        {
            villageCollection = Builder<Village>.CreateListOfSize(200).All().Build();
        }
        public bool Delete(int id)
        {
            return (villageCollection.Where(x=>x.Id==id).Any());
        }

        public IList<Village> GetAllVillage()
        {
            return villageCollection;        }

        public Village GetVillageById(int id)
        {
            return villageCollection.Where(x => x.Id == id).FirstOrDefault();
          
        }

        public bool Insert(Village village)
        {
            villageCollection.Add(village);
            return true;
        }

        public bool Update(Village village,int id)
        {
            var element= villageCollection.Where(x => x.Id == village.Id).FirstOrDefault();

            return true;
            
        }
    }
}
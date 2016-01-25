using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Suges.Films.VillagesWeb.Services.Interfaces;
using Suges.Films.VillagesWeb.Services;
using System.Linq;
using Suges.Films.VillagesWeb.Models;

namespace Suges.Films.Villages.Test
{
    [TestClass]
    public class UTVillageService
    {
        IVillageService service;
        public UTVillageService()
        {
            service = new VillageServiceMock();
        }
        [TestMethod]
        public void GetAll()
        {
            Assert.IsTrue(service.GetAllVillage().Any());
;        }

        [TestMethod]
        public void Insert()
        {
            var village = new Village
            {
                Id = 200,
                Name = "Octupus",
                Film = "Spiderman 2"
            };
            Assert.IsTrue(service.Insert(village));
        }
        [TestMethod]
        public void Update()
        {
            var village = new Village
            {
                Id = 200,
                Name = "Octupus",
                Film = "Spiderman 2"
            };
            Assert.IsTrue(service.Update(village,200));
        }
        [TestMethod]
        public void Delte()
        {
            
            Assert.IsTrue(service.Delete(1));
        }


    }
}

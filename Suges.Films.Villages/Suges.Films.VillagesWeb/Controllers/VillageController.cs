using Suges.Films.VillagesWeb.Models;
using Suges.Films.VillagesWeb.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Suges.Films.VillagesWeb.Controllers
{
    public class VillageController : Controller
    {
        IVillageService service;

        public VillageController(IVillageService service)
        {
            this.service = service;
        }
        // GET: Village
        public ActionResult Index()
        {
            var villageCOllection = this.service.GetAllVillage();
            return View(villageCOllection);
        }

        // GET: Village/Details/5
        public ActionResult Details(int id)
        {
            var village = this.service.GetVillageById(id); 
            return View(village);
        }

        // GET: Village/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Village/Create
        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            try
            {
                var village = new Village
                {
                    Film = collection["Film"].ToString(),
                    Name = collection["Name"].ToString(),
                    Photo = collection["Photo"].ToString()
                };

                service.Insert(village);
                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: Village/Edit/5
        public ActionResult Edit(int id)
        {
            var village = service.GetVillageById(id);
            return View(village);
        }

        // POST: Village/Edit/5
        [HttpPost]
        public ActionResult Edit(int id, FormCollection collection)
        {
            try
            {
                var village = new Village
                {
                    Film = collection["Film"].ToString(),
                    Name = collection["Name"].ToString(),
                    Photo = collection["Photo"].ToString()
                };

                service.Update(village,id);

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: Village/Delete/5
        public ActionResult Delete(int id)
        {
            var village = service.GetVillageById(id);
            return View(village);
        }

        // POST: Village/Delete/5
        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                service.Delete(id);

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}

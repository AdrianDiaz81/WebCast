using Suges.Films.VillagesWeb.Models;
using System.Collections.Generic;

namespace Suges.Films.VillagesWeb.Services.Interfaces
{
    public interface IVillageService
    {
        IList<Village> GetAllVillage();
        Village GetVillageById(int id);
        bool Insert(Village village);

        bool Update(Village village, int id);
        bool Delete(int id);

    }
}

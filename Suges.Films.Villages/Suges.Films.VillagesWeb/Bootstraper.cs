using Autofac;
using Autofac.Integration.Mvc;
using Suges.Films.VillagesWeb.Services;
using Suges.Films.VillagesWeb.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Suges.Films.VillagesWeb
{
    public class Bootstraper
    {


        internal static void Init(ContainerBuilder builder) { 


            builder.RegisterType<VillageServiceMock>().As<IVillageService>().InstancePerRequest();

           
        }
    }
}
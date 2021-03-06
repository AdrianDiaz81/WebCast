// <copyright file="VillageServiceMockTest.cs">Copyright ©  2016</copyright>
using System;
using System.Collections.Generic;
using Microsoft.Pex.Framework;
using Microsoft.Pex.Framework.Validation;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Suges.Films.VillagesWeb.Models;
using Suges.Films.VillagesWeb.Services;

namespace Suges.Films.VillagesWeb.Services.Tests
{
    /// <summary>This class contains parameterized unit tests for VillageServiceMock</summary>
    [PexClass(typeof(VillageServiceMock))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(InvalidOperationException))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(ArgumentException), AcceptExceptionSubtypes = true)]
    [TestClass]
    public partial class VillageServiceMockTest
    {
        /// <summary>Test stub for .ctor()</summary>
        [PexMethod]
        public VillageServiceMock ConstructorTest()
        {
            VillageServiceMock target = new VillageServiceMock();
            return target;
            // TODO: add assertions to method VillageServiceMockTest.ConstructorTest()
        }

        /// <summary>Test stub for Delete(Int32)</summary>
        [PexMethod]
        public bool DeleteTest([PexAssumeUnderTest]VillageServiceMock target, int id)
        {
            bool result = target.Delete(id);
            return result;
            // TODO: add assertions to method VillageServiceMockTest.DeleteTest(VillageServiceMock, Int32)
        }

        /// <summary>Test stub for GetAllVillage()</summary>
        [PexMethod]
        public IList<Village> GetAllVillageTest([PexAssumeUnderTest]VillageServiceMock target)
        {
            IList<Village> result = target.GetAllVillage();
            return result;
            // TODO: add assertions to method VillageServiceMockTest.GetAllVillageTest(VillageServiceMock)
        }

        /// <summary>Test stub for GetVillageById(Int32)</summary>
        [PexMethod]
        public Village GetVillageByIdTest([PexAssumeUnderTest]VillageServiceMock target, int id)
        {
            Village result = target.GetVillageById(id);
            return result;
            // TODO: add assertions to method VillageServiceMockTest.GetVillageByIdTest(VillageServiceMock, Int32)
        }

        /// <summary>Test stub for Insert(Village)</summary>
        [PexMethod]
        public bool InsertTest([PexAssumeUnderTest]VillageServiceMock target, Village village)
        {
            bool result = target.Insert(village);
            return result;
            // TODO: add assertions to method VillageServiceMockTest.InsertTest(VillageServiceMock, Village)
        }

        /// <summary>Test stub for Update(Village, Int32)</summary>
        [PexMethod]
        public bool UpdateTest(
            [PexAssumeUnderTest]VillageServiceMock target,
            Village village,
            int id
        )
        {
            bool result = target.Update(village, id);
            return result;
            // TODO: add assertions to method VillageServiceMockTest.UpdateTest(VillageServiceMock, Village, Int32)
        }
    }
}

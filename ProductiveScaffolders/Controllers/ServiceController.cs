using System;
using System.Collections.Generic;
using System.Net;
using System.Web;
using System.Web.Mvc;

namespace ProductiveScaffolders.Controllers
{
    public class ServiceController : Controller
    {
        private readonly IService _service;

        public ServiceController(IService service)
        {
            _service = service;
        }


    }
}
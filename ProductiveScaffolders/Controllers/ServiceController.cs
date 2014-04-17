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

        public ActionResult ProcessSalary(Employee model) 
        {
        	if (ModelState.IsValid)
            {
        		try 
        		{
        			_service.ProcessSalary(model.Map<T1, T2>());
        		}
        		catch (Exception ex)
        		{
        			ModelState.AddModelError("", ex);
        		}
            }
        	
        	return View(model);
        }

    }
}
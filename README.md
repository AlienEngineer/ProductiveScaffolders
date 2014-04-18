ProductiveScaffolders (Under development)
=====================

Scaffolders to automate boring tasks


To create a view model based on a POCO:  
```
    Scaffold ViewModel <Type> [Name]
```

To create a Controller based on a Service:  
```
    Scaffold ServiceController <ServiceType> [Name] [-HandleExceptions]
    Scaffold ServiceApiController <ServiceType> [Name] [-HandleExceptions]
```

Small example:

this:
```C#
    public interface IService
    {
        void ProcessSalary(Employee employee);
    }
```

After this:
```
    Scaffold ServiceControler IService -HandleExceptions
```

Creates this:
```C#
    public class ServiceController : Controller
    {
        private readonly IService _service;

        public ServiceController(IService service)
        {
            _service = service;
        }

        public ActionResult ProcessSalary(EmployeeModel model) 
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
```

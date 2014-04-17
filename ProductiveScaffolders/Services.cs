using System;

namespace ProductiveScaffolders
{

    public interface IService
    {
        void ProcessSalary(Employee employee);
    }

    public class Employee
    {
        public int EmployeeId { get; set; }
        public String Name { get; set; }
    }

}
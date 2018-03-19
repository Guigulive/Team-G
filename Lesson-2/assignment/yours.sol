/*Ziqi Li A#2 Mar-16-2018*/
pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    uint totalSalary = 0;
    
    address boss;
    Employee[] employees;

    function Payroll() {
        boss = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * ((now - employee.lastPayday) / payDuration);
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i=0;i<employees.length;i++)
            if (employees[i].id == employeeId)
                return (employees[i] ,i);
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == boss);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        
        employees.push(Employee(employeeId,salary*1 ether,now));
        totalSalary+= salary*1 ether;
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == boss);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        delete employees[index];
        employees[index] = employees[employees.length-1];
        employees.length -=1;
        totalSalary -= employee.salary*1 ether;
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == boss);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        totalSalary += (salary - employee.salary) *1 ether;
        employee.salary = salary *1 ether;
        employee.lastPayday = now;
        
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0 ;
    }
    
    function getPaid() {
        var (employee,index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPayDay = employee.lastPayday + payDuration;
        assert(nextPayDay < now);
        
        employee.id.transfer(employee.salary);
    }
}

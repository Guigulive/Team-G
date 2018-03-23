/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;
contract Payroll{
    struct Employee {
        address id;
        uint salary;
        uint lastPayDay;
    }
    uint  payDuration = 10 seconds;
    address owner;
    Employee[] employees;
    uint salarySum;
    
    function Payroll(){
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private{
        uint payAmount = employee.salary * (now - employee.lastPayDay) / payDuration;
        employee.id.transfer(payAmount);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for(uint i = 0; i < employees.length; i++){
            if(employees[i].id == employeeId){
                return (employees[i], i);
            }
        }
    }
    
    function addEmployee(address employeeId, uint salary){
        require(msg.sender == owner);
        var(employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeId, salary * 1 ether,now));
        salarySum += salary * 1 ether;
    }
    
    function removeEmployee(address employeeId){
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        delete employees[index];
        employees[index] = employees[employees.length -1];
        employees.length -= 1;
        salarySum -= employees.salary;
    }
    
    function updateEmployee(address employeeId, uint salary){
        require(msg.sender == owner);
        var(employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        employees[index].id = employeeId;
        salarySum -= employees[index].salary
        employees[index].salary = salary * 1 ether;
        salarySum += employees[index].salary
        employees[index].lastPayDay = now;
    }
    
      function caclulateRunway()  returns (uint){
      return this.balance / salarySum;
  }
   
   function addFund() public payable returns (uint){
       return this.balance;
   }

  
  function hasEnoughFund() private returns (bool) {
      return caclulateRunway() > 0;
  }
  
  function getPaid() public {
     var (employee, index) = _findEmployee(msg.sender);
     assert(employee.id != 0x0);
     
     uint nextPayday = employee.lastPayDay + payDuration;
     assert(nextPayday < now);
     employee.lastPayDay = nextPayday;
     employee.id.transfer(employee.salary);
  }
}
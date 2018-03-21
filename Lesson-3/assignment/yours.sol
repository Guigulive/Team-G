pragma solidity ^0.4.14;
contract Payroll{
    struct Employee {
        address id;
        uint salary;
        uint lastPayDay;
    }
    uint  payDuration = 10 seconds;
    address owner;
    mapping(address => Employee) public employees ;
    uint totalSalary;
    
    function Payroll(){
        owner = msg.sender;
    }
    
    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }
    
    modifier employeeExist(address employeeId){
        var employee =employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    modifier removeByAddress(address employeeId){
        _;
        delete employees[employeeId];
    }
    
    function _partialPaid(Employee employee) private{
        uint payAmount = employee.salary * (now - employee.lastPayDay) / payDuration;
        employee.id.transfer(payAmount);
    }
    
    function addEmployee(address employeeId, uint salary) onlyOwner{
      
        totalSalary += salary * 1 ether;
        employees[employeeId] = Employee(employeeId, salary * 1 ether,now);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) removeByAddress(employeeId){
        var  employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary -= employees[employeeId].salary;

    }

    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId){
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary -= employees[employeeId].salary;
        employees[employeeId].salary = salary * 1 ether;
        totalSalary += employees[employeeId].salary;
        employees[employeeId].lastPayDay = now;
    }
    
     function caclulateRunway()  returns (uint){
      return this.balance / totalSalary;
  }
   
   function addFund() public payable returns (uint){
       return this.balance;
   }

  function hasEnoughFund() private returns (bool) {
      return caclulateRunway() > 0;
  }
  
  function checkEmployee(address employeeId) returns(uint salary, uint lastPayDay){
      salary = employees[employeeId].salary;
      lastPayDay = employees[employeeId].lastPayDay;
  }
  
  function getPaid() public {
     var employee = employees[msg.sender];
     assert(employee.id != 0x0);
     
     uint nextPayday = employee.lastPayDay + payDuration;
     assert(nextPayday < now);
     employees[msg.sender].lastPayDay = nextPayday;
     employee.id.transfer(employee.salary);
  }
  
  function changePaymenyAddress(address oldAddress,address newAddress) onlyOwner removeByAddress(oldAddress){
      employees[newAddress] = Employee(newAddress, employees[oldAddress].salary, employees[oldAddress].lastPayDay);

  }
}
/*Ziqi Li A3*/
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
    mapping (address=>Employee) public employees;
    
    modifier onlyOwner(){
        require(msg.sender == boss);
        _;
    }
    
    modifier onlyEmployee(address employeeId){
        require(msg.sender == employeeId);
        _;
    }
    
    modifier checkExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    modifier checkNotExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }

    function Payroll() {
        boss = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * ((now - employee.lastPayday) / payDuration);
        employee.id.transfer(payment);
    }
    
    
    function addEmployee(address employeeId, uint salary) onlyOwner checkNotExist(employeeId){
        employees[employeeId] = Employee(employeeId,salary*1 ether,now);
        totalSalary+= salary*1 ether;
    }
    
    function removeEmployee(address employeeId) onlyOwner checkExist(employeeId){
        var employee = employees[employeeId];
        _partialPaid(employee);
        delete employees[employeeId];
        totalSalary -= employee.salary;
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner checkExist(employeeId){
        var employee = employees[employeeId];
        _partialPaid(employee);
        employees[employeeId].salary = salary *1 ether;
        employees[employeeId].lastPayday = now;
        totalSalary += (salary *1 ether - employees[employeeId].salary) ;
    }
    
    function checkEmployee(address employeeId) returns (uint salary,uint lastPayday){
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
        
    }
    
    function changePaymentAddress(address newId) onlyEmployee(msg.sender) {
        var employee = employees[msg.sender];
        _partialPaid(employee);
        employees[msg.sender].id = newId;
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
    
    function getPaid() onlyEmployee(msg.sender) {
        var employee = employees[msg.sender];
        
        uint nextPayDay = employee.lastPayday + payDuration;
        assert(nextPayDay < now);
        
        employees[msg.sender].lastPayday = nextPayDay;
        employee.id.transfer(employee.salary);
    }
}

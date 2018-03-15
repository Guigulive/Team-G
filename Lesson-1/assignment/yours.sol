pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary;
    address employee = 0x0;
    uint lastPayday = now;

    function Payroll() {
        owner = msg.sender;
    }
    
    function updateEmployee(address e) {
        require(msg.sender == owner);
        
        if (e != 0x0 && employee != e) {
            payPreviousBalance();
        }else{
            revert();
        }
        employee = e;
    }
    
    function updateSalary(uint s) {
        require(msg.sender == owner);
        uint nextsalary = s * 1 ether;
        
        if (nextsalary == salary){
            revert();
        }
        payPreviousBalance();
        salary = s * 1 ether;
    }
    
    function payPreviousBalance() {
        if (salary > 0 && employee != 0x0){
            uint payment = salary * (now - lastPayday) / payDuration;
            lastPayday = now;            
            employee.transfer(payment);
        }
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        require(msg.sender == employee);
        
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}

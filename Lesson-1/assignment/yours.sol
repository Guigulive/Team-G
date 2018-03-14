/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    struct EmployeeInfo {
        uint salary;
        uint employeePoolIndex;
    }
    uint constant payDuration = 10 seconds;
    uint lastPayday;
    address private owner;
    address[] private employeePool;
    mapping (address => EmployeeInfo) private employee;

    function Payroll() {
        owner = msg.sender;
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() view returns (uint) {
        uint employeePoolLength = employeePool.length;
        require (employeePoolLength > 0);

        uint salarySum = 0;
        for (uint i = 0; i < employeePoolLength; i++) {
            salarySum += employee[employeePool[i]].salary;
        }

        return this.balance / salarySum;
    }

    function hasEnoughFund() view returns (bool) {
        return calculateRunway() >= 1;
    }

    function isEmployee(address e) public view returns (bool success) {
        return employeePool.length == 0 ? false : employeePool[employee[e].employeePoolIndex] == e;
    }

    function createEmployee(address e, uint s) returns (uint count) {
        require(msg.sender == owner && !isEmployee(e) && e != 0x0);

        employee[e].salary = s * 1 ether;
        employee[e].employeePoolIndex = employeePool.push(e) - 1;
        lastPayday = now;

        return employeePool.length - 1;
    }

    function getEmployee(address e) returns (uint salary) {
        require(msg.sender == owner && isEmployee(e));

        return employee[e].salary;
    }

    function updateEmployeeSalary(address e, uint s) returns (bool success) {
        require(msg.sender == owner && isEmployee(e));

        employee[e].salary = s * 1 ether;

        return true;
    }

    function updateEmployeeAddress(address oldAddress, address newAddress) returns (bool success) {
        require(msg.sender == owner && isEmployee(oldAddress));

        uint salary = employee[oldAddress].salary;
        uint positionToReplace = employee[oldAddress].employeePoolIndex;

        employee[newAddress].salary = salary;
        employee[newAddress].employeePoolIndex = positionToReplace;
        employeePool[positionToReplace] = newAddress;

        uint payment = salary * (now - lastPayday) / payDuration;
        newAddress.transfer(payment);
        lastPayday = now;

        return true;
    }

    function deleteEmployee(address e) returns (bool success) {
        require(msg.sender == owner && isEmployee(e));

        uint positoinToDelete = employee[e].employeePoolIndex;
        address addressToMove = employeePool[employeePool.length - 1];

        uint payment = salary * (now - lastPayday) / payDuration;
        e.transfer(payment);
        lastPayday = now;

        employeePool[positoinToDelete] = addressToMove;
        employee[addressToMove].employeePoolIndex = positoinToDelete;
        employeePool.length --;

        return true;
    }

    function getPaid() returns (bool success) {
        address sender = msg.sender;
        require(isEmployee(sender));

        uint nextPayday = lastPayday + payDuration;
        require(nextPayday < now);

        lastPayday = nextPayday;
        sender.transfer(employee[sender].salary);

        return true;
    }
}
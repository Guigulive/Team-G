pragma solidity ^0.4.14;

import './SafeMath.sol';

contract Payroll {
    using SafeMath for uint;

    struct EmployeeInfo {
        uint salary;
        uint lastPayday;
        uint employeePoolIndex;
    }
    uint constant payDuration = 10 seconds;
    uint totalSalary;
    address private owner;
    address[] private employeePool;
    mapping (address => EmployeeInfo) private employee;

    modifier isOwnerAndEmployee(address person) {
        require(msg.sender == owner && isEmployee(person));
        _;
    }

    function Payroll() {
        owner = msg.sender;
    }

    function _calculatePayment(EmployeeInfo e) private view returns (uint payment) {
        payment = (e.salary.mul(now.sub(e.lastPayday))).div(payDuration);
    }

    function addFund() payable returns (uint balance) {
        balance =  this.balance;
    }

    function calculateRunway() public view returns (uint runway) {
        uint employeePoolLength = employeePool.length;
        require (employeePoolLength > 0);

        runway = this.balance.div(totalSalary);
    }

    function hasEnoughFund() public view returns (bool success) {
        success = calculateRunway() >= 1;
    }

    function isEmployee(address e) public view returns (bool success) {
        success = employeePool.length == 0 ? false : employeePool[employee[e].employeePoolIndex] == e;
    }

    function createEmployee(address e, uint s) external returns (uint count) {
        require(msg.sender == owner && !isEmployee(e) && e != 0x0);

        employee[e].salary = s * 1 ether;
        employee[e].lastPayday = now;
        employee[e].employeePoolIndex = employeePool.push(e) - 1;
        totalSalary += s * 1 ether;

        count = employeePool.length - 1;
    }

    function getEmployee(address e) external view isOwnerAndEmployee(e) returns (uint salary, uint lastPayday, uint employeePoolIndex) {
        salary = employee[e].salary;
        lastPayday = employee[e].lastPayday;
        employeePoolIndex = employee[e].employeePoolIndex;
    }

    function updateEmployeeSalary(address e, uint s) external isOwnerAndEmployee(e) returns (bool success) {
        uint payment = _calculatePayment(employee[e]);

        employee[e].lastPayday = now;
        totalSalary = totalSalary - employee[e].salary + s * 1 ether;
        employee[e].salary = s * 1 ether;

        e.transfer(payment);

        success = true;
    }

    function updateEmployeeAddress(address oldAddress, address newAddress) external isOwnerAndEmployee(oldAddress) returns (bool success) {
        uint positionToReplace = employee[oldAddress].employeePoolIndex;
        uint payment = _calculatePayment(employee[oldAddress]);

        employee[newAddress].salary = employee[oldAddress].salary;
        employee[newAddress].lastPayday = now;
        employee[newAddress].employeePoolIndex = positionToReplace;
        employeePool[positionToReplace] = newAddress;
        delete employee[oldAddress];

        newAddress.transfer(payment);

        success = true;
    }

    function deleteEmployee(address e) external isOwnerAndEmployee(e) returns (bool success) {
        uint positoinToDelete = employee[e].employeePoolIndex;
        address addressToMove = employeePool[employeePool.length - 1];

        uint payment = _calculatePayment(employee[e]);
        employee[e].lastPayday = now;
        totalSalary -= employee[e].salary;
        e.transfer(payment);

        employeePool[positoinToDelete] = addressToMove;
        employee[addressToMove].employeePoolIndex = positoinToDelete;
        employeePool.length --;

        success = true;
    }

    function getPaid() external returns (bool success) {
        address sender = msg.sender;
        require(isEmployee(sender));

        uint nextPayday = employee[sender].lastPayday + payDuration;
        assert(nextPayday < now);

        employee[sender].lastPayday = nextPayday;
        sender.transfer(employee[sender].salary);

        success = true;
    }
}
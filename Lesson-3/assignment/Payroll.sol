/**
 * Author: JustinLee
 * Date: 2018.03.20
 * Content: 多员工薪酬系统
 */
pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable{

    //雇员信息
    struct Employee{
        address id; //雇员地质
        uint salary; //雇员薪资
        uint lastPayday; //上次发工资的时间
    }
    //发工资的周期
    uint constant payDuration = 10 seconds;
    mapping(address => Employee) employees;
    //所有雇员薪资之和
    uint totalSalary;

    /**
     * 雇员地址不为空
     * param address employeeId 雇员地址
     */
    modifier employeeExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    /**
     * 雇员地址为空
     * param address employeeId 雇员地址
     */
    modifier employeeNotExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }

    /**
     * 当前调用者只能查询自己的信息，雇主除外
     * param address employeeId 查询的地址
     * param address sendId 当前调用者地址
     */
    modifier onlyOwnerAndEmployee(address employeeId, address sendId){
        var employee = employees[employeeId];
        assert(employee.id == sendId || sendId == owner);
        _;
    }

    /**
     * 支付雇员剩余工资
     * param Employee employee 雇员地址
     */
    function _partialPaid(Employee employee) private {
        //需要发的工资 = 工资基数 * (当前时间 - 上次发工资的时间) / 发工资的周期
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        //更新地址和工资基数之前，给上一个员工发放应得的工资
        employee.id.transfer(payment);
    }

    /**
     * 新增雇员
     * param address employeeId 雇员地址
     * param uint salary 雇员薪资
     */
    function addEmployee(address employeeId, uint salary) onlyOwner employeeNotExist(employeeId) {
        var employee = employees[employeeId];
        //传入的是 wei,转换成 ether
        uint s = salary * 1 ether;
        //新增雇员到雇员信息数组中
        employees[employeeId] = Employee(employeeId, s, now);
        //累加到所有雇员薪资之和中
        totalSalary += s;
    }

    /**
     * 删除雇员
     * param address employeeId 雇员地址
     */
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        //发放该雇员剩余薪资
        _partialPaid(employee);
        //从所有雇员薪资之和中减去该雇员薪资
        totalSalary -= employees[employeeId].salary;
        //将该雇员信息去掉
        delete employees[employeeId];
    }

    /**
     * 更新雇员地址及工资基数
     * param address e 员工地址
     * param uint s 工资基数
     */
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        //发放该雇员剩余薪资
        _partialPaid(employee);
        //先从雇员薪资之和中减去原来的薪资
        totalSalary -= employees[employeeId].salary;
        //更改薪资
        employees[employeeId].salary = salary * 1 ether;
        //更改上次发放薪资的时间为现在
        employees[employeeId].lastPayday = now;
        //再从雇员薪资之和中加上现在的薪资
        totalSalary += employees[employeeId].salary;
    }

    /**
     * 更换雇员地址 - 只有雇员才能更换
     * param address newEmployeeId 新的地址
     */
    function changePaymentAddress(address newEmployeeId) employeeExist(msg.sender) {
        employees[msg.sender].id = newEmployeeId;
    }


    /**
     * 往合约里增加资金
     * return uint
     */
    function addFund() payable returns (uint) {
        //返回合约账户内的剩余资金
        return this.balance;
    }

    /**
     * 还可以发几次工资
     * return uint
     */
    function calculateRunway() returns (uint) {
        //合约账户内剩余资金 除以 所有雇员薪资之和
        return this.balance / totalSalary;
    }


    /**
     * 合约内剩余资金是否可以发一次工资
     * return bool
     */
    function hasEnoughFund() returns (bool) {
        //还可以发工资的次数大于0
        return calculateRunway() > 0;
    }

    /**
     * 领取工资
     */
    function getPaid() employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        //当前工资支付时间 = 上次发工资的时间 + 发工资的周期
        uint curPayday = employee.lastPayday + payDuration;
        //如果当前工资支付时间大于当前时间，则抛出异常
        require(curPayday < now);
        //将当前工资支付时间赋值给上次发工资的时间
        employees[msg.sender].lastPayday = curPayday;
        //给雇员发放工资
        employee.id.transfer(employee.salary);
    }

    /**
     * 查询雇员信息（当前调用者只能查询自己的信息，雇主除外）
     * return uint salary
     * return uint lastPayday
     */
    function checkEmployee(address employeeId) onlyOwnerAndEmployee(employeeId, msg.sender) returns (uint salary, uint lastPayday) {
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
}

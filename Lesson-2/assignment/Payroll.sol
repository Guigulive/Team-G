/**
 * Author: JustinLee
 * Date: 2018.03.17
 * Content: 多员工薪酬系统
 */
pragma solidity ^0.4.14;

contract Payroll {

    //雇员信息
    struct Employee{
        address id; //雇员地质
        uint salary; //雇员薪资
        uint lastPayday; //上次发工资的时间
    }
    //发工资的周期
    uint constant payDuration = 10 seconds;
    Employee[] employees;
    //老板BOSS地址
    address owner;
    //所有雇员薪资之和
    uint countSalary;

    /**
     * 初始化
     */
    function Payroll() {
        //设置老板的地址为合约创建者
        owner = msg.sender;
    }

    /**
     * 支付雇员剩余工资
     * param Employee employee 员工地址
     */
    function _partialPaid(Employee employee) private{
        //需要发的工资 = 工资基数 * (当前时间 - 上次发工资的时间) / 发工资的周期
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        //更新地址和工资基数之前，给上一个员工发放应得的工资
        employee.id.transfer(payment);
    }

    /**
     * 根据地址查找雇员信息
     * param address employeeId 雇员地址
     * return Employee 雇员信息, uint 数组下标
     */
    function _findEmployee(address employeeId) private returns (Employee, uint){
        for(uint i = 0; i < employees.length; i++){
            if(employees[i].id == employeeId){
                return (employees[i], i);
            }
        }
    }

    /**
     * 新增雇员
     * param address employeeId 雇员地址
     * param uint salary 雇员薪资
     */
    function addEmployee(address employeeId, uint salary){
        //检查调用者是否为老板
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        //传入的是 wei,转换成 ether
        uint s = salary * 1 ether;
        //新增雇员到雇员信息数组中
        employees.push(Employee(employeeId, s, now));
        //累加到所有雇员薪资之和中
        countSalary += s;
    }

    /**
     * 删除雇员
     * param address employeeId 雇员地址
     */
    function removeEmployee(address employeeId){
        //检查调用者是否为雇主
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        //发放该雇员剩余薪资
        _partialPaid(employee);
        //从所有雇员薪资之和中减去该雇员薪资
        countSalary -= employee.salary;
        //将该雇员信息去掉
        delete employees[index];
        //将delete遗留的空白元素处理掉
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }

    /**
     * 更新员工地址及工资基数
     * param address e 员工地址
     * param uint s 工资基数
     */
    function updateEmployee(address employeeId, uint salary) {
        //只有老板才能更新员工地址和工资基数
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        //发放该雇员剩余薪资
        _partialPaid(employee);
        //先从雇员薪资之和中减去原来的薪资
        countSalary -= employee.salary;
        //更改薪资
        employee.salary = salary * 1 ether;
        //更改上次发放薪资的时间为现在
        employee.lastPayday = now;
        //再从雇员薪资之和中加上现在的薪资
        countSalary += employee.salary;
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
     * 还可以发几次工资 -- 优化前的方法
     * return uint
     */
    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
        //循环所有雇员，累加薪资
        for(uint i = 0; i < employees.length; i++){
          totalSalary += employees[i].salary;
        }
        //合约账户内剩余资金 除以 所有雇员薪资之和
        return this.balance / totalSalary;
    }

    /**
     * 还可以发几次工资 -- 优化后的方法
     * return uint
     */
    function calculateRunwayAfter() returns (uint) {
        //合约账户内剩余资金 除以 所有雇员薪资之和
        return this.balance / countSalary;
    }

    /**
     * 合约内剩余资金是否可以发一次工资
     * return bool
     */
    function hasEnoughFund() returns (bool) {
        //还可以发工资的次数大于0
        //return calculateRunway() > 0;
        return calculateRunwayAfter() > 0;
    }

    /**
     * 领取工资
     */
    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        //当前工资支付时间 = 上次发工资的时间 + 发工资的周期
        uint curPayday = employee.lastPayday + payDuration;
        //如果当前工资支付时间大于当前时间，则抛出异常
        require(curPayday < now);
        //将当前工资支付时间赋值给上次发工资的时间
        employee.lastPayday = curPayday;
        //给雇员发放工资
        employee.id.transfer(employee.salary);
    }
}

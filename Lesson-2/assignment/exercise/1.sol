//***
// * @Author: 花夏
// * @Date:   2018-03-16
// * @Email:  liubiao@itoxs.com
// * 第二节： 编写多员工薪资系统
// * @Copyright: Copyright (c) 2018 by huarxia. All Rights Reserved.
// */

pragma solidity ^0.4.14;

// 声明合约方法
contract CompensationSys {
    // 发薪时间步长
    // uint constant payStep = 30 days;
    // 方便调试改成 10s
    uint constant payStep = 10 seconds;
    address owner;
    // 定一个strut类型的employee数组
    struct Employee {
        // 因为地址是唯一的，所以将地址设为Id
        address id;
        uint salary;
        uint lastPayDay;
    }
    Employee [] employees;
    //**
    //* [CompensationSys 这是构造函数？智能合约一部署自动执行然后将所有者赋给 owner？]
    //* @method   CompensationSys
    //* @author 花夏 liubiao@itoxs.com
    //* @datetime 2018-03-13T10:38:31+080
    //*/
    function CompensationSys() {
        owner = msg.sender;
    }

    //**
    //* [_paySurplusWages 内置支付剩余薪水函数，有木有和js类似？]
    //* @method   _paySurplusWages
    //* @author 花夏 liubiao@itoxs.com
    //* @datetime 2018-03-16T21:44:11+080
    //* @param    {Employee}                employee [需要支付的员工数据信息]
    //*/
    function _paySurplusWages(Employee employee) {
        assert(employee.id != 0x0);
        uint paySurplusWages = employee.salary * (now - employee.lastPayDay) / payStep;
        employee.id.transfer(paySurplusWages);
    }
    function _findEmployee(address employeeId) returns(Employee, uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employee) {
                // 教程讲的这样，用心良苦，为了强行讲var，我知道了~
                return (employees[i], i);
            }
        }
    }
    //**
    //* [addEmployee 添加一个新员工地址]
    //* @method   addEmployee
    //* @author 花夏 liubiao@itoxs.com
    //* @datetime 2018-03-16T21:18:34+080
    //* @param    {address}             employee [新员工地址]
    //* @param    {uint}                salary    [应付的月薪]
    //*/
    function addEmployee(address employee, uint salary) {
        require(msg.sender == owner);
        // 添加前需要判断是否已经包含该员工
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employee) {
                revert();
            }
        }
        // 添加员工
        employees.push(Employee(employee, salary, now));
    }

    //**
    //* [removerEmployee 删除一个员工并支付其剩余薪水]
    //* @method   removerEmployee
    //* @author 花夏 liubiao@itoxs.com
    //* @datetime 2018-03-16T21:24:19+080
    //* @param    {address}                employee [需要删除员工的地址]
    //*/
    function removerEmployee(address employee) {
        require(msg.sender == owner);
        // 查找存在的需要移除的员工
        var (employee, index) = _findEmployee(employee);
        // 我已经在支付函数里做了判断拉~~
        _paySurplusWages(employee.id);
        delete employee;
        employees[employees.index] = employees[employees.length - 1];
        employees.length--;
    }
    
    //**
    //* [updateEmployeeMsg 更新员工地址或者月薪基数]
    //* @method   updateEmployeeMsg
    //* @author 花夏 liubiao@itoxs.com
    //* @datetime 2018-03-13T10:21:58+080
    //* @param    {address}               ads [更新地址]
    //* @param    {uint}                  sly [更新的月薪基数]
    // *** 填写地址处一定要使用英文状态下的双引号 "" ***
    // 例如 "0xca35b7d915458ef540ade6068dfe2f44e8fa733c"
    //*/
    function updateEmployeeMsg(address ads, uint sly) {
        // 检查是否合约所有者，不是的话是不允许改变的哦，要不然嘻嘻嘻~~~
        require(msg.sender == owner);
        // 查找存在的需要移除的员工
        var (employee, index) = _findEmployee(ads);
        // 我已经在支付函数里做了判断拉~~
        _paySurplusWages(employee.id);
        paySurplusWages();
        employee.id = ads;
        employee.salary = sly * 1 ether;
        employee.lastPayDay = now;
    }
    
    //**
    //* [addFund 添加支付金到合约地址]
    //* @method   addFund
    //* @author   花夏 liubiao@itoxs.com
    //* @datetime 2018-03-13T10:20:27+080
    //* @return   返回合约的余额
    //*/
    function addFund() payable returns(uint) {
        // this 指向合约对象
        return this.balance;
    }

    //**
    //* [getPayTimes 获取合约地址还能支付薪水的次数]
    //* @method   getPayTimes
    //* @author 花夏 liubiao@itoxs.com
    //* @datetime 2018-03-13T10:24:27+080
    //* @return   {uint}                [返回合约地址还能支付薪水的次数]
    //*/
    function getPayTimes() returns(uint) {
        return this.balance / salary;
    }

    //**
    //* [hasEnoughPay 查看是否支付足够]
    //* @method   hasEnoughPay
    //* @author 花夏 liubiao@itoxs.com
    //* @datetime 2018-03-13T10:30:36+080
    //* @return   {Boolean}               [返回是否足够支付]
    //*/
    function hasEnoughPay() returns(bool) {
        // ether == 10^18 wei
        // finney == 10^15 wei
        // 然鹅~~ 难道发薪不要手续费？我再加上0.01ether的手续费吧。保证一下。
        return this.balance >= salary + 10 finney;
    }

    //**
    //* [getMyWage 员工自己领取自己的工资]
    //* @method   getMyWage
    //* @author 花夏 liubiao@itoxs.com
    //* @datetime 2018-03-13T10:32:35+080
    //*/
    function getMyWage() {
        require(msg.sender == employee);
        uint curPayDay = lastPayDay + payStep;
        assert(curPayDay <= now);
        assert(hasEnoughPay());
        // 为啥这几个if判断个分开写？不使用 || ？我分别弹出消息提醒用户啊！
        lastPayDay = curPayDay;
        // 这里千万不要交换顺序哦，我猜测可以更改本地时间干坏事情
        employee.transfer(salary);
    }
}

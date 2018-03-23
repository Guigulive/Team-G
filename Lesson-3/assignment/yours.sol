<<<<<<< HEAD
/**
 * @author: 花夏
 * @date:   2018-03-16
 * @Email:  liubiao@itoxs.com
 * 第三节：  编写多员工薪资系统，并继续添加新功能,如何减少GAS消耗
 * 在查看是否足够支付员工薪水时，算上手续费
 * @Copyright: Copyright (c) 2018 by huarxia. All Rights Reserved.
 */

pragma solidity ^0.4.14;
import './zeppelin/ownable.sol';
// 声明合约方法
contract CompensationSys is Ownable {
    // 发薪时间步长
    // uint constant payStep = 30 days;
    // 方便调试改成 10s
    uint constant payStep = 10 seconds;
    address owner;
    uint private totalSalary = 0;
    // 定义个strut类型的employee数组
    struct Employee {
        // 因为地址是唯一的，所以将地址设为Id
        address id;
        uint salary;
        uint lastPayDay;
    }
    // Employee [] employees;
    // 使用map结构方便查询降低gas
    mapping (address => Employee) public employees;
    /**
     * 定义一个modifier 判断是否包含这个员工
     */
    modifier employeeExist(address ads) {
        var employee = employees[ads];
        assert(employee.id != 0x0);
        _;
    }

    /**
     *  根据传入的 msg.sender判断是否具有操作权限
     */
    modifier isEmpolyee(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id == employeeId);
        _;
    }
    /**
     * [_paySurplusWages 内置支付剩余薪水函数，有木有和js类似？]
     * @author 花夏 liubiao@itoxs.com
     * private 内部函数请声明私有化
     * @param  employee [需要支付的员工数据信息]
     */
    function _paySurplusWages(Employee employee) private employeeExist(employee.id) {
        // assert(employee.id != 0x0);
        uint paySurplusWages = employee.salary * (now - employee.lastPayDay) / payStep;
        employee.id.transfer(paySurplusWages);
    }

    /**
     * [addEmployee 添加一个新员工地址]
     * @author 花夏 liubiao@itoxs.com
     * @param  employeeId [新员工地址]
     * @param  salary    [应付的月薪]
     */
    function addEmployee(address employeeId, uint salary) onlyOwner {
        var employeeTemp = employees[employeeId];
        // 添加员工
        Employee memory employee = Employee(employeeId, salary * 1 ether, now);
        employees[employeeId] = employee;
        totalSalary += employee.salary;
    }

    /**
     * [removerEmployee 删除一个员工并支付其剩余薪水]
     * @author 花夏 liubiao@itoxs.com
     * @param  employeeId [需要删除员工的地址]
     */
    function removerEmployee(address employeeId) onlyOwner {
        // 查找存在的需要移除的员工
        var employee = employees[employeeId];
        // 我已经在支付函数里做了判断拉~~
        _paySurplusWages(employee);
        totalSalary -= employees[employeeId].salary;
        delete employees[employeeId];
    }
    
    /**
     * [updateEmployeeMsg 更新员工地址或者月薪基数]
     * @author 花夏 liubiao@itoxs.com
     * @param  ads [更新地址]
     * @param  sly [更新的月薪基数]
     * ** 填写地址处一定要使用英文状态下的双引号 "" ***
     * 例如 "0xca35b7d915458ef540ade6068dfe2f44e8fa733c"
     */
    function updateEmployeeMsg(address ads, uint sly) onlyOwner employeeExist(ads) {
        // 查找存在的需要移除的员工
        var employee = employees[ads];
        // 我已经在支付函数里做了判断拉~~
        _paySurplusWages(employee);
        totalSalary -= employee.salary;
        employees[ads].id = ads;
        employees[ads].salary = sly * 1 ether;
        employees[ads].lastPayDay = now;
        totalSalary += employees[ads].salary;
    }

    /**
     * [changePaymentAddress]  更改员工薪水地址，这个函数要求只能员工自己能调用，老板不能调用
     *
     * @author 花夏 liubiao@itoxs.com
     * @param  ads [新地址]
     * @return     [description]
     */
    function changePaymentAddress(address ads) isEmpolyee(msg.sender) {
        employees[msg.sender].id = ads;
    }
    
    /**
     * [addFund  添加支付金到合约地址]
     * @author   花夏 liubiao@itoxs.com
     * @return   返回合约的余额
     */
    function addFund() payable returns(uint) {
        // this 指向合约对象
        return this.balance;
    }

    /**
     * [getPayTimes 获取合约地址还能支付薪水的次数]
     * @author 花夏 liubiao@itoxs.com
     * @return [返回合约地址还能支付薪水的次数]
     */
    function getPayTimes() returns(uint) {
        return this.balance / totalSalary;
    }

    /**
     * [hasEnoughPay 查看是否支付足够]
     * @author 花夏 liubiao@itoxs.com
     * @return [返回是否足够支付]
     */
    function hasEnoughPay() returns(bool) {
        return getPayTimes() >= 1;
    }

    /**
     * [getMyWage 员工自己领取自己的工资]
     * @author 花夏 liubiao@itoxs.com
     */
    function getMyWage() employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        uint curPayDay = employee.lastPayDay + payStep;
        assert(curPayDay <= now && hasEnoughPay());
        // 为啥这几个if判断个分开写？不使用 || ？我分别弹出消息提醒用户啊！
        employee.lastPayDay = curPayDay;
        // 这里千万不要交换顺序哦，我猜测可以更改本地时间干坏事情
        employee.id.transfer(employee.salary);
    }
}
=======
/*作业请提交在这个目录下*/
>>>>>>> Team-G/master

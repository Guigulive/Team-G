/**
 * Author: JustinLee
 * Date: 2018.03.11
 * Content: 单员工薪酬系统
 */
pragma solidity ^0.4.14;

contract Payroll {
    //发工资的周期
    uint constant payDuration = 10 seconds;
    //老板BOSS地址
    address owner;
    //工资基数
    uint salary = 1 ether;
    //员工地址
    address employee;
    //上次发工资的时间
    uint lastPayday;

    //初始化
    function Payroll() {
        //设置老板的地址为合约创建者
        owner = msg.sender;
    }


    /**
     * 更新员工地址及工资基数
     * param address e 员工地址
     * param uint s 工资基数
     */
    function updateEmployee(address e, uint s) {
        //只有老板才能更新员工地址和工资基数
        if(msg.sender != owner){
            revert();
        }

        //如果员工地址不为空
        if (employee != 0x0) {
            //需要发的工资 = 工资基数 * (当前时间 - 上次发工资的时间) / 发工资的周期
            uint payment = salary * (now - lastPayday) / payDuration;
            //更新上次发工资的时间为当前时间
            lastPayday = now;
            //更新地址和工资基数之前，给上一个员工发放应得的工资
            employee.transfer(payment);
        }

        //更新员工地址
        employee = e;
        //更新员工工资
        salary = s * 1 ether;
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
        //合约账户内剩余资金 除以 工资基数
        return this.balance / salary;
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
    function getPaid() {
        //只有员工才能领取工资
        if(msg.sender != employee){
            revert();
        }
        //当前工资支付时间 = 上次发工资的时间 + 发工资的周期
        uint curPayday = lastPayday + payDuration;
        //如果当前工资支付时间大于当前时间，则抛出异常
        if(curPayday > now){
            revert();
        }
        //将当前工资支付时间赋值给上次发工资的时间
        lastPayday = curPayday;
        //给员工发放工资
        employee.transfer(salary);
    }
}

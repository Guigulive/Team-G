//***
// * @Author: 花夏
// * @Date:   2018-03-12
// * @Email:  liubiao@itoxs.com
// * @Copyright: Copyright (c) 2018 by huarxia. All Rights Reserved.
// */

pragma solidity ^0.4.14;

// 声明合约方法
contract CompensationSys {
    // 员工月薪定为 1ether
    uint salary = 1 ether;
    // 花夏的薪资地址
    address huaxia = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    // 发薪时间步长
    // uint constant payStep = 30 days;
    // 方便调试改成 10s
    uint constant payStep = 10 seconds;
    // 上次发薪时间
    uint lastPayDay = now;
    
    // addFund 添加支付金到合约地址
    // payable 这个必须声明，因为不声明是无法增加金额进去的
    // return  返回合约地址的总金额
    function addFund() payable returns(uint) {
        // this 指向合约对象
        return this.balance;
    }
    
    // getPayTimes 获取合约地址还能支付薪水的次数
    // return      返回合约地址还能支付薪水的次数
    function getPayTimes() returns(uint) {
        return this.balance / salary;
    }
    
    function hasEnoughPay() returns(bool) {
        // ether == 10^18 wei
        // finney == 10^15 wei
        // 示例中采用 getPayTimes() > 0
        // 我私认为，程序是方便人读的，何不变成 getPayTimes() >= 1？
        // 这样是不是读到程序就知道是至少需要一个月的余额才行？
        
        // 然鹅~~ 难道发薪不要手续费？我再加上0.01ether的手续费吧。保证一下。
        return this.balance >= salary + 10 finney;
    }
    
    // getwMyWage 获取我应得的薪资
    function getwMyWage() {
        uint curPayDay = lastPayDay + payStep;
        if (curPayDay > now) {
            // 这里不写=是因为=容易被攻击哦，非要掐那个点领工资？
            revert();
        }
        if (!hasEnoughPay()) {
            revert();
        }
        // 为啥这俩个分开写？不使用 || ？我分别弹出消息提醒用户啊！
        lastPayDay = curPayDay;
        // 这里千万不要交换顺序哦，我猜测可以更改本地时间干坏事情
        huaxia.transfer(salary);
    }
}

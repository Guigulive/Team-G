//***
// * @Author: 花夏
// * @Date:   2018-03-12
// * @Email:  liubiao@itoxs.com
// * @Copyright: Copyright (c) 2018 by huarxia. All Rights Reserved.
// */

pragma solidity ^0.4.14;

// 声明合约方法
contract CompensationSys {
    // 员工月薪定为 1 ether
    // 默认设置 1 ether 好不好，不然非要去update一下，好麻烦
    // 不update就不能添加完金额后查询自己的余额了？
    uint salary = 1 ether;
    // 花夏的薪资地址
    address employee;
    // 发薪时间步长
    // uint constant payStep = 30 days;
    // 方便调试改成 10s
    uint constant payStep = 10 seconds;
    // 上次发薪时间
    uint lastPayDay = now;
    address owner;

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
        // 示例中有 以下代码
        // if (employee != 0x0) {
        //     uint payment = salary * (now - lastPayday) / payDuration;
        //     employee.transfer(payment);
        // }
        // 私认为是可以不要的，这个的意思是： 执行者查看是否有员工
        // 很久没有领取薪资，然后帮他发送了？天？还有这样的老板？
        // 这个函数是用作更新员工信息的，为什么要一个函数做多件事情？
        // 所以我省去了~~~

        // 看了群里的解释，貌似自己没有想到，更新地址后是需要支付没有支付的薪资的
        // 私认为还是单独写一个函数设置吧
        paySurplusWages();
        // 天啊撸！ 老板你调皮了~~ 万一执行者傻乎乎的没写地址呢？
        // 是不是要兼容一下？嘻嘻嘻~~~
        // if (ads == 0x0) {
        //     revert();
        // }
        // 测试了，貌似不能为空
        employee = ads;

        // 老板坏坏的哦，不给默认值，万一坏老板设置0呢？
        // if (sly == 0) {
        //     sly = 1;
        // }
        // 测试了貌似不能设置为0？猜想可不可以呢？
        salary = sly * 1 ether;

        // 这个有漏洞吧？
        // 今天发薪了？我去更新下信息，岂不是立马变成30 days后才能领工资？
        // 老板你好坏坏的哟~~
        lastPayDay = now;
    }
    
    //**
    //* [paySurplusWages 在更新地址或者月薪时支付剩余余额]
    //* @method   paySurplusWages
    //* @author 花夏 liubiao@itoxs.com
    //* @datetime 2018-03-13T10:18:51+080
    //*/
    function paySurplusWages() {
        if (employee != 0x0) {
             uint paySurplusWages = salary * (now - lastPayDay) / payStep;
             employee.transfer(paySurplusWages);
        }
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
        // 示例中采用 getPayTimes() > 0
        // 我私认为，程序是方便人读的，何不变成 getPayTimes() >= 1？
        // 这样是不是读到程序就知道是至少需要一个月的余额才行？

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
        if (msg.sender != employee) {
            // 龟毛的花夏也是个好人啊，你们可以来随便点，不会浪费你们的手续费；
            revert();
        }
        uint curPayDay = lastPayDay + payStep;
        if (curPayDay > now) {
            // 这里不写 = 是因为 = 容易被攻击哦，非要掐那个点领工资？
            revert();
        }
        if (!hasEnoughPay()) {
            revert();
        }
        // 为啥这几个if判断个分开写？不使用 || ？我分别弹出消息提醒用户啊！
        lastPayDay = curPayDay;
        // 这里千万不要交换顺序哦，我猜测可以更改本地时间干坏事情
        employee.transfer(salary);
    }
}

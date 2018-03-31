/*作业请提交在这个目录下*/
/*
@title:64+郑广军+第四课作业
@date:20180325
@desc:使用truffle测试payroll功能
*/
var Payroll = artifacts.require("./Payroll.sol");
var salary =1;
contract('Payroll', function(accounts) {
  var account=accounts[1];

  it("1.addFund 添加金额", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      console.log("****** addFund 添加 10 ether 金额");
      return PayrollInstance.addFund({from: accounts[0],value:web3.toWei('10','ether')});
    }).then(function() {
      console.log("获取余额");
      var banlance=web3.eth.getBalance(PayrollInstance.address);
      console.log(web3.fromWei(banlance.toNumber(),'ether'),'ether');
    });
  });

  it("2.addEmployee 添加新员工", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      console.log("****** addEmployee 添加新员工:",account);
      return PayrollInstance.addEmployee(account,salary,{from: accounts[0]});
    }).then(function() {
      console.log("检查地址:employees['"+account+"']");
      return PayrollInstance.employees.call(account);
    }).then(function(storedData) {
      console.log("员工地址:",storedData[0]);
      console.log("员工薪水:",web3.fromWei(storedData[1].toNumber(),'ether'),'ether');
      console.log("上次领薪日:",storedData[2].toNumber());
    });
  });

  it("3.getPaid 领取薪水", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      console.log("等待 10 seconds!");
      web3.currentProvider.send({jsonrpc:"2.0",method:"evm_increaseTime",params:[10],id:0});
      console.log("****** 薪水账号:",account);
      return PayrollInstance.getPaid({from: account});
    }).then(function() {
      console.log("检查地址:employees['"+account+"']");
      return PayrollInstance.employees.call(account);
    }).then(function(storedData) {
      console.log("员工地址:",storedData[0]);
      console.log("员工薪水:",web3.fromWei(storedData[1].toNumber(),'ether'),'ether');
      console.log("上次领薪日:",storedData[2].toNumber());
    }); 
  }); 
  
  it("4.removeEmployee 删除员工", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      console.log("****** 删除员工账号:",account);
      return PayrollInstance.removeEmployee(account,{from: accounts[0]});
    }).then(function(storedData) {
      console.log("check address:employees['"+account+"']");
      return PayrollInstance.employees.call(account);
    }).then(function(storedData) {
      console.log("员工地址:",storedData[0]);
      console.log("员工薪水:",web3.fromWei(storedData[1].toNumber(),'ether'),'ether');
      console.log("上次领薪日:",storedData[2].toNumber());
      var address=web3.toBigNumber(storedData[0]).toNumber();
      assert.equal(address,0,"测试失败!");
    }); 
  });
     
});

var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {
  it("...should not addEmployee, if not onlyOwner", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.addEmployee(accounts[1],1,{from:accounts[1]});
    }).catch(function(error) {
      assert(error.toString().includes('invalid'), "not addEmployee, because not owner");
    });
  });

  it("...should not addEmployee, if the employee exists", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.addEmployee(accounts[1],1);
    }).catch(function(error) {
      assert(error.toString().includes('invalid'), "not addEmployee because the employee exists");
    });
  });

  it("...should addEmployee", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.addEmployee(accounts[1],1);
    }).then(function() {
      return PayrollInstance.employees(accounts[1]);
    }).then(function(returnData) {
      assert.equal(returnData[0], accounts[1], "addEmployee");
    });
  });

  it("...should not removeEmployee, if not onlyOwner", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.addEmployee(accounts[2],1);
    }).then(function() {
      return PayrollInstance.removeEmployee(accounts[2],{from:accounts[1]});
    }).catch(function(error) {
      assert(error.toString().includes('invalid'), "not removeEmployee because not owner");
    });
  });

  it("...should not removeEmployee if the employee doesn't exist", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.removeEmployee(accounts[2]);
    }).catch(function(error) {
      assert(error.toString().includes('invalid'), "not removeEmployee because the employee doesn't exist");
    });
  });
  
  it("...should remove employee", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.removeEmployee(accounts[2]);
    }).then(function(returnData) {
      return PayrollInstance.employees(accounts[2]);
    }).then(function(returnData) {
      assert.equal(returnData[0], '0x0000000000000000000000000000000000000000', "removeEmployee");
    });
  });

  const displayCurrentTime = function() {
    console.log(web3.eth.getBlock(web3.eth.blockNumber).timestamp);
  }

  it("...should the employee getPaid", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      currentBalance = web3.eth.getBalance(accounts[1]).toNumber();
      return  web3.currentProvider.send({
        jsonrpc: "2.0", 
        method: "evm_increaseTime", 
        params: [100], id: 0
      });
    }).then(function(returnData) {
      return web3.eth.sendTransaction({from: web3.eth.accounts[0]});
    }).then(function(returnData) {
      return PayrollInstance.getPaid({from:accounts[1]});
    }).then(function(returnData) {
      assert(web3.eth.getBalance(accounts[1]).toNumber() > currentBalance, "getPaid");
    });
  });
  
  it("...should addFund", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      PayrollInstance.addFund({value:100000000000000000000}) 
      return PayrollInstance.addFund.call({value:0})   
    }).then(function(returnData) {
      assert.equal(JSON.parse(returnData), 100000000000000000000, "addFund");
    });
  });  
});

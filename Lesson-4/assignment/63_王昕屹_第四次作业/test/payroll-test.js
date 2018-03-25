var Payroll = artifacts.require("../contracts/payroll.sol");

var PayrollInstance;

contract('Payroll', function(accounts) {

  it("should addFund", function() {
    return Payroll.deployed().then(function(instance) {
      instance.addFund({
        from: accounts[0],
        value: web3.toWei('20', 'ether'),
      }).then(function() {
        var banlance = web3.eth.getBalance(instance.address);
        assert.equal(web3.fromWei(banlance.toNumber(), 'ether'), 20);
      });
    });
  });

  it("should add employee", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.createEmployee(accounts[1], 2, { from: accounts[0] });
    }).then(function() {
      return PayrollInstance.isEmployee.call(accounts[1]);
    }).then(function(result) {
      assert.equal(result, true);
    })
  });

  it("should remove employee", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.deleteEmployee(accounts[1], { from: accounts[0] });
    }).then(function(storedData) {
      return PayrollInstance.isEmployee.call(accounts[1]);
    }).then(function(result) {
      assert.equal(result, false);
    });
  });

});



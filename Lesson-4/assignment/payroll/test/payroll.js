var Payroll = artifacts.require("./Payroll.sol");


contract('Payroll', function(accounts) {


  it("...addEmployee", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      return payrollInstance.addEmployee(accounts[1], 1, {from: accounts[0]});
    }).then(function() {
      return payrollInstance.employees.call(accounts[1]);
    }).then(function(employee) {
      //console.log(employee)
      assert.equal(employee[0], accounts[1], "address not added");
    });
  });
  
  //Add employee=>Add fund=>remove Added=>Assert
  it("...removeEmployee", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      return payrollInstance.addEmployee(accounts[2], 1, {from: accounts[0]});
        })
    .then(function(){
        return payrollInstance.addFund({value: 100}); 
    })
    .then(function() {
      return payrollInstance.employees.call(accounts[2]);
    })
    .then(function() {
       return payrollInstance.removeEmployee(accounts[2], {from: accounts[0]});
       })
    .then(function() {
      return payrollInstance.employees.call(accounts[2]);
        })
    .then(function(employee) {
      assert.notEqual(employee[0], accounts[2], "address not removed");
    });
  });
  
  it("...getPaid", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      return payrollInstance.addEmployee(accounts[3], 1, {from: accounts[0]});
        })
    .then(function(){
        return payrollInstance.addFund({value: 100}); 
    })
    .then(function() {
      return payrollInstance.getPaid({from: accounts[3]});
    })
    
  });
  


});
  
var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {
    var PayrollInstance;

    it("Add Fund.", function(){
        console.log("\n" + "-".repeat(100) + "\n");
        return Payroll.deployed().then(function(instance){
            PayrollInstance = instance;
            console.log("PayrollInstance:", PayrollInstance.address);
            return PayrollInstance.addFund({from: accounts[0], value: web3.toWei('50', 'ether')});
        }).then(function(){
            console.log(web3.fromWei(web3.eth.getBalance(PayrollInstance.address).toNumber(), 'ether'), 'ether');
        });
    });

    it("If not owner.", function(){
        console.log("\n" + "-".repeat(100) + "\n");
        return Payroll.deployed().then(function(instance){
            PayrollInstance = instance;
            console.log("PayrollInstance:", PayrollInstance.address)
            return PayrollInstance.addEmployee(accounts[1], 1, {from: accounts[1]});
        }).catch(function(e){
            assert(e, "don't add employee, because not owner");
        });
    });

    it("Add Employee Successfully.", function(){
        console.log("\n" + "-".repeat(100) + "\n");
        return Payroll.deployed().then(function(instance){
            PayrollInstance = instance;
            console.log("PayrollInstance:", PayrollInstance.address);
            return PayrollInstance.addEmployee(accounts[1], 1);
        });
    });

    it("getPaid Successfully.", function(){
        console.log("\n" + "-".repeat(100) + "\n");
        return Payroll.deployed().then(function(instance){
            PayrollInstance = instance;
            web3.currentProvider.send({
                jsonrpc: "2.0",
                method: "evm_increaseTime",
                params: [20],
                id: 0
            });
            return PayrollInstance.getPaid({from: accounts[1]});
        });
    });

    it("Remove Employee Successfully.", function(){
        console.log("\n" + "-".repeat(100) + "\n");
        return Payroll.deployed().then(function(instance){
            PayrollInstance = instance;
            console.log("PayrollInstance:", PayrollInstance.address);
            return PayrollInstance.removeEmployee(accounts[1]);
        });
    });
});

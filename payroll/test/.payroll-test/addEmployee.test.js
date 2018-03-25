const ora = require('ora');
const _ = require('lodash');
const chalk = require('chalk');
const _GAS = {
    gas: 3000000
};
module.exports = function(PayrollStorage, accounts, spinner, next) {
    spinner.color = 'yellow';
    // spinner.text = '测试中...\n';
    it('owner 执行addEmployee测试', function () {
        var address = accounts[0];
        return PayrollStorage.deployed().then(function(instance) {
            PayrollStorageInstance = instance;
            return PayrollStorageInstance.addEmployee(address, 1, _.assign({
                from: accounts[0]
            }, _GAS));
        }).then(function() {
            return PayrollStorageInstance.employees.call(address);
        }).then(function(res) {
            setTimeout(()=> {
                spinner.color = 'green';
                spinner.text = chalk.green('owwer测试 Function addEmployee 成功! 😄');
                spinner.succeed();
            }, 1000);
        });
    });
    it('非owner 执行addEmployee测试', function () {
        var address = accounts[1];
        return PayrollStorage.deployed().then(function (instance) {
            PayrollStorageInstance = instance;
            return PayrollStorageInstance.addEmployee(address, 1, _.assign({
                from: address
            }, _GAS));
        }).then(function () {
            return PayrollStorageInstance.employees.call(address);
        }).catch(function(error) {
            setTimeout(()=> {
                spinner.color = 'green';
                spinner.text = chalk.green('非owwer测试 Function addEmployee 成功! 😄');
                spinner.succeed();
            }, 100);
        });
    });
    next && next();
};

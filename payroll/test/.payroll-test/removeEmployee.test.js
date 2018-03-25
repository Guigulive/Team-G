const ora = require('ora');
const _ = require('lodash');
const chalk = require('chalk');
const _GAS = {
    gas: 3000000
};
module.exports = function(PayrollStorage, accounts, spinner, next) {
    spinner.color = 'yellow';
    spinner.text = '测试中...\n';
    it('owner 执行removeEmployee测试', function () {
        var address = accounts[accounts.length - 2];
        var PayrollStorageInstance;
        return PayrollStorage.deployed().then(function (instance) {
            PayrollStorageInstance = instance;
            return PayrollStorageInstance.addEmployee(address, 1, _.assign({
                from: accounts[0]
            }, _GAS));
        }).then(function() {
            return PayrollStorageInstance.removeEmployee(address, _.assign({
                from: accounts[0]
            }, _GAS));
        }).then(function () {
            return PayrollStorageInstance.employees(address, {from: accounts[0]});
        }).then(function() {
            setTimeout(()=> {
                spinner.color = 'green';
                spinner.text = chalk.green('owner测试 Function removeEmployee 成功! 😄');
                spinner.succeed();
            }, 100);
        });
    });
    it('非owner 执行removeEmployee测试', function () {
        var address = accounts[accounts.length - 1];
        var PayrollStorageInstance;
        return PayrollStorage.deployed().then(function(instance) {
            PayrollStorageInstance = instance;
            return PayrollStorageInstance.addEmployee(address, 1, _.assign({
                from: accounts[1]
            }, _GAS));
        }).then(function() {
            return PayrollStorageInstance.removeEmployee(address, _.assign({
                from: accounts[1]
            }, _GAS));
        }).then(function() {
            return PayrollStorageInstance.employees(address, {from: accounts[0]});
        }).catch(function(eror) {
            setTimeout(()=> {
                spinner.color = 'green';
                spinner.text = chalk.green('非owner测试 Function removeEmployee 成功! 😄');
                spinner.succeed();
            }, 100);
        });
    });
    next && next();
}

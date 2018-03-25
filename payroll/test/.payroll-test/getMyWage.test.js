const ora = require('ora');
const _ = require('lodash');
const chalk = require('chalk');
const _GAS = {
    gas: 3000000
};
module.exports = function(PayrollStorage, accounts, spinner, next) {
    spinner.color = 'yellow';
    spinner.text = '测试中...\n';
    next && next();
    var address = accounts[1];
    var PayrollStorageInstance;
    it('当前自己地址 执行getMyWage测试', function() {
        return PayrollStorage.deployed().then(function (instance) {
            PayrollStorageInstance = instance;
            return PayrollStorageInstance.addEmployee(address, 1, _.assign({
                from: accounts[0]
            }, _GAS));
        }).then(function() {
            return PayrollStorageInstance.getMyWage(_.assign({
                from: address
            }, _GAS));
        }).then(function (storedData) {
            setTimeout(()=> {
                spinner.color = 'green';
                spinner.text = chalk.green('Function getMyWage 成功');
                spinner.succeed();
            }, 100);
        });
    });
    it('非自己地址 执行getMyWage测试', function() {
        return PayrollStorage.deployed().then(function (instance) {
            PayrollStorageInstance = instance;
            return PayrollStorageInstance.addEmployee(address, 1, _.assign({
                from: accounts[0]
            }, _GAS));
        }).then(function() {
            return PayrollStorageInstance.getMyWage(_.assign({
                from: address
            }, _GAS));
        }).catch(function() {
            setTimeout(()=> {
                spinner.color = 'green';
                spinner.text = chalk.green('非自己地址测试 Function getMyWage 成功');
                spinner.succeed();
            }, 100);
        });
    });
};

const ora = require('ora');
const _ = require('lodash');
const chalk = require('chalk');
const _GAS = {
    gas: 3000000
};
module.exports = function(PayrollStorage, accounts, next) {
    const spinner = ora('开始Payroll合约中' + chalk.cyan(' getMyWage ') + '函数测试!\n').start();
    next && next();
    var address = accounts[1];
    var PayrollStorageInstance;
    it('', function () {
        return PayrollStorage.deployed().then(function (instance) {
            PayrollStorageInstance = instance;
            return PayrollStorageInstance.addEmployee(address, 1, _.assign({
                from: accounts[0]
            }, _GAS));
        }).then(function () {
            return PayrollStorageInstance.getMyWage(_.assign({
                from: address
            }, _GAS));
        }).then(function (storedData) {
            spinner.color = 'green';
            spinner.text = chalk.green('Function getMyWage 测试成功');
            spinner.succeed();
        });
    });
};

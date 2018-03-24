const ora = require('ora');
const _ = require('lodash');
const chalk = require('chalk');
const _GAS = {
    gas: 3000000
};
module.exports = function(PayrollStorage, accounts, next) {
    const spinner = ora('开始Payroll合约中' + chalk.cyan(' addEmployee ') + '函数测试!\n').start();
    next && next();
    it('', function () {
        var address = accounts[0];
        return PayrollStorage.deployed().then(function (instance) {
            PayrollStorageInstance = instance;
            return PayrollStorageInstance.addEmployee(address, 1, _.assign({
                from: accounts[0]
            }, _GAS));
        }).then(function () {
            return PayrollStorageInstance.employees.call(address);
        }).then(function (storedData) {
            spinner.color = 'green';
            spinner.text = chalk.green('Function addEmployee 测试成功');
            spinner.succeed();
        });
    });
};

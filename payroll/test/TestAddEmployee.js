const ora = require('ora');
const _ = require('lodash');
const chalk = require('chalk');
let _GAS = {
    gas: 3000000
};
var PayrollStorage = artifacts.require("./Payroll.sol");
const spinner = ora('开始Payroll合约中' + chalk.cyan(' addEmployee ') + '函数测试!').start();
contract('PayrollStorage', function (accounts) {
    it('', function () {
        return PayrollStorage.deployed().then(function (instance) {
            PayrollStorageInstance = instance;
            return PayrollStorageInstance.addEmployee('0x798f43262235ea63b5c3f0cbc0ac70cb9b9a5414', 1, _.assign({
                from: accounts[0]
            }, _GAS));
        }).then(function () {
            return PayrollStorageInstance.employees.call('0x798f43262235ea63b5c3f0cbc0ac70cb9b9a5414');
        }).then(function (storedData) {
            spinner.color = 'green';
            spinner.text = chalk.green('Function addEmployee 测试成功');
            spinner.succeed()
        });
    });
});

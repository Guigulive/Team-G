const ora = require('ora');
const _ = require('lodash');
const chalk = require('chalk');
const _GAS = {
    gas: 3000000
};
// todo(思考) 后期可参照gulp直接获取文件夹下所有文件，不需要单独require
var testArr = [
    require('./.payroll-test/testAddEmployee.js'),
    require('./.payroll-test/testRemoveEmployee.js')
];
var PayrollStorage = artifacts.require("./Payroll.sol");
contract('PayrollStorage', function (accounts) {
    next();
    function next() {
        if (testArr.length > 0) {
            testArr.shift()(PayrollStorage, accounts, next);
        }
    };
});

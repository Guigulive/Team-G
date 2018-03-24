var requireDir = require('require-dir');
const ora = require('ora');
const _ = require('lodash');
const chalk = require('chalk');
const _GAS = {
    gas: 3000000
};
var testArr = [];
var dir = requireDir('./.payroll-test/', {
    recurse: true,
    filter: function(fullPath) {
        // 匹配测试示例文件必须以  .test.js结尾
        return process.env.NODE_ENV !== 'production' && !!fullPath.match(/(\.test\.js)$/);
    }
});
for (name in dir) {
    testArr.push(dir[name]);
}
var PayrollStorage = artifacts.require("./Payroll.sol");
contract('PayrollStorage', function (accounts) {
    next();
    function next() {
        if (testArr.length > 0) {
            testArr.shift()(PayrollStorage, accounts, next);
        }
    };
});

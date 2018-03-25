var requireDir = require('require-dir');
var YAML = require('yamljs');
const path = require('path');
const ora = require('ora');
const _ = require('lodash');
const chalk = require('chalk');
const _GAS = {
    gas: 3000000
};
var testArr = [];
var testignore = YAML.load(path.join(__dirname, './.testignore.yml'));
const ignore = testignore.ignore;
const fileNameReg = /([^/]+)$/;
var dir = requireDir('./.payroll-test/', {
    recurse: true,
    filter: function(fullPath) {
        // 匹配测试示例文件必须以  .test.js结尾
        // 忽略文件不返回
        const fileName = fullPath.match(fileNameReg)[1];
        return process.env.NODE_ENV !== 'production'
            && !!fileName.match(/(\.test\.js)$/)
            && ignore.indexOf(fileName) === -1;
    }
});
for (name in dir) {
    testArr.push(dir[name]);
}
// todo 生成的测试文件按时间戳保存到result文件夹下
var PayrollStorage = artifacts.require("./Payroll.sol");
contract('PayrollStorage', function (accounts) {
    next();
    function next() {
        if (testArr.length > 0) {
            testArr.shift()(PayrollStorage, accounts, next);
        }
    };
});

var Ownable = artifacts.require('zeppelin-solidity/contracts/ownership/Ownable.sol');
var SafeMath = artifacts.require('zeppelin-solidity/contracts/math/SafeMath.sol');
var Payroll = artifacts.require('./Payroll.sol');
module.exports = function(deployer) {
    deployer.deploy(Ownable);
    deployer.deploy(SafeMath);
    deployer.deploy(Payroll);
    deployer.link(Ownable, Payroll);
    deployer.link(SafeMath, Payroll);
};

var Ownable = artifacts.require('zeppelin-solidity/contracts/ownership/Ownable.sol');
var Payroll = artifacts.require('./Payroll.sol');
module.exports = function(deployer) {
    deployer.deploy(Ownable);
    deployer.link(Ownable, Payroll);
    deployer.deploy(Payroll);
};

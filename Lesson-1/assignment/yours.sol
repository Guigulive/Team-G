/*Assignment #1 Ziqi Li*/

pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;
    address boss;
    //init Frank's salary
    uint frankSalary = 1 ether; 
    //init Frank's address
    address frankAddress = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    uint lastPayday = now;
    
    function Payroll() {
        boss = msg.sender;
    }
    
    //Update frank's address, has to be done by boss
    function updateFrankAddress(address newAddress) {
        require(msg.sender == boss);
        if (newAddress == 0x0) {
            revert();
        }
        frankAddress = newAddress;
    }
    
    //Update frank's salary, has to be done by boss
    function updateFrankSalary(uint newSalary) {
        require(msg.sender == boss);
        if (frankSalary <= 0) {
            revert();
        }
        frankSalary = newSalary * 1 ether;
    }
    
    //Add fund, has to be called from Boss
    function addFund() payable returns (uint) {
        require(msg.sender == boss);
        return this.balance;
    }
    
    //Calculate runway, has to be called from Boss
    function calculateRunway() returns (uint) {
        require(msg.sender == boss);
        return this.balance / frankSalary;
    }
    
    //Check Frank's salary, has to be called from Boss or Frank
    function getFrankSalary() returns (uint) {
        require(msg.sender == frankAddress || msg.sender ==  boss);
        return frankSalary;
    }
    
    //Check funds, has to be called from Boss
    function hasEnoughFund() returns (bool) {
        require(msg.sender == boss);
        return calculateRunway() > 0;
    }
    
    //Frank gets paid, has to be called from Frank
    function getPaid() {
        require(msg.sender == frankAddress);
        
        uint nextPayday = lastPayday + payDuration;
        if (nextPayday > now){
            revert();
        }

        lastPayday = now;
        boss.transfer(frankSalary);
    }
}
/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;
contract Payroll{
    uint salary = 1 ether;
    address frankAddress = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint  payDuration = 10 seconds;
    uint lastPayDay = now;
   
   function addFund() public payable returns (uint){
       return this.balance;
   }
  
  function caclulateRunway()  returns (uint){
      return this.balance / salary;
  }
  
  function hasEnoughFund() private returns (bool) {
      return caclulateRunway() > 0;
  }
  
  function getPaid() public {
      if(msg.sender != frankAddress){
          revert();
      }
    uint nextPayDay =   lastPayDay + payDuration;
    if(nextPayDay > now){
          revert();
    }
    lastPayDay = nextPayDay;
    frankAddress.transfer(salary);
  }
  
  function updateAddress(address newAddress) public{
      frankAddress = newAddress;
  }
  
  function updateSalary(uint newSalary) public{
      salary = newSalary;
  }
  
}
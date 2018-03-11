// 声明所使用的版本，实际上是方便开源
pragma solidity ^0.4.14;

contract CompensationSys {
    // 声明一个智能合约，这个智能合约是薪酬系统
    uint storedData;
    
    // 设置值 
    function setStoredData(uint x) {
        storedData = x;
    }
    // 获取值
    function getStoredData() constant returns(uint) {
        return storedData;
    }
}
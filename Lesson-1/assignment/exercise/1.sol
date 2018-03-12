//***
// * @Author: 花夏>
// * @Date:   2018-03-07T15:27:43+08:00
// * @Email:  liubiao@itoxs.com
// * @Last modified by:   huaxia
// * @Last modified time: 2018-03-12T20:55:32+08:00
// * @Copyright: Copyright (c) 2018 by huarxia. All Rights Reserved.
// */
// 声明所使用的版本，实际上是方便开源
pragma solidity ^0.4.14;

// 声明一个合约,这个合约是薪酬系统
contract CompensationSys {
    uint storedData;

    // 获取storedData值
    // @return uint storedData
    function getStoredData() returns(uint) {
        return storedData;
    }

    // 设置storedData值
    // @parma uint x
    function setStoredData(uint x) {
        storedData = x;
    }
}

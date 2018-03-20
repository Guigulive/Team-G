## 硅谷live以太坊智能合约 第三课作业
这里是同学提交作业的目录

### 第三课：课后作业
- 第一题：完成今天所开发的合约产品化内容，使用Remix调用每一个函数，提交函数调用截图


<img width="708" alt="untitled1" src="https://user-images.githubusercontent.com/5518908/37686863-763bf35c-2c56-11e8-9bc9-be961dd4a3fc.png">
<img width="712" alt="d2" src="https://user-images.githubusercontent.com/5518908/37686867-78ec8382-2c56-11e8-9c36-68d53bf1cf4c.png">


- 第二题：增加 changePaymentAddress 函数，更改员工的薪水支付地址，思考一下能否使用modifier整合某个功能
```
modifier onlyEmployee(address employeeId){
        require(msg.sender == employeeId);
        _;
    }
    
function changePaymentAddress(address newId) onlyEmployee(msg.sender) {
        var employee = employees[msg.sender];
        _partialPaid(employee);
        employees[msg.sender].id = newId;
    }
```

- 第三题（加分题）：自学C3 Linearization, 求以下 contract Z 的继承线
- contract O
- contract A is O
- contract B is O
- contract C is O
- contract K1 is A, B
- contract K2 is A, C
- contract Z is K1, K2

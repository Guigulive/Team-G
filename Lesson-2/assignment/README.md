## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 - 如何优化calculateRunway这个函数来减少gas的消耗？

简单的记录了一下2个，3个，4个员工的时候 calculateRunway 消耗的gas， 可以看到gas使用明显增大。因为for循环随着数组的增加，消耗的也越来越多，可以通过一个变量来保存所有员工工资的和，每次增加删除员工的时候来更改这个和

 2 employee	
 transaction cost 	23747 gas 
 execution cost 	2475 gas 
3
 transaction cost 	24528 gas 
 execution cost 	3256 gas 
 4
 transaction cost 	25309 gas 
 execution cost 	4037 gas 

提交：智能合约代码，gas变化的记录，calculateRunway函数的优化




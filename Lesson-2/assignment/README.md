## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化

--- 
The reason of gas variation is that the `for` loop reads more data as the number of employees increases. 
|        | Transaction gas | Execution gas  |
| :----: |:-----:| :---:|
| first  | 23162 | 1890 |
| second | 24053 | 2781 |
| third  | 24944 | 3672 |
| forth  | 25835 | 4563 |
| fifth  | 26726 | 5454 |
| sixth  | 27617 | 6345 |
| seventh| 28508 | 7236 |
| eighth | 29399 | 8127 |
| ninth  | 30290 | 9018 |
| tenth  | 31181 | 9909 |
---
Set a global variable to track total salary. After the implementation, the gas becomes constant: `transaction gas 22418 with execution gas 1146`

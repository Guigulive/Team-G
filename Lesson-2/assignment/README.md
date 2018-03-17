## 硅谷live以太坊智能合约 第二课作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化


##### 添加10个雇员

|Id |Address |Salary|
|---|--------|------|
|1 |0xca35b7d915458ef540ade6068dfe2f44e8fa733a |1 |
|2 |0xca35b7d915458ef540ade6068dfe2f44e8fa733b |1 |
|3 |0xca35b7d915458ef540ade6068dfe2f44e8fa733c |1 |
|4 |0xca35b7d915458ef540ade6068dfe2f44e8fa733d |1 |
|5 |0xca35b7d915458ef540ade6068dfe2f44e8fa733e |1 |
|6 |0xca35b7d915458ef540ade6068dfe2f44e8fa733f |1 |
|7 |0xca35b7d915458ef540ade6068dfe2f44e8fa733g |1 |
|8 |0xca35b7d915458ef540ade6068dfe2f44e8fa733h |1 |
|9 |0xca35b7d915458ef540ade6068dfe2f44e8fa733i |1 |
|10 |0xca35b7d915458ef540ade6068dfe2f44e8fa733j |1 |

##### 优化函数calculateRunway前所消耗的Gas

|Id |transaction cost |execution cost |
|---|-----------------|---------------|
|1 |22988 |1716 |
|2 |23769 |2497 |
|3 |24550 |3278 |
|4 |25331 |4059 |
|5 |26112 |4840 |
|6 |26893 |5621 |
|7 |27674 |6402 |
|8 |28455 |7183 |
|9 |29236 |7964 |
|10 |30017 |8745 |


##### 优化函数calculateRunway后所消耗的Gas

|Id |transaction cost |execution cost |
|---|-----------------|---------------|
|1 |22124  |852 |
|2 |22124|852 |
|3 |22124 |852 |
|4 |22124 |852 |
|5 |22124 |852|
|6 |22124 |852|
|7 |22124 |852|
|8 |22124 |852|
|9 |22124 |852|
|10 |22124 |852|

##### 优化
优化前，每次执行函数calculateRunway都要循环整个雇员信息的数组
优化后，execution cost每次都为852
优化方式，定义一个全局变量countSalary来存储所有雇员的薪资之和，每次执行函数calculateRunwayAfter，账户内剩余资金balance 除以 所有雇员的薪资之和countSalary

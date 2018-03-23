## 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化


## Run the contract Payroll
**Add 10 Employees**

|Serial No. |Address |Salary |
|-----------|--------|-------|
|1 |"0x583031d1113ad414f02576bd6afabfb30214022a" |1 |
|2 |"0x583031d1113ad414f02576bd6afabfb30214022b" |1 |
|3 |"0x583031d1113ad414f02576bd6afabfb30214022c" |1 |
|4 |"0x583031d1113ad414f02576bd6afabfb30214022d" |1 |
|5 |"0x583031d1113ad414f02576bd6afabfb30214022e" |1 |
|6 |"0x583031d1113ad414f02576bd6afabfb30214022f" |1 |
|7 |"0x583031d1113ad414f02576bd6afabfb30214022g" |1 |
|8 |"0x583031d1113ad414f02576bd6afabfb30214022h" |1 |
|9 |"0x583031d1113ad414f02576bd6afabfb30214022i" |1 |
|10 |"0x583031d1113ad414f02576bd6afabfb30214022j" |1 |
|11 |"0x583031d1113ad414f02576bd6afabfb30214022k" |1 |
|12 |"0x583031d1113ad414f02576bd6afabfb30214022l" |1 |

**Cost of Gas for Transaction to Payroll.calculateRunway**

|Serial No. |transaction cost |execution cost |
|-----------|-----------------|---------------|
|1 |22971 |1699 |
|2 |23759 |2487 |
|3 |24547 |3275 |
|4 |25335 |4063 |
|5 |26123 |4851 |
|6 |26911 |5639 |
|7 |27699 |6427 |
|8 |28487 |7215 |
|9 |29275 |8003 |
|10 |29275 |8003 |
|11 |29275 |8003 |
|12 |29275 |8003 |

**Cost of Gas after Optimization**

|Serial No. |transaction cost |execution cost |
|-----------|-----------------|---------------|
|1 |22122 |850 |
|2 |22122 |850 |
|3 |22122 |850 |
|4 |22122 |850 |
|5 |22122 |850 |
|6 |22122 |850 |
|7 |22122 |850 |
|8 |22122 |850 |
|9 |22122 |850 |
|10 |22122 |850 |
|11 |22122 |850 |
|12 |22122 |850 |

## Optimization
Based on data from running the original contract, the cost of gas for transaction to Payroll.calculateRunway grows by around 1600 gas for every employee and salary increases. The reason is that the for-loop in the function calculateRunway calculates the totalSalary by calculating all the employees every employee increases.

The solution is to use a variable totalSalary to avoid high gas cost in for-loop. The data after the code optimization shows it works.

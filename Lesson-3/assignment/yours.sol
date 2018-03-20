/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;
/*
@title:第三课作业
@date:20180320
@auther:64+郑广军
*/
contract Payroll{
    /*变量定义*/
    uint constant payDuration=10 seconds;
    address owner;
    uint totalsalary;
    
    //结构体
    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }
    mapping(address =>Employee) employees;
    
    //判断合约者是owner
    modifier onlyOwner{
        require(msg.sender==owner);
        _;
    }
    //判断员工是否存在
    modifier employeeExist(address employeeid ){
        var employee=employees[employeeid];
        assert(employee.id!=0x0);
        _;
    }
    
    function Payroll(){
        owner=msg.sender;
    }
    
    //结算之前薪资
    function _partialPaid(Employee employee) private {
        uint payment=employee.salary*(now -employee.lastPayday)/payDuration;
        employee.id.transfer(payment);
    }
    //添加员工
    function addEmployee(address employeeid,uint salary) onlyOwner  {
        //require(msg.sender==owner);
        var employee=employees[employeeid];
        assert(employee.id==0x0);
        totalsalary+=salary * 1 ether;
        employees[employeeid]=Employee(employeeid,salary * 1 ether,now);

    }
    //删除员工
    function removeEmployee(address employeeid) onlyOwner employeeExist(employeeid) {
        //require(msg.sender==owner);
        var employee=employees[employeeid];
        //assert(employee.id!=0x0);
        
        _partialPaid(employee);
        totalsalary-=employees[employeeid].salary;
        delete employees[employeeid];

    }
    
    //更新员工支付地址
    function changePaymentAddress(address employeeid,address new_employeeid) onlyOwner employeeExist(employeeid) {
        var employee=employees[employeeid];
        employee.id=new_employeeid;
    }
    
    //更新员工信息
    function updateEmployee(address employeeid,uint salary) onlyOwner employeeExist(employeeid) {
        //require(msg.sender==owner);
       var employee=employees[employeeid];
        //assert(employee.id!=0x0);
        _partialPaid(employee);
        totalsalary-=employees[employeeid].salary;
        employees[employeeid].salary=salary * 1 ether;
        totalsalary+=employees[employeeid].salary;
        employees[employeeid].lastPayday=now;
    }
    //充值
    function addFund() payable returns(uint){
        return this.balance;
    }
    //计算可支付次数
    function calculateRunway() returns (uint){
        return this.balance/totalsalary;
    }
    //判断是否足够支付
    function hasEnoughFund() returns(bool){
        return calculateRunway()>0;
    }
    //领取薪水
    function getPaid() employeeExist(msg.sender) {
        
        var employee=employees[msg.sender];
        //assert(employee.id!=0x0);
        
        uint nextPayday=employee.lastPayday+payDuration;
        employees[msg.sender].lastPayday=nextPayday;
        employee.id.transfer(employee.salary);
    }
}

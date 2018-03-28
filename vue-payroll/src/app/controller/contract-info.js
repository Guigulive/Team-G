import {BigNumber} from 'bignumber.js';
import moment from 'moment';
import _ from 'lodash';
export default {
    getInfo(_this) {
        var me = this;
        window.addEventListener('load', function() {
            me.init(_this);
        });
        // todo 路由切换做单独判断
        // me.init(_this);
    },

    /**
     * [init] 初始化页面进行默认
     *
     * @author 花夏 liubiao@itoxs.com
     * @param  {Object} _this [传入的当前对象]
     */
    init(_this) {
        this.self = _this;
        let Payroll = _this.Payroll;
        let web3 = _this.web3;
        let PayrollInstance;
        _this.info = [];
        Payroll.deployed().then((instance) => {
            PayrollInstance = instance;
            _this.info.push({
                name: '合约地址',
                value: PayrollInstance.address
            });
            return this;
        }).then((result) => {
            PayrollInstance.addFund.call().then((res) => {
                _this.info.push({
                    name: '合约剩余总额 / ETH',
                    value: web3.fromWei(new BigNumber(res).toNumber()),
                    isAddFund: true
                });
            });
            return this;
        }).then((result) => {
            PayrollInstance.getPayTimes.call().then((res) => {
                _this.info.push({
                    name: '剩余最多支付次数 / 次',
                    value: new BigNumber(res).toNumber()
                });
            });
            return this;
        });
    },

    /**
     * [addFund] 添加金额到合约地址里
     *
     * @author 花夏 liubiao@itoxs.com
     * @param  {Number} value [添加的eth数量]
     * @param  {Object} _this [调用对象]
     */
    addFund(value, _this) {
        var me = this;
        let Payroll = me.self.Payroll;
        let web3 = me.self.web3;
        Payroll.deployed().then((instance) => {
            instance.addFund(_.assign({
                from: me.self.account,
                value: web3.toWei(value)
            }, _this.GAS)).then(() => {
                setTimeout(() => {
                    self.location.reload();
                }, 1000);
            });
            return this;
        });
    },

    /**
     * [addEmpolyee] 添加一个员工
     *
     * @author 花夏 liubiao@itoxs.com
     * @param  {String} address [员工地址]
     * @param  {Number} salary  [员工月薪]
     * @param  {Object} _this   [调用的当前对象]
     */
    addEmpolyee(address, salary, _this) {
        let Payroll = _this.Payroll;
        Payroll.deployed().then((instance) => {
            instance.addEmployee(address, salary, _.assign({
                from: _this.account
            }, _this.GAS)).then(() => {
                setTimeout(() => {
                    self.location.reload();
                }, 1000);
            });
            return this;
        });
    },

    getEmployeeList(_this) {
        let Payroll = _this.Payroll;
        let web3 = _this.web3;
        Payroll.deployed().then((instance) => {
            instance.checkInfo.call().then((res) => {
                _this.balance = web3.fromWei(new BigNumber(res[0]).toNumber());
                _this.runTimes = new BigNumber(res[1]).toNumber();
                _this.employeeCount = new BigNumber(res[2]).toNumber();
                return _this;
            }).then((result) => {
                let employeeCount = result.employeeCount;
                var employeesListArr = [];
                for (var i = 0; i < employeeCount; i++) {
                    employeesListArr.push(instance.checkEmployee.call(i));
                }
                return employeesListArr;
            }).then((res) => {
                Promise.all(res).then(values => {
                    let employees = values.map(value => ({
                        address: value[0],
                        salary: web3.fromWei(value[1].toNumber()),
                        lastPayDay: moment(new Date(new BigNumber(value[2]).toNumber())).format('LLLL')
                    }));
                    console.log(employees);
                });
            });
            return this;
        });
    }
};

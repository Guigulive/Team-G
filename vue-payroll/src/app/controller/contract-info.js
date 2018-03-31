import {BigNumber} from 'bignumber.js';
import moment from 'moment';
import _ from 'lodash';
export default {
    getInfo(_this) {
        this.init(_this);
        this.getEmployeeList(_this);
    },

    /**
     * [init] 初始化页面进行默认
     *
     * @author 花夏 liubiao@itoxs.com
     * @param  {Object} _this [传入的当前对象]
     */
    init(_this) {
        this.self = _this;
        _this.info.push({
            name: '合约地址',
            value: _this.instance.address
        });
        _this.instance.addFund.call().then((res) => {
            _this.info.push({
                name: '合约剩余总额 / ETH',
                value: _this.web3.fromWei(new BigNumber(res).toNumber()),
                isAddFund: true
            });
        });
        _this.instance.getPayTimes.call().then((res) => {
            _this.info.push({
                name: '剩余最多支付次数 / 次',
                value: new BigNumber(res).toNumber()
            });
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
        var newFund = _this.instance.NewFund((err, result) => {
            if (!err) {
                _this.info = [];
                me.init(_this);
                _this.addLoading = false;
            }
            newFund.stopWatching();
        });
        _this.instance.addFund(_.assign({
            from: _this.account,
            value: _this.web3.toWei(value)
        }, _this.gas));
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
        let me = this;
        var newEmployeeExist = _this.instance.NewEmployeeExist((err, result) => {
            if (!err) {
                _this.$Message.error('该地址已存在!请不要重复添加');
            }
            newEmployeeExist.stopWatching();
        });
        _this.instance.addEmployee(address, salary, _.assign({
            from: _this.account
        }, _this.gas)).then((res) => {
            var newEmployeeIsNull = _this.instance.NewEmployeeIsNull((err, result) => {
                if (!err) {
                    _this.addAddress = '';
                    _this.addSalary = '';
                    me.getEmployeeList(_this);
                    _this.addEmpLoading = false;
                }
                newEmployeeIsNull.stopWatching();
            });
        });
    },

    /**
     * [getEmployeeList] 获取所有员工列表
     *
     * @author 花夏 liubiao@itoxs.com
     * @param  {Object} _this [调用的当前对象]
     */
    getEmployeeList(_this) {
        _this.instance.checkInfo.call().then((res) => {
            _this.balance = _this.web3.fromWei(new BigNumber(res[0]).toNumber());
            _this.runTimes = new BigNumber(res[1]).toNumber();
            _this.employeeCount = new BigNumber(res[2]).toNumber();
            return _this;
        }).then((result) => {
            let employeeCount = result.employeeCount;
            var employeesListArr = [];
            for (var i = 0; i < employeeCount; i++) {
                employeesListArr.push(_this.instance.checkEmployee.call(i));
            }
            return employeesListArr;
        }).then((res) => {
            Promise.all(res).then(values => {
                let employees = values.map(value => ({
                    address: value[0],
                    salary: _this.web3.fromWei(new BigNumber(value[1]).toNumber()),
                    lastPayDay: moment(new Date(new BigNumber(value[2]).toNumber()) * 1000).format('LLLL')
                }));
                _this.employeeData = employees;
            });
        });
    },

    /**
     * [changePaymentAddress] 更换员工地址
     *
     * @author 花夏 liubiao@itoxs.com
     * @param  {String} initialAds [原始地址]
     * @param  {String} address    [新地址]
     * @param  {Number} index      [下标]
     * @param  {Object} _this      [传入的对象]
     */
    changePaymentAddress(initialAds, address, index, _this) {
        let me = this;
        _this.instance.changePaymentAddress(initialAds, address, index, _.assign({
            from: _this.account
        }, _this.gas)).then((res) => {
            var updateInfo = _this.instance.UpdateInfo((err, result) => {
                if (!err) {
                    me.getEmployeeList(_this);
                }
                _this.updateLoading = false;
                updateInfo.stopWatching();
            });
        });
    },

    /**
     * [updateEmployeeSalary]  更新员工月薪
     *
     * @author 花夏 liubiao@itoxs.com
     * @param  {String} address    [员工地址]
     * @param  {Number} tempSalary [员工新的月薪]
     * @param  {Object} _this      [当前对象]
     */
    updateEmployeeSalary(address, tempSalary, _this) {
        let me = this;
        _this.instance.updateEmployeeMsg(address, +tempSalary, _.assign({
            from: _this.account
        }, _this.gas)).then((res) => {
            var updateInfo = _this.instance.UpdateInfo((err, result) => {
                if (!err) {
                    me.getEmployeeList(_this);
                }
                _this.updateSalLoading = false;
                updateInfo.stopWatching();
            });
        });
    },

    /**
     * [delEmployee]  删除一个员工
     *
     * @author 花夏 liubiao@itoxs.com
     * @param  {String} address [员工地址]
     * @param  {Object} _this   [当前对象]
     */
    delEmployee(address, _this) {
        let me = this;
        _this.delEmpLoading = true;
        _this.instance.removeEmployee(address, _.assign({
            from: _this.account
        }, _this.gas)).then((res) => {
            _this.delModal = false;
            var updateInfo = _this.instance.UpdateInfo((err, result) => {
                if (!err) {
                    me.getEmployeeList(_this);
                }
                _this.delEmpLoading = false;
                updateInfo.stopWatching();
            });
        });
    }
};

import {BigNumber} from 'bignumber.js';
// import moment from 'moment';
import _ from 'lodash';
export default {
    /**
     * [getInfo] 获取员工以及合约信息
     *
     * @author 花夏 liubiao@itoxs.com
     * @param  {Object} _this [调用的当前对象]
     */
    getInfo(_this) {
        let me = this;
        let web3 = _this.web3;
        var accountAddress = web3.eth.accounts[0];
        let employee = me.checkEmployee(accountAddress, _this);
        if (employee.length <= 0) {
            _this.$Message.error('不存在的员工账号!');
            return;
        }
        _this.employee.address = accountAddress;
        let salary = employee[0].salary;
        let lastPayDay = employee[0].lastPayDay;
        _this.employee.salary = salary;
        _this.employee.lastPayDay = lastPayDay;
        web3.eth.getBalance(accountAddress, function(error, balance) {
            _this.employee.balance = web3.fromWei(new BigNumber(balance).toNumber());
        });
        // _this.instance.checkEmployeeOfAds.call(accountAddress).then((res) => {
        //     console.log(res);
        //     let salary = web3.fromWei(new BigNumber(res[1]).toNumber());
        //     let lastPayDay = moment(new Date(new BigNumber(res[2]).toNumber()) * 1000).format('LLLL');
        //     _this.employee.salary = salary;
        //     _this.employee.lastPayDay = lastPayDay;
        // });
    },

    /**
     * [checkEmployee] 根据address判断是否是员工账号
     *
     * @author 花夏 liubiao@itoxs.com
     * @param  {String} address [以太地址]
     * @param  {Object} _this   [调用的对象]
     * @return {Object}         [存在的员工数组]
     */
    checkEmployee(address, _this) {
        let employeeData = _this.employeeData;
        var res = employeeData.filter(function(item, index, array) {
            item['i'] = index;
            return item.address === address;
        });
        return res;
    },

    /**
     * [getMyWages]  获取自己的薪资
     *
     * @author 花夏 liubiao@itoxs.com
     * @param  {Object} _this [调用的当前对象]
     */
    getMyWages(_this) {
        let me = this;
        let index = 0;
        let employee = _this.employeeData[index];
        if (!employee) {
            _this.$Message.error('不存在的员工账号!');
            return;
        }
        let address = _this.employeeData[index].address;
        _this.instance.getMyWage(_.assign({
            from: address
        }, _this.gas)).then((res) => {
            var getMyWage = _this.instance.GetMyWage((err, result) => {
                if (!err) {
                    _this.getWageLoading = false;
                    me.getInfo(_this);
                }
                getMyWage.stopWatching();
            });
        }).catch((err) => {
            if (!!err) {
                _this.$Message.error('合约没钱啦！！老板跑路啦~~还没有到领取工资的时间哦~~!');
                _this.getWageLoading = false;
                return;
            }
        });
    }
};

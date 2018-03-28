import {BigNumber} from 'bignumber.js';
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
        let PayrollInstance;
        Payroll.deployed().then((instance) => {
            PayrollInstance = instance;
            PayrollInstance.addFund(_.assign({
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

    addEmpolyee(address, salary, _this) {
        var me = this;
        let Payroll = me.self.Payroll;
        // let web3 = me.self.web3;
        let PayrollInstance;
        Payroll.deployed().then((instance) => {
            PayrollInstance = instance;
            PayrollInstance.addEmployee(address, salary, {
                from: me.self.account
            }).then(() => {
                setTimeout(() => {
                    self.location.reload();
                }, 1000);
            });
            return this;
        });
    }
};

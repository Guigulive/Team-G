import {BigNumber} from 'bignumber.js';
export default {
    getInfo(_this) {
        var me = this;
        window.addEventListener('load', function() {
            me.init(_this);
        });
        // todo 路由切换做单独判断
        // me.init(_this);
    },
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
            PayrollInstance.addFund.call({
                from: _this.account
            }).then((res) => {
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
    addFund(value) {
        var me = this;
        let Payroll = me.self.Payroll;
        let web3 = me.self.web3;
        let PayrollInstance;
        Payroll.deployed().then((instance) => {
            PayrollInstance = instance;
            PayrollInstance.addFund({
                from: me.self.account,
                value: web3.toWei(value)
            }).then(() => {
                setTimeout(() => {
                    self.location.reload();
                }, 1000);
            });
            return this;
        });
    }
};

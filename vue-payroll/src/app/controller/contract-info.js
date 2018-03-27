// import {BigNumber} from 'bignumber.js';
export default {
    getInfo(_this) {
        var me = this;
        window.addEventListener('load', function() {
            me.init(_this);
        });
    },
    init(_this) {
        let Payroll = _this.Payroll;
        let web3 = _this.web3;
        let PayrollInstance;
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
                    value: web3.toWei(res.c[0])
                });
            });
            return this;
        }).then((result) => {
            PayrollInstance.getPayTimes.call().then((res) => {
                _this.info.push({
                    name: '剩余最多支付次数 / 次',
                    value: res.c[0]
                });
            });
            return this;
        });
    }
};

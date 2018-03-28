import {BigNumber} from 'bignumber.js';
import moment from 'moment';
import _ from 'lodash';
export default {
    getInfo(_this) {
        this.self = _this;
        let web3 = _this.web3;
        let index = 0;
        let address = _this.employeeData[index].address;
        _this.employee.address = address;
        let balance = web3.eth.getBalance(address);
        _this.employee.balance = web3.fromWei(new BigNumber(balance).toNumber());
        let Payroll = _this.Payroll;
        // let PayrollInstance;
        _this.info = [];
        Payroll.deployed().then((instance) => {
            instance.checkEmployee.call(index).then((res) => {
                let salary = web3.fromWei(new BigNumber(res[1]).toNumber());
                let lastPayDay = moment(new Date(new BigNumber(res[2]).toNumber()) * 1000).format('LLLL');
                _this.employee.salary = salary;
                _this.employee.lastPayDay = lastPayDay;
            });
        });
    },
    getMyWages(_this) {
        this.self = _this;
        let Payroll = _this.Payroll;
        // let PayrollInstance;
        // let web3 = _this.web3;
        let index = 0;
        let address = _this.employeeData[index].address;
        console.log(address);
        Payroll.deployed().then((instance) => {
            instance.getMyWage(_.assign({
                from: address
            }, _this.GAS)).then((res) => {
                setTimeout(() => {
                    self.location.reload();
                }, 1000);
            });
        });
    }
};

import {BigNumber} from 'bignumber.js';
import moment from 'moment';
import _ from 'lodash';
export default {
    getInfo(_this) {
        let web3 = _this.web3;
        let index = 0;
        let address = _this.employeeData[index].address;
        _this.employee.address = address;
        let balance = web3.eth.getBalance(address);
        _this.employee.balance = web3.fromWei(new BigNumber(balance).toNumber());
        _this.instance.checkEmployee.call(index).then((res) => {
            let salary = web3.fromWei(new BigNumber(res[1]).toNumber());
            let lastPayDay = moment(new Date(new BigNumber(res[2]).toNumber()) * 1000).format('LLLL');
            _this.employee.salary = salary;
            _this.employee.lastPayDay = lastPayDay;
        });
    },
    getMyWages(_this) {
        let index = 0;
        let address = _this.employeeData[index].address;
        _this.instance.getMyWage(_.assign({
            from: address
        }, _this.gas)).then((res) => {
            setTimeout(() => {
                self.location.reload();
            }, 1000);
        });
    }
};

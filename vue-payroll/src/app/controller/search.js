import {BigNumber} from 'bignumber.js';
import moment from 'moment';
export default {
    searchOfAds(ads, _this) {
        var Payroll = _this.Payroll;
        var web3 = _this.web3;
        var PayrollInstance;
        Payroll.deployed().then((instance) => {
            PayrollInstance = instance;
            var employeeInfo = PayrollInstance.employees.call(ads);
            return employeeInfo;
        }).then((result) => {
            _this.loading = false;
            _this.disabled = false;
            let employeeAds = result[0];
            // 判段地址是否是 0x0000000000000000000000000000000000000000
            if (parseInt(employeeAds.slice(2), 10) === 0) {
                _this.result = 0;
                return;
            }
            // salary
            let salary = web3.fromWei(new BigNumber(result[1]).toNumber());
            // lastPayDay
            let lastPayDay = moment(new Date(new BigNumber(result[2]).toNumber())).format('LLLL');
            let employeeInfo = {
                employeeAds: {
                    name: '员工地址',
                    value: employeeAds
                },
                salary: {
                    name: '员工月薪',
                    value: salary
                },
                lastPayDay: {
                    name: '上次领取薪水时间',
                    value: lastPayDay
                }
            };
            _this.result = employeeInfo;
        });
    }
};

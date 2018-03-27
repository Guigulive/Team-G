/**
 * vue web3插件
 *
 * @type {object}
 */

 // 引入web3
import getWeb3 from '../lib/getWeb3';
import config from '@/common/config';
const GAS = config.GAS;
import PayrollContract from '../../../build/contracts/Payroll.json';
export default {
    install(Vue, options) {
        getWeb3.then(results => {
            const contract = require('truffle-contract');
            const Payroll = contract(PayrollContract);
            Vue.prototype.web3 = results.web3;
            Vue.prototype.Payroll = Payroll;
            Vue.prototype.GAS = GAS;
            Payroll.setProvider(results.web3.currentProvider);
        }).catch((res) => {
            console.log('Error finding web3.');
        });
    }
};

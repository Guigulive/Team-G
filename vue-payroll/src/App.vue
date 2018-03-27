<template>
    <div id="app">
        <xc-menu :activeName="activeName"></xc-menu>
        <router-view></router-view>
        <xc-footer></xc-footer>
    </div>
</template>

<script>
import getWeb3 from './common/lib/getWeb3';
import PayrollContract from '../build/contracts/Payroll.json';
import {BigNumber} from 'bignumber.js';
import _ from 'lodash';
import moment from 'moment';
let _GAS = {
    gas: 3000000
};
export default {
    name: 'app',
    data() {
        return {
            activeName: 'index'
        };
    },
    mounted() {
        var me = this;
        getWeb3.then(results => {
            me.web3 = results.web3;
            this.init();
        }).catch((res) => {
            console.log('Error finding web3.');
        });
    },
    methods: {
        init() {
            var me = this;
            const contract = require('truffle-contract');
            // const simpleStorage = contract(SimpleStorageContract)
            // simpleStorage.setProvider(me.web3.currentProvider)
            const Payroll = contract(PayrollContract);
            Payroll.setProvider(me.web3.currentProvider);

            // Declaring this for later so we can chain functions on SimpleStorage.
            var PayrollInstance;

            // Get accounts.
            me.web3.eth.getAccounts((info, accounts) => {
                Payroll.deployed().then((instance) => {
                    PayrollInstance = instance;

                    // Stores a given value, 5 by default.
                    return PayrollInstance.addEmployee('0xded5502072351838127a494d8fbb960e8f104894', 1, _.assign({from: accounts[0]}, _GAS));
                }).then((result) => {
                    var employeeInfo = PayrollInstance.employees.call('0xded5502072351838127a494d8fbb960e8f104894');
                    return employeeInfo;
                }).then((result) => {
                    let employeeAds = result[0];
                    // salary
                    let salary = new BigNumber(result[1] / 1e18).toNumber() + ' ETH';
                    // lastPayDay
                    let lastPayDay = moment(new Date(new BigNumber(result[2]).toNumber())).format('YYYY MMMM Do , h:mm:ss a');
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
                    console.log(employeeInfo);
                });
            });
        }
    }
};
</script>
<style src="src/assets/style/common.less" lang="less"></style>

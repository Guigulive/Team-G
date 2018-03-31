<template src="./index.tpl.html"></template>
<script>
import Employee from '@controller/contract-employee';
import contractInfo from '@controller/contract-info';
export default {
    name: 'employee',
    props: ['web3', 'instance', 'gas', 'account'],
    components: {},
    data() {
        return {
            info: [],
            employeeData: [],
            employee: {
                address: '',
                lastPayDay: '',
                salary: 0,
                balance: 0
            }
        };
    },
    watch: {
        employeeData: {
            handler: function(newVal, oldVal) {
                Employee.getInfo(this);
            },
            deep: true
        }
    },
    mounted() {
        this.init();
    },
    methods: {
        init() {
            contractInfo.init(this);
            contractInfo.getEmployeeList(this);
        },
        getMyWages() {
            Employee.getMyWages(this);
        }
    }
};
</script>
<style src="./index.less" lang="less"></style>

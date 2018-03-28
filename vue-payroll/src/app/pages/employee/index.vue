<template src="./index.tpl.html"></template>
<script>
import Employee from '@controller/contract-employee';
import contractInfo from '@controller/contract-info';
export default {
    name: 'employee',
    components: {},
    data() {
        return {
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
            var me = this;
            window.addEventListener('load', function() {
                contractInfo.getEmployeeList(me);
            });
        },
        getMyWages() {
            Employee.getMyWages(this);
        }
    }
};
</script>
<style src="./index.less" lang="less"></style>

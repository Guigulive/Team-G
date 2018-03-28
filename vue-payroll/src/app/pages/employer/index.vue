<template src="./index.tpl.html"></template>
<script>
import contractInfo from '@controller/contract-info';
import modalHtml from './Modal-html/';
export default {
    name: 'employer',
    components: {},
    data() {
        return {
            loading: false,
            leftMenuAcName: 'contractInfo',
            info: [],
            addAddress: '',
            addSalary: '',
            balance: 0,
            runTimes: 0,
            employeeCount: 0,
            columns1: [
                {
                    title: '员工地址',
                    key: 'address'
                },
                {
                    title: '月薪',
                    key: 'salary'
                },
                {
                    title: '上次领取时间',
                    key: 'lastPayDay'
                }
            ],
            employeeData: [
                {
                    name: 'John Brown',
                    salary: 18,
                    address: 'New York No. 1 Lake Park',
                    lastPayDay: '2016-10-03'
                },
                {
                    name: 'Jim Green',
                    salary: 24,
                    address: 'London No. 1 Lake Park',
                    lastPayDay: '2016-10-01'
                },
                {
                    name: 'Joe Black',
                    salary: 30,
                    address: 'Sydney No. 1 Lake Park',
                    lastPayDay: '2016-10-02'
                },
                {
                    name: 'Jon Snow',
                    salary: 26,
                    address: 'Ottawa No. 2 Lake Park',
                    lastPayDay: '2016-10-04'
                },
                {
                    name: 'John Brown',
                    salary: 18,
                    address: 'New York No. 1 Lake Park',
                    lastPayDay: '2016-10-03'
                },
                {
                    name: 'Jim Green',
                    salary: 24,
                    address: 'London No. 1 Lake Park',
                    lastPayDay: '2016-10-01'
                },
                {
                    name: 'Joe Black',
                    salary: 30,
                    address: 'Sydney No. 1 Lake Park',
                    lastPayDay: '2016-10-02'
                },
                {
                    name: 'Jon Snow',
                    salary: 26,
                    address: 'Ottawa No. 2 Lake Park',
                    lastPayDay: '2016-10-04'
                }
            ]
        };
    },
    watch: {
        leftMenuAcName(newVal, oldVal) {
            // if (newVal === 'contractInfo') {
            //     contractInfo.init(this);
            // }
        }
    },
    mounted() {
        this.init();
    },
    methods: {
        init() {
            contractInfo.getInfo(this);
        },
        addFund() {
            this.$Modal.confirm({
                render: (h) => {
                    return h(modalHtml, {
                        props: {
                            value: this.value,
                            autofocus: true,
                            placeholder: '请输入需要添加的金额'
                        },
                        on: {
                            countValue: (val) => {
                                this.value = val;
                            }
                        }
                    });
                },
                onOk: () => {
                    if (this.value <= 0) {
                        this.$Message.error('不能小于1吧?!');
                    }
                    contractInfo.addFund(this.value, this);
                }
            });
        },
        selectLeftMenu(name) {
            this.leftMenuAcName = name;
            switch (name) {
                case 'contractInfo':
                    contractInfo.init(this);
                    break;
                case 'employeeInfo':
                    this.getEmployeeList();
                    break;
                default:
                    contractInfo.init(this);
                    break;
            }
        },
        addEmpolyee() {
            if (!this.web3.isAddress(this.addAddress)) {
                this.$Message.error('请输入一个以太地址!');
                return;
            }
            if (this.addSalary <= 0) {
                this.$Message.error('月薪必须大于0!');
                return;
            }
            contractInfo.addEmpolyee(this.addAddress, 1, this);
        },
        getEmployeeList() {
            contractInfo.getEmployeeList(this);
        }
    }
};
</script>
<style src="./index.less" lang="less"></style>

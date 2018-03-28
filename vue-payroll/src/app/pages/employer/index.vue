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
            delModal: false,
            leftMenuAcName: 'contractInfo',
            info: [],
            addAddress: '',
            delAddress: '',
            tempAddress: '',
            tempSalary: 1,
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
                    title: '月薪 ETH',
                    key: 'salary',
                    width: 100
                },
                {
                    title: '上次领取时间',
                    key: 'lastPayDay'
                },
                {
                    title: '操作',
                    key: 'action',
                    width: 220,
                    render: (h, params) => {
                        return h('div', [
                            h('Button', {
                                props: {
                                    type: 'error',
                                    size: 'small'
                                },
                                style: {
                                    marginRight: '5px'
                                },
                                on: {
                                    click: () => {
                                        this.delEmployee(params);
                                    }
                                }
                            }, '删除'),
                            h('Button', {
                                props: {
                                    type: 'info',
                                    size: 'small'
                                },
                                style: {
                                    marginRight: '5px'
                                },
                                on: {
                                    click: () => {
                                        this.updateAddress(params);
                                    }
                                }
                            }, '更新地址'),
                            h('Button', {
                                props: {
                                    type: 'success',
                                    size: 'small'
                                },
                                on: {
                                    click: () => {
                                        this.updateEmployeeSalary(params);
                                    }
                                }
                            }, '更新月薪')
                        ]);
                    }
                }
            ],
            employeeData: []
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
        },
        updateAddress(params) {
            var me = this;
            this.$Modal.confirm({
                title: '请使用新地址替换当前地址',
                render: (h) => {
                    return h('Input', {
                        props: {
                            value: params.row.address,
                            autofocus: true,
                            placeholder: '请输入需要替换的地址'
                        },
                        on: {
                            input: (val) => {
                                this.tempAddress = val;
                            }
                        }
                    });
                },
                onOk: () => {
                    contractInfo.changePaymentAddress(params.row.address, this.tempAddress, params.index, me);
                    me.tempAddress = '';
                },
                onCancel: () => {
                    this.tempAddress = '';
                }
            });
        },
        updateEmployeeSalary(params) {
            var me = this;
            let address = params.row.address;
            this.$Modal.confirm({
                title: '请输入最新的月薪',
                render: (h) => {
                    return h('Input', {
                        props: {
                            value: +params.row.salary,
                            autofocus: true,
                            placeholder: '请输入最新的月薪'
                        },
                        on: {
                            input: (val) => {
                                this.tempSalary = val;
                            }
                        }
                    });
                },
                onOk: () => {
                    contractInfo.updateEmployeeSalary(address, this.tempSalary, me);
                    me.tempSalary = 1;
                },
                onCancel: () => {
                    this.tempSalary = 1;
                }
            });
        },
        delEmployee(params) {
            this.delModal = true;
            this.delAddress = params.row.address;
        },
        del() {
            contractInfo.delEmployee(this.delAddress, this);
            this.delAddress = '';
        }
    }
};
</script>
<style src="./index.less" lang="less"></style>

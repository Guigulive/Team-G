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
            info: []
        };
    },
    watch: {
        leftMenuAcName(newVal, oldVal) {
            if (newVal === 'contractInfo') {
                contractInfo.init(this);
            }
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
                    contractInfo.addFund(this.value);
                }
            });
        },
        selectLeftMenu(name) {
            this.leftMenuAcName = name;
        }
    }
};
</script>
<style src="./index.less" lang="less"></style>

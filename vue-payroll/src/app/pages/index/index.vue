<template src="./index.tpl.html"></template>
<script>
import search from '@controller/search';
export default {
    name: 'index',
    components: {},
    data() {
        return {
            loading: false,
            employeeAds: '',
            disabled: false,
            result: -1
        };
    },
    watch: {
        employeeAds(newVal, oldVal) {
            this.result = -1;
        }
    },
    mounted() {
        this.init();
    },
    methods: {
        init() {},
        search() {
            try {
                this.disabled = true;
                this.web3.fromWei(this.web3.eth.getBalance(this.employeeAds), 'ether');
                if (!this.employeeAds) {
                    this.$Message.error('请输入一个以太地址!');
                    return;
                }
                this.loading = true;
                search.searchOfAds(this.employeeAds, this);
            } catch (e) {
                this.$Message.error('请输入一个以太地址!');
                this.loading = false;
                this.disabled = false;
            }
        }
    }
};
</script>
<style src="./index.less" lang="less"></style>

<template src="./index.tpl.html"></template>
<script>
import search from '@controller/search';
export default {
    name: 'index',
    props: ['web3', 'instance'],
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
            if (!this.web3.isAddress(this.employeeAds)) {
                this.$Message.error('请输入一个以太地址!');
                this.loading = false;
                this.disabled = false;
                return;
            }
            if (!this.employeeAds) {
                this.$Message.error('请输入一个以太地址!');
                return;
            }
            this.loading = true;
            this.disabled = true;
            search.searchOfAds(this.employeeAds, this);
        }
    }
};
</script>
<style src="./index.less" lang="less"></style>

<template src="./index.tpl.html"></template>
<script>
import contractInfo from '@controller/contract-info';
export default {
    name: 'employer',
    components: {},
    data() {
        return {
            loading: false,
            info: []
        };
    },
    watch: {},
    mounted() {
        this.init();
    },
    methods: {
        init() {
            contractInfo.getInfo(this);
        }
    }
};
</script>
<style src="./index.less" lang="less"></style>

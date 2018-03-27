<template src="./index.tpl.html"></template>
<script>
export default {
    name: 'employer',
    components: {},
    data() {
        return {
            loading: false,
            employeeAds: '',
            disabled: false,
            result: -1
        };
    },
    watch: {},
    mounted() {
        this.init();
    },
    methods: {
        init() {}
    }
};
</script>
<style src="./index.less" lang="less"></style>

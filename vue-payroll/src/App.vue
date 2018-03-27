<template>
    <div id="app">
        <xc-menu :activeName="activeName"></xc-menu>
        <router-view></router-view>
        <xc-footer></xc-footer>
    </div>
</template>

<script>
export default {
    name: 'app',
    data() {
        return {
            activeName: 'index'
        };
    },
    mounted() {},
    methods: {
        init() {}
    }
};
</script>
<style src="src/assets/style/common.less" lang="less"></style>

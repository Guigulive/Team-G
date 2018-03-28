<template>
    <div id="app">
        <xc-menu :activeName="activeName"></xc-menu>
        <router-view :key="key"></router-view>
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
    watch: {
        '$route'(to, from) {
            // todo 这里简单对路由变化做处理，不应该这样做的
            self.location.reload();
        }
    },
    computed: {
        key() {
            return this.$route.name !== 'undefined' ? this.$route.name + new Date() : this.$route + new Date();
        }
    },
    mounted() {
        this.init();
    },
    methods: {
        init() {
            var activeName = this.$route.name;
            this.activeName = activeName;
        }
    }
};
</script>
<style src="src/assets/style/common.less" lang="less"></style>

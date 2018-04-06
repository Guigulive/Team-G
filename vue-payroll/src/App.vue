<template>
    <div id="app">
        <xc-menu :activeName="activeName"></xc-menu>
        <router-view
            :key="key"
            :web3="web3"
            :instance="instance"
            :gas="gas"
            :account="account"></router-view>
        <xc-footer></xc-footer>
        <loading :spin-show="globalSpinShow"></loading>
    </div>
</template>

<script>
import loading from '@components/loading/';
export default {
    name: 'app',
    data() {
        let Web3 = window.web3;
        return {
            activeName: 'index',
            globalSpinShow: true,
            web3: Web3,
            instance: window.instance,
            gas: window.gas,
            account: window.account
        };
    },
    components: {
        loading
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
            this.$Message.config({
                top: 55,
                duration: 3
            });
            var activeName = this.$route.name;
            this.activeName = activeName;
            this.globalSpinShow = false;
        }
    }
};
</script>
<style src="src/assets/style/common.less" lang="less"></style>

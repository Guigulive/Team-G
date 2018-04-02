<template src="./index.tpl.html"></template>
<script>
import uri from 'src/common/lib/uri';
export default {
    name: 'top-menu',
    props: [
        'activeName'
    ],
    data() {
        this.activeName = 'index';
        return {
            theme: 'light',
            newActiveName: this.activeName
        };
    },
    watch: {
        activeName(newVal, oldVal) {
            this.newActiveName = newVal;
        }
    },
    mounted() {
        this.init();
    },
    methods: {
        init() {},
        route(name) {
            this.$router.push(
                {
                    name: name
                }
            );
        },
        gotoCommunity(e) {
            var currentTarget = e.currentTarget;
            var name = currentTarget.name;
            var url = uri[name];
            self.open(url, '_blank');
        }
    }
};
</script>
<style src="./index.less" lang="less" scoped></style>

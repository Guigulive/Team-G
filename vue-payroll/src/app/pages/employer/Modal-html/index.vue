<template>
    <div>
        <h3 class="title">请拖动选择您要增加的金额</h3>
        <p><Tag type="border">{{value}}</Tag> ETH</p>
        <Slider
            v-model="value"
            :step="1"
            show-stops
            @on-change="valueChange"></Slider>
    </div>
</template>
<script>
export default {
    name: 'modalHtml',
    data() {
        return {
            value: 1
        };
    },
    watch: {},
    mounted() {
        this.init();
    },
    methods: {
        init() {},
        valueChange() {
            var val = this.value;
            if (isNaN(+this.value)) {
                val = 1;
            }
            this.$emit('countValue', val);
        }
    }
};
</script>
<style lang="less">
    .title {
        margin-bottom: 12px;
    }
</style>

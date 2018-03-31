<template>
    <Spin fix class="loading" v-if="spinShow">
          <Icon type="load-c" :size="size" class="spin-icon-load"></Icon>
          <div>{{loadingText || '加载中'}}</div>
    </Spin>
</template>

<script>
export default {
    props: [
        'loadingText',
        'size',
        'spinShow'
    ]
};
</script>

<style lang="less" scoped>
.loading {
    z-index: 9999;
    .spin-icon-load{
        animation: ani-demo-spin 1s linear infinite;
    }
    @keyframes ani-demo-spin {
        from { transform: rotate(0deg);}
        50%  { transform: rotate(180deg);}
        to   { transform: rotate(360deg);}
    }
}
</style>

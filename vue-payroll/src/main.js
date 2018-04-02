// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue';
import App from './App';
import router from './router';
import iView from 'iview';
import moment from 'moment';

import 'iview/dist/styles/iview.css';
import web3ContractUtil from '@/common/vue-util/web3-contract';

import TopMenu from '@components/top-menu/';
import XCFooter from '@components/footer/';
Vue.use(web3ContractUtil);
moment.locale('zh-cn');
Vue.config.productionTip = false;
Vue.use(iView);
Vue.component('xc-footer', XCFooter);
Vue.component('xc-menu', TopMenu);
Vue.config.productionTip = false;
/* eslint-disable no-new */
new Vue({
    el: '#app',
    router,
    template: '<App/>',
    components: {
        App
    }
});

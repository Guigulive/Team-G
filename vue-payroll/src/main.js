// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue';
import App from './App';
import router from './router';
import iView from 'iview';
import 'iview/dist/styles/iview.css';
import TopMenu from '@components/top-menu/';
import XCFooter from '@components/footer/';

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

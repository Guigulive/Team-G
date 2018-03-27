/**
 * @file:      路由配置
 * @author:    花夏(liubiao@itoxs.com)
 * @version:   V0.0.1
 * @date:      2017-03-21 19:34:17
 */

import Index from '@pages/index/';
import Employer from '@pages/employer/';
export default [
    {
        path: '/',
        name: 'index',
        component: Index
    },
    {
        path: '/employer',
        name: 'employer',
        component: Employer
    }
];

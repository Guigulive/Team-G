### vue-contract

```bash
npm install
npm run dev
```

    vue-contract
    ├── .gitignore  // 忽略git提交文件
    ├── README.md  // 项目说明
    ├── .babelrc  // babel编译配置
    ├── .editorconfig // 编辑器规范配置
    ├── .eslintignore // eslint代码检查忽略文件配置
    ├── .eslintrc.js  // eslint代码检查配置
    ├── .postcssrc.js // postcss 配置，目前使用sass此项无用
    ├── package.json // 项目依赖配置
    ├── truffle.js // truffle本地开发文件
    ├── truffle-config.js // truffle本地开发配置文件(暂时没用到)
    ├── index.html  // 项目视图入口文件
    ├── LICENSE    // 许可证 MIT
    ├── dist      // `npm run build` 后生成的打包目录
    ├── vue-build    // 运行项目等配置
    ├── build    // contract build目录
    ├── contracts    // contract 开发
    ├── migrations    // migrations 部署文件目录
    ├── config  // 通用配置等
    ├── src
    ├── ├── app // 项目相关源码开发目录
    ├── |   ├── components // 公用组件
    ├── |   ├── pages // 具体页面目录
    ├── ├── assets // 静态公用资源
    └── ├── common
        |   ├── ...
        ├── router // 路由配置
        ├── app.vue // 视图入口
        ├── main.js // webpack入口
        └── mock
            ├──GET // 本地mock get
            └──POST // 本地mock post

### 支持功能

    1.本地mock： 更改config/index.js : mockLocal: 1, // 1為本地 \ 0為代理 remote中可配置代理地址
    2.自动获取本地局域方地址（192.*.*.*）方便局域网查看
    3.自动获取端口号(默认8888)，不再为端口号占用烦恼，提高效率
    4.运行 `npm run dev`后自动代开浏览器，不必手动打开，提高效率 更改config/index.js : browser: 'google chrome', // 可配置 firefox \ google chrome \ Safari
    5.支持eslint 本地开发必须符合[代码规范](https://github.com/huarxia/spec),也可以单独运行`npm run lint`

### 感谢这些开源项目

1. [Vue.js](http://vuejs.org/)
2. [webpack](https://webpack.github.io/)


### License

MIT © [花夏](http://www.huar.love)

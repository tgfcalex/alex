let nocasApiPath = process.env.nacos_api_path;
let nacosTenant = process.env.nacos_tenant;
let nacosDataId = process.env.nacos_dataId;
let nacosGroup = process.env.nacos_group;
console.log(nocasApiPath);
console.log(nacosTenant);
console.log(nacosDataId);
console.log(nacosGroup);

let configUrl = `${nocasApiPath}?tenant=${nacosTenant}&dataId=${nacosDataId}&group=${nacosGroup}`;

var Koa = require("koa");
var proxy = require("koa-proxies");
var route = require("koa-route");
var koaStatic = require("koa-static");
const https = require("https");
const http = require("http");
const fs = require("fs");
const path = require("path");
const { historyApiFallback } = require("koa2-connect-history-api-fallback");
const logsUtil = require("./logs.utils.js"); // 记录日志

var app = new Koa();
let cors = require("koa-cors");
app.use(historyApiFallback({ whiteList: ["/api", "/nacosConfig"] }));
// 设置代理
var appFetch;
if (configUrl.indexOf("https") !== -1) {
  // https
  appFetch = https;
} else {
  // https
  appFetch = http;
}
appFetch.get(configUrl, function(res) {
  var str = "";
  res.on("data", function(chunk) {
    str += chunk;
  });
  res.on("end", function() {
    let config = JSON.parse(str);
    // 跨域设置// koa2-cors
    // app.use(async (ctx, next) => {
    //   ctx.set('Access-Control-Allow-Origin', '*')
    //   await next()
    // })
    // app.use(async (ctx, next) => {
    //   // text/plain; charset=utf-8 //application/json, text/plain, */*
    //   ctx.set('Content-Type', 'application/json')
    //   ctx.set('Access-Control-Allow-Origin', '*')
    //   ctx.set('Access-Control-Allow-Headers', 'Content-Type, Content-Length, Authorization, Accept, X-Requested-With , yourHeaderFeild')
    //   ctx.set('Access-Control-Allow-Methods', 'PUT, POST, GET, DELETE, OPTIONS')
    //   if (ctx.method == 'OPTIONS') {
    //     ctx.body = 200
    //   } else {
    //     await next()
    //   }
    // })
    app.use(
      route.get("/nacosConfig", async function(ctx) {
        let loginUrl = config["config"].loginUrl;
        await cors();
        ctx.type = "application/json";
        ctx.body = { loginUrl };
      })
    );
    // now using proxies
    app.use(
      proxy("/api", {
        // api
        target: config["api"].url,
        changeOrigin: true,
        logs: false
      })
    );
  });
});

const logsHandle = require("./logs.utils").logHandle; // 记录操作
const logInfo = require("./logs.utils").logInfo; // 记录信息
// 首页
const main = async function(ctx, next) {
  ctx.response.type = "html";
  ctx.response.body = await fs.createReadStream(
    `${process.cwd()}/dist/index.html`
  ); // 读取index.html
  logsHandle("孫子，你來了");
  logInfo("孫子，你來了");
};
// 静态资源
const staticfile = koaStatic(path.join(__dirname));

app.use(route.get("/", main));
app.use(staticfile);
// 记录日志
app.use(async (ctx, next) => {
  const start = new Date(); // 响应开始时间
  let intervals; // 响应间隔时间
  try {
    await next();
    intervals = new Date() - start;
    logsUtil.logResponse(ctx, intervals); // 记录响应日志
  } catch (error) {
    intervals = new Date() - start;
    logsUtil.logError(ctx, error, intervals); // 记录异常日志
  }
});

app.listen(3000); // 监听3000端口
console.log("服務已經啟動"); // log

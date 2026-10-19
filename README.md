# Anhuann · 个人网站

一个**零依赖**的个人网站：前台四个板块（首页 / 关于 / 博客 / 联系），支持深浅色主题、移动端适配、LaTeX 公式。
自带一个 **Node 服务器**（`server.js`，只用 Node 内置模块，无需 `npm install`），提供：

- **动态内容** —— 前台实时从 `/api/content` 读取，后台一保存、刷新前台即生效
- **可视化后台** —— 登录后在线编辑站点、关于、社交、文章，另有「工具箱」
- **真实登录校验** —— 账号密码在服务器端验证，登录态存 HttpOnly Cookie

---

## 目录结构

```
.
├── 启动网站.bat            # ★ Windows 一键启动（双击即可，自动打开浏览器）
├── index.html              # 前台页面结构（一般不用改）
├── admin.html              # 后台管理入口
├── server.js               # Node 服务器：静态服务 + 登录 + 内容读写 API
├── assets/
│   ├── css/
│   │   ├── style.css       # 前台样式（改配色、圆角、字号来这里）
│   │   └── admin.css       # 后台样式
│   ├── img/avatar.jpg      # 头像
│   ├── vendor/katex/       # 本地 KaTeX 库（公式渲染，离线可用）
│   └── js/
│       ├── data.js         # ★ 所有内容都在这里，日常只改这个文件
│       ├── main.js         # 前台交互逻辑（一般不用改）
│       └── admin.js        # 后台逻辑（一般不用改）
└── README.md
```

---

## 快速开始

### 方式一：一键启动（推荐，Windows）

双击 **`启动网站.bat`**，或在 PowerShell 里执行：

```powershell
.\启动网站.bat        # 可选端口：.\启动网站.bat 9000
```

它会检测 Node.js → 启动服务器 → 自动打开浏览器。
启动后：前台 `http://localhost:8080/`，后台 `http://localhost:8080/admin.html`。

> 没装 Node.js？到 https://nodejs.org/ 下载 LTS 版安装即可。

### 方式二：命令行启动

```bash
node server.js
# 可选：自定义端口与后台账号
# PORT=9000 ADMIN_USER=yourname ADMIN_PASS=yourpass node server.js
```

### 方式三：只预览前台（无后台）

```bash
python -m http.server 8000     # 或 npx serve .
```

### 三种方式对比

| | 一键启动 / node server.js | python / npx serve | 双击 index.html |
|---|---|---|---|
| 前台展示 | ✅ 读 API（动态） | ✅ 回退 data.js | ✅ 回退 data.js |
| 后台登录 / 保存 | ✅ | ❌ 无此接口 | ❌ |
| 保存后前台即时生效 | ✅ | ❌ | ❌ |
| 需要 Node.js | ✅ | ❌ | ❌ |

---

## 如何改内容

日常只改 `assets/js/data.js` 一个文件，保存后刷新浏览器即可生效。它分成 4 块：

| 区块 | 说明 |
| --- | --- |
| `SITE` | 名字、头像、首屏问候/标语、简介、邮箱、页脚备注 |
| `ABOUT` | 引入语 + 主题故事卡（健康 / 学习 / 沟通 / 短剧 / 自我认同），默认折叠，点标题展开 |
| `POSTS` | 博客文章：标题、日期、标签、摘要、正文 |
| `SOCIALS` | 社交账号与联系方式 |

### 新增一篇博客文章

在 `POSTS` 数组里加一项：

```js
{
  title: "文章标题",
  date: "2026-10-17",              // 建议 YYYY-MM-DD
  tags: ["随笔"],
  excerpt: "列表页显示的一两句摘要。",
  body: [
    "第一段正文。",
    "<h3>小标题</h3>",
    "第二段正文，支持 <strong>加粗</strong>、<code>代码</code>。",
    "<blockquote>这是一句引用。</blockquote>",
    "<ul><li>列表项一</li><li>列表项二</li></ul>"
  ]
}
```

正文支持 LaTeX 公式：行内用 `` `$E=mc^2$` ``，单独成块用 `$$...$$`（由本地 KaTeX 渲染，离线也能用）。
注意：`$` 会被当作公式起始符，要显示美元金额请写成 `\$5`。

### 新增一个社交账号

在 `SOCIALS` 数组里加一项：

```js
{
  name: "微博",
  handle: "@anhuann",
  url: "https://weibo.com/",   // 没有链接就留空字符串 ""（变成点击复制）
  icon: "globe",               // 可选：github / mail / x / wechat / bilibili / zhihu / douyin / globe / rss
  copy: false,                 // true = 点击复制 handle（适合微信号）
  color: ["#E9A08C", "#D4785F"]
}
```

`icon` 想要自定义，可以在 `assets/js/main.js` 顶部的 `ICONS` 里加一个 SVG 路径。

> `data.js` 里每个字段都写了详细注释和示例，照着改一般不会出错。
> 改完可用 `node --check assets/js/data.js` 自检语法。

---

## 后台管理（可视化编辑）

先启动服务器（见上方「快速开始」），然后打开 `http://localhost:8080/admin.html`。

1. 登录：账号 `AnHuann`，密码见本地 `.env`（仓库里只有 `.env.example` 模板；复制为 `.env` 填你的密码即可：`copy .env.example .env`）。也可用环境变量 `ADMIN_USER` / `ADMIN_PASS` 覆盖；勾选「记住我」可延长登录有效期，之后打开后台自动登录
2. 五个标签页直接改文字、增删条目：
   - **站点信息** —— 名字、头像、首屏文案、邮箱、页脚
   - **关于我** —— 引入语 + 主题故事卡
   - **社交账号** —— 名称、账号、链接、图标、徽章颜色
   - **博客文章** —— 标题、日期、标签、摘要、正文
   - **工具箱** —— 一组纯前端小工具（见下）
3. 点「保存」即写入服务器上的 `data.js`，刷新前台立即生效
4. 也可点「导出 data.js」下载文件做备份

### 工具箱

后台内置 5 个纯前端小工具，打开就能用：Markdown 实时预览、JSON 格式化/校验、Base64 编解码（支持中文）、字数统计、时间戳转换。

> 安全说明：账号密码由服务器校验，登录态保存在 HttpOnly Cookie 中，比纯前端门禁安全；
> 但仍建议不要把后台直接暴露到公网（可加反向代理鉴权或限制 IP）。

### 配置后台密码（重要）

后台密码**不写在源码里**（避免提交到 GitHub 后泄露），改走本地 `.env`：

```bash
copy .env.example .env      # 第一次需要从模板复制
# 然后编辑 .env，把 ADMIN_PASS 改成你自己的密码
```

`.env` 已被 `.gitignore` 忽略，不会进版本库；`.env.example` 只是空模板，可提交。
也支持用环境变量临时覆盖：`$env:ADMIN_PASS="你的密码"`（PowerShell）/ `ADMIN_PASS=xxx node server.js`（Linux/Mac）。

---

## 如何改配色

打开 `assets/css/style.css`，最上面的 `:root` 是浅色主题，`[data-theme="dark"]` 是深色主题：

```css
:root {
  --accent: #e08d79;     /* 主色：按钮、强调文字 */
  --accent-2: #7fb3c9;   /* 辅助色：渐变另一端 */
  --bg: #fbfdff;         /* 页面底色 */
  --bg-soft: #eef4fb;    /* 浅色区块底色 */
  --text: #37424f;       /* 正文颜色 */
  --radius: 20px;        /* 卡片圆角 */
}
```

改这几个值，整站风格就会跟着变。

---

## 部署上线

- **GitHub Pages / Vercel / Netlify**：把仓库或文件夹直接放上去即可，前台完全正常
  （此时没有服务器，前台自动回退到 `data.js` 里的静态内容，**后台不可用**）
- **自己的服务器**：把整个文件夹传到网站目录，然后
  ```bash
  node server.js        # 前台 + 后台都可用
  ```
  生产环境建议配 `ADMIN_USER` / `ADMIN_PASS`，并用 pm2 / systemd 常驻，前面再套 Nginx 反代和 HTTPS。

部署前记得把 `data.js` 里的邮箱、社交链接换成你自己的。

---

## 说明

- 无需 `npm install`，没有构建步骤（KaTeX 已本地化到 `assets/vendor/`）
- 文章写在 JS 里，适合更新频率不高、篇数不多的个人博客
- 如果以后文章变多，建议把 `POSTS` 拆成 Markdown 文件，再用静态站点生成器（如 Astro、Eleventy）接管
- 代码里所有文件都写了详细注释，改之前先读注释能少踩坑

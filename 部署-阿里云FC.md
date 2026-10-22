# 部署到阿里云函数计算 FC（带可视化后台）

本仓库已为 FC 做好准备：`server.js` 会读取 `FC_SERVER_PORT` 端口、支持把内容写到可挂载的
`DATA_DIR` 目录；根目录有 `bootstrap` 启动脚本与 `package.json`。

> 前置：一个阿里云账号，并开通「函数计算 FC」。想让后台改的内容**不丢失**，建议同时开通
> 「文件存储 NAS」（见文末「持久化」）。

---

## 方式一：Serverless Devs（推荐，最省心）

仓库里已经准备好了 `s.yaml`（区域已设为 `cn-beijing`）、`bootstrap`、`package.json` 和 `.signore`。

1. 准备阿里云访问凭证（AccessKey）：
   - 登录阿里云控制台 → **访问控制 RAM** → 创建用户并赋予「函数计算」相关权限（如 `AliyunFCFullAccess`；若用 NAS 再加 `AliyunNASFullAccess`）
   - 为该用户创建 **AccessKey（ID + Secret）**
2. 本地安装 `s` 工具（需要 Node ≥ 16）：
   ```bash
   npm install -g @serverless-devs/s
   s config add        # 选 Alibaba Cloud，填上面的 AccessKey ID / Secret，访问别名用 default
   ```
3. 编辑 `s.yaml`，把 `ADMIN_PASS` 改成你的强密码（**只在本机文件里改，不要提交到仓库**）。
4. 在仓库根目录部署：
   ```bash
   s deploy
   ```
   > 注意：`.signore` 已配置，**本地 `.env`（含密码）与 `backups/` 不会被上传**。
5. 部署完成后会得到一个 `*.fc.aliyuncs.com` 的临时域名（阿里云已备案，**免备案**即可访问）。
   手机浏览器打开 `https://<你的域名>/admin.html` 即可登录后台。

> 想连 GitHub 自动部署：在 FC 控制台「函数」→「代码」里选择「代码仓库」并授权 GitHub，
> 选 `grainshun/Anhuann_personal_website` 的 `main` 分支，之后 push 会自动触发部署。

---

## 方式二：FC 控制台（不用装命令行）

1. 函数计算控制台 → 新建「服务」→ 新建「函数」，运行环境选 **Custom Runtime（自定义运行时）**。
2. 代码来源选「代码仓库」并授权 GitHub，选 `grainshun/Anhuann_personal_website` / `main` 分支
   （或本地打 zip 上传：把仓库根目录打成 zip 即可，包含 `server.js`、`bootstrap`、`assets/` 等）。
3. 监听端口填 `9000`（FC 会注入 `FC_SERVER_PORT=9000`，`server.js` 已兼容）。
4. 配置环境变量：`ADMIN_USER=AnHuann`、`ADMIN_PASS=你的强密码`
   （**切勿把密码写进仓库**，密码只通过环境变量传入；`.env` 已被 git 忽略，不会上传）。
5. 创建「HTTP 触发器」，认证选「匿名」，得到临时域名。

---

## 持久化（重要）

FC 的磁盘是**临时**的：实例回收/冷启动后，你用后台改的内容会被重置回部署时的版本。两条路解决：

- **挂载 NAS（推荐）**：在「文件存储 NAS」创建文件系统 → 在 FC 函数里「存储配置」挂载到 `/mnt/auto`
  → 把上面 `s.yaml` 里的 `DATA_DIR` 设为 `/mnt/auto`。这样 `data.js` 和备份都落在 NAS 上，永久保留。
- **最低成本**：不挂 NAS，只是编辑可能在实例长时间空闲后被重置；可把 FC「最小实例数」设为 1 减少回收。

---

## 上线后

1. 打开 `https://<你的域名>/admin.html`，用环境变量里的账号密码登录。
2. 在「界面文案 / 博客文章 / 关于我」里编辑内容，`Ctrl/Cmd+S` 保存即可，手机上同样可用。
3. 想用自己域名：在 FC「自定义域名」里绑定（**用自己的域名需先完成 ICP 备案**；用 FC 自带的 `*.fc.aliyuncs.com` 临时域名则免备案）。

# DeepSeek Harness · 个人分支

本仓库是 [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness)
的个人分支，在保留上游全部功能的基础上，增加了 Windows 一键启动脚本，并对
GitHub Actions 的 CI 缓存策略做了优化以提升缓存命中率。

- 上游项目：<https://github.com/deepseek-ai/deepseek-harness>
- 版本基线：`v0.1.0-rc.5`（commit `47f943859b`）

## 与上游的差异

### 1. Windows 一键启动脚本 `start-dsh.bat`

双击即可自动完成「环境检查 → 安装依赖 → 构建 → 启动 Web UI → 打开浏览器」，
等价于手动执行：

```bat
pnpm install
pnpm run build
pnpm dsh web
```

启动后访问 <http://127.0.0.1:3080>。

### 2. CI 缓存优化（提升缓存命中率）

针对 pnpm 缓存命中率偏低的问题做了如下改进，详见
`.github/workflows/ci.yml` 与 `.github/dependabot.yml`：

- **恢复缓存生产者**：新增 `cache-seed` 作业，每次 master push 重新播种
  pnpm store 与 Playwright 缓存。此前生产者 `serial-linux` 被禁用，导致
  PR 作业只能命中过期的前缀缓存。
- **统一缓存命名空间**：所有 pnpm store 缓存 key 统一为
  `${{ runner.os }}-pnpm-<lockfile-hash>`，去掉 Node 版本段，让
  Node 22/24/26 及全部 Linux 作业共享同一份缓存。
- **前缀回退**：把 `setup-node` 的 `cache: pnpm`（仅精确 key、无回退）
  改为带 `restore-keys` 的手写 `actions/cache`，锁文件变化时从「全冷重装」
  降级为「增量补拉」。
- **收敛锁文件抖动**：Dependabot 的 patch/minor 更新合并进单个 PR，
  降低 `pnpm-lock.yaml` 的变化频率。

## 快速开始

要求：Node.js `^22.19.0 || >=24.0.0`，pnpm `11.7.0`（`corepack enable`）。

```sh
pnpm install
pnpm run build
pnpm dsh web
```

启动后访问 <http://127.0.0.1:3080>。Windows 下也可直接双击根目录的
`start-dsh.bat`。

## 同步上游

```sh
git fetch origin
git merge origin/master
```

## 目录结构

与上游一致，详见上游 `README.md` / `README.zh.md` 与 `docs/`。

# 把 WeLine 打包成 Windows EXE 安装包

本项目是 Electron 桌面应用，打包后会生成 NSIS 安装程序 `WeLine-4.3.0-Setup.exe`。

> ⚠️ 为什么不在当前环境直接打包？
> 当前沙箱**没有 C++ 编译器（MSVC）**，且**访问 GitHub 不通**。WeLine 的原生模块（sharp / koffi / sherpa-onnx-node）必须编译成对应 Electron 的版本，Electron 二进制也默认从 GitHub 下载——两者在此环境都不可行。因此请在**你自己的 Windows 开发机**上完成打包。本项目已附 `build-exe.bat` 一键脚本（已配国内镜像）。

---

## 方法一：一键脚本（推荐）

1. 把整个 `WeLine` 目录拷到一台 **Windows** 电脑上。
2. 先装好前置依赖（见下方“前置环境”）。
3. **右键 `build-exe.bat` → 以管理员身份运行**（管理员可避免 NSIS 写入权限问题）。
4. 等待：先 `npm install`（下载 Electron + 编译原生模块，约几分钟），再 `npm run build`。
5. 完成后安装包在：
   ```
   WeLine\release\WeLine-4.3.0-Setup.exe
   ```

## 方法二：手动命令

```bash
# 1) 进入项目
cd WeLine

# 2) 设置国内镜像（关键：否则 Electron / NSIS 从 GitHub 下载会失败）
set ELECTRON_MIRROR=https://registry.npmmirror.com/-/binary/electron/
set ELECTRON_BUILDER_BINARIES_MIRROR=https://registry.npmmirror.com/-/binary/electron-builder-binaries/
npm config set registry https://registry.npmmirror.com

# 3) 安装依赖（会下载 Electron 并编译原生模块）
npm install

# 4) 打包（tsc 编译 → vite 构建 → electron-builder 生成 exe 安装包）
npm run build
```

---

## 前置环境（本机 Windows 必须装）

| 工具 | 说明 | 验证命令 |
|---|---|---|
| Node.js 20+ | 建议 LTS 版本 | `node -v` |
| Git | 拉代码/部分依赖需要 | `git --version` |
| Python 3.x | node-gyp 编译原生模块需要 | `python --version` |
| Visual Studio Build Tools | 勾选 **“使用 C++ 的桌面开发”**（含 MSVC v143 + Windows SDK） | 安装后在“开始”里能看到 *Developer Command Prompt* |

> 若 `npm install` 报 `node-gyp` / `MSBUILD` 相关错误，99% 是没装 Visual Studio C++ 生成工具，补齐后重跑即可。

---

## 产物说明

- 默认目标：`nsis`（Windows 安装向导），一次安装、可创建桌面快捷方式、支持中文/英文。
- 输出目录：项目根下 `release/`。
- 其他平台目标（在 `package.json` 的 `build` 字段里配置）：macOS `dmg/zip`、Linux `AppImage/tar.gz`，需在对应系统上打包。

## 常见问题

- **卡在下载 Electron / NSIS**：确认 `ELECTRON_MIRROR` 等镜像变量已设置，且能访问 `registry.npmmirror.com`。
- **原生模块编译失败**：确认装了 VS C++ 生成工具 + Python，然后 `npm run rebuild` 重新编译，再 `npm run build`。
- **只想本地跑起来看界面**（不打包）：`npm install` 后执行 `npm run electron:dev`。

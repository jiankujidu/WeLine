@echo off
chcp 65001 >nul
title WeLine 打包成 Windows EXE
echo ============================================================
echo   WeLine 一键打包 Windows EXE 安装包
echo   前置条件（本机 Windows）：
echo     1. Node.js 20+  (建议 LTS)
echo     2. Git
echo     3. Python 3.x   (node-gyp 编译原生模块需要)
echo     4. Visual Studio Build Tools，勾选“使用 C++ 的桌面开发”
echo        (或单独安装 “MSVC v143 + Windows 10/11 SDK”)
echo ============================================================
setlocal

REM 国内镜像：避免从 GitHub 下载 Electron / NSIS / 原生模块二进制失败
set ELECTRON_MIRROR=https://registry.npmmirror.com/-/binary/electron/
set ELECTRON_BUILDER_BINARIES_MIRROR=https://registry.npmmirror.com/-/binary/electron-builder-binaries/
set npm_config_registry=https://registry.npmmirror.com

cd /d %~dp0

echo.
echo [1/2] 安装依赖（会下载 Electron 并编译原生模块，请耐心等待数分钟）...
call npm install
if errorlevel 1 (
  echo.
  echo [错误] 依赖安装失败。请确认已安装 Python 与 Visual Studio C++ 生成工具。
  pause
  exit /b 1
)

echo.
echo [2/2] 开始打包（产物：release\WeLine-4.3.0-Setup.exe）...
call npm run build
if errorlevel 1 (
  echo.
  echo [错误] 打包失败，请查看上方报错信息。
  pause
  exit /b 1
)

echo.
echo ============================================================
echo  成功！安装包位于：
echo  %~dp0release\WeLine-4.3.0-Setup.exe
echo ============================================================
pause

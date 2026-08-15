@echo off
setlocal
cd /d "%~dp0"
title DeepSeek Harness - dsh web

echo ============================================
echo   DeepSeek Harness 一键启动 (Web UI)
echo ============================================

rem ---- 1. 检查运行环境 ----
echo [1/4] 检查环境...
where node >nul 2>nul
if errorlevel 1 (
    echo [错误] 未找到 Node.js，请先安装：https://nodejs.org/
    pause
    exit /b 1
)
where pnpm >nul 2>nul
if errorlevel 1 (
    echo [错误] 未找到 pnpm，请先执行：corepack enable
    pause
    exit /b 1
)

rem ---- 2. 检查依赖 ----
echo [2/4] 检查依赖...
if not exist "node_modules\" (
    echo 首次运行，正在安装依赖（可能需要几分钟）...
    call pnpm install
    if errorlevel 1 (
        echo [错误] 依赖安装失败，请检查网络后重试
        pause
        exit /b 1
    )
)

rem ---- 3. 检查构建产物 ----
echo [3/4] 检查构建产物...
if not exist "apps\web\dist\" (
    echo 首次运行，正在构建项目（可能需要几分钟）...
    call pnpm run build
    if errorlevel 1 (
        echo [错误] 构建失败
        pause
        exit /b 1
    )
)

rem ---- 4. 启动服务 ----
echo [4/4] 启动 Web UI: http://127.0.0.1:3080
echo 按 Ctrl+C 停止服务
start "" cmd /c "ping -n 4 127.0.0.1 >nul & start http://127.0.0.1:3080"
call pnpm dsh web

echo.
echo 服务已停止
pause

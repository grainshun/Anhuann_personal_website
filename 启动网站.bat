@echo off
chcp 65001 >nul
title Anhuann 网站服务器

set "PORT=8080"
if not "%~1"=="" set "PORT=%~1"

echo.
echo  ============================================
echo   Anhuann 个人网站 - 一键启动
echo  ============================================
echo.

where node >nul 2>nul
if errorlevel 1 (
    echo [错误] 没有检测到 Node.js，请先安装：
    echo        https://nodejs.org/  ^(选 LTS 版^)
    echo.
    echo 安装完成后重新双击本文件即可。
    echo.
    pause
    exit /b 1
)

echo 正在启动服务器，请稍候...
timeout /t 1 /nobreak >nul

echo.
echo   前台： http://localhost:%PORT%/
echo   后台： http://localhost:%PORT%/admin.html
echo.
echo 浏览器会自动打开前台页面。
echo 关闭此窗口（或按 Ctrl+C）即可停止网站。
echo.

start "" http://localhost:%PORT%/

node server.js

echo.
echo 服务器已停止。
pause

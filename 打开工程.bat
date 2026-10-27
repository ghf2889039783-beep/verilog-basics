@echo off
chcp 936 >nul
REM 双击本文件 = 用 VS Code 打开当前工程目录
setlocal
set "CODE=%LOCALAPPDATA%\Programs\Microsoft VS Code\Code.exe"
if not exist "%CODE%" (
    echo [错误] 找不到 VS Code
    echo 预期路径: %CODE%
    echo.
    pause
    exit /b 1
)
pushd "%~dp0"
start "" "%CODE%" "%CD%"
popd
exit /b 0

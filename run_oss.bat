@echo off
REM run_oss.bat —— 用 OSS CAD Suite 里的 iverilog 跑仿真（WSL 装好之前的主力方式）
REM 依赖：E:\tools\oss-cad-suite
setlocal
set "YOSYSHQ_ROOT=E:\tools\oss-cad-suite"
set "PATH=%YOSYSHQ_ROOT%\bin;%YOSYSHQ_ROOT%\lib;%PATH%"
cd /d "%~dp0"

echo [1/2] 编译...
iverilog -g2012 -o sim counter.v counter_tb.v
if errorlevel 1 goto :err

echo [2/2] 仿真...
vvp sim
if errorlevel 1 goto :err

echo.
echo [OK] 波形：counter_tb.vcd
echo      用 VS Code 打开这个文件即可看波形（VaporView 扩展）
goto :eof

:err
echo.
echo [FAIL] 上一步出错
exit /b 1

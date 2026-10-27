@echo off
chcp 936 >nul
REM 编译 + 仿真 + 用 GTKWave 打开波形窗口
setlocal
set "YOSYSHQ_ROOT=E:\tools\oss-cad-suite"
set "PATH=%YOSYSHQ_ROOT%\bin;%YOSYSHQ_ROOT%\lib;%PATH%"
cd /d "%~dp0"

echo [1/3] 编译 ...
iverilog -g2012 -o sim counter.v counter_tb.v
if errorlevel 1 goto :err

echo.
echo [2/3] 仿真 ...
vvp sim
if errorlevel 1 goto :err

echo.
echo [3/3] 打开 GTKWave 波形窗口 ...
start "" "%YOSYSHQ_ROOT%\bin\gtkwave.exe" "%~dp0counter_tb.vcd"
echo 波形窗口已弹出，本窗口可以关掉
echo.
pause
exit /b 0

:err
echo.
echo [失败] 上一步报错了，看上面几行的错误信息
echo.
pause
exit /b 1

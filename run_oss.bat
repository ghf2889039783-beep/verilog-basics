@echo off
chcp 936 >nul
REM 用 OSS CAD Suite 里的 iverilog 编译并仿真
setlocal
set "YOSYSHQ_ROOT=E:\tools\oss-cad-suite"
set "PATH=%YOSYSHQ_ROOT%\bin;%YOSYSHQ_ROOT%\lib;%PATH%"
cd /d "%~dp0"

if not exist "%YOSYSHQ_ROOT%\bin\iverilog.exe" (
    echo [错误] 找不到 iverilog
    echo 预期路径: %YOSYSHQ_ROOT%\bin\iverilog.exe
    echo.
    pause
    exit /b 1
)

echo [1/2] 编译 counter.v + counter_tb.v ...
iverilog -g2012 -o sim counter.v counter_tb.v
if errorlevel 1 goto :err

echo.
echo [2/2] 运行仿真 ...
vvp sim
if errorlevel 1 goto :err

echo.
echo [完成] 波形文件已生成: counter_tb.vcd
echo        在 VS Code 里点开它就能看波形
echo.
pause
exit /b 0

:err
echo.
echo [失败] 上一步报错了，看上面几行的错误信息
echo.
pause
exit /b 1

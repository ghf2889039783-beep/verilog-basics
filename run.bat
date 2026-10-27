@echo off
chcp 936 >nul
REM 备用方案：用 ModelSim-Altera Starter 10.1d 跑仿真
setlocal
set "PATH=D:\altera\13.1\modelsim_ase\win32aloem;%PATH%"
cd /d "%~dp0"

if not exist "D:\altera\13.1\modelsim_ase\win32aloem\vlib.exe" (
    echo [错误] 找不到 ModelSim
    echo 如果已经删掉 D:\altera，就改用 run_oss.bat
    echo.
    pause
    exit /b 1
)

if exist work rmdir /s /q work
vlib work
if errorlevel 1 goto :err
vlog -work work counter.v counter_tb.v
if errorlevel 1 goto :err
vsim -c -do "run -all; quit" counter_tb
if errorlevel 1 goto :err

echo.
echo [完成] 波形文件: counter_tb.vcd
echo.
pause
exit /b 0

:err
echo.
echo [失败] 上一步报错了，看上面几行的错误信息
echo.
pause
exit /b 1

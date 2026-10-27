@echo off
chcp 936 >nul
REM 备用方案：用 ModelSim 打开波形窗口（信号已自动加好）
setlocal
set "PATH=D:\altera\13.1\modelsim_ase\win32aloem;%PATH%"
cd /d "%~dp0"
vsim -do wave.do counter_tb
pause

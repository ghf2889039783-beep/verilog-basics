@echo off
REM wave.bat —— 一键打开 ModelSim 波形窗口（信号已自动加好）
setlocal
set PATH=D:\altera\13.1\modelsim_ase\win32aloem;%PATH%
cd /d "%~dp0"
vsim -do wave.do counter_tb

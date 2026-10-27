@echo off
REM run.bat —— 用 ModelSim-Altera Starter 10.1d 跑仿真（WSL 装好之前先用这个）
REM 用法：双击，或在 PowerShell 里 .\run.bat
setlocal
set PATH=D:\altera\13.1\modelsim_ase\win32aloem;%PATH%

if exist work rmdir /s /q work
vlib work || goto :err
vlog -work work counter.v counter_tb.v || goto :err
vsim -c -do "run -all; quit" counter_tb || goto :err

echo.
echo [OK] 波形文件：counter_tb.vcd
echo      看波形：vsim -view counter_tb.vcd  ^(或装 GTKWave 后 gtkwave counter_tb.vcd^)
goto :eof

:err
echo.
echo [FAIL] 上一步出错，检查上面的报错信息
exit /b 1

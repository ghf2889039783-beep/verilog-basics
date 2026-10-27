# wave.do —— 打开仿真 GUI，自动把所有层次信号加到波形窗，然后跑完
# 用法：双击 wave.bat，或在工程目录下执行  vsim -do wave.do counter_tb
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -r /*
run -all

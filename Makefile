# Makefile —— WSL 里用 iverilog + gtkwave 跑（11 月清单要求「一条 make run」）
# 现在 Windows 侧还没装 iverilog，先用 run.bat；WSL 装好后在 Ubuntu 里直接 make run

SRCS := counter.v counter_tb.v
TOP  := counter_tb
SIM  := sim
VCD  := counter_tb.vcd

.PHONY: run wave clean

run:
	iverilog -g2012 -o $(SIM) $(SRCS)
	vvp $(SIM)

wave: run
	gtkwave $(VCD) &

clean:
	rm -f $(SIM) $(VCD)

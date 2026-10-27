# verilog-basics

数字 IC 验证自学路线（2026.11 – 2027.10）的阶段 0 起点仓库。
目标：从零搭起「写 RTL → 写自检 TB → 跑仿真 → 看波形 → 提交」的最小闭环。

## 模块表

| 模块 | 文件 | 说明 | TB 自检 |
|---|---|---|---|
| 4 bit 参数化计数器 | `counter.v` | 同步使能 + 异步复位（低有效），非阻塞赋值 | ✅ 6 个 check point |

## 目录结构

```
counter/
├── counter.v         RTL
├── counter_tb.v      自检 TB（PASS/FAIL 由 $display 判定，不靠肉眼）
├── Makefile          WSL 里 make run / make wave / make clean
├── run.bat           Windows 侧用 ModelSim-Altera Starter 跑
└── counter_tb.vcd    仿真波形（gtkwave 打开）
```

## 怎么跑

**Windows（当前机器，ModelSim 10.1d）**

```powershell
cd E:\work\verilog\counter
.\run.bat
```

**WSL / Ubuntu（iverilog + gtkwave）**

```bash
make run     # 编译 + 仿真，直接打印 PASS/FAIL
make wave    # 顺便打开波形
```

## TB 的 6 个 check point

1. `reset` —— 复位期间 cnt 保持 0
2. `hold_when_disabled` —— 释放复位但 en=0，cnt 不动
3. `count_to_5` —— en=1 数 5 拍，cnt=5
4. `hold_at_5` —— 关使能后停在 5
5. `wrap_around` —— 4 bit 回绕，5+11=16 → 0
6. `async_reset` —— 不给时钟沿，拉低 rst_n 也要立刻清零

## 待办

- [ ] 补 shiftreg / mux / decoder / adder / DFF（11 月清单要求 ≥ 6 个模块）
- [ ] 手绘 setup/hold 时序图，存 `docs/`
- [ ] HDLBits 累计 ≥ 40 题

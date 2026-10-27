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
├── 打开工程.bat      双击 = 用 VS Code 打开本目录
├── run_oss.bat       双击 = 编译 + 仿真（iverilog）
├── 看波形.bat        双击 = 编译 + 仿真 + 弹 GTKWave
├── counter.v         RTL
├── counter_tb.v      自检 TB（PASS/FAIL 由 $display 判定，不靠肉眼）
├── Makefile          WSL 里 make run / make wave / make clean
└── counter_tb.vcd    仿真波形（VS Code 里点开，或 GTKWave）
```

## 工具链

| 工具 | 版本 | 位置 |
|---|---|---|
| Icarus Verilog | 14.0 | `E:\tools\oss-cad-suite\bin` |
| Verilator | 5.x | 同上 |
| GTKWave | — | 同上 |
| Verible | v0.0-4296 | `E:\tools\verible\bin`（已加入用户 PATH） |
| VS Code + Verilog-HDL + VaporView | — | 用户级安装 |

## 怎么跑

双击 `run_oss.bat`，或 VS Code 里按 `Ctrl+Shift+B`：

```bat
cd /d E:\work\verilog\counter
run_oss.bat
```

期望输出结尾：`RESULT: ALL PASS  (6/6)`

## 怎么看波形

1. 先跑一次 `run_oss.bat` 生成 `counter_tb.vcd`
2. VS Code 里点开 `counter_tb.vcd` → VaporView 扩展渲染成波形
3. 或双击 `看波形.bat` → 直接弹 GTKWave

看波形顺序：先找时钟（周期应为 10ns）→ 再看复位（`rst_n` 拉低时 `cnt` 应立刻归零）→ 最后看 `en` 与 `cnt` 的加一关系。

## 代码规范（Verible）

VS Code 已配好 Verible：

- **保存时自动 lint** —— 有风格问题会在 Problems 面板标出来
- **手动格式化**：`Shift+Alt+F`（未开保存自动格式化，因为 Verible 会把 `if/else` 单语句收成一行）

命令行用法：

```bat
verible-verilog-lint counter.v counter_tb.v
verible-verilog-format --indentation_spaces=4 counter.v
```

## ⚠️ 两个已踩过的坑

**1. `.bat` 必须是 GBK 编码 + CRLF 换行**

中文 Windows 的 cmd 按 GBK 解码，若存成 UTF-8，中文注释会变乱码并把 `setlocal` / `goto` 一起吞掉。
VS Code 已通过 `.vscode/settings.json` 把 `[bat]` 强制为 GBK，改完确认右下角显示 `GBK` 再保存。

**2. `parameter` 要用 `integer` 而不是 `int`**

`parameter int WIDTH` 是合法 SystemVerilog，但 ModelSim-Altera 10.1d（2012 年）不认，会报
`near "WIDTH": syntax error`。用 Verilog-2001 的 `parameter integer WIDTH` 两个仿真器都能过，
Verible 的 `explicit-parameter-storage-type` 规则也满足。

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

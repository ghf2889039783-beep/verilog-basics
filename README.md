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
├── run_oss.bat       双击 = 编译 + 仿真（iverilog，主力）
├── 看波形.bat        双击 = 编译 + 仿真 + 弹 GTKWave
├── run.bat           备用 = ModelSim-Altera Starter
├── wave.bat          备用 = ModelSim 波形窗口
├── counter.v         RTL
├── counter_tb.v      自检 TB（PASS/FAIL 由 $display 判定，不靠肉眼）
├── Makefile          WSL 里 make run / make wave / make clean
└── counter_tb.vcd    仿真波形（VS Code 里点开，或 GTKWave）
```

## 怎么跑

**Windows（当前机器，主力方式）**

双击 `run_oss.bat`，或命令行：

```bat
cd /d E:\work\verilog\counter
run_oss.bat
```

期望输出结尾：`RESULT: ALL PASS  (6/6)`

**WSL / Ubuntu（iverilog + gtkwave）**

```bash
make run     # 编译 + 仿真，直接打印 PASS/FAIL
make wave    # 顺便打开波形
```

## 怎么看波形

1. 先跑一次 `run_oss.bat` 生成 `counter_tb.vcd`
2. VS Code 里点开 `counter_tb.vcd` → VaporView 扩展渲染成波形
3. 或双击 `看波形.bat` → 直接弹 GTKWave

看波形顺序：先找时钟（周期应为 10ns）→ 再看复位（`rst_n` 拉低时 `cnt` 应立刻归零）→ 最后看 `en` 与 `cnt` 的加一关系。

## ⚠️ 改 .bat 的注意事项

本目录的 `.bat` 全部是 **GBK 编码 + CRLF 换行**。原因是中文 Windows 的 cmd 按 GBK 解码，
若存成 UTF-8，中文注释会变乱码并把 `setlocal` / `goto` 一起吞掉，脚本一条命令都执行不了。

在 VS Code 里改 `.bat` 后，必须确认右下角编码显示 `GBK`（不是 `UTF-8`）再保存。
若不小心存成 UTF-8 出现乱码，用 Git 还原：`git checkout -- run_oss.bat`。

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

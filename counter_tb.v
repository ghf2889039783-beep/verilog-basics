// counter_tb.v —— 自检式 testbench（不靠肉眼看波形）
// 5 个 check point：复位 / 使能保持 / 计数 / 关使能保持 / 回绕 / 异步复位
`timescale 1ns / 1ps

module counter_tb;

    localparam integer WIDTH = 4;

    reg              clk   = 1'b0;
    reg              rst_n = 1'b0;
    reg              en    = 1'b0;
    wire [WIDTH-1:0] cnt;

    integer errors = 0;
    integer total  = 0;

    counter #(.WIDTH(WIDTH)) dut (
        .clk  (clk),
        .rst_n(rst_n),
        .en   (en),
        .cnt  (cnt)
    );

    // 100 MHz 时钟，周期 10 ns
    always #5 clk = ~clk;

    // 自检宏：断言 cnt 应等于 exp
    `define CHECK(exp, name)                                                     \
        begin                                                                   \
            total = total + 1;                                                  \
            if (cnt !== (exp)) begin                                            \
                $display("FAIL  [%0s] t=%0t  expected=%0d  got=%0d",            \
                         name, $time, (exp), cnt);                              \
                errors = errors + 1;                                            \
            end else begin                                                      \
                $display("PASS  [%0s] t=%0t  cnt=%0d", name, $time, cnt);       \
            end                                                                 \
        end

    initial begin
        $dumpfile("counter_tb.vcd");
        $dumpvars(0, counter_tb);

        // 1) 复位期间应保持 0
        repeat (2) @(negedge clk);
        `CHECK(4'd0, "reset")

        // 2) 释放复位但 en=0，应原地不动
        rst_n = 1'b1;
        repeat (3) @(negedge clk);
        `CHECK(4'd0, "hold_when_disabled")

        // 3) en=1 数 5 拍
        en = 1'b1;
        repeat (5) @(negedge clk);
        `CHECK(4'd5, "count_to_5")

        // 4) 关使能，应停在 5
        en = 1'b0;
        repeat (3) @(negedge clk);
        `CHECK(4'd5, "hold_at_5")

        // 5) 再数 11 拍，4 bit 回绕 5+11=16 -> 0
        en = 1'b1;
        repeat (11) @(negedge clk);
        `CHECK(4'd0, "wrap_around")

        // 6) 异步复位：不给时钟沿，直接拉低也要立刻清零
        rst_n = 1'b0;
        #2;
        `CHECK(4'd0, "async_reset")

        $display("--------------------------------------------------");
        if (errors == 0)
            $display("RESULT: ALL PASS  (%0d/%0d)", total, total);
        else
            $display("RESULT: %0d FAILURE(S) out of %0d", errors, total);
        $display("--------------------------------------------------");
        $finish;
    end

endmodule

// counter.v —— 4 bit 参数化计数器（阶段 0 第一个模块）
// 同步使能 + 异步复位（低有效），非阻塞赋值
`timescale 1ns / 1ps

module counter #(
    parameter WIDTH = 4
) (
    input  wire             clk,
    input  wire             rst_n,   // 异步复位，低有效
    input  wire             en,      // 同步使能
    output reg  [WIDTH-1:0] cnt
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= {WIDTH{1'b0}};
        else if (en)
            cnt <= cnt + 1'b2;
    end

endmodule

`timescale 1ns / 1ps

module BtcMiner
(
    input   clk         ,
    input   rst         ,
    output  result      ,
    output  uart_out        
);

localparam hash_rate = 8'h46;
wire send;
reg [26:0] counter, counter_next;
assign send = (counter == 0) ? 1'b1 : 1'b0;
reg [2:0] divcnt, divcnt_next;

shapipe_top
miner
(
    .clk    (clk    ),
    .result (result )
);

UART_TX
tx
(
    .clk            (clk),
    .rst            (rst),
    .tx_basla       (send),
    .tx_data        (hash_rate),
    .out_tx         (uart_out),
    .out_tx_bitis   ()
); 


always @(posedge clk)
    counter <= counter_next;

always @(*) begin
    counter_next = counter;
    if(rst) begin
        counter_next = 0;
    end else begin
        if(counter == 27'h42C1D80)
            counter_next = 0;
        else
            counter_next = counter + 1;
    end
end


endmodule

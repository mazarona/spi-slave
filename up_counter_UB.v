/* A counter that will count up to UPPER_BOUND only if triggered
* and it stops at 0 when it reaches UPPER_BOUND */
module trigger_up_counter_UB(clk, rst_n, trigger, counter_up);
    parameter W = 4;
    parameter UPPER_BOUND = 8;
    input clk, rst_n, trigger;
    output reg [W-1:0]counter_up;

    reg triggered;
    always@(posedge trigger)begin
        triggered <= 1;
    end
    
    always@(posedge clk)begin
        if(~rst_n) begin
            counter_up <= 0;
            triggered <= 0;
        end
        else if(counter_up == UPPER_BOUND) begin
            counter_up <= 0;
            triggered <= 0;
        end
        else if(triggered) counter_up <= counter_up + 1;
    end
endmodule

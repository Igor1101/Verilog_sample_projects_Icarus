`include "cnt.vh"
module cnt(clk, reset, div, control, q, dout);
  input clk;
  input reset;
  input [31:0] div;
  input [2:0] control;
  output q;
  output [31:0] dout;
  reg [31:0] data;
  reg [31:0] divider;
  reg q;
  reg phase;
  always @(posedge reset, clk)
  begin 
    if(reset) begin
      data <= 0;
      divider <= 32'h0;
      q <= 0;
      phase <= 0;
    end
    else begin
      divider <= div;
      case (control) 
      `CTRL_OFF:
      // do nothing      
      data <= 0;
      `CTRL_RESET_AND_SIGNAL_IF_EQUAL:
      // count till divider, then '0' + signal toggle
      if(divider == data) begin
        data <= 0;
        q<= ~q;
      end else 
        data <= data + 32'h1;
      `CTRL_COUNTDOWN_AND_SIGNAL_IF_EQUAL:
      // count till divider, then signal toggle + count to zero 
      if(divider == data) begin
        phase <= ~phase;
        q <= ~q;
      end else begin
        if(phase == 1'h0) 
          data <= data + 32'h1;
        else
          data <= data - 32'h1;
      end
      endcase
    end

  end

  assign dout = data;
endmodule

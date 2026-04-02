//`define HEXPATH "/workspaces/lab-3-behavioral-verilog-kaibugata/part4/sinusoid"
module sinusoid
  (input [0:0] clk_i
  ,input [0:0] reset_i
   // Your ports here
  //  ,input valid_i
  //  ,output ready_o
  //  ,output valid_o
  //  ,input ready_i

   ,output [11:0] sinOut//signed??
   );

  logic [$clog2(100)-1:0] count_o2;
  logic [$clog2(500)-1:0] count_o;
  always_ff @(posedge clk_i) begin
    if(reset_i || count_o2 == 100) begin
      count_o <= '0;
      count_o2 <= '0;
    end else begin
      count_o <= count_o + 1;
      if(count_o == 500) begin
        count_o2 <= count_o2 + 1;
      end
    end
    
  end
  //wire [11:0] sinOut;
  wire [6:0] hex_i; //was 11:0
  assign hex_i = count_o2;
  // Your code here

  ram_1r1w_async #(.width_p(12),.depth_p(100),.filename_p("sinusoid.hex")) sinRAM (
    .clk_i(1'b0),                
    .reset_i(1'b0),              
    .wr_valid_i(1'b0),           
    .wr_data_i('0),
    .wr_addr_i('0),
    .rd_addr_i(hex_i),
    .rd_data_o(sinOut)
   );

endmodule
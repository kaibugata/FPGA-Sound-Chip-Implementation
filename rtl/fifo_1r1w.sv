module fifo_1r1w
  #(parameter [31:0] width_p = 8
   // Note: Not depth_p! depth_p should be 1<<depth_log2_p
   ,parameter [31:0] depth_log2_p = 8
   )
  (input [0:0] clk_i
  ,input [0:0] reset_i

  ,input [width_p - 1:0] data_i
  ,input [0:0] valid_i
  ,output [0:0] ready_o 

  ,output [0:0] valid_o 
  ,output [width_p - 1:0] data_o 
  ,input [0:0] ready_i
  );



    logic [depth_log2_p:0] read_cntr_q;
    logic [depth_log2_p:0] writ_cntr_q;

    assign ready_o = !((writ_cntr_q[depth_log2_p-1:0] == read_cntr_q[depth_log2_p-1:0]) && (writ_cntr_q[depth_log2_p] != read_cntr_q[depth_log2_p]));
    assign valid_o = !(writ_cntr_q == read_cntr_q);


    always_ff @(posedge clk_i) begin
        if(reset_i) begin
            read_cntr_q <= '0;
            writ_cntr_q <= '0;
        end else begin
            if(ready_o && valid_i) begin//push
                writ_cntr_q <= writ_cntr_q + 1;
            end

            if(ready_i && valid_o) begin//pop
                read_cntr_q <= read_cntr_q + 1;
            end
        end
        
    end


    ram_1r1w_async #(width_p, 1<<depth_log2_p, 0) ramMod (
    .clk_i,
    .reset_i,
    .wr_valid_i(ready_o && valid_i), //push
    .wr_data_i(data_i),
    .wr_addr_i(writ_cntr_q[depth_log2_p-1:0]),
    .rd_addr_i(read_cntr_q[depth_log2_p-1:0]),
    .rd_data_o(data_o)
    );


endmodule
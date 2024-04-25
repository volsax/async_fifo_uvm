`include "synchronizer.sv"
`include "wptr_handler.sv"
`include "rptr_handler.sv"
`include "fifo_mem.sv"

module asynchronous_fifo #(parameter DEPTH=64, DATA_WIDTH=32) (
  input logic wclk, wrst_n,
  input logic rclk, rrst_n,
  input logic w_en, r_en,
  input logic [DATA_WIDTH-1:0] data_in,
  output logic [DATA_WIDTH-1:0] data_out,
  output logic full, empty
);
  
  parameter PTR_WIDTH = $clog2(DEPTH);
 
  logic [PTR_WIDTH:0] g_wptr_sync, g_rptr_sync;
  logic [PTR_WIDTH:0] b_wptr, b_rptr;
  logic [PTR_WIDTH:0] g_wptr, g_rptr;

  logic [PTR_WIDTH-1:0] waddr, raddr;

  synchronizer #(PTR_WIDTH) sync_wptr (rclk, rrst_n, g_wptr, g_wptr_sync); //write pointer to read clock domain
  synchronizer #(PTR_WIDTH) sync_rptr (wclk, wrst_n, g_rptr, g_rptr_sync); //read pointer to write clock domain 
  
  wptr_handler #(PTR_WIDTH) wptr_h(wclk, wrst_n, w_en,g_rptr_sync,b_wptr,g_wptr,full);
  rptr_handler #(PTR_WIDTH) rptr_h(rclk, rrst_n, r_en,g_wptr_sync,b_rptr,g_rptr,empty);
  fifo_mem fifom(wclk, w_en, rclk, r_en,b_wptr, b_rptr, data_in,full,empty, data_out);

endmodule
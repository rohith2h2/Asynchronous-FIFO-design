`include "synchronizer.sv"
`include "wptr_handler.sv"
`include "rptr_handler.sv"
`include "memory.sv"

module fifo #(parameter DEPTH = 32, parameter DATA_WIDTH = 32)(
  input logic wclk,
  input logic wrstn,
  input logic wr_en,
  input logic rclk,
  input logic rrstn,
  input logic rd_en,
  input logic [DATA_WIDTH-1:0] data_in,
  output logic full,
  output logic empty,
  output logic [DATA_WIDTH-1:0] data_out );
  
  parameter PTR_WIDTH = $clog2(DEPTH);
  reg [PTR_WIDTH:0] g_wptr_sync, g_rptr_sync;
  reg [PTR_WIDTH:0] b_wptr, g_wptr;
  reg [PTR_WIDTH:0] b_rptr, g_rptr;
  
  synchronizer #(PTR_WIDTH) sync_wptr(.clk(rclk), .rstn(rrstn), .d_in(g_wptr),
                                      .d_out(g_wptr_sync) );
  
  synchronizer #(PTR_WIDTH) sync_rptr(.clk(wclk), .rstn(wrstn), .d_in(g_rptr),
                                      .d_out(g_rptr_sync) );
  
  wptr_handler #(PTR_WIDTH) i1( .wclk(wclk), .wrstn(wrstn), .wr_en(wr_en), .g_rptr_sync(g_rptr_sync), .b_wptr(b_wptr), .g_wptr(g_wptr), .full(full) );
  
  rptr_handler #(PTR_WIDTH) i2( .rclk(rclk), .rrstn(rrstn), .rd_en(rd_en), .g_wptr_sync(g_wptr_sync), .b_rptr(b_rptr), .g_rptr(g_rptr), .empty(empty) );
  
  memory mem( .wclk(wclk), .wr_en(wr_en), .rclk(rclk), .rd_en(rd_en), .b_wptr(b_wptr), .b_rptr(b_rptr), .full(full), .empty(empty), .data_in(data_in), .data_out(data_out) );
  
endmodule
  

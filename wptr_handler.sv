module wptr_handler #(parameter PTR_WIDTH = 8)(
  input logic wclk,
  input logic wrstn,
  input logic wr_en,
  input logic [PTR_WIDTH:0] g_rptr_sync, //gray read pointer synchronized
  output logic [PTR_WIDTH:0] b_wptr, //binary write pointer
  output logic [PTR_WIDTH:0] g_wptr, //gray write pointer
  output reg full);
  
  reg [PTR_WIDTH:0] b_wptr_next, g_wptr_next;
  wire wfull;
  
  assign b_wptr_next = b_wptr + (wr_en & !full);
  assign g_wptr_next = (b_wptr_next >> 1) ^ (b_wptr_next); //gray code operation, right shift by 1 bit and xor gives out g_wptr_next value
  
  always @(posedge wclk or negedge wrstn) begin
    if(!wrstn) begin
      b_wptr <= 1'b0;
      g_wptr <= 1'b0;
    end else begin
      b_wptr <= b_wptr_next;
      g_wptr <= g_wptr_next;
    end
  end
  
  always @(posedge wclk or negedge wrstn) begin
    if(!wrstn)
      full <= 0;
    else
      full <= wfull;
  end
  
  assign wfull = (g_wptr_next == {~g_rptr_sync[PTR_WIDTH:PTR_WIDTH-1], g_rptr_sync[PTR_WIDTH-2:0]});
  
endmodule:wptr_handler

                  
                  
                  
                  
                  
  
  
  
  

module rptr_handler #(parameter PTR_WIDTH = 8)(
  input logic rclk,
  input logic rrstn,
  input logic rd_en,
  input logic [PTR_WIDTH:0] g_wptr_sync,
  output logic [PTR_WIDTH:0] b_rptr,
  output logic [PTR_WIDTH:0] g_rptr,
  output logic empty);
  
  reg rempty;
  
  reg [PTR_WIDTH:0] b_rptr_next, g_rptr_next;
  
  assign rempty = (g_rptr_next == g_wptr_sync);
  
  
  assign b_rptr_next = b_rptr + (rd_en & !empty);
  assign g_rptr_next = ( (b_rptr_next >> 1 ) ^ b_rptr_next);
  
  always @(posedge rclk or negedge rrstn) begin
    if(!rrstn) begin
      b_rptr <= 0;
      g_rptr <= 0;
    end else begin
      b_rptr <= b_rptr_next;
      g_rptr <= g_rptr_next;
    end
  end
  
  always @(posedge rclk or negedge rrstn) begin
    if(!rrstn) 
      empty <= 1;
    else
      empty <= rempty;
  end
  
endmodule:rptr_handler

  

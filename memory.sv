module memory #(parameter PTR_WIDTH =8, DATA_WIDTH = 32, DEPTH = 32)(
  input logic wclk,
  input logic wr_en,
  input logic rclk,
  input logic rd_en,
  input logic [PTR_WIDTH:0] b_wptr,
  input logic [PTR_WIDTH:0] b_rptr,
  input logic [DATA_WIDTH-1:0] data_in,
  input logic full,
  input logic empty,
  output logic [DATA_WIDTH-1:0] data_out);
  
  reg [DATA_WIDTH-1:0] fifo [DEPTH-1:0];
  
  always @(posedge wclk) begin
    if(wr_en & !full) begin
      fifo[b_wptr[PTR_WIDTH-1:0]] <= data_in;
    end
  end
  
  assign data_out = fifo[b_rptr[PTR_WIDTH-1:0] ];
endmodule:memory
           

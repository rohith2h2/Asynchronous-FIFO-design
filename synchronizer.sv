module synchronizer #(parameter DATA_WIDTH = 8)(
  input logic clk,
  input logic rstn,
  input logic [DATA_WIDTH:0] d_in,
  output logic [DATA_WIDTH:0] d_out);
  reg [DATA_WIDTH:0] q1;
  
  always @(posedge clk) begin
    if(!rstn) begin
      q1 <= 0;
      d_out <= 0;
    end
    else begin
        q1 <= d_in;
        d_out <= q1;
    end
  end
endmodule:synchronizer

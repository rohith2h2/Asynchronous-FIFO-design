module tb;
  parameter DATA_WIDTH = 32;
  parameter DEPTH = 32;
  reg wclk;
  reg rclk;
  reg wr_en;
  reg rd_en;
  reg wrstn;
  reg rrstn;
  reg [DATA_WIDTH-1:0] data_in;
  wire full;
  wire empty;
  wire [DATA_WIDTH-1:0] data_out;
  
  reg [DATA_WIDTH-1:0] wdata_q[$], wdata;
  
  fifo i1(.wclk(wclk), .wrstn(wrstn), .wr_en(wr_en), .rd_en(rd_en), .rclk(rclk), .rrstn(rrstn), .data_in(data_in), .full(full), .empty(empty), .data_out(data_out) );
  
  always #10 wclk = ~wclk;
  always #30 rclk = ~rclk;
  
  initial begin
    wclk = 1'b0;
    wr_en = 1'b0;
    data_in = 1'b0;
    wrstn = 1'b0;
    
    repeat(10) @(posedge wclk);
    wrstn = 1'b1;
    
    repeat(2) begin
      for(int i=0; i<30; i++) begin
        @(posedge wclk iff !full);
        wr_en = (i%2==0) ? 1'b1 : 1'b0;
        if(wr_en) begin
          data_in = $urandom;
          wdata_q.push_back(data_in);
        end
      end
      #50;
    end
  end
  
  initial begin
    rclk = 1'b0;
    rd_en = 1'b0;
    rrstn = 1'b0;
    repeat(20) @(posedge rclk);
    rrstn = 1'b1;
    
    repeat(2) begin
      for(int i =0; i<30; i++) begin
        @(posedge rclk iff !empty);
        rd_en = (i%2 == 0) ? 1'b1:1'b0;
        if(rd_en) begin
          wdata = wdata_q.pop_front();
          if(data_out !== wdata) $error("Time = %0t: Comparison Failed: expected wr_data = %h, rd_data = %h", $time, wdata, data_out);
          else
            $display("Time = %0t: Comparison Passed: wr_data = %h and rd_data = %h",$time, wdata, data_out);
        end
      end
      #50;
    end
    
    $finish();
  end
  
  initial begin 
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
  end
  
endmodule

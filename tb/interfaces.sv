interface dut_write #(
    parameter DATA_WIDTH = 8
);
    logic  wclk, wrst_n;
    logic  w_en;
    logic  [DATA_WIDTH-1:0] data_in;
    logic  full;
endinterface: dut_write

interface dut_read #(
    parameter DATA_WIDTH = 8
);
    logic  rclk, rrst_n;
    logic  r_en;
    logic  [DATA_WIDTH-1:0] data_out;
    logic  empty;
endinterface: dut_read

interface dut_in #(
    parameter DATA_WIDTH = 8
);
    logic  wclk, wrst_n;
    logic  rclk, rrst_n;
    logic  w_en, r_en;
    logic  [DATA_WIDTH-1:0] data_in;
endinterface: dut_in

interface dut_out #(
    parameter DATA_WIDTH = 8
);
    logic  wclk, rclk;
    logic  [DATA_WIDTH-1:0] data_out;
    logic  full, empty;
endinterface: dut_out
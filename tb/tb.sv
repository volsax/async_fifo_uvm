// This is the top module UVM testbench of async fifo`timescale 1ns / 100ps
`include "uvm_macros.svh"
import uvm_pkg::*;
import modules_pkg::*;
import sequences::*;
import coverage::*;
import scoreboard::*;
import tests::*;


module dut(dut_in _in, dut_out _out);
asynchronous_fifo async0(
    .wclk(_in.wclk),
    .wrst_n(_in.wrst_n),
    .rclk(_in.rclk),
    .rrst_n(_in.rrst_n),
    .w_en(_in.w_en),
    .r_en(_in.r_en),
    .data_in(_out.data_in),
    .data_out(_out.data_out),
    .full(_out.full),
    .empty(_out.empty)
);
endmodule: dut

module top;    
dut_in dut_in1();
dut_out dut_out1();

initial begin
    dut_in1.wclk<=0;
    forever #50 dut_in1.wclk<=~dut_in1.wclk;
end

initial begin
    dut_out1.wclk<=0;
    forever #50 dut_out1.rclk<=~dut_out1.rclk;
end

initial begin
    dut_in1.rclk<=0;
    forever #50 dut_out1.wclk<=~dut_out1.wclk;
end

initial begin
    dut_out1.rclk<=0;
    forever #50 dut_out1.rclk<=~dut_out1.rclk;
end

// TODO: Instantiate the dut module as dut1 and use the input as dut_in1 and output as dut_out1
dut dut1(
    ._in(dut_in1),
    ._out(dut_out1)
);

initial begin
    uvm_config_db #(virtual dut_in)::set(null,"uvm_test_top","dut_vi_in",dut_in1);
    uvm_config_db #(virtual dut_out)::set(null,"uvm_test_top","dut_vi_out",dut_out1);
    uvm_top.finish_on_completion=1;

    //TODO:Modify the test name here
    run_test("test1");
end

endmodule: top

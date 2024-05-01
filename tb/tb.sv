// This is the top module UVM testbench of async fifo
`timescale 1ns / 100ps
`include "uvm_macros.svh"
import uvm_pkg::*;
import modules_pkg::*;
import sequences_read::*;
import sequences_write::*;
import coverage::*;
import scoreboard::*;
import tests::*;


module dut(dut_write wrif, dut_read rrif);
asynchronous_fifo async0(
    .wclk(wrif.wclk),
    .wrst_n(wrif.wrst_n),
    .rclk(rrif.rclk),
    .rrst_n(rrif.rrst_n),
    .w_en(wrif.w_en),
    .r_en(rrif.r_en),
    .data_in(wrif.data_in),
    .data_out(rrif.data_out),
    .full(wrif.full),
    .empty(rrif.empty)
);
endmodule: dut

module top;    
dut_write dut_write1();
dut_read  dut_read1();

// Drive the read and write clock
initial begin
    dut_write1.wclk<=0;
    forever #50 dut_write1.wclk<=~dut_write1.wclk;
end

initial begin
    dut_read1.rclk<=0;
    forever #50 dut_read1.rclk<=~dut_read1.rclk;
end


// TODO: Instantiate the dut module as dut1 and use the input as dut_in1 and output as dut_out1
dut dut1(
    .wrif(dut_write1),
    .rrif(dut_read1)
);

initial begin
    uvm_config_db #(virtual dut_write)::set(null,"uvm_test_top","dut_vi_write",dut_write1);
    uvm_config_db #(virtual dut_read)::set(null,"uvm_test_top","dut_vi_read",dut_read1);
    uvm_top.finish_on_completion=1;
    //TODO:Modify the test name here
    run_test("test1");
end

endmodule: top

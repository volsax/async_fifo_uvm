`include "uvm_macros.svh"
package modules_pkg;

import uvm_pkg::*;
import sequences::*;
import coverage::*;
import scoreboard::*;

// typedef uvm_sequencer #(alu_transaction_in) alu_sequencer_in;

class async_fifo_dut_config extends uvm_object;
    `uvm_object_utils(async_fifo_dut_config)

    virtual dut_in dut_vi_in;
    virtual dut_out dut_vi_out;

endclass: async_fifo_dut_config

class async_fifo_read_driver extends uvm_driver#(alu_transaction_in); // TODO change alu_transaction_in to afifo
    `uvm_component_utils(async_fifo_read_driver)

    async_fifo_dut_config dut_config_0;
    virtual dut_in dut_vi_in;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
       assert( uvm_config_db #(async_fifo_dut_config)::get(this, "", "dut_config", dut_config_0));
       dut_vi_in = dut_config_0.dut_vi_in;
    endfunction : build_phase
   
    task run_phase(uvm_phase phase);
      forever
      begin
        // TODO change alu_transaction_in tx
        alu_transaction_in tx;
        
        @(posedge dut_vi_in.clk);
        seq_item_port.get(tx);
       
        // TODO: Drive values from alu_transaction_in onto the virtual
        // interface of dut_vi_in
        dut_vi_in.A <= tx.A;
        dut_vi_in.B <= tx.B;
        dut_vi_in.CIN <= tx.CIN;
        dut_vi_in.opcode <= tx.opcode;
        dut_vi_in.rst <= tx.rst;
      end
    endtask: run_phase

endclass: async_fifo_read_driver

class async_write_driver extends uvm_driver#(alu_transaction_in); // TODO change alu_transaction_in to afifo
    `uvm_component_utils(async_write_driver)

    async_fifo_dut_config dut_config_0;
    virtual dut_in dut_vi_in;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
       assert( uvm_config_db #(async_fifo_dut_config)::get(this, "", "dut_config", dut_config_0));
       dut_vi_in = dut_config_0.dut_vi_in;
    endfunction : build_phase
   
    task run_phase(uvm_phase phase);
      forever
      begin
        // TODO change alu_transaction_in tx
        alu_transaction_in tx;
        
        @(posedge dut_vi_in.clk);
        seq_item_port.get(tx);
       
        // TODO: Drive values from alu_transaction_in onto the virtual
        // interface of dut_vi_in
        dut_vi_in.A <= tx.A;
        dut_vi_in.B <= tx.B;
        dut_vi_in.CIN <= tx.CIN;
        dut_vi_in.opcode <= tx.opcode;
        dut_vi_in.rst <= tx.rst;
      end
    endtask: run_phase

endclass: async_write_driver



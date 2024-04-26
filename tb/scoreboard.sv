`include "uvm_macros.svh"
package scoreboard; 
import uvm_pkg::*;
import sequences_read::*;
import sequences_write::*;

class async_fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(alu_scoreboard)

    uvm_analysis_export #(async_fifo_transaction_read) sb_read;
    uvm_analysis_export #(async_fifo_transaction_write) sb_write;

    uvm_tlm_analysis_fifo #(async_fifo_transaction_read) fifo_read;
    uvm_tlm_analysis_fifo #(async_fifo_transaction_write) fifo_write;

    async_fifo_transaction_read tx_read;
    async_fifo_transaction_write tx_write;

    function new(string name, uvm_component parent);
        super.new(name,parent);
        tx_read=new("tx_read");
        tx_write=new("tx_write");
    endfunction: new

    function void build_phase(uvm_phase phase);
        sb_read=new("sb_read",this);
        sb_write=new("sb_write",this);
        fifo_read=new("fifo_read",this);
        fifo_write=new("fifo_write",this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        sb_read.connect(fifo_read.analysis_export);
        sb_write.connect(fifo_write.analysis_export);
    endfunction: connect_phase

    task run();
        forever begin
            fifo_read.get(tx_read);
            fifo_write.get(tx_write);
            compare();
        end
    endtask: run

    extern virtual function [33:0] getresult; 
    extern virtual function void compare; 
        
endclass: async_fifo_scoreboard

function void async_fifo_scoreboard::compare;
    //TODO: Write this function to check whether the output of the DUT matches
    //the spec.
    //Use the getresult() function to get the spec output.
    //Consider using `uvm_info(ID,MSG,VERBOSITY) in this function to print the
    //results of the comparison which passed
    //and `uvm_error(ID,MSG) for the failed cases.
    //The debugging statements can have a higher verbosity level
    //You can use tx_in.convert2string() and tx_out.convert2string() for
    //debugging purposes

    // Assume our transaction has data out empty full
    // string s;
    logic    [33:0]ref_result;  //[1 bit empty, 1 bit full, 32bit data]
    ref_result = getresult();


    if(tx_read.data_out != ref_result[31:0] || $isunknown(tx_read.out)) begin
        `uvm_error("1","Compare fail for OUT[31:0]");
        // `uvm_info("1", $sformatf("\nActual input A: %x, B: %x, opcode: %b, CIN %b ,rst: %b\nDUT output: %x, vout: %b, cout: %b\nExpected output: %x, vout: %b, cout: %b\n", tx_in.A, tx_in.B, tx_in.opcode, tx_in.CIN, tx_in.rst, tx_out.OUT, tx_out.VOUT, tx_out.COUT, ref_result[31:0], ref_result[33], ref_result[32]), UVM_HIGH);
    end
    else if(tx_write.full != ref_result[32] || $isunknown(tx_write.full)) begin
        `uvm_error("2","Compare fail for full flag");
        // `uvm_info("2", $sformatf("\nActual input A: %x, B: %x, opcode: %b, CIN %b ,rst: %b\nDUT output: %x, vout: %b, cout: %b\nExpected output: %x, vout: %b, cout: %b\n", tx_in.A, tx_in.B, tx_in.opcode, tx_in.CIN, tx_in.rst, tx_out.OUT, tx_out.VOUT, tx_out.COUT, ref_result[31:0], ref_result[33], ref_result[32]), UVM_HIGH);
    end
    else if(tx_read.empty != ref_result[33] || $isunknown(tx_read.empty)) begin
        `uvm_error("3","Compare fail for empty flag");
        // `uvm_info("3", $sformatf("\nActual input A: %x, B: %x, opcode: %b, CIN %b ,rst: %b\nDUT output: %x, vout: %b, cout: %b\nExpected output: %x, vout: %b, cout: %b\n", tx_in.A, tx_in.B, tx_in.opcode, tx_in.CIN, tx_in.rst, tx_out.OUT, tx_out.VOUT, tx_out.COUT, ref_result[31:0], ref_result[33], ref_result[32]), UVM_HIGH);
    end
    else begin
        `uvm_info("4", "Test Passed", UVM_HIGH);
        // `uvm_info("4", $sformatf("\nActual input A: %x, B: %x, opcode: %b, CIN %b ,rst: %b\nDUT output: %x, vout: %b, cout: %b\nExpected output: %x, vout: %b, cout: %b\n", tx_in.A, tx_in.B, tx_in.opcode, tx_in.CIN, tx_in.rst, tx_out.OUT, tx_out.VOUT, tx_out.COUT, ref_result[31:0], ref_result[33], ref_result[32]), UVM_HIGH);
    end
endfunction

function [33:0] async_fifo_scoreboard::getresult;
    //TODO: Write this function to return a 34-bit result {empty, full, out[31:0]} which is
    //consistent with the given spec.
    logic empty;
    logic full;
    logic [31:0] out;
    logic [6:0] count;  // Use to calculate full and empty, fifo depth is 64

    // Maybe I will need to add a fifo to store the write data

    if(tx_write.w_en) begin
        out = tx_write.data_in;
        count++;
    end

    if(tx_read.r_en) begin
        count--;
    end

    if(count == 0) begin
        empty = 1;
        full = 0;
    end
    else if(count == 64) begin
        empty = 0;
        full = 1;
    end
    else begin
        empty = 0;
        full = 0;
    end  

    return {empty, full, out[31:0]};
endfunction

endpackage: scoreboard

`include "uvm_macros.svh"
package coverage;

import uvm_pkg::*;
import sequences_read::*;
import sequences_write::*;

class async_fifo_subscriber_write extends uvm_subscriber #(async_fifo_transaction_write);
    `uvm_component_utils(async_fifo_subscriber_write)

    // Declare the transaction object to facilitate sampling and create covergroup and its corresponding coverpoints
    //Make sure to instantiate the covergroup inside the new function
    
    // Variavles declaration
    // input
    logic wrst_n;
    logic w_en;
    logic [31:0] data_in;
    // output
    logic full;
    
    // Covergroup creation
    covergroup async_fifo_write;
        option.per_instance = 1;
        
        cp_wrst_n: coverpoint wrst_n {
            bins reset = {0};
            bins no_reset = {1};
        }

        cp_w_en: coverpoint w_en {
            option.at_least = 10;
            bins w_not_en = {0};
            bins w_en = {1};
        }

        cp_data_in: coverpoint data_in {
            option.at_least = 50;
            bins pos = {[32'h00000001 : 32'h7FFFFFFF]};
            bins neg = {[32'h80000000 : 32'hFFFFFFFF]};
        }

        cp_full: coverpoint full {
            option.at_least = 3;
            bins not_full = {0};
            bins full = {1};
        }

    endgroup

    function new(string name, uvm_component parent);
        super.new(name,parent);
        async_fifo_write = new();
    endfunction: new

    function void write(async_fifo_transaction_write t);
        // Sample the created covergroup with the proper transaction object
        wrst_n = {t.wrst_n};
        w_en = {t.w_en};
        data_in = {t.data_in};
        full = {t.full};
        async_fifo_write.sample();
    endfunction: write

endclass: async_fifo_subscriber_write

class async_fifo_subscriber_read extends uvm_subscriber #(async_fifo_transaction_read);
    `uvm_component_utils(async_fifo_subscriber_read)

    // Declare the transaction object to facilitate sampling and create covergroup and its corresponding coverpoints
    //Make sure to instantiate the covergroup inside the new function
    
    // Variavles declaration
    // input
    logic rrst_n;
    logic r_en;
    // output
    logic [31:0] data_out;
    logic empty;

    // Covergroup creation
    covergroup async_fifo_read;
        option.per_instance = 1;
        
        cp_rrst_n: coverpoint rrst_n {
            bins reset = {0};
            bins no_reset = {1};
        }

        cp_w_en: coverpoint r_en {
            option.at_least = 10;
            bins r_not_en = {0};
            bins r_en = {1};
        }

        cp_data_in: coverpoint data_out {
            option.at_least = 50;
            bins pos = {[32'h00000001 : 32'h7FFFFFFF]};
            bins neg = {[32'h80000000 : 32'hFFFFFFFF]};
        }

        cp_full: coverpoint empty {
            option.at_least = 3;
            bins not_empty = {0};
            bins empty = {1};
        }

    endgroup

    function new(string name, uvm_component parent);
        super.new(name,parent);
        async_fifo_read = new();
    endfunction: new

    function void write(async_fifo_transaction_read t);
        // Sample the created covergroup with the proper transaction object 
        rrst_n = {t.rrst_n};
        r_en = {t.r_en};
        data_out = {t.data_out};
        empty = {t.empty};
        async_fifo_read.sample();
    endfunction: write

endclass: async_fifo_subscriber_read

endpackage: coverage
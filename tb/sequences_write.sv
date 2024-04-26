`include "uvm_macros.svh"
package sequences_write;

    import uvm_pkg::*;

    class async_fifo_transaction_write extends uvm_sequence_item;
        // Register the async_fifo_transaction_write object.
        `uvm_object_utils(async_fifo_transaction_write)
        
        // input
        rand logic wrst_n;
        rand logic w_en;
        rand logic [31:0] data_in;
        // output
        logic full;

        // Add constraints here
        // When the AFIFO is full, we can't write more value
        constraint async_fifo_full {
          ( full == 1'b1 ) -> ( w_en == 1'b0 );
        }

        // When write is not enabled, data_in should be 0
        constraint w_en_data_in {
          ( w_en == 1'b0 ) -> ( data_in == 32'b0 );
        }

        function new(string name = "");
            super.new(name);
        endfunction: new

        function string convert2string;
            convert2string={$sformatf("w_en = %b, data_in = %b, full = %b",w_en,data_in,full)};
        endfunction: convert2string
        
    endclass: async_fifo_transaction_write

    // write sequence creation
    class simple_seq_write extends uvm_sequence #(async_fifo_transaction_write);
        `uvm_object_utils(simple_seq_write)

        function new(string name = "");
            super.new(name);
        endfunction: new

        task body;
            async_fifo_transaction_write tw;
            tw=async_fifo_transaction_write::type_id::create("tw");
            start_item(tw);
            assert(tw.randomize());
            finish_item(tw);
        endtask: body
    endclass: simple_seq_write

    class seq_of_commands_write extends uvm_sequence #(async_fifo_transaction_write);
        `uvm_object_utils(seq_of_commands_write)
        `uvm_declare_p_sequencer(uvm_sequencer#(async_fifo_transaction_write))

        function new (string name = "");
            super.new(name);
        endfunction: new

        task body;
            repeat(200)
            begin
                simple_seq_write seq_write;
                seq_write = simple_seq_write::type_id::create("seq_write");
                assert( seq_write.randomize() );
                seq_write.start(p_sequencer);
            end
        endtask: body

    endclass: seq_of_commands_write

endpackage: sequences_write
`include "uvm_macros.svh"
package sequences_read;

    import uvm_pkg::*;

    class async_fifo_transaction_read extends uvm_sequence_item;
	// Register the async_fifo_transaction_read object.
        `uvm_object_utils(async_fifo_transaction_read)

        // input
        rand logic rrst_n;
        rand logic r_en;

        // output
        logic [31:0] data_out;
        logic empty;

        // Add constraints here
        // When the AFIFO is empty, we can't read more value
        // constraint async_fifo_empty {
        //   ( empty == 1'b1 ) -> ( r_en == 1'b0 );
        // }

        function new(string name = "");
            super.new(name);
        endfunction: new;
        
        function string convert2string;
            convert2string={$sformatf("r_en = %b, data_out = %b, empty = %b",r_en,data_out,empty)};
        endfunction: convert2string

    endclass: async_fifo_transaction_read

    // read sequence creation
    class simple_seq_read extends uvm_sequence #(async_fifo_transaction_read);
        `uvm_object_utils(simple_seq_read)

        function new(string name = "");
            super.new(name);
        endfunction: new

        task body;
            async_fifo_transaction_read tr;
            tr=async_fifo_transaction_read::type_id::create("tr");
            start_item(tr);
            assert(tr.randomize());
            finish_item(tr);
        endtask: body
    endclass: simple_seq_read

    class seq_of_commands_read extends uvm_sequence #(async_fifo_transaction_read);
        `uvm_object_utils(seq_of_commands_read)
        `uvm_declare_p_sequencer(uvm_sequencer#(async_fifo_transaction_read))

        function new (string name = "");
            super.new(name);
        endfunction: new

        task body;
            repeat(200)
            begin
                simple_seq_read seq_read;
                seq_read = simple_seq_read::type_id::create("seq_read");
                assert( seq_read.randomize() );
                seq_read.start(p_sequencer);
            end
        endtask: body

    endclass: seq_of_commands_read

endpackage: sequences_read
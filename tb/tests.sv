package tests;
`include "uvm_macros.svh"
import modules_pkg::*;
import uvm_pkg::*;
import sequences_read::*;
import sequences_write::*;
import scoreboard::*;

class test1 extends async_fifo_test;
    `uvm_component_utils(test1)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
	seq_of_commands_write seq_write;
    seq_of_commands_read seq_read;
	seq_write = seq_of_commands_write::type_id::create("seq_write");
    seq_read = seq_of_commands_read::type_id::create("seq_read");
	assert( seq_write.randomize() );
    assert( seq_read.randomize() );
	phase.raise_objection(this);
	seq_read.start(async_fifo_env_h.async_fifo_read_agent_h.async_fifo_read_sequencer_h);
    seq_write.start(async_fifo_env_h.async_fifo_write_agent_h.async_fifo_write_sequencer_h);
	phase.drop_objection(this);
    endtask: run_phase     
endclass: test1

//TODO: Add More Tests

endpackage: tests

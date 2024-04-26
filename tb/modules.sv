`include "uvm_macros.svh"
package modules_pkg;

import uvm_pkg::*;
import sequences_read::*;
import sequences_write::*;
import coverage::*;
import scoreboard::*;

typedef uvm_sequencer #(async_fifo_transaction_read) async_fifo_read_sequencer;
typedef uvm_sequencer #(async_fifo_transaction_write) async_fifo_write_sequencer;

class async_fifo_dut_config extends uvm_object;
    `uvm_object_utils(async_fifo_dut_config)

    virtual dut_write dut_vi_write;
    virtual dut_read dut_vi_read;

endclass: async_fifo_dut_config

class async_fifo_read_driver extends uvm_driver#(async_fifo_transaction_read); // TODO change alu_transaction_in to afifo
    `uvm_component_utils(async_fifo_read_driver)

    async_fifo_dut_config dut_config_0;
    virtual dut_read dut_vi_read;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
       assert( uvm_config_db #(async_fifo_dut_config)::get(this, "", "dut_config", dut_config_0));
       dut_vi_read = dut_config_0.dut_vi_read;
    endfunction : build_phase
   
    task run_phase(uvm_phase phase);
      forever
      begin
        // TODO change alu_transaction_in tx to our async fifo tx
        async_fifo_transaction_read tx;
        
        @(posedge dut_vi_read.rclk);
        seq_item_port.get(tx);
       
        // TODO: Drive values from async fifo tx onto the virtual
        // interface of dut_vi_read
        dut_vi_read.r_en <= tx.r_en;
        dut_vi_read.rrst_n <= tx.rrst_n;
      end
    endtask: run_phase

endclass: async_fifo_read_driver

class async_fifo_write_driver extends uvm_driver#(async_fifo_transaction_write); // TODO change alu_transaction_in to afifo
    `uvm_component_utils(async_fifo_write_driver)

    async_fifo_dut_config dut_config_0;
    virtual dut_write dut_vi_write;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
       assert( uvm_config_db #(async_fifo_dut_config)::get(this, "", "dut_config", dut_config_0));
       dut_vi_write = dut_config_0.dut_vi_write;
    endfunction : build_phase
   
    task run_phase(uvm_phase phase);
      forever
      begin
        // TODO change alu_transaction_in tx
        async_fifo_transaction_write tx;
        
        @(posedge dut_vi_write.wclk);
        // Get the sequence from the sequence
        seq_item_port.get(tx);
       
        // TODO: Drive values from alu_transaction_in onto the virtual
        // interface of dut_vi_in
        dut_vi_write.w_en <= tx.w_en;
        dut_vi_write.wrst_n <= tx.wrst_n;
        dut_vi_write.data_in <= tx.data_in;
      end
    endtask: run_phase

endclass: async_fifo_write_driver

class async_fifo_write_monitor extends uvm_monitor;
    `uvm_component_utils(async_fifo_write_monitor)

    uvm_analysis_port #(async_fifo_transaction_write) aport;

    async_fifo_dut_config dut_config_0;

    virtual dut_write dut_vi_write;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        dut_config_0=async_fifo_dut_config::type_id::create("config");
        aport=new("aport",this);
        // Not sure what this is about
        assert( uvm_config_db #(async_fifo_dut_config)::get(this, "", "dut_config", dut_config_0) );
        dut_vi_write=dut_config_0.dut_vi_write;
    endfunction: build_phase

    task run_phase(uvm_phase phase);
    @(posedge dut_vi_write.wclk);
      forever
      begin
        async_fifo_transaction_write tx;    // TODO: create async fifo tx
        @(posedge dut_vi_write.wclk);
        tx = async_fifo_transaction_write::type_id::create("tx");

	// TODO: Read the values from the virtual interface of dut_vi_in and
        // assign them to the transaction "tx"
        tx.full = dut_vi_write.full;
        tx.data_in = dut_vi_write.data_in;
        tx.w_en = dut_vi_write.w_en;
        tx.wrst_n = dut_vi_write.wrst_n;
        aport.write(tx);           // Write to the analysis port
        
      end
    endtask: run_phase

endclass: async_fifo_write_monitor

class async_fifo_read_monitor extends uvm_monitor;
    `uvm_component_utils(async_fifo_read_monitor)

    uvm_analysis_port #(async_fifo_transaction_read) aport; //TODO: change alu transaction

    async_fifo_dut_config dut_config_0;

    virtual dut_read dut_vi_read;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        dut_config_0=async_fifo_dut_config::type_id::create("config");
        aport=new("aport",this);
        assert( uvm_config_db #(async_fifo_dut_config)::get(this, "", "dut_config", dut_config_0) );
        dut_vi_read=dut_config_0.dut_vi_read;
    endfunction: build_phase

    task run_phase(uvm_phase phase);
    @(posedge dut_vi_read.wclk);
      forever
      begin
        async_fifo_transaction_read tx;    // TODO: create async fifo tx
        @(posedge dut_vi_read.wclk);
        tx = async_fifo_transaction_read::type_id::create("tx");

	// TODO: Read the values from the virtual interface of dut_vi_in and
        // assign them to the transaction "tx"
        tx.rrst_n = dut_vi_read.rrst_n;
        tx.r_en = dut_vi_read.r_en;
        tx.data_out = dut_vi_read.data_out;
        tx.empty = dut_vi_read.empty;
        aport.write(tx);           // read to the analysis port
        
      end
    endtask: run_phase

endclass: async_fifo_read_monitor

class async_fifo_write_agent extends uvm_agent;
    `uvm_component_utils(async_fifo_write_agent)

    uvm_analysis_port #(async_fifo_transaction_write) aport;  // TODO: change alu transaction to async_fifo_transaction_write

    async_fifo_write_sequencer async_fifo_write_sequencer_h;
    async_fifo_write_driver async_fifo_write_driver_h;
    async_fifo_write_monitor async_fifo_write_monitor_h;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new


    function void build_phase(uvm_phase phase);
        aport=new("aport",this);
        async_fifo_write_sequencer_h=async_fifo_write_sequencer::type_id::create("async_fifo_write_sequencer_h",this);
        async_fifo_write_driver_h=async_fifo_write_driver::type_id::create("async_fifo_write_driver_h",this);
        async_fifo_write_monitor_h=async_fifo_write_monitor::type_id::create("async_fifo_write_monitor_h",this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        async_fifo_write_driver_h.seq_item_port.connect(async_fifo_write_sequencer_h.seq_item_export);
        async_fifo_write_monitor_h.aport.connect(aport);
    endfunction: connect_phase

endclass: async_fifo_write_agent

class async_fifo_read_agent extends uvm_agent;
    `uvm_component_utils(async_fifo_read_agent)

    uvm_analysis_port #(async_fifo_transaction_read) aport;  // TODO: change alu transaction to async_fifo_transaction_read

    async_fifo_read_sequencer async_fifo_read_sequencer_h;
    async_fifo_read_driver async_fifo_read_driver_h;
    async_fifo_read_monitor async_fifo_read_monitor_h;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new


    function void build_phase(uvm_phase phase);
        aport=new("aport",this);
        async_fifo_read_sequencer_h=async_fifo_read_sequencer::type_id::create("async_fifo_read_sequencer_h",this);
        async_fifo_read_driver_h=async_fifo_read_driver::type_id::create("async_fifo_read_driver_h",this);
        async_fifo_read_monitor_h=async_fifo_read_monitor::type_id::create("async_fifo_read_monitor_h",this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        async_fifo_read_driver_h.seq_item_port.connect(async_fifo_read_sequencer_h.seq_item_export);
        async_fifo_read_monitor_h.aport.connect(aport);
    endfunction: connect_phase

endclass: async_fifo_read_agent

class async_fifo_env extends uvm_env;
    `uvm_component_utils(async_fifo_env)

    async_fifo_read_agent async_fifo_read_agent_h;
    async_fifo_write_agent async_fifo_write_agent_h;
    async_fifo_read_subscriber async_fifo_read_subscriber_h;
    async_fifo_write_subscriber async_fifo_write_subscriber_h;
    async_fifo_scoreboard async_fifo_scoreboard_h;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        async_fifo_read_agent_h = async_fifo_read_agent::type_id::create("async_fifo_read_agent_h",this);
        async_fifo_write_agent_h = async_fifo_write_agent::type_id::create("async_fifo_write_agent_h",this);
        async_fifo_read_subscriber_h = async_fifo_read_subscriber::type_id::create("async_fifo_read_subscriber_h",this);
        async_fifo_write_subscriber_h = async_fifo_write_subscriber::type_id::create("async_fifo_write_subscriber_h",this);
        async_fifo_scoreboard_h = async_fifo_scoreboard::type_id::create("async_fifo_scoreboard_h",this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        async_fifo_read_agent_h.aport.connect(async_fifo_read_subscriber_h.analysis_export);
        async_fifo_write_agent_h.aport.connect(async_fifo_write_subscriber_h.analysis_export);
        // TODO verify the scoreboard structure and connect them correctly
        async_fifo_read_agent_h.aport.connect(async_fifo_scoreboard_h.sb_read);
        async_fifo_write_agent_h.aport.connect(async_fifo_scoreboard_h.sb_write);
    endfunction: connect_phase

    function void start_of_simulation_phase(uvm_phase phase);
        //TODO: Set the verbosity of the testbench. By
        //default, it is UVM_MEDIUM
        uvm_top.set_report_verbosity_level_hier(UVM_DEBUG);
    endfunction: start_of_simulation_phase

endclass: async_fifo_env

class async_fifo_test extends uvm_test;
    `uvm_component_utils(async_fifo_test)

    async_fifo_dut_config dut_config_0;
    async_fifo_env async_fifo_env_h;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        dut_config_0 = new();
        if(!uvm_config_db #(virtual dut_read)::get( this, "", "dut_vi_read", dut_config_0.dut_vi_read))
          `uvm_fatal("NOVIF", "No virtual interface set for dut_read")
        
        if(!uvm_config_db #(virtual dut_write)::get( this, "", "dut_vi_write", dut_config_0.dut_vi_write))
          `uvm_fatal("NOVIF", "No virtual interface set for dut_write")
            
        uvm_config_db #(async_fifo_dut_config)::set(this, "*", "dut_config", dut_config_0);
        async_fifo_env_h = async_fifo_env::type_id::create("async_fifo_env_h", this);
    endfunction: build_phase

endclass:async_fifo_test

endpackage: modules_pkg



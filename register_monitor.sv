class register_monitor extends uvm_monitor;

//factory registration
`uvm_component_utils(register_monitor)
  
  //virtual interface handle declaration
  virtual register_interface reg_vintf;
  
  //uvm analysis port declaration.
  uvm_analysis_port#(register_seq_item) item_collected_port;
  //transaction class handle declaration
  register_seq_item trans_collected;
  
  //default constructor
  function new(string name,uvm_component parent);
    super.new(name,parent);
     item_collected_port=new("item_collected_port",this);
  endfunction:new
 
  
virtual function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 if(! uvm_config_db#(virtual register_interface)::get(this," ","reg_vintf",this.reg_vintf))
 `uvm_fatal(get_full_name(),"first set the reg_vintf");
// item_collected_port=new("item_collected_port",this);
endfunction:build_phase

  
task run_phase(uvm_phase phase);
 @(posedge reg_vintf.monitor_modp.clk);
 wait(reg_vintf.monitor_modp.rst_n);//we are waiting upto the reset operation is done.
  
forever begin:forever_begin
trans_collected=register_seq_item::type_id::create("trans_collected");
 sample_dut();
end:forever_begin
    
endtask:run_phase

//capature task for the collecting the signal values from interface 
virtual task sample_dut();
  @(posedge reg_vintf.monitor_modp.clk);
  @(negedge reg_vintf.monitor_modp.clk);
  
wait(reg_vintf.monitor_modp.wr==1'b1 || reg_vintf.monitor_modp.rd==1'b1);
  
  if(reg_vintf.monitor_modp.wr == 1'b1) begin:write
  
   trans_collected.addr = reg_vintf.monitor_modp.addr;
   trans_collected.wr   = reg_vintf.monitor_modp.wr;
   trans_collected.wr_data = reg_vintf.monitor_modp.wr_data;
   trans_collected.rd = reg_vintf.monitor_modp.rd;
  `uvm_info(get_full_name(), {"REGISTER_MONITOR WRITE MODE COLLECTION \n", trans_collected.sprint()}, UVM_NONE);
    item_collected_port.write(trans_collected);
  end:write
  
if(reg_vintf.monitor_modp.rd == 1'b1) begin:read
  
   trans_collected.addr = reg_vintf.monitor_modp.addr;
   trans_collected.wr   = reg_vintf.monitor_modp.wr;
   trans_collected.wr_data = reg_vintf.monitor_modp.wr_data;
   trans_collected.rd = reg_vintf.monitor_modp.rd;
    @(posedge reg_vintf.monitor_modp.clk);
    @(negedge reg_vintf.monitor_modp.clk);
    trans_collected.rd_data = reg_vintf.monitor_modp.rd_data;
  `uvm_info(get_full_name(), {"REGISTER_MONITOR READ MODE COLLECTION \n", trans_collected.sprint()}, UVM_NONE);
  item_collected_port.write(trans_collected);
end:read
  
endtask:sample_dut
  
endclass:register_monitor


//sequencer class for the register agent.
class register_sequencer extends uvm_sequencer#(register_seq_item);
  
  bit [7:0] ctrl_reg_data;
  bit [7:0] pay_load_size;
  bit [7:0] repeat_count;
  
//factory registration
`uvm_component_utils(register_sequencer)
  
  //default constructor
  function new(string name,uvm_component parent);
  super.new(name,parent);
  endfunction:new
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(! uvm_config_db#(int)::get(this,this.get_full_name(),"pay_load_size",pay_load_size))
`uvm_fatal(get_full_name()," FIRST CONFIG THE  SET METHOD OF \" pay_load_size \" ");
       
    if(! uvm_config_db#(int)::get(this,this.get_full_name(),"ctrl_reg_data",ctrl_reg_data))
`uvm_fatal(get_full_name()," FIRST CONFIG THE  SET METHOD OF \" ctrl_reg_data \" "); 
        
    if(! uvm_config_db#(int)::get(this,this.get_full_name(),"repeat_count" ,repeat_count))
`uvm_fatal(get_full_name()," FIRST CONFIG THE  SET METHOD OF \" repeat_count \" ");
       
  endfunction:build_phase 
  
endclass:register_sequencer
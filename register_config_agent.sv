

class register_config_agent extends uvm_object;

//factory registration
`uvm_object_utils(register_config_agent)
  
  
uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  //some flags required for the monitor for send the samples to scoreboard based this flags.
  //
  enum {byte_by_byte,complete_packet} send_samples = byte_by_byte;
  
  
//default constructor.
  function new(string name ="register_config_agent");
    super.new(name);
  endfunction:new
  
endclass:register_config_agent  
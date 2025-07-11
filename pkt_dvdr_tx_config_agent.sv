

class pkt_dvdr_tx_config_agent extends uvm_object;
  
//factory registration.
`uvm_object_utils(pkt_dvdr_tx_config_agent)
 
uvm_active_passive_enum is_active = UVM_PASSIVE;
  
  
//default constructot
  function new(string name = "pkt_dvdr_tx_config_agent");
    super.new(name);
  endfunction:new
  
  
endclass:pkt_dvdr_tx_config_agent
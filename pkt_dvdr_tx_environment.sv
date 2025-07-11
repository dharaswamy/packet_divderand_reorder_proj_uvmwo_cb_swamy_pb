
class pkt_dvdr_tx_environment extends uvm_env;

//factory registration.
  `uvm_component_utils(pkt_dvdr_tx_environment)
  
  //config agent class declaration
  pkt_dvdr_tx_config_agent tx_cfg_agent;
  //tx agent class handle declartion.
  pkt_dvdr_tx_agent tx_agent;
  
  //default constructor
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction:new
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //creating the tx config agent class.
    tx_cfg_agent = pkt_dvdr_tx_config_agent::type_id::create("tx_cfg_agent",this);
    uvm_config_db#(pkt_dvdr_tx_config_agent)::set(this,"*","tx_cfg_agent",tx_cfg_agent);
    // creating the tx agent classs.
    tx_agent = pkt_dvdr_tx_agent::type_id::create("tx_agent",this);
  endfunction:build_phase
  
endclass:pkt_dvdr_tx_environment
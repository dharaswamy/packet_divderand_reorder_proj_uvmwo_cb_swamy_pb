
class pkt_dvdr_environment extends uvm_env;
  
//factory registration
  `uvm_component_utils(pkt_dvdr_environment)
  
//environment class handle declaration
  register_environment reg_env;
  
//tx environment class handle declaration.
  pkt_dvdr_tx_environment tx_env;
  
//scorboard class handle declaration.
  scoreboard scb;
  
  
//default constructor 
function new(string name ,uvm_component parent);
 super.new(name,parent);
endfunction:new

virtual function void build_phase(uvm_phase phase);
 super.build_phase(phase);
//register environment class creation.
reg_env=register_environment::type_id::create("reg_env",this);
//creating the environment.
tx_env = pkt_dvdr_tx_environment::type_id::create("tx_env",this);
 scb=scoreboard::type_id::create("scb",this);
endfunction:build_phase

  
//connect phase for connecting the analysis ports between the components.
virtual function void connect_phase(uvm_phase phase);
 super.connect_phase(phase);
 //connecting the reg_mntr to scb for sending the transactions through analysis ports.
 //here reg_agent analysis port already connected to the reg_mntr analysis port.
 reg_env.reg_agent.item_collected_port.connect(scb.reg_mntr2scb);
  //connecting the tx_mntr to scb for sending the transactions through analysis ports.
 //here tx_agent analysis port already connected to the tx_mntr analysis port.
  tx_env.tx_agent.item_collected_port.connect(scb.tx_mntr2scb);
endfunction:connect_phase
  
  
endclass:pkt_dvdr_environment
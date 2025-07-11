`uvm_analysis_imp_decl(_reg_mntr)
`uvm_analysis_imp_decl(_tx_mntr)
class scoreboard extends uvm_scoreboard;
  
//factory registration
  `uvm_component_utils(scoreboard)
//uvm analysis imp port declaration.
uvm_analysis_imp_reg_mntr#(register_seq_item,scoreboard) reg_mntr2scb;
uvm_analysis_imp_tx_mntr#(pkt_dvdr_tx_seq_item,scoreboard) tx_mntr2scb;

  
//register transaction class handle declaration
  register_seq_item  reg_pkt_qu[$];  

  function new(string name,uvm_component parent);
    super.new(name,parent);
    reg_mntr2scb=new("reg_mntr2scb",this);
    tx_mntr2scb =new("tx_mntr2scb",this);
  endfunction:new

virtual function void build_phase(uvm_phase phase);
 super.build_phase(phase);
// reg_mntr2scb=new("reg_mntr2scb",this);
endfunction:build_phase

  //write method for collecting the seq items from the register monitor.
  virtual function void write_reg_mntr(register_seq_item reg_pkt);
    `uvm_info(get_full_name(),{" SCOREBORAD GOT PKT FROM THE REGISTER_AGENT, REG_MNTR \n",reg_pkt.sprint()},UVM_NONE);
  endfunction:write_reg_mntr
  
  //write method for the collecting the seq items from the tx_monitor
  virtual function void write_tx_mntr(pkt_dvdr_tx_seq_item tx_pkt);
    `uvm_info(get_full_name(),{" SCOREBORAD GOT PKT FROM THE TRANSMIT_AGNET,TX_MNTR \n",tx_pkt.sprint()},UVM_NONE); 
  endfunction:write_tx_mntr
  
  
  
  
endclass:scoreboard
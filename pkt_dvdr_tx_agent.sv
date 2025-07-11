
class pkt_dvdr_tx_agent extends uvm_agent;
  
//factory registration
`uvm_component_utils(pkt_dvdr_tx_agent)

  //analysis port declaration
  uvm_analysis_port#(pkt_dvdr_tx_seq_item) item_collected_port;
  
  //config agent class declaration
  pkt_dvdr_tx_config_agent tx_cfg_agent;
  
  //pkt dvdr tx sequencer class handle declartion.
  pkt_dvdr_tx_sequencer tx_seqr;
  //pkt dvdr tx driver class handle declaration.
  pkt_dvdr_tx_driver tx_driv;
  //pkt drdr tx monitor class handle declartion.
  pkt_dvdr_tx_monitor tx_mntr;
  
  function new(string name ,uvm_component parent);
    super.new(name,parent);
    //analysis port creation.
  item_collected_port = new("item_collected_port",this);
endfunction:new
  
  
virtual function void build_phase(uvm_phase phase);
 super.build_phase(phase);
  if(! uvm_config_db#(pkt_dvdr_tx_config_agent)::get(this, " ","tx_cfg_agent",tx_cfg_agent))
 `uvm_fatal(get_name(),"FIRST SET THE CONFIG DB SET METHOD OF \"tx_cfg_agent\" pkt_dvdr_tx_config_agent class handle " );
  if(tx_cfg_agent.is_active == UVM_ACTIVE ) begin
  
 //sequencer class creation
  tx_seqr = pkt_dvdr_tx_sequencer::type_id::create("tx_seqr",this);
  //driver class creation.
  tx_driv = pkt_dvdr_tx_driver::type_id::create("tx_driv",this);
  `uvm_info(get_name()," pkt_dvdr_tx_agent is configured as a \" ACTIVE AGNET\" ",UVM_NONE);
  end
  else  `uvm_info(get_name()," pkt_dvdr_tx_agent is configured as a \" PASSIVE AGNET\" ",UVM_NONE); 
  
  //monitor class creation
  tx_mntr = pkt_dvdr_tx_monitor::type_id::create("tx_mntr",this);
  
  
  endfunction:build_phase
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
     if(tx_cfg_agent.is_active == UVM_ACTIVE ) begin
       tx_driv.seq_item_port.connect(tx_seqr.seq_item_export);
     end
    tx_mntr.item_collected_port.connect(this.item_collected_port);
  endfunction:connect_phase
  
endclass:pkt_dvdr_tx_agent
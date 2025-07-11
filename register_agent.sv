//agent for the registers
class register_agent extends uvm_agent;
  
//factory registration
`uvm_component_utils(register_agent)
  
  //register config agent class handle declaration.
  register_config_agent  reg_cfg_agent;
//register sequencer class handle declaration
  register_sequencer reg_seqr;
//register driver class handle declaration
  register_driver reg_driv;
//register monitor class handle declaration
  register_monitor reg_mntr;
  
//uvm analysis port declaration
uvm_analysis_port#(register_seq_item) item_collected_port;
  
//default constructor
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction:new

  //build phase function for creating the sequecer,driver ,monitor in register agent
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
 if(! uvm_config_db#(register_config_agent)::get(this," " ,"reg_cfg_agent",this.reg_cfg_agent) )
  `uvm_fatal(get_name()," first set the config db of \" reg_cfg_agent \" " );
    
    if(reg_cfg_agent.is_active == UVM_ACTIVE ) begin
    //sequencer class  create
    reg_seqr=register_sequencer::type_id::create("reg_seqr",this);
    //driver class create.
    reg_driv=register_driver::type_id::create("reg_driv",this);
    `uvm_info(get_name()," REGISTER AGENT IS CONFIGURED AS A \" ACTIVE AGENT \" ",UVM_NONE); 
    end
    else  `uvm_info(get_name()," REGISTER AGENT IS CONFIGURED AS A \" PASSIVE AGENT \" ",UVM_NONE); 
    
    //monitor class create.
    reg_mntr=register_monitor::type_id::create("reg_mntr",this);
    //analysis port create.
    item_collected_port=new("item_collected_port",this);
    
    
  endfunction:build_phase
  
  
  //connect phase for the connecting the driver and sequencer.
virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
  if(reg_cfg_agent.is_active == UVM_ACTIVE ) begin
 //establishing the connection b/w the driver and sequencer through ".connect" of seq_item_port.connect seq_item_export.
reg_driv.seq_item_port.connect(reg_seqr.seq_item_export);
  end
//we are connecting the reg_mntr analysis port to the this agent class analysis port.
reg_mntr.item_collected_port.connect(this.item_collected_port);
endfunction:connect_phase
  
  
endclass:register_agent
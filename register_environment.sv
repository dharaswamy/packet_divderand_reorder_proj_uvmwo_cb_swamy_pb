class register_environment extends uvm_env;

  //factory registration
  `uvm_component_utils(register_environment)
  
  //register agent class handle declaration.
  register_agent reg_agent;
  
  //register configuration agent class handle declaration.
  register_config_agent reg_cfg_agent;
  
  
  //default construnctor
  function new(string name ,uvm_component parent);
    super.new(name,parent);
  endfunction:new
  
  //build phase for agent components creation.
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    //register agent creation.
    reg_cfg_agent =register_config_agent::type_id::create("reg_cfg_agent");
     uvm_config_db#(register_config_agent)::set(this,"*","reg_cfg_agent",reg_cfg_agent);
    reg_agent=register_agent::type_id::create("reg_agent",this);
   
   
  endfunction:build_phase
  

endclass:register_environment

class ctrl_test extends base_test;
  
//factory registration
  `uvm_component_utils(ctrl_test)
  
  //sequence class handle declaration
  register_sequence reg_sequ;
  
  //register config agent class handle declaration.
  register_config_agent  reg_cfg_agent;
  
  //default construnctor
  function new(string name,uvm_component parent);
    super.new(name,parent);
    reg_cfg_agent=new();
  endfunction:new
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(int)::set(this,"*","pay_load_size",2);
    uvm_config_db#(int)::set(this,"*","ctrl_reg_data",8'b0100_0000);
    uvm_config_db#(int)::set(this,"*","repeat_count",1);
    //sequence creation
    reg_sequ=register_sequence::type_id::create("reg_sequ");
  //reg_cfg_agent = register_config_agent::type_id::create("reg_cfg_agent",this);
   endfunction:build_phase
 
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    if(pkt_dvdr_env.reg_env.reg_cfg_agent.is_active == UVM_ACTIVE ) begin
      reg_sequ.start(pkt_dvdr_env.reg_env.reg_agent.reg_seqr);
    end
   // #500;
    //phase.phase_done.set_drain_time(this,280);
    phase.drop_objection(this);
    phase.phase_done.set_drain_time(this,2000);
  endtask:run_phase
  
endclass:ctrl_test
class base_test extends uvm_test;
  //factory registration.
  `uvm_component_utils(base_test)
  
  //pkt_dvdr_environment class handle declaration.this env contains the 1.register_environment,2.pkt_dvdr_tx_environment,3.pkt_dvdr_rx_environment.(but pkt_dvdr_rx is pending).
  pkt_dvdr_environment pkt_dvdr_env;
  //factory print and topology print 
  uvm_factory factory;
  uvm_coreservice_t cs=uvm_coreservice_t::get();
  
  
  //default constructor
  function new(string name,uvm_component parent);
  super.new(name,parent);
  endfunction:new

  //build phase for the creation of environments
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //creation of environment.
    pkt_dvdr_env = pkt_dvdr_environment::type_id::create("pkt_dvdr_env",this);
 endfunction:build_phase
  
  //end_of_elaboration_phase for any final adjustments in components before going of start_run_phase.
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    this.print();
    factory=cs.get_factory();
    factory.print();
    
    
  endfunction:end_of_elaboration_phase
  
  //start of simulation phase
  virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    uvm_top.print_topology();
  endfunction:start_of_simulation_phase
  
endclass:base_test
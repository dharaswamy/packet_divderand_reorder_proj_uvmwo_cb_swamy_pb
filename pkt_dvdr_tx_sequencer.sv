


class pkt_dvdr_tx_sequencer extends uvm_sequencer#(pkt_dvdr_tx_seq_item);

// factory registration ,this is a component class so uvm_component_utils macro use for the registration
`uvm_component_utils(pkt_dvdr_tx_sequencer)

  //default constructor
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction:new
  
endclass:pkt_dvdr_tx_sequencer
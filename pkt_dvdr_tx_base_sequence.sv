


class pkt_dvdr_tx_base_sequence extends uvm_sequence#(pkt_dvdr_tx_seq_item);
 
//factory registration
  `uvm_object_utils(pkt_dvdr_tx_base_sequence)
  
  //default constructor
  function new(string name = "pkt_dvdr_tx_base_sequence");
    super.new(name);
  endfunction:new
               
  
endclass:pkt_dvdr_tx_base_sequence


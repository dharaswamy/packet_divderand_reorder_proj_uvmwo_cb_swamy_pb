

class pkt_dvdr_tx_seq_item extends uvm_sequence_item;
 

//analysis fields 
bit tx_en;
bit [7:0] tx_data;

//packet format required fields.
  bit [7:0] sop;
  bit [7:0] length;
  bit [7:0] data[];//dynamic array for storing the payload 
  bit [7:0] pad;
  bit [7:0] parity;
  bit [7:0] eop;
  
//default constructor or new function call
  function new(string name = "pkt_dvdr_tx_seq_item");
    super.new(name);
  endfunction:new
  
 
  //factory registration fields ,this is a object class so uvm_objectd_utils with fields.
  `uvm_object_utils_begin(pkt_dvdr_tx_seq_item)
  `uvm_field_int(tx_en,UVM_ALL_ON)
  `uvm_field_int(tx_data,UVM_ALL_ON)
  `uvm_field_int(sop,UVM_ALL_ON)
  `uvm_field_int(length,UVM_ALL_ON)
  `uvm_field_array_int(data,UVM_ALL_ON)
  `uvm_field_int(pad,UVM_ALL_ON)
  `uvm_field_int(parity,UVM_ALL_ON)
  `uvm_field_int(eop,UVM_ALL_ON)
  `uvm_object_utils_end
  
endclass:pkt_dvdr_tx_seq_item
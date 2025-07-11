class register_seq_item extends uvm_sequence_item;

  //randomization fields.
  rand bit [2:0] addr;
  rand bit wr;
  rand bit [7:0] wr_data;
  rand bit rd;
  rand bit [7:0] tx_length;//length of data to transmit.
  rand bit [7:0] payload_size;
  
  rand bit cmd;
  
 //analysis fields.
  bit [7:0] data[];//i'm taking dynamic array for bytes of payload.
  bit [7:0]  rd_data;
  bit int_n;
  bit [2:0] divisor;
  bit parity;
  bit soft_reset;
  bit  pad;
   
constraint payload_size_const{soft payload_size inside{[1:100]};}
//constraint data_ary_size_const{soft data.size() == payload_size;}
//constraint data_ary_uvalues_const{unique {data};}
constraint cmd_const{soft cmd==1;}
//constraint wr_rd_const{ wr != rd;}
  
  
  //default constructor
  function new(string name="register_seq_item");
    super.new(name);
  endfunction:new
  
  //factory registration
  `uvm_object_utils_begin(register_seq_item)
  `uvm_field_int(addr,UVM_ALL_ON)
  `uvm_field_int(wr,UVM_ALL_ON)
  `uvm_field_int(wr_data,UVM_ALL_ON)
  `uvm_field_int(rd,UVM_ALL_ON)
  `uvm_field_int(rd_data,UVM_ALL_ON)
  `uvm_field_int(tx_length,UVM_ALL_ON)
  `uvm_field_int(payload_size,UVM_ALL_ON)
  `uvm_field_array_int(data,UVM_ALL_ON)
  `uvm_field_int(cmd,UVM_ALL_ON)
 
  `uvm_object_utils_end
   
endclass:register_seq_item
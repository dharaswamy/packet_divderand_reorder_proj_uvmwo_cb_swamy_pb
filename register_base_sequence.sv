
//base sequence class for the register agent.

class register_base_sequence extends uvm_sequence#(register_seq_item);

 // typedef enum{  
 
//factory registration
  `uvm_object_utils_begin(register_base_sequence)
  `uvm_object_utils_end
  
 //  enum bit {WRITE=1} wr_enum;
  
  function new(string name="register_base_sequence");
    super.new();
  endfunction:new
  
  //write sequence for user specified addr 
virtual task write_sequ_w_addr(input bit [2:0] m_addr);
    //creating the object for transaction class "register_seq_item"
    req=register_seq_item::type_id::create("req");
    start_item(req);
  req.randomize() with{addr == m_addr; wr == 1'b1; rd == 1'b0;};
  `uvm_info(get_name(),$sformatf("\n %0s",req.sprint()),UVM_DEBUG);
    finish_item(req);
endtask:write_sequ_w_addr
  
  //write sequence for user specified addr and data;
virtual task write_sequ_w_addr_data(input bit [2:0] m_addr,input bit[7:0]m_data);
    //creating the object for transaction class "register_seq_item"
    req=register_seq_item::type_id::create("req");
    start_item(req);
  req.randomize() with{addr == m_addr; wr_data == m_data; wr == 1'b1 ; rd == 1'b0; };
  `uvm_info(get_name(),$sformatf("\n %0s",req.sprint()),UVM_DEBUG);
    finish_item(req);
endtask:write_sequ_w_addr_data
 
 //read sequence for user specified addr
  virtual task read_sequ(input bit [2:0] m_addr);
    //creating the object for transaction class "register_seq_item"
    req=register_seq_item::type_id::create("req");
    start_item(req);
    req.randomize() with{addr == m_addr; rd == 1'b1; wr == 1'b0;};
 `uvm_info(get_name(),$sformatf("READ_SEQU_WITH  \n %0s",req.sprint()),UVM_DEBUG);
   finish_item(req);
   
endtask:read_sequ
  
  virtual task read_sequ_w_get_rsp(input bit [2:0] m_addr,output bit [7:0] temp_rd_data);
//creating the object for the transaction class "register_seq_item"
  req=register_seq_item::type_id::create("req");
    start_item(req);
    req.randomize() with{addr == m_addr; rd == 1'b1; wr == 1'b0;};
    finish_item(req);
    get_response(rsp);
    $display("read sequence time=%0t rsp.rd_data =%b",$time,rsp.rd_data);
    temp_rd_data = rsp.rd_data;
`uvm_info(get_name(),$sformatf("READ_SEQU_WITH GET RESPONSE \n %0s",req.sprint()),UVM_DEBUG);
    
endtask:read_sequ_w_get_rsp
    
  
endclass:register_base_sequence

////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////

class register_sequence extends register_base_sequence;

enum bit[2:0] {CMD_REG_ADDR,CTRL_REG_ADDR,TX_LENGTH_REG_ADDR,RX_LENGTH_REG_ADDR
     ,RX_INTR_REG_ADDR,STATUS_REG_ADDR,TX_FIFO_REG_ADDR,RX_FIFO_REG_ADDR} reg_addrs;
  
  bit [7:0] ctrl_reg_data;
  bit [7:0] pay_load_size;
  bit [7:0] repeat_count;
  bit [2:0] m_addr;
  bit [7:0] temp_rd_data;
  bit tx_busy =1'b1;
  bit tx_busy_1 =1'b1;
  
//FACTORY REGISTORY
  `uvm_object_utils(register_sequence)
  
  `uvm_declare_p_sequencer(register_sequencer) 
  
  //handle declaration for the register_sequencer.
  register_sequencer reg_seqr1;
  
  //default constructor.
  function new(string name="register_sequence");
    super.new();
  endfunction:new
  
  virtual task pre_start();
  $cast(reg_seqr1,m_sequencer);
  ctrl_reg_data = reg_seqr1.ctrl_reg_data;
  pay_load_size = reg_seqr1.pay_load_size;
  repeat_count = reg_seqr1.repeat_count;
  endtask:pre_start
  
virtual task body();
    
repeat(repeat_count) begin:repeat_begin
  
  while(tx_busy == 1'b1) begin:while_begin
 read_sequ_w_get_rsp(.m_addr(5),.temp_rd_data(temp_rd_data));
  `uvm_info(get_name(),$sformatf("STATUS_REGISTER TX_BUSY =%0B",temp_rd_data[0]),UVM_NONE);
    if(temp_rd_data[0] != 1'b1) begin
    tx_busy = 1'b0;
      `uvm_info(get_name(),$sformatf("\n STATUS_REGISTER TX_BUSY =%0B -------------SO PROCCED TO START REGISTERS CONFIGRATION-----------------",temp_rd_data[0]),UVM_NONE);
    end
  //we need some delay here using interfacfe. clk before starts the register configaration.
  end:while_begin
  
   `uvm_info(get_name(),"\n--------------REGISTER CONFIGARATION IS STARTED---------------",UVM_NONE);

//configuration for the payload to tx_fifo addr=6;
 repeat(pay_load_size) begin:pay_load_size_begin
  write_sequ_w_addr(.m_addr(6));
 end:pay_load_size_begin
//write sequence for configuration of the tx_length register.
  write_sequ_w_addr_data(.m_addr(2),.m_data(pay_load_size));//here the tx_length is equal to the payload_size i want to transmit whole payload .
//write sequence for configuration of the ctrl register.
  write_sequ_w_addr_data(.m_addr(1),.m_data(ctrl_reg_data));
//write sequence for the configuration of the cmd register.
write_sequ_w_addr_data(.m_addr(0),.m_data(8'b0000_0001));
`uvm_info(get_name(),"\n <<<<<<<<<<<<<<<<<<REGISTER CONFIGARATION IS COMPLETED>>>>>>>>>>>>>>>>>",UVM_NONE);
  tx_busy=1'b1; 
  `uvm_do_with(req,{wr==1'b0;rd==1'b0;})  
end:repeat_begin
/*
//this logic for the setting the drian time becuse after configuration ,the dut takes the time to transmit the data for that it takes time to processing the data and send so we are setting the some drain time here,other wise uvm_root is takes action all runphases are drop objection so it is processed to go to cleanup phase ,due to this you not get dut output waveforms. 
while(tx_busy_1 == 1'b1) begin:while2
read_sequ_w_get_rsp(.m_addr(5),.temp_rd_data(temp_rd_data));  
if(temp_rd_data[0] != 1'b1) begin
 tx_busy_1 =1'b0;
  end
  
  
end:while2*/

  
endtask:body

  
endclass:register_sequence

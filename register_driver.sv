class register_driver extends uvm_driver#(register_seq_item);

//factory registration
`uvm_component_utils(register_driver)
  
//virtual interface handle declartion
virtual register_interface reg_vintf;
  
  //default constructor
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction:new

  //build_phase function
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(! uvm_config_db#(virtual register_interface)::get(this," ","reg_vintf",this.reg_vintf))
   `uvm_fatal(get_full_name()," set the reg_vintf from top or test ");
  endfunction:build_phase
       
  //run phase
virtual task run_phase(uvm_phase phase);
 super.run_phase(phase);
 reset();// here we call reset task.     
forever begin:forever_begin
  req=register_seq_item::type_id::create("req");
seq_item_port.get_next_item(req); 

  drive();
 `uvm_info("REG_DRV_RUN", {"\n", req.sprint()}, UVM_NONE);
end:forever_begin
  
endtask:run_phase

virtual task drive();
@(posedge reg_vintf.driver_modp.clk);

if(req.wr==1'b1 && req.rd==1'b0) begin:write

reg_vintf.driver_modp.addr <= req.addr;
reg_vintf.driver_modp.wr <= req.wr;
reg_vintf.driver_modp.wr_data <= req.wr_data;
reg_vintf.driver_modp.rd <= req.rd;
seq_item_port.item_done();
end:write
  
else if(req.rd ==1'b1 && req.wr ==1'b0) begin:read
reg_vintf.driver_modp.addr <= req.addr;
reg_vintf.driver_modp.wr <= req.wr;
reg_vintf.driver_modp.wr_data <= req.wr_data;
reg_vintf.driver_modp.rd <= req.rd;
@(posedge reg_vintf.driver_modp.clk);
reg_vintf.driver_modp.wr <= 1'B0;
reg_vintf.driver_modp.rd <= 1'B0;
@(negedge reg_vintf.driver_modp.clk);
req.rd_data = reg_vintf.driver_modp.rd_data;
$display("time=%0t rx_driver reg_vintf.rd_data =%b",$time,reg_vintf.driver_modp.rd_data);  
$display("time=%0t rx_driver req.rd_data =%b",$time,req.rd_data);
$cast(rsp,req.clone());
rsp.set_id_info(req); // Set the rsp_item sequence id to match req
seq_item_port.item_done();
seq_item_port.put(rsp);
end:read
  
else if(req.wr == 1'b0 && req.rd == 1'b0) begin:not_write_read
reg_vintf.driver_modp.addr <= req.addr;
reg_vintf.driver_modp.wr <= req.wr;
reg_vintf.driver_modp.wr_data <= req.wr_data;
reg_vintf.driver_modp.rd <= req.rd; 
seq_item_port.item_done();
 end:not_write_read
 
else begin
  if(req.wr == 1'b1 && req.rd == 1'b1) begin
`uvm_fatal(get_name(),$sformatf("INVALID randomization both wr = %0b and rd =%0b ",req.wr,req.rd)); 
 seq_item_port.item_done();
  end
 
end
  
endtask:drive
  
//task for the reset operation 
virtual task reset();
@(posedge reg_vintf.driver_modp.clk);
wait(! reg_vintf.driver_modp.rst_n);//according to the specfication of dut,the reset is a active low reset.
`uvm_info(get_name(),$sformatf(" RESET OF DUT IS STARTED  \"active low reset rst_n =%0b \" " ,reg_vintf.driver_modp.rst_n),UVM_NONE);
reg_vintf.driver_modp.addr <= 1'b0;
reg_vintf.driver_modp.wr <=1'b0;
reg_vintf.driver_modp.wr_data <= 8'h00;
reg_vintf.driver_modp.rd <= 1'b0;
@(posedge reg_vintf.driver_modp.clk);
wait( reg_vintf.driver_modp.rst_n);
`uvm_info(get_name(),$sformatf(" RESET OF DUT IS COMPLETED \"active low reset rst_n =%0b \" " ,reg_vintf.driver_modp.rst_n),UVM_NONE);
endtask:reset
  
endclass:register_driver
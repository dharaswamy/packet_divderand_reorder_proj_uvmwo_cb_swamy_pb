


class pkt_dvdr_tx_driver extends uvm_driver#(pkt_dvdr_tx_seq_item);
 
//factory registration
`uvm_component_utils(pkt_dvdr_tx_driver)
  
// pkt_dvdr_tx_intt virtual interface handle declaration.
virtual pkt_dvdr_transmit_intf  tx_vintf;
  
//default constructor.
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction:new
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(! uvm_config_db#(virtual pkt_dvdr_transmit_intf)::get(this," ","tx_vintf",tx_vintf))
   `uvm_fatal(get_name()," FIRST SET THE CONFIG DB SET METHOD OF \" tx_vintf \" of pkt_dvdr_transmit_intf virtual inteface ");
endfunction:build_phase

       virtual task run_phase(uvm_phase phase);
         super.run_phase(phase);
        // forever begin:forever_begin
          // seq_item_port.get_next_item(req);
           //`uvm_info(get_name(),$sformatf("  TX_DRIVER GOT ITEM \N %0S ",req.sprint()),UVM_NONE);
           //seq_item_port.item_done(req);
         //end:forever_begin
         #300;
       endtask:run_phase
       
endclass:pkt_dvdr_tx_driver
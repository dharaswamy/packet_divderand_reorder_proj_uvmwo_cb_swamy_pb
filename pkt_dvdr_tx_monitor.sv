
class pkt_dvdr_tx_monitor extends uvm_monitor;

//factory registration
`uvm_component_utils(pkt_dvdr_tx_monitor)
  
//transmit interface handle 
virtual pkt_dvdr_transmit_intf tx_vintf;
  
//analysis port class handle declaration.
uvm_analysis_port#(pkt_dvdr_tx_seq_item) item_collected_port;
  
//pkt dvdr transmit class handle declaration.
pkt_dvdr_tx_seq_item  item_collected;
  
//default constructor
  function new(string name,uvm_component parent);
    super.new(name,parent);
    //analysis port creation.
    item_collected_port = new("item_collected_port",this);
  endfunction:new
  
virtual function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 if(! uvm_config_db#(virtual pkt_dvdr_transmit_intf)::get(this," ","tx_vintf",tx_vintf))
 `uvm_fatal(get_name()," FIRST SET THE CONFIG DB SET METHOD OF \" tx_vintf \" of pkt_dvdr_transmit_intf virtual inteface ");
 endfunction:build_phase
  

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    forever begin:forever_begin
     // phase.raise_objection(this);
      item_collected=pkt_dvdr_tx_seq_item::type_id::create("item_collected",this);
      //@(posedge tx_vintf.monitor_modp.clk);
      wait(tx_vintf.monitor_modp.tx_en);
      @(negedge tx_vintf.monitor_modp.clk);
      if(tx_vintf.monitor_modp.tx_en == 1'b1) begin
       item_collected.tx_data = tx_vintf.monitor_modp.tx_data;
      item_collected.tx_en = tx_vintf.monitor_modp.tx_en;
         `uvm_info("PKT_DVDR_TX_MNTR",$sformatf(" TX_MONITOR COLLECTION %0s",item_collected.sprint()),UVM_NONE);
        item_collected_port.write(item_collected);
       end
      //phase.drop_objection(this);
    end:forever_begin
  endtask:run_phase
  
endclass:pkt_dvdr_tx_monitor
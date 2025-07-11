

interface pkt_dvdr_transmit_intf(input logic clk,rst_n);

// out packet data transmit enable signal
logic tx_en;
  
//output packet data transmit signal
//packet comes out byte by byte format of
// _______________________________________
// |sop|len|d1|d1|d2|dn|padding|parity|eop|
//-----------------------------------------
logic [7:0] tx_data;
  

  

 
  
  modport driver_modp(input clk,rst_n,output tx_en,tx_data);
  modport monitor_modp(input clk,rst_n,tx_en,tx_data);
  
endinterface:pkt_dvdr_transmit_intf
  




  /* clocking driver_cb@(posedge clk);
  default input#1 output#0;
    input tx_en;
    input tx_data;
  endclocking:driver_cb
  
  clocking monitor_cb@(posedge clk);
   default input#1 output#0;
    input tx_en;
    input tx_data;
    
  endclocking:monitor_cb */
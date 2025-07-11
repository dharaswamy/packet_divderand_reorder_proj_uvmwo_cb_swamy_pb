// Code your design here

module pkt_dvdr_reg_tx_dut(input clk,
                           input rst_n,
                           input [2:0]  addr,
                           input wr,
                           input rd,
                           input [7:0] wr_data,
                           output reg [7:0] rd_data,
                           output reg tx_en,
                           output reg [7:0] tx_data,
                           output reg int_n);
  
  
//   reg [7:0] sop1=8'hbe;
//   reg[7:0] sop2=8'hef;
//   reg[7:0] eop1=8'hde;
//   reg[7:0] eop2=8'had;
  reg [7:0] parity;
  reg [7:0] pad_byte=8'h00;
  
  reg [7:0] sop_eop[4]='{8'hbe,8'hef,8'hde,8'had};
 
  reg [7:0] pkt_reg [8]; 
  
  reg [7:0] cmd_reg; 
  reg [7:0] ctrl_reg;
  reg[7:0] tx_length;
  
  
  reg [7:0] temp_tx_data[10];//this is the tx_fifo register.
  
  

always @(posedge clk or negedge rst_n) begin:c1
  
if(!rst_n) begin
foreach(pkt_reg[i])
pkt_reg[i] <= 8'hff;
end
  
else begin
  
 if(wr==1'b1) begin:c2
 if(addr == 6) begin
  int j; 
 temp_tx_data[j] <= wr_data;
  j++;
 if(j == 10)
   j=0;
   end
  else if(addr==0) begin
  cmd_reg <= wr_data; 
  end
   else if(addr == 1) begin
   ctrl_reg <= wr_data;
   end
   else if(addr == 2) begin
     tx_length <= wr_data;
   end
   
  else pkt_reg[addr] <= wr_data;
 
      
      end:c2
      
    
    if(rd == 1'b1) begin:c3
     rd_data <= pkt_reg[addr];
    end:c3
      
    end
    
  end:c1
  
  initial begin
    #1000 pkt_reg[5] =0;
  end
 
//  always @(posedge clk) begin:B4
    
//    if(cmd_reg[0]==1'b1) begin:B5
//         pkt_reg[5] <= 1;
      
//         for(int ij=0;ij<2;ij++) begin
//          @(posedge clk);
//         tx_en <= 1'b1;
//          tx_data <=sop_eop[ij] ;
//         end
//      repeat(tx_length) begin:B6
//          int i;
//         @(posedge clk);
//         tx_en <= 1'b1;
//         tx_data <=temp_tx_data[i] ;
//         i++;
//        if(i == tx_length) begin:i_tx_length
//           for(int ijk=2;ijk<4;ijk++) begin
//          @(posedge clk);
//         tx_en <= 1'b1;
//          tx_data <=sop_eop[ijk] ;
//           end
//         @(posedge clk);
//         pkt_reg[0] <= 0;
//         cmd_reg[0] <=1'b0;
//         tx_en <=0;
//         pkt_reg[5] <= 0;
//         i=0;
//         end:i_tx_length
//       end:B6
     
//     end:B5
    
//   end:B4 
  
always @(posedge clk) begin
    
  if(cmd_reg[0] == 1'b1) begin
    `uvm_info("cmd_transaction","entered",UVM_NONE);
  pkt_reg[5] <= 1;
  ctrl_logic();
  
end
    
end
  
 task small_task();

 int i; 
for(int ij=0;ij<2;ij++) begin
@(posedge clk);
tx_en <= 1'b1;
tx_data <=sop_eop[ij] ;
end
@(posedge clk);
tx_en <= 1'b1;
tx_data <= tx_length ; 
//parity <= tx_length;
  
repeat(tx_length) begin
@(posedge clk);
//`uvm_info("parity_check",$sformatf("parity=%0h",parity),UVM_NONE)
tx_en <= 1'b1;
tx_data <=temp_tx_data[i] ;
i++;
// if(ctrl_reg[7]==1'b1) begin:even_parity
// parity <=~(parity^temp_tx_data[i]);
// end:even_parity
// else begin:odd_parity
// parity <= (parity^temp_tx_data[i]); 
 // $strobe("==============strobe parity_check=%0h",parity);
//end:odd_parity

end
i<=0;
`uvm_info("parity_in_small_task",$sformatf(" parity =%0d ",parity),UVM_NONE);            
endtask:small_task
 
  task parity_check();
    int i;
  @(posedge clk);
parity <= tx_length;
repeat(tx_length) begin
@(posedge clk);
//`uvm_info("parity_check",$sformatf("parity=%0h",parity),UVM_NONE)
if(ctrl_reg[7]==1'b1) begin:even_parity
parity <= (~(parity^temp_tx_data[i]));
end:even_parity
else begin:odd_parity
parity <= (parity^temp_tx_data[i]); 
end:odd_parity
  i++;
end
endtask:parity_check
  
//----------------ctrol_logic_---------------------------

task ctrl_logic();
`uvm_info("ctrl_logic","entered",UVM_NONE)
divisor(); 
@(posedge clk);
cmd_reg[0] <=1'b0;
tx_en <=0;
pkt_reg[5] <= 0; 
endtask:ctrl_logic
  
//------------------------cotrol_logic_completed---------------- 
  
  
//--------------------divisor_task------------------------------
  
task divisor();
  `uvm_info("divisor_","entered",UVM_NONE)  

if(ctrl_reg[2:0] === 3'b000) begin:divisor_0
  `uvm_info("divisor_0","entered",UVM_NONE)
  
if(ctrl_reg[6] === 1'b1) begin:even_bytes_of_payload
  
//padding is reqired or not checking 
  
  if((tx_length % 2)==0) begin:no_padding
`uvm_info("NO_padding","entered",UVM_NONE)
  fork
    small_task();
    parity_check();
  join
    `uvm_info("parity_AFTER_SMALL_TASK_in_divisor_no_padding",$sformatf(" parity =%0d tx_length=%0d",parity,tx_length),UVM_NONE);
@(posedge clk);
    `uvm_info("parity_AFTER_SMALL_TASK and posedge",$sformatf(" parity =%0d tx_length=%0d",parity,tx_length),UVM_NONE);

tx_en <=1'b1;
tx_data <= parity;
for(int ijk=2;ijk<4;ijk++) begin
@(posedge clk);
tx_en <= 1'b1;
tx_data <=sop_eop[ijk] ;
 tx_data <=sop_eop[ijk] ;
end
@(posedge clk);
  pkt_reg[5][0] <= 1'b0;
  cmd_reg[0] <=1'b0;

end:no_padding

else begin:padding_required
`uvm_info("padding-required","entered",UVM_NONE)
  small_task();
//sending padd byte for odd bytes of payload.
@(posedge clk);
tx_en <= 1'b1;
tx_data = pad_byte;
if(ctrl_reg[7]==1'b1) begin:even_parity
parity<=~(parity^pad_byte);
end:even_parity
else begin:odd_parity
parity<=(parity^pad_byte);  
end:odd_parity
@(posedge clk);
tx_en <=1'b1; 
tx_data <= parity;
for(int ijk=2;ijk<4;ijk++) begin
@(posedge clk);
tx_en <= 1'b1;
tx_data <=sop_eop[ijk] ;
end
end:padding_required
    
end:even_bytes_of_payload
  
  
else begin:odd_bytes_of_payload
    
end:odd_bytes_of_payload

end:divisor_0
  
  
  
else if(ctrl_reg[2:0] === 3'b001) begin:divisor_1
    
end:divisor_1
  
else if(ctrl_reg > 3'b001) begin:divisor_grtrthan1
    
end:divisor_grtrthan1
  
else begin:invalid_divisor
$display("invlid divisor");
end:invalid_divisor
    
endtask:divisor
  
//----------------------divisor_task_completed------------------------------
  

  
//small task _
  



endmodule:pkt_dvdr_reg_tx_dut






// Code your design here
/*module fifo_ram(

input clk,
input rst_h,
input [2:0] addr,
input temp_cmd,
input wen,
input [7:0] data_i,
output full_o,

input ren,
output reg [7:0] data_o,
output empty_o,
  output reg [6:0] fifo_count

);

parameter DEPTH=128;

reg [7:0] mem[DEPTH];
reg [2:0] wr_ptr;
reg [2:0] rd_ptr;
//reg [3:0] count;

// for full and empty operation
  assign full_o=(fifo_count==DEPTH);
  assign empty_o=(fifo_count==0);

  
//write operation
always @(posedge clk)
begin:write
if (wen && !full_o && addr == 6)
mem[wr_ptr]<=data_i;
else if (wen && ren)
mem[wr_ptr]<=data_i;
end

//read operation
always @(posedge clk)
 begin:read
   if(ren && !empty_o && temp_cmd) 
data_o<=mem[rd_ptr];
else if(ren && wen)
data_o<=mem[rd_ptr];
end

// write and read pointer operation
always @(posedge clk) begin:pointer
if(!rst_h) begin:reset
wr_ptr<=0;
rd_ptr<=0;
end
else begin
wr_ptr<=((wen && !full_o) || (wen && ren))?(wr_ptr+1):(wr_ptr);
rd_ptr<=((ren && !empty_o) || (ren && wen))?(rd_ptr+1):(rd_ptr);
end
end

//counter operation
always @(posedge clk) begin   
  if(!rst_h) fifo_count<=0;
else begin
case ({wen,ren})

2'b00:fifo_count<=fifo_count;
2'b01:fifo_count<=(fifo_count==0)?0:fifo_count-1;
2'b10:fifo_count<=(fifo_count==DEPTH)?DEPTH:fifo_count+1;
2'b11:fifo_count<=fifo_count;
default:fifo_count<=fifo_count; 
endcase

end
end

endmodule:fifo_ram */


//-------------------------------------------------------------------------------------------------
// packet divider and reorder logic ckt dut 
//-------------------------------------------------------------------------------------------------
/*
module pkt_dvdr_reg_tx_dut(input clk,
                           input rst_n,
                           input [2:0]  addr,
                           input wr,
                           input rd,
                           input [7:0] wr_data,
                           output reg [7:0] rd_data,
                           output reg tx_en,
                           output reg [7:0] tx_data,
                           output reg int_n);
  
  

 
  reg [7:0] pkt_reg [8]; 
  
  //reg [7:0] temp_tx_data[10];//this is the tx_fifo register.
  
  reg [7:0] temp_data_o;
  reg [6:0] fifo_count;
  reg full_o;
  reg empty_o;
  
  
 //instaniation of fifo 
  fifo_ram fifo_for_packet_divider(.clk(clk),.rst_h(rst_n),addr(addr),.wen(wr),.data_i(wr_data),.full_o(full_o),.ren(temp_cmd),data_o(temp_data_o),.empty_o(empty_o),.fifo_count(fifo_count));
  

  always @(posedge clk or negedge rst_n) begin:c1
    if(!rst_n) begin
      foreach(pkt_reg[i])
        pkt_reg[i] <= 8'hff;
    end
    else begin
    if(wr==1'b1) begin:c2
      pkt_reg[addr] <= wr_data;
      if(addr == 6) begin
       int j; 
        temp_tx_data[j] <= wr_data;
        j++;
        if(j == 10)
          j=0;
      end
      end:c2
      
    
    if(rd == 1'b1) begin:c3
     rd_data <= pkt_reg[addr];
    end:c3
      
    end
    
  end:c1
  
  initial begin
    #1000 pkt_reg[5] =0;
  end
 
 always @(posedge clk) begin:B4
    
    if(pkt_reg[0] == 1) begin:B5
      pkt_reg[5] <= 1;
      repeat(pkt_reg[2]) begin:B6
         int i;
        @(posedge clk);
        tx_en <= 1'b1;
        tx_data <=temp_tx_data[i] ;
        i++;
        if(i == pkt_reg[2]) begin
        @(posedge clk);
        pkt_reg[0] <= 0;
        tx_en <=0;
        pkt_reg[5] <= 0;
        i=0;
        end
      end:B6
     
    end:B5
    
  end:B4 
  

endmodule:pkt_dvdr_reg_tx_dut



// Code for the fifo.

module fifo_ram(

input clk,
input rst_h,
input [2:0] addr,
//input temp_cmd,
input wen,
input [7:0] data_i,
output full_o,

input ren,
output reg [7:0] data_o,
output empty_o,
output reg [6:0] fifo_count

);

//parameter DEPTH=128;
parameter DEPTH=100; //for packet divider and reorder logic project we need fifo with the 100 bytes.

reg [7:0] mem[DEPTH];
reg [2:0] wr_ptr;
reg [2:0] rd_ptr;
//reg [3:0] count;

// for full and empty operation
assign full_o=(fifo_count==DEPTH);
assign empty_o=(fifo_count==0);

  
//write operation
always @(posedge clk)
begin:write
if (wen && !full_o && addr == 6)
mem[wr_ptr]<=data_i;
else if (wen && ren)
mem[wr_ptr]<=data_i;
end

//read operation
always @(posedge clk)
 begin:read
//if(ren && !empty_o && temp_cmd) 
if(ren && !empty_o) 
data_o<=mem[rd_ptr];
else if(ren && wen)
data_o<=mem[rd_ptr];
end

// write and read pointer operation
always @(posedge clk) begin:pointer
if(!rst_h) begin:reset
wr_ptr<=0;
rd_ptr<=0;
end
else begin
wr_ptr<=((wen && !full_o) || (wen && ren))?(wr_ptr+1):(wr_ptr);
rd_ptr<=((ren && !empty_o) || (ren && wen))?(rd_ptr+1):(rd_ptr);
end
end

//counter operation
always @(posedge clk) begin   
  if(!rst_h) fifo_count<=0;
else begin
case ({wen,ren})

2'b00:fifo_count<=fifo_count;
2'b01:fifo_count<=(fifo_count==0)?0:fifo_count-1;
2'b10:fifo_count<=(fifo_count==DEPTH)?DEPTH:fifo_count+1;
2'b11:fifo_count<=fifo_count;
default:fifo_count<=fifo_count; 
endcase

end
end

endmodule:fifo_ram 

*/

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/13 11:01:40
// Design Name: 
// Module Name: MemOrIO
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MemOrIO(mRead, mWrite, ioRead, ioWrite,addr_in, addr_out, m_rdata, io_rdata, r_wdata, r_rdata, write_data, LEDCtrl, SwitchCtrl, KeyCtrl, KeyBoardClear);
    input mRead; // read memory, from Controller
    input mWrite; // write memory, from Controller
    input ioRead; // read IO, from Controller
    input ioWrite; // write IO, from Controller
    
    input[31:0] addr_in; // from alu_result in ALU
    output[31:0] addr_out; // address to Data-Memory
    
    input[31:0] m_rdata; // data read from Data-Memory
    input[15:0] io_rdata; // data read from IO,16 bits
    output[31:0] r_wdata; // data to Decoder(register file)
    
    input[31:0] r_rdata; // data read from Decoder(register file)
    
    output reg[31:0] write_data; // data to memory or I/O��m_wdata, io_wdata��
    output LEDCtrl; // LED Chip Select
    output SwitchCtrl; // Switch Chip Select
    output KeyCtrl;    // KeyBoard Select
    output KeyBoardClear;
    
    assign addr_out= addr_in;
    // The data wirte to register file may be from memory or io. // While the data is from io, it should be the lower 16bit of r_wdata.
    assign r_wdata = (ioRead == 1'b1) ? {{16{1'b0}}, io_rdata} : m_rdata; //�Ƿ���address��22bitȫΪ1һ���жϣ���
    // Chip select signal of Led and Switch are all active high;
    assign LEDCtrl= (ioWrite == 1'b1) ? 1'b1 : 1'b0; //ledģ���Ƭѡ�źţ��ߵ�ƽ��Ч//�Ƿ���address��22bitȫΪ1һ���жϣ���
    
    assign SwitchCtrl = (ioRead == 1'b1) ? 1'b1 : 1'b0; //switchģ���Ƭѡ�źţ��ߵ�ƽ��Ч//�Ƿ���address��22bitȫΪ1һ���жϣ���
    
    assign KeyCtrl = (ioRead == 1'b1 && addr_in[7:0] == 8'b1000_0011) ? 1'b1: 1'b0; // load word from keyboard   0xC83

    assign KeyBoardClear = (ioWrite == 1'b1 && addr_in[7:0] == 8'b1001_0011);       // clear keyboard register   0xC93    
    
    always @* begin
    if(mWrite==1 || ioWrite == 1) begin
    //wirte_data could go to either memory or IO. where is it from?
       if (LEDCtrl) begin
            // write_data = {{16{1'b0}}, io_rdata[15:0]}; 
            write_data = {16'b0000000000000000, r_rdata[15:0]};  
       end
       else 
            write_data = r_rdata;
    end
    else
        write_data = 32'hZZZZZZZZ;
    end
endmodule

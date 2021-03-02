`timescale 1ns / 1ps

module tb_top_level();

logic iClk;
logic iRst;

logic iStart_master1;
logic iStart_master2;
logic iStart_master3;
logic iStart_master4;

logic [31:0] master1_ext_data;
logic [31:0] master1_ext_addr;
logic [31:0] master2_ext_data;
logic [31:0] master2_ext_addr;
logic [31:0] master3_ext_data;
logic [31:0] master3_ext_addr;
logic [31:0] master4_ext_data;
logic [31:0] master4_ext_addr;

logic master1_ext_oper;
logic master2_ext_oper;
logic master3_ext_oper;
logic master4_ext_oper;

top_level dut_inst
(
	.iClk(iClk),
	.iRst(iRst),
	.iStart_master1(iStart_master1),
	.iStart_master2(iStart_master2),
	.iStart_master3(iStart_master3),
	.iStart_master4(iStart_master4),
	.master1_ext_data(master1_ext_data),
 	.master1_ext_addr(master1_ext_addr),
 	.master2_ext_data(master2_ext_data),
	.master2_ext_addr(master2_ext_addr),
 	.master3_ext_data(master3_ext_data),
	.master3_ext_addr(master3_ext_addr),
 	.master4_ext_data(master4_ext_data),
	.master4_ext_addr(master4_ext_addr),
	.master1_ext_oper(master1_ext_oper),
	.master2_ext_oper(master2_ext_oper),
	.master3_ext_oper(master3_ext_oper),
	.master4_ext_oper(master4_ext_oper)
);

initial begin
	iClk = 1'b0;
	forever iClk = #5 ~iClk;
end

initial begin
	#5;
	iRst = 1'b1;
	#10;
	iRst = 1'b0;
	/*Запись в 1 slave от 4 Master'ов*/
	master1_ext_oper = 1'b1;
	master2_ext_oper = 1'b1;
	master3_ext_oper = 1'b1;
	master4_ext_oper = 1'b1;

	master1_ext_data = 32'd11;
	master1_ext_addr = 32'b11000000000000000000000000000000; 

	master2_ext_data = 32'd22;
	master2_ext_addr = 32'b11000000000000000000000000000000;

	master3_ext_data = 32'd33;
	master3_ext_addr = 32'b11000000000000000000000000000000; 

	master4_ext_data = 32'd44;
	master4_ext_addr = 32'b11000000000000000000000000000000;

	iStart_master1 = 1'b1;
	iStart_master2 = 1'b1;
	iStart_master3 = 1'b1;
	iStart_master4 = 1'b1;
	#10;
	iStart_master1 = 1'b0;
	iStart_master2 = 1'b0;
	iStart_master3 = 1'b0;
	iStart_master4 = 1'b0;
	#200;

	/*Запись в разные Slave'ы*/
	master1_ext_oper = 1'b1;
	master2_ext_oper = 1'b1;
	master3_ext_oper = 1'b1;
	master4_ext_oper = 1'b1;

	master1_ext_data = 32'd11;
	master1_ext_addr = 32'b11000000000000000000000000000000; 

	master2_ext_data = 32'd22;
	master2_ext_addr = 32'b10000000000000000000000000000000;

	master3_ext_data = 32'd33;
	master3_ext_addr = 32'b01000000000000000000000000000000;

	master4_ext_data = 32'd44;
	master4_ext_addr = 32'b00000000000000000000000000000000;
	iStart_master1 = 1'b1;
	iStart_master2 = 1'b1;
	iStart_master3 = 1'b1;
	iStart_master4 = 1'b1;
	#10;
	iStart_master1 = 1'b0;
	iStart_master2 = 1'b0;
	iStart_master3 = 1'b0;
	iStart_master4 = 1'b0;
	#200;

	/*Запись и чтение в разные Slave'ы*/
	master1_ext_oper = 1'b1;
	master2_ext_oper = 1'b0;
	master3_ext_oper = 1'b1;
	master4_ext_oper = 1'b0;

	master1_ext_data = 32'd11;
	master1_ext_addr = 32'b11000000000000000000000000000000; 

	master2_ext_data = 32'd22;
	master2_ext_addr = 32'b11000000000000000000000000000000;

	master3_ext_data = 32'd33;
	master3_ext_addr = 32'b01000000000000000000000000000000;

	master4_ext_data = 32'd44;
	master4_ext_addr = 32'b01000000000000000000000000000000;
	iStart_master1 = 1'b1;
	iStart_master2 = 1'b1;
	iStart_master3 = 1'b1;
	iStart_master4 = 1'b1;
	#10;
	iStart_master1 = 1'b0;
	iStart_master2 = 1'b0;
	iStart_master3 = 1'b0;
	iStart_master4 = 1'b0;
	#200;
	#1000;
	$stop;
	end
endmodule

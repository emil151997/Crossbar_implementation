`timescale 1ns / 1ps

/*Модуль верхнего уровня*/
module top_level(
	input iClk, 								// Входной тактовый сигнал
	input iRst, 								// Сигнал сброса
	input iStart_master1, 						// Сигналы инициализации запросов Master 
	input iStart_master2, 						
	input iStart_master3, 						
	input iStart_master4, 						
	input [31:0] master1_ext_data, 				// Шины записываемых данных для Master
 	input [31:0] master2_ext_data, 				
	input [31:0] master3_ext_data, 				
 	input [31:0] master4_ext_data, 				
 	input [31:0] master1_ext_addr, 				// Шины адресов, по которым записываются данные
	input [31:0] master2_ext_addr, 				
 	input [31:0] master3_ext_addr, 				
	input [31:0] master4_ext_addr, 				
	input master1_ext_oper, 					// Сигналы выбора операции
	input master2_ext_oper,
	input master3_ext_oper,
	input master4_ext_oper
 );

	
localparam pInit_Delay = 32'd5;

/*Wirе'ы для соединения между модулями*/ 
logic		 master_1_req;
logic [31:0] master_1_addr;
logic		 master_1_cmd;
logic [31:0] master_1_wdata;
logic [31:0] master_1_rdata;
logic  		 master_1_ack;


logic 		 master_2_req;
logic [31:0] master_2_addr;
logic 		 master_2_cmd;
logic [31:0] master_2_wdata;
logic [31:0] master_2_rdata;
logic 		 master_2_ack;

logic 		 master_3_req;
logic [31:0] master_3_addr;
logic 		 master_3_cmd;
logic [31:0] master_3_wdata;
logic [31:0] master_3_rdata;
logic 		 master_3_ack;


logic 		 master_4_req;
logic [31:0] master_4_addr;
logic 		 master_4_cmd;
logic [31:0] master_4_wdata;
logic [31:0] master_4_rdata;
logic  		 master_4_ack;


logic 		 slave_1_ack;
logic [31:0] slave_1_rdata;
logic  		 slave_1_req;
logic		 slave_1_cmd;
logic [31:0] slave_1_wdata;

logic		 slave_2_ack;
logic [31:0] slave_2_rdata;
logic		 slave_2_req;
logic		 slave_2_cmd;
logic [31:0] slave_2_wdata;

logic		 slave_3_ack;
logic [31:0] slave_3_rdata;
logic		 slave_3_req;
logic		 slave_3_cmd;
logic [31:0] slave_3_wdata;

logic		 slave_4_ack;
logic [31:0] slave_4_rdata;
logic		 slave_4_req;
logic		 slave_4_cmd;
logic [31:0] slave_4_wdata;




Master #(pInit_Delay) Master_1_inst
(
	.iClk(iClk),
	.iRst(iRst),
	.iStart(iStart_master1),
	.iWrite_Data(master1_ext_data),
	.iAddr(master1_ext_addr),
	.iOper(master1_ext_oper),
	.master_ack(master_1_ack),
	.master_rdata(master_1_rdata),
	.master_req(master_1_req),
	.master_addr(master_1_addr),
	.master_cmd(master_1_cmd),
	.master_wdata(master_1_wdata)
);

Master #(pInit_Delay) Master_2_inst
(
	.iClk(iClk),
	.iRst(iRst),
	.iStart(iStart_master2),
	.iWrite_Data(master2_ext_data),
	.iAddr(master2_ext_addr),
	.iOper(master2_ext_oper),
	.master_ack(master_2_ack),
	.master_rdata(master_2_rdata),
	.master_req(master_2_req),
	.master_addr(master_2_addr),
	.master_cmd(master_2_cmd),
	.master_wdata(master_2_wdata)
);

Master #(pInit_Delay) Master_3_inst
(
	.iClk(iClk),
	.iRst(iRst),
	.iStart(iStart_master3),
	.iWrite_Data(master3_ext_data),
	.iAddr(master3_ext_addr),
	.iOper(master3_ext_oper),
	.master_ack(master_3_ack),
	.master_rdata(master_3_rdata),
	.master_req(master_3_req),
	.master_addr(master_3_addr),
	.master_cmd(master_3_cmd),
	.master_wdata(master_3_wdata)
);

Master #(pInit_Delay) Master_4_inst
(
	.iClk(iClk),
	.iRst(iRst),
	.iStart(iStart_master4),
	.iWrite_Data(master4_ext_data),
	.iAddr(master4_ext_addr),
	.iOper(master4_ext_oper),
	.master_ack(master_4_ack),
	.master_rdata(master_4_rdata),
	.master_req(master_4_req),
	.master_addr(master_4_addr),
	.master_cmd(master_4_cmd),
	.master_wdata(master_4_wdata)
);



Slave #(pInit_Delay) Slave_1_inst
(
	.iClk(iClk),
	.iRst(iRst),
	.slave_req(slave_1_req),
	.slave_cmd(slave_1_cmd),
	.slave_wdata(slave_1_wdata),
	.slave_ack(slave_1_ack),
	.slave_rdata(slave_1_rdata)
);

Slave #(pInit_Delay) Slave_2_inst
(
	.iClk(iClk),
	.iRst(iRst),
	.slave_req(slave_2_req),
	.slave_cmd(slave_2_cmd),
	.slave_wdata(slave_2_wdata),
	.slave_ack(slave_2_ack),
	.slave_rdata(slave_2_rdata)
);

Slave #(pInit_Delay) Slave_3_inst
(
	.iClk(iClk),
	.iRst(iRst),
	.slave_req(slave_3_req),
	.slave_cmd(slave_3_cmd),
	.slave_wdata(slave_3_wdata),
	.slave_ack(slave_3_ack),
	.slave_rdata(slave_3_rdata)
);

Slave #(pInit_Delay) Slave_4_inst
(
	.iClk(iClk),
	.iRst(iRst),
	.slave_req(slave_4_req),
	.slave_cmd(slave_4_cmd),
	.slave_wdata(slave_4_wdata),
	.slave_ack(slave_4_ack),
	.slave_rdata(slave_4_rdata)
);

Control #(pInit_Delay) Control_inst
(
	.iClk(iClk),
	.iRst(iRst),
	.master_1_req(master_1_req),
	.master_1_addr(master_1_addr),
	.master_1_cmd(master_1_cmd),
	.master_1_wdata(master_1_wdata),
	.master_1_rdata(master_1_rdata),
	.master_1_ack(master_1_ack),

	.master_2_req(master_2_req),
	.master_2_addr(master_2_addr),
	.master_2_cmd(master_2_cmd),
	.master_2_wdata(master_2_wdata),
	.master_2_rdata(master_2_rdata),
	.master_2_ack(master_2_ack),
	
	.master_3_req(master_3_req),
	.master_3_addr(master_3_addr),
	.master_3_cmd(master_3_cmd),
	.master_3_wdata(master_3_wdata),
	.master_3_rdata(master_3_rdata),
	.master_3_ack(master_3_ack),
	
	.master_4_req(master_4_req),
	.master_4_addr(master_4_addr),
	.master_4_cmd(master_4_cmd),
	.master_4_wdata(master_4_wdata),
	.master_4_rdata(master_4_rdata),
	.master_4_ack(master_4_ack),

	.slave_1_ack(slave_1_ack),
	.slave_1_rdata(slave_1_rdata),
	.slave_1_req(slave_1_req),
	.slave_1_cmd(slave_1_cmd),
	.slave_1_wdata(slave_1_wdata),

	.slave_2_ack(slave_2_ack),
	.slave_2_rdata(slave_2_rdata),
	.slave_2_req(slave_2_req),
	.slave_2_cmd(slave_2_cmd),
	.slave_2_wdata(slave_2_wdata),

	.slave_3_ack(slave_3_ack),
	.slave_3_rdata(slave_3_rdata),
	.slave_3_req(slave_3_req),
	.slave_3_cmd(slave_3_cmd),
	.slave_3_wdata(slave_3_wdata),

	.slave_4_ack(slave_4_ack),
	.slave_4_rdata(slave_4_rdata),
	.slave_4_req(slave_4_req),
	.slave_4_cmd(slave_4_cmd),
	.slave_4_wdata(slave_4_wdata)
);

endmodule

`timescale 1ns / 1ps

module Control
#(parameter pInit_Delay = 50)
(
	input iClk, 							 			// Входной тактовый сигнал
	input iRst,								 			// Сигнал сброса

	input 		  master_1_req, 					// Сигналы для Master 1
	input  [31:0] master_1_addr,
	input 		  master_1_cmd,
	input  [31:0] master_1_wdata,
	output [31:0] master_1_rdata,
	output  		  master_1_ack,

	input 		  master_2_req, 					// Сигналы для Master 2
	input  [31:0] master_2_addr,
	input 		  master_2_cmd,
	input  [31:0] master_2_wdata,
	output [31:0] master_2_rdata,
	output 		  master_2_ack,

	input 		  master_3_req, 					// Сигналы для Master 3
	input  [31:0] master_3_addr,
	input 		  master_3_cmd,
	input  [31:0] master_3_wdata,
	output [31:0] master_3_rdata,
	output 		  master_3_ack,

 	input 		  master_4_req, 					// Сигналы для Master 4
	input  [31:0] master_4_addr,
	input 		  master_4_cmd,
	input  [31:0] master_4_wdata,
	output [31:0] master_4_rdata,
	output 		  master_4_ack,

	input 		  slave_1_ack, 					// Сигналы для Slave 1
	input  [31:0] slave_1_rdata,
	output 		  slave_1_req,
	output 		  slave_1_cmd,
	output [31:0] slave_1_wdata,
	
	
	input 		  slave_2_ack, 					// Сигналы для Slave 2
	input  [31:0] slave_2_rdata,
	output 		  slave_2_req,
	output 		  slave_2_cmd,
	output [31:0] slave_2_wdata,

	input 		  slave_3_ack, 					// Сигналы для Slave 3
	input  [31:0] slave_3_rdata,
	output 		  slave_3_req,
	output 		  slave_3_cmd,
	output [31:0] slave_3_wdata,
	
	
	input 		  slave_4_ack, 					// Сигналы для Slave 4
	input  [31:0] slave_4_rdata,
	output 		  slave_4_req,
	output 		  slave_4_cmd,
	output [31:0] slave_4_wdata
);

/*Состояния конечного автомата*/
enum logic [1:0] {
	init_delay = 2'b01,
	wait_operation 	  = 2'b10
} state;


logic [31:0] reg_master_1_rdata; 				// Регистры для хранения считываемых данных со slave'ов
logic [31:0] reg_master_2_rdata;
logic [31:0] reg_master_3_rdata;
logic [31:0] reg_master_4_rdata;


logic [31:0] reg_slave_1_wdata; 					// Регистры для хранения записываемых данных в slave'ы
logic [31:0] reg_slave_2_wdata;
logic [31:0] reg_slave_3_wdata;
logic [31:0] reg_slave_4_wdata;

logic 		 reg_slave_1_req; 					// Регистры для формирования запросов к slave'ам
logic 		 reg_slave_2_req;
logic 		 reg_slave_3_req;
logic 		 reg_slave_4_req;


logic 		 reg_slave_1_cmd; 					// Регистры для хранения операций Master'ов
logic 		 reg_slave_2_cmd; 	
logic 		 reg_slave_3_cmd;
logic 		 reg_slave_4_cmd;


 
logic reg_master_1_ack; 						   // Регистры подтверждения операций от slave 
logic reg_master_2_ack;
logic reg_master_3_ack;
logic reg_master_4_ack;

logic reg_master_1_flag; 							// Флаги используемый для реализации round robin
logic reg_master_2_flag;
logic reg_master_3_flag;
logic reg_master_4_flag;

logic [31:0] rCnt_Delay; 							// Счетчик для задержки

initial begin
		state <= init_delay;
		reg_master_1_rdata			<= 'b0;
		reg_master_2_rdata			<= 'b0;
		reg_master_3_rdata			<= 'b0;
		reg_master_4_rdata			<= 'b0;

		reg_slave_1_wdata				<= 'b0;
		reg_slave_2_wdata				<= 'b0;
		reg_slave_3_wdata				<= 'b0;
		reg_slave_4_wdata				<= 'b0;

		reg_slave_1_req	 			<= 'b0;
		reg_slave_2_req	 			<= 'b0;
		reg_slave_3_req	 			<= 'b0;
		reg_slave_4_req	 			<= 'b0;

		reg_slave_1_cmd 				<= 'b0;
		reg_slave_2_cmd 				<= 'b0;
		reg_slave_3_cmd 				<= 'b0;
		reg_slave_4_cmd 				<= 'b0;

		reg_master_1_ack 				<= 'b0;
		reg_master_2_ack 				<= 'b0;
		reg_master_3_ack 				<= 'b0;
		reg_master_4_ack 				<= 'b0;

		reg_master_1_flag 			<= 'b0;
		reg_master_2_flag 			<= 'b0;
		reg_master_3_flag 			<= 'b0;
		reg_master_4_flag 			<= 'b0;

		rCnt_Delay 						<= 'b0;
end

always_ff @(posedge iClk) begin
	if (iRst) begin 										 			// Если пришел сигнал сброса - обнуляем регистры
		state  							<= init_delay;
		reg_master_1_rdata			<= 'b0;
		reg_master_2_rdata			<= 'b0;
		reg_master_3_rdata			<= 'b0;
		reg_master_4_rdata			<= 'b0;

		reg_slave_1_wdata				<= 'b0;
		reg_slave_2_wdata				<= 'b0;
		reg_slave_3_wdata				<= 'b0;
		reg_slave_4_wdata				<= 'b0;

		reg_slave_1_req	 			<= 'b0;
		reg_slave_2_req	 			<= 'b0;
		reg_slave_3_req	 			<= 'b0;
		reg_slave_4_req	 			<= 'b0;

		reg_slave_1_cmd 				<= 'b0;
		reg_slave_2_cmd 				<= 'b0;
		reg_slave_3_cmd 				<= 'b0;
		reg_slave_4_cmd 				<= 'b0;

		reg_master_1_ack 				<= 'b0;
		reg_master_2_ack 				<= 'b0;
		reg_master_3_ack 				<= 'b0;
		reg_master_4_ack 				<= 'b0;

		reg_master_1_flag 			<= 'b0;
		reg_master_2_flag 			<= 'b0;
		reg_master_3_flag 			<= 'b0;
		reg_master_4_flag 			<= 'b0;

		rCnt_Delay 						<= 'b0;
	end	
	else begin
		case (state) 						
			init_delay : begin	 																			// Состояние задержки
				if (rCnt_Delay == pInit_Delay) begin 													// Если досчитали до конца
					rCnt_Delay <= 'b1; 																		// Сбрасываем счетчик
					state <= wait_operation; 																// Переходим в операцию ожидания состояния
				end
				else begin 																						// Если не досчитали - считаем
					rCnt_Delay <= rCnt_Delay + 1'b1;
				end
			end
			wait_operation : begin
				if (master_1_req && ~reg_master_1_flag) begin : master1req 					   // Если пришел запрос от Master 1 
				
					if (master_1_addr[31:30] == 2'b11) begin											// Запрос master 1 к slave 1
						if (slave_1_ack) begin 																// Если пришло подтверждение запроса от slave 1
							reg_slave_1_req  <= 'b0; 														// Обнуляем регистр запроса master 1
							reg_master_1_ack <= 'b1; 														// Защелкиваем регистр подтверждения для master 1
						end				
						else if (reg_master_1_ack)  begin 												// Если регистр подтверждения запроса для master 1 в активном уровне
							reg_master_1_flag <= 'b1; 														// Устанавливаем флаг, того master 1 отработал и сбрасываем остальные флаги (других master'ов)
							reg_master_2_flag <= 'b0;
							reg_master_3_flag <= 'b0;	
							reg_master_4_flag <= 'b0;					
							if (~reg_slave_1_cmd) begin 														// Если мы выполняли операцию чтения, тогда считываем в регистр данные со slave 1
								reg_master_1_rdata <= slave_1_rdata;					
							end				
							reg_master_1_ack <= 'b0; 														// Сбрасываем регистр подтверждения запроса
						end				
						else begin 								 												// Иначе (формирование запроса)
							reg_slave_1_cmd    <= master_1_cmd; 										// Защелкиваем код операции и записываемые данные в регистр
							reg_slave_1_wdata  <= master_1_wdata; 					
							reg_slave_1_req  	 <= 'b1; 													// Защелкиваем регистр запроса для slave 1
						end
					end
	
					else if (master_1_addr[31:30] == 2'b10) begin									// Запрос master 1 к slave 2
						if (slave_2_ack) begin 																// Если пришло подтверждение запроса от slave 2
							reg_slave_2_req  <= 'b0; 														// Обнуляем регистр запроса master 1
							reg_master_1_ack <= 'b1; 														// Защелкиваем регистр подтверждения для master 1
						end 																						 
						else if (reg_master_1_ack) begin 							 					// Если регистр подтверждения запроса для master 1 в активном уровне
							reg_master_1_flag <= 'b1; 														// Устанавливаем флаг, того master 1 отработал и сбрасываем флаг master 4
							reg_master_4_flag <= 'b0; 														 
							if (~reg_slave_2_cmd) begin 														// Если мы выполняли операцию чтения, тогда считываем в регистр данные со slave 2
								reg_master_1_rdata <= slave_2_rdata;	 								  															
							end 																					  															
							reg_master_1_ack <= 'b0; 														// Сбрасываем регистр подтверждения запроса 	
						end 																						
						else begin 																				// Иначе (формирование запроса)
							reg_slave_2_wdata <= master_1_wdata; 										// Защелкиваем код операции и записываемые данные в регистр
							reg_slave_2_cmd   <= master_1_cmd;  										 
							reg_slave_2_req   <= 'b1; 														// Защелкиваем регистр запроса для slave 
						end
					end
		
					else if (master_1_addr[31:30] == 2'b01)  begin 									// Запрос master 1 к slave 3
						if (slave_3_ack) begin 																// Если пришло подтверждение запроса от slave 3
							reg_slave_3_req  <= 'b0; 														// Обнуляем регистр запроса master 1
							reg_master_1_ack <= 'b1; 														// Защелкиваем регистр подтверждения для master 1
						end 																						 
						else if (reg_master_1_ack) begin 							 					// Если регистр подтверждения запроса для master 1 в активном уровне
							reg_master_1_flag <= 'b1; 														// Устанавливаем флаг, того master 1 отработал и сбрасываем флаг master 4
							reg_master_4_flag <= 'b0; 														 
							if (~reg_slave_3_cmd) begin 														// Если мы выполняли операцию чтения, тогда считываем в регистр данные со slave 3
								reg_master_1_rdata <= slave_3_rdata;	 								  															
							end 																					  															
							reg_master_1_ack <= 'b0; 														// Сбрасываем регистр подтверждения запроса 	
						end 																						
						else begin 																				// Иначе (формирование запроса)
							reg_slave_3_wdata <= master_1_wdata; 										// Защелкиваем код операции и записываемые данные в регистр
							reg_slave_3_cmd   <= master_1_cmd;  										 
							reg_slave_3_req   <= 'b1; 														// Защелкиваем регистр запроса для slave 
						end
					end
	
					else if (master_1_addr[31:30] == 2'b00)  begin 									// Запрос master 1 к slave 4
						if (slave_4_ack) begin 																// Если пришло подтверждение запроса от slave 4
							reg_slave_4_req  <= 'b0; 														// Обнуляем регистр запроса master 1
							reg_master_1_ack <= 'b1; 														// Защелкиваем регистр подтверждения для master 1
						end 																						 
						else if (reg_master_1_ack) begin 							 					// Если регистр подтверждения запроса для master 1 в активном уровне
							reg_master_1_flag <= 'b1; 														// Устанавливаем флаг, того master 1 отработал и сбрасываем флаг master 4
							reg_master_4_flag <= 'b0; 														 
							if (~reg_slave_4_cmd) begin 														// Если мы выполняли операцию чтения, тогда считываем в регистр данные со slave 4
								reg_master_1_rdata <= slave_4_rdata;	 								  															
							end 																					  															
							reg_master_1_ack <= 'b0; 														// Сбрасываем регистр подтверждения запроса 	
						end 																						
						else begin 																				// Иначе (формирование запроса)
							reg_slave_4_wdata <= master_1_wdata; 										// Защелкиваем код операции и записываемые данные в регистр
							reg_slave_4_cmd   <= master_1_cmd;  										 
							reg_slave_4_req   <= 'b1; 														// Защелкиваем регистр запроса для slave 
						end
					end
				end

				else if (master_2_req && ~reg_master_2_flag) begin   		 	// Если пришел запрос от master 2 (и его очередь)

					if (master_2_addr[31:30] == 2'b11)  begin 									 	// Запрос master 2 к slave 1							 						
						if (slave_1_ack) begin 																// Если пришло подтверждение запроса от slave 1
							reg_slave_1_req  <= 'b0; 														// Обнуляем регистр запроса master 2
							reg_master_2_ack <= 'b1; 														// Защелкиваем регистр подтверждения для master 2
						end 																				       
						else if (reg_master_2_ack) begin 												// Если регистр подтверждения запроса для master 2 в активном уровне
							reg_master_1_flag <= 'b0; 														// Устанавливаем флаг, того master 2 отработал и сбрасываем флаг master 1
							reg_master_2_flag <= 'b1; 														 
							if (~reg_slave_1_cmd) begin 														// Если мы выполняли операцию чтения, тогда считываем в регистр данные со slave 1
								reg_master_2_rdata <= slave_1_rdata;	 								  															
							end								 														 
							reg_master_2_ack <= 'b0; 														// Сбрасываем регистр запроса
						end 																				  									
						else begin 																													
							reg_slave_1_wdata <= master_2_wdata; 										// Сбрасываем регистр подтверждения запроса 	
							reg_slave_1_cmd   <= master_2_cmd; 											// Иначе (формирование запроса)
							reg_slave_1_req   <= 'b1; 														// Защелкиваем код операции и записываемые данные в регистр
						end
					end	 			

					else if (master_2_addr[31:30] == 2'b10)  begin 									// Запрос master 2 к slave 2
						if (slave_2_ack) begin  															// Если пришло подтверждение запроса от slave 2
							reg_slave_2_req  <= 'b0;  														// Обнуляем регистр запроса master 2
							reg_master_2_ack <= 'b1;  														// Защелкиваем регистр подтверждения для master 2
						end  																						
						else if (reg_master_2_ack) begin  												// Если регистр подтверждения запроса для master 2 в активном уровне
							reg_master_1_flag <= 'b0;  													// Устанавливаем флаг, того master 2 отработал и сбрасываем флаг master 2
							reg_master_2_flag <= 'b1; 														 
							if (~reg_slave_2_cmd) begin 														// Если мы выполняли операцию чтения, тогда считываем в регистр данные со slave 2
								reg_master_2_rdata <= slave_2_rdata;	 								  															
							end 												 														 
							reg_master_2_ack <= 'b0; 														// Сбрасываем регистр подтверждения запроса
						end  																						
						else begin  																							
							reg_slave_2_wdata <= master_2_wdata;  										// Сбрасываем регистр подтверждения запроса 	
							reg_slave_2_cmd   		 <= master_2_cmd;  								// Иначе (формирование запроса)
							reg_slave_2_req  <= 'b1;  														// Защелкиваем код операции и записываемые данные в регистр
						end
					end	 			

					else if (master_2_addr[31:30] == 2'b01)  begin 									// Запрос master 2 к slave 3
						if (slave_3_ack) begin  															// Если пришло подтверждение запроса от slave 3
							reg_slave_3_req  <= 'b0;  														// Обнуляем регистр запроса master 2
							reg_master_2_ack <= 'b1;  														// Защелкиваем регистр подтверждения для master 2
						end  																						
						else if (reg_master_2_ack) begin  												// Если регистр подтверждения запроса для master 2 в активном уровне
							reg_master_1_flag <= 'b0;  													// Устанавливаем флаг, того master 2 отработал и сбрасываем флаг master 1
							reg_master_2_flag <= 'b1; 														 
							if (~reg_slave_3_cmd) begin 														// Если мы выполняли операцию чтения, тогда считываем в регистр данные со slave 3
								reg_master_2_rdata <= slave_3_rdata;	 								  															
							end 												 														 
							reg_master_2_ack <= 'b0; 														// Сбрасываем регистр подтверждения запроса
						end  																						
						else begin  																							
							reg_slave_3_wdata <= master_2_wdata;  										// Сбрасываем регистр подтверждения запроса 	
							reg_slave_3_cmd   		 <= master_2_cmd;  								// Иначе (формирование запроса)
							reg_slave_3_req  <= 'b1;  														// Защелкиваем код операции и записываемые данные в регистр
						end
					end	 			

					else if (master_2_addr[31:30] == 2'b00)  begin 									// Запрос master 2 к slave 4
						if (slave_4_ack) begin  															// Если пришло подтверждение запроса от slave 4
							reg_slave_4_req  <= 'b0;  														// Обнуляем регистр запроса master 2
							reg_master_2_ack <= 'b1;  														// Защелкиваем регистр подтверждения для master 2
						end  																						
						else if (reg_master_2_ack) begin  												// Если регистр подтверждения запроса для master 2 в активном уровне
							reg_master_1_flag <= 'b0;  													// Устанавливаем флаг, того master 2 отработал и сбрасываем флаг master 1
							reg_master_2_flag <= 'b1;														 
							if (~reg_slave_4_cmd) begin 														// Если мы выполняли операцию чтения, тогда считываем в регистр данные со slave 4
								reg_master_2_rdata <= slave_4_rdata;	 								  															
							end 												 														 
							reg_master_2_ack <= 'b0; 														// Сбрасываем регистр подтверждения запроса
						end  																						
						else begin  																							
							reg_slave_4_wdata <= master_2_wdata;  										// Сбрасываем регистр подтверждения запроса 	
							reg_slave_4_cmd   <= master_2_cmd;  									   // Иначе (формирование запроса)
							reg_slave_4_req   <= 'b1;  													// Защелкиваем код операции и записываемые данные в регистр
						end
					end	
				end


				else if (master_3_req && ~reg_master_3_flag) begin :  master3req 		 	   // Если пришел запрос от master 3 (и его очередь)
	
					 if (master_3_addr[31:30] == 2'b11)  begin 										// Запрос master 3 к slave 1							 						
						if (slave_1_ack) begin 																// Если пришло подтверждение запроса от slave 1
							reg_slave_1_req  <= 'b0; 														// Обнуляем регистр запроса master 3
							reg_master_3_ack <= 'b1; 														// Защелкиваем регистр подтверждения для master 3
						end 																				       
						else if (reg_master_3_ack) begin 												// Если регистр подтверждения запроса для master 3 в активном уровне
							reg_master_2_flag <= 'b0; 														// Устанавливаем флаг, того master 3 отработал и сбрасываем флаг master 2
							reg_master_3_flag <= 'b1;														 
							if (~reg_slave_1_cmd) begin 														// Если мы выполняли операцию чтения, тогда считываем в регистр данные со slave 1
								reg_master_3_rdata <= slave_1_rdata;	 								  															
							end 												 														 
							reg_master_3_ack <= 'b0; 														// Сбрасываем регистр подтверждения запроса
						end 																				  									
						else begin 																													
							reg_slave_1_wdata <= master_3_wdata; 										// Сбрасываем регистр подтверждения запроса 	
							reg_slave_1_cmd   <= master_3_cmd; 											// Иначе (формирование запроса)
							reg_slave_1_req   <= 'b1; 														// Защелкиваем код операции и записываемые данные в регистр
						end
					end	 			
	
					else if (master_3_addr[31:30] == 2'b10)  begin 									// Запрос master 3 к slave 2
						if (slave_2_ack) begin  															// Если пришло подтверждение запроса от slave 2
							reg_slave_2_req  <= 'b0;  														// Обнуляем регистр запроса master 2
							reg_master_3_ack <= 'b1;  														// Защелкиваем регистр подтверждения для master 2
						end  																						
						else if (reg_master_3_ack) begin  												// Если регистр подтверждения запроса для master 3 в активном уровне
							reg_master_2_flag <= 'b0;  													// Устанавливаем флаг, того master 3 отработал и сбрасываем флаг master 2
							reg_master_3_flag <= 'b1;														 
							if (~reg_slave_2_cmd) begin 														// Если мы выполняли операцию чтения, тогда считываем в регистр данные со slave 2
								reg_master_3_rdata <= slave_2_rdata;	 								  															
							end 												 														 
							reg_master_3_ack <= 'b0; 														// Сбрасываем регистр подтверждения запроса
						end  																						
						else begin  																							
							reg_slave_2_wdata <= master_3_wdata;  										// Сбрасываем регистр подтверждения запроса 	
							reg_slave_2_cmd   		 <= master_3_cmd;  								// Иначе (формирование запроса)
							reg_slave_2_req  <= 'b1;  														// Защелкиваем код операции и записываемые данные в регистр
						end
					end	 			
	
					else if (master_3_addr[31:30] == 2'b01)  begin 									// Запрос master 3 к slave 3
						if (slave_3_ack) begin  															// Если пришло подтверждение запроса от slave 3
							reg_slave_3_req  <= 'b0;  														// Обнуляем регистр запроса master 3
							reg_master_3_ack <= 'b1;  														// Защелкиваем регистр подтверждения для master 3
						end  																						
						else if (reg_master_3_ack) begin  												// Если регистр подтверждения запроса для master 3 в активном уровне
							reg_master_2_flag <= 'b0;  													// Устанавливаем флаг, того master 3 отработал и сбрасываем флаг master 2
							reg_master_3_flag <= 'b1;														 
							if (~reg_slave_3_cmd) begin 														// Если мы выполняли операцию чтения, тогда считываем в регистр данные со slave 3
								reg_master_3_rdata <= slave_3_rdata;	 								  															
							end 												 														 
							reg_master_3_ack <= 'b0; 														// Сбрасываем регистр подтверждения запроса
						end  																						
						else begin  																							
							reg_slave_3_wdata <= master_3_wdata;  										// Сбрасываем регистр подтверждения запроса 	
							reg_slave_3_cmd   <= master_3_cmd;  								 		// Иначе (формирование запроса)
							reg_slave_3_req   <= 'b1;  													// Защелкиваем код операции и записываемые данные в регистр
						end
					end	 			
	
					else if (master_3_addr[31:30] == 2'b00)  begin 									// Запрос master 3 к slave 4
						if (slave_4_ack) begin  															// Если пришло подтверждение запроса от slave 4
							reg_slave_4_req  <= 'b0;  														// Обнуляем регистр запроса master 3
							reg_master_3_ack <= 'b1;  														// Защелкиваем регистр подтверждения для master 3
						end  																						
						else if (reg_master_3_ack) begin  												// Если регистр подтверждения запроса для master 3 в активном уровне
							reg_master_2_flag <= 'b0;  													// Устанавливаем флаг, того master 3 отработал и сбрасываем флаг master 2
							reg_master_3_flag <= 'b1;														 
							if (~reg_slave_4_cmd) begin 														// Если мы выполняли операцию чтения, тогда считываем в регистр данные со slave 4
								reg_master_3_rdata <= slave_4_rdata;	 								  															
							end 												 														 
							reg_master_3_ack <= 'b0; 														// Сбрасываем регистр подтверждения запроса
						end  																						
						else begin  																							
							reg_slave_4_wdata <= master_3_wdata;  										// Сбрасываем регистр подтверждения запроса 	
							reg_slave_4_cmd   <= master_3_cmd;  									   // Иначе (формирование запроса)
							reg_slave_4_req   <= 'b1;  													// Защелкиваем код операции и записываемые данные в регистр
						end
					end
				end

				else if (master_4_req && ~reg_master_4_flag) begin :  master4req 		 		// Если пришел запрос от master 4 (и его очередь)
		
					if (master_4_addr[31:30] == 2'b11)  begin 										// Запрос master 4 к slave 1							 						
						if (slave_1_ack) begin 																// Если пришло подтверждение запроса от slave 1
							reg_slave_1_req  <= 'b0; 														// Обнуляем регистр запроса master 4
							reg_master_4_ack <= 'b1; 														// Защелкиваем регистр подтверждения для master 4
						end 																				       
						else if (reg_master_4_ack) begin 												// Если регистр подтверждения запроса для master 4 в активном уровне
							reg_master_3_flag <= 'b0; 														// Устанавливаем флаг, того master 4 отработал и сбрасываем флаг master 3
							reg_master_4_flag <= 'b1;														 
							if (~reg_slave_1_cmd) begin 														// Если мы выполняли операцию чтения, тогда считываем в регистр данные со slave 1
								reg_master_4_rdata <= slave_1_rdata;	 								  															
							end 												 														 
							reg_master_4_ack <= 'b0; 														// Сбрасываем регистр подтверждения запроса
						end 																				  									
						else begin 																													
							reg_slave_1_wdata <= master_4_wdata; 										// Сбрасываем регистр подтверждения запроса 	
							reg_slave_1_cmd   <= master_4_cmd; 											// Иначе (формирование запроса)
							reg_slave_1_req   <= 'b1; 														// Защелкиваем код операции и записываемые данные в регистр
						end
					end	 			
		
					else if (master_4_addr[31:30] == 2'b10)  begin 									// Запрос master 4 к slave 2
						if (slave_2_ack) begin  															// Если пришло подтверждение запроса от slave 2
							reg_slave_2_req  <= 'b0;  														// Обнуляем регистр запроса master 2
							reg_master_4_ack <= 'b1;  														// Защелкиваем регистр подтверждения для master 2
						end  																						
						else if (reg_master_4_ack) begin  												// Если регистр подтверждения запроса для master 2 в активном уровне
							reg_master_3_flag <= 'b0;  													// Устанавливаем флаг, того master 2 отработал и сбрасываем флаг master 3
							reg_master_4_flag <= 'b1;														 
							if (~reg_slave_2_cmd) begin 														// Если мы выполняли операцию чтения, тогда считываем в регистр данные со slave 2
								reg_master_4_rdata <= slave_2_rdata;	 								  															
							end 												 														 
							reg_master_4_ack <= 'b0; 														// Сбрасываем регистр подтверждения запроса
						end  																						
						else begin  																							
							reg_slave_2_wdata <= master_4_wdata;  										// Сбрасываем регистр подтверждения запроса 	
							reg_slave_2_cmd   		 <= master_4_cmd;  								// Иначе (формирование запроса)
							reg_slave_2_req  <= 'b1;  														// Защелкиваем код операции и записываемые данные в регистр
						end
					end	 			
		
					else if (master_4_addr[31:30] == 2'b01)  begin 									// Запрос master 4 к slave 3
						if (slave_3_ack) begin  															// Если пришло подтверждение запроса от slave 3
							reg_slave_3_req  <= 'b0;  														// Обнуляем регистр запроса master 3
							reg_master_4_ack <= 'b1;  														// Защелкиваем регистр подтверждения для master 3
						end  																						
						else if (reg_master_4_ack) begin  												// Если регистр подтверждения запроса для master 3 в активном уровне
							reg_master_3_flag <= 'b0;  													// Устанавливаем флаг, того master 3 отработал и сбрасываем флаг master 3
							reg_master_4_flag <= 'b1;														 
							if (~reg_slave_3_cmd) begin 														// Если мы выполняли операцию чтения, тогда считываем в регистр данные со slave 3
								reg_master_4_rdata <= slave_3_rdata;	 								  															
							end 												 														 
							reg_master_4_ack <= 'b0; 														// Сбрасываем регистр подтверждения запроса
						end  																						
						else begin  																							
							reg_slave_3_wdata <= master_4_wdata;  										// Сбрасываем регистр подтверждения запроса 	
							reg_slave_3_cmd   		 <= master_4_cmd;  								// Иначе (формирование запроса)
							reg_slave_3_req  <= 'b1;  														// Защелкиваем код операции и записываемые данные в регистр
						end
					end	 			
		
					else if (master_4_addr[31:30] == 2'b00)  begin 									// Запрос master 4 к slave 4
						if (slave_4_ack) begin  															// Если пришло подтверждение запроса от slave 4
							reg_slave_4_req  <= 'b0;  														// Обнуляем регистр запроса master 4
							reg_master_4_ack <= 'b1;  														// Защелкиваем регистр подтверждения для master 4
						end  																						
						else if (reg_master_4_ack) begin  												// Если регистр подтверждения запроса для master 4 в активном уровне
							reg_master_3_flag <= 'b0;  													// Устанавливаем флаг, того master 4 отработал и сбрасываем флаг master 3
							reg_master_4_flag <= 'b1;														 
							if (~reg_slave_4_cmd) begin 														// Если мы выполняли операцию чтения, тогда считываем в регистр данные со slave 2
								reg_master_4_rdata <= slave_4_rdata;	 								  															
							end 												 														 
							reg_master_4_ack <= 'b0; 														// Сбрасываем регистр подтверждения запроса
						end  																						
						else begin  																							
							reg_slave_4_wdata <= master_4_wdata;  										// Сбрасываем регистр подтверждения запроса 	
							reg_slave_4_cmd   <= master_4_cmd;  									   // Иначе (формирование запроса)
							reg_slave_4_req   <= 'b1;  													// Защелкиваем код операции и записываемые данные в регистр
						end
					end

				end
			end


			default : begin
				state <= wait_operation;
			end
		endcase
	end
end

assign slave_1_wdata   = reg_slave_1_wdata;
assign slave_2_wdata   = reg_slave_2_wdata;
assign slave_3_wdata   = reg_slave_3_wdata;
assign slave_4_wdata   = reg_slave_4_wdata;


assign slave_1_req 	  = reg_slave_1_req;
assign slave_2_req 	  = reg_slave_2_req;
assign slave_3_req 	  = reg_slave_3_req;
assign slave_4_req 	  = reg_slave_4_req;

assign master_1_rdata  = reg_master_1_rdata;
assign master_2_rdata  = reg_master_2_rdata;
assign master_3_rdata  = reg_master_3_rdata;
assign master_4_rdata  = reg_master_4_rdata;

assign slave_1_cmd 	  = reg_slave_1_cmd;
assign slave_2_cmd 	  = reg_slave_2_cmd;
assign slave_3_cmd 	  = reg_slave_3_cmd;
assign slave_4_cmd 	  = reg_slave_4_cmd;

assign master_1_ack 	  = reg_master_1_ack;
assign master_2_ack 	  = reg_master_2_ack;
assign master_3_ack 	  = reg_master_3_ack;
assign master_4_ack 	  = reg_master_4_ack;
endmodule

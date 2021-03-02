`timescale 1ns / 1ps

module Slave
#(parameter pInit_Delay = 50)
(
	input iClk, 							// Входной тактовый сигнал
	input iRst,						 		// Сигнал сброса
	input slave_req, 						// Сигнал запроса (Master->Slave)
	input slave_cmd, 						// Сигнал выбора операции (Master->Slave)
	input [31:0] slave_wdata, 			// Шина записываемых данных (Master->Slave)
	output slave_ack, 					// Сигнал подтверждение операции (Slave->Master)
	output [31:0] slave_rdata 			// Шина считываемых данных  (Slave->Master)
);


logic [31:0] reg_Read_Data; 			// Регистр для хранения считываемых данных
logic [31:0] reg_Slave_Data; 			// Регистр для хранения записываемых данных
logic [31:0] rCnt_Delay; 				// Счетчик для задержки
logic rAck; 								// Регистр для реализации сигнала подтверждения

enum logic [3:0] { 						// Состояния конечного автомата
	init_delay 	   = 4'b0001,
	wait_operation = 4'b0010,
	read_data  	   = 4'b0100,
	write_data 	   = 4'b1000
} state;
/*
initial begin
	state  	 		<= init_delay;
	reg_Slave_Data <= 'b0;
	reg_Read_Data 	<= 'b0;
	rCnt_Delay 		<= 'b1;
	rAck 				<= 'b0;
end
*/
always_ff @(posedge iClk) begin 	
	if (iRst) begin 						 // Если пришел сигнал сброса - обнуляем регистры
		state  	 		<= init_delay;
		reg_Slave_Data <= 'b0;
		reg_Read_Data  <= 'b0;
		rCnt_Delay 		<= 'b1;
		rAck 				<= 'b0;
	end
	else begin
		case (state)
			init_delay : begin 								// Состояние задержки
				if (rCnt_Delay < pInit_Delay) begin 	// Если не досчитали до конца - считаем
					rCnt_Delay <= rCnt_Delay + 1'b1;
				end
				else begin
					rCnt_Delay <= 'b1; 						// Если досчитали - сбрасываем счетчик
					state <= wait_operation; 				// И переходим в состояние ожидания запроса
				end
			end
			wait_operation : begin 							// Состояние ожидания запроса
				if (slave_req) begin 						// Если пришел запрос
					case (slave_cmd)
						0 : begin 								// Операция чтения
							rAck   	<= 'b1; 					// Формируем сигнал подтверждения
							state  	<= read_data;   		// И переходим в состояние чтения данных
						end
						1 : begin 								// Операция записи
							rAck   	<= 'b1; 					// Формируем сигнал подтверждения
							state  	<= write_data; 		// И переходим в состояние чтения данных
						end
						default : begin
							state <= wait_operation;
						end
					endcase
				end
			end
			read_data : begin 								// Состояние чтения данных
				reg_Read_Data  <= reg_Slave_Data; 		// Записываем в регистр считанные данные
				state 	   	<= wait_operation; 		// Переходим в состояние ожидания запроса
				rAck 		   	<= 'b0; 						// Заканчиываем формриовать запрос
			end
			write_data : begin								// Состояние записи данных
				reg_Slave_Data <= slave_wdata;			// Записываем в регистр записываемые данные
				state 	   	<= wait_operation;		// Переходим в состояние ожидания запроса
				rAck 		   	<= 'b0;						// Заканчиываем формриовать запрос
			end
			default : begin
				state <= wait_operation;
			end
		endcase
	end
end
/*Ассигнования*/
assign slave_rdata = reg_Read_Data;
assign slave_ack 	 = rAck;

endmodule

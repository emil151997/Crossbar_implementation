`timescale 1ns / 1ps

/*Модуль реализации Master'а*/

module Master
#(parameter pInit_Delay = 10) 		// Параметр на инициализацию
(
	input iClk, 							// Входной тактовый сигнал
	input iRst,								// Сигнал сброса
	input iStart,							// Сигнал формирования запроса
	input [31:0] iWrite_Data,			// Входная шина записываемых данных
	input [31:0] iAddr,					// Входная шина адреса
	input iOper,							// Сигнал выбора операции (0 - чтение, 1 - запись)
	input master_ack,						// Сигнал подтверждения (Slave->Master)
	input [31:0] master_rdata,			// Шина считываемых данных от (Slave->Master)
	output master_req,					// Выходной сигнал - запрос на выполнение транзакции (Master->Slave)
	output [31:0] master_addr,			// Выходная шина адреса (Master->Slave)
	output master_cmd,					// Выходной сигнал выбора операции (Master->Slave)
	output [31:0] master_wdata			// Выходная шина щаписываемых данных для slave (Master->Slave)
);

logic [31:0] rRead_Data; 				// Регистр, для хранения считываемых данных
logic [31:0] rWrite_Data; 				// Регистр, для хранения записываемых данных
logic rReq; 								// Регистр, формирования запроса
logic [31:0] rCnt_Delay; 				// Счетчик для задержки при запуске
logic rMaster_cmd; 						// Регистр для хранения выбора операции
logic [31:0] rAddr; 						// Регистр для хранения адреса
logic rStart; 						 		// Регистр для состояния, если придет сигнал во время выполнения транзакции


enum logic [4:0] { 						// Описание состояний конечного автомата
	init_delay 	   = 5'b00001, 		// Состояние инициализации
	wait_start 	   = 5'b00010, 		// Состояние ожидания сигнала Start
	wait_operation = 5'b00100, 		// Состояние ожидание операции
	read_data  	   = 5'b01000, 		// Состояние чтения со slave
	write_data 	   = 5'b10000 			// Состояние записи в slave
} state;

/*
initial begin
	state  		<= init_delay;
	rRead_Data 	<= 'b0;
	rWrite_Data <= 'b0;
	rCnt_Delay  <= 'b1;
	rReq 			<= 'b0;
	rMaster_cmd <= 'b0;
	rAddr 		<= 'b0;
	rStart		<= 'b0;
end
*/

always_ff @(posedge iClk) begin
	if (iRst) begin 											// Если пришел сигнал сброса - обнуляем регистры
		state  		<= init_delay;
		rRead_Data 	<= 'b0;
		rWrite_Data <= 'b0;
		rCnt_Delay  <= 'b1;
		rReq 			<= 'b0;
		rMaster_cmd <= 'b0;
		rAddr 		<= 'b0;
	end
	else begin
		case (state) 											
			init_delay : begin 								// Состояние задержки при инициализации
				if (rCnt_Delay < pInit_Delay) begin 	// Если не досчитали до конца - считаем
					rCnt_Delay <= rCnt_Delay + 1'b1;
				end
				else begin 										// Если досчитали
					rCnt_Delay <= 'b1; 				      // Сбрасываем счетчик
					state <= wait_start; 					// И переходим в состояние ожидания сигнала Start
				end
			end
			wait_start : begin
				if (rStart) begin 							// Если пришел сигнал Start, переходим в состояние ожидания операции
					state <= wait_operation;
				end
			end
			wait_operation : begin 					
				case (iOper)
				0 : begin 										// Если выбрана операция чтения 
					rMaster_cmd  <= 'b0; 					// Устанавливаем операцию чтения 
					rReq 		 	 <= 'b1; 					// Формируем запрос
					rAddr 		 <= iAddr; 					// Считываем в регистр адрес
					state  	    <= read_data; 			// Переходим в состояние чтения
				end
				1 : begin
					rMaster_cmd   <= 'b1;					// Устанавливаем операцию чтения 
					rReq 		  	  <= 'b1;					// Формируем запрос
					rWrite_Data   <= iWrite_Data;			// Считываем в регистр записываемые данные
					rAddr 		  <= iAddr;					// Считываем в регистр адрес
					state  		  <= write_data; 			// Переходим в состояние записи
				end
				default : begin
					state <= wait_operation;
				end
				endcase
			end
			read_data : begin 								// Состояние чтения данных
				if (master_ack) begin 						// Если пришло подтверждение запроса
					rReq <= 'b0; 								// Обнуляем запрос
					rRead_Data <= master_rdata; 			// Считываем в регистр полученные данные
					state 	   <= wait_start; 			// Переходим в состояние ожидания rStart
				end
			end
			write_data : begin								// Состояние Ззаписи данных
				if (master_ack) begin						// Если пришло подтверждение запроса
					rReq <= 'b0;								// Обнуляем запрос
					state <= wait_start;						// Переходим в состояние ожидания rStart
				end												
			end
			default : begin
				state <= wait_start;
			end
		endcase
	end
end

always_ff @(posedge iClk) begin 							// Реализация rStart (для случаев, когда сигнал приходит во время выполнения транзакции)
	if (iRst) begin
		rStart <= 'b0;
	end
	else begin
		if (iStart) begin 									// Если пришел сигнал iStart, защелкиваем регистр
			rStart <= 'b1;
		end
		else begin
			if (state == wait_start) begin 				// Обнуляем в тот момент, когда автомат попал в состояние ожидания Start'а
				rStart <= 'b0;
			end
		end
	end
end

/*Ассигнования*/
assign master_req   = rReq;
assign master_cmd   = rMaster_cmd;
assign master_wdata = rWrite_Data;
assign master_addr  = rAddr;
endmodule

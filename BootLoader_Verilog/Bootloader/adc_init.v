// SPI master

module adc_init (
   input clock,
	input reset,
	output reg SCLK,
	output reg SDATA,
	output reg SEN
	);
	
	
	
	
	// state mashine for initial
	reg [7:0] state, return_state;
	reg [4:0] address;
	reg [10:0] data;
	reg [15:0] word;
	reg [7:0] bit_cnt;
	//
	//wire gain; // Coarse gain 0-3.5dB or 2Vpp - 1.34Vpp maximum range
	//reg [2:0] fine_gain; // 0 - 6 dB gain
	
	initial
	begin
	   state = 0;
		bit_cnt = 0;
		SEN = 1;
		SCLK = 1;
	end
	
	always @(posedge clock)
	begin
	   if (!reset)
		begin
		   state <= 0;;
		end
	   else
	   case (state)
	   0: begin   // reset device
		      address <= 5'd0;
				data <= 11'b00_00001_0000;
				return_state <= 1;
				state <= 200;
			end	
	   1: begin
		      address <= 5'h00;
				data <= 11'b00_0000_00000;;
				return_state <= 2;
				state <= 200;
			end	
	   2: begin
		      address <= 5'h04;
				data <= 11'b00_0000_00000;
				return_state <= 3;
				state <= 200;
			end	
	   3: begin
		      address <= 5'h0A;
				data <= 11'b0_00_000_00000;
				return_state <= 4;
				state <= 200;
			end	
	   4: begin
		      address <= 5'h0C;
				data <= 11'b00_0000_00000;
				return_state <= 5;
				state <= 200;
			end
		5: begin
			   address <= 5'h00;
				data <= 11'd1;
				return_state <= 6;
				state <= 200;  
			end
      6: state <= 6;
	
		
		
	 200:	begin word <= {address, data}; SEN <= 0; state <= 201; end
	 201: begin SDATA <= word[15 - bit_cnt]; state <= 202; end
	 202: begin SCLK <= 0; state <= 203; end
	 203: if (bit_cnt != 15) begin bit_cnt <= bit_cnt +1'd1; SCLK <= 1; state <= 201; end
	      else begin bit_cnt <= 0; SEN <= 1; state <= 204; end
	 204: begin SCLK <= 1; state <= return_state; end		
	   endcase	
	
	end
   
	//
 
 
endmodule	
 
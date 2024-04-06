module PE_FSM #( parameter tile_length = 16)
(
 		clk
	 ,rst_n
   ,start_conv
	 ,start_again
	 ,cfg_ci
	 ,cfg_co
	 ,ifm_read
   ,p_valid_output
	 ,last_chanel_output
	 ,end_conv
	 ,wgt_read
);
  input clk; 
  input rst_n;
  input start_again;
  input start_conv;
  input [1:0] cfg_ci;
	input [1:0] cfg_co;
output ifm_read; 
output wgt_read;
output p_valid_output;
output last_chanel_output;
output end_conv;

reg [5:0] ci,co;
reg [5:0] cnt1;// counting pixel load  0 <cnt1< tiling size
reg [8:0] cnt2;// counting 
reg [4:0] cnt3;

reg [2:0] current_state;
reg [2:0] next_state;

reg ifm_read;
reg wgt_read;
reg p_valid;
reg last_chanel;
reg end_conv;

parameter IDLE    = 3'b000; 
parameter S1      = 3'b001;
parameter S2      = 3'b010;
parameter FINISH  = 3'b011;

always @(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
	  current_state <= IDLE;
	end
	else begin
    current_state <= next_state;
	end
end

	always @(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		ci <= 0;
		co <= 0;
	end
	else if(start_conv) begin
	  ci <= ((cfg_ci + 6'd1) << 3);
	  ci <= ((cfg_co + 6'd1) << 3);
	end
end

always @(current_state or start_conv or start_again or cnt1 or cnt2) begin
next_state = 3'bx;
	case(current_state)
		IDLE: begin
			if(start_again) begin
				next_state = S1;
			end
			else 
      if (start_again && cnt2 == 0 && cnt3 == 0) begin
				next_state = FINISH;
			end
			else begin
				next_state = IDLE;
			end
			end
		S1: 
			  next_state = (cnt1 == 4) ? S2:S1;
		S2: begin
			if(cnt2 == 0 && cnt1 == 0) begin
					next_state = IDLE;
				end
				else if(cnt1 == 0) begin
					next_state = S1;
				end
      	else begin
					next_state = IDLE;
				end
			end
			default next_state = IDLE;
	endcase
end

always @(posedge clk or rst_n) begin
	if(!rst_n) begin
		{ifm_read, wgt_read, p_valid, last_chanel, end_conv} <= 5'b00000;
	end
	else begin
		{ifm_read, wgt_read, p_valid, last_chanel, end_conv} <= 5'b00000;
	case(next_state)
		IDLE: {ifm_read, wgt_read, p_valid, last_chanel, end_conv} <= 5'b00000;
		S1: begin
			  {ifm_read,wgt_read,end_conv} <= 3'b110;
			  p_valid <= (cnt1 == 3 && cnt2 == 0) ? 1 : 0;
			  last_chanel <= (cnt1 == 3 && cnt2 ==0) ? 1 : 0;
			end
		S2: begin
			    {ifm_read,wgt_read,p_valid,end_conv} <= 4'b1010;
				  last_chanel <= (cnt2 == 0) ? 1 : 0;
				end
		FINISH: {ifm_read, wgt_read, p_valid, last_chanel, end_conv} <= 5'b00001;
    default:
          {ifm_read, wgt_read, p_valid, last_chanel, end_conv} <= 5'b00000;
  endcase
 end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		cnt1 <= 0;
		cnt2 <= 0;
		cnt3 <= 0;
	end
  else begin if(next_state == IDLE)
		cnt1 <= 0;
	           else begin 
                  if(cnt1 == tile_length + 2)
		                cnt1 <= 0;
	                else
		                cnt1 <= cnt1 + 1; 
		              if(cnt1 == 0) begin
			               if(cnt2 == ci-1)
				                cnt2 <= 0;
		                 else 
			                  cnt2 <= cnt2 + 1;
		                 if(cnt2 == 0) 
		   	               if(cnt3 == co*15-1)
				                 cnt3 <= 0;
		                   else 
			                   cnt3 <= cnt3 + 1;
		                 else 
			                  cnt3 <= cnt3;
                  end
		              else
			               cnt2 <= cnt2;
             end
  end
end

reg [2:0] p_valid_i;
reg [2:0] last_chanel_i;
reg p_valid_output;
reg last_chanel_output;
always @(posedge clk or negedge rst_n) begin
	if(rst_n) begin
		p_valid_output     <= 0;
        p_valid_i[2]       <= 0;
        p_valid_i[1]       <= 0;
        p_valid_i[0]       <= 0;
        last_chanel_output <= 0;  
        last_chanel_i[2]   <= 0;
        last_chanel_i[1]   <= 0;
        last_chanel_i[0]   <= 0;
    end 
		else begin
        p_valid_output     <= p_valid_i[2];
        p_valid_i[2]       <= p_valid_i[1];
        p_valid_i[1]       <= p_valid_i[0];
        p_valid_i[0]       <= p_valid;
        last_chanel_output <= last_chanel_i[2];
        last_chanel_i[2]   <= last_chanel_i[1];
        last_chanel_i[1]   <= last_chanel_i[0];
        last_chanel_i[0]   <= last_chanel;
    end
end

endmodule //PE

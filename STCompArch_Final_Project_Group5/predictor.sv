typedef enum logic [1:0] {SNT=0, WNT, WT, ST} e_state;


module predictor (
input clk,rst_n,
	input [31:0] PC_in, // PCF	
	input [2:0] Branch_Type,
	input  taken_flag,stallF,
	input  [31:0] PC_BRANCH_DECODED,instr_F,
	input  [15:0] offset,
	output logic HIT,hit_flag,miss_flag,
	output logic MISSED,
	output logic [31:0] OUT_PC,
	output logic state
);


logic [5:0] index;
reg [5:0] pc_tag [63:0];
reg [25:0] pc_remain [63:0];
reg valid [63:0];
e_state state_predictor [63:0];
reg [31:0] Predicted_PC [63:0];


integer i;
// logic miss_flag;// hit_flag;
logic [5:0] index_buf;
logic [31:0] PC_BUF, PC_BRANCH_DECODED_BUF;
logic taken_flag_buf;
wire [31:0] target;
// logic [2:0] Branch_Type;


always @ (*) begin
	    HIT=0;
	    MISSED=0;

	     index<=PC_in[5:0];

		  if(PC_in[5:0] == pc_tag[PC_in[5:0]] && valid[PC_in[5:0]])begin
		  	if(PC_in[31:6] == pc_remain[PC_in[5:0]])
		  		HIT=1;
		    else 
		    	MISSED=1;		
		  end
		  else if (((PC_in[5:0] != pc_tag[PC_in[5:0]] || !valid[PC_in[5:0]]) || PC_in[31:6] != pc_remain[PC_in[5:0]])) 
		    	MISSED=1;

end



always @(posedge clk or negedge rst_n) begin
    // if(stallF)
	 
	if(~rst_n)begin
	    for(i=0;i<64;i=i+1) begin
	    	PC_BUF<=0;
	    	miss_flag<=0;
	    	hit_flag<=0;
	    	index_buf<=0;
	    end
	end
    else begin
    	miss_flag<=MISSED;
    	hit_flag<=HIT;
    	PC_BUF<=PC_in;
    	// PC_BRANCH_DECODED_BUF<=PC_BRANCH_DECODED;
    	// Branch_Type<=Branch_Type;
    	index_buf<=index;
		end	
end


always @(posedge clk or negedge rst_n)begin
	taken_flag_buf<=taken_flag;
	if(~rst_n)begin
	    for(i=0;i<64;i=i+1) begin
	    	pc_tag[i]<=0;
	    	pc_remain[i]<=0;
	    	state_predictor[i]<=WNT;//weakly not taken
	    	valid[i]<=0;
	    	Predicted_PC[i]<=0;
	    end
	end
	else if (offset[15]==0) begin
	    if(miss_flag  && (Branch_Type!=3'b000) && (Branch_Type!=3'b111) && (index_buf != index)) begin
	       if(valid[index_buf]==0) begin
	    	pc_tag[index_buf]<=PC_BUF[5:0];
	        pc_remain[index_buf]<=PC_BUF[31:6];
	        if(!stallF)
	    	    Predicted_PC[index_buf] <= PC_BRANCH_DECODED;
	    	else
	    		Predicted_PC[index_buf] <= target;
	    	valid[index_buf]<=1;
	       end
         else begin
	    	if(state_predictor[index_buf]==ST && taken_flag)
	    		state_predictor[index_buf]<=ST;
	    	else 
	    		state_predictor[index_buf]<=state_predictor[index_buf].next();

	    	if(state_predictor[index_buf]==SNT  && !taken_flag)
	    		state_predictor[index_buf]<=SNT;
	    	else
	    		state_predictor[index_buf]<=state_predictor[index_buf].prev();
	    end
	    end
	   else if(taken_flag && hit_flag   && (Branch_Type!=3'b000) && (Branch_Type!=3'b111)) begin
      	      if(state_predictor[index_buf]==ST)
	    		  state_predictor[index_buf]<=ST;
	    	  else
	    		  state_predictor[index_buf]<=state_predictor[index_buf].next();
	    end
	    else if(!taken_flag && hit_flag   && (Branch_Type!=3'b000) && (Branch_Type!=3'b111))  begin
	    	if(state_predictor[index_buf]==SNT)
	    		state_predictor[index_buf]<=SNT;
	    	else
	    		state_predictor[index_buf]<=state_predictor[index_buf].prev();
	    end
	end
  else if(offset[15]==1) begin
  	if(miss_flag  && (Branch_Type!=3'b000) && (Branch_Type!=3'b111) && valid[index_buf]==0 && !stallF) begin
        pc_tag[index_buf]<=PC_BUF[5:0];
	    pc_remain[index_buf]<=PC_BUF[31:6];
	    valid[index_buf]<=1;
	    state_predictor[index_buf]<=WT;
	    Predicted_PC[index_buf]<=PC_BRANCH_DECODED;
  	end
  end
end

always@(posedge clk)
   OUT_PC <= Predicted_PC[index] ; 
assign state = ((state_predictor[index_buf]==WT || state_predictor[index_buf]==ST))? 1 : 0;
assign target = ({{16{instr_F[15]}},{instr_F[15:0]}, 2'b00})+PC_BUF+4;

endmodule

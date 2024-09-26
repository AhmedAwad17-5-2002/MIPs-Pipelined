module Hazards_Control_Unit(
	input RegWriteE,RegWriteM,RegWriteW,MemtoRegE,MemtoRegM,Jump_D,Jump_Link_D,jr_rs,jalr_rs,
	input [2:0] BranchD,
	input [4:0] rsD,rsE,rtD,rtE,WriteRegE,WriteRegM,WriteRegW,
	input exception,
	input BREAK_E,DivByZero,Interrupt,BREAK_D,state,
	input MISSED_BUF,HIT_BUF,PCSrc_D_E,PCSrc_D,
	input OverFlow_M,OverFlow_E,OverFlow_W,Undefined_Instruction,
	input offset, start_div_D, start_div_E, done_div_E,
	input mfc0_D,mfc0_E,mfc0_M,mfc0_W,
  input mul_en_D_out, mul_DONE,

	output reg [1:0] forwardAE, forwardBE,
	output reg forwardAD, forwardBD,
	output reg StallF , StallD , FlushE,
	output reg [1:0] forwardEXC,
  output jalr_rs_W_out,
  output jalr_rs_E_out,
  output jalr_rs_M_out
	);
// data hazard forward unit for rs and rt

reg FlushE_delayed;
wire stall_predict;
	always @(*) begin : proc_Forward
	    forwardAE=2'b00;
	    forwardBE=2'b00;
   

		if(RegWriteM && (rsE != 0) && (rsE == WriteRegM) && !OverFlow_M) //forward for rs
			forwardAE = 2'b10;
		else if(RegWriteW && (rsE != 0) && (rsE == WriteRegW))
			forwardAE = 2'b01;
		else
			forwardAE = 2'b00;

		if(RegWriteM && (rtE != 0) && (rtE == WriteRegM) && !OverFlow_M) // forward for rt
			forwardBE = 2'b10;
		else if(RegWriteW && (rtE != 0) && (rtE == WriteRegW))
			forwardBE = 2'b01;
		else
			forwardBE = 2'b00;	
	end	


always@(*)begin
	forwardEXC=0;
	if((BranchD!=3'd7&&BranchD!=3'd0) && mfc0_E && rsD==13)
		forwardEXC=1;
	else if((BranchD!=3'd7&&BranchD!=3'd0) && mfc0_M && rsD==13)
		forwardEXC=2;
end


always@(*) 	begin : proc_STALL_FLUSH
	     forwardAD=1'b0;
         forwardBD=1'b0; 
	     StallF=1'b1;
	     StallD=1'b1;
	     FlushE=1'b0;

     if(Interrupt)begin
     	StallF=1'b0;
	     StallD=1'b0;
	     FlushE=1'b1;
     end
     else if (OverFlow_E | OverFlow_M | BREAK_E) begin
	    	FlushE=1;
     end
     
     if ( (start_div_D && !done_div_E) || (mul_en_D_out && !mul_DONE) )   //start_div_E && !done_div_E 
       begin
         StallF=1'b0;
	       StallD=1'b0;
       end

		 if(((rsD== rtE) || (rtD== rtE)) && MemtoRegE) //lw stall
	   begin
	     StallF=1'b0;
	     StallD=1'b0;
	     FlushE=1'b1;
	   end
	 if((((BranchD!=3'd7&&BranchD!=3'd0) && ((!offset) || (!(((state&HIT_BUF) && !PCSrc_D))))|| jr_rs) && RegWriteE && (WriteRegE == rsD || WriteRegE == rtD)) || //branch and jump stall
	    (((BranchD!=3'd7&&BranchD!=3'd0) && ((!offset) || (!(((state&HIT_BUF) && !PCSrc_D))))|| jr_rs) && MemtoRegM && (WriteRegM == rsD || WriteRegM == rtD)))
	   begin
	     StallF=1'b0;
	     StallD=1'b0;
	     FlushE=1'b1;
	   end    
	  
	   if((jalr_rs && !jalr_rs_E_out) && (WriteRegE == rsD || WriteRegE == rtD))
	   begin
	   	 StallF=1'b0;
	     StallD=1'b0;
	     forwardAD =1'b1;
	   end

	    forwardAD=(rsD != 0) && (rsD == WriteRegM) && RegWriteM ; //forward for branch
      forwardBD=(rtD != 0) && (rtD == WriteRegM) && RegWriteM;

	end
endmodule

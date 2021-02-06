//file name: sync_ulse.v
//function : sync pulse for CDC
//author   : HateHanzo
module sync_pulse(
        clk_a   , 
        clk_b   , 
        rst_n   , 
	    pls_a   ,
	    pls_b 
);

//parametr
parameter DLY         = 1              ;

//input output
input                      clk_a    ;//clock a 
input                      clk_b    ;//clock b
input                      rst_n    ;//asyn reset,"0" active
input                      pls_a    ;//pulse in from clock a

output                     pls_b    ;//pulse out at clock b

//-----------------------------
//--signal
//-----------------------------
reg exp    ;
reg exp_d1 ;
reg exp_d2 ;
reg exp_d3 ;
reg b2a_d1 ;
reg b2a_d2 ;

//-----------------------------
//--main circuit
//-----------------------------

//change pulse into level in clk_a
always@(posedge clk_a or negedge rst_n)
begin
  if(!rst_n)
    exp <= #DLY 1'b0 ;
  else if(b2a_d2)
    exp <= #DLY 1'b0 ;
  else if(pls_a)
    exp <= #DLY 1'b1 ;
  else ;
end

//sync exp_d2 from clk_b
always@(posedge clk_b or negedge rst_n)
begin
  if(!rst_n) begin
    b2a_d1 <= #DLY 1'b0 ;
    b2a_d2 <= #DLY 1'b0 ;
  end
  else begin
    b2a_d1 <= #DLY exp_d2 ;
    b2a_d2 <= #DLY b2a_d1 ;
  end
end


//sync exp and generate pulse pls_b in clk_b
always@(posedge clk_b or negedge rst_n)
begin
  if(!rst_n) begin
    exp_d1 <= #DLY 1'b0 ;
    exp_d2 <= #DLY 1'b0 ;
    exp_d3 <= #DLY 1'b0 ;
  end
  else begin
    exp_d1 <= #DLY exp    ;
    exp_d2 <= #DLY exp_d1 ;
    exp_d3 <= #DLY exp_d2 ;
  end
end

wire pls_b = exp_d2 & (~exp_d3) ;


endmodule






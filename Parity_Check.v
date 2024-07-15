module Parity_Check(
  input wire CLK, RST,
  input wire par_chk_en,
  input wire PAR_TYPE,
  input wire sampled_bit,
  input wire [7 : 0] P_DATA,
  output reg par_err
  );

reg calculated_parity;

always @(posedge CLK, negedge RST)
begin
  calculated_parity = ^P_DATA;
  
  if(!RST)
    begin
      par_err <= 'b0;
    end 
  else if(par_chk_en)
    begin
      if((PAR_TYPE == 'b0 && calculated_parity == sampled_bit) || (PAR_TYPE == 'b1 && calculated_parity != sampled_bit))
        begin
          par_err <= 'b0;
        end
    
      else
        begin
          par_err <= 'b1;
        end
    end
  else
    begin
      par_err <= 'b0;
    end
        
end

endmodule

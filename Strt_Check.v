module Strt_Check(
  input wire CLK, RST,
  input wire strt_chk_en,
  input wire sampled_bit,
  output reg strt_glitch
  );

always @(posedge CLK, negedge RST)
begin
  if(!RST)
    begin
      strt_glitch <= 1'b0;
    end
  else if (strt_chk_en && sampled_bit)
    begin
      strt_glitch <= 1'b1;
    end
  else
    begin
      strt_glitch <= 1'b0;
    end 
end

endmodule
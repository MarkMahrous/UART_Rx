module Stop_Check(
  input wire CLK, RST,
  input wire stp_chk_en,
  input wire sampled_bit,
  output reg stp_err
  );

always @(posedge CLK, negedge RST)
begin
  if(!RST)
    begin
      stp_err <= 1'b0;
    end
  else if(stp_chk_en && !sampled_bit)
    begin
      stp_err <= 1'b1;
    end
  else
    begin
      stp_err <= 1'b0;
    end    
end

endmodule

module Deserializer(
  input wire CLK, RST,
  input wire deser_en,
  input wire sampled_bit,
  output reg [7 : 0] P_DATA
  );
 
always @(posedge CLK, negedge RST)
begin
  if(!RST)
    begin
      P_DATA <= 'b0;
    end
  else if(deser_en)
    begin
      P_DATA <= {P_DATA[6 : 0], sampled_bit};
    end
    
  else
    begin
      P_DATA = 'b0;
    end
end

endmodule

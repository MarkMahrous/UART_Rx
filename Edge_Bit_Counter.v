module Edge_Bit_Counter(
  input wire CLK, RST,
  input wire enable,
  input wire [5 : 0] Prescale,
  output reg [2 : 0] bit_cnt,
  output reg [4 : 0] edge_cnt
  );

always @(posedge CLK, negedge RST)
begin
  if(!RST)
    begin
    end
  else if(enable)
    begin
      case(Prescale)
        6'b000100: begin
          if(edge_cnt == 'b00011)
            begin
              bit_cnt = bit_cnt + 1;
              edge_cnt = 'b0;
            end
          else
            begin
              edge_cnt = edge_cnt + 1;
            end
        end
        6'b001000: begin
          if(edge_cnt == 'b00111)
            begin
              bit_cnt = bit_cnt + 1;
              edge_cnt = 'b0;
            end
          else
            begin
              edge_cnt = edge_cnt + 1;
            end
        end
        6'b010000: begin
          if(edge_cnt == 'b01111)
            begin
              bit_cnt = bit_cnt + 1;
              edge_cnt = 'b0;
            end
          else
            begin
              edge_cnt = edge_cnt + 1;
            end
        end
        6'b100000: begin
          if(edge_cnt == 'b11111)
            begin
              bit_cnt = bit_cnt + 1;
              edge_cnt = 'b0;
            end
          else
            begin
              edge_cnt = edge_cnt + 1;
            end
        end
        default: begin
          bit_cnt = 'b0;
          edge_cnt = 'b0;
        end
      endcase
    end
    
  else
    begin
      bit_cnt = 'b0;
      edge_cnt = 'b0;
    end
end
 
endmodule

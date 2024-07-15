module Data_Sampling(
  input wire CLK, RST,
  input wire dat_samp_en,
  input wire [4 : 0] edge_count,
  input wire [5 : 0] Prescale,
  input wire RX_IN,
  output reg sampled_bit
  );

reg [2:0] sample_index;
reg [2:0] zero_count;
reg [2:0] one_count;
reg sample_count [0:7];
integer i;
 

always @(posedge CLK, negedge RST)
begin
  if(!RST)
    begin
      sampled_bit = 1'b0;
      sample_index = 3'b000;
      zero_count = 3'b000;
      one_count = 3'b000;
      
      for (i = 0; i <= 7; i = i + 1) begin
        sample_count[i] = 'b0;
      end
    end
  else if(dat_samp_en)
    begin
      case(Prescale)
        6'b000100: begin
          if (edge_count == 0 || edge_count == 2)
            begin
              sample_count[sample_index] = RX_IN;
              sample_index = sample_index + 1;
            end
        end
        
        6'b001000: begin
          if (edge_count == 0 || edge_count == 4 || edge_count == 3 || edge_count == 5)
            begin
              sample_count[sample_index] = RX_IN;
              sample_index = sample_index + 1;
            end
        end
        
        6'b010000: begin 
          if (edge_count == 0 || edge_count == 8 || edge_count == 6 || 
              edge_count == 7 || edge_count == 9 || edge_count == 10)
            begin
              sample_count[sample_index] = RX_IN;
              sample_index = sample_index + 1;
            end
        end
        
        6'b100000: begin
          if (edge_count == 0 || edge_count == 16 || edge_count == 13 || 
              edge_count == 14 || edge_count == 15 || edge_count == 17 || 
              edge_count == 18 || edge_count == 19)
            begin
              sample_count[sample_index] = RX_IN;
              sample_index = sample_index + 1;
            end
        end
        default: begin
          sampled_bit = 1'b0;
          sample_index = 3'b000;
          zero_count = 3'b000;
          one_count = 3'b000;
      
          for (i = 0; i <= 7; i = i + 1) begin
            sample_count[i] = 'b0;
          end
        end
      endcase
      
      for (i = 0; i < sample_index; i = i + 1) begin
        if(sample_count[i])
          one_count = one_count + 1;
        else
          zero_count = zero_count + 1;
      end
      
      if(one_count > zero_count)
        sampled_bit = 'b1;
      else
        sampled_bit = 'b0;
    end
    
  else
    begin
      sampled_bit = 1'b0;
      sample_index = 3'b000;
      zero_count = 3'b000;
      one_count = 3'b000;
      
      for (i = 0; i <= 7; i = i + 1) begin
        sample_count[i] = 'b0;
      end
    end
end
 
endmodule

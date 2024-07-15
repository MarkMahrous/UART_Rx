module FSM(
  input wire CLK, RST,
  input wire RX_IN,
  input wire PAR_EN,
  input wire [5 : 0] Prescale,
  input wire [4 : 0] edge_cnt,
  input wire [2 : 0] bit_cnt,
  input wire par_err,
  input wire strt_glitch,
  input wire stp_err,
  output reg enable,
  output reg dat_samp_en,
  output reg strt_chk_en,
  output reg stp_chk_en,
  output reg par_chk_en,
  output reg deser_en,
  output reg Data_valid
  );

reg [2:0] current_state, next_state;

// gray state encoding
localparam  [2:0]      IDLE     = 3'b000 ,
                       START    = 3'b001 ,
                       DATA     = 3'b011 ,
                       PARITY   = 3'b010 ,
                       STOP     = 3'b110 ,
                       ERR_CHK  = 3'b111 ;

//state transition 
always @(posedge CLK or negedge RST)
begin
  if (!RST)
    current_state <= IDLE;
  else
    current_state <= next_state;
end

always @(*)
begin
  case (current_state)
    IDLE: begin
      if (!RX_IN)
        next_state = START;
      else
        next_state = IDLE;
    end
    START: begin
      if (edge_cnt == (Prescale >> 1))  // Middle of the start bit
        next_state = DATA;
      else
        next_state = START;
    end
    DATA: begin
      if (bit_cnt == 3'b111)
        next_state = PARITY;
      else
        next_state = DATA;
    end
    PARITY: begin
      if (PAR_EN)
        next_state = STOP;
      else
        next_state = ERR_CHK;
    end
    STOP: begin
      if (edge_cnt == Prescale)
        next_state = ERR_CHK;
      else
        next_state = STOP;
    end
    ERR_CHK: begin
      next_state = IDLE;
    end
    default: begin
      next_state = IDLE;
    end
  endcase
end

always @(*)
begin
  // Default assignments
  enable = 1'b0;
  dat_samp_en = 1'b0;
  strt_chk_en = 1'b0;
  stp_chk_en = 1'b0;
  par_chk_en = 1'b0;
  deser_en = 1'b0;
  Data_valid = 1'b0;
  
  case (current_state)
    IDLE: begin
      if (!RX_IN)
        enable = 1'b1;
    end
    START: begin
      strt_chk_en = 1'b1;
      dat_samp_en = 1'b1;
    end
    DATA: begin
      deser_en = 1'b1;
      dat_samp_en = 1'b1;
    end
    PARITY: begin
      if (PAR_EN)
        par_chk_en = 1'b1;
    end
    STOP: begin
      stp_chk_en = 1'b1;
      dat_samp_en = 1'b1;
    end
    ERR_CHK: begin
      Data_valid = !(strt_glitch || stp_err || (PAR_EN && par_err));
    end
  endcase
end

endmodule

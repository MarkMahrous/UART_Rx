module UART_RX(
  input wire CLK, RST,
  input wire PAR_TYPE,
  input wire PAR_EN,
  input wire [5 : 0] Prescale,
  input wire RX_IN,
  output reg [7 : 0] P_DATA,
  output reg Data_valid,
  output reg Parity_Error,
  output reg Stop_Error
  );

wire strt_chk_en;
wire stp_chk_en;
wire par_chk_en;
wire deser_en;
wire enable;
wire dat_samp_en;
wire sampled_bit;
wire strt_glitch;

wire [2 : 0] bit_cnt;
wire [4 : 0] edge_cnt; 

wire stp_err;
wire par_err;
wire Data_Valid;
wire [7 : 0]P_Data;

Strt_Check U0_Strt_Check(
.CLK(CLK),
.RST(RST),
.strt_chk_en(strt_chk_en),
.sampled_bit(sampled_bit),
.strt_glitch(strt_glitch)
);

Stop_Check U0_Stop_Check(
.CLK(CLK),
.RST(RST),
.stp_chk_en(stp_chk_en),
.sampled_bit(sampled_bit),
.stp_err(stp_err)
); 

Parity_Check U0_Parity_Check(
.CLK(CLK),
.RST(RST),
.par_chk_en(par_chk_en),
.PAR_TYPE(PAR_TYPE),
.sampled_bit(sampled_bit),
.P_DATA(P_Data),
.par_err(par_err)
);

Deserializer U0_Deserializer(
.CLK(CLK),
.RST(RST),
.deser_en(deser_en),
.sampled_bit(sampled_bit),
.P_DATA(P_Data)
);

Edge_Bit_Counter U0_Edge_Bit_Counter(
.CLK(CLK),
.RST(RST),
.enable(enable),
.Prescale(Prescale),
.bit_cnt(bit_cnt),
.edge_cnt(edge_cnt)
);

Data_Sampling U0_Data_Sampling(
.CLK(CLK),
.RST(RST),
.dat_samp_en(dat_samp_en),
.edge_count(edge_cnt),
.Prescale(Prescale),
.RX_IN(RX_IN),
.sampled_bit(sampled_bit)
);

FSM U0_FSM(
.CLK(CLK),
.RST(RST),
.RX_IN(RX_IN),
.PAR_EN(PAR_EN),
.Prescale(Prescale),
.edge_cnt(edge_cnt),
.bit_cnt(bit_cnt),
.par_err(par_err),
.strt_glitch(strt_glitch),
.stp_err(stp_err),
.enable(enable),
.dat_samp_en(dat_samp_en),
.strt_chk_en(strt_chk_en),
.stp_chk_en(stp_chk_en),
.par_chk_en(par_chk_en),
.deser_en(deser_en),
.Data_valid(Data_Valid)
);

always @(posedge CLK, negedge RST)
begin
  if(!RST)
    begin
      P_DATA <= 'b0;
      Data_valid <= 'b0;
      Parity_Error <= 'b0;
      Stop_Error <= 'b0;
    end
  else
    begin
      P_DATA <= P_Data;
      Data_valid <= Data_Valid;
      Parity_Error <= par_err;
      Stop_Error <= stp_err;
    end
end

endmodule
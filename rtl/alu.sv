module alu #(
  BW = 16 // bitwidth
  )(
  input  logic signed [BW-1:0] in_a,
  input  logic signed [BW-1:0] in_b,
  input  logic             [2:0] opcode,
  output logic signed [BW-1:0] out,
  output logic         [2:0] flags // {overflow, negative, zero}
  );

always_comb begin

out = 'b0;

case(opcode)

3'b000: out = in_a + in_b;
3'b001: out = in_a - in_b;
3'b010: out = in_a & in_b;
3'b011: out = in_a | in_b;
3'b100: out = in_a ^ in_b;
3'b101: out = in_a + 1'b1;
3'b110: out = in_a;
3'b111: out = in_b;

default: out = 'b0;

endcase

end


always_comb begin

flags = 3'b0;

if (opcode == 3'b000) begin // ADD
  flags[2] = (in_a[BW-1] == in_b[BW-1]) && (out[BW-1] != in_a[BW-1]);
end
else if (opcode == 3'b001) begin // SUB
  flags[2] = (in_a[BW-1] != in_b[BW-1]) && (out[BW-1] != in_a[BW-1]);
end


flags[1] = out[BW-1];


flags[0] = (out == 0);


end

endmodule









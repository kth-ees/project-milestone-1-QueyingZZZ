module alu_tb;

  parameter BW = 16; // bitwidth

  logic signed [BW-1:0] in_a;
  logic signed [BW-1:0] in_b;
  logic        [2:0]    opcode;
  logic signed [BW-1:0] out;
  logic        [2:0]    flags; // {overflow, negative, zero}

  // Instantiate the ALU
  alu #(BW) dut (
    .in_a(in_a),
    .in_b(in_b),
    .opcode(opcode),
    .out(out),
    .flags(flags)
  );

  // A task to apply stimulus
  task run_test(input logic signed [BW-1:0] a,
                input logic signed [BW-1:0] b,
                input logic [2:0] op);
  begin
    in_a = a;
    in_b = b;
    opcode = op;
    #1ns; // wait for combinational logic to settle
    $display("time=%0t | opcode=%b | in_a=%0d | in_b=%0d | out=%0d | flags=%b",
              $time, opcode, in_a, in_b, out, flags);
  end
  endtask

  // Generate stimuli to test the ALU
  initial begin
    // Test all opcodes with different values
    // Small values
    run_test(5, 3, 3'b000); // ADD
    run_test(5, 3, 3'b001); // SUB
    run_test(5, 3, 3'b010); // AND
    run_test(5, 3, 3'b011); // OR
    run_test(5, 3, 3'b100); // XOR
    run_test(5, 0, 3'b101); // INC
    run_test(5, 7, 3'b110); // MOVA
    run_test(5, 7, 3'b111); // MOVB

    // Negative values
    run_test(-5, -3, 3'b000);
    run_test(-5,  3, 3'b001);

    // Zero detection
    run_test(7, -7, 3'b000); // ADD -> 0
    run_test(5,  5, 3'b001); // SUB -> 0

    // Overflow cases
    run_test(16'sh7FFF, 1, 3'b000); // max + 1 -> overflow
    run_test(-32768, -1, 3'b001);   // min - (-1) -> overflow

    // Random tests
    repeat(10) begin
      run_test($random, $random, $urandom_range(0,7));
    end

    $finish;
  end

endmodule

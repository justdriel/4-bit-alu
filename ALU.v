module alu_4bit(
    input wire [3:0] A, B,  
    input wire sel,
    input wire [2:0] opcode,
    output reg [3:0] alu_out,  
    output reg alu_carry
);

    wire [3:0] sum_wire, sub_wire, and_wire, or_wire, xor_wire;
    wire [3:0] not_wireA, not_wireB;     
    wire [3:0] sll_wireA, sll_wireB;        
    wire [3:0] srl_wireA, srl_wireB;        
    wire carry_wire, borrow_wire;

    adder_4bit add_1(
        .A(A), .B(B), .cin(1'b0), 
        .sum(sum_wire), .cout(carry_wire)
    );

    subtractor_4bit sub_1(                 
        .A(A), .B(B), .bin(1'b0), 
        .diff(sub_wire), .bout(borrow_wire)
    );

    assign and_wire  = A & B;
    assign or_wire   = A | B;
    assign xor_wire  = A ^ B;
    assign not_wireA = ~A;
    assign not_wireB = ~B;
    assign sll_wireA = A << 1; 
    assign sll_wireB = B << 1; 
    assign srl_wireA = A >> 1;
    assign srl_wireB = B >> 1;

    always @(*) begin
        case(opcode)
            3'b000: begin alu_out = sum_wire;  alu_carry = carry_wire;   end
            3'b001: begin alu_out = sub_wire;  alu_carry = borrow_wire;  end
            3'b010: begin alu_out = and_wire;  alu_carry = 1'b0;         end
            3'b011: begin alu_out = or_wire;   alu_carry = 1'b0;         end
            3'b100: begin 
                if (sel) alu_out = not_wireA;
                else     alu_out = not_wireB;   
                alu_carry = 1'b0;
            end
            3'b101: begin alu_out = xor_wire;  alu_carry = 1'b0;         end
            3'b110: begin 
                if (sel) alu_out = sll_wireA;
                else     alu_out = sll_wireB;
                alu_carry = 1'b0;
            end 
            3'b111: begin 
                if (sel) alu_out = srl_wireA;
                else     alu_out = srl_wireB;
                alu_carry = 1'b0;
            end 
            default: begin alu_out = 4'b0000;  alu_carry = 1'b0;         end
        endcase
    end
endmodule































































module adder_4bit(
    input wire [3:0] A, B,
    input wire cin,
    output wire [3:0] sum,
    output wire cout
);

    wire c1, c2, c3;

    full_adder fa0 (A[0], B[0], cin, sum[0], c1);
    full_adder fa1 (A[1], B[1], c1,  sum[1], c2);
    full_adder fa2 (A[2], B[2], c2,  sum[2], c3);
    full_adder fa3 (A[3], B[3], c3,  sum[3], cout);

endmodule

module full_adder(


    input wire a, b, cin,
    output wire sum, cout
);

    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));
endmodule

module subractor_4bit(
    input wire [3:0] A, B,
    input wire bin,
    output wire [3:0] diff,
    output wire bout
);
   
    wire b1, b2, b3;

  
    full_subtractor fs0 (A[0], B[0], bin, diff[0], b1);
    full_subtractor fs1 (A[1], B[1], b1,  diff[1], b2);
    full_subtractor fs2 (A[2], B[2], b2,  diff[2], b3);
    full_subtractor fs3 (A[3], B[3], b3,  diff[3], bout);

endmodule

module full_subtractor(
    input wire a, b, bin,
    output wire diff, bout
);
    assign diff = a ^ b ^ bin;
    assign bout = (~a & b) | (bin & ~(a ^ b));
endmodule


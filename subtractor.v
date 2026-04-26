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


module full(
    input wire A, B,
    input wire cin,
    output wire sum,   
    output wire cout
);

    wire s1, c1, s2, c2; 

    
    half_adder ha0(
        .A(A),
        .B(B),
        .Sum(s1),      
        .Carry(c1)     
    );

    
    half_adder ha1(
        .A(s1),
        .B(cin),       
        .Sum(sum),    
        .Carry(c2)
    );

    
    assign cout = c1 | c2;

endmodule

module half_adder(
    input wire A, B,
    output wire Sum,
    output wire Carry  
);
    assign Sum = A ^ B; 
    assign Carry = A & B; 
endmodule
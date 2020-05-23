module half_adder(
    input a,
    input b,
    output y,
    output cout
);
    assign cout = a & b; // Carry over
    assign y    = a ^ b;
endmodule

module full_adder(
    input  a,
    input  b,
    input  cin,
    output y,
    output cout
);
    wire xor_ab;

    assign xor_ab   = a ^ b;
    assign y        = xor_ab ^ cin;
    assign cout     = (xor_ab & cin) | (a & b);
endmodule

module adder #(parameter integer C_WIDTH = 32)
(
    input  [C_WIDTH-1:0]a,
    input  [C_WIDTH-1:0]b,
    output [C_WIDTH:0]y
);
    wire carry[C_WIDTH:0];

    half_adder U_0(
        .a    (a[0]),
        .b    (b[0]),
        .y    (y[0]),
        .cout (carry[0]));

    generate
        genvar i;
        for(i = 1; i < C_WIDTH; i = i + 1) begin
            full_adder U_i(
                .a    (a[i]),
                .b    (b[i]),
                .cin  (carry[i - 1]),
                .cout (carry[i]),
                .y    (y[i]));
        end
    endgenerate
    assign y[C_WIDTH] = carry[C_WIDTH-1];
endmodule

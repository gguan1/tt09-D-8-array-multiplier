/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module array_mult (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
    wire [3:0] m=ui_in[7:4];
    wire [3:0] q=ui_in[3:0];
    wire [7:0] p;
    wire [3:0] s0, s1, s2, s3, s4;
    wire [3:0] c0, c1, c2, c3, c4;
    wire [3:0] mp0, mp1, mp2, mp3;
    
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : and_gen
            assign mp0[i] = m[0] & q[i];
            assign mp1[i] = m[1] & q[i];
            assign mp2[i] = m[2] & q[i];
            assign mp3[i] = m[3] & q[i];
            assign c0[i] = 1'b0;
            assign s0[i] = mp0[i];
        end
    endgenerate
 

    full_adder m1p0 (mp1[0], s0[1], c0[0], s1[0], c1[0]);
    full_adder m1p1 (mp1[1], s0[2], c0[1], s1[1], c1[1]);
    full_adder m1p2 (mp1[2], s0[3], c0[2], s1[2], c1[2]);
    full_adder m1p3 (mp1[3], 1'b0, c0[3], s1[3], c1[3]);
    
    full_adder m2p0 (mp2[0], s1[1], c1[0], s2[0], c2[0]);
    full_adder m2p1 (mp2[1], s1[2], c1[1], s2[1], c2[1]);
    full_adder m2p2 (mp2[2], s1[3], c1[2], s2[2], c2[2]);
    full_adder m2p3 (mp2[3], 1'b0, c1[3], s2[3], c2[3]);
    
    full_adder m3p0 (mp3[0], s2[1], c2[0], s3[0], c3[0]);
    full_adder m3p1 (mp3[1], s2[2], c2[1], s3[1], c3[1]);
    full_adder m3p2 (mp3[2], s2[3], c2[2], s3[2], c3[2]);
    full_adder m3p3 (mp3[3], 1'b0, c2[3], s3[3], c3[3]);
    
    full_adder cp4(s3[1], c3[0], 1'b0, s4[0], c4[0]);
    full_adder cp5(s3[2], c3[1], c4[0], s4[1], c4[1]);
    full_adder cp6(s3[3], c3[2], c4[1], s4[2], c4[2]);
    full_adder cp7(1'b0, c3[3], c4[2], s4[3], c4[3]);
    
    assign p = {s4[3], s4[2], s4[1], s4[0], s3[0], s2[0], s1[0], s0[0]};
    assign uo_out  = p;  // Example: ou_out is the sum of ui_in and uio_in
    assign uio_out = 0;
    assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
    wire _unused = &{ena, clk, rst_n, uio_in,1'b0};
endmodule
module full_adder(m_in, p_in, c_in, s_out, c_out);
    input m_in, p_in, c_in;
    output s_out, c_out;
    wire w1, w2, w3;
    xor(w1, m_in, p_in);
    xor(s_out, w1, c_in);
    and(w2, w1, c_in);
    and(w3, m_in, p_in);
    or(c_out, w2, w3);
endmodule
    

  

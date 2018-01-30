// projl5.v    using dff
// run  verilog -q -l proj5_v.out proj5.v
`timescale 1ns/1ns

module dff6(d, c, s, r, q, q_);
  input  d;     // q follows d when c goes 0 to 1
  input  c;     // clock, state change on transition
  input  s;     // set q to 1 when s is zero, keep s high
  input  r;     // set q to 0 when r is zero, keep r high
  output q;     // normal output
  output q_;    // complement output
  wire d1, d1_, d2, d2_;

  nand #1 (d1,  d1_, s,  d2_);
  nand #1 (d1_, d1,  c,  r);
  nand #1 (d2,  d2_, c,  d1_);
  nand #1 (d2_, d2,  r,  d);
  nand #1 (q,   q_,  s,  d1_);
  nand #1 (q_,  q,   r,  d2);

endmodule // dff6

module proj5;  // test bench
  // signals used in test bench (the interconnections)
  wire A, B, C, D, E, F, A_, B_, C_, D_, E_, F_;
  wire Ain, Bin, Cin, Din, Ein, Fin;
  wire activate;
  reg clk; 
  reg   s;
  reg   r;
  reg 	zer;
  integer   i;
  reg       I; 
  reg [0:9] rcvr;
   
   
  // instantiate   dff6  with signals
  //         d  c  s  r  q  q_
  dff6 dA(Ain, clk, r, s, A, A_);
  dff6 dB(Bin, clk, s, r, B, B_);
  dff6 dC(Cin, clk, s, r, C, C_);
// etc ???
   
  assign Ain = (A&~I); // |(...)|(...)...
  assign Bin = A&I;
// etc ???
 
  assign activate = F&I;
   
  initial
    begin  // test cases 
      $display("proj5.v running");
      rcvr = 10'b1011011101;
  
      s = 1'b1;
      r = 1'b0;  // reset, unreset in loop
      clk = 1'b0; // toggle in loop
      $display("rcvr=%b",rcvr);
      $display("A  =%b, B  =%b, C  =%b, D  =%b, E  =%b, F  =%b",
                A, B, C, D, E, F);
      $display("s=%b, r=%b, clk=%b", s, r, clk);
      I = rcvr[0];
      #3$display("Ain=%b, Bin=%b, Cin=%b, Din=%b, Ein=%b, Fin=%b",
                  Ain, Bin, Cin, Din, Ein, Fin);
      $display("A  =%b, B  =%b, C  =%b, D  =%b, E  =%b, F  =%b",
                A, B, C, D, E, F);
	  $display("clk=%b, i=%d, I=%b, activate=%b", clk, i, I, activate);
          $display(" ");
      r = 1'b1; 
       
      for(i=0; i<10; i=i+1)
	begin
          I = rcvr[i];
          #3$display("Ain=%b, Bin=%b, Cin=%b, Din=%b, Ein=%b, Fin=%b",
                      Ain, Bin, Cin, Din, Ein, Fin);
          $display("A  =%b, B  =%b, C  =%b, D  =%b, E  =%b, F  =%b",
                    A, B, C, D, E, F);
	  $display("clk=%b, i=%d, I=%b, activate=%b", clk, i, I, activate);
//          $display(" ");
	  clk = ~clk;
//          #3$display("Ain=%b, Bin=%b, Cin=%b, Din=%b, Ein=%b, Fin=%b",
//                      Ain, Bin, Cin, Din, Ein, Fin);
//          $display("A  =%b, B  =%b, C  =%b, D  =%b, E  =%b, F  =%b",
//                    A, B, C, D, E, F);
//	  $display("clk=%b, i=%d, I=%b, activate=%b", clk, i, I, activate);
          #3$display(" ");
	  clk = ~clk;
	end
    end
endmodule // proj5

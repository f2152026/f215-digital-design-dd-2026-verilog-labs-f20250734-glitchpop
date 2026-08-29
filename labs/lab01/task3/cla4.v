// cla4.v
// Gate-level 4-bit carry-lookahead adder, matching the lecture circuit.
// Every gate needs an explicit delay (constant is fine here, e.g. #(2)) --
// this is the default from Task 2 onward, not a special step.
//
// TODO -- Step 1: generate/propagate signals (one xor + one and per bit)
//   p[i] = a[i] ^ b[i]
//   g[i] = a[i] & b[i]
//
// TODO -- Step 2: direct (non-recursive) carry equations. Verilog's and/or
// primitives accept more than 2 inputs directly, e.g.:
//   and #(2) (t2, p1, p0, g0);
// so you do not need to manually chain 2-input gates.
//   c1 = g0 + p0.cin
//   c2 = g1 + p1.g0 + p1.p0.cin
//   c3 = g2 + p2.g1 + p2.p1.g0 + p2.p1.p0.cin
//   c4 = g3 + p3.g2 + p3.p2.g1 + p3.p2.p1.g0 + p3.p2.p1.p0.cin
//
// TODO -- Step 3: sum bits
//   sum[i] = p[i] ^ c[i]     (c0 = cin)

module cla4(
  input  [3:0] a,
  input  [3:0] b,
  input        cin,
  output [3:0] sum,
  output       cout
);

  wire p0, p1, p2, p3;
  wire g0, g1, g2, g3;
  wire c1, c2, c3;

  xor #(2) xp0 (p0, a[0], b[0]);
  xor #(2) xp1 (p1, a[1], b[1]);
  xor #(2) xp2 (p2, a[2], b[2]);
  xor #(2) xp3 (p3, a[3], b[3]);

  and #(2) ag0 (g0, a[0], b[0]);
  and #(2) ag1 (g1, a[1], b[1]);
  and #(2) ag2 (g2, a[2], b[2]);
  and #(2) ag3 (g3, a[3], b[3]);

  // ---- c1 = G0 + P0.cin ----
  wire t1;
  and #(2) a_t1 (t1, p0, cin);
  or  #(2) o_c1 (c1, g0, t1);

  // ---- c2 = G1 + P1.G0 + P1.P0.cin ----
  wire t2a, t2b;
  and #(2) a_t2a (t2a, p1, g0);
  and #(2) a_t2b (t2b, p1, p0, cin);
  or  #(2) o_c2  (c2, g1, t2a, t2b);

  // ---- c3 = G2 + P2.G1 + P2.P1.G0 + P2.P1.P0.cin ----
  wire t3a, t3b, t3c;
  and #(2) a_t3a (t3a, p2, g1);
  and #(2) a_t3b (t3b, p2, p1, g0);
  and #(2) a_t3c (t3c, p2, p1, p0, cin);
  or  #(2) o_c3  (c3, g2, t3a, t3b, t3c);

  // ---- cout = c4 = G3 + P3.G2 + P3.P2.G1 + P3.P2.P1.G0 + P3.P2.P1.P0.cin ----
  wire t4a, t4b, t4c, t4d;
  and #(2) a_t4a (t4a, p3, g2);
  and #(2) a_t4b (t4b, p3, p2, g1);
  and #(2) a_t4c (t4c, p3, p2, p1, g0);
  and #(2) a_t4d (t4d, p3, p2, p1, p0, cin);
  or  #(2) o_c4  (cout, g3, t4a, t4b, t4c, t4d);

  // ---- Sum bits ----
  xor #(2) xs0 (sum[0], p0, cin);
  xor #(2) xs1 (sum[1], p1, c1);
  xor #(2) xs2 (sum[2], p2, c2);
  xor #(2) xs3 (sum[3], p3, c3);

  // TODO: your gate-level P/G, carry, and sum logic goes here.
  // (cout should be connected to c4.) Remember the delay on every gate.

endmodule

/*
 * Copyright (c) 2015 Steven Stallion
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

`timescale 1ns / 10ps

module cpld(input  reset,
	    input  clear,
	    input  [3:0] addr,
	    output r, s, t, x, y, z,
	    input  clk_in,
	    output clk_out,
	    input  pia_e,
	    output pia_ca1, pia_cb1,
	    input  pia_ca2, pia_cb2,
	    output [6:0] pia_pa,
	    input  [6:0] pia_pb,
	    output pia_da,
	    input  fifo_rxf, fifo_txe,
	    output fifo_rd, fifo_wr,
	    inout  [7:0] fifo_data);

	addr_decode U1(
		.addr(addr),
		.r(r),
		.s(s),
		.t(t),
		.x(x),
		.y(y),
		.z(z)
	);

	clk_div U2(
		.reset(reset),
		.clk_in(clk_in),
		.clk_out(clk_out)
	);

	fifo_mux U3(
		.reset(reset),
		.clear(clear),
		.clk(clk_in),
		.pia_e(pia_e),
		.pia_ca1(pia_ca1),
		.pia_cb1(pia_cb1),
		.pia_ca2(pia_ca2),
		.pia_cb2(pia_cb2),
		.pia_pa(pia_pa),
		.pia_pb(pia_pb),
		.pia_da(pia_da),
		.fifo_rxf(fifo_rxf),
		.fifo_txe(fifo_txe),
		.fifo_rd(fifo_rd),
		.fifo_wr(fifo_wr),
		.fifo_data(fifo_data)
	);
endmodule

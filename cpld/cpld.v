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
	    input  clk_in,
	    output clk_out,
	    input  enable,
	    input  [3:0] addr,
	    output r, s, t, x, y, z,
	    output ca1, cb1,
	    input  ca2, cb2,
	    output [6:0] pa,
	    input  [6:0] pb,
	    input  fifo_rxf, fifo_txf,
	    output fifo_rd, fifo_wr,
	    inout  [6:0] fifo_data);

	clk_div clk_div(
		.reset(reset),
		.clk_in(clk_in),
		.clk_out(clk_out)
	);

	addr_decode addr_decode(
		.enable(enable),
		.addr(addr),
		.r(r),
		.s(s),
		.t(t),
		.x(x),
		.y(y),
		.z(z)
	);

	fifo_bridge fifo_bridge(
		.enable(enable),
		.ca1(ca1),
		.cb1(cb1),
		.ca2(ca2),
		.cb2(cb2),
		.pa(pa),
		.pb(pb),
		.fifo_rxf(fifo_rxf),
		.fifo_txe(fifo_txe),
		.fifo_rd(fifo_rd),
		.fifo_wr(fifo_wr),
		.fifo_data(fifo_data)
	);
endmodule

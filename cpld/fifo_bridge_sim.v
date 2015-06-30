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

module fifo_bridge_sim;
	reg  enable;
	wire ca1, cb1;
	reg  ca2, cb2;
	wire [6:0] pa;
	reg  [6:0] pb;
	reg  fifo_rxf, fifo_txe;
	wire fifo_rd, fifo_wr;
	wire [6:0] fifo_data;
	reg  [6:0] fifo_data_in;

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

	initial $monitor($time, " enable=%b ca1=%b cb1=%b ca2=%b cb2=%b pa=%x pb=%x fifo_rd=%b fifo_wr=%b fifo_rxf=%b fifo_txe=%b fifo_data=%x",
			 enable, ca1, cb1, ca2, cb2, pa, pb, fifo_rd, fifo_wr, fifo_rxf, fifo_txe, fifo_data);

	initial begin
		// keyboard input
		#500 enable	  <= 0;
	       	     ca2	  <= 0;
		     cb2	  <= 0;
		     fifo_rxf	  <= 0;
		     fifo_txe	  <= 0;
		     pb		  <= 0;
		     fifo_data_in <= 7'ha;
		#500 enable	  <= 1;
		     ca2	  <= 1;

		// terminal output
		#500 enable	  <= 0;
		     ca2	  <= 0;
		     cb2	  <= 0;
		     fifo_rxf	  <= 0;
		     fifo_txe	  <= 0;
		     pb		  <= 7'hb;
		     fifo_data_in <= 0;
		#500 enable	  <= 1;
		     cb2	  <= 1;
	end

	assign fifo_data = (enable && ca2) ? fifo_data_in : 7'bz;
endmodule

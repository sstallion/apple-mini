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

module fifo_mux_sim;
	reg  reset;
	reg  clear;
	reg  clk;
	reg  pia_e;
	wire pia_ca1, pia_cb1;
	reg  pia_ca2, pia_cb2;
	wire [6:0] pia_pa;
	reg  [6:0] pia_pb;
	wire pia_da;
	reg  fifo_rxf, fifo_txe;
	wire fifo_rd, fifo_wr;
	wire [7:0] fifo_data;
	reg  [7:0] fifo_data_in;

	fifo_mux U(
		.reset(reset),
		.clear(clear),
		.clk(clk),
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
	
	always #41.5 clk <= ~clk; // 12MHz


	initial $monitor($time, " reset=%b pia_e=%b pia_ca1=%b pia_cb1=%b pia_ca2=%b pia_cb2=%b pia_pa=%x pia_pb=%x pia_da=%b fifo_rd=%b fifo_wr=%b fifo_rxf=%b fifo_txe=%b fifo_data=%x",
			 reset, pia_e, pia_ca1, pia_cb1, pia_ca2, pia_cb2, pia_pa, pia_pb, pia_da, fifo_rd, fifo_wr, fifo_rxf, fifo_txe, fifo_data);

	initial begin
		reset <= 0;
		clear <= 0;
		clk <= 0;
		pia_e <= 0;

		$display("\nReset:");
		#500 reset <= 1;

		$display("\nKeyboard input:");
		#500 pia_e	  <= 0;
		     pia_ca2	  <= 0;
		     pia_cb2	  <= 0;
		     fifo_rxf	  <= 0;
		     fifo_txe	  <= 1;
		     pia_pb	  <= 0;
		     fifo_data_in <= 8'ha;
		#500 pia_e	  <= 1;
		     pia_ca2	  <= 1;
		#500 pia_e	  <= 0;
		     pia_ca2	  <= 0;
		     fifo_rxf	  <= 1;

		$display("\nTerminal output:");
		#500 pia_e	  <= 0;
		     pia_ca2	  <= 0;
		     pia_cb2	  <= 0;
		     fifo_rxf	  <= 1;
		     fifo_txe	  <= 0;
		     pia_pb	  <= 7'hb;
		     fifo_data_in <= 0;
		#500 pia_e	  <= 1;
		     pia_cb2	  <= 1;

		#500 pia_e	  <= 0;
		     pia_cb2	  <= 0;
		     fifo_txe	  <= 1;

		$finish;
	end

	assign fifo_data = (pia_e && pia_ca2) ? fifo_data_in : 8'bz;
endmodule

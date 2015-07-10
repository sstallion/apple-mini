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

module fifo_mux(input  reset,
		input  clk,
		input  pia_e,
		output reg pia_ca1, pia_cb1,
		input  pia_ca2, pia_cb2,
		output reg [6:0] pia_pa,
		input  [6:0] pia_pb,
		output pia_da,
		input  fifo_rxf, fifo_txe,
		output reg fifo_rd, fifo_wr,
		inout  [6:0] fifo_data);

	localparam STATE_READ_SETUP	   = 3'b000;
	localparam STATE_READ_STROBE_LOW   = 3'b001;
	localparam STATE_READ_STROBE_HIGH  = 3'b010;
	localparam STATE_WRITE_SETUP	   = 3'b100;
	localparam STATE_WRITE_STROBE_LOW  = 3'b101;
	localparam STATE_WRITE_STROBE_HIGH = 3'b110;

	localparam STATE_WRITE_MASK = 1<<2;

	reg [6:0] fifo_data_out;
	reg [2:0] state;

	always @(posedge clk) begin
		if (!reset) begin
			pia_ca1 <= 1'b0;
			pia_cb1 <= 1'b0;
			fifo_rd <= 1'b1;
			fifo_wr <= 1'b1;
			state <= STATE_READ_SETUP;
		end
		else if (!pia_e) begin
			pia_ca1 <= !fifo_rxf;
			pia_cb1 <= !fifo_txe;
			state <= STATE_READ_STROBE_LOW;
		end
		else begin
			case (state)
			STATE_READ_STROBE_LOW: begin
				if (pia_ca2) begin
					fifo_rd <= 1'b0;
				end
				state <= STATE_READ_STROBE_HIGH;
			end

			STATE_READ_STROBE_HIGH: begin
				if (pia_ca2) begin
					pia_pa <= fifo_data;
					fifo_rd <= 1'b1;
					pia_ca1 <= 1'b0;
				end
				state <= STATE_WRITE_SETUP;
			end

			STATE_WRITE_SETUP: begin
				if (pia_cb2) begin
					fifo_data_out <= pia_pb;
				end
				state <= STATE_WRITE_STROBE_LOW;
			end

			STATE_WRITE_STROBE_LOW: begin
				if (pia_cb2) begin
					fifo_wr <= 1'b0;
				end
				state <= STATE_WRITE_STROBE_HIGH;
			end

			STATE_WRITE_STROBE_HIGH: begin
				if (pia_cb2) begin
					fifo_wr <= 1'b1;
					pia_cb1 <= 1'b0;
				end
				state <= STATE_READ_SETUP;
			end
			endcase
		end
	end

	assign pia_da = pia_cb2 || fifo_txe;
	assign fifo_data = (state & STATE_WRITE_MASK) ? fifo_data_out : 7'bz;
endmodule

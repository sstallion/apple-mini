# Copyright (c) 2015 Steven Stallion
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.

IVL = iverilog
IVLFLAGS = -t$(IVLTARGET) -Wall
IVLTARGET = vvp

SIMS = addr_decode_sim clk_div_sim fifo_bridge_sim

.PHONY:	all clean

all:	$(SIMS)

clean:
	-$(RM) $(SIMS) a.out

addr_decode_sim: addr_decode_sim.v addr_decode.v
	$(IVL) $(IVLFLAGS) -o $@ $^

clk_div_sim: clk_div_sim.v clk_div.v
	$(IVL) $(IVLFLAGS) -o $@ $^

fifo_bridge_sim: fifo_bridge_sim.v fifo_bridge.v
	$(IVL) $(IVLFLAGS) -o $@ $^

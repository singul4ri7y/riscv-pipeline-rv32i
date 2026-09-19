all:
	iverilog -g2012 -o simu.vvp *.sv
	vvp simu.vvp

clean:
	rm -rf simu.vvp dump.vcd

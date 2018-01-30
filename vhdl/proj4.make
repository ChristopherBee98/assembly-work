# Makefile for Cadence "ldv" "ncvhdl"  VHDL
#
#      source vhdl_cshrc
#      make
#
# must have set up  cds.lib  and  hdl.var  in default directory
# must have subdirectory "vhdl_lib",  mkdir  vhdl_lib 

all: proj4.out

proj4.out:  proj4.vhdl proj4.run
	ncvhdl -v93 proj4.vhdl
	ncelab -v93 proj4:circuits
	ncsim -batch  -logfile proj4.out -input proj4.run proj4

clean:
	rm -f *.log
	rm -rf vhdl_lib
	mkdir  vhdl_lib


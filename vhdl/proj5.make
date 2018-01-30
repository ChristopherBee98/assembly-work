# Makefile for Cadence "ldv" "ncvhdl"  VHDL
#
#      source vhdl_cshrc
#      make
#
# must have set up  cds.lib  and  hdl.var  in default directory
# must have subdirectory "vhdl_lib",  mkdir  vhdl_lib 

all: proj5.out

proj5.out:  proj5.vhdl proj5.run
	ncvhdl -v93 proj5.vhdl
	ncelab -v93 proj5:circuits
	ncsim -batch  -logfile proj5.out -input proj5.run proj5

clean:
	rm -f *.log
	rm -rf vhdl_lib
	mkdir  vhdl_lib


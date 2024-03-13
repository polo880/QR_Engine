+v2k 
-debug_access+all 
+notimingcheck 
-P /usr/cad/synopsys/verdi/cur/share/PLI/VCS/LINUX64/novas.tab
/usr/cad/synopsys/verdi/cur/share/PLI/VCS/LINUX64/pli.a
-sverilog 
-assert svaext
+lint=TFIPC-L
+fsdb+parameter=on

-y /usr/cad/synopsys/synthesis/cur/dw/sim_ver +libext+.v
+incdir+/usr/cad/synopsys/synthesis/cur/dw/sim_ver/+

// Change different packets
+define+P1

// Add your RTL & SRAM files
QR_Engine.v
sram_256x8.v
DW_sqrt_pipe.v
DW_sqrt.v

//DW_div_pipe.v
//DW_div.v

div.v

DW02_mult_2_stage.v
// tb
testfixture-3.v
# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

# Switches
set_property PACKAGE_PIN V17 [get_ports {sw[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]
set_property PACKAGE_PIN V16 [get_ports {sw[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
set_property PACKAGE_PIN W16 [get_ports {sw[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]
set_property PACKAGE_PIN W17 [get_ports {sw[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[3]}]
set_property PACKAGE_PIN W15 [get_ports {sw[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[4]}]
set_property PACKAGE_PIN V15 [get_ports {sw[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[5]}]
set_property PACKAGE_PIN W14 [get_ports {sw[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[6]}]
set_property PACKAGE_PIN W13 [get_ports {sw[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[7]}]
set_property PACKAGE_PIN V2 [get_ports {sw[8]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[8]}]
set_property PACKAGE_PIN T3 [get_ports {sw[9]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[9]}]
set_property PACKAGE_PIN T2 [get_ports {sw[10]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[10]}]
set_property PACKAGE_PIN R3 [get_ports {sw[11]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[11]}]
set_property PACKAGE_PIN W2 [get_ports {sw_test_mode}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw_test_mode}]
#DVP
create_clock -add -name dvp_pclk_pin -period 10.00 -waveform {0 5} [get_ports dvp_pclk]
	set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets dvp_pclk_IBUF]

##Pmod Header JA
##Sch name = JA1
set_property PACKAGE_PIN J1 [get_ports {dvp_pclk}]
	set_property IOSTANDARD LVCMOS33 [get_ports {dvp_pclk}]
##Sch name = JA2
set_property PACKAGE_PIN L2 [get_ports {dvp_href}]
	set_property IOSTANDARD LVCMOS33 [get_ports {dvp_href}]
##Sch name = JA3
set_property PACKAGE_PIN J2 [get_ports {dvp_vsync}]
	set_property IOSTANDARD LVCMOS33 [get_ports {dvp_vsync}]
##Sch name = JA4
#set_property PACKAGE_PIN G2 [get_ports {JA[3]}]
#	set_property IOSTANDARD LVCMOS33 [get_ports {JA[3]}]
##Sch name = JA7
set_property PACKAGE_PIN H1 [get_ports {dvp_din[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {dvp_din[0]}]
##Sch name = JA8
set_property PACKAGE_PIN K2 [get_ports {dvp_din[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {dvp_din[1]}]
##Sch name = JA9
set_property PACKAGE_PIN H2 [get_ports {dvp_din[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {dvp_din[2]}]
##Sch name = JA10
set_property PACKAGE_PIN G3 [get_ports {dvp_din[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {dvp_din[3]}]

##Pmod Header JB
##Sch name = JB1
set_property PACKAGE_PIN A14 [get_ports {dvp_din[4]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {dvp_din[4]}]
##Sch name = JB2
set_property PACKAGE_PIN A16 [get_ports {dvp_din[5]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {dvp_din[5]}]
##Sch name = JB3
set_property PACKAGE_PIN B15 [get_ports {dvp_din[6]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {dvp_din[6]}]
##Sch name = JB4
set_property PACKAGE_PIN B16 [get_ports {dvp_din[7]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {dvp_din[7]}]
##Sch name = JB7
set_property PACKAGE_PIN A15 [get_ports {dvp_din[8]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {dvp_din[8]}]
##Sch name = JB8
set_property PACKAGE_PIN A17 [get_ports {dvp_din[9]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {dvp_din[9]}]
##Sch name = JB9
set_property PACKAGE_PIN C15 [get_ports {dvp_din[10]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {dvp_din[10]}]
##Sch name = JB10
set_property PACKAGE_PIN C16 [get_ports {dvp_din[11]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {dvp_din[11]}]
	
#VGA Connector
set_property PACKAGE_PIN G19 [get_ports {rgb[8]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {rgb[8]}]
set_property PACKAGE_PIN H19 [get_ports {rgb[9]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {rgb[9]}]
set_property PACKAGE_PIN J19 [get_ports {rgb[10]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {rgb[10]}]
set_property PACKAGE_PIN N19 [get_ports {rgb[11]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {rgb[11]}]
set_property PACKAGE_PIN N18 [get_ports {rgb[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {rgb[0]}]
set_property PACKAGE_PIN L18 [get_ports {rgb[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {rgb[1]}]
set_property PACKAGE_PIN K18 [get_ports {rgb[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {rgb[2]}]
set_property PACKAGE_PIN J18 [get_ports {rgb[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {rgb[3]}]
set_property PACKAGE_PIN J17 [get_ports {rgb[4]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {rgb[4]}]
set_property PACKAGE_PIN H17 [get_ports {rgb[5]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {rgb[5]}]
set_property PACKAGE_PIN G17 [get_ports {rgb[6]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {rgb[6]}]
set_property PACKAGE_PIN D17 [get_ports {rgb[7]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {rgb[7]}]
set_property PACKAGE_PIN P19 [get_ports hsync]						
	set_property IOSTANDARD LVCMOS33 [get_ports hsync]
set_property PACKAGE_PIN R19 [get_ports vsync]						
	set_property IOSTANDARD LVCMOS33 [get_ports vsync]

set_property PACKAGE_PIN U18 [get_ports reset]						
        set_property IOSTANDARD LVCMOS33 [get_ports reset]
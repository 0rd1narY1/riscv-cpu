set_host_options -max_cores 16

#设置搜索路径
set search_path "/media/ord1nary/Yes/SynopsysEDA/designcompiler2016/libraries/syn 
                 /media/ord1nary/Yes/SynopsysEDA/designcompiler2016/minpower/syn 
                 /media/ord1nary/Yes/SynopsysEDA/designcompiler2016/dw/syn_ver 
                 /media/ord1nary/Yes/SynopsysEDA/designcompiler2016/dw/sim_ver "
 
#设置标准元件库
set target_library "/media/ord1nary/Yes/SynopsysEDA/designcompiler2016/libraries/syn/lsi_10k.db"     
set link_library   "* $target_library "
#设置标准元件图标库
set symbol_library "/media/ord1nary/Yes/SynopsysEDA/designcompiler2016/libraries/syn/lsi_10k.sdb"  
 
set access_internal_pins true
 
#设置reports文件夹
set report_path "./reports"    
#设置outputs文件夹
set output_path "./outputs"    

set rtl_list [list ../src/cpu.v ../src/EXU/alu.v ../src/IFU/ifu.v \
                   ../src/IDU/decoder.v ../src/LSU/lsu.v ../src/ctrl_unit/ctrlu.v \
                   ../src/regfile/regfile.v ../src/regfile/memory.v]
analyze -f verilog $rtl_list
elaborate cpu
 
#指明主程序
current_design cpu 
#工艺库链接
link   
uniquify
 
set     design_name     [get_object_name [current_design]]
 
#设置线负载模型
set_wire_load_model -name "50x50"    
set_wire_load_mode top
 
#设置时钟，周期200ns，脉宽0-50ns
create_clock -period 100 -waveform {0 50} [get_ports clk_i]  -name clk    
 
#延迟时间2.5ns
set_clock_latency 3 clk    
#翻转时间0.3ns
set_clock_transition 0.3 clk    
#建立时间1.5ns
set_clock_uncertainty 2 -setup clk   
#保持时间0.3ns
set_clock_uncertainty 1 -hold clk    
 
#设置输入驱动强度为0
set_drive 0 [list clk_i rstn_i]      
#设置驱动单元
set_driving_cell -lib_cell FD1 -pin Q -no_design_rule [all_inputs]    
 
#设置输入延时20ns
set_input_delay  2 -clock [get_clocks clk] [all_inputs]   
#设置输出负载为2pF
set_load          2        [all_outputs]    
 
set_max_area 30000
 
check_design > $report_path/check_design_before_compile.rpt
check_timing > $report_path/check_timing_before_compile.rpt
 
compile
compile -incremental_mapping -map_effort high
 
#时序描述
write_sdf -version 2.1         $output_path/${design_name}_post_dc.sdf   
write -f ddc -hier -output     $output_path/${design_name}_post_dc.ddc
#网表
write -f verilog -hier -output $output_path/${design_name}_post_dc.v    
#约束
write_sdc                      $output_path/${design_name}_post_dc.sdc  
 
report_constraint -all_violators -verbose          > $report_path/constraint.rpt
report_qor                > $report_path/qor.rpt
report_power              > $report_path/power.rpt
report_area               > $report_path/area.rpt
report_cell               > $report_path/cell.rpt
report_clock              > $report_path/clk.rpt
report_hierarchy          > $report_path/hierarchy.rpt
report_design             > $report_path/design.rpt
report_reference          > $report_path/reference.rpt
report_timing             > $report_path/timing.rpt
 
check_design > $report_path/check_design_post_compile.rpt
check_timing > $report_path/check_timing_post_compile.rpt
 
#start_gui

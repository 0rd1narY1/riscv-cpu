debImport "-i" "-simflow" "-simBin" "./simv" "-simDelim" \
          "+UVM_VERBOSITY=UVM_LOW -a vcs.log +UVM_VERDI_TRACE=UVM_AWARE+RAL+HIER+COMPWAVE +UVM_LOG_RECORD"
srcTBInvokeSim
srcHBSelect "tb.i_cpu_soc.i_cpu.i_registers" -win $_nTrace1
srcSetScope -win $_nTrace1 "tb.i_cpu_soc.i_cpu.i_registers" -delim "."
srcDeselectAll -win $_nTrace1
srcSelect -signal "clk_i" -win $_nTrace1
srcSelect -signal "rstn_i" -win $_nTrace1
srcSelect -signal "regfile" -win $_nTrace1
wvCreateWindow
srcAddSelectedToWave -win $_nTrace1
verdiDockWidgetMaximize -dock windowDock_nWave_3
srcTBRunSim
verdiDockWidgetMaximize -dock windowDock_nWave_3
wvSelectSignal -win $_nWave3 {( "G1" 3 )} 
wvExpandBus -win $_nWave3 {("G1" 3)}
wvSetCursor -win $_nWave3 1040982.764921 -snap {("G1" 20)}
wvZoomIn -win $_nWave3
wvZoomIn -win $_nWave3
wvZoomIn -win $_nWave3
wvZoomIn -win $_nWave3
wvSetCursor -win $_nWave3 1104794.648295 -snap {("G1" 20)}
wvSetCursor -win $_nWave3 1123033.267357 -snap {("G1" 20)}
debExit

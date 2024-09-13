debImport "-i" "-simflow" "-simBin" "./simv" "-simDelim" \
          "+UVM_VERBOSITY=UVM_LOW -a vcs.log +UVM_VERDI_TRACE=UVM_AWARE+RAL+HIER+COMPWAVE +UVM_LOG_RECORD"
srcTBInvokeSim
srcHBSelect "tb.i_cpu_soc" -win $_nTrace1
srcSetScope -win $_nTrace1 "tb.i_cpu_soc" -delim "."
srcHBSelect "tb.i_cpu_soc.i_insn_mem" -win $_nTrace1
srcSetScope -win $_nTrace1 "tb.i_cpu_soc.i_insn_mem" -delim "."
srcDeselectAll -win $_nTrace1
srcSelect -signal "memory" -win $_nTrace1
wvCreateWindow
srcDeselectAll -win $_nTrace1
srcSelect -signal "memory" -win $_nTrace1
srcAddSelectedToWave -win $_nTrace1
srcTBRunSim
verdiDockWidgetMaximize -dock windowDock_nWave_3
wvSelectSignal -win $_nWave3 {( "G1" 1 )} 
wvExpandBus -win $_nWave3 {("G1" 1)}
debExit

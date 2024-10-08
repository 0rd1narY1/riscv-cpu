//
//----------------------------------------------------------------------
// Copyright 2011 AMD
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2007-2011 Mentor Graphics Corporation
// Copyright 2015-2024 NVIDIA Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// Git details (see DEVELOPMENT.md):
//
// $File:     src/base/uvm_bottomup_phase.svh $
// $Rev:      2024-02-08 13:43:04 -0800 $
// $Hash:     29e1e3f8ee4d4aa2035dba1aba401ce1c19aa340 $
//
//----------------------------------------------------------------------


//------------------------------------------------------------------------------
//
// Class -- NODOCS -- uvm_bottomup_phase
//
//------------------------------------------------------------------------------
// Virtual base class for function phases that operate bottom-up.
// The pure virtual function execute() is called for each component.
// This is the default traversal so is included only for naming.
//
// A bottom-up function phase completes when the <execute()> method
// has been called and returned on all applicable components
// in the hierarchy.

// @uvm-ieee 1800.2-2020 auto 9.5.1
virtual class uvm_bottomup_phase extends uvm_phase;


  // @uvm-ieee 1800.2-2020 auto 9.5.2.1
  function new(string name);
    super.new(name,UVM_PHASE_IMP);
  endfunction



  // @uvm-ieee 1800.2-2020 auto 9.5.2.2
  virtual function void traverse(uvm_component comp,
                                 uvm_phase phase,
                                 uvm_phase_state state);
    string name;
    uvm_domain phase_domain =phase.get_domain();
    uvm_domain comp_domain = comp.get_domain();
    uvm_phase_hopper hopper;
    hopper = uvm_phase_hopper::get_global_hopper();

    if (comp.get_first_child(name)) begin
      
      do begin
        
        hopper.traverse_on(this, comp.get_child(name), phase, state);
      end
      while(comp.get_next_child(name));
    end


    if (m_phase_trace) begin
      `uvm_info("PH_TRACE",
      $sformatf("bottomup-phase phase=%s state=%s comp=%s comp.domain=%s phase.domain=%s",
      phase.get_name(), state.name(), comp.get_full_name(),comp_domain.get_name(),phase_domain.get_name()),
      UVM_DEBUG)
    end
      
    if (phase_domain == uvm_domain::get_common_domain() ||
        phase_domain == comp_domain) begin
      case (state)
        UVM_PHASE_STARTED: begin
          comp.m_current_phase = phase;
          comp.m_apply_verbosity_settings(phase);
          comp.phase_started(phase);
        end
        UVM_PHASE_EXECUTING: begin
          uvm_phase ph = this; 
          if (comp.m_phase_imps.exists(this)) begin
            
            ph = comp.m_phase_imps[this];
          end

          hopper.execute_on(ph, comp, phase);
        end
        UVM_PHASE_READY_TO_END: begin
          comp.phase_ready_to_end(phase);
        end
        UVM_PHASE_ENDED: begin
          comp.phase_ended(phase);
          comp.m_current_phase = null;
        end
        default: begin
          `uvm_fatal("PH_BADEXEC","bottomup phase traverse internal error")
        end
      endcase
    end
  endfunction



  // @uvm-ieee 1800.2-2020 auto 9.5.2.3
  virtual function void execute(uvm_component comp,
                                          uvm_phase phase);
    // reseed this process for random stability
    process proc = process::self();
    proc.srandom(uvm_create_random_seed(phase.get_type_name(), comp.get_full_name()));

    comp.m_current_phase = phase;
    exec_func(comp,phase);
  endfunction

endclass

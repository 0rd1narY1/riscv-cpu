//----------------------------------------------------------------------
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2007-2011 Mentor Graphics Corporation
// Copyright 2020-2024 NVIDIA Corporation
// Copyright 2010 Synopsys, Inc.
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
// $File:     src/seq/uvm_sequencer_analysis_fifo.svh $
// $Rev:      2024-02-08 13:43:04 -0800 $
// $Hash:     29e1e3f8ee4d4aa2035dba1aba401ce1c19aa340 $
//
//----------------------------------------------------------------------



class uvm_sequencer_analysis_fifo #(type RSP = uvm_sequence_item) extends uvm_tlm_fifo #(RSP);

  uvm_analysis_imp #(RSP, uvm_sequencer_analysis_fifo #(RSP)) analysis_export;
  uvm_sequencer_base sequencer_ptr;

  function new (string name, uvm_component parent = null);
    super.new(name, parent, 0);
    analysis_export = new ("analysis_export", this);
  endfunction

  function void write(input RSP t);
    if (sequencer_ptr == null)
      begin
        uvm_report_fatal ("SEQRNULL", "The sequencer pointer is null when attempting a write", UVM_NONE);
      end

    sequencer_ptr.analysis_write(t);
  endfunction // void
endclass

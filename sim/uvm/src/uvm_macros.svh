//
//----------------------------------------------------------------------
// Copyright 2010-2018 AMD
// Copyright 2007-2021 Cadence Design Systems, Inc.
// Copyright 2021 Marvell International Ltd.
// Copyright 2007-2013 Mentor Graphics Corporation
// Copyright 2013-2024 NVIDIA Corporation
// Copyright 2010-2014 Synopsys, Inc.
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
// $File:     src/uvm_macros.svh $
// $Rev:      2024-02-08 13:43:04 -0800 $
// $Hash:     29e1e3f8ee4d4aa2035dba1aba401ce1c19aa340 $
//
//----------------------------------------------------------------------


`ifndef UVM_MACROS_SVH
`define UVM_MACROS_SVH

//
// Any vendor specific defines go here.
//

`ifdef MODEL_TECH
`ifndef QUESTA
`define QUESTA
`endif
`endif

`ifndef UVM_USE_STRING_QUEUE_STREAMING_PACK
  `define UVM_STRING_QUEUE_STREAMING_PACK(q) uvm_pkg::m_uvm_string_queue_join(q)
`endif

`ifndef QUESTA
`define uvm_typename(X) $typename(X)
`else
`define uvm_typename(X) $typename(X,39)
`endif

`ifdef VCS
`endif


// cadence simulators xcelium/inca 
`ifndef XCELIUM
`ifdef INCA
`define UVM_XCELIUM
`define UVM_USE_PROCESS_CONTAINER
`endif
`endif
`ifdef XCELIUM
`define UVM_XCELIUM
`define UVM_USE_PROCESS_CONTAINER
`define DPI_COMPATIBILITY_VERSION_1800v2005
`endif

`define uvm_delay(TIME) #(TIME);


`include "macros/uvm_version_defines.svh"
`include "macros/uvm_global_defines.svh"
`include "macros/uvm_message_defines.svh"
`include "macros/uvm_phase_defines.svh"
`include "macros/uvm_printer_defines.svh"
`include "macros/uvm_comparer_defines.svh"
`include "macros/uvm_recorder_defines.svh"
`include "macros/uvm_resource_defines.svh"
`include "macros/uvm_packer_defines.svh"
`include "macros/uvm_copier_defines.svh"
 `include "macros/uvm_object_defines.svh"
`include "macros/uvm_tlm_defines.svh"
`include "macros/uvm_sequence_defines.svh"
`include "macros/uvm_callback_defines.svh"
`include "macros/uvm_reg_defines.svh"

`include "deprecated/macros/uvm_sequence_defines.svh"

`endif

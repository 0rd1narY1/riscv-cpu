//
//----------------------------------------------------------------------
// Copyright 2010 AMD
// Copyright 2010-2023 Cadence Design Systems, Inc.
// Copyright 2022 Marvell International Ltd.
// Copyright 2010-2011 Mentor Graphics Corporation
// Copyright 2013-2024 NVIDIA Corporation
// Copyright 2010-2011 Synopsys, Inc.
//
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
// $File:     compat/uvm_compat_pkg.sv $
// $Rev:      2024-02-08 13:43:04 -0800 $
// $Hash:     29e1e3f8ee4d4aa2035dba1aba401ce1c19aa340 $
//
//----------------------------------------------------------------------

`ifndef UVM_COMPAT_PKG_SV
`define UVM_COMPAT_PKG_SV

`include "uvm_macros.svh"
`include "uvm_compat_macros.svh"

package uvm_compat_pkg;

  import uvm_pkg::*;

`include "uvm_compat_packer.svh"
`include "uvm_compat_proxy_sequence.svh"
  
  
endpackage

`endif

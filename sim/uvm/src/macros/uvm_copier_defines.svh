//----------------------------------------------------------------------
// Copyright 2018 Cadence Design Systems, Inc.
// Copyright 2018-2024 NVIDIA Corporation
// Copyright 2018 Qualcomm, Inc.
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
// $File:     src/macros/uvm_copier_defines.svh $
// $Rev:      2024-02-08 13:43:04 -0800 $
// $Hash:     29e1e3f8ee4d4aa2035dba1aba401ce1c19aa340 $
//
//----------------------------------------------------------------------


//------------------------------------------------------------------------------
//
// MACROS for uvm_copier usage
//
// Provides a set of comparison macros that will call appropriate methods
// inside of a uvm_copier object.
//
//------------------------------------------------------------------------------

`ifndef UVM_COPIER_DEFINES_SVH
 `define UVM_COPIER_DEFINES_SVH

// uvm_copy_object

`define uvm_copy_object(LVALUE, RVALUE, POLICY=UVM_DEFAULT_POLICY, COPIER=copier) \
if (LVALUE != RVALUE) begin \
  if ((RVALUE == null) || \
      (POLICY == UVM_REFERENCE) || \
      ((POLICY == UVM_DEFAULT_POLICY) && \
       (COPIER.get_recursion_policy() == UVM_REFERENCE))) begin \
    LVALUE = RVALUE; \
  end \
  else begin \
    uvm_object lvalue_ref__; \
    if (!COPIER.get_first_copy(RVALUE,lvalue_ref__) || !$cast(LVALUE,lvalue_ref__)) begin \
        uvm_recursion_policy_enum prev_pol__ = COPIER.get_recursion_policy(); \
        uvm_recursion_policy_enum curr_pol__; \
        if (POLICY != UVM_DEFAULT_POLICY) \
          COPIER.set_recursion_policy(POLICY); \
        curr_pol__ = COPIER.get_recursion_policy(); \
        if (LVALUE == null) begin \
          if (($cast(LVALUE, RVALUE.create(RVALUE.get_name())) == 0) || \
              (LVALUE == null)) begin \
            `uvm_fatal("UVM/COPY/NULL_CREATE", \
                   {"Could not create '", RVALUE.get_full_name(), \
                        "' of type '", RVALUE.get_type_name(), \
                        "', into '", `"LVALUE`", "'."}) \
          end \
          else begin \
             COPIER.copy_object(LVALUE, RVALUE); \
          end \
        end \
        else begin \
           if (COPIER.object_copied(LVALUE, RVALUE, curr_pol__) == uvm_policy::STARTED) begin \
             `uvm_warning("UVM/COPY/LOOP", \
                      {"Loop detected in copy operation (LHS:'", \
                   LVALUE.get_full_name(), \
                   "', RHS:'", \
                           RVALUE.get_full_name(), \
                   "')"}) \
           end \
           else begin \
             COPIER.copy_object(LVALUE, RVALUE); \
           end \
        end \
        if (POLICY != UVM_DEFAULT_POLICY) \
          COPIER.set_recursion_policy(prev_pol__); \
     end \
  end \
end

`define uvm_copy_aa_object(LVALUE, RVALUE, POLICY=UVM_DEFAULT_POLICY, COPIER=copier) \
if ((POLICY == UVM_REFERENCE) || !RVALUE.size()) \
  LVALUE = RVALUE; \
else begin \
  LVALUE.delete(); \
  foreach(RVALUE[i]) \
    `uvm_copy_object(LVALUE[i], RVALUE[i], POLICY, COPIER) \
end


`define uvm_copier_get_function(FUNCTION) \
function int get_``FUNCTION``_copy(uvm_object rhs, ref uvm_object lhs); \
  if (m_recur_states.exists(rhs)) \
    return m_recur_states[rhs].FUNCTION(lhs); \
  return 0; \
endfunction : get_``FUNCTION``_copy

`endif // UVM_COPIER_DEFINES_SVH

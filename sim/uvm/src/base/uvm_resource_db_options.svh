//----------------------------------------------------------------------
// Copyright 2018 Cadence Design Systems, Inc.
// Copyright 2017 Cisco Systems, Inc.
// Copyright 2018-2024 NVIDIA Corporation
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
// $File:     src/base/uvm_resource_db_options.svh $
// $Rev:      2024-02-08 13:43:04 -0800 $
// $Hash:     29e1e3f8ee4d4aa2035dba1aba401ce1c19aa340 $
//
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// Title -- NODOCS -- UVM Resource Database
//
// Topic: Intro
//
// The <uvm_resource_db> class provides a convenience interface for
// the resources facility.  In many cases basic operations such as
// creating and setting a resource or getting a resource could take
// multiple lines of code using the interfaces in <uvm_resource_base> or
// <uvm_resource#(T)>.  The convenience layer in <uvm_resource_db>
// reduces many of those operations to a single line of code.
//
// If the run-time ~+UVM_RESOURCE_DB_TRACE~ command line option is
// specified, all resource DB accesses (read and write) are displayed.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Class: uvm_resource_db_options
//
// This class contains static functions for manipulating and
// retrieving options that control the behavior of the 
// resources DB facility.
//
// @uvm-accellera The details of this API are specific to the Accellera implementation, and are not being considered for contribution to 1800.2
//----------------------------------------------------------------------
class uvm_resource_db_options;
   
  static local bit ready;
  static local bit tracing;

  // Function: turn_on_tracing
  //
  // Turn tracing on for the resource database. This causes all
  // reads and writes to the database to display information about
  // the accesses. Tracing is off by default.
  //
  // This method is implicitly called by the ~+UVM_RESOURCE_DB_TRACE~.
  //
  // @uvm-accellera The details of this API are specific to the Accellera implementation, and are not being considered for contribution to 1800.2


  static function void turn_on_tracing();
     if (!ready) begin
       init();
     end

    tracing = 1;
  endfunction

  // Function: turn_off_tracing
  //
  // Turn tracing off for the resource database.
  //
  // @uvm-accellera The details of this API are specific to the Accellera implementation, and are not being considered for contribution to 1800.2


  static function void turn_off_tracing();
     if (!ready) begin
       init();
     end

    tracing = 0;
  endfunction

  // Function: is_tracing
  //
  // Returns 1 if the tracing facility is on and 0 if it is off.
  //
  // @uvm-accellera The details of this API are specific to the Accellera implementation, and are not being considered for contribution to 1800.2


  static function bit is_tracing();
    if (!ready) begin
      init();
    end

    return tracing;
  endfunction


  static local function void init();
     uvm_cmdline_processor clp;
     string trace_args[$];
     
     clp = uvm_cmdline_processor::get_inst();

     if (clp.get_arg_matches("+UVM_RESOURCE_DB_TRACE", trace_args)) begin
       tracing = 1;
     end

     ready = 1;
  endfunction

endclass

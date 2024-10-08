//
//-----------------------------------------------------------------------------
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2017 Cisco Systems, Inc.
// Copyright 2007-2009 Mentor Graphics Corporation
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
//-----------------------------------------------------------------------------

//----------------------------------------------------------------------
// Git details (see DEVELOPMENT.md):
//
// $File:     src/base/uvm_text_tr_stream.svh $
// $Rev:      2024-02-08 13:43:04 -0800 $
// $Hash:     29e1e3f8ee4d4aa2035dba1aba401ce1c19aa340 $
//
//----------------------------------------------------------------------



//------------------------------------------------------------------------------
//
// CLASS: uvm_text_tr_stream
//
// The ~uvm_text_tr_stream~ is the default stream implementation for the
// <uvm_text_tr_database>.  
//
//                     
// @uvm-accellera The details of this API are specific to the Accellera implementation, and are not being considered for contribution to 1800.2

class uvm_text_tr_stream extends uvm_tr_stream;

   // Variable- m_text_db
   // Internal reference to the text-based backend
   local uvm_text_tr_database m_text_db;
   
   `uvm_object_utils_begin(uvm_text_tr_stream)
   `uvm_object_utils_end

   // Function: new
   // Constructor
   //
   // Parameters:
   // name - Instance name
   function new(string name="unnamed-uvm_text_tr_stream");
      super.new(name);
   endfunction : new

   // Group: Implementation Agnostic API

   // Function: do_open
   // Callback triggered via <uvm_tr_database::open_stream>.
   //
   // @uvm-accellera The details of this API are specific to the Accellera implementation, and are not being considered for contribution to 1800.2
   protected virtual function void do_open(uvm_tr_database db,
                                           string scope,
                                           string stream_type_name);
      $cast(m_text_db, db);
      if (m_text_db.open_db())
        begin
          $fdisplay(m_text_db.m_file, 
                  "  CREATE_STREAM @%0t {NAME:%s T:%s SCOPE:%s STREAM:%0d}",
                  $time,
                  this.get_name(),
                  stream_type_name,
                  scope,
                  this.get_handle());
        end

   endfunction : do_open

   // Function: do_close
   // Callback triggered via <uvm_tr_stream::close>.
   //
   // @uvm-accellera The details of this API are specific to the Accellera implementation, and are not being considered for contribution to 1800.2
   protected virtual function void do_close();
      if (m_text_db.open_db())
        begin
          $fdisplay(m_text_db.m_file,
                  "  CLOSE_STREAM @%0t {NAME:%s T:%s SCOPE:%s STREAM:%0d}",
                  $time,
                  this.get_name(),
                  this.get_stream_type_name(),
                  this.get_scope(),
                  this.get_handle());
        end

   endfunction : do_close
      
   // Function: do_free
   // Callback triggered via <uvm_tr_stream::free>.
   //
   // @uvm-accellera The details of this API are specific to the Accellera implementation, and are not being considered for contribution to 1800.2
   protected virtual function void do_free();
      if (m_text_db.open_db())
        begin
          $fdisplay(m_text_db.m_file, 
                  "  FREE_STREAM @%0t {NAME:%s T:%s SCOPE:%s STREAM:%0d}",
                  $time,
                  this.get_name(),
                  this.get_stream_type_name(),
                  this.get_scope(),
                  this.get_handle());
        end

      m_text_db = null;
      return;
   endfunction : do_free
   
   // Function: do_open_recorder
   // Marks the beginning of a new record in the stream
   //
   // Text-backend specific implementation.
   //
   // @uvm-accellera The details of this API are specific to the Accellera implementation, and are not being considered for contribution to 1800.2
   protected virtual function uvm_recorder do_open_recorder(string name,
                                                           time   open_time,
                                                           string type_name);
      if (m_text_db.open_db()) 
        begin
          return uvm_text_recorder::type_id::create(name);
        end

      return null;
   endfunction : do_open_recorder

endclass : uvm_text_tr_stream

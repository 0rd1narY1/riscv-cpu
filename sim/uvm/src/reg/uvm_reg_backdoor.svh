//
// -------------------------------------------------------------
// Copyright 2010 AMD
// Copyright 2010-2018 Cadence Design Systems, Inc.
// Copyright 2010-2020 Mentor Graphics Corporation
// Copyright 2015-2024 NVIDIA Corporation
// Copyright 2004-2018 Synopsys, Inc.
// Copyright 2020 Verific
//    All Rights Reserved Worldwide
//
//    Licensed under the Apache License, Version 2.0 (the
//    "License"); you may not use this file except in
//    compliance with the License.  You may obtain a copy of
//    the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in
//    writing, software distributed under the License is
//    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//    CONDITIONS OF ANY KIND, either express or implied.  See
//    the License for the specific language governing
//    permissions and limitations under the License.
// -------------------------------------------------------------
//

//----------------------------------------------------------------------
// Git details (see DEVELOPMENT.md):
//
// $File:     src/reg/uvm_reg_backdoor.svh $
// $Rev:      2024-02-08 13:43:04 -0800 $
// $Hash:     29e1e3f8ee4d4aa2035dba1aba401ce1c19aa340 $
//
//----------------------------------------------------------------------


typedef class uvm_reg_cbs;


//------------------------------------------------------------------------------
// Class -- NODOCS -- uvm_reg_backdoor
//
// Base class for user-defined back-door register and memory access.
//
// This class can be extended by users to provide user-specific back-door access
// to registers and memories that are not implemented in pure SystemVerilog
// or that are not accessible using the default DPI backdoor mechanism.
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2020 auto 19.5.1
virtual class uvm_reg_backdoor extends uvm_object;


   `uvm_object_abstract_utils(uvm_reg_backdoor)


   // @uvm-ieee 1800.2-2020 auto 19.5.2.1
   function new(string name = "");
      super.new(name);
   endfunction: new

   

   // @uvm-ieee 1800.2-2020 auto 19.5.2.2
   protected task do_pre_read(uvm_reg_item rw);
      pre_read(rw);
      `uvm_do_obj_callbacks(uvm_reg_backdoor, uvm_reg_cbs, this,
                            pre_read(rw))
   endtask



   // @uvm-ieee 1800.2-2020 auto 19.5.2.3
   protected task do_post_read(uvm_reg_item rw);
      uvm_reg_data_t value_array[];
      uvm_callback_iter#(uvm_reg_backdoor, uvm_reg_cbs) iter = new(this);
      for(uvm_reg_cbs cb = iter.last(); cb != null; cb=iter.prev()) begin
        rw.get_value_array(value_array);
        cb.decode(value_array);
      end
      `uvm_do_obj_callbacks(uvm_reg_backdoor,uvm_reg_cbs,this,post_read(rw))
      post_read(rw);
   endtask



   // @uvm-ieee 1800.2-2020 auto 19.5.2.4
   protected task do_pre_write(uvm_reg_item rw);
      uvm_reg_data_t rw_value[];
      uvm_callback_iter#(uvm_reg_backdoor, uvm_reg_cbs) iter = new(this);
      pre_write(rw);
      `uvm_do_obj_callbacks(uvm_reg_backdoor,uvm_reg_cbs,this,pre_write(rw))
      for(uvm_reg_cbs cb = iter.first(); cb != null; cb = iter.next()) begin
        rw.get_value_array(rw_value);
        cb.encode(rw_value);
      end
   endtask



   // @uvm-ieee 1800.2-2020 auto 19.5.2.5
   protected task do_post_write(uvm_reg_item rw);
      `uvm_do_obj_callbacks(uvm_reg_backdoor,uvm_reg_cbs,this,post_write(rw))
      post_write(rw);
   endtask



   // @uvm-ieee 1800.2-2020 auto 19.5.2.6
   extern virtual task write(uvm_reg_item rw);



   // @uvm-ieee 1800.2-2020 auto 19.5.2.7
   extern virtual task read(uvm_reg_item rw);

   

   // @uvm-ieee 1800.2-2020 auto 19.5.2.8
   extern virtual function void read_func(uvm_reg_item rw);



   extern virtual function bit is_auto_updated(uvm_reg_field field);



   extern virtual task wait_for_change(uvm_object element);

  
   /*local*/ extern function void start_update_thread(uvm_object element);
   /*local*/ extern function void kill_update_thread(uvm_object element);
   /*local*/ extern function bit has_update_threads();



   // @uvm-ieee 1800.2-2020 auto 19.5.2.9
   virtual task pre_read(uvm_reg_item rw); endtask



   // @uvm-ieee 1800.2-2020 auto 19.5.2.10
   virtual task post_read(uvm_reg_item rw); endtask



   // @uvm-ieee 1800.2-2020 auto 19.5.2.11
   virtual task pre_write(uvm_reg_item rw); endtask



   // @uvm-ieee 1800.2-2020 auto 19.5.2.12
   virtual task post_write(uvm_reg_item rw); endtask


   string fname;
   int lineno;

`ifdef UVM_USE_PROCESS_CONTAINER
   local process_container_c m_update_thread[uvm_object];
`else
   local process m_update_thread[uvm_object];
`endif 

   `uvm_register_cb(uvm_reg_backdoor, uvm_reg_cbs)


endclass: uvm_reg_backdoor


//------------------------------------------------------------------------------
// IMPLEMENTATION
//------------------------------------------------------------------------------


// is_auto_updated

function bit uvm_reg_backdoor::is_auto_updated(uvm_reg_field field);
   return 0;
endfunction


// wait_for_change

task uvm_reg_backdoor::wait_for_change(uvm_object element);
   `uvm_fatal("RegModel", "uvm_reg_backdoor::wait_for_change() method has not been overloaded")
endtask


// start_update_thread

function void uvm_reg_backdoor::start_update_thread(uvm_object element);
   uvm_reg rg;
   if (this.m_update_thread.exists(element)) begin
     this.kill_update_thread(element);
   end
   if (!$cast(rg,element)) begin
     
     return;
   end
 // only regs supported at this time

   fork
     begin
       uvm_reg_field fields[$];

`ifdef UVM_USE_PROCESS_CONTAINER         
       this.m_update_thread[element] = new(process::self());
`else
       this.m_update_thread[element] = process::self();
`endif
      
       rg.get_fields(fields);
       forever begin
         uvm_status_e status;
         uvm_reg_data_t  val;
         uvm_reg_item r_item = new("bd_r_item");
         r_item.set_element(rg);
         r_item.set_element_kind(UVM_REG);
         this.read(r_item);
         val = r_item.get_value(0);
         if (r_item.get_status() != UVM_IS_OK) begin
           `uvm_error("RegModel", $sformatf("Backdoor read of register '%s' failed.",
           rg.get_name()))
         end
         foreach (fields[i]) begin
           if (this.is_auto_updated(fields[i])) begin
             uvm_reg_data_t tmp;
             tmp = (val >> fields[i].get_lsb_pos()) & ((1 << fields[i].get_n_bits())-1);
             r_item.set_value(tmp, 0);
             fields[i].do_predict(r_item);
           end
         end
         this.wait_for_change(element);
       end
     end
   join_none
endfunction


// kill_update_thread

function void uvm_reg_backdoor::kill_update_thread(uvm_object element);
   if (this.m_update_thread.exists(element)) begin

`ifdef UVM_USE_PROCESS_CONTAINER
     this.m_update_thread[element].p.kill();
`else 
     this.m_update_thread[element].kill();
`endif

     this.m_update_thread.delete(element);
   end
endfunction


// has_update_threads

function bit uvm_reg_backdoor::has_update_threads();
   return this.m_update_thread.num() > 0;
endfunction


// write

task uvm_reg_backdoor::write(uvm_reg_item rw);
   `uvm_fatal("RegModel", "uvm_reg_backdoor::write() method has not been overloaded")
endtask


// read

task uvm_reg_backdoor::read(uvm_reg_item rw);
   do_pre_read(rw);
   read_func(rw);
   do_post_read(rw);
endtask


// read_func

function void uvm_reg_backdoor::read_func(uvm_reg_item rw);
   `uvm_fatal("RegModel", "uvm_reg_backdoor::read_func() method has not been overloaded")
   rw.set_status(UVM_NOT_OK);
endfunction

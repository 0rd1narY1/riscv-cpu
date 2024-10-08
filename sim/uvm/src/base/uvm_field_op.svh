//----------------------------------------------------------------------
// Copyright 2018 Cadence Design Systems, Inc.
// Copyright 2018 Cisco Systems, Inc.
// Copyright 2018-2024 NVIDIA Corporation
// Copyright 2018 Synopsys, Inc.
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
// $File:     src/base/uvm_field_op.svh $
// $Rev:      2024-02-08 13:43:04 -0800 $
// $Hash:     29e1e3f8ee4d4aa2035dba1aba401ce1c19aa340 $
//
//----------------------------------------------------------------------


//------------------------------------------------------------------------------
// Class - uvm_field_op
//
// uvm_field_op is the UVM class for describing all operations supported by the do_execute_op function
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2020 auto 5.7.1
class uvm_field_op extends uvm_object;

   `uvm_object_utils(uvm_field_op)

   local uvm_policy m_policy;
   local bit m_user_hook;
   local uvm_object m_object;
   // Bit m_is_set is set when the set() method is called and acts 
   // like a state variable. It is cleared when flush is called.
   local bit m_is_set;
   local  uvm_field_flag_t m_op_type;


   // Function -- new 
   // 
   // Creates a policy with the specified instance name. If name is not provided, then the policy instance is
   // unnamed.

   // @uvm-ieee 1800.2-2020 auto 5.7.2.1
   function new (string name="");
      super.new(name);
      m_is_set = 1'b0;
      m_user_hook = 1'b1;
   endfunction


   // @uvm-ieee 1800.2-2020 auto 5.7.2.2
   virtual function void set( uvm_field_flag_t op_type, uvm_policy policy = null, uvm_object rhs = null);
     string matching_ops[$];
     if (op_type & UVM_COPY) begin
       
       matching_ops.push_back("UVM_COPY");
     end

     if (op_type & UVM_COMPARE) begin
       
       matching_ops.push_back("UVM_COMPARE");
     end

     if (op_type & UVM_PRINT) begin
       
       matching_ops.push_back("UVM_PRINT");
     end

     if (op_type & UVM_RECORD) begin
       
       matching_ops.push_back("UVM_RECORD");
     end

     if (op_type & UVM_PACK) begin
       
       matching_ops.push_back("UVM_PACK");
     end

     if (op_type & UVM_UNPACK) begin
       
       matching_ops.push_back("UVM_UNPACK");
     end

     if (op_type & UVM_SET) begin
       
       matching_ops.push_back("UVM_SET");
     end


     if (matching_ops.size() > 1) begin
       string msg_queue[$];
       msg_queue.push_back("(");
       foreach (matching_ops[i]) begin
         msg_queue.push_back(matching_ops[i]);
         if (i != matching_ops.size() - 1) begin
           
           msg_queue.push_back(",");
         end

       end
       msg_queue.push_back(")");
       `uvm_error("UVM/FIELD_OP/SET_BAD_OP_TYPE", {"set() was passed op_type matching multiple operations: ", `UVM_STRING_QUEUE_STREAMING_PACK(msg_queue)})
     end

     if(m_is_set == 0) begin
       m_op_type = op_type;
       m_policy = policy;
       m_object = rhs;
       m_is_set = 1'b1;
     end 
     else begin
       `uvm_error("UVM/FIELD_OP/SET","Attempting to set values in policy without flushing")
     end
   endfunction 

   // @uvm-ieee 1800.2-2020 auto 5.7.2.3
   virtual function string get_op_name();
      case(m_op_type)
        UVM_COPY : begin
          return "copy";
        end

        UVM_COMPARE : begin
          return "compare";
        end

        UVM_PRINT : begin
          return "print";
        end

        UVM_RECORD : begin
          return "record";
        end

        UVM_PACK : begin
          return "pack";
        end

        UVM_UNPACK : begin
          return "unpack";
        end

        UVM_SET : begin
          return "set";
        end

        default: begin
          return "";
        end

      endcase
   endfunction

   // @uvm-ieee 1800.2-2020 auto 5.7.2.4
   virtual function uvm_field_flag_t get_op_type();
      if(m_is_set == 1'b1) begin 
        
        return m_op_type;
      end

      else begin
        `uvm_error("UVM/FIELD_OP/GET_OP_TYPE","Calling get_op_type() before calling set() is not allowed")
      end
   endfunction


   // @uvm-ieee 1800.2-2020 auto 5.7.2.5
   virtual function uvm_policy get_policy();
      if(m_is_set == 1'b1) begin 
        
        return m_policy;
      end

      else begin
        `uvm_error("UVM/FIELD_OP/GET_POLICY","Attempting to call get_policy() before calling set() is not allowed")
      end
   endfunction

   // @uvm-ieee 1800.2-2020 auto 5.7.2.6
   virtual function uvm_object get_rhs();
      if(m_is_set == 1'b1) begin 
        
        return m_object;
      end

      else begin
        `uvm_error("UVM/FIELD_OP/GET_RHS","Calling get_rhs() before calling set() is not allowed")
      end
   endfunction

   // @uvm-ieee 1800.2-2020 auto 5.7.2.7
   function bit user_hook_enabled();
      if(m_is_set == 1'b1) begin 
        
        return m_user_hook;
      end

      else begin
        `uvm_error("UVM/FIELD_OP/GET_USER_HOOK","Attempting to get_user_hook before calling set() is not allowed")
      end
   endfunction

   // @uvm-ieee 1800.2-2020 auto 5.7.2.8
   function void disable_user_hook();
      m_user_hook = 1'b0;
   endfunction

   static uvm_field_op m_recycled_op[$] ; 

   // @uvm-ieee 1800.2-2020 auto 5.7.2.9
   virtual function void flush();
      m_policy = null;
      m_object = null;
      m_user_hook = 1'b1;
      m_is_set = 0;
   endfunction

   // API for reusing uvm_field_op instances.  Implementation
   // artifact, should not be used directly by the user.
   function void m_recycle();
     this.flush();
     m_recycled_op.push_back(this);
   endfunction : m_recycle 
 
   static function uvm_field_op m_get_available_op() ;
      uvm_field_op field_op ;
      if (m_recycled_op.size() > 0) begin
        field_op = m_recycled_op.pop_back() ;
      end

      else begin
        field_op = uvm_field_op::type_id::create("field_op");
      end

      return field_op ;
   endfunction
endclass

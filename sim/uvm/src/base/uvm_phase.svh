//
//----------------------------------------------------------------------
// Copyright 2011-2012 AMD
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2012-2017 Cisco Systems, Inc.
// Copyright 2021-2022 Marvell International Ltd.
// Copyright 2007-2014 Mentor Graphics Corporation
// Copyright 2013-2024 NVIDIA Corporation
// Copyright 2014 Semifore
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
// $File:     src/base/uvm_phase.svh $
// $Rev:      2024-02-08 13:43:04 -0800 $
// $Hash:     29e1e3f8ee4d4aa2035dba1aba401ce1c19aa340 $
//
//----------------------------------------------------------------------


typedef class uvm_sequencer_base;

typedef class uvm_domain;
typedef class uvm_task_phase;

typedef class uvm_phase_cb;
typedef class uvm_phase_state_change;

   
//------------------------------------------------------------------------------
//
// Section -- NODOCS -- Phasing Definition classes
//
//------------------------------------------------------------------------------
//
// The following class are used to specify a phase and its implied functionality.
//
  
//------------------------------------------------------------------------------
//
// Class -- NODOCS -- uvm_phase
//
//------------------------------------------------------------------------------
//
// This base class defines everything about a phase: behavior, state, and context.
//
// To define behavior, it is extended by UVM or the user to create singleton
// objects which capture the definition of what the phase does and how it does it.
// These are then cloned to produce multiple nodes which are hooked up in a graph
// structure to provide context: which phases follow which, and to hold the state
// of the phase throughout its lifetime.
// UVM provides default extensions of this class for the standard runtime phases.
// VIP Providers can likewise extend this class to define the phase functor for a
// particular component context as required.
//
// This base class defines everything about a phase: behavior, state, and context.
//
// To define behavior, it is extended by UVM or the user to create singleton
// objects which capture the definition of what the phase does and how it does it.
// These are then cloned to produce multiple nodes which are hooked up in a graph
// structure to provide context: which phases follow which, and to hold the state
// of the phase throughout its lifetime.
// UVM provides default extensions of this class for the standard runtime phases.
// VIP Providers can likewise extend this class to define the phase functor for a
// particular component context as required.
//
// *Phase Definition*
//
// Singleton instances of those extensions are provided as package variables.
// These instances define the attributes of the phase (not what state it is in)
// They are then cloned into schedule nodes which point back to one of these
// implementations, and calls its virtual task or function methods on each
// participating component.
// It is the base class for phase functors, for both predefined and
// user-defined phases. Per-component overrides can use a customized imp.
//
// To create custom phases, do not extend uvm_phase directly: see the
// three predefined extended classes below which encapsulate behavior for
// different phase types: task, bottom-up function and top-down function.
//
// Extend the appropriate one of these to create a uvm_YOURNAME_phase class
// (or YOURPREFIX_NAME_phase class) for each phase, containing the default
// implementation of the new phase, which must be a uvm_component-compatible
// delegate, and which may be a ~null~ implementation. Instantiate a singleton
// instance of that class for your code to use when a phase handle is required.
// If your custom phase depends on methods that are not in uvm_component, but
// are within an extended class, then extend the base YOURPREFIX_NAME_phase
// class with parameterized component class context as required, to create a
// specialized functor which calls your extended component class methods.
// This scheme ensures compile-safety for your extended component classes while
// providing homogeneous base types for APIs and underlying data structures.
//
// *Phase Context*
//
// A schedule is a coherent group of one or mode phase/state nodes linked
// together by a graph structure, allowing arbitrary linear/parallel
// relationships to be specified, and executed by stepping through them in
// the graph order.
// Each schedule node points to a phase and holds the execution state of that
// phase, and has optional links to other nodes for synchronization.
//
// The main operations are: construct, add phases, and instantiate
// hierarchically within another schedule.
//
// Structure is a DAG (Directed Acyclic Graph). Each instance is a node
// connected to others to form the graph. Hierarchy is overlaid with m_parent.
// Each node in the graph has zero or more successors, and zero or more
// predecessors. No nodes are completely isolated from others. Exactly
// one node has zero predecessors. This is the root node. Also the graph
// is acyclic, meaning for all nodes in the graph, by following the forward
// arrows you will never end up back where you started but you will eventually
// reach a node that has no successors.
//
// *Phase State*
//
// A given phase may appear multiple times in the complete phase graph, due
// to the multiple independent domain feature, and the ability for different
// VIP to customize their own phase schedules perhaps reusing existing phases.
// Each node instance in the graph maintains its own state of execution.
//
// *Phase Handle*
//
// Handles of this type uvm_phase are used frequently in the API, both by
// the user, to access phasing-specific API, and also as a parameter to some
// APIs. In many cases, the singleton phase handles can be
// used (eg. <uvm_run_phase::get()>) in APIs. For those APIs that need to look
// up that phase in the graph, this is done automatically.

// @uvm-ieee 1800.2-2020 auto 9.3.1.2
class uvm_phase extends uvm_object;

  //`uvm_object_utils(uvm_phase)

  `uvm_register_cb(uvm_phase, uvm_phase_cb)


  //--------------------
  // Group -- NODOCS -- Construction
  //--------------------
  

  // @uvm-ieee 1800.2-2020 auto 9.3.1.3.1
  extern function new(string name="uvm_phase",
                      uvm_phase_type phase_type=UVM_PHASE_SCHEDULE,
                      uvm_phase parent=null);


  // @uvm-ieee 1800.2-2020 auto 9.3.1.3.2
  extern function uvm_phase_type get_phase_type();

  // @uvm-ieee 1800.2-2020 auto 9.3.1.3.3
  extern virtual function void set_max_ready_to_end_iterations(int max);

  // @uvm-ieee 1800.2-2020 auto 9.3.1.3.4
  // @uvm-ieee 1800.2-2020 auto 9.3.1.3.6
  extern virtual function int get_max_ready_to_end_iterations();

  // @uvm-ieee 1800.2-2020 auto 9.3.1.3.5
  extern static function void set_default_max_ready_to_end_iterations(int max);

  extern static function int get_default_max_ready_to_end_iterations();

  //-------------
  // Group -- NODOCS -- State
  //-------------


  // @uvm-contrib For potential contribution to 1800.2
  extern function void set_state(uvm_phase_state state);
  
  // @uvm-ieee 1800.2-2020 auto 9.3.1.4.1
  extern function uvm_phase_state get_state();



  // @uvm-ieee 1800.2-2020 auto 9.3.1.4.2
  extern function int get_run_count();



  // @uvm-ieee 1800.2-2020 auto 9.3.1.4.3
  extern function uvm_phase find_by_name(string name, bit stay_in_scope=1);



  // @uvm-ieee 1800.2-2020 auto 9.3.1.4.4
  extern function uvm_phase find(uvm_phase phase, bit stay_in_scope=1);



  // @uvm-ieee 1800.2-2020 auto 9.3.1.4.5
  extern function bit is(uvm_phase phase);



  // @uvm-ieee 1800.2-2020 auto 9.3.1.4.6
  extern function bit is_before(uvm_phase phase);



  // @uvm-ieee 1800.2-2020 auto 9.3.1.4.7
  extern function bit is_after(uvm_phase phase);


  //-----------------
  // Group -- NODOCS -- Callbacks
  //-----------------


  // @uvm-ieee 1800.2-2020 auto 9.3.1.5.1
  virtual function void exec_func(uvm_component comp, uvm_phase phase); endfunction



  // @uvm-ieee 1800.2-2020 auto 9.3.1.5.2
  virtual task exec_task(uvm_component comp, uvm_phase phase); endtask



  //----------------
  // Group -- NODOCS -- Schedule
  //----------------


  // @uvm-ieee 1800.2-2020 auto 9.3.1.6.1
  extern function void add(uvm_phase phase,
                           uvm_phase with_phase=null,
                           uvm_phase after_phase=null,
                           uvm_phase before_phase=null,
                           uvm_phase start_with_phase=null,
                           uvm_phase end_with_phase=null
                        );



  // @uvm-ieee 1800.2-2020 auto 9.3.1.6.2
  extern function uvm_phase get_parent();



  // @uvm-ieee 1800.2-2020 auto 9.3.1.6.3
  extern virtual function string get_full_name();



  // @uvm-ieee 1800.2-2020 auto 9.3.1.6.4
  extern function uvm_phase get_schedule(bit hier = 0);



  // @uvm-ieee 1800.2-2020 auto 9.3.1.6.5
  extern function string get_schedule_name(bit hier = 0);



  // @uvm-ieee 1800.2-2020 auto 9.3.1.6.6
  extern function uvm_domain get_domain();



  // @uvm-ieee 1800.2-2020 auto 9.3.1.6.7
  extern function uvm_phase get_imp();



  // @uvm-ieee 1800.2-2020 auto 9.3.1.6.8
  extern function string get_domain_name();


  // @uvm-ieee 1800.2-2020 auto 9.3.1.6.9
  extern function void get_adjacent_predecessor_nodes(ref uvm_phase pred[]);


  // @uvm-ieee 1800.2-2020 auto 9.3.1.6.10
  extern function void get_adjacent_successor_nodes(ref uvm_phase succ[]);

  //-----------------------
  // Group -- NODOCS -- Phase Done Objection
  //-----------------------
  //
  // Task-based phase nodes within the phasing graph provide a <uvm_objection>
  // based interface for prolonging the execution of the phase.  All other
  // phase types do not contain an objection, and will report a fatal error
  // if the user attempts to ~raise~, ~drop~, or ~get_objection_count~.
   
  // Function- m_report_null_objection
  // Simplifies the reporting of ~null~ objection errors
  extern function void m_report_null_objection(uvm_object obj,
                                               string description,
                                               int count,
                                               string action);


  // @uvm-ieee 1800.2-2020 auto 9.3.1.7.2
  extern virtual function void raise_objection (uvm_object obj, 
                                                string description="",
                                                int count=1);


  // @uvm-ieee 1800.2-2020 auto 9.3.1.7.3
  extern virtual function void drop_objection (uvm_object obj, 
                                               string description="",
                                               int count=1);



  // @uvm-ieee 1800.2-2020 auto 9.3.1.7.4
  extern virtual function int get_objection_count( uvm_object obj=null );

  // @uvm-contrib For potential contribution to 1800.2
  extern virtual function int get_objection_total( uvm_object obj=null );
   
  //-----------------------
  // Group -- NODOCS -- Synchronization
  //-----------------------
  // The functions 'sync' and 'unsync' add soft sync relationships between nodes
  //
  // Summary of usage:
  //| my_phase.sync(.target(domain)
  //|              [,.phase(phase)[,.with_phase(phase)]]);
  //| my_phase.unsync(.target(domain)
  //|                [,.phase(phase)[,.with_phase(phase)]]);
  //
  // Components in different schedule domains can be phased independently or in sync
  // with each other. An API is provided to specify synchronization rules between any
  // two domains. Synchronization can be done at any of three levels:
  //
  // - the domain's whole phase schedule can be synchronized
  // - a phase can be specified, to sync that phase with a matching counterpart
  // - or a more detailed arbitrary synchronization between any two phases
  //
  // Each kind of synchronization causes the same underlying data structures to
  // be managed. Like other APIs, we use the parameter dot-notation to set
  // optional parameters.
  //
  // When a domain is synced with another domain, all of the matching phases in
  // the two domains get a 'with' relationship between them. Likewise, if a domain
  // is unsynched, all of the matching phases that have a 'with' relationship have
  // the dependency removed. It is possible to sync two domains and then just
  // remove a single phase from the dependency relationship by unsyncing just
  // the one phase.



  // @uvm-ieee 1800.2-2020 auto 9.3.1.8.1
  extern function void sync(uvm_domain target,
                            uvm_phase phase=null,
                            uvm_phase with_phase=null);


  // @uvm-ieee 1800.2-2020 auto 9.3.1.8.2
  extern function void unsync(uvm_domain target,
                              uvm_phase phase=null,
                              uvm_phase with_phase=null);



  // @uvm-ieee 1800.2-2020 auto 9.3.1.8.3
  extern task wait_for_state(uvm_phase_state state, uvm_wait_op op=UVM_EQ);

   
  //---------------
  // Group -- NODOCS -- Jumping
  //---------------
  
  // Force phases to jump forward or backward in a schedule
  //
  // A phasing domain can execute a jump from its current phase to any other.
  // A jump passes phasing control in the current domain from the current phase
  // to a target phase. There are two kinds of jump scope:
  //
  // - local jump to another phase within the current schedule, back- or forwards
  // - global jump of all domains together, either to a point in the master
  //   schedule outwith the current schedule, or by calling jump_all()
  //
  // A jump preserves the existing soft synchronization, so the domain that is
  // ahead of schedule relative to another synchronized domain, as a result of
  // a jump in either domain, will await the domain that is behind schedule.
  //
  // *Note*: A jump out of the local schedule causes other schedules that have
  // the jump node in their schedule to jump as well. In some cases, it is
  // desirable to jump to a local phase in the schedule but to have all
  // schedules that share that phase to jump as well. In that situation, the
  // jump_all static function should be used. This function causes all schedules
  // that share a phase to jump to that phase.
 

  // @uvm-ieee 1800.2-2020 auto 9.3.1.9.1
  extern function void jump(uvm_phase phase);


  // @uvm-ieee 1800.2-2020 auto 9.3.1.9.2
  extern function void set_jump_phase(uvm_phase phase) ;

  // @uvm-contrib For potential contribution to 1800.2
  extern function bit is_jumping_forward();

  // @uvm-contrib For potential contribution to 1800.2
  extern function bit is_jumping_backward();
  
  // @uvm-ieee 1800.2-2020 auto 9.3.1.9.3
  extern function void end_prematurely() ;

  // @uvm-contrib For potential contribution to 1800.2
  extern function bit is_ending_prematurely();

  // Function- jump_all
  //
  // Make all schedules jump to a specified ~phase~, even if the jump target is local.
  // The jump happens to all phase schedules that contain the jump-to ~phase~,
  // i.e. a global jump. 
  //
  extern static function void jump_all(uvm_phase phase);



  // @uvm-ieee 1800.2-2020 auto 9.3.1.9.4
  extern function uvm_phase get_jump_target();



  //--------------------------
  // Internal - Implementation
  //--------------------------

  typedef bit edges_t[uvm_phase]; // Associative array type for storing predecessor/successor lists
  
  // Implementation - Construction
  //------------------------------
  protected uvm_phase_type m_phase_type;
  protected uvm_phase      m_parent;     // our 'schedule' node [or points 'up' one level]
  uvm_phase                m_imp;        // phase imp to call when we execute this node

  // Implementation - State
  //-----------------------
  // Could move this to hopper
  // vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
  local uvm_phase_state    m_state;
  local int                m_run_count; // num times this phase has executed
  // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  protected uvm_phase_state_change m_state_chg;
  /*local*/ process            m_phase_proc;
  local static int         m_default_max_ready_to_end_iters = 20;    // 20 is the initial value defined by 1800.2-2020 9.3.1.3.5
  local int                      max_ready_to_end_iters = get_default_max_ready_to_end_iterations();
  int                      m_num_procs_not_yet_returned;
  extern function uvm_phase m_find_predecessor(uvm_phase phase, bit stay_in_scope=1, uvm_phase orig_phase=null);
  extern function uvm_phase m_find_successor(uvm_phase phase, bit stay_in_scope=1, uvm_phase orig_phase=null);
  extern function uvm_phase m_find_predecessor_by_name(string name, bit stay_in_scope=1, uvm_phase orig_phase=null);
  extern function uvm_phase m_find_successor_by_name(string name, bit stay_in_scope=1, uvm_phase orig_phase=null);
  extern function void m_print_successors();

  // Implementation - Callbacks
  //---------------------------
  // Provide the required component traversal behavior. Called by execute()
  virtual function void traverse(uvm_component comp,
                                 uvm_phase phase,
                                 uvm_phase_state state);
  endfunction
  // Provide the required per-component execution flow. Called by traverse()
  virtual function void execute(uvm_component comp,
                                 uvm_phase phase);
  endfunction

  // Implementation - Schedule
  //--------------------------
  protected edges_t m_predecessors;
  protected edges_t m_successors;
  protected uvm_phase m_end_node;
  // Track the currently executing real task phases (used for debug)
  static protected edges_t m_executing_phases;
  function uvm_phase get_begin_node(); if (m_imp != null) begin
    return this;
  end
 return null; endfunction
  function uvm_phase get_end_node();   return m_end_node; endfunction

  // Implementation - Synchronization
  //---------------------------------
  local uvm_phase m_sync[$];  // schedule instance to which we are synced

  //@uvm-compat provided for compatability with 1.2
  uvm_objection phase_done;
   
  extern function void get_predecessors(ref edges_t predecessors);
  extern function void get_successors(ref edges_t successors);
  extern function void get_sync_relationships(ref edges_t relationships);
  extern local function void get_predecessors_for_successors(output edges_t pred_of_succ);
  // Could move this to hopper
  // vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
  extern /*local*/ task m_wait_for_pred();
  // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

  // Implementation - Jumping
  //-------------------------
  local bit                m_jump_bkwd;
  local bit                m_jump_fwd;
  local uvm_phase          m_jump_phase;
  // Could move this to hopper
  // vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
  /*local*/ bit                m_premature_end;
  // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  extern function void clear(uvm_phase_state state = UVM_PHASE_DORMANT);
  extern function void clear_successors(
                             uvm_phase_state state = UVM_PHASE_DORMANT,
                             uvm_phase end_state=null);

  // Implementation - Overall Control
  //---------------------------------
  local static mailbox #(uvm_phase) m_phase_hopper = new();

  extern local function void m_terminate_phase();
  extern local function void m_print_termination_state();
  // Could move this to hopper
  // vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
  extern /*local*/ task wait_for_self_and_siblings_to_drop();
  // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  extern function void kill();
  extern function void kill_successors();

  // TBD add more useful debug
  //---------------------------------
  /*protected*/ static bit m_phase_trace;
  /*local*/ static bit m_use_ovm_run_semantic;


  function string convert2string();
  //return $sformatf("PHASE %s = %p",get_name(),this);
  string s;
    s = $sformatf("phase: %s parent=%s  pred=%s  succ=%s",get_name(),
                     (m_parent==null) ? "null" : get_schedule_name(),
                     m_aa2string(m_predecessors),
                     m_aa2string(m_successors));
    return s;
  endfunction

  local function string m_aa2string(edges_t aa); // TBD tidy
    string s;
    int i;
    s = "'{ ";
    foreach (aa[ph]) begin
      uvm_phase n = ph;
      s = {s, (n == null) ? "null" : n.get_name(),
        (i == aa.num()-1) ? "" : ", "};
      i++;
    end
    s = {s, " }"};
    return s;
  endfunction

  function bit is_domain();
    return (m_phase_type == UVM_PHASE_DOMAIN);
  endfunction

  virtual function void m_get_transitive_children(ref uvm_phase phases[$]);
    foreach (m_successors[succ]) begin
    
      phases.push_back(succ);
      succ.m_get_transitive_children(phases);
    end
  endfunction
  
  
  // @uvm-ieee 1800.2-2020 auto 9.3.1.7.1
  function uvm_objection get_objection();
     uvm_phase imp;
     uvm_task_phase tp;
     imp = get_imp();
     // Only nodes with a non-null uvm_task_phase imp have objections
     if ((get_phase_type() != UVM_PHASE_NODE) || (imp == null) || !$cast(tp, imp)) begin
       return null;
     end
     if (phase_done == null) begin
       phase_done = uvm_objection::type_id::create({get_name(), "_objection"});
     end
     
     return phase_done;
  endfunction // get_objection

  
endclass


//------------------------------------------------------------------------------
//
// Class -- NODOCS -- uvm_phase_state_change
//
//------------------------------------------------------------------------------
//
// Phase state transition descriptor.
// Used to describe the phase transition that caused a
// <uvm_phase_cb::phase_state_changed()> callback to be invoked.
//

// @uvm-ieee 1800.2-2020 auto 9.3.2.1
class uvm_phase_state_change extends uvm_object;

  `uvm_object_utils(uvm_phase_state_change)

  // Implementation -- do not use directly
  /* local */ uvm_phase       m_phase;
  /* local */ uvm_phase_state m_prev_state;
  /* local */ uvm_phase       m_jump_to;
  
  function new(string name = "uvm_phase_state_change");
    super.new(name);
  endfunction



  // @uvm-ieee 1800.2-2020 auto 9.3.2.2.1
  virtual function uvm_phase_state get_state();
    return m_phase.get_state();
  endfunction
  

  // @uvm-ieee 1800.2-2020 auto 9.3.2.2.2
  virtual function uvm_phase_state get_prev_state();
    return m_prev_state;
  endfunction


  // @uvm-ieee 1800.2-2020 auto 9.3.2.2.3
  function uvm_phase jump_to();
    return m_jump_to;
  endfunction

endclass


//------------------------------------------------------------------------------
//
// Class -- NODOCS -- uvm_phase_cb
//
//------------------------------------------------------------------------------
//
// This class defines a callback method that is invoked by the phaser
// during the execution of a specific node in the phase graph or all phase nodes.
// User-defined callback extensions can be used to integrate data types that
// are not natively phase-aware with the UVM phasing.
//

// @uvm-ieee 1800.2-2020 auto 9.3.3.1
class uvm_phase_cb extends uvm_callback;


  // @uvm-ieee 1800.2-2020 auto 9.3.3.2.1
  function new(string name="unnamed-uvm_phase_cb");
     super.new(name);
  endfunction : new
   

  // @uvm-ieee 1800.2-2020 auto 9.3.3.2.2
  virtual function void phase_state_change(uvm_phase phase,
                                           uvm_phase_state_change change);
  endfunction
endclass

//------------------------------------------------------------------------------
//
// Class -- NODOCS -- uvm_phase_cb_pool
//
//------------------------------------------------------------------------------
//
// Convenience type for the uvm_callbacks#(uvm_phase, uvm_phase_cb) class.
//
typedef uvm_callbacks#(uvm_phase, uvm_phase_cb) uvm_phase_cb_pool /* @uvm-ieee 1800.2-2020 auto D.4.1*/ ;


//------------------------------------------------------------------------------
//                               IMPLEMENTATION
//------------------------------------------------------------------------------

typedef class uvm_cmdline_processor;

`define UVM_PH_TRACE(ID,MSG,PH,VERB) \
  if (uvm_phase::m_phase_trace) \
   `uvm_info(ID, {$sformatf("Phase '%0s' (id=%0d) ", \
       PH.get_full_name(), PH.get_inst_id()),MSG}, VERB)

//-----------------------------
// Implementation - Construction
//-----------------------------

// new

function uvm_phase::new(string name="uvm_phase",
                        uvm_phase_type phase_type=UVM_PHASE_SCHEDULE,
                        uvm_phase parent=null);
  super.new(name);
  m_state_chg = uvm_phase_state_change::type_id::create(name);
  m_state_chg.m_phase = this;
  m_phase_type = phase_type;

  // The common domain is the only thing that initializes m_state.  All
  // other states are initialized by being 'added' to a schedule.
  if ((name == "common") &&
      (phase_type == UVM_PHASE_DOMAIN)) begin
    
    m_state = UVM_PHASE_DORMANT;
  end

   
  m_run_count = 0;
  m_parent = parent;

  begin
    uvm_cmdline_processor clp = uvm_cmdline_processor::get_inst();
    string val;
    if (clp.get_arg_value("+UVM_PHASE_TRACE", val)) begin
      
      m_phase_trace = 1;
    end

    else begin
      
      m_phase_trace = 0;
    end

    if (clp.get_arg_value("+UVM_USE_OVM_RUN_SEMANTIC", val)) begin
      
      m_use_ovm_run_semantic = 1;
    end

    else begin
      
      m_use_ovm_run_semantic = 0;
    end

  end

   
  if (parent == null && (phase_type == UVM_PHASE_SCHEDULE ||
                         phase_type == UVM_PHASE_DOMAIN )) begin
    //m_parent = this;
    m_end_node = new({name,"_end"}, UVM_PHASE_TERMINAL, this);
    this.m_successors[m_end_node] = 1;
    m_end_node.m_predecessors[this] = 1;
  end

endfunction


// add
// ---
// TBD error checks if param nodes are actually in this schedule or not

function void uvm_phase::add(uvm_phase phase,
                             uvm_phase with_phase=null,
                             uvm_phase after_phase=null,
                             uvm_phase before_phase=null,
                             uvm_phase start_with_phase=null,
                             uvm_phase end_with_phase=null
                          );
  uvm_phase new_node, begin_node, end_node, tmp_node;
  uvm_phase_state_change state_chg;

  if (phase == null) begin
    `uvm_fatal("PH/NULL", "add: phase argument is null")
  end

  if (with_phase != null && with_phase.get_phase_type() == UVM_PHASE_IMP) begin
    string nm = with_phase.get_name();
    with_phase = find(with_phase);
    if (with_phase == null) begin
      `uvm_fatal("PH_BAD_ADD",
      {"cannot find with_phase '",nm,"' within node '",get_name(),"'"})
    end
  end

  if (before_phase != null && before_phase.get_phase_type() == UVM_PHASE_IMP) begin
    string nm = before_phase.get_name();
    before_phase = find(before_phase);
    if (before_phase == null) begin
      `uvm_fatal("PH_BAD_ADD",
      {"cannot find before_phase '",nm,"' within node '",get_name(),"'"})
    end
  end

  if (after_phase != null && after_phase.get_phase_type() == UVM_PHASE_IMP) begin
    string nm = after_phase.get_name();
    after_phase = find(after_phase);
    if (after_phase == null) begin
      `uvm_fatal("PH_BAD_ADD",
      {"cannot find after_phase '",nm,"' within node '",get_name(),"'"})
    end
  end

  if (start_with_phase != null && start_with_phase.get_phase_type() == UVM_PHASE_IMP) begin
    string nm = start_with_phase.get_name();
    start_with_phase = find(start_with_phase);
    if (start_with_phase == null) begin
      `uvm_fatal("PH_BAD_ADD",
      {"cannot find start_with_phase '",nm,"' within node '",get_name(),"'"})
    end
  end

  if (end_with_phase != null && end_with_phase.get_phase_type() == UVM_PHASE_IMP) begin
    string nm = end_with_phase.get_name();
    end_with_phase = find(end_with_phase);
    if (end_with_phase == null) begin
      `uvm_fatal("PH_BAD_ADD",
      {"cannot find end_with_phase '",nm,"' within node '",get_name(),"'"})
    end
  end

  if (((with_phase != null) + (after_phase != null) + (start_with_phase != null)) > 1) begin
    `uvm_fatal("PH_BAD_ADD",
    "only one of with_phase/after_phase/start_with_phase may be specified as they all specify predecessor")
  end

  if (((with_phase != null) + (before_phase != null) + (end_with_phase != null)) > 1) begin
    `uvm_fatal("PH_BAD_ADD",
    "only one of with_phase/before_phase/end_with_phase may be specified as they all specify successor")
  end

  if (before_phase == this || 
     after_phase == m_end_node || 
     with_phase == m_end_node ||
     start_with_phase == m_end_node ||
     end_with_phase == m_end_node) begin
    `uvm_fatal("PH_BAD_ADD",
    "cannot add before begin node, after end node, or with end nodes")
  end

  if (before_phase != null && after_phase != null) begin
    if (!after_phase.is_before(before_phase)) begin
      `uvm_fatal("PH_BAD_ADD",{"Phase '",before_phase.get_name(),
      "' is not before phase '",after_phase.get_name(),"'"})
    end
  end

  if (before_phase != null && start_with_phase != null) begin
    if (!start_with_phase.is_before(before_phase)) begin
      `uvm_fatal("PH_BAD_ADD",{"Phase '",before_phase.get_name(),
      "' is not before phase '",start_with_phase.get_name(),"'"})
    end
  end

  if (end_with_phase != null && after_phase != null) begin
    if (!after_phase.is_before(end_with_phase)) begin
      `uvm_fatal("PH_BAD_ADD",{"Phase '",end_with_phase.get_name(),
      "' is not before phase '",after_phase.get_name(),"'"})
    end
  end

  // If we are inserting a new "leaf node"
  if (phase.get_phase_type() == UVM_PHASE_IMP) begin
    uvm_task_phase tp;
    new_node = new(phase.get_name(),UVM_PHASE_NODE,this);
    new_node.m_imp = phase;
    begin_node = new_node;
    end_node = new_node;

  end
  // We are inserting an existing schedule
  else begin
    begin_node = phase;
    end_node   = phase.m_end_node;
    phase.m_parent = this;
  end

  // If 'with_phase' is us, then insert node in parallel
  /*
  if (with_phase == this) begin
    after_phase = this;
    before_phase = m_end_node;
  end
  */

  // If no before/after/with specified, insert at end of this schedule
  if (with_phase==null && after_phase==null && before_phase==null && 
     start_with_phase==null && end_with_phase==null) begin
    before_phase = m_end_node;
  end


  if (m_phase_trace) begin
    uvm_phase_type typ = phase.get_phase_type();
    `uvm_info("PH/TRC/ADD_PH",
    {get_name()," (",m_phase_type.name(),") ADD_PHASE: phase=",phase.get_full_name()," (",
    typ.name(),", inst_id=",$sformatf("%0d",phase.get_inst_id()),")",
    " with_phase=",   (with_phase == null)   ? "null" : with_phase.get_name(), 
    " start_with_phase=",   (start_with_phase == null)   ? "null" : start_with_phase.get_name(), 
    " end_with_phase=",   (end_with_phase == null)   ? "null" : end_with_phase.get_name(), 
    " after_phase=",  (after_phase == null)  ? "null" : after_phase.get_name(),
    " before_phase=", (before_phase == null) ? "null" : before_phase.get_name(), 
    " new_node=",     (new_node == null)     ? "null" : {new_node.get_name(),
    " inst_id=",
    $sformatf("%0d",new_node.get_inst_id())},
    " begin_node=",   (begin_node == null)   ? "null" : begin_node.get_name(),
    " end_node=",     (end_node == null)     ? "null" : end_node.get_name()},UVM_DEBUG)
  end


  // 
  // INSERT IN PARALLEL WITH 'WITH' PHASE
  if (with_phase != null) begin
    // all pre-existing predecessors to with_phase are predecessors to the new phase
    begin_node.m_predecessors = with_phase.m_predecessors;
    foreach (with_phase.m_predecessors[pred]) begin
      pred.m_successors[begin_node] = 1;
    end

    // all pre-existing successors to with_phase are successors to this phase
    end_node.m_successors = with_phase.m_successors;
    foreach (with_phase.m_successors[succ]) begin
      succ.m_predecessors[end_node] = 1;
    end

  end
  
  if (start_with_phase != null) begin
    // all pre-existing predecessors to start_with_phase are predecessors to the new phase
    begin_node.m_predecessors = start_with_phase.m_predecessors;
    foreach (start_with_phase.m_predecessors[pred]) begin
      pred.m_successors[begin_node] = 1;
    end
    // if not otherwise specified, successors for the new phase are the successors to the end of this schedule
    if (before_phase == null && end_with_phase == null) begin
      end_node.m_successors = m_end_node.m_successors ;
      foreach (m_end_node.m_successors[succ]) begin
        succ.m_predecessors[end_node] = 1;
      end
    end
  end
  
  if (end_with_phase != null) begin
    // all pre-existing successors to end_with_phase are successors to the new phase
    end_node.m_successors = end_with_phase.m_successors;
    foreach (end_with_phase.m_successors[succ]) begin
      succ.m_predecessors[end_node] = 1;
    end
    // if not otherwise specified, predecessors for the new phase are the predecessors to the start of this schedule
    if (after_phase == null && start_with_phase == null) begin
      begin_node.m_predecessors = this.m_predecessors ;
      foreach (this.m_predecessors[pred]) begin
        pred.m_successors[begin_node] = 1;
      end
    end
  end

  // INSERT BEFORE PHASE
  if (before_phase != null) begin
    // unless predecessors to this phase are otherwise specified, 
    // pre-existing predecessors to before_phase move to be predecessors to the new phase
    if (after_phase == null && start_with_phase == null) begin
      foreach (before_phase.m_predecessors[pred]) begin
        pred.m_successors.delete(before_phase);
        pred.m_successors[begin_node] = 1;
      end
      begin_node.m_predecessors = before_phase.m_predecessors;
      before_phase.m_predecessors.delete();
    end
    // there is a special case if before and after used to be adjacent;
    // the new phase goes in-between them
    else if (before_phase.m_predecessors.exists(after_phase)) begin
      before_phase.m_predecessors.delete(after_phase);
    end

    // before_phase is now the sole successor of this phase
    before_phase.m_predecessors[end_node] = 1;
    end_node.m_successors.delete() ;
    end_node.m_successors[before_phase] = 1;

  end


  // INSERT AFTER PHASE
  if (after_phase != null) begin
    // unless successors to this phase are otherwise specified, 
    // pre-existing successors to after_phase are now successors to this phase
    if (before_phase == null && end_with_phase == null) begin
      foreach (after_phase.m_successors[succ]) begin
        succ.m_predecessors.delete(after_phase);
        succ.m_predecessors[end_node] = 1;
      end
      end_node.m_successors = after_phase.m_successors;
      after_phase.m_successors.delete();
    end
    // there is a special case if before and after used to be adjacent;
    // the new phase goes in-between them
    else if (after_phase.m_successors.exists(before_phase)) begin
      after_phase.m_successors.delete(before_phase);
    end

    // after_phase is the sole predecessor of this phase 
    after_phase.m_successors[begin_node] = 1;
    begin_node.m_predecessors.delete();
    begin_node.m_predecessors[after_phase] = 1;
  end
  


  // Transition nodes to DORMANT state
  if (new_node == null) begin
    
    tmp_node = phase;
  end

  else begin
    
    tmp_node = new_node;
  end


  state_chg = uvm_phase_state_change::type_id::create(tmp_node.get_name());
  state_chg.m_phase = tmp_node;
  state_chg.m_jump_to = null;
  state_chg.m_prev_state = tmp_node.m_state;
  tmp_node.m_state = UVM_PHASE_DORMANT;
  `uvm_do_callbacks(uvm_phase, uvm_phase_cb, phase_state_change(tmp_node, state_chg)) 
endfunction


// get_parent
// ----------

function uvm_phase uvm_phase::get_parent();
  return m_parent;
endfunction


// get_imp
// -------

function uvm_phase uvm_phase::get_imp();
  return m_imp;
endfunction


// get_schedule
// ------------

function uvm_phase uvm_phase::get_schedule(bit hier=0);
  uvm_phase sched;
  sched = this;
  if (hier) begin
    
    while (sched.m_parent != null && (sched.m_parent.get_phase_type() == UVM_PHASE_SCHEDULE)) begin
      
      sched = sched.m_parent;
    end

  end

  if (sched.m_phase_type == UVM_PHASE_SCHEDULE) begin
    
    return sched;
  end

  if (sched.m_phase_type == UVM_PHASE_NODE) begin
    
    if (m_parent != null && m_parent.m_phase_type != UVM_PHASE_DOMAIN) begin
      
      return m_parent;
    end

  end

  return null;
endfunction


// get_domain
// ----------

function uvm_domain uvm_phase::get_domain();
  uvm_phase phase;
  phase = this;
  while (phase != null && phase.m_phase_type != UVM_PHASE_DOMAIN) begin
    
    phase = phase.m_parent;
  end

  if (phase == null) begin // no parent domain 
    
    return null;
  end

  if(!$cast(get_domain,phase)) begin
    `uvm_fatal("PH/INTERNAL", "get_domain: m_phase_type is DOMAIN but $cast to uvm_domain fails")
  end
endfunction


// get_domain_name
// ---------------
  
function string uvm_phase::get_domain_name();
  uvm_domain domain;
  domain = get_domain();
  if (domain == null) begin
    
    return "unknown";
  end

  return domain.get_name();
endfunction


// get_schedule_name
// -----------------
  
function string uvm_phase::get_schedule_name(bit hier=0);
  uvm_phase sched;
  string s;
  sched = get_schedule(hier);
  if (sched == null) begin
    
    return "";
  end

  s = sched.get_name();
  while (sched.m_parent != null && sched.m_parent != sched &&
          (sched.m_parent.get_phase_type() == UVM_PHASE_SCHEDULE)) begin
    sched = sched.m_parent;
    s = {sched.get_name(),(s.len()>0?".":""),s};
  end
  return s;
endfunction


// get_full_name
// -------------

function string uvm_phase::get_full_name();
  string dom, sch;
  if (m_phase_type == UVM_PHASE_IMP) begin
    
    return get_name();
  end

  get_full_name = get_domain_name();
  sch = get_schedule_name();
  if (sch != "") begin
    
    get_full_name = {get_full_name, ".", sch};
  end

  if (m_phase_type != UVM_PHASE_DOMAIN && m_phase_type != UVM_PHASE_SCHEDULE) begin
    
    get_full_name = {get_full_name, ".", get_name()};
  end

endfunction


// get_phase_type
// --------------

function uvm_phase_type uvm_phase::get_phase_type();
  return m_phase_type;
endfunction

// set_max_ready_to_end_iterations
// -------------------------------

function void uvm_phase::set_max_ready_to_end_iterations(int max);
  max_ready_to_end_iters = max;
endfunction

// get_max_ready_to_end_iterations
// -------------------------------

function int uvm_phase::get_max_ready_to_end_iterations();
  return max_ready_to_end_iters;
endfunction

// set_default_max_ready_to_end_iterations
// ---------------------------------------

function void uvm_phase::set_default_max_ready_to_end_iterations(int max);
  m_default_max_ready_to_end_iters = max;
endfunction

// get_default_max_ready_to_end_iterations
// ---------------------------------------

function int uvm_phase::get_default_max_ready_to_end_iterations();
  return m_default_max_ready_to_end_iters;
endfunction


//-----------------------
// Implementation - State
//-----------------------

// set_state
// ---------
function void uvm_phase::set_state(uvm_phase_state state);
  if (m_state == state) begin
    
    return;
  end

  if (state == UVM_PHASE_STARTED) begin
    
    m_run_count++;
  end

  // TODO: Seems like there should be an official way to set these values...
  m_state_chg.m_jump_to = m_jump_phase;
  m_state_chg.m_prev_state = m_state;
  m_state = state;
  `uvm_do_callbacks(uvm_phase, uvm_phase_cb, phase_state_change(this, m_state_chg))
endfunction : set_state

// get_state
// ---------

function uvm_phase_state uvm_phase::get_state();
  return m_state;
endfunction

// get_run_count
// -------------

function int uvm_phase::get_run_count();
  return m_run_count;
endfunction


// m_print_successors
// ------------------

function void uvm_phase::m_print_successors();
  uvm_phase found;
  static string spaces = "                                                 ";
  static int level;
  if (m_phase_type == UVM_PHASE_DOMAIN) begin
    
    level = 0;
  end

  `uvm_info("UVM/PHASE/SUCC",$sformatf("%s%s (%s) id=%0d",spaces.substr(0,level*2),get_name(), m_phase_type.name(),get_inst_id()),UVM_NONE)
  level++;
  foreach (m_successors[succ]) begin
    succ.m_print_successors();
  end
  level--;
endfunction


// m_find_predecessor
// ------------------

function uvm_phase uvm_phase::m_find_predecessor(uvm_phase phase, bit stay_in_scope=1, uvm_phase orig_phase=null);
  uvm_phase found;
  //$display("  FIND PRED node '",phase.get_name(),"' (id=",$sformatf("%0d",phase.get_inst_id()),") - checking against ",get_name()," (",m_phase_type.name()," id=",$sformatf("%0d",get_inst_id()),(m_imp==null)?"":{"/",$sformatf("%0d",m_imp.get_inst_id())},")");
  if (phase == null) begin
    return null ;
  end
  if (phase == m_imp || phase == this) begin
    
    return this;
  end

  foreach (m_predecessors[pred]) begin
    uvm_phase orig;
    orig = (orig_phase==null) ? this : orig_phase;
    if (!stay_in_scope || 
    (pred.get_schedule() == orig.get_schedule()) ||
    (pred.get_domain() == orig.get_domain())) begin
      found = pred.m_find_predecessor(phase,stay_in_scope,orig);
      if (found != null) begin
        
        return found;
      end

    end
  end
  return null;
endfunction


// m_find_predecessor_by_name
// --------------------------

function uvm_phase uvm_phase::m_find_predecessor_by_name(string name, bit stay_in_scope=1, uvm_phase orig_phase=null);
  uvm_phase found;
  //$display("  FIND PRED node '",name,"' - checking against ",get_name()," (",m_phase_type.name()," id=",$sformatf("%0d",get_inst_id()),(m_imp==null)?"":{"/",$sformatf("%0d",m_imp.get_inst_id())},")");
  if (get_name() == name) begin
    
    return this;
  end

  foreach (m_predecessors[pred]) begin
    uvm_phase orig;
    orig = (orig_phase==null) ? this : orig_phase;
    if (!stay_in_scope || 
    (pred.get_schedule() == orig.get_schedule()) ||
    (pred.get_domain() == orig.get_domain())) begin
      found = pred.m_find_predecessor_by_name(name,stay_in_scope,orig);
      if (found != null) begin
        
        return found;
      end

    end
  end
  return null;
endfunction


// m_find_successor
// ----------------

function uvm_phase uvm_phase::m_find_successor(uvm_phase phase, bit stay_in_scope=1, uvm_phase orig_phase=null);
  uvm_phase found;
  //$display("  FIND SUCC node '",phase.get_name(),"' (id=",$sformatf("%0d",phase.get_inst_id()),") - checking against ",get_name()," (",m_phase_type.name()," id=",$sformatf("%0d",get_inst_id()),(m_imp==null)?"":{"/",$sformatf("%0d",m_imp.get_inst_id())},")");
  if (phase == null) begin
    return null ;
  end
  if (phase == m_imp || phase == this) begin
    return this;
  end
  foreach (m_successors[succ]) begin
    uvm_phase orig;
    orig = (orig_phase==null) ? this : orig_phase;
    if (!stay_in_scope || 
    (succ.get_schedule() == orig.get_schedule()) ||
    (succ.get_domain() == orig.get_domain())) begin
      found = succ.m_find_successor(phase,stay_in_scope,orig);
      if (found != null) begin
        return found;
      end
    end
  end
  return null;
endfunction


// m_find_successor_by_name
// ------------------------

function uvm_phase uvm_phase::m_find_successor_by_name(string name, bit stay_in_scope=1, uvm_phase orig_phase=null);
  uvm_phase found;
  //$display("  FIND SUCC node '",name,"' - checking against ",get_name()," (",m_phase_type.name()," id=",$sformatf("%0d",get_inst_id()),(m_imp==null)?"":{"/",$sformatf("%0d",m_imp.get_inst_id())},")");
  if (get_name() == name) begin
    
    return this;
  end

  foreach (m_successors[succ]) begin
    uvm_phase orig;
    orig = (orig_phase==null) ? this : orig_phase;
    if (!stay_in_scope || 
    (succ.get_schedule() == orig.get_schedule()) ||
    (succ.get_domain() == orig.get_domain())) begin
      found = succ.m_find_successor_by_name(name,stay_in_scope,orig);
      if (found != null) begin
        
        return found;
      end

    end
  end
  return null;
endfunction


// find
// ----

function uvm_phase uvm_phase::find(uvm_phase phase, bit stay_in_scope=1);
  // TBD full search
  //$display({"\nFIND node '",phase.get_name(),"' within ",get_name()," (scope ",m_phase_type.name(),")", (stay_in_scope) ? " staying within scope" : ""});
  if (phase == m_imp || phase == this) begin
    
    return phase;
  end

  find = m_find_predecessor(phase,stay_in_scope,this);
  if (find == null) begin
    
    find = m_find_successor(phase,stay_in_scope,this);
  end

endfunction


// find_by_name
// ------------

function uvm_phase uvm_phase::find_by_name(string name, bit stay_in_scope=1);
  // TBD full search
  //$display({"\nFIND node named '",name,"' within ",get_name()," (scope ",m_phase_type.name(),")", (stay_in_scope) ? " staying within scope" : ""});
  if (get_name() == name) begin
    
    return this;
  end

  find_by_name = m_find_predecessor_by_name(name,stay_in_scope,this);
  if (find_by_name == null) begin
    
    find_by_name = m_find_successor_by_name(name,stay_in_scope,this);
  end

endfunction


// is
// --
  
function bit uvm_phase::is(uvm_phase phase);
  return (m_imp == phase || this == phase); 
endfunction

  
// is_before
// ---------

function bit uvm_phase::is_before(uvm_phase phase);
  //$display("this=%s is before phase=%s?",get_name(),phase.get_name());
  // TODO: add support for 'stay_in_scope=1' functionality
  return (!is(phase) && m_find_successor(phase,0,this) != null);
endfunction


// is_after
// --------
  
function bit uvm_phase::is_after(uvm_phase phase);
  //$display("this=%s is after phase=%s?",get_name(),phase.get_name());
  // TODO: add support for 'stay_in_scope=1' functionality
  return (!is(phase) && m_find_predecessor(phase,0,this) != null);
endfunction

function void uvm_phase::get_adjacent_predecessor_nodes(ref uvm_phase pred[]);
   bit done;
   edges_t predecessors;
   int idx;

   // Get all predecessors (including TERMINALS, SCHEDULES, etc.)
   foreach (m_predecessors[p]) begin
     
     predecessors[p] = 1;
   end


   // Replace any terminal / schedule nodes with their predecessors,
   // recursively.
   do begin
     done = 1;
     foreach (predecessors[p]) begin
       if (p.get_phase_type() != UVM_PHASE_NODE) begin
         predecessors.delete(p);
         foreach (p.m_predecessors[next_p]) begin
              
           predecessors[next_p] = 1;
         end

         done = 0;
       end
     end
   end while (!done); 

   pred = new [predecessors.size()];
   foreach (predecessors[p]) begin
     pred[idx++] = p;
   end
endfunction : get_adjacent_predecessor_nodes

function void uvm_phase::get_adjacent_successor_nodes(ref uvm_phase succ[]);
   bit done;
   edges_t successors;
   int idx;

   // Get all successors (including TERMINALS, SCHEDULES, etc.)
   foreach (m_successors[s]) begin
     
     successors[s] = 1;
   end


   // Replace any terminal / schedule nodes with their successors,
   // recursively.
   do begin
     done = 1;
     foreach (successors[s]) begin
       if (s.get_phase_type() != UVM_PHASE_NODE) begin
         successors.delete(s);
         foreach (s.m_successors[next_s]) begin
              
           successors[next_s] = 1;
         end

         done = 0;
       end
     end
   end while (!done); 

   succ = new [successors.size()];
   foreach (successors[s]) begin
     succ[idx++] = s;
   end
endfunction : get_adjacent_successor_nodes

function void uvm_phase::get_predecessors(ref edges_t predecessors);
  foreach (m_predecessors[p]) begin
    
    predecessors[p] = 1;
  end

endfunction : get_predecessors

function void uvm_phase::get_successors(ref edges_t successors);
  foreach (m_successors[p]) begin
    
    successors[p] = 1;
  end

endfunction : get_successors

function void uvm_phase::get_sync_relationships(ref edges_t relationships);
  foreach (m_sync[i]) begin
    
    relationships[m_sync[i]] = 1;
  end

endfunction : get_sync_relationships

// Internal implementation, more efficient than calling get_predessor_nodes on all
// of the successors returned by get_adjacent_successor_nodes
function void uvm_phase::get_predecessors_for_successors(output edges_t pred_of_succ);
    bit done;
    uvm_phase successors[];

    get_adjacent_successor_nodes(successors);
          
    // get all predecessors to these successors
    foreach (successors[s]) begin
      
      foreach (successors[s].m_predecessors[pred]) begin
        
        pred_of_succ[pred] = 1;
      end

    end

    
    // replace any terminal nodes with their predecessors, recursively.
    // we are only interested in "real" phase nodes
    do begin
      done=1;
      foreach (pred_of_succ[pred]) begin
        if (pred.get_phase_type() != UVM_PHASE_NODE) begin
          pred_of_succ.delete(pred); 
          foreach (pred.m_predecessors[next_pred]) begin
            
            pred_of_succ[next_pred] = 1;
          end

          done =0;
        end
      end
    end while (!done);


    // remove ourselves from the list
    pred_of_succ.delete(this);
endfunction


// m_wait_for_pred
// ---------------

task uvm_phase::m_wait_for_pred();
    edges_t pred_of_succ;
    get_predecessors_for_successors(pred_of_succ);

    // wait for predecessors to successors (real phase nodes, not terminals)
    // mostly debug msgs
    foreach (pred_of_succ[sibling]) begin

      if (m_phase_trace) begin
        string s;
        s = $sformatf("Waiting for phase '%s' (%0d) to be READY_TO_END. Current state is %s",
            sibling.get_name(),sibling.get_inst_id(),sibling.m_state.name());
        `UVM_PH_TRACE("PH/TRC/WAIT_PRED_OF_SUCC",s,this,UVM_HIGH)
      end

      sibling.wait_for_state(UVM_PHASE_READY_TO_END, UVM_GTE);

      if (m_phase_trace) begin
        string s;
        s = $sformatf("Phase '%s' (%0d) is now READY_TO_END. Releasing phase",
            sibling.get_name(),sibling.get_inst_id());
        `UVM_PH_TRACE("PH/TRC/WAIT_PRED_OF_SUCC",s,this,UVM_HIGH)
      end

    end

    if (m_phase_trace) begin
      if (pred_of_succ.num()) begin
        string s = "( ";
        foreach (pred_of_succ[pred]) begin
          
          s = {s, pred.get_full_name()," "};
        end

        s = {s, ")"};
        `UVM_PH_TRACE("PH/TRC/WAIT_PRED_OF_SUCC",
        {"*** All pred to succ ",s," in READY_TO_END state, so ending phase ***"},this,UVM_HIGH)
      end
      else begin
        `UVM_PH_TRACE("PH/TRC/WAIT_PRED_OF_SUCC",
        "*** No pred to succ other than myself, so ending phase ***",this,UVM_HIGH)
      end
    end

  #0; // LET ANY WAITERS WAKE UP

endtask


//---------------------------------
// Implementation - Synchronization
//---------------------------------

function void uvm_phase::m_report_null_objection(uvm_object obj,
                                               string description,
                                               int count,
                                               string action);
   string m_action;
   string m_addon;
   string m_obj_name = (obj == null) ? "uvm_top" : obj.get_full_name();
   
   if ((action == "raise") || (action == "drop")) begin
     if (count != 1) begin
        
       m_action = $sformatf("%s %0d objections", action, count);
     end

     else begin
        
       m_action = $sformatf("%s an objection", action);
     end
 
   end
   else if (action == "get_objection_count") begin
     m_action = "call get_objection_count";
   end

   if (this.get_phase_type() == UVM_PHASE_IMP) begin
     m_addon = " (This is a UVM_PHASE_IMP, you have to query the schedule to find the UVM_PHASE_NODE)";
   end
   
   `uvm_error("UVM/PH/NULL_OBJECTION",
              $sformatf("'%s' attempted to %s on '%s', however '%s' is not a task-based phase node! %s",
                        m_obj_name,
                        m_action,
                        get_name(),
                        get_name(),
                        m_addon))
endfunction : m_report_null_objection
                        
   
// raise_objection
// ---------------

function void uvm_phase::raise_objection (uvm_object obj, 
                                                   string description="",
                                                   int count=1);
  uvm_objection phase_done;
  phase_done = get_objection();
  if (phase_done != null) begin
    
    phase_done.raise_objection(obj,description,count);
  end

  else begin
    
    m_report_null_objection(obj, description, count, "raise");
  end

endfunction


// drop_objection
// --------------

function void uvm_phase::drop_objection (uvm_object obj, 
                                                  string description="",
                                                  int count=1);
  uvm_objection phase_done;
  phase_done = get_objection();
  if (phase_done != null) begin
    
    phase_done.drop_objection(obj,description,count);
  end

  else begin
    
    m_report_null_objection(obj, description, count, "drop");
  end

endfunction

// get_objection_count
// -------------------

function int uvm_phase::get_objection_count (uvm_object obj=null);
  uvm_objection phase_done;
  phase_done = get_objection();
  if (phase_done != null) begin
    
    return phase_done.get_objection_count(obj);
  end

  else begin
    m_report_null_objection(obj, "" , 0, "get_objection_count");
    return 0;
  end
endfunction : get_objection_count

// get_objection_total
// -------------------

function int uvm_phase::get_objection_total (uvm_object obj=null);
  uvm_objection phase_done;
  phase_done = get_objection();
  if (phase_done != null) begin
    
    return phase_done.get_objection_total(obj);
  end

  else begin
    m_report_null_objection(obj, "" , 0, "get_objection_total");
    return 0;
  end
endfunction : get_objection_total

// sync
// ----

function void uvm_phase::sync(uvm_domain target,
                              uvm_phase phase=null,
                              uvm_phase with_phase=null);
  if (!this.is_domain()) begin
    `uvm_fatal("PH_BADSYNC","sync() called from a non-domain phase schedule node")
  end
  else if (target == null) begin
    `uvm_fatal("PH_BADSYNC","sync() called with a null target domain")
  end
  else if (!target.is_domain()) begin
    `uvm_fatal("PH_BADSYNC","sync() called with a non-domain phase schedule node as target")
  end
  else if (phase == null && with_phase != null) begin
    `uvm_fatal("PH_BADSYNC","sync() called with null phase and non-null with phase")
  end
  else if (phase == null) begin
    // whole domain sync - traverse this domain schedule from begin to end node and sync each node
    edges_t visited;
    uvm_phase queue[$];
    queue.push_back(this);
    visited[this] = 1;
    while (queue.size()) begin
      uvm_phase node;
      node = queue.pop_front();
      if (node.m_imp != null) begin
        sync(target, node.m_imp);
      end
      foreach (node.m_successors[succ]) begin
        if (!visited.exists(succ)) begin
          queue.push_back(succ);
          visited[succ] = 1;
        end
      end
    end
  end else begin
    // single phase sync
    // this is a 2-way ('with') sync and we check first in case it is already there
    uvm_phase from_node, to_node;
    int found_to[$], found_from[$];
    if(with_phase == null) begin
      with_phase = phase;
    end

    from_node = find(phase);
    to_node = target.find(with_phase);
    if(from_node == null || to_node == null) begin
      return;
    end

    found_to = from_node.m_sync.find_index(node) with (node == to_node);
    found_from = to_node.m_sync.find_index(node) with (node == from_node);
    if (found_to.size() == 0) begin
      from_node.m_sync.push_back(to_node);
    end

    if (found_from.size() == 0) begin
      to_node.m_sync.push_back(from_node);
    end

  end
endfunction


// unsync
// ------

function void uvm_phase::unsync(uvm_domain target,
                                uvm_phase phase=null,
                                uvm_phase with_phase=null);
  if (!this.is_domain()) begin
    `uvm_fatal("PH_BADSYNC","unsync() called from a non-domain phase schedule node")
  end else if (target == null) begin
    `uvm_fatal("PH_BADSYNC","unsync() called with a null target domain")
  end else if (!target.is_domain()) begin
    `uvm_fatal("PH_BADSYNC","unsync() called with a non-domain phase schedule node as target")
  end else if (phase == null && with_phase != null) begin
    `uvm_fatal("PH_BADSYNC","unsync() called with null phase and non-null with phase")
  end else if (phase == null) begin
    // whole domain unsync - traverse this domain schedule from begin to end node and unsync each node
    edges_t visited;
    uvm_phase queue[$];
    queue.push_back(this);
    visited[this] = 1;
    while (queue.size()) begin
      uvm_phase node;
      node = queue.pop_front();
      if (node.m_imp != null) begin
        unsync(target,node.m_imp);
      end

      foreach (node.m_successors[succ]) begin
        if (!visited.exists(succ)) begin
          queue.push_back(succ);
          visited[succ] = 1;
        end
      end
    end
  end else begin
    // single phase unsync
    // this is a 2-way ('with') sync and we check first in case it is already there
    uvm_phase from_node, to_node;
    int found_to[$], found_from[$];
    if(with_phase == null) begin
      with_phase = phase;
    end

    from_node = find(phase);
    to_node = target.find(with_phase);
    if(from_node == null || to_node == null) begin
      return;
    end

    found_to = from_node.m_sync.find_index(node) with (node == to_node);
    found_from = to_node.m_sync.find_index(node) with (node == from_node);
    if (found_to.size()) begin
      from_node.m_sync.delete(found_to[0]);
    end

    if (found_from.size()) begin
      to_node.m_sync.delete(found_from[0]);
    end

  end
endfunction


// wait_for_state
//---------------
  
task uvm_phase::wait_for_state(uvm_phase_state state, uvm_wait_op op=UVM_EQ);
  case (op)
    UVM_EQ:  begin
      wait((state&m_state) != 0);
    end

    UVM_NE:  begin
      wait((state&m_state) == 0);
    end

    UVM_LT:  begin
      wait(m_state <  state);
    end

    UVM_LTE: begin
      wait(m_state <= state);
    end

    UVM_GT:  begin
      wait(m_state >  state);
    end

    UVM_GTE: begin
      wait(m_state >= state);
    end

  endcase
endtask


//-------------------------
// Implementation - Jumping
//-------------------------

// set_jump_phase
// ----
//
// Specify a phase to transition to when phase is complete.

function void uvm_phase::set_jump_phase(uvm_phase phase) ;
  uvm_phase d;
  bit active;
  uvm_phase_state state;
  state = get_state();
  active = (state >= UVM_PHASE_STARTED) && (state <= UVM_PHASE_ENDED);

  if (!active) begin
    if (phase == null) begin
      // Clear out jump information
      m_jump_phase = null;
      m_jump_fwd = 0;
      m_jump_bkwd = 0;
      m_premature_end = 0;
      return;
    end
    else begin
      `uvm_error("JMPPHIDL", { "Attempting to jump from phase \"",
      get_name(), "\" which is not currently active (current state is ",
      state.name(), "). The jump will not happen until the phase becomes ",
      "active."})
    end
  end
  
  // A jump can be either forward or backwards in the phase graph.
  // If the specified phase (name) is found in the set of predecessors
  // then we are jumping backwards.  If, on the other hand, the phase is in the set
  // of successors then we are jumping forwards.  If neither, then we
  // have an error.
  //
  // If the phase is non-existant and thus we don't know where to jump
  // we have a situation where the only thing to do is to uvm_report_fatal
  // and terminate_phase.  By calling this function the intent was to
  // jump to some other phase. So, continuing in the current phase doesn't
  // make any sense.  And we don't have a valid phase to jump to.  So we're done.

  d = m_find_predecessor(phase,0);
  if (d == null) begin
    d = m_find_successor(phase,0);
    if (d == null) begin
      string msg;
      $sformat(msg,{"phase %s is neither a predecessor or successor of ",
                    "phase %s or is non-existant, so we cannot jump to it.  ",
                    "Phase control flow is now undefined so the simulation ",
                    "must terminate"}, phase.get_name(), get_name());
      `uvm_fatal("PH_BADJUMP", msg)
    end
    else begin
      m_jump_fwd = 1;
      `uvm_info("PH_JUMPF",$sformatf("jumping forward to phase %s", phase.get_name()),
      UVM_DEBUG)
    end
  end
  else begin
    m_jump_bkwd = 1;
    `uvm_info("PH_JUMPB",$sformatf("jumping backward to phase %s", phase.get_name()),
    UVM_DEBUG)
  end
  
  m_jump_phase = d;
endfunction

// is_jumping_forward
function bit uvm_phase::is_jumping_forward();
  return m_jump_fwd;
endfunction : is_jumping_forward

// is_jumping_backward
function bit uvm_phase::is_jumping_backward();
  return m_jump_bkwd;
endfunction : is_jumping_backward

// end_prematurely
// ----
//
// Set a flag to cause the phase to end prematurely.  

function void uvm_phase::end_prematurely() ;
   m_premature_end = 1 ;
endfunction

// is_ending_permaturely
function bit uvm_phase::is_ending_prematurely();
  return m_premature_end;
endfunction : is_ending_prematurely


// jump
// ----
//
// Note that this function does not directly alter flow of control.
// That is, the new phase is not initiated in this function.
// Rather, flags are set which execute_phase() uses to determine
// that a jump has been requested and performs the jump.

function void uvm_phase::jump(uvm_phase phase);
   set_jump_phase(phase) ;
   end_prematurely() ;
endfunction


// jump_all
// --------
function void uvm_phase::jump_all(uvm_phase phase);
    `uvm_warning("NOTIMPL","uvm_phase::jump_all is not implemented and has been replaced by uvm_domain::jump_all")
endfunction


// get_jump_target
// ---------------
  
function uvm_phase uvm_phase::get_jump_target();
  return m_jump_phase;
endfunction


// clear
// -----
// for internal graph maintenance after a forward jump
function void uvm_phase::clear(uvm_phase_state state = UVM_PHASE_DORMANT);
  uvm_objection phase_done;
  phase_done = get_objection();
  set_state(state);
  m_phase_proc = null;
  if (phase_done != null) begin
    
    phase_done.clear(this);
  end

endfunction


// clear_successors
// ----------------
// for internal graph maintenance after a forward jump
// - called only by execute_phase()
// - depth-first traversal of the DAG, calliing clear() on each node
// - do not clear the end phase or beyond 
function void uvm_phase::clear_successors(uvm_phase_state state = UVM_PHASE_DORMANT, 
    uvm_phase end_state=null);
  if(this == end_state) begin 
    
    return;
  end

  clear(state);
  foreach(m_successors[succ]) begin
    succ.clear_successors(state, end_state);
  end
endfunction


//---------------------------------
// Implementation - Overall Control
//---------------------------------
// wait_for_self_and_siblings_to_drop
// -----------------------------
// This task loops until this phase instance and all its siblings, either
// sync'd or sharing a common successor, have all objections dropped.
task uvm_phase::wait_for_self_and_siblings_to_drop() ;
  bit need_to_check_all = 1 ;
  uvm_root top;
  uvm_coreservice_t cs;
  edges_t siblings;
  
  `UVM_PH_TRACE("PH/TRC/WAIT_SELF_AND_SIBLINGS","WAITING FOR SELF AND SIBLINGS TO DROP",this,UVM_HIGH)
  
  cs = uvm_coreservice_t::get();
  top = cs.get_root();
  
  get_predecessors_for_successors(siblings);
  foreach (m_sync[i]) begin
    siblings[m_sync[i]] = 1;
  end

  // Put ourselves in the list of siblings
  siblings[this] = 1;
  
  while (need_to_check_all) begin
    uvm_objection phase_done;
    string msg;
    phase_done = get_objection();
    need_to_check_all = 0 ; //if all are dropped, we won't need to do this again

    // now wait for siblings to drop
    foreach(siblings[sib]) begin
      phase_done = sib.get_objection();
      sib.wait_for_state(UVM_PHASE_EXECUTING, UVM_GTE); // sibling must be at least executing 
      if ((phase_done != null) && (phase_done.get_objection_total(top) != 0)) begin
        if (m_phase_trace) begin
          msg = $sformatf("Waiting for phase '%s' (%0d) to be READY_TO_END. Current state is %s",
                          sib.get_name(),sib.get_inst_id(),sib.m_state.name());
          `UVM_PH_TRACE("PH/TRC/WAIT_SELF_AND_SIBLINGS",msg,this,UVM_HIGH)
        end
        m_state = UVM_PHASE_EXECUTING ;
        phase_done.wait_for(UVM_ALL_DROPPED, top); // sibling must drop any objection
        if (m_phase_trace) begin
          msg = $sformatf("Phase '%s' (%0d) is now READY_TO_END. Releasing phase",
                          sib.get_name(),sib.get_inst_id());
          `UVM_PH_TRACE("PH/TRC/WAIT_SELF_AND_SIBLINGS",msg,this,UVM_HIGH)
        end
        need_to_check_all = 1 ;
      end
    end
  end
endtask

// kill
// ----

function void uvm_phase::kill();

  `uvm_info("PH_KILL", {"killing phase '", get_name(),"'"}, UVM_DEBUG)

  if (m_phase_proc != null) begin
    m_phase_proc.kill();
    m_phase_proc = null;
  end

endfunction


// kill_successors
// ---------------

// Using a depth-first traversal, kill all the successor phases of the
// current phase.
function void uvm_phase::kill_successors();
  foreach (m_successors[succ]) begin
    
    succ.kill_successors();
  end

  kill();
endfunction


// terminate_phase
// ---------------

function void uvm_phase::m_terminate_phase();
  uvm_objection phase_done;
  phase_done = get_objection();
  if (phase_done != null) begin
    
    phase_done.clear(this);
  end

endfunction


// print_termination_state
// -----------------------

function void uvm_phase::m_print_termination_state();
  uvm_root top;
  uvm_coreservice_t cs;
  uvm_objection phase_done;
  phase_done = get_objection();
  cs = uvm_coreservice_t::get();
  top = cs.get_root();
  if (phase_done != null) begin
    `uvm_info("PH_TERMSTATE",
    $sformatf("phase %s outstanding objections = %0d",
    get_name(), phase_done.get_objection_total(top)),
    UVM_DEBUG)
  end
  else begin
    `uvm_info("PH_TERMSTATE",
    $sformatf("phase %s has no outstanding objections",
    get_name()),
    UVM_DEBUG)
  end
endfunction

   

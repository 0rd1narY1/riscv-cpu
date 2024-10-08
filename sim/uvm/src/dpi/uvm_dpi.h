//----------------------------------------------------------------------
// Copyright 2010-2018 Cadence Design Systems, Inc.
// Copyright 2010-2017 Mentor Graphics Corporation
// Copyright 2013-2024 NVIDIA Corporation
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
// $File:     src/dpi/uvm_dpi.h $
// $Rev:      2024-02-08 13:43:04 -0800 $
// $Hash:     29e1e3f8ee4d4aa2035dba1aba401ce1c19aa340 $
//
//----------------------------------------------------------------------


//
// Top level header filke that wraps all requirements which
// are common to the various C/C++ files in UVM.
//

#ifndef UVM_DPI__H
#define UVM_DPI__H

#include <stdlib.h>
#include "vpi_user.h"
#include "veriuser.h"
#include "svdpi.h"
#include <malloc.h>
#include <string.h>
#include <stdio.h>
#include <regex.h>
#include <limits.h>

// The following consts and method call are for
// internal usage by the UVM DPI implementation,
// and are not intended for public use.
static const int M_UVM_INFO = 0;
static const int M_UVM_WARNING = 1;
static const int M_UVM_ERROR = 2;
static const int M_UVM_FATAL = 3;

static const int M_UVM_NONE = 0;
static const int M_UVM_LOW = 100;
static const int M_UVM_MEDIUM = 200;
static const int M_UVM_HIGH = 300;
static const int M_UVM_FULL = 400;
static const int M_UVM_DEBUG = 500;

void m_uvm_report_dpi(int severity,
                      char* id,
                      char* message,
                      int verbosity,
                      char* file,
                      int linenum);

int int_str_max( int );

char * uvm_re_buffer();
const char * uvm_re_deglobbed(const char *glob, unsigned char with_brackets);
void uvm_re_free(regex_t* handle);
regex_t* uvm_re_comp(const char *re, unsigned char deglob);
int uvm_re_exec(regex_t* rexp, const char *str);
regex_t* uvm_re_compexec(const char *re, const char *str, unsigned char deglob, int* exec_ret);


int uvm_hdl_check_path(char *path);
int uvm_hdl_read(char *path, p_vpi_vecval value);
int uvm_hdl_deposit(char *path, p_vpi_vecval value);
int uvm_hdl_force(char *path, p_vpi_vecval value);
int uvm_hdl_release_and_read(char *path, p_vpi_vecval value);
int uvm_hdl_release(char *path);

void push_data(int lvl,char *entry, int cmd);
void walk_level(int lvl, int argc, char**argv,int cmd);
const char *uvm_dpi_get_next_arg_c (int init);
extern char* uvm_dpi_get_tool_name_c ();
extern char* uvm_dpi_get_tool_version_c ();

#endif

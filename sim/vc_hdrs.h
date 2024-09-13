#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif
#include <stdio.h>
#include <dlfcn.h>
#include "svdpi.h"

#ifdef __cplusplus
extern "C" {
#endif

#ifndef _VC_TYPES_
#define _VC_TYPES_
/* common definitions shared with DirectC.h */

typedef unsigned int U;
typedef unsigned char UB;
typedef unsigned char scalar;
typedef struct { U c; U d;} vec32;

#define scalar_0 0
#define scalar_1 1
#define scalar_z 2
#define scalar_x 3

extern long long int ConvUP2LLI(U* a);
extern void ConvLLI2UP(long long int a1, U* a2);
extern long long int GetLLIresult();
extern void StoreLLIresult(const unsigned int* data);
typedef struct VeriC_Descriptor *vc_handle;

#ifndef SV_3_COMPATIBILITY
#define SV_STRING const char*
#else
#define SV_STRING char*
#endif

#endif /* _VC_TYPES_ */


 extern int uvm_hdl_check_path(/* INPUT */const char* path);

 extern int uvm_hdl_deposit(/* INPUT */const char* path, const /* INPUT */svLogicVecVal *value);

 extern int uvm_hdl_force(/* INPUT */const char* path, const /* INPUT */svLogicVecVal *value);

 extern int uvm_hdl_release_and_read(/* INPUT */const char* path, /* INOUT */svLogicVecVal *value);

 extern int uvm_hdl_release(/* INPUT */const char* path);

 extern int uvm_hdl_read(/* INPUT */const char* path, /* OUTPUT */svLogicVecVal *value);

 extern SV_STRING uvm_dpi_get_next_arg_c(/* INPUT */int init);

 extern SV_STRING uvm_dpi_get_tool_name_c();

 extern SV_STRING uvm_dpi_get_tool_version_c();

 extern SV_STRING uvm_re_deglobbed(/* INPUT */const char* glob, /* INPUT */unsigned char with_brackets);

 extern SV_STRING uvm_re_buffer();

 extern void uvm_re_free(/* INPUT */void* rexp);

 extern void* uvm_re_comp(/* INPUT */const char* re, /* INPUT */unsigned char deglob);

 extern int uvm_re_exec(/* INPUT */void* rexp, /* INPUT */const char* str);

 extern void* uvm_re_compexec(/* INPUT */const char* re, /* INPUT */const char* str, /* INPUT */unsigned char deglob, /* OUTPUT */int *exec_ret);

 extern unsigned char uvm_re_compexecfree(/* INPUT */const char* re, /* INPUT */const char* str, /* INPUT */unsigned char deglob, /* OUTPUT */int *exec_ret);

 extern void m__uvm_report_dpi(/* INPUT */int severity, /* INPUT */const char* id, /* INPUT */const char* message, /* INPUT */int verbosity, /* INPUT */const char* filename, /* INPUT */int line);

 extern void uvm_polling_value_change_notify(/* INPUT */int sv_key);
void SdisableFork();

#ifdef __cplusplus
}
#endif


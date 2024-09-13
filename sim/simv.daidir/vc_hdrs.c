#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif
#include <stdio.h>
#include <dlfcn.h>
#include "svdpi.h"

#ifdef __cplusplus
extern "C" {
#endif

/* VCS error reporting routine */
extern void vcsMsgReport1(const char *, const char *, int, void *, void*, const char *);

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

#ifndef __VCS_IMPORT_DPI_STUB_uvm_hdl_check_path
#define __VCS_IMPORT_DPI_STUB_uvm_hdl_check_path
__attribute__((weak)) int uvm_hdl_check_path(/* INPUT */const char* A_1)
{
    static int _vcs_dpi_stub_initialized_ = 0;
    static int (*_vcs_dpi_fp_)(/* INPUT */const char* A_1) = NULL;
    if (!_vcs_dpi_stub_initialized_) {
        _vcs_dpi_stub_initialized_ = 1;
        _vcs_dpi_fp_ = (int (*)(const char* A_1)) dlsym(RTLD_NEXT, "uvm_hdl_check_path");
    }
    if (_vcs_dpi_fp_) {
        return _vcs_dpi_fp_(A_1);
    } else {
        const char *fileName;
        int lineNumber;
        svGetCallerInfo(&fileName, &lineNumber);
        vcsMsgReport1("DPI-DIFNF", fileName, lineNumber, 0, 0, "uvm_hdl_check_path");
        return 0;
    }
}
#endif /* __VCS_IMPORT_DPI_STUB_uvm_hdl_check_path */

#ifndef __VCS_IMPORT_DPI_STUB_uvm_hdl_deposit
#define __VCS_IMPORT_DPI_STUB_uvm_hdl_deposit
__attribute__((weak)) int uvm_hdl_deposit(/* INPUT */const char* A_1, const /* INPUT */svLogicVecVal *A_2)
{
    static int _vcs_dpi_stub_initialized_ = 0;
    static int (*_vcs_dpi_fp_)(/* INPUT */const char* A_1, const /* INPUT */svLogicVecVal *A_2) = NULL;
    if (!_vcs_dpi_stub_initialized_) {
        _vcs_dpi_stub_initialized_ = 1;
        _vcs_dpi_fp_ = (int (*)(const char* A_1, const svLogicVecVal* A_2)) dlsym(RTLD_NEXT, "uvm_hdl_deposit");
    }
    if (_vcs_dpi_fp_) {
        return _vcs_dpi_fp_(A_1, A_2);
    } else {
        const char *fileName;
        int lineNumber;
        svGetCallerInfo(&fileName, &lineNumber);
        vcsMsgReport1("DPI-DIFNF", fileName, lineNumber, 0, 0, "uvm_hdl_deposit");
        return 0;
    }
}
#endif /* __VCS_IMPORT_DPI_STUB_uvm_hdl_deposit */

#ifndef __VCS_IMPORT_DPI_STUB_uvm_hdl_force
#define __VCS_IMPORT_DPI_STUB_uvm_hdl_force
__attribute__((weak)) int uvm_hdl_force(/* INPUT */const char* A_1, const /* INPUT */svLogicVecVal *A_2)
{
    static int _vcs_dpi_stub_initialized_ = 0;
    static int (*_vcs_dpi_fp_)(/* INPUT */const char* A_1, const /* INPUT */svLogicVecVal *A_2) = NULL;
    if (!_vcs_dpi_stub_initialized_) {
        _vcs_dpi_stub_initialized_ = 1;
        _vcs_dpi_fp_ = (int (*)(const char* A_1, const svLogicVecVal* A_2)) dlsym(RTLD_NEXT, "uvm_hdl_force");
    }
    if (_vcs_dpi_fp_) {
        return _vcs_dpi_fp_(A_1, A_2);
    } else {
        const char *fileName;
        int lineNumber;
        svGetCallerInfo(&fileName, &lineNumber);
        vcsMsgReport1("DPI-DIFNF", fileName, lineNumber, 0, 0, "uvm_hdl_force");
        return 0;
    }
}
#endif /* __VCS_IMPORT_DPI_STUB_uvm_hdl_force */

#ifndef __VCS_IMPORT_DPI_STUB_uvm_hdl_release_and_read
#define __VCS_IMPORT_DPI_STUB_uvm_hdl_release_and_read
__attribute__((weak)) int uvm_hdl_release_and_read(/* INPUT */const char* A_1, /* INOUT */svLogicVecVal *A_2)
{
    static int _vcs_dpi_stub_initialized_ = 0;
    static int (*_vcs_dpi_fp_)(/* INPUT */const char* A_1, /* INOUT */svLogicVecVal *A_2) = NULL;
    if (!_vcs_dpi_stub_initialized_) {
        _vcs_dpi_stub_initialized_ = 1;
        _vcs_dpi_fp_ = (int (*)(const char* A_1, svLogicVecVal* A_2)) dlsym(RTLD_NEXT, "uvm_hdl_release_and_read");
    }
    if (_vcs_dpi_fp_) {
        return _vcs_dpi_fp_(A_1, A_2);
    } else {
        const char *fileName;
        int lineNumber;
        svGetCallerInfo(&fileName, &lineNumber);
        vcsMsgReport1("DPI-DIFNF", fileName, lineNumber, 0, 0, "uvm_hdl_release_and_read");
        return 0;
    }
}
#endif /* __VCS_IMPORT_DPI_STUB_uvm_hdl_release_and_read */

#ifndef __VCS_IMPORT_DPI_STUB_uvm_hdl_release
#define __VCS_IMPORT_DPI_STUB_uvm_hdl_release
__attribute__((weak)) int uvm_hdl_release(/* INPUT */const char* A_1)
{
    static int _vcs_dpi_stub_initialized_ = 0;
    static int (*_vcs_dpi_fp_)(/* INPUT */const char* A_1) = NULL;
    if (!_vcs_dpi_stub_initialized_) {
        _vcs_dpi_stub_initialized_ = 1;
        _vcs_dpi_fp_ = (int (*)(const char* A_1)) dlsym(RTLD_NEXT, "uvm_hdl_release");
    }
    if (_vcs_dpi_fp_) {
        return _vcs_dpi_fp_(A_1);
    } else {
        const char *fileName;
        int lineNumber;
        svGetCallerInfo(&fileName, &lineNumber);
        vcsMsgReport1("DPI-DIFNF", fileName, lineNumber, 0, 0, "uvm_hdl_release");
        return 0;
    }
}
#endif /* __VCS_IMPORT_DPI_STUB_uvm_hdl_release */

#ifndef __VCS_IMPORT_DPI_STUB_uvm_hdl_read
#define __VCS_IMPORT_DPI_STUB_uvm_hdl_read
__attribute__((weak)) int uvm_hdl_read(/* INPUT */const char* A_1, /* OUTPUT */svLogicVecVal *A_2)
{
    static int _vcs_dpi_stub_initialized_ = 0;
    static int (*_vcs_dpi_fp_)(/* INPUT */const char* A_1, /* OUTPUT */svLogicVecVal *A_2) = NULL;
    if (!_vcs_dpi_stub_initialized_) {
        _vcs_dpi_stub_initialized_ = 1;
        _vcs_dpi_fp_ = (int (*)(const char* A_1, svLogicVecVal* A_2)) dlsym(RTLD_NEXT, "uvm_hdl_read");
    }
    if (_vcs_dpi_fp_) {
        return _vcs_dpi_fp_(A_1, A_2);
    } else {
        const char *fileName;
        int lineNumber;
        svGetCallerInfo(&fileName, &lineNumber);
        vcsMsgReport1("DPI-DIFNF", fileName, lineNumber, 0, 0, "uvm_hdl_read");
        return 0;
    }
}
#endif /* __VCS_IMPORT_DPI_STUB_uvm_hdl_read */

#ifndef __VCS_IMPORT_DPI_STUB_uvm_dpi_get_next_arg_c
#define __VCS_IMPORT_DPI_STUB_uvm_dpi_get_next_arg_c
__attribute__((weak)) SV_STRING uvm_dpi_get_next_arg_c(/* INPUT */int A_1)
{
    static int _vcs_dpi_stub_initialized_ = 0;
    static SV_STRING (*_vcs_dpi_fp_)(/* INPUT */int A_1) = NULL;
    if (!_vcs_dpi_stub_initialized_) {
        _vcs_dpi_stub_initialized_ = 1;
        _vcs_dpi_fp_ = (SV_STRING (*)(int A_1)) dlsym(RTLD_NEXT, "uvm_dpi_get_next_arg_c");
    }
    if (_vcs_dpi_fp_) {
        return _vcs_dpi_fp_(A_1);
    } else {
        const char *fileName;
        int lineNumber;
        svGetCallerInfo(&fileName, &lineNumber);
        vcsMsgReport1("DPI-DIFNF", fileName, lineNumber, 0, 0, "uvm_dpi_get_next_arg_c");
        return 0;
    }
}
#endif /* __VCS_IMPORT_DPI_STUB_uvm_dpi_get_next_arg_c */

#ifndef __VCS_IMPORT_DPI_STUB_uvm_dpi_get_tool_name_c
#define __VCS_IMPORT_DPI_STUB_uvm_dpi_get_tool_name_c
__attribute__((weak)) SV_STRING uvm_dpi_get_tool_name_c()
{
    static int _vcs_dpi_stub_initialized_ = 0;
    static SV_STRING (*_vcs_dpi_fp_)() = NULL;
    if (!_vcs_dpi_stub_initialized_) {
        _vcs_dpi_stub_initialized_ = 1;
        _vcs_dpi_fp_ = (SV_STRING (*)()) dlsym(RTLD_NEXT, "uvm_dpi_get_tool_name_c");
    }
    if (_vcs_dpi_fp_) {
        return _vcs_dpi_fp_();
    } else {
        const char *fileName;
        int lineNumber;
        svGetCallerInfo(&fileName, &lineNumber);
        vcsMsgReport1("DPI-DIFNF", fileName, lineNumber, 0, 0, "uvm_dpi_get_tool_name_c");
        return 0;
    }
}
#endif /* __VCS_IMPORT_DPI_STUB_uvm_dpi_get_tool_name_c */

#ifndef __VCS_IMPORT_DPI_STUB_uvm_dpi_get_tool_version_c
#define __VCS_IMPORT_DPI_STUB_uvm_dpi_get_tool_version_c
__attribute__((weak)) SV_STRING uvm_dpi_get_tool_version_c()
{
    static int _vcs_dpi_stub_initialized_ = 0;
    static SV_STRING (*_vcs_dpi_fp_)() = NULL;
    if (!_vcs_dpi_stub_initialized_) {
        _vcs_dpi_stub_initialized_ = 1;
        _vcs_dpi_fp_ = (SV_STRING (*)()) dlsym(RTLD_NEXT, "uvm_dpi_get_tool_version_c");
    }
    if (_vcs_dpi_fp_) {
        return _vcs_dpi_fp_();
    } else {
        const char *fileName;
        int lineNumber;
        svGetCallerInfo(&fileName, &lineNumber);
        vcsMsgReport1("DPI-DIFNF", fileName, lineNumber, 0, 0, "uvm_dpi_get_tool_version_c");
        return 0;
    }
}
#endif /* __VCS_IMPORT_DPI_STUB_uvm_dpi_get_tool_version_c */

#ifndef __VCS_IMPORT_DPI_STUB_uvm_re_deglobbed
#define __VCS_IMPORT_DPI_STUB_uvm_re_deglobbed
__attribute__((weak)) SV_STRING uvm_re_deglobbed(/* INPUT */const char* A_1, /* INPUT */unsigned char A_2)
{
    static int _vcs_dpi_stub_initialized_ = 0;
    static SV_STRING (*_vcs_dpi_fp_)(/* INPUT */const char* A_1, /* INPUT */unsigned char A_2) = NULL;
    if (!_vcs_dpi_stub_initialized_) {
        _vcs_dpi_stub_initialized_ = 1;
        _vcs_dpi_fp_ = (SV_STRING (*)(const char* A_1, unsigned char A_2)) dlsym(RTLD_NEXT, "uvm_re_deglobbed");
    }
    if (_vcs_dpi_fp_) {
        return _vcs_dpi_fp_(A_1, A_2);
    } else {
        const char *fileName;
        int lineNumber;
        svGetCallerInfo(&fileName, &lineNumber);
        vcsMsgReport1("DPI-DIFNF", fileName, lineNumber, 0, 0, "uvm_re_deglobbed");
        return 0;
    }
}
#endif /* __VCS_IMPORT_DPI_STUB_uvm_re_deglobbed */

#ifndef __VCS_IMPORT_DPI_STUB_uvm_re_buffer
#define __VCS_IMPORT_DPI_STUB_uvm_re_buffer
__attribute__((weak)) SV_STRING uvm_re_buffer()
{
    static int _vcs_dpi_stub_initialized_ = 0;
    static SV_STRING (*_vcs_dpi_fp_)() = NULL;
    if (!_vcs_dpi_stub_initialized_) {
        _vcs_dpi_stub_initialized_ = 1;
        _vcs_dpi_fp_ = (SV_STRING (*)()) dlsym(RTLD_NEXT, "uvm_re_buffer");
    }
    if (_vcs_dpi_fp_) {
        return _vcs_dpi_fp_();
    } else {
        const char *fileName;
        int lineNumber;
        svGetCallerInfo(&fileName, &lineNumber);
        vcsMsgReport1("DPI-DIFNF", fileName, lineNumber, 0, 0, "uvm_re_buffer");
        return 0;
    }
}
#endif /* __VCS_IMPORT_DPI_STUB_uvm_re_buffer */

#ifndef __VCS_IMPORT_DPI_STUB_uvm_re_free
#define __VCS_IMPORT_DPI_STUB_uvm_re_free
__attribute__((weak)) void uvm_re_free(/* INPUT */void* A_1)
{
    static int _vcs_dpi_stub_initialized_ = 0;
    static void (*_vcs_dpi_fp_)(/* INPUT */void* A_1) = NULL;
    if (!_vcs_dpi_stub_initialized_) {
        _vcs_dpi_stub_initialized_ = 1;
        _vcs_dpi_fp_ = (void (*)(void* A_1)) dlsym(RTLD_NEXT, "uvm_re_free");
    }
    if (_vcs_dpi_fp_) {
        _vcs_dpi_fp_(A_1);
    } else {
        const char *fileName;
        int lineNumber;
        svGetCallerInfo(&fileName, &lineNumber);
        vcsMsgReport1("DPI-DIFNF", fileName, lineNumber, 0, 0, "uvm_re_free");
    }
}
#endif /* __VCS_IMPORT_DPI_STUB_uvm_re_free */

#ifndef __VCS_IMPORT_DPI_STUB_uvm_re_comp
#define __VCS_IMPORT_DPI_STUB_uvm_re_comp
__attribute__((weak)) void* uvm_re_comp(/* INPUT */const char* A_1, /* INPUT */unsigned char A_2)
{
    static int _vcs_dpi_stub_initialized_ = 0;
    static void* (*_vcs_dpi_fp_)(/* INPUT */const char* A_1, /* INPUT */unsigned char A_2) = NULL;
    if (!_vcs_dpi_stub_initialized_) {
        _vcs_dpi_stub_initialized_ = 1;
        _vcs_dpi_fp_ = (void* (*)(const char* A_1, unsigned char A_2)) dlsym(RTLD_NEXT, "uvm_re_comp");
    }
    if (_vcs_dpi_fp_) {
        return _vcs_dpi_fp_(A_1, A_2);
    } else {
        const char *fileName;
        int lineNumber;
        svGetCallerInfo(&fileName, &lineNumber);
        vcsMsgReport1("DPI-DIFNF", fileName, lineNumber, 0, 0, "uvm_re_comp");
        return 0;
    }
}
#endif /* __VCS_IMPORT_DPI_STUB_uvm_re_comp */

#ifndef __VCS_IMPORT_DPI_STUB_uvm_re_exec
#define __VCS_IMPORT_DPI_STUB_uvm_re_exec
__attribute__((weak)) int uvm_re_exec(/* INPUT */void* A_1, /* INPUT */const char* A_2)
{
    static int _vcs_dpi_stub_initialized_ = 0;
    static int (*_vcs_dpi_fp_)(/* INPUT */void* A_1, /* INPUT */const char* A_2) = NULL;
    if (!_vcs_dpi_stub_initialized_) {
        _vcs_dpi_stub_initialized_ = 1;
        _vcs_dpi_fp_ = (int (*)(void* A_1, const char* A_2)) dlsym(RTLD_NEXT, "uvm_re_exec");
    }
    if (_vcs_dpi_fp_) {
        return _vcs_dpi_fp_(A_1, A_2);
    } else {
        const char *fileName;
        int lineNumber;
        svGetCallerInfo(&fileName, &lineNumber);
        vcsMsgReport1("DPI-DIFNF", fileName, lineNumber, 0, 0, "uvm_re_exec");
        return 0;
    }
}
#endif /* __VCS_IMPORT_DPI_STUB_uvm_re_exec */

#ifndef __VCS_IMPORT_DPI_STUB_uvm_re_compexec
#define __VCS_IMPORT_DPI_STUB_uvm_re_compexec
__attribute__((weak)) void* uvm_re_compexec(/* INPUT */const char* A_1, /* INPUT */const char* A_2, /* INPUT */unsigned char A_3, /* OUTPUT */int *A_4)
{
    static int _vcs_dpi_stub_initialized_ = 0;
    static void* (*_vcs_dpi_fp_)(/* INPUT */const char* A_1, /* INPUT */const char* A_2, /* INPUT */unsigned char A_3, /* OUTPUT */int *A_4) = NULL;
    if (!_vcs_dpi_stub_initialized_) {
        _vcs_dpi_stub_initialized_ = 1;
        _vcs_dpi_fp_ = (void* (*)(const char* A_1, const char* A_2, unsigned char A_3, int* A_4)) dlsym(RTLD_NEXT, "uvm_re_compexec");
    }
    if (_vcs_dpi_fp_) {
        return _vcs_dpi_fp_(A_1, A_2, A_3, A_4);
    } else {
        const char *fileName;
        int lineNumber;
        svGetCallerInfo(&fileName, &lineNumber);
        vcsMsgReport1("DPI-DIFNF", fileName, lineNumber, 0, 0, "uvm_re_compexec");
        return 0;
    }
}
#endif /* __VCS_IMPORT_DPI_STUB_uvm_re_compexec */

#ifndef __VCS_IMPORT_DPI_STUB_uvm_re_compexecfree
#define __VCS_IMPORT_DPI_STUB_uvm_re_compexecfree
__attribute__((weak)) unsigned char uvm_re_compexecfree(/* INPUT */const char* A_1, /* INPUT */const char* A_2, /* INPUT */unsigned char A_3, /* OUTPUT */int *A_4)
{
    static int _vcs_dpi_stub_initialized_ = 0;
    static unsigned char (*_vcs_dpi_fp_)(/* INPUT */const char* A_1, /* INPUT */const char* A_2, /* INPUT */unsigned char A_3, /* OUTPUT */int *A_4) = NULL;
    if (!_vcs_dpi_stub_initialized_) {
        _vcs_dpi_stub_initialized_ = 1;
        _vcs_dpi_fp_ = (unsigned char (*)(const char* A_1, const char* A_2, unsigned char A_3, int* A_4)) dlsym(RTLD_NEXT, "uvm_re_compexecfree");
    }
    if (_vcs_dpi_fp_) {
        return _vcs_dpi_fp_(A_1, A_2, A_3, A_4);
    } else {
        const char *fileName;
        int lineNumber;
        svGetCallerInfo(&fileName, &lineNumber);
        vcsMsgReport1("DPI-DIFNF", fileName, lineNumber, 0, 0, "uvm_re_compexecfree");
        return 0;
    }
}
#endif /* __VCS_IMPORT_DPI_STUB_uvm_re_compexecfree */

#ifndef __VCS_EXPORT_DPI_DUMMY_REFERENCES__
#define __VCS_EXPORT_DPI_DUMMY_REFERENCES__
/* Dummy references to those export DPI routines.
 * The symbols will be then exported, so the
 * import DPI routines in another shared
 * libraries can call.
 */
void __vcs_export_dpi_dummy_references__();
void __vcs_export_dpi_dummy_references__()
{
    extern void m__uvm_report_dpi(void);
    void (*fp0)(void) = (void (*)(void)) m__uvm_report_dpi;
    fp0 = fp0;
    extern void uvm_polling_value_change_notify(void);
    void (*fp1)(void) = (void (*)(void)) uvm_polling_value_change_notify;
    fp1 = fp1;
}
#endif /* __VCS_EXPORT_DPI_DUMMY_REFERENCES_ */

#ifdef __cplusplus
}
#endif


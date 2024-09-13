
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

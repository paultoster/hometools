/*
 * MATLAB Compiler: 3.0
 * Date: Mon May 17 15:14:06 2004
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-x" "-W" "mex" "-L" "C"
 * "-t" "-T" "link:mexlibrary" "libmatlbmx.mlib" "-h" "-A" "annotation:all"
 * "duh_peak_filter_f" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __duh_peak_filter_f_h
#define __duh_peak_filter_f_h 1

#ifdef __cplusplus
extern "C" {
#endif

#include "libmatlb.h"

extern void InitializeModule_duh_peak_filter_f(void);
extern void TerminateModule_duh_peak_filter_f(void);
extern _mexLocalFunctionTable _local_function_table_duh_peak_filter_f;

extern mxArray * mlfDuh_peak_filter_f(mxArray * * c_comment,
                                      mxArray * d_in,
                                      mxArray * std_fac,
                                      mxArray * all);
extern void mlxDuh_peak_filter_f(int nlhs,
                                 mxArray * plhs[],
                                 int nrhs,
                                 mxArray * prhs[]);

#ifdef __cplusplus
}
#endif

#endif

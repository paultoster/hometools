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

#include "libmatlb.h"
#include "duh_peak_filter_f.h"
#include "getfield.h"
#include "setfield.h"
#include "sortiere_aufsteigend_f.h"
#include "std.h"
#include "repmat.h"
#include "libmatlbm.h"

extern _mex_information _mex_info;

static mexFunctionTableEntry function_table[6]
  = { { "duh_peak_filter_f", mlxDuh_peak_filter_f, 3,
        2, &_local_function_table_duh_peak_filter_f },
      { "getfield", mlxGetfield, -2, 1, &_local_function_table_getfield },
      { "setfield", mlxSetfield, -2, 1, &_local_function_table_setfield },
      { "sortiere_aufsteigend_f", mlxSortiere_aufsteigend_f,
        1, 1, &_local_function_table_sortiere_aufsteigend_f },
      { "std", mlxStd, 3, 1, &_local_function_table_std },
      { "repmat", mlxRepmat, 3, 1, &_local_function_table_repmat } };

static _mexInitTermTableEntry init_term_table[7]
  = { { libmatlbmxInitialize, libmatlbmxTerminate },
      { InitializeModule_duh_peak_filter_f,
        TerminateModule_duh_peak_filter_f },
      { InitializeModule_getfield, TerminateModule_getfield },
      { InitializeModule_setfield, TerminateModule_setfield },
      { InitializeModule_sortiere_aufsteigend_f,
        TerminateModule_sortiere_aufsteigend_f },
      { InitializeModule_std, TerminateModule_std },
      { InitializeModule_repmat, TerminateModule_repmat } };

/*
 * The function "mexLibrary" is a Compiler-generated mex wrapper, suitable for
 * building a MEX-function. It initializes any persistent variables as well as
 * a function table for use by the feval function. It then calls the function
 * "mlxDuh_peak_filter_f". Finally, it clears the feval table and exits.
 */
mex_information mexLibrary(void) {
    mclMexLibraryInit();
    return &_mex_info;
}

_mex_information _mex_info
  = { 1, 6, function_table, 0, NULL, 0, NULL, 7, init_term_table };

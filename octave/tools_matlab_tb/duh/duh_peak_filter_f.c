/*
 * MATLAB Compiler: 3.0
 * Date: Mon May 17 15:14:06 2004
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-x" "-W" "mex" "-L" "C"
 * "-t" "-T" "link:mexlibrary" "libmatlbmx.mlib" "-h" "-A" "annotation:all"
 * "duh_peak_filter_f" 
 */
#include "duh_peak_filter_f.h"
#include "getfield.h"
#include "libmatlbm.h"
#include "setfield.h"
#include "sortiere_aufsteigend_f.h"
#include "std.h"
static mxArray * _mxarray0_;
static mxArray * _mxarray1_;

static mxChar _array3_[30] = { 'a', 'l', 'l', 'e', ' ', 'V', 'e', 'k',
                               't', 'o', 'r', 'e', 'n', ' ', 'w', 'e',
                               'r', 'd', 'e', 'n', ' ', 'g', 'e', 'f',
                               'i', 'l', 't', 'e', 'r', 't' };
static mxArray * _mxarray2_;

static mxChar _array5_[43] = { 'N', 'u', 'r', ' ', 'd', 'i', 'e', ' ', 'e',
                               'i', 'n', 'z', 'e', 'l', 'n', 'e', 'n', ' ',
                               'V', 'e', 'k', 't', 'o', 'r', 'e', 'n', ' ',
                               'w', 'e', 'r', 'd', 'e', 'n', ' ', 'g', 'e',
                               'f', 'i', 'l', 't', 'e', 'r', 't' };
static mxArray * _mxarray4_;
static mxArray * _mxarray6_;
static mxArray * _mxarray7_;

static mxChar _array9_[6] = { '%', 's', '(', '%', 'i', ')' };
static mxArray * _mxarray8_;

static mxChar _array11_[4] = { '(', '%', 'i', ')' };
static mxArray * _mxarray10_;
static mxArray * _mxarray12_;
static mxArray * _mxarray13_;
static mxArray * _mxarray14_;

void InitializeModule_duh_peak_filter_f(void) {
    _mxarray0_ = mclInitializeDouble(3.0);
    _mxarray1_ = mclInitializeDouble(1.0);
    _mxarray2_ = mclInitializeString(30, _array3_);
    _mxarray4_ = mclInitializeString(43, _array5_);
    _mxarray6_ = mclInitializeDoubleVector(0, 0, (double *)NULL);
    _mxarray7_ = mclInitializeDouble(0.0);
    _mxarray8_ = mclInitializeString(6, _array9_);
    _mxarray10_ = mclInitializeString(4, _array11_);
    _mxarray12_ = mclInitializeDouble(2.0);
    _mxarray13_ = mclInitializeDouble(.5);
    _mxarray14_ = mclInitializeCellVector(0, 0, (mxArray * *)NULL);
}

void TerminateModule_duh_peak_filter_f(void) {
    mxDestroyArray(_mxarray14_);
    mxDestroyArray(_mxarray13_);
    mxDestroyArray(_mxarray12_);
    mxDestroyArray(_mxarray10_);
    mxDestroyArray(_mxarray8_);
    mxDestroyArray(_mxarray7_);
    mxDestroyArray(_mxarray6_);
    mxDestroyArray(_mxarray4_);
    mxDestroyArray(_mxarray2_);
    mxDestroyArray(_mxarray1_);
    mxDestroyArray(_mxarray0_);
}

static mxArray * Mduh_peak_filter_f(mxArray * * c_comment,
                                    int nargout_,
                                    mxArray * d_in,
                                    mxArray * std_fac,
                                    mxArray * all);

_mexLocalFunctionTable _local_function_table_duh_peak_filter_f
  = { 0, (mexFunctionTableEntry *)NULL };

/*
 * The function "mlfDuh_peak_filter_f" contains the normal interface for the
 * "duh_peak_filter_f" M-function from file
 * "d:\berthold\projekte\matlab_duh\duh\duh_peak_filter_f.m" (lines 1-145).
 * This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
mxArray * mlfDuh_peak_filter_f(mxArray * * c_comment,
                               mxArray * d_in,
                               mxArray * std_fac,
                               mxArray * all) {
    int nargout = 1;
    mxArray * d = NULL;
    mxArray * c_comment__ = NULL;
    mlfEnterNewContext(1, 3, c_comment, d_in, std_fac, all);
    if (c_comment != NULL) {
        ++nargout;
    }
    d = Mduh_peak_filter_f(&c_comment__, nargout, d_in, std_fac, all);
    mlfRestorePreviousContext(1, 3, c_comment, d_in, std_fac, all);
    if (c_comment != NULL) {
        mclCopyOutputArg(c_comment, c_comment__);
    } else {
        mxDestroyArray(c_comment__);
    }
    return mlfReturnValue(d);
}

/*
 * The function "mlxDuh_peak_filter_f" contains the feval interface for the
 * "duh_peak_filter_f" M-function from file
 * "d:\berthold\projekte\matlab_duh\duh\duh_peak_filter_f.m" (lines 1-145). The
 * feval function calls the implementation version of duh_peak_filter_f through
 * this function. This function processes any input arguments and passes them
 * to the implementation version of the function, appearing above.
 */
void mlxDuh_peak_filter_f(int nlhs,
                          mxArray * plhs[],
                          int nrhs,
                          mxArray * prhs[]) {
    mxArray * mprhs[3];
    mxArray * mplhs[2];
    int i;
    if (nlhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: duh_peak_filter_f Line: 1 Colu"
            "mn: 1 The function \"duh_peak_filter_f\" was called "
            "with more than the declared number of outputs (2)."),
          NULL);
    }
    if (nrhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: duh_peak_filter_f Line: 1 Colu"
            "mn: 1 The function \"duh_peak_filter_f\" was called "
            "with more than the declared number of inputs (3)."),
          NULL);
    }
    for (i = 0; i < 2; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 3 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 3; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    mplhs[0]
      = Mduh_peak_filter_f(&mplhs[1], nlhs, mprhs[0], mprhs[1], mprhs[2]);
    mlfRestorePreviousContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 2 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 2; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}

/*
 * The function "Mduh_peak_filter_f" is the implementation version of the
 * "duh_peak_filter_f" M-function from file
 * "d:\berthold\projekte\matlab_duh\duh\duh_peak_filter_f.m" (lines 1-145). It
 * contains the actual compiled code for that M-function. It is a static
 * function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * function    [d,c_comment] = duh_peak_filter(d,std_fac,all)
 */
static mxArray * Mduh_peak_filter_f(mxArray * * c_comment,
                                    int nargout_,
                                    mxArray * d_in,
                                    mxArray * std_fac,
                                    mxArray * all) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(
          &_local_function_table_duh_peak_filter_f);
    int nargin_ = mclNargin(3, d_in, std_fac, all, NULL);
    mxArray * d = NULL;
    mxArray * index = NULL;
    mxArray * j = NULL;
    mxArray * ans = NULL;
    mxArray * thr = NULL;
    mxArray * dvec1 = NULL;
    mxArray * k = NULL;
    mxArray * idvec = NULL;
    mxArray * dvec = NULL;
    mxArray * vec = NULL;
    mxArray * i = NULL;
    mxArray * cindex = NULL;
    mxArray * kindex = NULL;
    mxArray * name_list = NULL;
    mxArray * index_list = NULL;
    mxArray * names = NULL;
    mclCopyInputArg(&d, d_in);
    mclCopyArray(&std_fac);
    mclCopyArray(&all);
    /*
     * 
     * % Sucht Peaks in Strukturliste von d, wenn Betrag der Differenz eines
     * % Vektors ausserhalb des Wertes std_fac * Standardabweichung liegt.
     * % Wenn all gesetzt werden alle Vektoren an dieser Stelle gebügelt,
     * % ansonsten nur der Vektor
     * % 
     * % d         Struktur mit Datenvektor (double)
     * % std_fac   (def=3.0) Faktor zur Festlegung des Bands
     * % all       (def=1) Flag ob all an einer gefunden peak-stelle gefiltert
     * %            werden
     * 
     * if( nargin < 2 )
     */
    if (nargin_ < 2) {
        /*
         * std_fac = 3;
         */
        mlfAssign(&std_fac, _mxarray0_);
    /*
     * else
     */
    } else {
        /*
         * std_fac = abs(std_fac);
         */
        mlfAssign(&std_fac, mlfAbs(mclVa(std_fac, "std_fac")));
    /*
     * end
     */
    }
    /*
     * if( nargin < 3 )
     */
    if (nargin_ < 3) {
        /*
         * all = 1;
         */
        mlfAssign(&all, _mxarray1_);
    /*
     * end
     */
    }
    /*
     * 
     * if( all )
     */
    if (mlfTobool(mclVa(all, "all"))) {
        /*
         * c_comment{1} = 'alle Vektoren werden gefiltert';
         */
        mlfIndexAssign(c_comment, "{?}", _mxarray1_, _mxarray2_);
    /*
     * else
     */
    } else {
        /*
         * c_comment{1} = 'Nur die einzelnen Vektoren werden gefiltert';
         */
        mlfIndexAssign(c_comment, "{?}", _mxarray1_, _mxarray4_);
    /*
     * end
     */
    }
    /*
     * 
     * names = fieldnames(d);
     */
    mlfAssign(&names, mlfFieldnames(mclVa(d, "d")));
    /*
     * 
     * index_list = [];
     */
    mlfAssign(&index_list, _mxarray6_);
    /*
     * name_list = [];
     */
    mlfAssign(&name_list, _mxarray6_);
    /*
     * kindex = 0;
     */
    mlfAssign(&kindex, _mxarray7_);
    /*
     * cindex = 1;
     */
    mlfAssign(&cindex, _mxarray1_);
    /*
     * 
     * %fprintf('len=%g\n',length(names));
     * for i=1:length(names)
     */
    {
        int v_ = mclForIntStart(1);
        int e_ = mclLengthInt(mclVv(names, "names"));
        if (v_ > e_) {
            mlfAssign(&i, _mxarray6_);
        } else {
            /*
             * 
             * %            fprintf('%g....\n',i);
             * vec = getfield(d,names{i});
             * 
             * dvec = diff(vec);
             * 
             * idvec = 0;
             * for k=1:length(dvec)
             * if( dvec(k) ~= 0 )
             * idvec = idvec+1;
             * dvec1(idvec) = dvec(k);
             * end
             * end
             * if( idvec == 0 )
             * dvec1(1) = 0;
             * end
             * 
             * 
             * thr = std(dvec1) * std_fac;
             * 
             * clear dvec1
             * 
             * for k=1:length(dvec)-1
             * 
             * if( (dvec(k) > thr & dvec(k+1) < -thr) ...
             * | (dvec(k) < -thr & dvec(k+1) > thr) ...
             * )
             * 
             * kindex = kindex + 1;
             * cindex = cindex + 1;
             * index_list(kindex) = k+1;
             * name_list(kindex) = i;
             * c_comment{cindex} = sprintf('%s(%i)',names{i},k+1);
             * end
             * end
             * 
             * if( (dvec(length(dvec)) > thr) | (dvec(length(dvec)) < -thr) )
             * 
             * kindex = kindex + 1;
             * cindex = cindex + 1;
             * index_list(kindex) = length(dvec)+1;
             * name_list(kindex) = i;
             * c_comment{cindex} = sprintf('%s(%i)',names{i},k+1);
             * end
             * end
             */
            for (; ; ) {
                mlfAssign(
                  &vec,
                  mlfGetfield(
                    mclVa(d, "d"),
                    mlfIndexRef(mclVv(names, "names"), "{?}", mlfScalar(v_)),
                    NULL));
                mlfAssign(&dvec, mlfDiff(mclVv(vec, "vec"), NULL, NULL));
                mlfAssign(&idvec, _mxarray7_);
                {
                    int v_0 = mclForIntStart(1);
                    int e_0 = mclLengthInt(mclVv(dvec, "dvec"));
                    if (v_0 > e_0) {
                        mlfAssign(&k, _mxarray6_);
                    } else {
                        for (; ; ) {
                            if (mclNeBool(
                                  mclIntArrayRef1(mclVv(dvec, "dvec"), v_0),
                                  _mxarray7_)) {
                                mlfAssign(
                                  &idvec,
                                  mclPlus(mclVv(idvec, "idvec"), _mxarray1_));
                                mclArrayAssign1(
                                  &dvec1,
                                  mclIntArrayRef1(mclVv(dvec, "dvec"), v_0),
                                  mclVv(idvec, "idvec"));
                            }
                            if (v_0 == e_0) {
                                break;
                            }
                            ++v_0;
                        }
                        mlfAssign(&k, mlfScalar(v_0));
                    }
                }
                if (mclEqBool(mclVv(idvec, "idvec"), _mxarray7_)) {
                    mclIntArrayAssign1(&dvec1, _mxarray7_, 1);
                }
                mlfAssign(
                  &thr,
                  mclMtimes(
                    mlfStd(mclVv(dvec1, "dvec1"), NULL, NULL),
                    mclVa(std_fac, "std_fac")));
                mlfClear(&dvec1, NULL);
                {
                    int v_1 = mclForIntStart(1);
                    int e_1 = mclLengthInt(mclVv(dvec, "dvec")) - 1;
                    if (v_1 > e_1) {
                        mlfAssign(&k, _mxarray6_);
                    } else {
                        for (; ; ) {
                            mxArray * a_
                              = mclInitialize(
                                  mclGt(
                                    mclIntArrayRef1(mclVv(dvec, "dvec"), v_1),
                                    mclVv(thr, "thr")));
                            if (mlfTobool(a_)) {
                                mlfAssign(
                                  &a_,
                                  mclAnd(
                                    a_,
                                    mclLt(
                                      mclIntArrayRef1(
                                        mclVv(dvec, "dvec"), v_1 + 1),
                                      mclUminus(mclVv(thr, "thr")))));
                            } else {
                                mlfAssign(&a_, mlfScalar(0));
                            }
                            if (mlfTobool(a_)) {
                            } else {
                                mxArray * b_
                                  = mclInitialize(
                                      mclLt(
                                        mclIntArrayRef1(
                                          mclVv(dvec, "dvec"), v_1),
                                        mclUminus(mclVv(thr, "thr"))));
                                if (mlfTobool(b_)) {
                                    mlfAssign(
                                      &b_,
                                      mclAnd(
                                        b_,
                                        mclGt(
                                          mclIntArrayRef1(
                                            mclVv(dvec, "dvec"), v_1 + 1),
                                          mclVv(thr, "thr"))));
                                } else {
                                    mlfAssign(&b_, mlfScalar(0));
                                }
                                {
                                    mxLogical c_0 = mlfTobool(mclOr(a_, b_));
                                    mxDestroyArray(b_);
                                    if (c_0) {
                                    } else {
                                        mxDestroyArray(a_);
                                        goto done_;
                                    }
                                }
                            }
                            mxDestroyArray(a_);
                            mlfAssign(
                              &kindex,
                              mclPlus(mclVv(kindex, "kindex"), _mxarray1_));
                            mlfAssign(
                              &cindex,
                              mclPlus(mclVv(cindex, "cindex"), _mxarray1_));
                            mclArrayAssign1(
                              &index_list,
                              mlfScalar(v_1 + 1),
                              mclVv(kindex, "kindex"));
                            mclArrayAssign1(
                              &name_list,
                              mlfScalar(v_),
                              mclVv(kindex, "kindex"));
                            mlfIndexAssign(
                              c_comment,
                              "{?}",
                              mclVv(cindex, "cindex"),
                              mlfSprintf(
                                NULL,
                                _mxarray8_,
                                mlfIndexRef(
                                  mclVv(names, "names"), "{?}", mlfScalar(v_)),
                                mlfScalar(v_1 + 1),
                                NULL));
                            done_:
                            if (v_1 == e_1) {
                                break;
                            }
                            ++v_1;
                        }
                        mlfAssign(&k, mlfScalar(v_1));
                    }
                }
                {
                    mxArray * a_
                      = mclInitialize(
                          mclGt(
                            mclIntArrayRef1(
                              mclVv(dvec, "dvec"),
                              mclLengthInt(mclVv(dvec, "dvec"))),
                            mclVv(thr, "thr")));
                    if (mlfTobool(a_)
                        || mlfTobool(
                             mclOr(
                               a_,
                               mclLt(
                                 mclIntArrayRef1(
                                   mclVv(dvec, "dvec"),
                                   mclLengthInt(mclVv(dvec, "dvec"))),
                                 mclUminus(mclVv(thr, "thr")))))) {
                        mxDestroyArray(a_);
                        mlfAssign(
                          &kindex,
                          mclPlus(mclVv(kindex, "kindex"), _mxarray1_));
                        mlfAssign(
                          &cindex,
                          mclPlus(mclVv(cindex, "cindex"), _mxarray1_));
                        mclArrayAssign1(
                          &index_list,
                          mlfScalar(mclLengthInt(mclVv(dvec, "dvec")) + 1),
                          mclVv(kindex, "kindex"));
                        mclArrayAssign1(
                          &name_list, mlfScalar(v_), mclVv(kindex, "kindex"));
                        mlfIndexAssign(
                          c_comment,
                          "{?}",
                          mclVv(cindex, "cindex"),
                          mlfSprintf(
                            NULL,
                            _mxarray8_,
                            mlfIndexRef(
                              mclVv(names, "names"), "{?}", mlfScalar(v_)),
                            mclPlus(mclVv(k, "k"), _mxarray1_),
                            NULL));
                    } else {
                        mxDestroyArray(a_);
                    }
                }
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&i, mlfScalar(v_));
        }
    }
    /*
     * 
     * 
     * if( all )
     */
    if (mlfTobool(mclVa(all, "all"))) {
        /*
         * 
         * if( length(index_list) > 0 )
         */
        if (mclLengthInt(mclVv(index_list, "index_list")) > 0) {
            /*
             * 
             * index_list = sortiere_aufsteigend_f(index_list);
             */
            mlfAssign(
              &index_list,
              mlfSortiere_aufsteigend_f(mclVv(index_list, "index_list")));
            /*
             * for i=1:length(index_list)
             */
            {
                int v_ = mclForIntStart(1);
                int e_ = mclLengthInt(mclVv(index_list, "index_list"));
                if (v_ > e_) {
                    mlfAssign(&i, _mxarray6_);
                } else {
                    /*
                     * cindex=cindex+1;
                     * c_comment{cindex} = sprintf('(%i)',index_list(i));
                     * end
                     */
                    for (; ; ) {
                        mlfAssign(
                          &cindex,
                          mclPlus(mclVv(cindex, "cindex"), _mxarray1_));
                        mlfIndexAssign(
                          c_comment,
                          "{?}",
                          mclVv(cindex, "cindex"),
                          mlfSprintf(
                            NULL,
                            _mxarray10_,
                            mclIntArrayRef1(
                              mclVv(index_list, "index_list"), v_),
                            NULL));
                        if (v_ == e_) {
                            break;
                        }
                        ++v_;
                    }
                    mlfAssign(&i, mlfScalar(v_));
                }
            }
            /*
             * 
             * %Eliminiere peaks für alle vektoren:
             * for i=1:length(names)
             */
            {
                int v_ = mclForIntStart(1);
                int e_ = mclLengthInt(mclVv(names, "names"));
                if (v_ > e_) {
                    mlfAssign(&i, _mxarray6_);
                } else {
                    /*
                     * 
                     * vec = getfield(d,names{i});
                     * 
                     * for j=1:length(index_list)
                     * 
                     * index = index_list(j);
                     * 
                     * if( index == 1 )
                     * 
                     * vec(index) = vec(index+1)*2-vec(index+2);
                     * 
                     * elseif( index == length(vec) )
                     * 
                     * vec(index) = vec(index-1)*2-vec(index-2);
                     * 
                     * elseif( index < length(vec) )    
                     * 
                     * vec(index) = (vec(index+1)+vec(index-1))*0.5;
                     * end
                     * end
                     * 
                     * d = setfield(d,names{i},vec);
                     * end
                     */
                    for (; ; ) {
                        mlfAssign(
                          &vec,
                          mlfGetfield(
                            mclVa(d, "d"),
                            mlfIndexRef(
                              mclVv(names, "names"), "{?}", mlfScalar(v_)),
                            NULL));
                        {
                            int v_2 = mclForIntStart(1);
                            int e_2
                              = mclLengthInt(mclVv(index_list, "index_list"));
                            if (v_2 > e_2) {
                                mlfAssign(&j, _mxarray6_);
                            } else {
                                for (; ; ) {
                                    mlfAssign(
                                      &index,
                                      mclIntArrayRef1(
                                        mclVv(index_list, "index_list"), v_2));
                                    if (mclEqBool(
                                          mclVv(index, "index"), _mxarray1_)) {
                                        mclArrayAssign1(
                                          &vec,
                                          mclMinus(
                                            mclMtimes(
                                              mclArrayRef1(
                                                mclVv(vec, "vec"),
                                                mclPlus(
                                                  mclVv(index, "index"),
                                                  _mxarray1_)),
                                              _mxarray12_),
                                            mclArrayRef1(
                                              mclVv(vec, "vec"),
                                              mclPlus(
                                                mclVv(index, "index"),
                                                _mxarray12_))),
                                          mclVv(index, "index"));
                                    } else if (mclEqBool(
                                                 mclVv(index, "index"),
                                                 mlfScalar(
                                                   mclLengthInt(
                                                     mclVv(vec, "vec"))))) {
                                        mclArrayAssign1(
                                          &vec,
                                          mclMinus(
                                            mclMtimes(
                                              mclArrayRef1(
                                                mclVv(vec, "vec"),
                                                mclMinus(
                                                  mclVv(index, "index"),
                                                  _mxarray1_)),
                                              _mxarray12_),
                                            mclArrayRef1(
                                              mclVv(vec, "vec"),
                                              mclMinus(
                                                mclVv(index, "index"),
                                                _mxarray12_))),
                                          mclVv(index, "index"));
                                    } else if (mclLtBool(
                                                 mclVv(index, "index"),
                                                 mlfScalar(
                                                   mclLengthInt(
                                                     mclVv(vec, "vec"))))) {
                                        mclArrayAssign1(
                                          &vec,
                                          mclMtimes(
                                            mclPlus(
                                              mclArrayRef1(
                                                mclVv(vec, "vec"),
                                                mclPlus(
                                                  mclVv(index, "index"),
                                                  _mxarray1_)),
                                              mclArrayRef1(
                                                mclVv(vec, "vec"),
                                                mclMinus(
                                                  mclVv(index, "index"),
                                                  _mxarray1_))),
                                            _mxarray13_),
                                          mclVv(index, "index"));
                                    }
                                    if (v_2 == e_2) {
                                        break;
                                    }
                                    ++v_2;
                                }
                                mlfAssign(&j, mlfScalar(v_2));
                            }
                        }
                        mlfAssign(
                          &d,
                          mlfSetfield(
                            mclVa(d, "d"),
                            mlfIndexRef(
                              mclVv(names, "names"), "{?}", mlfScalar(v_)),
                            mclVv(vec, "vec"),
                            NULL));
                        if (v_ == e_) {
                            break;
                        }
                        ++v_;
                    }
                    mlfAssign(&i, mlfScalar(v_));
                }
            }
        /*
         * end
         */
        }
    /*
     * else
     */
    } else {
        /*
         * for i=1:length(index_list)
         */
        int v_ = mclForIntStart(1);
        int e_ = mclLengthInt(mclVv(index_list, "index_list"));
        if (v_ > e_) {
            mlfAssign(&i, _mxarray6_);
        } else {
            /*
             * 
             * vec = getfield(d,names{name_list(i)});
             * index = index_list(i);
             * 
             * if( index == 1 )
             * 
             * vec(index) = vec(index+1)*2-vec(index+2);
             * 
             * elseif( index == length(vec) )
             * 
             * vec(index) = vec(index-1)*2-vec(index-2);
             * 
             * elseif( index < length(vec) )    
             * 
             * vec(index) = (vec(index+1)+vec(index-1))*0.5;
             * end
             * d = setfield(d,names{name_list(i)},vec);
             * end        
             */
            for (; ; ) {
                mlfAssign(
                  &vec,
                  mlfGetfield(
                    mclVa(d, "d"),
                    mlfIndexRef(
                      mclVv(names, "names"),
                      "{?}",
                      mclIntArrayRef1(mclVv(name_list, "name_list"), v_)),
                    NULL));
                mlfAssign(
                  &index, mclIntArrayRef1(mclVv(index_list, "index_list"), v_));
                if (mclEqBool(mclVv(index, "index"), _mxarray1_)) {
                    mclArrayAssign1(
                      &vec,
                      mclMinus(
                        mclMtimes(
                          mclArrayRef1(
                            mclVv(vec, "vec"),
                            mclPlus(mclVv(index, "index"), _mxarray1_)),
                          _mxarray12_),
                        mclArrayRef1(
                          mclVv(vec, "vec"),
                          mclPlus(mclVv(index, "index"), _mxarray12_))),
                      mclVv(index, "index"));
                } else if (mclEqBool(
                             mclVv(index, "index"),
                             mlfScalar(mclLengthInt(mclVv(vec, "vec"))))) {
                    mclArrayAssign1(
                      &vec,
                      mclMinus(
                        mclMtimes(
                          mclArrayRef1(
                            mclVv(vec, "vec"),
                            mclMinus(mclVv(index, "index"), _mxarray1_)),
                          _mxarray12_),
                        mclArrayRef1(
                          mclVv(vec, "vec"),
                          mclMinus(mclVv(index, "index"), _mxarray12_))),
                      mclVv(index, "index"));
                } else if (mclLtBool(
                             mclVv(index, "index"),
                             mlfScalar(mclLengthInt(mclVv(vec, "vec"))))) {
                    mclArrayAssign1(
                      &vec,
                      mclMtimes(
                        mclPlus(
                          mclArrayRef1(
                            mclVv(vec, "vec"),
                            mclPlus(mclVv(index, "index"), _mxarray1_)),
                          mclArrayRef1(
                            mclVv(vec, "vec"),
                            mclMinus(mclVv(index, "index"), _mxarray1_))),
                        _mxarray13_),
                      mclVv(index, "index"));
                }
                mlfAssign(
                  &d,
                  mlfSetfield(
                    mclVa(d, "d"),
                    mlfIndexRef(
                      mclVv(names, "names"),
                      "{?}",
                      mclIntArrayRef1(mclVv(name_list, "name_list"), v_)),
                    mclVv(vec, "vec"),
                    NULL));
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&i, mlfScalar(v_));
        }
    /*
     * end
     */
    }
    /*
     * 
     * if( length(c_comment) == 1 )
     */
    if (mclLengthInt(mclVv(*c_comment, "c_comment")) == 1) {
        /*
         * 
         * c_comment = {};
         */
        mlfAssign(c_comment, _mxarray14_);
    /*
     * end
     */
    }
    mclValidateOutput(d, 1, nargout_, "d", "duh_peak_filter_f");
    mclValidateOutput(
      *c_comment, 2, nargout_, "c_comment", "duh_peak_filter_f");
    mxDestroyArray(names);
    mxDestroyArray(index_list);
    mxDestroyArray(name_list);
    mxDestroyArray(kindex);
    mxDestroyArray(cindex);
    mxDestroyArray(i);
    mxDestroyArray(vec);
    mxDestroyArray(dvec);
    mxDestroyArray(idvec);
    mxDestroyArray(k);
    mxDestroyArray(dvec1);
    mxDestroyArray(thr);
    mxDestroyArray(ans);
    mxDestroyArray(j);
    mxDestroyArray(index);
    mxDestroyArray(all);
    mxDestroyArray(std_fac);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return d;
}

//--------------------------------------------------------------
// file: mexEinspurmodell.cpp - Matlab Mex function application
//--------------------------------------------------------------
/*##FUNCTION_CODE_NAMEXYZ_START##*/
/*##FUNCTION_CODE_NAMEXYZ_END##*/
#include "mex.h"

#include "sim_TIME_STEP_SIM.h"

//===============================================================
//===============================================================
// Name mex-Funktion
//===============================================================
//===============================================================
#define MEX_FUNCTION_NAME       "#PROJECT_NAME#"

bool mex_TIME_STEP_input_struct(const mxArray * ppar,std::vector<SSimIO> &simIO,size_t nVarNames);
//bool mex_SIM_MOD_par_struct(const mxArray * ppar);
mxArray *mex_TIME_STEP_output_struct(void);
void FillVectorByClass(mxArray *parray,std::vector<double> &vec);
//===============================================================
//===============================================================
//--------------------------------------------------------------
// mexFunction - Entry point from Matlab. From this C function,
//   simply call the C++ application function, above.
//--------------------------------------------------------------
//===============================================================
//===============================================================
void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray  *prhs[] )
{
  int             irhs;
  char            errtext[255];
  size_t          lerrtext = 254;
  bool            flag;
  //size_t          i;
  errtext[0]      = '\0';
  //mexPrintf("mexFunction: <%s>\n\n",MEX_FUNCTION_NAME);



  // keine PArameter
  if( nrhs == 0 )
  {
    mexPrintf("sout = %s(type,sin,p);\n",MEX_FUNCTION_NAME);
    mexPrintf("  type                   int         type=0,1,2: init/loop/done\n");
    mexPrintf("  sin                    struct      s-Struktur für die Eingabevektoren + sin.dt (init) \n");
    mexPrintf("  sout                   struct      s-Struktur für die Ausgabevektoren\n");
    mexPrintf("  p                      struct      p-Struktur für die Eingabevektoren für Parameter\n");

    if( nlhs > 0 )
    {
      mwSize dims[2];
      dims[0] = 0;
      dims[1] = 0;
      plhs[0] = mxCreateStructArray(2,dims,0,NULL);
    }

    return;
  }


  // 1. Parameter s-Struktur lesen
  //==============================
  irhs = 0;
  if( mxIsEmpty(prhs[irhs]) )  /* typ ist nicht leer */
  {
    sprintf_s(errtext,lerrtext,"Error_%s: Erster Parameter type = (0/1/2:init/loop/done) nicht vorhanden",MEX_FUNCTION_NAME);
    mexErrMsgTxt(errtext);	
    return;
  }
  else
  {
    if( mxIsDouble(prhs[irhs]) )  /* typ übergeben */
    {
      double *pdval = mxGetPr(prhs[irhs]);
      SimMod.type = (char)(*pdval);

    }
    else
    {
      sprintf_s(errtext,lerrtext,"Error_%s: Erster Parameter type = (0/1/2:init/loop/done) nicht vorhanden",MEX_FUNCTION_NAME);
      mexErrMsgTxt(errtext);	
      return;
    }
  }
  //SimMod.tstart    = SimInpTime.ptime[0];
  //SimMod.tend      = SimInpTime.ptime[SimInpTime.ntime-1];
  irhs = irhs+1;
  flag = false;
  if( (nrhs > irhs) )
  { 
      if( mxIsStruct(prhs[irhs]) )  /* inp-Struktur übergeben */
      {
        mex_TIME_STEP_input_struct(prhs[irhs],SimInp,SIM_TIME_STEP_SIM_N_INP);
      }
      else if( SIM_TIME_STEP_SIM_N_INP && (SimMod.type == SIM_TIME_STEP_TYPE_LOOP) )
      {
        flag = true;
      }
  }
  else
  {
    flag = true;
  }
  if (flag)
  {
    sprintf_s(errtext,lerrtext,"Error_%s: Erster Parameter ist keine Struktur sin (struct)",MEX_FUNCTION_NAME);
    mexErrMsgTxt(errtext);	
    return;
  }

  // 2. Parameter typ einlesen
  //==============================
  irhs = irhs+1;
  if( (nrhs > irhs) )
  { 
    if( !mxIsEmpty(prhs[irhs]) )  /* p-Struktur ist nicht leer */
    {
      if( mxIsStruct(prhs[irhs]) )  /* e-Struktur übergeben */
      {
        mex_TIME_STEP_input_struct(prhs[irhs],SimPar,SIM_TIME_STEP_SIM_N_PAR);
      }
    }
  }

  // nach type
  //============================================
  if(  SimMod.type == 0 )
  {
    if( !sim_TIME_STEP_init(errtext,lerrtext) )
	{
		mexErrMsgTxt(errtext);
	}
  }
  else if( SimMod.type == 1 )
  {
    if( !sim_TIME_STEP_loop(errtext,lerrtext) )
	{
		mexErrMsgTxt(errtext);
	}
  }
  else
  {
    if( !sim_TIME_STEP_done(errtext,lerrtext) )
	{
		mexErrMsgTxt(errtext);
	}
  }


}
bool mex_TIME_STEP_input_struct(const mxArray * ppar,std::vector<SSimIO> &simIO,size_t nVarNames)
{
  int         nfields,ifield;
  int         nfields2,ifield2;
  mxArray     *pstruct, *parray;
  std::string fieldname,fieldname2;
  mwSize      nelems2;
  size_t      isig;
  bool        flag;

  try
  {

    nfields = mxGetNumberOfFields(ppar);

    for(ifield=0; ifield<nfields; ifield++)
    {
      fieldname = mxGetFieldNameByNumber(ppar,ifield);
      pstruct   = mxGetFieldByNumber(ppar, 0, ifield);

      if(pstruct == NULL)
      {		
        mexPrintf("Error_%s: %s%d\t%s%d\n", "FIELD: ",MEX_FUNCTION_NAME, ifield+1, "STRUCT INDEX :", 1);
        mexErrMsgTxt("Above field is empty!");
      }

      if( mxIsStruct(pstruct) )  /* Unterstruktur */
      {
        flag = false;
        for( isig=0;isig<nVarNames;isig++)
        {
          if( fieldname.compare(simIO[isig].vecname) == 0 )
          {
            flag = true;
            break;
          }
        }
        if( flag )
        {
          nfields2 = mxGetNumberOfFields(pstruct);
          nelems2  = mxGetNumberOfElements(pstruct);


          for(ifield2 = 0; ifield2 < nfields2; ifield2++)
          {
            fieldname2 = mxGetFieldNameByNumber(pstruct,ifield2);
            parray     = mxGetFieldByNumber(pstruct, 0, ifield2);

            if(parray == NULL)
            {		
              mexPrintf("Error_%s: %s%d\t%s%d\n", "FIELD: ",MEX_FUNCTION_NAME, ifield2+1, "STRUCT INDEX :", 1);
              mexErrMsgTxt("Above field is empty!");
            }
            if( (fieldname2.compare("time") == 0) && mxIsNumeric(parray) )  /* ein einfacher Vektor Zeit */
            {
              if( mxIsDouble(parray) )
              {
                double *pdval = mxGetPr(parray);
                size_t i,n   = mxGetM(parray) * mxGetN(parray);
                for(i=0;i<n;++i)
                {
                  simIO[isig].time.push_back(pdval[i]);
                }
              }
              else if( mxIsSingle(parray) )
              {
                float *pfval = (float *)mxGetPr(parray);
                size_t i,n   = mxGetM(parray) * mxGetN(parray);
                for(i=0;i<n;++i)
                {
                  simIO[isig].time.push_back((double)pfval[i]);
                }
              }
              else
              {
                mexPrintf("Error_%s: ClassID: <%i> \n", MEX_FUNCTION_NAME,mxGetClassID(parray));
                mexErrMsgTxt("type input time is not double or single");
              }
            }
            else if( (fieldname2.compare("vec") == 0) )
            {
              if( mxIsNumeric(parray) ) /* ein einfacher Vektor */
              {		
                simIO[isig].isvecofvec = 0;
                simIO[isig].isstring   = 0;
                simIO[isig].found      = true;

                FillVectorByClass(parray,simIO[isig].vec);

                if( simIO[isig].vec.size() == 0 )
                {
                  mexPrintf("Error_%s: e.%s.vec hat die null Elemente\n",MEX_FUNCTION_NAME, fieldname.c_str());
                  mexErrMsgTxt("Above field must have not numeric data.");
                }
              }
              else if( mxIsCell(parray) ) /* cell array mit Vektor of Vektor */
              {
                mwIndex ind;
                mxArray  *pnum;
                mwSize ncells = mxGetNumberOfElements(parray);

                simIO[isig].isvecofvec = 1;
                simIO[isig].isstring   = 0;
                simIO[isig].found      = true;

                for (ind=0; ind<ncells; ind++)
                {

                  pnum = mxGetCell(parray, ind);
                  if( pnum == NULL )
                  {
                    std::vector<double> vec;
                    simIO[isig].vecvec.push_back(vec);
                    simIO[isig].nvecvec.push_back(0);
                  }
                  else if( mxIsNumeric(pnum) ) /* numericher Vektor */
                  {
                    std::vector<double> vec;
                    FillVectorByClass(pnum,vec);
                    simIO[isig].vecvec.push_back(vec);
                    simIO[isig].nvecvec.push_back( vec.size() );
                  }
                  else if( mxIsChar(pnum) ) /* String Vektor */
                  {
                    char *tt = (char *)malloc(sizeof(char)*(mxGetM(pnum) * mxGetN(pnum)+1));

                    mxGetString(pnum,tt,(mxGetM(pnum) * mxGetN(pnum)+1));
                    std::string s = tt;
                    free(tt);

                    simIO[isig].isstring   = 1;

                    simIO[isig].vecstring.push_back(s);
                    simIO[isig].nvecvec.push_back( s.size() );
                  }
                  else
                  {
                    mexPrintf("Error_%s: d.%s(%i) ist kein numerischer Wert\n", MEX_FUNCTION_NAME, fieldname.c_str(), ind);
                    mexErrMsgTxt("Above field must have not numeric data.");
                  }
                }
              }
              else
              {
                mexPrintf("Error_%s: parray ist kein numerischer,string bzw. Cell-Wert\n", MEX_FUNCTION_NAME);
                mexErrMsgTxt("parray !!!");
              }
            }
          }
          /* Überprüfen */
          if( simIO[isig].isstring ) /* cellarray mit strings */
          {
            simIO[isig].n = SIM_TIME_STEP_MIN(simIO[isig].time.size(),simIO[isig].vecstring.size());
          }
          else if( simIO[isig].isvecofvec ) /* cellarray */
          {
            simIO[isig].n = SIM_TIME_STEP_MIN(simIO[isig].time.size(),simIO[isig].vecvec.size());
          }
          else /* vector */
          {
            simIO[isig].n = SIM_TIME_STEP_MIN(simIO[isig].time.size(),simIO[isig].vec.size());
          }
        }
      }
    }
  }
  catch(...)
  {
    char a;
    a = 0;
    mexErrMsgTxt("Absturz simIO einlesen!!!");
  }
  return true;
}
mxArray *mex_TIME_STEP_output_struct(void)
{
  mxArray    *pout = NULL;
  mwSize     dims[2];
  const char *p_struct_name_liste[] = {"time","vec","unit","comment"};
#define MEX_OUTPUT_STRUCT_NUMBER_OF_FIELDS  4
  size_t     i,j,k;
  mxArray    *pstruct;
  mwSize     buflen;
  char       *p_unit;
  mxArray    *field;
  double     *pd;

  //=============================
  // Matlab-Datenstruktur anlegen
  //=============================
  dims[0] = 1;
  dims[1] = 1;
  pout    = mxCreateStructArray(2,dims,(int)SIM_TIME_STEP_SIM_N_OUT,(const char **)pSimOutVarNames);

  //=============================
  // Matlab-Unterstruktur anlegen
  //=============================
  for(i=0;i<SIM_TIME_STEP_SIM_N_OUT;i++)
  {
    dims[0] = 1;
    dims[1] = 1;
    pstruct = mxCreateStructArray(2,dims,MEX_OUTPUT_STRUCT_NUMBER_OF_FIELDS,&p_struct_name_liste[0]);

    /* Vektorlänge */
    dims[0] = SimOut[i].time.size();
    dims[1] = 1;

    /* Zeitvektor */
    field   = mxCreateNumericArray(2,dims, mxDOUBLE_CLASS,mxREAL);
    pd      = mxGetPr(field);
    for(j=0;j<SimOut[i].time.size();j++) *(pd+j) = SimOut[i].time[j];
    mxSetFieldByNumber(pstruct,0,0,field);

    /* Wertevektoren */
    if( SimOut[i].isvecofvec ) /* cell array mit Vektoren bilden */
    {
      mxArray    *field1;
      field = mxCreateCellMatrix(1,(mwSize)SimOut[i].time.size());
      for(j=0;j<SimOut[i].time.size();j++)
      {

        std::vector<double> vec = SimOut[i].vecvec[j];
        dims[0]  = vec.size();
        dims[1]  = 1;
        field1   = mxCreateNumericArray(2,dims, mxDOUBLE_CLASS,mxREAL);
        pd       = mxGetPr(field1);

        for(k=0;k<vec.size();k++) *(pd+k) = vec[k];

        mxSetCell(field,j,field1);

      }
      mxSetFieldByNumber(pstruct,0,1,field);
    }
    else /* Vektor */
    {
      field   = mxCreateNumericArray(2,dims, mxDOUBLE_CLASS,mxREAL);
      pd      = mxGetPr(field);
      for(j=0;j<SimOut[i].time.size();j++) *(pd+j) = SimOut[i].vec[j];
      mxSetFieldByNumber(pstruct,0,1,field);
    }

    /* Unit */
    buflen = strlen(pSimOutUnitNames[i])+1;
    p_unit = (char *)mxCalloc(buflen, sizeof(char));
    strcpy(p_unit,pSimOutUnitNames[i]);
    field = mxCreateString(p_unit);
    mxSetFieldByNumber(pstruct,0,2,field);

    /* Comment */
    buflen = SimOut[i].comment.size()+1;
    p_unit = (char *)mxCalloc(buflen, sizeof(char));
    strcpy(p_unit,SimOut[i].comment.c_str());
    field = mxCreateString(p_unit);
    mxSetFieldByNumber(pstruct,0,3,field);

    /* pstruct an pout hängen */
    mxSetFieldByNumber(pout,0,i,pstruct);

  }
  return pout;
}
void FillVectorByClass(mxArray *parray,std::vector<double> &vec)
{

  if( mxIsDouble(parray) )
  {
    double *pdval = mxGetPr(parray);
    size_t i,n   = mxGetM(parray) * mxGetN(parray);
    for(i=0;i<n;++i)
    {
      vec.push_back(pdval[i]);
    }
  }
  else if( mxIsSingle(parray) )
  {
    float *pfval = (float *)mxGetPr(parray);
    size_t i,n   = mxGetM(parray) * mxGetN(parray);
    for(i=0;i<n;++i)
    {
      vec.push_back((double)pfval[i]);
    }
  }
  else if( mxIsUint8(parray) )
  {
    unsigned char *pui8val = (unsigned char *)mxGetPr(parray);
    size_t i,n   = mxGetM(parray) * mxGetN(parray);
    for(i=0;i<n;++i)
    {
      vec.push_back((double)pui8val[i]);
    }
  }
  else if( mxIsUint32(parray) )
  {
    unsigned int *pui32val = (unsigned int *)mxGetPr(parray);
    size_t i,n   = mxGetM(parray) * mxGetN(parray);
    for(i=0;i<n;++i)
    {
      vec.push_back((double)pui32val[i]);
    }
  }
  else if( mxIsInt32(parray) )
  {
    signed int *pi32val = (signed int *)mxGetPr(parray);
    size_t i,n   = mxGetM(parray) * mxGetN(parray);
    for(i=0;i<n;++i)
    {
      vec.push_back((double)pi32val[i]);
    }
  }
  else if( mxIsInt64(parray) )
  {
    __int64 *pi64val = (__int64 *)mxGetPr(parray);
    size_t i,n   = mxGetM(parray) * mxGetN(parray);
    for(i=0;i<n;++i)
    {
      vec.push_back((double)pi64val[i]);
    }
  }
  else
  {
    mexPrintf("Error_%s: ClassID: <%i> \n", MEX_FUNCTION_NAME,mxGetClassID(parray));
    mexErrMsgTxt("type input vec is not double or single");
  }
}

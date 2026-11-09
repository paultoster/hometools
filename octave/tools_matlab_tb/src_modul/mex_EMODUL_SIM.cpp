//--------------------------------------------------------------
// file: mexEinspurmodell.cpp - Matlab Mex function application
//--------------------------------------------------------------
/*##FUNCTION_CODE_NAMEXYZ_START##*/
/*##FUNCTION_CODE_NAMEXYZ_END##*/
#include "mex.h"
#define SLF_BASIC_UINT32_T_DEFINED
#include "sim_EMODUL_SIM.h"

//===============================================================
//===============================================================
// Name mex-Funktion
//===============================================================
//===============================================================
#define MEX_FUNCTION_NAME       "#PROJECT_NAME#"

std::string MessAcsCanFile = "";      // Ascii-Filename mit Messung
std::vector<size_t> ListeCANID;       // Vektor mit Identifier, die benutzt werden sollen
std::vector<unsigned char> ListeCANCHAN; // Vektor mit den dazugehörigen Channels

bool mex_SIM_MOD_input_struct(const mxArray * ppar,std::vector<SSimIO> &simIO,size_t nVarNames);
//bool mex_SIM_MOD_par_struct(const mxArray * ppar);
mxArray *mex_SIM_MOD_output_struct(void);
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
  size_t          i;
  errtext[0]      = '\0';
  //mexPrintf("mexFunction: <%s>\n\n",MEX_FUNCTION_NAME);


  // Initialisieren:
  SimMod.tstart = 0.0;                          /* Startzeit, entweder null oder durch Odometrie-Trajektorienabgleich */
  SimMod.tend   = 0.0;                          /* Endzeit                     */
  SimMod.dtloop = 0.0;                          /* loop time Function          */
  SimMod.dtout  = 0.0;                          /* output loop time            */
  SimMod.ParamNames.clear();                    /* Parameternamen aus mex-Eingabe */
  SimMod.ParamValues.clear();                   /* Parameterwerte (numerisch) aus mex-Eingabe */

  for(i=0;i<SIM_EMODUL_SIM_N_INP;i++)
  {
    SimInp[i].found      = false;
    SimInp[i].time.clear();
    SimInp[i].vec.clear();
    SimInp[i].vecvec.clear();
    SimInp[i].vecstring.clear();
    SimInp[i].nvecvec.clear();
    SimInp[i].n          = 0;
    SimInp[i].iAct       = 0;
    SimInp[i].isvecofvec = 0;
    SimInp[i].isstring   = 0;
    SimInp[i].vecname    = pSimInpVarNames[i];
  }
  for(i=0;i<SIM_EMODUL_SIM_N_PAR;i++)
  {
    SimPar[i].found      = false;
    SimPar[i].time.clear();
    SimPar[i].vec.clear();
    SimPar[i].vecvec.clear();
    SimPar[i].nvecvec.clear();
    SimPar[i].n          = 0;
    SimPar[i].iAct       = 0;
    SimPar[i].isvecofvec = 0;
    SimPar[i].vecname    = pSimParVarNames[i];
  }
  for(i=0;i<SIM_EMODUL_SIM_N_OUT;i++)
  {
    SimOut[i].found = false;
    SimOut[i].time.clear();
    SimOut[i].vec.clear();
    SimOut[i].vecvec.clear();
    SimOut[i].nvecvec.clear();
    SimOut[i].n          = 0;
    SimOut[i].iAct       = 0;
    SimOut[i].isvecofvec = 0;
    SimOut[i].vecname    = pSimOutVarNames[i];
  }
	
	// keine PArameter
  if( nrhs == 0 )
  {
    mexPrintf("e = %s(e,p,qparamstruct]);\n",MEX_FUNCTION_NAME);
    mexPrintf("  e                      struct      e-Struktur für die Eingabevektoren\n");
    mexPrintf("  p                      struct      p-Struktur für die Eingabevektoren für Parameter\n");
    mexPrintf("  qparamstruct            .name = value  Struktur mit Parameternamen und numerischer Wert\n");

    if( nlhs > 0 )
    {
      mwSize dims[2];
      dims[0] = 0;
      dims[1] = 0;
      plhs[0] = mxCreateStructArray(2,dims,0,NULL);
    }

    return;
  }


  // 1. Parameter e-Struktur lesen
  //==============================
	irhs = 0;
  if( mxIsStruct(prhs[irhs]) )  /* e-Struktur übergeben */
  {
    mex_SIM_MOD_input_struct(prhs[irhs],SimInp,SIM_EMODUL_SIM_N_INP);
  }
  //SimMod.tstart    = SimInpTime.ptime[0];
  //SimMod.tend      = SimInpTime.ptime[SimInpTime.ntime-1];
  else
  {
		sprintf_s(errtext,lerrtext,"Error_%s: Erster Parameter ist keine Struktur e (struct)",MEX_FUNCTION_NAME);
    mexErrMsgTxt(errtext);	
    return;
  }

  // 2. Parameter p-Struktur lesen
  //==============================
	irhs = irhs+1;
  if( !mxIsEmpty(prhs[irhs]) )  /* p-Struktur ist nicht leer */
  {
    if( mxIsStruct(prhs[irhs]) )  /* e-Struktur übergeben */
    {
      mex_SIM_MOD_input_struct(prhs[irhs],SimPar,SIM_EMODUL_SIM_N_PAR);

    }
    else
    {
	    sprintf_s(errtext,lerrtext,"Error_%s: Zweiter Parameter ist keine Struktur p (struct)",MEX_FUNCTION_NAME);
      mexErrMsgTxt(errtext);	
      return;
    }
  }
  // 3. q-Parameterstrukturdaten
  //==================================================
  irhs = irhs+1;
  if( nrhs > irhs )
  {
    if( !mxIsStruct(prhs[irhs]) )
    {
  		sprintf_s(errtext,lerrtext,"Error_%s: Zweiter Parameter ist keine Parameter-struct (struct)",MEX_FUNCTION_NAME);
	  	mexErrMsgTxt(errtext);
      return;
    }
    else
    {
      int nfields = mxGetNumberOfFields(prhs[irhs]);
      int ifield;
      mxArray  *parray;
      const char *fieldname;
	    double   *pd,dval;

      // Schleife über alle Strukturelemente
      //====================================
      for( ifield=0;ifield<nfields;ifield++)
      {
      parray = mxGetFieldByNumber(prhs[irhs], 0, ifield);
        fieldname = mxGetFieldNameByNumber(prhs[irhs],ifield);


        if( mxIsDouble(parray) )
      {		
          pd = mxGetPr(parray);
          dval = *pd;
          SimMod.ParamValues.push_back(dval);
        }
        else if( mxIsSingle(parray) )
        {
          float *pfval = (float *) mxGetData(parray);
          SimMod.ParamValues.push_back(*pfval);
      }
        else
        {
          sprintf_s(errtext,lerrtext,"Error_%s: Parameterdtruktur enthaelt non numeric (double,single) Werte",MEX_FUNCTION_NAME);
          mexErrMsgTxt(errtext);
          return;
        }
        SimMod.ParamNames.push_back(fieldname);
      }
    }
  }

	// Parameter an SIM_MOD_SIM übergeben
	//============================================
	if( sim_EMODUL_SIM_init(errtext,lerrtext) !=  OKAY )
  {
    mexErrMsgTxt(errtext);
  }


	// Simulation aufrufen
	//====================
	if( sim_EMODUL_SIM(errtext,lerrtext) != OKAY )
          {
    mexErrMsgTxt(errtext);
          }

  // Ausgabe erstellen
  //==================
  if( SIM_EMODUL_SIM_N_OUT && nlhs > 0) plhs[0] = mex_SIM_MOD_output_struct();

}
bool mex_SIM_MOD_input_struct(const mxArray * ppar,std::vector<SSimIO> &simIO,size_t nVarNames)
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
            simIO[isig].n = SIM_EMODUL_MIN(simIO[isig].time.size(),simIO[isig].vecstring.size());
          }
          else if( simIO[isig].isvecofvec ) /* cellarray */
          {
            simIO[isig].n = SIM_EMODUL_MIN(simIO[isig].time.size(),simIO[isig].vecvec.size());
          }
          else /* vector */
          {
            simIO[isig].n = SIM_EMODUL_MIN(simIO[isig].time.size(),simIO[isig].vec.size());
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
//bool mex_SIM_MOD_par_struct(const mxArray * ppar)
//{
//  int      nfields,ifield;
//  int         nfields2,ifield2;
//  mxArray     *pstruct, *parray;
//  std::string fieldname,fieldname2;
//  mwSize      nelems2;
//  size_t      i;
//  bool       flag;
//
//  nfields = mxGetNumberOfFields(ppar);
//
//  for(ifield=0; ifield<nfields; ifield++)
//  {
//    fieldname = mxGetFieldNameByNumber(ppar,ifield);
//    pstruct   = mxGetFieldByNumber(ppar, 0, ifield);
//
//    if(pstruct == NULL)
//    {		
//      mexPrintf("Error_%s: %s%d\t%s%d\n", "FIELD: ",MEX_FUNCTION_NAME, ifield+1, "STRUCT INDEX :", 1);
//      mexErrMsgTxt("Above field is empty!");
//    }
//
//    if( mxIsStruct(pstruct) )  /* Unterstruktur */
//    {
//      flag = false;
//      for( i=0;i<SIM_EMODUL_SIM_N_PAR;i++)
//      {
//        if( fieldname.compare(pSimParVarNames[i]) == 0 )
//        {
//          flag = true;
//          break;
//        }
//      }
//      if( flag )
//      {
//        nfields2 = mxGetNumberOfFields(pstruct);
//        nelems2  = mxGetNumberOfElements(pstruct);
//
//        for(ifield2 = 0; ifield2 < nfields2; ifield2++)
//        {
//          fieldname2 = mxGetFieldNameByNumber(pstruct,ifield2);
//          parray     = mxGetFieldByNumber(pstruct, 0, ifield2);
//
//          if(parray == NULL)
//          {		
//            mexPrintf("Error_%s: %s%d\t%s%d\n", "FIELD: ",MEX_FUNCTION_NAME, ifield2+1, "STRUCT INDEX :", 1);
//            mexErrMsgTxt("Above field is empty!");
//          }
//          if( (fieldname2.compare("time") == 0) && mxIsNumeric(parray) )  /* ein einfacher Vektor Zeit */
//          {
//            SimPar[i].ptime = mxGetPr(parray);
//            SimPar[i].ntime = mxGetM(parray) * mxGetN(parray);
//          }
//          else if( (fieldname2.compare("vec") == 0) )
//          {
//            if( mxIsNumeric(parray) ) /* ein einfacher Vektor */
//            {
//              SimPar[i].isvecofvec = 0;
//              SimPar[i].found      = true;
//              SimPar[i].ncells     = 1;
//
//              SimPar[i].pvec.push_back(mxGetPr(parray));
//              SimPar[i].nvec.push_back(mxGetM(parray) * mxGetN(parray));
//
//              if( SimPar[i].nvec[0] == 0 )
//              {
//                mexPrintf("Error_%s: e.%s.vec hat die null Elemente\n",MEX_FUNCTION_NAME, fieldname.c_str());
//                mexErrMsgTxt("Above field must have not numeric data.");
//              }
//            }
//            else /* cell array mit Vektor of Vektor */
//            {
//              mwIndex ind;
//              mxArray  *pnum;
//              mwSize ncells = mxGetNumberOfElements(parray);
//
//              SimPar[i].isvecofvec = 1;
//              SimPar[i].ncells     = ncells;
//              SimPar[i].found      = true;
//
//              for (ind=0; ind<ncells; ind++)
//              {
//                pnum = mxGetCell(parray, ind);
//                if( pnum == NULL )
//                {
//                  SimPar[i].pvec.push_back(NULL);
//                  SimPar[i].nvec.push_back( 0 );
//                }
//                else if( mxIsNumeric(pnum) ) /* numericher Vektor */
//                {
//                  SimPar[i].pvec.push_back(mxGetPr(pnum));
//                  SimPar[i].nvec.push_back( mxGetM(pnum) * mxGetN(pnum) );
//                }
//                else
//                {
//                  mexPrintf("Error_%s: d.%s(%i) ist kein numerischer Wert\n", MEX_FUNCTION_NAME, fieldname.c_str(), ind);
//                  mexErrMsgTxt("Above field must have not numeric data.");
//                }
//              }
//            }
//          }
//        }
//      }
//    }
//  }
//  return true;
//}
mxArray *mex_SIM_MOD_output_struct(void)
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
  pout    = mxCreateStructArray(2,dims,(int)SIM_EMODUL_SIM_N_OUT,(const char **)pSimOutVarNames);

  //=============================
  // Matlab-Unterstruktur anlegen
  //=============================
  for(i=0;i<SIM_EMODUL_SIM_N_OUT;i++)
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

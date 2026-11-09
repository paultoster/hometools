//--------------------------------------------------------------
// file: mexEinspurmodell.cpp - Matlab Mex function application
//--------------------------------------------------------------
/*##FUNCTION_CODE_NAMEXYZ_START##*/
/*##FUNCTION_CODE_NAMEXYZ_END##*/
#include "mex.h"

#include "sim_MODUL_SIM.h"

//===============================================================
//===============================================================
// Name mex-Funktion
//===============================================================
//===============================================================
#define MEX_FUNCTION_NAME       "#PROJECT_NAME#"

std::string MessAcsCanFile = "";      // Ascii-Filename mit Messung
std::vector<size_t> ListeCANID;       // Vektor mit Identifier, die benutzt werden sollen
std::vector<unsigned char> ListeCANCHAN; // Vektor mit den dazugehörigen Channels

mxArray *mex_SIM_MOD_output_struct(void);
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
  SimMod.ParamNames.clear();                    /* Parameternamen aus mex-Eingabe */
  SimMod.ParamValues.clear();                   /* Parameterwerte (numerisch) aus mex-Eingabe */

  SimInpTime.found = false;
  for(i=0;i<SIM_MODUL_SIM_N_INP;i++)
  {
    SimInp[i].found      = false;
    SimInp[i].nvec.clear();
    SimInp[i].pvec.clear();
    SimInp[i].ncells     = 0;
    SimInp[i].isvecofvec = 0;
    SimInp[i].vecname    = pSimInpVarNames[i];
  }
  SimParTime.found = false;
  for(i=0;i<SIM_MODUL_SIM_N_PAR;i++)
  {
    SimPar[i].found      = false;
    SimPar[i].nvec.clear();
    SimPar[i].pvec.clear();
    SimPar[i].ncells     = 0;
    SimPar[i].isvecofvec = 0;
    SimPar[i].vecname    = pSimParVarNames[i];
  }
  for(i=0;i<SIM_MODUL_SIM_N_OUT;i++)
  {
    SimOut[i].time.clear();
    SimOut[i].vec.clear();
    SimOut[i].comment.clear();
    SimOut[i].isvecofvec = false;
  }
	
	// keine PArameter
  if( nrhs == 0 )
  {
    mexPrintf("e = %s(d,p,qparamstruct]);\n",MEX_FUNCTION_NAME);
    mexPrintf("  d                      struct      d-Struktur für die Eingabevektoren\n");
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


  // 1. Parameter d-Struktur lesen
  //==============================
	irhs = 0;
  if( mxIsStruct(prhs[irhs]) )  /* d-Struktur übergeben */
  {
    int      nfields,ifield;
    mxArray  *parray;
    std::string fieldname;
    bool       flag;

    nfields = mxGetNumberOfFields(prhs[irhs]);

    for(ifield=0; ifield<nfields; ifield++)
    {
      fieldname = mxGetFieldNameByNumber(prhs[irhs],ifield);

      parray = mxGetFieldByNumber(prhs[irhs], 0, ifield);

      if(parray == NULL)
      {		
        mexPrintf("Error_%s: %s%d\t%s%d\n", "FIELD: ",MEX_FUNCTION_NAME, ifield+1, "STRUCT INDEX :", 1);
	      mexErrMsgTxt("Above field is empty!");
      }

      if(  mxIsNumeric(parray)  /* ein einfacher Vektor */
        || mxIsCell(parray)     /* Vektor of Vektor */
        )
      {
        if( fieldname.compare("time") == 0 ) /* Zeitvektor */
        {
          if( mxIsCell(parray) )
          {
  		      mexPrintf("Error_%s: d.time darf nicht als cell-array benutzt werden\n", MEX_FUNCTION_NAME);
            mexErrMsgTxt("Above field must have not numeric data.");
          }
          SimInpTime.ptime = mxGetPr(parray);
          SimInpTime.ntime = mxGetM(parray) * mxGetN(parray);
          SimInpTime.found = true;

          if( SimInpTime.ntime == 0 )
          {
  		      mexPrintf("Error_%s: d.time hat die null Elemente\n", MEX_FUNCTION_NAME);
            mexErrMsgTxt("Above field must have not numeric data.");
          }
          SimMod.tstart    = SimInpTime.ptime[0];
          SimMod.tend      = SimInpTime.ptime[SimInpTime.ntime-1];
        }
        else
        {
          flag = false;
          for( i=0;i<SIM_MODUL_SIM_N_INP;i++)
          {
            if( fieldname.compare(pSimInpVarNames[i]) == 0 )
            {
              flag = true;
              break;
            }
          }
          if( flag )
          {
            if( mxIsNumeric(parray) ) /* ein einfacher Vektor */
            {
              SimInp[i].isvecofvec = 0;
              SimInp[i].found      = true;
              SimInp[i].ncells     = 1;

              SimInp[i].pvec.push_back(mxGetPr(parray));
              SimInp[i].nvec.push_back(mxGetM(parray) * mxGetN(parray));

              if( SimInp[i].nvec[0] == 0 )
              {
                mexPrintf("Error_%s: d.%s hat die null Elemente\n",MEX_FUNCTION_NAME, fieldname.c_str());
                mexErrMsgTxt("Above field must have not numeric data.");
              }
            }
            else /* cell array mit Vektor of Vektor */
            {
              mwIndex index;
              mxArray  *pnum;
              mwSize ncells = mxGetNumberOfElements(parray);

              SimInp[i].isvecofvec = 1;
              SimInp[i].ncells     = ncells;
              SimInp[i].found      = true;

              for (index=0; index<ncells; index++)
              {
                pnum = mxGetCell(parray, index);
                if( pnum == NULL )
                {
                  SimInp[i].pvec.push_back(NULL);
                  SimInp[i].nvec.push_back( 0 );
                }
                else if( mxIsNumeric(pnum) ) /* numericher Vektor */
                {
                  SimInp[i].pvec.push_back(mxGetPr(pnum));
                  SimInp[i].nvec.push_back( mxGetM(pnum) * mxGetN(pnum) );
                }
                else
                {
                  mexPrintf("Error_%s: d.%s(%i) ist kein numerischer Wert\n", MEX_FUNCTION_NAME, fieldname.c_str(), index);
                  mexErrMsgTxt("Above field must have not numeric data.");
                }
              }
            }
          }
        }
      }
      else
      {
        mexPrintf("Error_%s: d.%s ist kein numerischer Wert oder cell-array\n", MEX_FUNCTION_NAME, fieldname.c_str());
        mexErrMsgTxt("Above field must have not numeric data.");
      }
    }
  }
  else
  {
		sprintf_s(errtext,lerrtext,"Error_%s: Erster Parameter ist keine Struktur d (struct)",MEX_FUNCTION_NAME);
    mexErrMsgTxt(errtext);	
    return;
  }

  // 2. Parameter p-Struktur lesen
  //==============================
	irhs = irhs+1;
  if( !mxIsEmpty(prhs[irhs]) )  /* p-Struktur ist nicht leer */
  {
    if( mxIsStruct(prhs[irhs]) )  /* p-Struktur übergeben */
    {
      int      nfields,ifield;
      mxArray  *parray;
      std::string fieldname;
      bool       flag;

      nfields = mxGetNumberOfFields(prhs[irhs]);

      for(ifield=0; ifield<nfields; ifield++)
      {
        fieldname = mxGetFieldNameByNumber(prhs[irhs],ifield);

        parray = mxGetFieldByNumber(prhs[irhs], 0, ifield);

        if(parray == NULL)
        {		
          mexPrintf("Error_%s: %s%d\t%s%d\n", "FIELD: ",MEX_FUNCTION_NAME, ifield+1, "STRUCT INDEX :", 1);
	        mexErrMsgTxt("Above field is empty!");
        }

        if(  mxIsNumeric(parray)  /* ein einfacher Vektor */
          || mxIsCell(parray)     /* Vektor of Vektor */
          )
        {
          if( fieldname.compare("time") == 0 ) /* Zeitvektor */
          {
            if( mxIsCell(parray) )
            {
  		        mexPrintf("Error_%s: d.time darf nicht als cell-array benutzt werden\n", MEX_FUNCTION_NAME);
              mexErrMsgTxt("Above field must have not numeric data.");
            }
            SimParTime.ptime = mxGetPr(parray);
            SimParTime.ntime = mxGetM(parray) * mxGetN(parray);
            SimParTime.found = true;

            if( SimParTime.ntime == 0 )
            {
  		        mexPrintf("Error_%s: p.time hat die null Elemente\n", MEX_FUNCTION_NAME);
              mexErrMsgTxt("Above field must have not numeric data.");
            }
          }
          else
          {
            flag = false;
            for( i=0;i<SIM_MODUL_SIM_N_PAR;i++)
            {
              if( fieldname.compare(pSimParVarNames[i]) == 0 )
              {
                flag = true;
                break;
              }
            }
            if( flag )
            {
              if( mxIsNumeric(parray) ) /* ein einfacher Vektor */
              {
                SimPar[i].isvecofvec = 0;
                SimPar[i].found      = true;
                SimPar[i].ncells     = 1;

                SimPar[i].pvec.push_back(mxGetPr(parray));
                SimPar[i].nvec.push_back(mxGetM(parray) * mxGetN(parray));

                if( SimPar[i].nvec[0] == 0 )
                {
                  mexPrintf("Error_%s: p.%s hat die null Elemente\n",MEX_FUNCTION_NAME, fieldname.c_str());
                  mexErrMsgTxt("Above field must have not numeric data.");
                }
              }
              else /* cell array mit Vektor of Vektor */
              {
                mwIndex index;
                mxArray  *pnum;
                mwSize ncells = mxGetNumberOfElements(parray);

                SimPar[i].isvecofvec = 1;
                SimPar[i].ncells     = ncells;
                SimPar[i].found      = true;

                for (index=0; index<ncells; index++)
                {
                  pnum = mxGetCell(parray, index);
                  if( pnum == NULL )
                  {
                    SimPar[i].pvec.push_back(NULL);
                    SimPar[i].nvec.push_back( 0 );
                  }
                  else if( mxIsNumeric(pnum) ) /* numericher Vektor */
                  {
                    SimPar[i].pvec.push_back(mxGetPr(pnum));
                    SimPar[i].nvec.push_back( mxGetM(pnum) * mxGetN(pnum) );
                  }
                  else
                  {
                    mexPrintf("Error_%s: p.%s(%i) ist kein numerischer Wert\n", MEX_FUNCTION_NAME, fieldname.c_str(), index);
                    mexErrMsgTxt("Above field must have not numeric data.");
                  }
                }
              }
            }
          }
        }
        else
        {
          mexPrintf("Error_%s: p.%s ist kein numerischer Wert oder cell-array\n", MEX_FUNCTION_NAME, fieldname.c_str());
          mexErrMsgTxt("Above field must have not numeric data.");
        }
      }
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
        parray    = mxGetFieldByNumber(prhs[irhs], 0, ifield);
        fieldname = mxGetFieldNameByNumber(prhs[irhs],ifield);

        if( !mxIsDouble(parray) )
        {
  	  	  sprintf_s(errtext,lerrtext,"Error_%s: Parameterdtruktur enthaelt non numeric Werte",MEX_FUNCTION_NAME);
	    	  mexErrMsgTxt(errtext);
          return;
        }
        else
        {
          pd = mxGetPr(parray);
        }
        SimMod.ParamNames.push_back(fieldname);
        dval = *pd;
        SimMod.ParamValues.push_back(dval);
      }
    }
  }

	// Parameter an SIM_MOD_SIM übergeben
	//============================================
	if( sim_MODUL_SIM_init(errtext,lerrtext) !=  OKAY )
  {
    mexErrMsgTxt(errtext);
  }


	// Simulation aufrufen
	//====================
	if( sim_MODUL_SIM(errtext,lerrtext) != OKAY )
  {
    mexErrMsgTxt(errtext);
  }

  // Ausgabe erstellen
  //==================
  if( SIM_MODUL_SIM_N_OUT && nlhs > 0) plhs[0] = mex_SIM_MOD_output_struct();

}
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
  pout    = mxCreateStructArray(2,dims,(int)SIM_MODUL_SIM_N_OUT,(const char **)pSimOutVarNames);

  //=============================
  // Matlab-Unterstruktur anlegen
  //=============================
  for(i=0;i<SIM_MODUL_SIM_N_OUT;i++)
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

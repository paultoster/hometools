//--------------------------------------------------------------
// file: mexEinspurmodell.cpp - Matlab Mex function application
//--------------------------------------------------------------
/*##FUNCTION_CODE_NAMEXYZ_START##*/
/*##FUNCTION_CODE_NAMEXYZ_END##*/
//#define CHAR16_T unsigned short
#include "mex.h"
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <vector>

#include "sim_VPU_CAN_SIM.h"

#define NEW_READ_FUNCTION 1

//===============================================================
//===============================================================
// Name mex-Funktion
//===============================================================
//===============================================================
#define MEX_FUNCTION_NAME       "mex_#PROJECT_NAME#"

std::string MessAcsCanFile = "";      // Ascii-Filename mit Messung
std::vector<size_t> ListeCANID;       // Vektor mit Identifier, die benutzt werden sollen
std::vector<unsigned char> ListeCANCHAN; // Vektor mit den dazugehörigen Channels

mxArray *mex_VPU_CAN_SIM_output_struct(void);
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
  size_t          i,j;
  int             irhs;
  size_t          nrow,ncol,nvec;
  char            errtext[255];
  size_t          lerrtext = 254;
  errtext[0]      = '\0';
  //mexPrintf("mexFunction: <%s>\n\n",MEX_FUNCTION_NAME);


  // Initialisieren:
  SimVpu.MessAsciiCanFile.clear();              /* Messdatei */
  SimVpu.VecIdCh.clear();                       /* Vector mit ID und Channel, die eingelesen werden */
  SimVpu.RecBufListIsRead = false;              /* Flag, ob RecBufList gelesen */
  SimVpu.RecBufList.clear();                    /* Buffer, der eingelesen wird */
  SimVpu.RecTimerList.clear();                  /* Timer der eingelsenen Botschaften, um in integer rechnen zu können */
  SimVpu.tstart = 0.0;                          /* Startzeit, entweder null oder durch Odometrie-Trajektorienabgleich */
  SimVpu.tend   = 0.0;                          /* Endzeit                     */
  SimVpu.ParamNames.clear();                    /* Parameternamen aus mex-Eingabe */
  SimVpu.ParamValues.clear();                   /* Parameterwerte (numerisch) aus mex-Eingabe */

  for(i=0;i<SIM_VPU_CAN_SIM_N_PAR;i++)
  {
    SimPar[i].found      = false;
    SimPar[i].nvec.clear();
    SimPar[i].pvec.clear();
    SimPar[i].ncells     = 0;
    SimPar[i].isvecofvec = 0;
    SimPar[i].vecname    = pSimParVarNames[i];
  }
  for(i=0;i<SIM_VPU_CAN_SIM_N_OUT;i++)
  {
    SimOut[i].time.clear();
    SimOut[i].vec.clear();
    SimOut[i].comment.clear();
    SimOut[i].vecvec.clear();
    SimOut[i].nvecvec.clear();
    SimOut[i].isvecofvec = false;
  }

	
	// keine PArameter
  if( nrhs == 0 )
  {
    mexPrintf("e = %s(mess_file_asc_file,IDs,channels,[p,qparamstruct]);\n",MEX_FUNCTION_NAME);
    mexPrintf("  mess_file_asc_file     char        Name Ascii-Messfile\n");
    mexPrintf("  IDs                    double      vector mit den zu verwendeten IDs\n");
    mexPrintf("  channels               double      vector mit dem dazugehörigen channel\n");
    mexPrintf("  channels               double      vector mit dem dazugehörigen channel\n");
    mexPrintf("  p                      struct      p-Struktur für die Eingabevektoren für Parameter\n");
    mexPrintf("  qparamstruct           .name = value  Struktur mit Parameternamen und numerischer Wert\n");

    if( nlhs > 0 )
    {
      mwSize dims[2];
      dims[0] = 0;
      dims[1] = 0;
      plhs[0] = mxCreateStructArray(2,dims,0,NULL);
    }

    return;
  }


  // 1. Parameter mess-File string oder b-Struktur lesen
  //====================================================
	irhs = 0;
  if( mxIsStruct(prhs[irhs]) )  /* b-Struktur übergeben */
  {
#if NEW_READ_FUNCTION == 1
    int      nfields,ifield;
    mxArray  *parray;
    std::string fieldname;
    mwSize     nelems;
    mwSize     ndim;
    double     *ptime ,*pid  ,*pchannel  ,*plen  ,*pbyte0  ,*pbyte1  ,*pbyte2  ,*pbyte3  ,*pbyte4  ,*pbyte5  ,*pbyte6  ,*pbyte7  ,*preceive;
    size_t     itime,ntime=0, nid=0, nchannel=0, nlen=0, nbyte0=0, nbyte1=0, nbyte2=0, nbyte3=0, nbyte4=0, nbyte5=0, nbyte6=0, nbyte7=0, nreceive=0;

	  SimVpu.RecBufList.clear();

    nfields = mxGetNumberOfFields(prhs[irhs]);
    nelems  = mxGetNumberOfElements(prhs[irhs]);

    for(ifield = 0; ifield < nfields; ifield++)
    {
      fieldname = mxGetFieldNameByNumber(prhs[irhs],ifield);
      parray    = mxGetFieldByNumber(prhs[irhs], 0, ifield);

      if(parray == NULL)
      {		
        mexPrintf("Error_%s: %s%d\t%s%d\n", "FIELD: ",MEX_FUNCTION_NAME, ifield+1, "STRUCT INDEX :", 1);
        mexErrMsgTxt("Above field is empty!");
      }

      if(  mxIsNumeric(parray)  /* ein einfacher Vektor */
        )
      {
        if( fieldname.compare("time") == 0 ) /* Zeitvektor */
        {
          ptime = mxGetPr(parray);
          ntime = mxGetM(parray) * mxGetN(parray);
        }
        else if( fieldname.compare("id") == 0 ) /* ID-Vektor */
        {
          pid = mxGetPr(parray);
          nid = mxGetM(parray) * mxGetN(parray);
        }
        else if( fieldname.compare("channel") == 0 ) /* ID-Vektor */
        {
          pchannel = mxGetPr(parray);
          nchannel = mxGetM(parray) * mxGetN(parray);
        }
        else if( fieldname.compare("len") == 0 ) /* ID-Vektor */
        {
          plen = mxGetPr(parray);
          nlen = mxGetM(parray) * mxGetN(parray);
        }
        else if( fieldname.compare("byte0") == 0 ) /* ID-Vektor */
        {
          pbyte0 = mxGetPr(parray);
          nbyte0 = mxGetM(parray) * mxGetN(parray);
        }
        else if( fieldname.compare("byte1") == 0 ) /* ID-Vektor */
        {
          pbyte1 = mxGetPr(parray);
          nbyte1 = mxGetM(parray) * mxGetN(parray);
        }
        else if( fieldname.compare("byte2") == 0 ) /* ID-Vektor */
        {
          pbyte2 = mxGetPr(parray);
          nbyte2 = mxGetM(parray) * mxGetN(parray);
        }
        else if( fieldname.compare("byte3") == 0 ) /* ID-Vektor */
        {
          pbyte3 = mxGetPr(parray);
          nbyte3 = mxGetM(parray) * mxGetN(parray);
        }
        else if( fieldname.compare("byte4") == 0 ) /* ID-Vektor */
        {
          pbyte4 = mxGetPr(parray);
          nbyte4 = mxGetM(parray) * mxGetN(parray);
        }
        else if( fieldname.compare("byte5") == 0 ) /* ID-Vektor */
        {
          pbyte5 = mxGetPr(parray);
          nbyte5 = mxGetM(parray) * mxGetN(parray);
        }
        else if( fieldname.compare("byte6") == 0 ) /* ID-Vektor */
        {
          pbyte6 = mxGetPr(parray);
          nbyte6 = mxGetM(parray) * mxGetN(parray);
        }
        else if( fieldname.compare("byte7") == 0 ) /* ID-Vektor */
        {
          pbyte7 = mxGetPr(parray);
          nbyte7 = mxGetM(parray) * mxGetN(parray);
        }
        else if( fieldname.compare("receive") == 0 ) /* ID-Vektor */
        {
          preceive = mxGetPr(parray);
          nreceive = mxGetM(parray) * mxGetN(parray);
        }
      }
    }
    // auf kleinsten kürzen
    ntime = MIN(ntime,nid);
    ntime = MIN(ntime,nchannel);
    ntime = MIN(ntime,nlen);
    ntime = MIN(ntime,nbyte0);
    ntime = MIN(ntime,nbyte1);
    ntime = MIN(ntime,nbyte2);
    ntime = MIN(ntime,nbyte3);
    ntime = MIN(ntime,nbyte4);
    ntime = MIN(ntime,nbyte5);
    ntime = MIN(ntime,nbyte6);
    ntime = MIN(ntime,nbyte7);
    ntime = MIN(ntime,nreceive);

    for(itime=0;itime<ntime;++itime)
    {
      
      SRecBuf recBuf;
      //recBuf.time    = 0.0;
      //recBuf.id      = 0;
      //recBuf.channel = 0;
      //recBuf.len     = 0;
      //recBuf.len     = 0;
      //memset(recBuf.data, 0, sizeof(recBuf.data)*8);
      //recBuf.receive = 0;
      recBuf.time    = ptime[itime];
      recBuf.id      = (size_t)(pid[itime]+0.5);
      recBuf.channel = (unsigned char)(pchannel[itime]+0.5);
      recBuf.len     = (unsigned char)(plen[itime]+0.5);
      recBuf.data[0] = (unsigned char)(pbyte0[itime]+0.5);
      recBuf.data[1] = (unsigned char)(pbyte1[itime]+0.5);
      recBuf.data[2] = (unsigned char)(pbyte2[itime]+0.5);
      recBuf.data[3] = (unsigned char)(pbyte3[itime]+0.5);
      recBuf.data[4] = (unsigned char)(pbyte4[itime]+0.5);
      recBuf.data[5] = (unsigned char)(pbyte5[itime]+0.5);
      recBuf.data[6] = (unsigned char)(pbyte6[itime]+0.5);
      recBuf.data[7] = (unsigned char)(pbyte7[itime]+0.5);
      recBuf.receive = (unsigned char)(preceive[itime]+0.5);

      if( itime == 0         ) SimVpu.tstart = recBuf.time;
      if( itime == (ntime-1) ) SimVpu.tend   = recBuf.time;


      SimVpu.RecBufList.push_back(recBuf);
    }
    ndim = SimVpu.RecBufList.size();
    SimVpu.RecBufListIsRead = true;
#else
    int      nfields,ifield;
    mxArray  *parray;
    std::string fieldname;
    double     *pdvalue;
    mwIndex    jstruct;
    mwSize     nelems;
    mwSize     ndim;
    mwSize     idim;


    SimVpu.RecBufList.clear();

    nfields = mxGetNumberOfFields(prhs[irhs]);
    nelems  = mxGetNumberOfElements(prhs[irhs]);

    // check empty field, proper data type, and data type consistency;
    // and get classID for each field.

    for(jstruct = 0; jstruct < nelems; jstruct++)
    {
      SRecBuf recBuf;
      //recBuf.time    = 0.0;
      //recBuf.id      = 0;
      //recBuf.channel = 0;
      //recBuf.len     = 0;
      //recBuf.len     = 0;
      //memset(recBuf.data, 0, sizeof(recBuf.data)*8);
      //recBuf.receive = 0;

      for(ifield=0; ifield<nfields; ifield++)
      {
        fieldname = mxGetFieldNameByNumber(prhs[irhs],ifield);

        parray = mxGetFieldByNumber(prhs[irhs], jstruct, ifield);
	
        if(parray == NULL)
        {		
          mexPrintf("Error_%s: %s%d\t%s%d\n", "FIELD: ",MEX_FUNCTION_NAME, ifield+1, "STRUCT INDEX :", jstruct+1);
		      mexErrMsgTxt("Above field is empty!");
	      }

	      if( (!mxIsNumeric(parray)) ) {
  		    mexPrintf("Error_%s: %s%d\t%s%d\n", "FIELD: ",MEX_FUNCTION_NAME, ifield+1, "STRUCT INDEX :", jstruct+1);
	        mexErrMsgTxt("Above field must have not numeric data.");
	      }
        if( fieldname == "time" )
        {
          recBuf.time = *mxGetPr(parray);
          if( jstruct == 0          ) SimVpu.tstart = recBuf.time;
          if( jstruct == (nelems-1) ) SimVpu.tend   = recBuf.time;
        }
        else if( fieldname == "id" )
        {
          recBuf.id = (size_t)(*mxGetPr(parray)+0.5);
        }
        else if( fieldname == "channel" )
        {
          recBuf.channel = (unsigned char)(*mxGetPr(parray)+0.5);
        }
        else if( fieldname == "len" )
        {
          recBuf.len = (unsigned char)(*mxGetPr(parray)+0.5);
        }
        else if( fieldname == "bytes" )
        {
          pdvalue = mxGetPr(parray);
          ndim  = mxGetM(parray) * mxGetN(parray);
			    if( ndim > 8 ) ndim = 8;
          for(idim=0;idim<ndim;idim++)
          {
            recBuf.data[idim] = (unsigned char)((*(pdvalue+idim)+0.5));
          }
          for(idim=ndim;idim<8;idim++)
          {
            recBuf.data[idim] = 0;
          }
        }
        else if( fieldname == "receive" )
        {
          recBuf.receive = (unsigned char)(*mxGetPr(parray)+0.5);
        }
      }
      SimVpu.RecBufList.push_back(recBuf);
    }
    ndim = SimVpu.RecBufList.size();
    SimVpu.RecBufListIsRead = true;
#endif
  }
  else if( mxIsChar(prhs[irhs]) )  /* Ascii-Datei einlesen */
  {
		char *ptext=0;

		ptext = (char *)malloc(sizeof(char)*(mxGetM(prhs[irhs]) * mxGetN(prhs[irhs])+1));
		
		if( ptext != 0 ) {
			
			mxGetString(prhs[irhs],ptext,(mxGetM(prhs[irhs]) * mxGetN(prhs[irhs])+1));
		}
    else
    {
		  sprintf_s(errtext,lerrtext,"Error_%s: malloc char * %i konnte nicht erzeugt werden\n",MEX_FUNCTION_NAME,(mxGetM(prhs[irhs]) * mxGetN(prhs[irhs])+1));
      mexErrMsgTxt(errtext);
		  return;
		}
		MessAcsCanFile = ptext;
		free(ptext);

		/* Check dat-file */
		FILE            *fp;
    fp = fopen(MessAcsCanFile.c_str(), "r");
    if(!fp)
    {
	    sprintf_s(errtext,lerrtext,"Error_%s: Dat-File <%s> konnte nicht geöffnet werden.\n",MEX_FUNCTION_NAME,MessAcsCanFile.c_str());
	    mexErrMsgTxt(errtext);
      return;
    }
    fclose(fp);

	}
  else
  {
		sprintf_s(errtext,lerrtext,"Error_%s: Erster Parameter ist kein Filename (char) oder Struktur b (struct) (mess_file_asc_file)",MEX_FUNCTION_NAME);
    mexErrMsgTxt(errtext);	
    return;
  }

  if( !SimVpu.RecBufListIsRead )
  {
    // 2. Parameter Liste mit einzulesenden IDs
    //================================================
	  irhs = irhs + 1;
    if( nrhs <= irhs )
    {
		  sprintf_s(errtext,lerrtext,"Error_%s: Anzahl Parameter stimmt nicht überein nrhs = %i",MEX_FUNCTION_NAME,3);
      mexErrMsgTxt(errtext);
      return;
    }
    if( !mxIsDouble(prhs[irhs]) )
    {
		  sprintf_s(errtext,lerrtext,"Error_%s: Zweiter Parameter ist kein (double)",MEX_FUNCTION_NAME);
		  mexErrMsgTxt(errtext);
      return;
    }
    nrow = mxGetM(prhs[irhs]);  // Get number of rows in mxArray
    ncol = mxGetN(prhs[irhs]);  // Get number of columns in mxArray
    nvec = ncol*nrow;

	  double *pval = mxGetPr(prhs[irhs]);

    for(j=0;j<nvec;j++)
	  {
		  ListeCANID.push_back((size_t)pval[j]);
	  }
    // 3. Parameter Liste mit dem dazu gehörigen Channel
    //==================================================
	  irhs = irhs + 1;
    if( nrhs <= irhs )
    {
		  sprintf_s(errtext,lerrtext,"Error_%s: Anzahl Parameter stimmt nicht überein nrhs = %i",MEX_FUNCTION_NAME,3);
      mexErrMsgTxt(errtext);
      return;
    }
    if( !mxIsDouble(prhs[irhs]) )
    {
		  sprintf_s(errtext,lerrtext,"Error_%s: Dritter Parameter ist kein (double)",MEX_FUNCTION_NAME);
		  mexErrMsgTxt(errtext);
      return;
    }
    nrow = mxGetM(prhs[irhs]);  // Get number of rows in mxArray
    ncol = mxGetN(prhs[irhs]);  // Get number of columns in mxArray
    nvec = ncol*nrow;

	  pval = mxGetPr(prhs[irhs]);

    for(j=0;j<nvec;j++)
	  {
		  ListeCANCHAN.push_back((unsigned char)pval[j]);
	  }
	  // Channelvektor auffüllen, wenn weniger Channels angegeben
    if( ListeCANCHAN.size() == 0 ) ListeCANID.push_back(1);
	  while(ListeCANCHAN.size() < ListeCANID.size()) ListeCANCHAN.push_back(ListeCANCHAN[ListeCANCHAN.size()-1]);
  }

  // 2. Parameter p-Struktur lesen
  //==============================
  irhs = irhs+1;
  if( nrhs > irhs )
  {
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
              for( i=0;i<SIM_VPU_CAN_SIM_N_PAR;i++)
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
  }
  // 5. q-Parameterstrukturdaten
  //==================================================
  irhs = irhs+1;
  if( nrhs > irhs )
  {
    if( !mxIsStruct(prhs[irhs]) )
    {
  		sprintf_s(errtext,lerrtext,"Error_%s: Vierter Parameter ist keine (struct)",MEX_FUNCTION_NAME);
	  	mexErrMsgTxt(errtext);
      return;
    }
    else
    {
      int nfields = mxGetNumberOfFields(prhs[irhs]);
      int ifield;
      mxArray  *parray;
      const char *fieldname;
	    double   *pd;
      size_t   i,nval;

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
          pd   = mxGetPr(parray);
          nval =  mxGetM(parray)*mxGetN(parray);
        }
        // Parametervektor anlegen
        CParamValues Vec;
        // Parameter Vektor füllen
        for(i=0;i<nval;i++) Vec.push_back(*(pd+i));
        // Name des Parameters speichern
        SimVpu.ParamNames.push_back(fieldname);
        // Parameter Vektor speichern
        SimVpu.ParamValues.push_back(Vec);
      }
    }
  }

	// Parameter an sim_VPU_CAN_SIM übergeben
	//============================================
	if( sim_VPU_CAN_SIM_init(&MessAcsCanFile,&ListeCANID,&ListeCANCHAN,errtext,lerrtext) !=  OKAY )
  {
    mexErrMsgTxt(errtext);
  }


	// Simulation aufrufen
	//====================
	if( sim_VPU_CAN_SIM(errtext,lerrtext) != OKAY )
  {
    mexErrMsgTxt(errtext);
  }

  // Ausgabe erstellen
  //==================
  if( SIM_VPU_CAN_SIM_N_OUT && nlhs > 0) plhs[0] = mex_VPU_CAN_SIM_output_struct();

}
mxArray *mex_VPU_CAN_SIM_output_struct(void)
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
  pout    = mxCreateStructArray(2,dims,(int)SIM_VPU_CAN_SIM_N_OUT,(const char **)pSimOutVarNames);

  //=============================
  // Matlab-Unterstruktur anlegen
  //=============================
  for(i=0;i<SIM_VPU_CAN_SIM_N_OUT;i++)
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

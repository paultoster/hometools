/******************************************************************************
* @file  sim_EMODUL_SIM.c
*
* @author  Thomas Berthold
* @date    03/3/2014
*
* @brief Simulation of VPU
*
* @subversion_tags (not part of doxygen)
*   $LastChangedBy: berthold $
*   $LastChangedRevision: 38987 $
*   $LastChangedDate: 2014-02-06 15:49:32 +0100 (Do, 06 Feb 2014) $
*   $URL: http://frd2ahjg/svn/tze/Departments/EnvironmentPerception/Components/ArbiDev2PathTask/src/Application/ArbiDev2PathMain.cpp $
******************************************************************************/
/*##FUNCTION_CODE_NAMEXYZ_START##*/
/*##FUNCTION_CODE_NAMEXYZ_END##*/

/*****************************************************************************
INCLUDES
*****************************************************************************/
#include <climits>
double  SimDebugStopTime=6.14;
double  SimDebugTime= 0.0;
/*##EMODUL_SIM_START_INC##*/
#ifdef __cplusplus
extern "C" {
#endif
#include "iqf.h"
#include "iqf.he"
#ifdef __cplusplus
}
#endif
#include "fkt_EMODUL_SIM.h"
char *pSimInpVarNames[] = {"abc"
                          };
char *pSimOutVarNames[] = {"def"
                          };
char *pSimParVarNames[] = {"ghhj"
                          };
char *pSimInpUnitNames[] = {"m"
                           };
char *pSimOutUnitNames[] = {"-"
                           };
char *pSimParUnitNames[] = {"enum"
                           };
/*##EMODUL_SIM_END_INC##*/


#define SLF_BASIC_BYTE_T_DEFINED
#define SLF_BASIC_UINT32_T_DEFINED
#include "sim_EMODUL_SIM.h"
#include "fkt_EMODUL_SIM.h"
std::vector<SSimIO> SimInp(SIM_EMODUL_SIM_N_INP);
std::vector<SSimIO> SimOut(SIM_EMODUL_SIM_N_OUT);
std::vector<SSimIO> SimPar(SIM_EMODUL_SIM_N_PAR);

/*****************************************************************************
FUNCTIONS
*****************************************************************************/
bool sim_EMODUL_SIM_get_param(char *param_name,double *pval);
status_t sim_EMODUL_SIM_inp_loop(double *ptime,char *errtext,size_t lerrtext);
status_t sim_EMODUL_SIM_out_loop(double *ptime,char *errtext,size_t lerrtext);
status_t sim_EMODUL_SIM_par_perm(char *errtext,size_t lerrtext);
status_t sim_EMODUL_SIM_par_loop(double *ptime,char *errtext,size_t lerrtext);
status_t sim_EMODUL_SIM_par_init0(char *errtext,size_t lerrtext);
status_t sim_EMODUL_SIM_par_init1(char *errtext,size_t lerrtext);
/*****************************************************************************
DECLARATIONS
*****************************************************************************/
SSimMod SimMod;

status_t sim_EMODUL_SIM_init(char *errtext,size_t lerrtext)
{
	status_t status = OKAY;
  size_t   i;
  //  double   tstart;

  // Input prüfen
  //=============
  for( i=0;i<SIM_EMODUL_SIM_N_INP;i++)
  {
    if( !SimInp[i].found )
    {
      status = NOT_OKAY;
      sprintf_s(errtext,lerrtext,"Kein Vektor '%s' in der eingelesenen daten-Struktur gefunden !!!",SimInp[i].vecname.c_str());
      return status;
    }
  }
  for( i=0;i<SIM_EMODUL_SIM_N_PAR;i++)
  {
    if( !SimPar[i].found )
    {
      status = NOT_OKAY;
      sprintf_s(errtext,lerrtext,"Kein Vektor '%s' in der eingelesenen parameter-Struktur gefunden !!!",SimPar[i].vecname.c_str());
      return status;
    }
  }
  // Simulationsdaten
  //==================
  if( !sim_EMODUL_SIM_get_param("dt",&(SimMod.dt)) )          SimMod.dt     = SIM_EMODUL_MIN_DT;
  if( !sim_EMODUL_SIM_get_param("dtloop",&(SimMod.dtloop)) )  SimMod.dtloop = SIM_EMODUL_DEFAULT_DTLOOP;
  if( !sim_EMODUL_SIM_get_param("dtout",&(SimMod.dtout))   )  SimMod.dtout  = SIM_EMODUL_DEFAULT_DTOUT;
  if( !sim_EMODUL_SIM_get_param("tend",&(SimMod.tend))     )  SimMod.tend   = SIM_EMODUL_DEFAULT_TEND;

  
  SimMod.dtloop   = SIM_EMODUL_MAX(SimMod.dtloop,SIM_EMODUL_MIN_DT);
  SimMod.dtout    = SIM_EMODUL_MAX(SimMod.dtout,SIM_EMODUL_MIN_DT);
  SimMod.dt       = SIM_EMODUL_MIN(SimMod.dt,SimMod.dtout);
  SimMod.nloop    = SIM_EMODUL_MAX(1,size_t(SimMod.tend/SimMod.dt+0.5)+1);

  // Parameter vor Initialisierung setzen
  //=====================================
  if( sim_EMODUL_SIM_par_init0(errtext,lerrtext) != OKAY) return NOT_OKAY;

  /* Fkt - initialisierung */
  /*======================*/
  if( fkt_EMODUL_SIM_init(SimMod.dtloop,errtext,lerrtext) != OKAY ) return NOT_OKAY;

  // Parameter nach Initialisierung setzen
  //======================================
  if( sim_EMODUL_SIM_par_init1(errtext,lerrtext) != OKAY) return NOT_OKAY;

  return status;
}
status_t sim_EMODUL_SIM(char *errtext,size_t lerrtext)
{

  size_t  TimeCounter;
#if SIM_EMODUL_SIM_N_LOOP_PAR > 0
#define DELTA_T_TIME_PAR_ADD (1.e-6)
#endif
  double   SimDebugTime     = 0.0;
  unsigned long int nloop   = SIM_EMODUL_MAX((unsigned long int)(SimMod.dtloop/SimMod.dt+0.5),1);
  unsigned long int nloopM1 = nloop-1;
  unsigned long int iloop   = nloopM1;
  unsigned long int nout    = SIM_EMODUL_MAX((unsigned long int)(SimMod.dtout/SimMod.dt+0.5),1);
  unsigned long int noutM1  = nout-1;
  unsigned long int iout    = noutM1;

  for(TimeCounter=0;TimeCounter<SimMod.nloop;TimeCounter++)
  {

    if( SimDebugTime >= SimDebugStopTime )
    {
      char a;
      a = 0;
    }
    /*##FUNCTION_CODE_EMODUL_TIMESTOP_START##*/
    /*##FUNCTION_CODE_EMODUL_TIMESTOP_END##*/

    if( sim_EMODUL_SIM_inp_loop(&SimDebugTime,errtext,lerrtext) != OKAY )
    {
       return NOT_OKAY;
    }

	/* konstante Parameterwerte */
    if( sim_EMODUL_SIM_par_perm(errtext,lerrtext) != OKAY )
    {
       return NOT_OKAY;
    }

	/* Loop-weise sich ändernde Parameterwerte */
#if SIM_EMODUL_SIM_N_LOOP_PAR > 0
    if( sim_EMODUL_SIM_par_loop(&SimDebugTime,errtext,lerrtext) != OKAY )
    {
      return NOT_OKAY;
    }
#endif

    /* Loop-Aufruf */
    if( iloop == nloopM1 )
    {
      if( fkt_EMODUL_SIM_loop(errtext,lerrtext) != OKAY )
      {
         return NOT_OKAY;
      }
      iloop = 0;
    }
    else
    {
      ++iloop;
    }

    if( iout == noutM1 )
    {
      if( sim_EMODUL_SIM_out_loop(&SimDebugTime,errtext,lerrtext) != OKAY )
      {
         return NOT_OKAY;
      }
      iout = 0;
    }
    else
    {
      ++iout;
    }

    /* Incremetieren */
    SimDebugTime += SimMod.dt;

  }
  return OKAY;
}
/* ***********************************************************************/
/*!
@fn               status_t sim_EMODUL_SIM_inp_loop(double *ptime,char *errtext,size_t lerrtext)

@brief            Output nach der loop ...;

@desription

@return           status = OKAY

@pre

@post

@author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t sim_EMODUL_SIM_inp_loop(double *ptime,char *errtext,size_t lerrtext)
{
  /*##EMODUL_SIM_START_INP_LOOP##*/
  {
    double *pdval;
    size_t ndval,i;
    /* IQF1_LdwStatus */
    pdval = SimInp[0].pvec[0];
    ndval = SimInp[0].nvec[0];
    CAN1InputData.IQFLdwStatus = (unsigned char)(pdval[MIN(itime,ndval-1)] * 1.000000 + 0.000000);

    /* IQF1_LdwStatus_mBuffer_x */
    pdval = SimInp[1].pvec[MIN(itime,SimInp[1].ncells-1)];
    ndval = SimInp[1].nvec[MIN(itime,SimInp[1].ncells-1)];
    for(i=0;i<MIN(200,ndval);i++)
    {
       I.IQF1_LdwStatus_mBuffer_x[i] = (float)(pdval[i] * 1.0000 + 0.0000);
    }

  }
  /*##EMODUL_SIM_END_INP_LOOP##*/

  return OKAY;
}
/* ***********************************************************************/ 
/*!
@fn               status_t sim_EMODUL_SIM_par_perm(char *errtext,size_t lerrtext)

@brief            Parameter während der loop aber konstant

@desription

@return           status = OKAY

@pre

@post

@author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t sim_EMODUL_SIM_par_perm(char *errtext,size_t lerrtext)
{
  /*##EMODUL_SIM_START_PAR_PERM##*/
  {
    double *pdval;
    /* IQF1_LdwStatus */
    pdval = SimPar[0].pvec[0];
    arbiDev2PathParData.UseEgoPosFilt = (signed short int)(pdval[0]);

    /* UseEgoPosFilt=0 */
    arbiDev2PathParData.UseEgoPosFilt = (signed short int)(0);
  }
  /*##EMODUL_SIM_END_PAR_PERM##*/
  return OKAY;
}
/* ***********************************************************************/ 
/*!
@fn               status_t sim_EMODUL_SIM_par_loop(double *ptime,char *errtext,size_t lerrtext)

@brief            Parameter während der loop ...;

@desription

@return           status = OKAY

@pre

@post

@author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t sim_EMODUL_SIM_par_loop(double *ptime,char *errtext,size_t lerrtext)
{
  /*##EMODUL_SIM_START_PAR_LOOP##*/
  {
    double *pdval;
    size_t ndval,i;
    /* IQF1_LdwStatus */
    pdval = SimPar[0].pvec[0];
    ndval = SimPar[0].nvec[0];
    CAN1InputData.IQFLdwStatus = (unsigned char)(pdval[MIN(itime,ndval-1)] * 1.000000 + 0.000000);
  }
  /*##EMODUL_SIM_END_PAR_LOOP##*/
  return OKAY;
}
/* ***********************************************************************/ 
/*!
@fn               status_t sim_EMODUL_SIM_par_init0(char *errtext,size_t lerrtext)

@brief            Parameter vor initialisierung ...;

@desription

@return           status = OKAY

@pre

@post

@author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t sim_EMODUL_SIM_par_init0(char *errtext,size_t lerrtext)
{
  /*##EMODUL_SIM_START_PAR_INIT0##*/
  /*##EMODUL_SIM_END_PAR_INIT0##*/
  return OKAY;
}
/* ***********************************************************************/ 
/*!
@fn               status_t sim_EMODUL_SIM_par_init1(char *errtext,size_t lerrtext)

@brief            Parameter nach Initialisierung ...;

@desription

@return           status = OKAY

@pre

@post

@author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t sim_EMODUL_SIM_par_init1(char *errtext,size_t lerrtext)
{
  /*##EMODUL_SIM_START_PAR_INIT1##*/
  /*##EMODUL_SIM_END_PAR_INIT1##*/
  return OKAY;
}
/* ***********************************************************************/ 
/*!
@fn               status_t sim_EMODUL_SIM_out_loop(double *ptime,struct SRecBuf *p_rec_buf,char *errtext,size_t lerrtext)

@brief            Output nach der loop ...;

@desription

@return           status = OKAY

@pre

@post

@author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t sim_EMODUL_SIM_out_loop(double *ptime,char *errtext,size_t lerrtext)
{
  /*##EMODUL_SIM_START_OUT_LOOP##*/

  /* SIQF_SALaLoIqf1_switchOnIntvL */
  SimOut[0].time.push_back(*ptime);
  SimOut[0].vec.push_back(IQFsimOut.SALaLoIqf1_switchOnIntvL*1.000000+0.000000);
  SimOut[0].comment = "";

  /*##EMODUL_SIM_END_OUT_LOOP##*/
  return OKAY;
}
/* ***********************************************************************/ 
/*!
@fn               bool sim_EMODUL_SIM_get_param(char *param_name,double *pval)

@brief            Sucht Parameterwert;

@desription       Sucht Parametername in der Liste SimMod.ParamNames
Wenn gefunden, wird der Wert in *pval geschrieben und true zurückgegeben
Wenn nicht vorhanden wird false zurückgegeben

@return           status = OKAY

@pre

@post

@author           Thomas Berthold; 13.03.2014
**************************************************************************** */
bool sim_EMODUL_SIM_get_param(char *param_name,double *pval)
{
  std::vector<std::string>::iterator iterN;
  std::vector<double>::iterator      iterV = SimMod.ParamValues.begin();
  bool                               flag = false;

  for( iterN = SimMod.ParamNames.begin(); iterN != SimMod.ParamNames.end(); ++iterN )
  {
    if( (*iterN).compare(param_name) == 0 )
    {
      *pval = *iterV;
      flag = true;
      break;
    }
    ++iterV;
  }
  return flag;
}

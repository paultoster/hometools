/******************************************************************************
 * @file  sim_MODUL_SIM.c
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
double  SimDebugTime=4.;
/*##MODUL_SIM_START_INC##*/
#ifdef __cplusplus
extern "C" {
#endif
#include "iqf.h"
#include "iqf.he"
#ifdef __cplusplus
}
#endif
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
/*##MODUL_SIM_END_INC##*/


#define SLF_BASIC_BYTE_T_DEFINED
#include "sim_MODUL_SIM.h"
#include "fkt_MODUL_SIM.h"
SSimInpTime SimInpTime;
SSimInp SimInp[SIM_MODUL_SIM_N_INP];
SSimOut SimOut[SIM_MODUL_SIM_N_OUT];
SSimParTime SimParTime;
SSimPar SimPar[SIM_MODUL_SIM_N_PAR];

/*****************************************************************************
  FUNCTIONS
*****************************************************************************/

status_t sim_MODUL_SIM_inp_loop(size_t itime,char *errtext,size_t lerrtext);
status_t sim_MODUL_SIM_out_loop(double *ptime,char *errtext,size_t lerrtext);
status_t sim_MODUL_SIM_par_perm(char *errtext,size_t lerrtext);
status_t sim_MODUL_SIM_par_loop(size_t itime,char *errtext,size_t lerrtext);
status_t sim_MODUL_SIM_par_init0(char *errtext,size_t lerrtext);
status_t sim_MODUL_SIM_par_init1(char *errtext,size_t lerrtext);
/*****************************************************************************
  DECLARATIONS
*****************************************************************************/
SSimMod SimMod;

status_t sim_MODUL_SIM_init(char *errtext,size_t lerrtext)
{
	status_t status = OKAY;
  size_t   i;
//  double   tstart;

  // Input prüfen
  //=============
  if( !SimInpTime.found )
  {
    status = NOT_OKAY;
    sprintf_s(errtext,lerrtext,"Kein Zeitvektor 'time' in der eingelesenen daten-Struktur gefunden !!!");
    return status;
  }
  for( i=0;i<SIM_MODUL_SIM_N_INP;i++)
  {
    if( !SimInp[i].found )
    {
      status = NOT_OKAY;
      sprintf_s(errtext,lerrtext,"Kein Vektor '%s' in der eingelesenen daten-Struktur gefunden !!!",SimInp[i].vecname.c_str());
      return status;
    }
  }
#if SIM_MODUL_SIM_N_LOOP_PAR > 0
  if( !SimParTime.found )
  {
    status = NOT_OKAY;
    sprintf_s(errtext,lerrtext,"Kein Zeitvektor 'time' in der eingelesenen parameter-Struktur gefunden (notwendig, da type = ''single'' verwendet!!!");
    return status;
  }
#endif
  for( i=0;i<SIM_MODUL_SIM_N_PAR;i++)
  {
    if( !SimPar[i].found )
    {
      status = NOT_OKAY;
      sprintf_s(errtext,lerrtext,"Kein Vektor '%s' in der eingelesenen parameter-Struktur gefunden !!!",SimPar[i].vecname.c_str());
      return status;
    }
  }
  // Parameter vor Initialisierung setzen
  //=====================================
  if( sim_MODUL_SIM_par_init0(errtext,lerrtext) != OKAY) return NOT_OKAY;

  /* Fkt - initialisierung */
  /*======================*/
  if( fkt_MODUL_SIM_init(errtext,lerrtext) != OKAY ) return NOT_OKAY;

  // Parameter nach Initialisierung setzen
  //======================================
  if( sim_MODUL_SIM_par_init1(errtext,lerrtext) != OKAY) return NOT_OKAY;

  return status;
}
status_t sim_MODUL_SIM(char *errtext,size_t lerrtext)
{

  size_t  TimeCounter;
#if SIM_MODUL_SIM_N_LOOP_PAR > 0
  size_t  TimeParCounter=0;
#define DELTA_T_TIME_PAR_ADD (1.e-6)
#endif
  double   time;

  for(TimeCounter=0;TimeCounter<SimInpTime.ntime;TimeCounter++)
  {
    time = SimInpTime.ptime[TimeCounter];
    if( time >= SimDebugTime )
    {
      char a;
      a = 0;
    }
/*##FUNCTION_CODE_MODUL_TIMESTOP_START##*/
/*##FUNCTION_CODE_MODUL_TIMESTOP_END##*/

    if( sim_MODUL_SIM_inp_loop(TimeCounter,errtext,lerrtext) != OKAY )
    {
       return NOT_OKAY;
    }

	/* konstante Parameterwerte */
    if( sim_MODUL_SIM_par_perm(errtext,lerrtext) != OKAY )
    {
       return NOT_OKAY;
    }

	/* Loop-weise sich ändernde Parameterwerte */
#if SIM_MODUL_SIM_N_LOOP_PAR > 0
    if( (TimeParCounter < SimParTime.ntime) && (SimParTime.ptime[TimeParCounter] <= (time+DELTA_T_TIME_PAR_ADD)) )
    {
      if( sim_MODUL_SIM_par_loop(TimeParCounter,errtext,lerrtext) != OKAY ) return NOT_OKAY;
      ++TimeParCounter;
    }
#endif

    /* Loop-Aufruf */
    if( fkt_MODUL_SIM_loop(errtext,lerrtext) != OKAY )
    {
       return NOT_OKAY;
    }

    if( sim_MODUL_SIM_out_loop(&time,errtext,lerrtext) != OKAY )
    {
       return NOT_OKAY;
    }

  }
  return OKAY;
}
/* ***********************************************************************/ /*!
  @fn               status_t sim_MODUL_SIM_inp_loop(size_t itime,char *errtext,size_t lerrtext)

  @brief            Output nach der loop ...;

  @desription

  @return           status = OKAY

  @pre

  @post

  @author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t sim_MODUL_SIM_inp_loop(size_t itime,char *errtext,size_t lerrtext)
{
  /*##MODUL_SIM_START_INP_LOOP##*/
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
  /*##MODUL_SIM_END_INP_LOOP##*/

  return OKAY;
}
/* ***********************************************************************/ /*!
  @fn               status_t sim_MODUL_SIM_par_perm(char *errtext,size_t lerrtext)

  @brief            Parameter während der loop aber konstant

  @desription

  @return           status = OKAY

  @pre

  @post

  @author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t sim_MODUL_SIM_par_perm(char *errtext,size_t lerrtext)
{
  /*##MODUL_SIM_START_PAR_PERM##*/
  {
    double *pdval;
    /* IQF1_LdwStatus */
    pdval = SimPar[0].pvec[0];
    CAN1InputData.IQFLdwStatus = (unsigned char)(pdval[0] * 1.000000 + 0.000000);
  }
  /*##MODUL_SIM_END_PAR_PERM##*/
  return OKAY;
}
/* ***********************************************************************/ /*!
  @fn               status_t sim_MODUL_SIM_par_loop(size_t itime,char *errtext,size_t lerrtext)

  @brief            Parameter während der loop ...;

  @desription

  @return           status = OKAY

  @pre

  @post

  @author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t sim_MODUL_SIM_par_loop(size_t itime,char *errtext,size_t lerrtext)
{
  /*##MODUL_SIM_START_PAR_LOOP##*/
  {
    double *pdval;
    size_t ndval,i;
    /* IQF1_LdwStatus */
    pdval = SimPar[0].pvec[0];
    ndval = SimPar[0].nvec[0];
    CAN1InputData.IQFLdwStatus = (unsigned char)(pdval[MIN(itime,ndval-1)] * 1.000000 + 0.000000);
  }
  /*##MODUL_SIM_END_PAR_LOOP##*/
  return OKAY;
}
/* ***********************************************************************/ /*!
  @fn               status_t sim_MODUL_SIM_par_init0(char *errtext,size_t lerrtext)

  @brief            Parameter vor initialisierung ...;

  @desription

  @return           status = OKAY

  @pre

  @post

  @author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t sim_MODUL_SIM_par_init0(char *errtext,size_t lerrtext)
{
  /*##MODUL_SIM_START_PAR_INIT0##*/
  /*##MODUL_SIM_END_PAR_INIT0##*/
  return OKAY;
}
/* ***********************************************************************/ /*!
  @fn               status_t sim_MODUL_SIM_par_init1(char *errtext,size_t lerrtext)

  @brief            Parameter nach Initialisierung ...;

  @desription

  @return           status = OKAY

  @pre

  @post

  @author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t sim_MODUL_SIM_par_init1(char *errtext,size_t lerrtext)
{
  /*##MODUL_SIM_START_PAR_INIT1##*/
  /*##MODUL_SIM_END_PAR_INIT1##*/
  return OKAY;
}
/* ***********************************************************************/ /*!
  @fn               status_t sim_MODUL_SIM_out_loop(double *ptime,struct SRecBuf *p_rec_buf,char *errtext,size_t lerrtext)

  @brief            Output nach der loop ...;

  @desription

  @return           status = OKAY

  @pre

  @post

  @author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t sim_MODUL_SIM_out_loop(double *ptime,char *errtext,size_t lerrtext)
{
  /*##MODUL_SIM_START_OUT_LOOP##*/

  /* SIQF_SALaLoIqf1_switchOnIntvL */
  SimOut[0].time.push_back(*ptime);
  SimOut[0].vec.push_back(IQFsimOut.SALaLoIqf1_switchOnIntvL*1.000000+0.000000);
  SimOut[0].comment = "";

  /*##MODUL_SIM_END_OUT_LOOP##*/
  return OKAY;
}
/* ***********************************************************************/ /*!
  @fn               bool sim_MODUL_SIM_get_param(char *param_name,double *pval)

  @brief            Sucht Parameterwert;

  @desription       Sucht Parametername in der Liste SimMod.ParamNames
                    Wenn gefunden, wird der Wert in *pval geschrieben und true zurückgegeben
                    Wenn nicht vorhanden wird false zurückgegeben

  @return           status = OKAY

  @pre

  @post

  @author           Thomas Berthold; 13.03.2014
**************************************************************************** */
bool sim_MODUL_SIM_get_param(char *param_name,double *pval)
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

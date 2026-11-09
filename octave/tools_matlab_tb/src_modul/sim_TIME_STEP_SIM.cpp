/******************************************************************************
* @file  sim_TIME_STEP_SIM.c
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
/*##TIME_STEP_SIM_START_INC##*/
#ifdef __cplusplus
extern "C" {
#endif
#include "iqf.h"
#include "iqf.he"
#ifdef __cplusplus
}
#endif
#include "fkt_TIME_STEP_SIM.h"
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
/*##TIME_STEP_SIM_END_INC##*/


#define SLF_BASIC_BYTE_T_DEFINED
#include "sim_TIME_STEP_SIM.h"
#include "fkt_TIME_STEP_SIM.h"
std::vector<SSimIO> SimInp(SIM_TIME_STEP_SIM_N_INP);
std::vector<SSimIO> SimOut(SIM_TIME_STEP_SIM_N_OUT);
std::vector<SSimIO> SimPar(SIM_TIME_STEP_SIM_N_PAR);

/*****************************************************************************
FUNCTIONS
*****************************************************************************/
bool sim_TIME_STEP_SIM_get_param(char *param_name,double *pval);
status_t sim_TIME_STEP_SIM_inp_loop(double *ptime,char *errtext,size_t lerrtext);
status_t sim_TIME_STEP_SIM_out_loop(double *ptime,char *errtext,size_t lerrtext);
status_t sim_TIME_STEP_SIM_par_perm(char *errtext,size_t lerrtext);
status_t sim_TIME_STEP_SIM_par_loop(double *ptime,char *errtext,size_t lerrtext);
status_t sim_TIME_STEP_SIM_par_init0(char *errtext,size_t lerrtext);
status_t sim_TIME_STEP_SIM_par_init1(char *errtext,size_t lerrtext);
/*****************************************************************************
DECLARATIONS
*****************************************************************************/
SSimMod SimMod;

status_t sim_TIME_STEP_init(char *errtext,size_t lerrtext)
{
	status_t status = OKAY;
  size_t   i;
  //  double   tstart;

  // Input prüfen
  //=============
  for( i=0;i<SIM_TIME_STEP_SIM_N_INP;i++)
  {
    if( !SimInp[i].found )
    {
      status = NOT_OKAY;
      sprintf_s(errtext,lerrtext,"Kein Vektor '%s' in der eingelesenen daten-Struktur gefunden !!!",SimInp[i].vecname.c_str());
      return status;
    }
  }
  for( i=0;i<SIM_TIME_STEP_SIM_N_PAR;i++)
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
  if( !sim_TIME_STEP_SIM_get_param("dt",&(SimMod.dt)) )          SimMod.dt     = SIM_TIME_STEP_MIN_DT;
  
  SimMod.tSim = 0.0;

  // Parameter vor Initialisierung setzen
  //=====================================
  if( sim_TIME_STEP_SIM_par_init0(errtext,lerrtext) != OKAY) return NOT_OKAY;

  /* Fkt - initialisierung */
  /*======================*/
  if( fkt_TIME_STEP_SIM_init(SimMod.dt,errtext,lerrtext) != OKAY ) return NOT_OKAY;

  // Parameter nach Initialisierung setzen
  //======================================
  if( sim_TIME_STEP_SIM_par_init1(errtext,lerrtext) != OKAY) return NOT_OKAY;

  return status;
}
status_t sim_TIME_STEP_loop(char *errtext,size_t lerrtext)
{

  SimMod.tSim += SimMod.dt;


  if( sim_TIME_STEP_SIM_inp_loop(&SimDebugTime,errtext,lerrtext) != OKAY )
  {
      return NOT_OKAY;
  }

	/* konstante Parameterwerte */
  if( sim_TIME_STEP_SIM_par_perm(errtext,lerrtext) != OKAY )
  {
      return NOT_OKAY;
  }

	/* Loop-weise sich ändernde Parameterwerte */
#if SIM_TIME_STEP_SIM_N_LOOP_PAR > 0
  if( sim_TIME_STEP_SIM_par_loop(&SimDebugTime,errtext,lerrtext) != OKAY )
  {
    return NOT_OKAY;
  }
#endif
  if( fkt_TIME_STEP_SIM_loop(errtext,lerrtext) != OKAY )
  {
    return NOT_OKAY;
  }

  return OKAY;
}
status_t sim_TIME_STEP_done(char * , size_t )
{
  return OKAY;
}
/* ***********************************************************************/
/*!
@fn               status_t sim_TIME_STEP_SIM_inp_loop(double *ptime,char *errtext,size_t lerrtext)

@brief            Output nach der loop ...;

@desription

@return           status = OKAY

@pre

@post

@author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t sim_TIME_STEP_SIM_inp_loop(double *ptime,char *errtext,size_t lerrtext)
{
  /*##TIME_STEP_SIM_START_INP_LOOP##*/
  {
    size_t i;

    /* AccelRequest */
    if( SimInp[0].iAct < SimInp[0].n )
    {
      if( (*ptime >= SimInp[0].time[SimInp[0].iAct]) )
      {
        AccelRequest = (float)(SimInp[0].vec[SimInp[0].iAct]);
        ++(SimInp[0].iAct);
      }
    }

    /* AccelActual */
    if( SimInp[1].iAct < SimInp[1].n )
    {
      if( (*ptime >= SimInp[1].time[SimInp[1].iAct]) )
      {
        AccelActual = (float)(SimInp[1].vec[SimInp[1].iAct]);
        ++(SimInp[1].iAct);
      }
    }

    /* VelocityActual */
    if( SimInp[2].iAct < SimInp[2].n )
    {
      if( (*ptime >= SimInp[2].time[SimInp[2].iAct]) )
      {
        VelocityActual = (float)(SimInp[2].vec[SimInp[2].iAct]);
        ++(SimInp[2].iAct);
      }
    }

    /* VelocityActualAbsolute */
    if( SimInp[3].iAct < SimInp[3].n )
    {
      if( (*ptime >= SimInp[3].time[SimInp[3].iAct]) )
      {
        VelocityActualAbsolute = (float)(SimInp[3].vec[SimInp[3].iAct]);
        ++(SimInp[3].iAct);
      }
    }

    /* CurrentGear */
    if( SimInp[4].iAct < SimInp[4].n )
    {
      if( (*ptime >= SimInp[4].time[SimInp[4].iAct]) )
      {
        CurrentGear = (int)(SimInp[4].vec[SimInp[4].iAct]);
        ++(SimInp[4].iAct);
      }
    }

    /* GearSelectorPosition */
    if( SimInp[5].iAct < SimInp[5].n )
    {
      if( (*ptime >= SimInp[5].time[SimInp[5].iAct]) )
      {
        GearSelectorPosition = (unsigned char)(SimInp[5].vec[SimInp[5].iAct]);
        ++(SimInp[5].iAct);
      }
    }

    /* ParkingBrakeOpen */
    if( SimInp[6].iAct < SimInp[6].n )
    {
      if( (*ptime >= SimInp[6].time[SimInp[6].iAct]) )
      {
        ParkingBrakeOpen = (unsigned char)(SimInp[6].vec[SimInp[6].iAct]);
        ++(SimInp[6].iAct);
      }
    }

    /* EngineAxleTorqueActual */
    if( SimInp[7].iAct < SimInp[7].n )
    {
      if( (*ptime >= SimInp[7].time[SimInp[7].iAct]) )
      {
        EngineAxleTorqueActual = (float)(SimInp[7].vec[SimInp[7].iAct]);
        ++(SimInp[7].iAct);
      }
    }

    /* EngineAxleTorqueMin */
    if( SimInp[8].iAct < SimInp[8].n )
    {
      if( (*ptime >= SimInp[8].time[SimInp[8].iAct]) )
      {
        EngineAxleTorqueMin = (float)(SimInp[8].vec[SimInp[8].iAct]);
        ++(SimInp[8].iAct);
      }
    }

    /* EngineAxleTorqueMax */
    if( SimInp[9].iAct < SimInp[9].n )
    {
      if( (*ptime >= SimInp[9].time[SimInp[9].iAct]) )
      {
        EngineAxleTorqueMax = (float)(SimInp[9].vec[SimInp[9].iAct]);
        ++(SimInp[9].iAct);
      }
    }

    /* BrakeAxleTorqueActual */
    if( SimInp[10].iAct < SimInp[10].n )
    {
      if( (*ptime >= SimInp[10].time[SimInp[10].iAct]) )
      {
        BrakeAxleTorqueActual = (float)(SimInp[10].vec[SimInp[10].iAct]);
        ++(SimInp[10].iAct);
      }
    }

    /* StandStillAxleTorqueActual */
    if( SimInp[11].iAct < SimInp[11].n )
    {
      if( (*ptime >= SimInp[11].time[SimInp[11].iAct]) )
      {
        StandStillAxleTorqueActual = (float)(SimInp[11].vec[SimInp[11].iAct]);
        ++(SimInp[11].iAct);
      }
    }

    /* eng_a_kp_inc */
    if( SimInp[12].iAct < SimInp[12].n )
    {
      if( (*ptime >= SimInp[12].time[SimInp[12].iAct]) )
      {
        eng_a_kp_inc = (signed int)(SimInp[12].vec[SimInp[12].iAct]);
        ++(SimInp[12].iAct);
      }
    }

    /* eng_a_kp_dec */
    if( SimInp[13].iAct < SimInp[13].n )
    {
      if( (*ptime >= SimInp[13].time[SimInp[13].iAct]) )
      {
        eng_a_kp_dec = (signed int)(SimInp[13].vec[SimInp[13].iAct]);
        ++(SimInp[13].iAct);
      }
    }

    /* eng_a_ki_inc */
    if( SimInp[14].iAct < SimInp[14].n )
    {
      if( (*ptime >= SimInp[14].time[SimInp[14].iAct]) )
      {
        eng_a_ki_inc = (signed int)(SimInp[14].vec[SimInp[14].iAct]);
        ++(SimInp[14].iAct);
      }
    }

    /* IQF1_LdwStatus */
    if( SimInp[15].iAct < SimInp[15].n )
    {
      if( (*ptime >= SimInp[15].time[SimInp[15].iAct]) )
      {
        eng_a_ki_dec = (signed int)(SimInp[15].vec[SimInp[15].iAct]);
        ++(SimInp[15].iAct);
      }
    }

    /* IQF1_LdwStatus_mBuffer_x */
    if( SimInp[16].iAct < SimInp[16].n )
    {
      if( (*ptime >= SimInp[16].time[SimInp[16].iAct]) )
      {
        eng_a_arw_thres = (signed int)(SimInp[16].vec[SimInp[16].iAct]);
        ++(SimInp[16].iAct);
      }
    }

    /* eng_a_ff_gain */
    if( SimInp[17].iAct < SimInp[17].n )
    {
      if( (*ptime >= SimInp[17].time[SimInp[17].iAct]) )
      {
        eng_a_ff_gain = (signed int)(SimInp[17].vec[SimInp[17].iAct]);
        ++(SimInp[17].iAct);
      }
    }
  }
  /*##TIME_STEP_SIM_END_INP_LOOP##*/

  return OKAY;
}
/* ***********************************************************************/ 
/*!
@fn               status_t sim_TIME_STEP_SIM_par_perm(char *errtext,size_t lerrtext)

@brief            Parameter während der loop aber konstant

@desription

@return           status = OKAY

@pre

@post

@author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t sim_TIME_STEP_SIM_par_perm(char *errtext,size_t lerrtext)
{
  /*##TIME_STEP_SIM_START_PAR_PERM##*/

  /*##TIME_STEP_SIM_END_PAR_PERM##*/
  return OKAY;
}
/* ***********************************************************************/ 
/*!
@fn               status_t sim_TIME_STEP_SIM_par_loop(double *ptime,char *errtext,size_t lerrtext)

@brief            Parameter während der loop ...;

@desription

@return           status = OKAY

@pre

@post

@author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t sim_TIME_STEP_SIM_par_loop(double *ptime,char *errtext,size_t lerrtext)
{
  /*##TIME_STEP_SIM_START_PAR_LOOP##*/
  {
    double *pdval;
    
    /* dt */
    if( (*ptime >= SimPar[0].time[SimPar[0].iAct]) && (SimPar[0].iAct < SimPar[0].n) )
    {
      SimMod.dt = (double)(SimPar[0].vec[SimPar[0].iAct]);
      if( SimPar[0].iAct < SimPar[0].n ) ++(SimPar[0].iAct);
    }
  }
  /*##TIME_STEP_SIM_END_PAR_LOOP##*/
  return OKAY;
}
/* ***********************************************************************/ 
/*!
@fn               status_t sim_TIME_STEP_SIM_par_init0(char *errtext,size_t lerrtext)

@brief            Parameter vor initialisierung ...;

@desription

@return           status = OKAY

@pre

@post

@author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t sim_TIME_STEP_SIM_par_init0(char *errtext,size_t lerrtext)
{
  /*##TIME_STEP_SIM_START_PAR_INIT0##*/
  /*##TIME_STEP_SIM_END_PAR_INIT0##*/
  return OKAY;
}
/* ***********************************************************************/ 
/*!
@fn               status_t sim_TIME_STEP_SIM_par_init1(char *errtext,size_t lerrtext)

@brief            Parameter nach Initialisierung ...;

@desription

@return           status = OKAY

@pre

@post

@author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t sim_TIME_STEP_SIM_par_init1(char *errtext,size_t lerrtext)
{
  /*##TIME_STEP_SIM_START_PAR_INIT1##*/
  /*##TIME_STEP_SIM_END_PAR_INIT1##*/
  return OKAY;
}
/* ***********************************************************************/ 
/*!
@fn               status_t sim_TIME_STEP_SIM_out_loop(double *ptime,struct SRecBuf *p_rec_buf,char *errtext,size_t lerrtext)

@brief            Output nach der loop ...;

@desription

@return           status = OKAY

@pre

@post

@author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t sim_TIME_STEP_SIM_out_loop(double *ptime,char *errtext,size_t lerrtext)
{
  /*##TIME_STEP_SIM_START_OUT_LOOP##*/

  /* SIQF_SALaLoIqf1_switchOnIntvL */
  SimOut[0].time.push_back(*ptime);
  SimOut[0].vec.push_back(EngineAxleTorqueReference);
  SimOut[0].comment = "";
  SimOut[0].isvecofvec = 0;

  /*##TIME_STEP_SIM_END_OUT_LOOP##*/
  SimOut[1].time.push_back(*ptime);
  SimOut[1].vec.push_back(BrakeAxleTorqueReference);
  SimOut[1].comment = "";
  SimOut[1].isvecofvec = 0;
  /*##TIME_STEP_SIM_END_OUT_LOOP##*/
  SimOut[1].time.push_back(*ptime);
  SimOut[1].vec.push_back(BrakeAxleTorqueReference);
  SimOut[1].comment = "";
  SimOut[1].isvecofvec = 0;
  /*##TIME_STEP_SIM_END_OUT_LOOP##*/
  return OKAY;
}
/* ***********************************************************************/ 
/*!
@fn               bool sim_TIME_STEP_SIM_get_param(char *param_name,double *pval)

@brief            Sucht Parameterwert;

@desription       Sucht Parametername in der Liste SimMod.ParamNames
Wenn gefunden, wird der Wert in *pval geschrieben und true zurückgegeben
Wenn nicht vorhanden wird false zurückgegeben

@return           status = OKAY

@pre

@post

@author           Thomas Berthold; 13.03.2014
**************************************************************************** */
bool sim_TIME_STEP_SIM_get_param(char *param_name,double *pval)
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

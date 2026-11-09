/******************************************************************************
 * @file  sim_TIME_STEP_SIM.h
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
#ifndef _SIM_TIME_STEP_SIM_H_INC_
#define _SIM_TIME_STEP_SIM_H_INC_
/*##FUNCTION_CODE_NAMEXYZ_START##*/
/*##FUNCTION_CODE_NAMEXYZ_END##*/

#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <vector>
#define SLF_BASIC_UINT32_T_DEFINED
#include "SlfBasic.h"

#define SIM_TIME_STEP_DEFAULT_DTLOOP  (0.01)
#define SIM_TIME_STEP_DEFAULT_DTOUT   (0.01)
#define SIM_TIME_STEP_DEFAULT_TEND    (10.)
#define SIM_TIME_STEP_MIN_DT          (0.001)

#define SIM_TIME_STEP_MIN(a,b)  (((a) < (b)) ? (a) : (b))
#define SIM_TIME_STEP_MAX(a,b)  (((a) > (b)) ? (a) : (b))


/*##TIME_STEP_SIM_START_H##*/
#define SIM_TIME_STEP_SIM_N_INP 27
#define SIM_TIME_STEP_SIM_N_OUT 105
#define SIM_TIME_STEP_SIM_N_PAR 1
#define SIM_TIME_STEP_SIM_N_LOOP_PAR 0
/*##TIME_STEP_SIM_END_H##*/

#define SIM_TIME_STEP_TYPE_INIT 0
#define SIM_TIME_STEP_TYPE_LOOP 1
#define SIM_TIME_STEP_TYPE_DONE 2

#define SIM_TIME_STEP_DEFAULT_STEP_SIZE 0.01

typedef struct
{
  unsigned long int                n;
  bool                             found;
  bool                             isvecofvec;
  bool                             isstring;
  unsigned long int                iAct;
  std::vector<double>              time;
  std::vector<double>              vec;
  std::vector<std::vector<double>> vecvec;
  std::vector<std::string>         vecstring;
  std::vector<size_t>              nvecvec;
  std::string                      comment;
  std::string                      vecname;
  std::string                      stringval;
}SSimIO;
extern std::vector<SSimIO> SimInp;
extern std::vector<SSimIO> SimOut;
extern std::vector<SSimIO> SimPar;

typedef struct
{
  unsigned char       type;
  double              dt;                            /* dleta Time for Simulation */
  double              tSim;                      /* Startzeit, entweder null oder durch Odometrie-Trajektorienabgleich */
  std::vector<std::string>   ParamNames;             /* Parameternamen aus mex-Eingabe */
  std::vector<double>        ParamValues;            /* Parameterwerte (numerisch) aus mex-Eingabe */


} SSimMod;
extern SSimMod SimMod;

extern char *pSimInpVarNames[];
extern char *pSimInpUnitNames[];
extern char *pSimOutVarNames[];
extern char *pSimOutUnitNames[];
extern char *pSimParVarNames[];
extern char *pSimParUnitNames[];

status_t sim_TIME_STEP_init(char *errtext,size_t lerrtext);
status_t sim_TIME_STEP_loop(char * errtext,size_t lerrtext);
status_t sim_TIME_STEP_done(char * errtext,size_t lerrtext);

#endif

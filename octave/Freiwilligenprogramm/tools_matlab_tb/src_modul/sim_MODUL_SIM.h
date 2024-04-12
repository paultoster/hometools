/******************************************************************************
 * @file  sim_MODUL_SIM.h
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
#ifndef _SIM_MODUL_SIM_H_INC_
#define _SIM_MODUL_SIM_H_INC_
/*##FUNCTION_CODE_NAMEXYZ_START##*/
/*##FUNCTION_CODE_NAMEXYZ_END##*/

#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <vector>

#include "SlfBasic.h"

/*##MODUL_SIM_START_H##*/
#define SIM_MODUL_SIM_N_INP 27
#define SIM_MODUL_SIM_N_OUT 105
#define SIM_MODUL_SIM_N_PAR 1
#define SIM_MODUL_SIM_N_LOOP_PAR 0
/*##MODUL_SIM_END_H##*/
typedef struct
{
  double      *ptime;
  size_t      ntime;
  bool        found;
}SSimInpTime;
extern SSimInpTime SimInpTime;
typedef struct
{
  std::string   vecname;
  bool          found;
  bool          isvecofvec;
  size_t        ncells;
  std::vector<double*> pvec;
  std::vector<size_t>  nvec;
}SSimInp;
extern SSimInp SimInp[SIM_MODUL_SIM_N_INP];
typedef struct
{
  double      *ptime;
  size_t      ntime;
  bool        found;
}SSimParTime;
extern SSimParTime SimParTime;
typedef struct
{
  std::string   vecname;
  bool          found;
  bool          isvecofvec;
  size_t        ncells;
  std::vector<double*> pvec;
  std::vector<size_t>  nvec;
}SSimPar;
extern SSimPar SimPar[SIM_MODUL_SIM_N_PAR];
typedef struct
{
  std::vector<double>              time;
  std::vector<double>              vec;
  bool                             isvecofvec;
  std::vector<std::vector<double>> vecvec;
  std::string                      comment;
}SSimOut;
extern SSimOut SimOut[SIM_MODUL_SIM_N_OUT];

typedef struct
{
  double              tstart;                        /* Startzeit, entweder null oder durch Odometrie-Trajektorienabgleich */
  double              tend;                          /* Endzeit                     */
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

status_t sim_MODUL_SIM_init(char *errtext,size_t lerrtext);
status_t sim_MODUL_SIM(char * errtext,size_t lerrtext);

#endif

/******************************************************************************
 * @file  sim_YMODUL_SIM.h
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
#ifndef _SIM_YMODUL_SIM_H_INC_
#define _SIM_YMODUL_SIM_H_INC_
/*##FUNCTION_CODE_NAMEXYZ_START##*/
/*##FUNCTION_CODE_NAMEXYZ_END##*/

#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <vector>

#include "SlfBasic.h"

#define SIM_YMODUL_DEFAULT_DTLOOP  (0.01)
#define SIM_YMODUL_DEFAULT_DTOUT   (0.01)
#define SIM_YMODUL_DEFAULT_TEND    (10.)
#define SIM_YMODUL_MIN_DT          (0.001)

#define SIM_YMODUL_MIN(a,b)  (((a) < (b)) ? (a) : (b))
#define SIM_YMODUL_MAX(a,b)  (((a) > (b)) ? (a) : (b))


/*##YMODUL_SIM_START_H##*/
#define SIM_YMODUL_SIM_N_OUT 105
/*##YMODUL_SIM_END_H##*/
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
extern std::vector<SSimIO> SimOut;

typedef struct
{
  double              tstart;                        /* Startzeit, entweder null oder durch Odometrie-Trajektorienabgleich */
  double              tend;                          /* Endzeit                     */
  double              dtloop;                        /* Loopzeit Funktion           */
  double              dtout;                         /* Loopzeit Ausgabe            */
  double              dt;                            /* minimal Loopzeit            */
  size_t              nloop;                         /* ANzahl der Loops mit dt     */
  std::vector<std::string>   ParamNames;             /* Parameternamen aus mex-Eingabe */
  std::vector<double>        ParamValues;            /* Parameterwerte (numerisch) aus mex-Eingabe */


} SSimMod;
extern SSimMod SimMod;

extern char *pSimOutVarNames[];
extern char *pSimOutUnitNames[];

status_t sim_YMODUL_SIM_init(char *errtext,size_t lerrtext);
status_t sim_YMODUL_SIM(char * errtext,size_t lerrtext);

#endif

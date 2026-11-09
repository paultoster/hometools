/******************************************************************************
 * @file  fkt_EMODUL_SIM.h
 *
 * @author  Thomas Berthold
 * @date    03/3/2014
 *
 * @brief Declaration Funtionen Simulation of VPU
 *
 * @subversion_tags (not part of doxygen)
 *   $LastChangedBy: berthold $
 *   $LastChangedRevision: 38987 $
 *   $LastChangedDate: 2014-02-06 15:49:32 +0100 (Do, 06 Feb 2014) $
 *   $URL: http://frd2ahjg/svn/tze/Departments/EnvironmentPerception/Components/ArbiDev2PathTask/src/Application/ArbiDev2PathMain.cpp $
******************************************************************************/
#ifndef _FKT_SIM_MOD_H_INC_
#define _FKT_SIM_MOD_H_INC_
/*##FKT_START_H_FILE_CODE##*/
/*##FKT_END_H_FILE_CODE##*/
/*****************************************************************************
  INCLUDES
*****************************************************************************/
#include "SlfBasic.h"

/*****************************************************************************
  FUNCTIONS
*****************************************************************************/
#ifdef __cplusplus
extern "C" {
#endif
status_t fkt_EMODUL_SIM_init(double dt,char *errtext,size_t lerrtext);
status_t fkt_EMODUL_SIM_loop(char *errtext,size_t lerrtext);
status_t fkt_EMODUL_SIM_end(char *errtext,size_t lerrtext);
#ifdef __cplusplus
}
#endif

#endif

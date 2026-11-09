/******************************************************************************
 * @file  fkt_VPU_CAN_SIM.h
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
#ifndef _FKT_VPU_CAN_SIM_H_INC_
#define _FKT_VPU_CAN_SIM_H_INC_
/*##FUNCTION_CODE_MODUL_NAMEXYZ_START##*/
/*##FUNCTION_CODE_MODUL_NAMEXYZ_END##*/

/*****************************************************************************
  INCLUDES
*****************************************************************************/
#include "SlfBasic.h"
#include "ReadCanAscii.h"
/*****************************************************************************
  FUNCTIONS
*****************************************************************************/
#ifdef __cplusplus
extern "C" {
#endif
status_t fkt_VPU_CAN_SIM_init(double dt,char *errtext,size_t lerrtext);
status_t fkt_VPU_CAN_SIM_loop(char *errtext,size_t lerrtext);
status_t can_receive_VPU_CAN_SIM(struct SRecBuf *p_rec_buf,char *errtext,size_t lerrtext);
status_t fkt_VPU_CAN_SIM_end(char *errtext,size_t lerrtext);
#ifdef __cplusplus
}
#endif


#endif

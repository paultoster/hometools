/******************************************************************************
 * @file  fkt_TIME_STAMP_SIM.c
 *
 * @author  Thomas Berthold
 * @date    03/3/2014
 *
 * @brief Funtionen Simulation of VPU
 *
 * @subversion_tags (not part of doxygen)
 *   $LastChangedBy: berthold $
 *   $LastChangedRevision: 38987 $
 *   $LastChangedDate: 2014-02-06 15:49:32 +0100 (Do, 06 Feb 2014) $
 *   $URL: http://frd2ahjg/svn/tze/Departments/EnvironmentPerception/Components/ArbiDev2PathTask/src/Application/ArbiDev2PathMain.cpp $
******************************************************************************/

/*****************************************************************************
  INCLUDES
*****************************************************************************/
/* in SlfBasic.h wird typedef byte_t ausgeschaltet */
#define SLF_BASIC_BYTE_T_DEFINED
#include "fkt_TIME_STEP_SIM.h"
#include "stdio.h"

/*##FKT_START_INCLUDE##*/
/*##FKT_END_INCLUDE##*/
/*****************************************************************************
  FUNCTIONS
*****************************************************************************/

/*****************************************************************************
  DECLARATIONS
*****************************************************************************/
/* ***********************************************************************/ /*!
  @fn               status_t fkt_SIM_MOD_init(char *errtext,size_t lerrtext)

  @brief            Init  CAN Interface and ...;

  @desription

  @return           status = OKAY

  @pre

  @post

  @author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t fkt_TIME_STEP_SIM_init(double dt,char *errtext,size_t lerrtext)
{
/*##FKT_START_INIT_FUNCTION_CALL##*/
/*##FKT_END_INIT_FUNCTION_CALL##*/
  return OKAY;
}
/* ***********************************************************************/ /*!
  @fn               status_t fkt_SIM_MOD_loop(char *errtext,size_t lerrtext)

  @brief            Init  CAN Interface and ...;

  @desription

  @return           status = OKAY

  @pre

  @post

  @author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t fkt_TIME_STEP_SIM_loop(char *errtext,size_t lerrtext)
{
/*##FKT_START_LOOP_FUNCTION_CALL##*/
/*##FKT_END_LOOP_FUNCTION_CALL##*/
  return OKAY;
}
/* ***********************************************************************/ /*!
  @fn               status_t fkt_SIM_MOD_end(char *errtext,size_t lerrtext)

  @brief            Init  CAN Interface and ...;

  @desription

  @return           status = OKAY

  @pre

  @post

  @author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t fkt_TIME_STEP_SIM_end(char *errtext,size_t lerrtext)
{
/*##FKT_START_END_FUNCTION_CALL##*/
/*##FKT_END_END_FUNCTION_CALL##*/
  return OKAY;
}
/*##FKT_START_ADD_CODE##*/
/*##FKT_END_ADD_CODE##*/
/******************************************************************************
 * @file  fkt_VPU_CAN_SIM.c
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
/*##FKT_START_INCLUDE##*/
/*##FKT_END_INCLUDE##*/

/*****************************************************************************
  INCLUDES
*****************************************************************************/
/* in SlfBasic.h wird typedef byte_t ausgeschaltet */
#define SLF_BASIC_BYTE_T_DEFINED
#include "glob_type.he"
#include "can_inc.h"
#include "can.h"
#include "fct.he"
#include "fkt_VPU_CAN_SIM.h"
#include "stdio.h"
/*****************************************************************************
  FUNCTIONS
*****************************************************************************/
canuint8 CanHL_ReceivedRxHandle( CAN_CHANNEL_CANTYPE_FIRST CanReceiveHandle rxHandle );
void ACTLCanProcessing(void);
void CANVarInit(void);
/*****************************************************************************
  DECLARATIONS
*****************************************************************************/
/* ***********************************************************************/ /*!
  @fn               status_t fkt_VPU_CAN_SIM_init(char *errtext,size_t lerrtext)

  @brief            Init  CAN Interface and ...;

  @desription

  @return           status = OKAY

  @pre

  @post

  @author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t fkt_VPU_CAN_SIM_init(double dt,char *errtext,size_t lerrtext)
{

 /*##FKT_START_INIT_FUNCTION_CALL##*/
 /*##FKT_END_INIT_FUNCTION_CALL##*/
 /* Init Initialisierung der CAN-Größen LowLevel,                      */
  /* aber nur FiFo (der andere Teil von CANInitLL();ist hardware näher) */
  CANInitFiFo();

  /* High-Level */
  CANInitHL();
  
  /* CAN-Variablen initialisieren */
  CANVarInit();

  return OKAY;
}
/* ***********************************************************************/ /*!
  @fn               status_t can_receive_VPU_CAN_SIM(struct SRecBuf *p_rec_buf,char *errtext,size_t lerrtext)

  @brief            CAN Interface for one CAN-message;

  @desription

  @return           status = OKAY

  @pre

  @post

  @author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t can_receive_VPU_CAN_SIM(struct SRecBuf *p_rec_buf,char *errtext,size_t lerrtext)
{
  ui8_t            channel;
  ui16_t           i;
  ui8_t            chipMsgObj[10] = {0,0,0,0,0,0,0,0,0,0};
  size_t           ival;

  /* Channel */
  /*---------*/
  if( p_rec_buf->channel == 1 ) channel = kCanIndex0;
  else                          channel = kCanIndex1;

  canRxInfoStruct[channel].Channel = channel;
  /*##FUNCTION_CODE_RECEIVE_VPU_CAN_SIM_START##*/
  /*##FUNCTION_CODE_RECEIVE_VPU_CAN_SIM_END##*/
  /* Search Handle with Id */
  /*-----------------------*/
  canRxInfoStruct[channel].Handle = kCanRxHandleNotUsed;
  ival = p_rec_buf->id + channel * 0x800;
  for(i=0;i<kHashSearchListCount;i++)
  {
    if( CanRxHashId[i] == ival )
    {
      canRxInfoStruct[channel].Handle = CanRxMsgIndirection[i];
      break;
    }
  }
  if( canRxInfoStruct[channel].Handle != kCanRxHandleNotUsed )
  {
    //sprintf_s(errtext,lerrtext,"Id = <%i> aus Messung konnte nicht in CanRxHashId[] gefunden werden",p_rec_buf->id);
    //return NOT_OK;

    /* CAN-Message-Data */
    /*------------------*/
    canRxInfoStruct[channel].pChipData   = p_rec_buf->data;

    /* DLC */
    /* In ((canuint8)(*(rxStruct->pChipMsgObj+5) & 0xf)) ist die tatsächliche eingelesene DLC-Länge */
    /* Wird hier auf die Soll-Länge gesetzt CanGetRxDataLen(canRxInfoStruct[channel].Handle)        */

    chipMsgObj[5] = CanGetRxDataLen(canRxInfoStruct[channel].Handle);
    canRxInfoStruct[channel].pChipMsgObj = chipMsgObj;

    /* sonstiges */
    /*-----------*/
    canRxInfoStruct[channel].EcuNumber = 0;
    canRxInfoStruct[channel].idType    = 0;

    CanHL_ReceivedRxHandle(channel,canRxInfoStruct[channel].Handle);

  }
  return OKAY;
}
/* ***********************************************************************/ /*!
  @fn               status_t fkt_VPU_CAN_SIM_loop(char *errtext,size_t lerrtext)

  @brief            Init  CAN Interface and ...;

  @desription

  @return           status = OKAY

  @pre

  @post

  @author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t fkt_VPU_CAN_SIM_loop(char *errtext,size_t lerrtext)
{
  /* CAN-Processing */
  CANProcessRxCh0();
  CANProcessRxCh1();

  /*##FKT_START_LOOP_FUNCTION_CALL##*/
  /*##FKT_END_LOOP_FUNCTION_CALL##*/
  return OKAY;
}
/* ***********************************************************************/ /*!
  @fn               status_t fkt_VPU_CAN_SIM_end(char *errtext,size_t lerrtext)

  @brief            Init  CAN Interface and ...;

  @desription

  @return           status = OKAY

  @pre

  @post

  @author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t fkt_VPU_CAN_SIM_end(char *errtext,size_t lerrtext)
{
/*##FKT_START_END_FUNCTION_CALL##*/
/*##FKT_END_END_FUNCTION_CALL##*/
  return OKAY;
}
/*##FKT_START_ADD_CODE##*/
/*##FKT_END_ADD_CODE##*/
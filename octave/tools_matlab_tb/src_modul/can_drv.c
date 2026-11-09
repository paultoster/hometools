/* Kernbauer Version: 1.09 Konfiguration: can_driver Erzeugungsgangnummer: 817 */

/* STARTSINGLE_OF_MULTIPLE */


/*****************************************************************************
| Project Name: C A N - D R I V E R
|    File Name: CAN_DRV.C
|
|  Description: Implementation of the CAN driver
|               Target systems: Renesas M32R
|               Compiler:       Mitsubishi
|               Compiler:       Gaio
|-----------------------------------------------------------------------------
|               C O P Y R I G H T
|-----------------------------------------------------------------------------
| Copyright (c) 1996-2001 by Vector Informatik GmbH.       All rights reserved.
|
| This software is copyright protected and proprietary to Vector Informatik GmbH.
| Vector Informatik GmbH grants to you only those rights as set out in the license
| conditions. All other rights remain with Vector Informatik GmbH.
|
|-----------------------------------------------------------------------------
|               A U T H O R   I D E N T I T Y
|-----------------------------------------------------------------------------
| Initials     Name                      Company
| --------     ---------------------     -------------------------------------
| Ht           Heike Honert              Vector Informatik GmbH
| Vg           Frank Voorburg            Vector Informatik GmbH
| Et           Thomas Ebert              Vector Informatik GmbH
| Ces          Senol Cendere             Vector Informatik GmbH
|-----------------------------------------------------------------------------
|               R E V I S I O N   H I S T O R Y
|-----------------------------------------------------------------------------
| Date       Version  Author Description
| ---------- -------  ------ --------------------------------------------------
| 2003-07-18 1.00.00  Vg     - implementation for Mitsubishi M32R
| 2004-07-26 1.01.00  Et     - ESCAN00008957: support derivative M32173 (C_SINGLE_RECEIVE_CHANNEL)
|                            - CANdrv HL V1.29.xx migration
|                            - ESCAN00009076: extended ID reception in BasicCAN
|                            - ESCAN00009085: reject remote frames
|                            - ESCAN00009086: CanStop: abort pending Tx request
| 2004-12-06 1.02.00  Et     - ESCAN00010512: loss of Tx message confirmation and Rx message indication
| 2005-01-21 1.03.00  Et     - no changes (s. CAN_DRV.C)
| 2005-07-03 1.04.00  Ces    - ESCAN00012507: support multi channel configuration
|                            - ESCAN00012508: support GAIO compiler/linker
| 2005-07-14 1.05.00  Ces    - ESCAN00012755: new macro CanCauseOfError() to read register CAN0EF/CAN1CEF
|                            - ESCAN00012766: copy timestamp of received messages to buffer
|                            - ESCAN00012907: inconsistency in CAN interrupt disable status
| 2005-07-27 1.06.00  Ces    - ESCAN00013057: added macro MK_STDID_LO_EXT
| 2005-08-22 1.07.00  Ces    - ESCAN00013216: check kCanNumberOfChannels to verify C_CAN_BASE_ADR
|                            - ESCAN00013255: added assertion-condition for M32192
| 2005-08-26 1.08.00  Ces    - ESCAN00013333: replaced kCanNumberOfChannels in ROM tables
| 2005-09-16 1.09.00  Ces    - ESCAN00013499: support transmit abort feature (cancel in hardware)
| 2005-11-24 1.10.00  Ces    - ESCAN00014332: condition of cancel in hardware feature is always false
| 2005-11-25 1.11.00  Ces    - ESCAN00014407: added cast for macros CanRxActualData, CanRxActualDLC and CanRxActualIdType
| 2006-02-20 1.12.00  Ces    - ESCAN00015419: adapted macro CanRxActualData for compiler GAIO
| 2006-02-28 1.13.00  Ces    - ESCAN00015476: support feature multi ECU configuration
|***************************************************************************/
/*****************************************************************************
|
|    ************    Version and change information of      **********
|    ************    high level part only                   **********
|
|    Please find the version number of the whole module in the previous
|    File header.
|
|-----------------------------------------------------------------------------
|               A U T H O R   I D E N T I T Y
|-----------------------------------------------------------------------------
| Initials     Name                      Company
| --------     ---------------------     -------------------------------------
| Ht           Heike Honert              Vector Informatik GmbH
| Pl           Georg Pfluegel            Vector Informatik GmbH
| Vg           Frank Voorburg            Vector CANtech, Inc.
| An           Ahmad Nasser              Vector CANtech, Inc.
| Ml           Patrick Markl             Vector Informatik GmbH
|-----------------------------------------------------------------------------
|               R E V I S I O N   H I S T O R Y
|-----------------------------------------------------------------------------
| Date       Ver  Author  Description
| ---------  ---  ------  ----------------------------------------------------
| 19-Jan-01  0.02  Ht     - derived form C16x V3.3
| 18-Apr-01  1.00  Pl     - derived for ARM7 TDMI
| 02-May-01  1.01  Ht     - adaption to LI1.2
|                         - change from code doupling to indexed
| 31-Oct-01  1.02  Ht     - support hash search
|                  Ht     - optimisation for message access (hardware index)
|                  Vg     - adaption for PowerPC
| 07-Nov-01  1.03  Ht     - remove some comments
|                         - support of basicCAN polling extended
| 12-Dez-01  1.04  Ht     - avoid compiler warnings for KEIL C166
|                         - ESCAN00001881: warning in CanInitPowerOn
|                         - ESCAN00001913: call of CanLL_TxEnd()
|                  Fz     - ESCAN00001914: CanInterruptRestore changed for M32C
| 02-Jan-02  1.05  Ht     - ESCAN00002009: support of polling mode improved
|                         - ESCAN00002010: Prototype of CanHL_TxConfirmation()
|                                          not available in every case.
| 12-Feb-02  1.06 Pl      - ESCAN00002279: - now it is possible to use only the error-task without the tx-task
|                                          - support of the makro  REENTRANT
|                                          - support of the makro C_HL_ENABLE_RX_INFO_STRUCT_PTR
|                                          - For better performance for the T89C51C there is a switch-case
|                                            instruction for direct call of the PreTransmitfunction
|                                          - add C_ENABLE_RX_BASICCAN_POLLING in CanInitPowerOn
| 18-Mai-02  1.07 Ht      - ESCAN....    : support Hash search with FullCAN controller
|                         - ESCAN00002707: Reception could went wrong if IL and Hash Search
|                         - ESCAN00002893: adaption to LI 1.3
| 29-Mai-02  1.08 Ht      - ESCAN00003028: Transmission could fail in Polling mode
|                         - ESCAN00003082: call Can_LL_TxEnd() in CanMsgTransmit()
|                         - ESCAN00003083: Hash search with extended ID
|                         - ESCAN00003084: Support C_COMP_METROWERKS_PPC
|                         - ESCAN00002164: Temporary vaiable "i" not defined in function CanBasicCanMsgReceived
|                         - ESCAN00003085: support C_HL_ENABLE_IDTYPE_IN_ID
| 25-Jun     1.08.01 Vg   - Declared localInterruptOldFlag in CanRxTask()
|                         - Corrected call to CanWakeUp for multichannel
| 11-Jul-02  1.08.02 Ht   - ESCAN00003203: Hash Search routine does not work will with extended IDs
|                         - ESCAN00003205: Support of ranges could went wrong on some platforms
| 08-Aug-02  1.08.03 Ht   - ESCAN00003447: Transmission without databuffer and pretransmit-function
| 08-Aug-02  1.08.04 An   - Added support to Green Hills
| 09-Sep-02  1.09    Ht   - ESCAN00003837: code optimication with KernelBuilder
|                         - ESCAN00004479: change the place oft the functioncall of CanLL_TxCopyMsgTransmit
|                                          in CanMsgTransmit
| 2002-12-06 1.10    Ht   -                Support consistancy for polling tasks
|                         - ESCAN00004567: Definiton of NULL pointer
|                         -                remove include of string.h
|                         -                support Dummy functions for indirect function call
|                         -                optimization for one single Tx mail box
| 2003-02-04 1.11    Ht   -                optimization for polling mode
| 2003-03-19 1.12    Ht   - ESCAN00005152: optimization of CanInit() in case of Direct Tx Objects
|                         - ESCAN00005143: CompilerWarning about function prototype
|                                          CanHL_ReceivedRxHandle() and CanHL_IndRxHandle
|                         - ESCAN00005130: Wrong result of Heash Search on second or higher channel
| 2003-05-12 1.13    Ht   - ESCAN00005624: support CantxMsgDestroyed for multichannel system
|                         - ESCAN00005209: Support confirmation and indication flags for EasyCAN4
|                         - ESCAN00004721: Change data type of Handle in CanRxInfoStruct
| 2003-06-18 1.20   Ht    - ESCAN00005908: support features of RI1.4
|                         - ESCAN: Support FJ16LX-Workaround for multichannel system
|                         - ESCAN00005671: Dynamic Transmit Objects: ID in extended ID frames is wrong
|                         - ESCAN00005863: Notification about cancelation failes in case of CanTxMsgDestroyed
| 2003-06-30 1.21   Ht   - ESCAN00006117: Common Confirmation Function: Write access to wrong memory location
|                        - ESCAN00006008: CanCanInterruptDisable in case of polling
|                        - ESCAN00006118: Optimization for Mixed ID and ID type in Own Register or ID type in ID Register
|                        - ESCAN00006100: transmission with wrong ID in mixed ID mode
|                        - ESCAN00006063: Undesirable hardware dependency for
|                                         CAN_HL (CanLL_RxBasicTxIdReceived)
| 2003-09-10 1.22   Ht   - ESCAN00006853: Support V_MEMROM0
|                        - ESCAN00006854: suppress some Compiler warnings
|                        - ESCAN00006856: support CanTask if only Wakeup in polling mode
|                        - ESCAN00006857: variable newDLC not defined in case of Variable DataLen
| 2003-10-14 1.23   Ht   - ESCAN00006858: support BrsTime for internal runtime measurement
|                        - ESCAN00006860: support Conditional Msg Receive
|                        - ESCAN00006865: support "Cancel in HW" with CanTask
|                        - ESCAN00006866: support Direct Tx Objects
|                        - ESCAN00007109: support new memory qualifier for const data and pointer to const
| 2004-01-05 1.24   Ml   - ESCAN00007206: resolved preprocessor error for Hitachi compiler
|                   Ml   - ESCAN00007254: several changes
| 2004-02-06 1.25   Ml   - ESCAN00007281: solved compilerwarning
|                   Ml   - removed compiler warnings
| 2004-02-21 1.26   Ml   - ESCAN00007670: CAN RAM check
|                   Ml   - ESCAN00007671: fixed dyn Tx object issue
|                   Ml   - ESCAN00007764: added possibility to adjust Rx handle in LL drv
|                   Ml   - ESCAN00007681: solved compilerwarning in CanHL_IndRxHandle
|                   Ml   - ESCAN00007272: solved queue transmission out of LowLevel object
|                   Ml   - ESCAN00008064: no changes
| 2004-04-16 1.27   Ml   - ESCAN00008204: no changes
|                   Ml   - ESCAN00008160: no changes
|                   Ml   - ESCAN00008266: changed name of parameter of function CanTxGetActHandle
|                   Fz   - ESCAN00008272: Compiler error due to missing array canPollingTaskActive
| 2004-05-10 1.28   Fz   - ESCAN00008328: Compiler error if cancel in hardware is active
|                        - ESCAN00008363: Hole closed when TX in interrupt and cancel in HW is used
|                        - ESCAN00008365: Switch C_ENABLE_APPLCANPREWAKEUP_FCT added
|                        - ESCAN00008391: Wrong parameter macro used in call of
|                                         CanLL_WakeUpHandling
| 2004-05-24 1.29   Ht   - ESCAN00008441: Interrupt not restored in case of internal error if TX Polling is used
| 2004-09-21 1.30   Ht   - ESCAN00008914: CAN channel may stop transmission for a certain time
|                        - ESCAN00008824: check of reference implementation version added
|                        - ESCAN00008825: No call of ApplCanMsgCancelNotification during CanInit()
|                        - ESCAN00008826: Support asssertions for "Conditional Message Received"
|                   Ml   - ESCAN00008752: Added function qualifier macros
|                   Ht   - ESCAN00008823: compiler error due to array size 0
|                        - ESCAN00008977: label without instructions
|                        - ESCAN00009485: Message via Normal Tx Object will not be sent
|                        - ESCAN00009497: support of CommonCAN and RX queue added
|                        - ESCAN00009521: Inconsitancy in total polling mode
| 2004-09-28 1.31   Ht   - ESCAN00009703: unresolved functions CAN_POLLING_IRQ_DISABLE/RESTORE()
| 2004-11-25 1.32   Ht   - move fix for ESCAN00007671 to CAN-LL of DrvCan_MpcToucanHll
|                        - ESCAN00010350: Dynamic Tx messages are send always with Std. ID
|                        - ESCAN00010388: ApplCanMsgConfirmed will only be called if realy transmitted
|                    Ml  - ESCAN00009931: The HardwareLoopCheck should have a channelparameter in multichannel systems.
|                    Ml  - ESCAN00010093: lint warning: function type inconsistent "CanCheckMemory"
|                    Ht  - ESCAN00010811: remove Misra and compiler warnings
|                        - ESCAN00010812: support Multi ECU
|                        - ESCAN00010526: CAN interrupts will be disabled accidently
|                        - ESCAN00010584: ECU may crash or behave strange with Rx queue active
| 2005-01-20 1.33    Ht  - ESCAN00010877: ApplCanMsgTransmitConf() is called erronemous
| 2005-03-03 1.34    Ht  - ESCAN00011139: Improvement/Correction of C_ENABLE_MULTI_ECU_CONFIG
|                        - ESCAN00011511: avoid PC-Lint warnings
|                        - ESCAN00011512: copy DLC in case of variable Rx Datalen
|                        - ESCAN00010847: warning due to missing brakets in can_par.c at CanChannelObject
| 2005-05-23 1.35   Ht   - ESCAN00012445: compiler error "V_MEMROMO undefined"in case of multi ECU
|                        - ESCAN00012350: Compiler Error "Illegal token channel"
| 2005-07-06 1.36   Ht   - ESCAN00012153: Compile Error: missing declaration of variable i
|                        - ESCAN00012460: Confirmation of LowLevel message will run into assertion (C_ENABLE_MULTI_ECU_PHYS enabled)
|                        - support Testpoints for CanTestKit
| 2005-07-14 1.37   Ht   - ESCAN00012892: compile error due to missing logTxObjHandle
|                        - ESCAN00012998: Compile Error: missing declaration of txHandle in CanInit()
|                        - support Testpoints for CanTestKit for FullCAN controller
| 2005-10-05 1.38   Ht   - ESCAN00013597: Linker error: Undefined symbol 'CanHL_IndRxHandle'
| 2005-11-10 1.39.00 Ht  - ESCAN00014331 : Compile error due to missing 'else' in function CanTransmit
|
|    ************    Version and change information of      **********
|    ************    high level part only                   **********
|
|    Please find the version number of the whole module in the previous
|    File header.
|
|***************************************************************************/

#define C_DRV_INTERNAL

/***************************************************************************/
/* Include files                                                           */
/***************************************************************************/

#include "can_inc.h"


/***************************************************************************/
/* Version check                                                           */
/***************************************************************************/
#if(DRVCAN_M32RCANMODULEHLL_VERSION != 0x0113)
# error "Source and Header file are inconsistent!"
#endif
#if(DRVCAN_M32RCANMODULEHLL_RELEASE_VERSION != 0x00)
# error "Source and Header file are inconsistent!"
#endif

#if( C_VERSION_REF_IMPLEMENTATION != 0x140)
# error "Generated Data and CAN driver source file are inconsistent!"
#endif

#if( DRVCAN__COREHLL_VERSION != 0x0139)
# error "Source and Header file are inconsistent!"
#endif
#if( DRVCAN__COREHLL_RELEASE_VERSION != 0x00)
# error "Source and Header file are inconsistent!"
#endif


/***************************************************************************/
/* Defines                                                                 */
/***************************************************************************/

#if !defined(NULL)
# define NULL ((void *)0)
#endif

/* ##RI-1.1: Object parameters for Tx-Observe functions */
/* status of transmit objects */
#define kCanBufferFree            ((CanTransmitHandle)0xFFFFFFFFU)   /* mark a transmit object is free */
#define kCanBufferCancel          ((CanTransmitHandle)0xFFFFFFFEU)   /* mark a transmit object as canceled */
#define kCanBufferMsgDestroyed    ((CanTransmitHandle)0xFFFFFFFDU)   /* mark a transmit object as destroyed */
/* reserved value because of definition in header:    0xFFFFFFFCU */
/* valid transmit message handle:   0x0 to kCanNumberOfTxObjects   */

/* return values */
#define kCanHlFinishRx            ((canuint8)0x00)
#define kCanHlContinueRx          ((canuint8)0x01)

#if (kCanNumberOfChannels == 1)
# if !defined (C_CAN_BASE_ADR_A)
#  error "CAN base address is not defined!"
# else
#  if ((C_CAN_BASE_ADR_A != 0x00801000) && (C_CAN_BASE_ADR_A != 0x00801400))
#   error "Invalid CAN base address defined!"
#  endif
# endif
#endif

#if (kCanNumberOfChannels == 2)
# if !defined (C_CAN_BASE_ADR_A)
#  error "CAN base address A is not defined!"
# else
#  if ((C_CAN_BASE_ADR_A != 0x00801000) && (C_CAN_BASE_ADR_A != 0x00801400))
#   error "Invalid CAN base address A defined!"
#  endif
# endif
# if !defined (C_CAN_BASE_ADR_B)
#  error "CAN base address B is not defined!"
# else
#  if ((C_CAN_BASE_ADR_B != 0x00801000) && (C_CAN_BASE_ADR_B != 0x00801400))
#   error "Invalid CAN base address B defined!"
#  endif
# endif
#endif

/* CANxCNT - Control register bit mask definitions */
#define kRBO    ((canuint16)0x0800)  /* return bus off                                  */
#define kTSR    ((canuint16)0x0400)  /* timestamp counter reset                         */
#define kTSP    ((canuint16)0x0300)  /* timestamp prescaler                             */
#define kFRST   ((canuint16)0x0010)  /* forcible reset                                  */
#define kBCM    ((canuint16)0x0008)  /* basic can mode                                  */
#define kLBM    ((canuint16)0x0002)  /* loopback mode                                   */
#define kRST    ((canuint16)0x0001)  /* can reset                                       */

/* CANxSTAT - Status register bit mask definitions */
#define kBOS    ((canuint16)0x4000)  /* bus off status                                  */
#define kEPS    ((canuint16)0x2000)  /* error passive status                            */
#define kCBS    ((canuint16)0x1000)  /* can bus error                                   */
#define kBCS    ((canuint16)0x0800)  /* basic can status                                */
#define kLBS    ((canuint16)0x0200)  /* loopback status                                 */
#define kCRS    ((canuint16)0x0100)  /* can reset status                                */
#define kRSB    ((canuint16)0x0080)  /* receive status                                  */
#define kTSB    ((canuint16)0x0040)  /* transmit status                                 */
#define kRSC    ((canuint16)0x0020)  /* receive complete status                         */
#define kTSC    ((canuint16)0x0010)  /* transmit complete status                        */
#define kMSN    ((canuint16)0x000f)  /* message slot number                             */

#if defined (C_PROCESSOR_32192)
# define kIDEBCA  ((canuint32)0x00000002)  /* 0: std id's 1: ext id's for msg object 30  */
# define kIDEBCB  ((canuint32)0x00000001)  /* 0: std id's 1: ext id's for msg object 31  */
# define kIDEALL  ((canuint32)0xFFFFFFFF)  /* configure all msg objects extended ID      */
#else
# define kIDEBCA  ((canuint16)0x0002)  /* 0: std id's 1: ext id's for msg object 14 */
# define kIDEBCB  ((canuint16)0x0001)  /* 0: std id's 1: ext id's for msg object 15 */
# define kIDEALL  ((canuint16)0xFFFF)  /* configure all msg objects extended ID     */
#endif

/* CANxCONF - Configuration register bit mask definitions */
#define kSJW    ((canuint16)0xc000)  /* resynchronization jump width                    */
#define kPH2    ((canuint16)0x3800)  /* phase segment 2                                 */
#define kPH1    ((canuint16)0x0700)  /* phase segment 1                                 */
#define kPRB    ((canuint16)0x00e0)  /* propagation segment                             */
#define kSAM    ((canuint16)0x0010)  /* time samples 0: once 1: three times             */

#if defined (C_PROCESSOR_32192)
# define kSSBCA  ((canuint32) 0x00000002)  /* 0: no int. 1: int. pending for msg object 14    */
# define kSSBCB  ((canuint32) 0x00000001)  /* 0: no int. 1: int. pending for msg object 15    */
#else
# define kSSBCA  ((canuint16) 0x0002)  /* 0: no int. 1: int. pending for msg object 14    */
# define kSSBCB  ((canuint16) 0x0001)  /* 0: no int. 1: int. pending for msg object 15    */
#endif

#if defined (C_PROCESSOR_32192)
# define kCanBCA ((canuint8)  30)
# define kCanBCB ((canuint8)  31)
# define kIRBCA  ((canuint32) 0x00000002)  /* 0=disabled, 1=enabled for msg object 30    */
# define kIRBCB  ((canuint32) 0x00000001)  /* 0=disabled, 1=enabled for msg object 31    */
#else
# define kCanBCA ((canuint8)  14)
# define kCanBCB ((canuint8)  15)
# define kIRBCA  ((canuint16) 0x0002)  /* 0: no int. 1: int. enabled for msg object 14    */
# define kIRBCB  ((canuint16) 0x0001)  /* 0: no int. 1: int. enabled for msg object 15    */
#endif

/* CANxERIST - Error interrupt status register bit mask definitions */
#define kEIS    ((canuint8)0x04)     /* can bus error interrupt status                  */
#define kPIS    ((canuint8)0x02)     /* error passive interrupt status                  */
#define kOIS    ((canuint8)0x01)     /* bus off interrupt status                        */

/* CANxERIMK - Error interrupt mask register bit mask definitions          */
#define kEIM    ((canuint8)0x04)     /* can bus error interrupt mask                    */
#define kPIM    ((canuint8)0x02)     /* error passive interrupt mask                    */
#define kOIM    ((canuint8)0x01)     /* bus off interrupt mask                          */

/* CxMSLyCNT - Message slot control register bit mask definitions */
#define kTR     ((canuint8)0x80)     /* transmit request                                */
#define kRR     ((canuint8)0x40)     /* receive request                                 */
#define kRM     ((canuint8)0x20)     /* remote frame                                    */
#define kRL     ((canuint8)0x10)     /* automatic response inhibit                      */
#define kRA     ((canuint8)0x08)     /* remote active                                   */
#define kML     ((canuint8)0x04)     /* message lost                                    */
#define kTRSTAT ((canuint8)0x02)     /* transmit/receive status                         */
#define kTRFIN  ((canuint8)0x01)     /* transmit/receive complete                       */
#define kTA     ((canuint8)0x0F)     /* transmit abort (special pattern)                */

/***************************************************************************/
/* macros                                                                  */
/***************************************************************************/

#if !(defined ( C_HL_DISABLE_RX_INFO_STRUCT_PTR ) || defined ( C_HL_ENABLE_RX_INFO_STRUCT_PTR ))
# define C_HL_ENABLE_RX_INFO_STRUCT_PTR
#endif

#if defined  ( C_HL_ENABLE_RX_INFO_STRUCT_PTR )
# define CAN_HL_P_RX_INFO_STRUCT(channel)  (pCanRxInfoStruct)
#else
# define CAN_HL_P_RX_INFO_STRUCT(channel)  (&canRxInfoStruct[channel])
#endif


/* define datatype of local signed variables for message handles */
# if defined( C_CPUTYPE_8BIT ) && (kCanNumberOfTxObjects > 128)
#  define CanSignedTxHandle  cansint16
# else
#  define CanSignedTxHandle  CANSINTX
# endif

# if defined( C_CPUTYPE_8BIT ) && (kCanNumberOfRxObjects > 128)
#  define CanSignedRxHandle  cansint16
# else
#  if defined( C_CPUTYPE_8BIT ) && defined ( C_SEARCH_HASH )
#   if ((kHashSearchListCountEx > 128) || (kHashSearchListCount > 128))
#    define CanSignedRxHandle  cansint16
#   else
#    define CanSignedRxHandle  CANSINTX
#   endif
#  else
#   define CanSignedRxHandle  CANSINTX
#  endif
# endif


/*disabled - lint -emacro( (572,778), C_RANGE_MATCH) */


#if defined ( C_SINGLE_RECEIVE_CHANNEL )
# if (kCanNumberOfUsedCanRxIdTables == 1)
/* Msg(4:3410) Macro parameter not enclosed in (). MISRA Rule 96 - no change */
#  define C_RANGE_MATCH( CAN_RX_IDRAW_PARA, mask, code)                                    \
                  (  ((idRaw0) & (tCanRxId0)~MK_RX_RANGE_MASK0(mask)) == MK_RX_RANGE_CODE0(code) )
#  define C_MK_ECU_NUMBER(CAN_RX_IDRAW_PARA, mask)                                          \
                                (  (canuint8)(XT_ID_LO((idRaw0) & MK_RX_RANGE_MASK0(mask)) ) )
# endif
# if (kCanNumberOfUsedCanRxIdTables == 2)
/* Msg(4:3410) Macro parameter not enclosed in (). MISRA Rule 96 - no change */
#  define C_RANGE_MATCH( CAN_RX_IDRAW_PARA, mask, code)                             \
                  ( ( ((idRaw0) & (tCanRxId0)~ MK_RX_RANGE_MASK0(mask)) == MK_RX_RANGE_CODE0(code) ) && \
                    ( ((idRaw1) & (tCanRxId1)~ MK_RX_RANGE_MASK1(mask)) == MK_RX_RANGE_CODE1(code) ) )
#  define C_MK_ECU_NUMBER(CAN_RX_IDRAW_PARA, mask)                                  \
                                (  (canuint8)(XT_ID_LO((idRaw0) & MK_RX_RANGE_MASK0(mask),  \
                                                       (idRaw1) & MK_RX_RANGE_MASK1(mask)) ) )
# endif
# if (kCanNumberOfUsedCanRxIdTables == 3)
/* Msg(4:3410) Macro parameter not enclosed in (). MISRA Rule 96 - no change */
#  define C_RANGE_MATCH( CAN_RX_IDRAW_PARA, mask, code)                      \
                  ( ( ((idRaw0) & (tCanRxId0)~ MK_RX_RANGE_MASK0(mask)) == MK_RX_RANGE_CODE0(code) ) && \
                    ( ((idRaw1) & (tCanRxId1)~ MK_RX_RANGE_MASK1(mask)) == MK_RX_RANGE_CODE1(code) ) && \
                    ( ((idRaw2) & (tCanRxId2)~ MK_RX_RANGE_MASK2(mask)) == MK_RX_RANGE_CODE2(code) ) )
#  define C_MK_ECU_NUMBER(CAN_RX_IDRAW_PARA, mask)                           \
                                (  (canuint8)(XT_ID_LO((idRaw0) & MK_RX_RANGE_MASK0(mask),  \
                                                       (idRaw1) & MK_RX_RANGE_MASK1(mask),  \
                                                       (idRaw2) & MK_RX_RANGE_MASK2(mask)) ) )
# endif
# if (kCanNumberOfUsedCanRxIdTables == 4)
/* Msg(4:3410) Macro parameter not enclosed in (). MISRA Rule 96 - no change */
#  define C_RANGE_MATCH( CAN_RX_IDRAW_PARA, mask, code)                      \
                  ( ( ((idRaw0) & (tCanRxId0)~ MK_RX_RANGE_MASK0(mask)) == MK_RX_RANGE_CODE0(code) ) && \
                    ( ((idRaw1) & (tCanRxId1)~ MK_RX_RANGE_MASK1(mask)) == MK_RX_RANGE_CODE1(code) ) && \
                    ( ((idRaw2) & (tCanRxId2)~ MK_RX_RANGE_MASK2(mask)) == MK_RX_RANGE_CODE2(code) ) && \
                    ( ((idRaw3) & (tCanRxId3)~ MK_RX_RANGE_MASK3(mask)) == MK_RX_RANGE_CODE3(code) ) )
#  define C_MK_ECU_NUMBER(CAN_RX_IDRAW_PARA, mask)                           \
                                (  (canuint8)(XT_ID_LO((idRaw0) & MK_RX_RANGE_MASK0(mask),  \
                                                       (idRaw1) & MK_RX_RANGE_MASK1(mask),  \
                                                       (idRaw2) & MK_RX_RANGE_MASK2(mask),  \
                                                       (idRaw3) & MK_RX_RANGE_MASK3(mask)) ) )
# endif
# if (kCanNumberOfUsedCanRxIdTables == 5)
/* Msg(4:3410) Macro parameter not enclosed in (). MISRA Rule 96 - no change */
#  define C_RANGE_MATCH( CAN_RX_IDRAW_PARA, mask, code)                      \
                  ( ( ((idRaw0) & (tCanRxId0)~ MK_RX_RANGE_MASK0(mask)) == MK_RX_RANGE_CODE0(code) ) && \
                    ( ((idRaw1) & (tCanRxId1)~ MK_RX_RANGE_MASK1(mask)) == MK_RX_RANGE_CODE1(code) ) && \
                    ( ((idRaw2) & (tCanRxId2)~ MK_RX_RANGE_MASK2(mask)) == MK_RX_RANGE_CODE2(code) ) && \
                    ( ((idRaw3) & (tCanRxId3)~ MK_RX_RANGE_MASK3(mask)) == MK_RX_RANGE_CODE3(code) ) && \
                    ( ((idRaw4) & (tCanRxId4)~ MK_RX_RANGE_MASK4(mask)) == MK_RX_RANGE_CODE4(code) ) )
#  define C_MK_ECU_NUMBER(CAN_RX_IDRAW_PARA, mask)                           \
                                (  (canuint8)(XT_ID_LO((idRaw0) & MK_RX_RANGE_MASK0(mask),  \
                                                       (idRaw1) & MK_RX_RANGE_MASK1(mask),  \
                                                       (idRaw2) & MK_RX_RANGE_MASK2(mask),  \
                                                       (idRaw3) & MK_RX_RANGE_MASK3(mask),  \
                                                       (idRaw4) & MK_RX_RANGE_MASK4(mask)) ) )
# endif
#else     /* C_MULTIPLE_RECEIVE_CHANNEL */

# if (kCanNumberOfUsedCanRxIdTables == 1)
/* Msg(4:3410) Macro parameter not enclosed in (). MISRA Rule 96 - no change */
#  define C_RANGE_MATCH( CAN_RX_IDRAW_PARA, mask, code)                                    \
                                (  ((idRaw0) & (tCanRxId0)~(mask[0])) == (code[0]) )
#  define C_MK_ECU_NUMBER(CAN_RX_IDRAW_PARA, mask)                                         \
                                (  (canuint8)(XT_ID_LO((idRaw0) & mask[0])) )
# endif
# if (kCanNumberOfUsedCanRxIdTables == 2)
/* Msg(4:3410) Macro parameter not enclosed in (). MISRA Rule 96 - no change */
#  define C_RANGE_MATCH( CAN_RX_IDRAW_PARA, mask, code)                             \
                                ( ( ((idRaw0) & (tCanRxId0)~(mask[0])) == (code[0]) ) &&\
                                  ( ((idRaw1) & (tCanRxId1)~(mask[1])) == (code[1]) ) )
#  define C_MK_ECU_NUMBER(CAN_RX_IDRAW_PARA, mask)                                  \
                                (  (canuint8)(XT_ID_LO((idRaw0) & mask[0],  \
                                                       (idRaw1) & mask[1])) )
# endif
# if (kCanNumberOfUsedCanRxIdTables == 3)
/* Msg(4:3410) Macro parameter not enclosed in (). MISRA Rule 96 - no change */
#  define C_RANGE_MATCH( CAN_RX_IDRAW_PARA, mask, code)                      \
                                ( ( ((idRaw0) & (tCanRxId0)~(mask[0])) == (code[0]) ) &&\
                                  ( ((idRaw1) & (tCanRxId1)~(mask[1])) == (code[1]) ) &&\
                                  ( ((idRaw2) & (tCanRxId2)~(mask[2])) == (code[2]) ) )
#  define C_MK_ECU_NUMBER(CAN_RX_IDRAW_PARA, mask)                           \
                                (  (canuint8)(XT_ID_LO((idRaw0) & mask[0],  \
                                                       (idRaw1) & mask[1],  \
                                                       (idRaw2) & mask[2])) )
# endif
# if (kCanNumberOfUsedCanRxIdTables == 4)
/* Msg(4:3410) Macro parameter not enclosed in (). MISRA Rule 96 - no change */
#  define C_RANGE_MATCH( CAN_RX_IDRAW_PARA, mask, code)                      \
                                ( ( ((idRaw0) & (tCanRxId0)~(mask[0])) == (code[0]) ) &&\
                                  ( ((idRaw1) & (tCanRxId1)~(mask[1])) == (code[1]) ) &&\
                                  ( ((idRaw2) & (tCanRxId2)~(mask[2])) == (code[2]) ) &&\
                                  ( ((idRaw3) & (tCanRxId3)~(mask[3])) == (code[3]) ) )
#  define C_MK_ECU_NUMBER(CAN_RX_IDRAW_PARA, mask)                           \
                                (  (canuint8)(XT_ID_LO((idRaw0) & mask[0],  \
                                                       (idRaw1) & mask[1],  \
                                                       (idRaw2) & mask[2],  \
                                                       (idRaw3) & mask[3])) )
# endif
# if (kCanNumberOfUsedCanRxIdTables == 5)
/* Msg(4:3410) Macro parameter not enclosed in (). MISRA Rule 96 - no change */
#  define C_RANGE_MATCH( CAN_RX_IDRAW_PARA, mask, code)                      \
                                ( ( ((idRaw0) & (tCanRxId0)~(mask[0])) == (code[0]) ) &&\
                                  ( ((idRaw1) & (tCanRxId1)~(mask[1])) == (code[1]) ) &&\
                                  ( ((idRaw2) & (tCanRxId2)~(mask[2])) == (code[2]) ) &&\
                                  ( ((idRaw3) & (tCanRxId3)~(mask[3])) == (code[3]) ) &&\
                                  ( ((idRaw4) & (tCanRxId4)~(mask[4])) == (code[4]) ) )
#  define C_MK_ECU_NUMBER(CAN_RX_IDRAW_PARA, mask)                           \
                                (  (canuint8)(XT_ID_LO((idRaw0) & mask[0],  \
                                                       (idRaw1) & mask[1],  \
                                                       (idRaw2) & mask[2],  \
                                                       (idRaw3) & mask[3],  \
                                                       (idRaw4) & mask[4])) )
# endif
#endif


#if (kCanNumberOfUsedCanRxIdTables == 1)
# define CAN_RX_IDRAW_PARA     idRaw0
#endif
#if (kCanNumberOfUsedCanRxIdTables == 2)
# define CAN_RX_IDRAW_PARA     idRaw0,idRaw1
#endif
#if (kCanNumberOfUsedCanRxIdTables == 3)
# define CAN_RX_IDRAW_PARA     idRaw0,idRaw1,idRaw2
#endif
#if (kCanNumberOfUsedCanRxIdTables == 4)
# define CAN_RX_IDRAW_PARA     idRaw0,idRaw1,idRaw2,idRaw3
#endif
#if (kCanNumberOfUsedCanRxIdTables == 5)
# define CAN_RX_IDRAW_PARA     idRaw0,idRaw1,idRaw2,idRaw3,idRaw4
#endif


#if defined ( C_SINGLE_RECEIVE_CHANNEL )
# define channel                                     ((CanChannelHandle)0)
# define canHwChannel                                ((CanChannelHandle)0)
# define CAN_HL_HW_CHANNEL_STARTINDEX(channel)       ((CanChannelHandle)0)
# define CAN_HL_HW_CHANNEL_STOPINDEX(channel)        ((CanChannelHandle)0)
# define CAN_HL_HW_MSG_TRANSMIT_INDEX(canHwChannel)  (kCanMsgTransmitObj)
# define CAN_HL_HW_TX_NORMAL_INDEX(canHwChannel)     (kCanHwTxNormalIndex)

/* Offset which has to be added to change the hardware Tx handle into a logical handle, which is unique over all channels */
/*        Tx-Hardware-Handle - CAN_HL_HW_TX_STARTINDEX(canHwChannel) + CAN_HL_LOG_HW_TX_STARTINDEX(canHwChannel) */
# define CAN_HL_TX_OFFSET_HW_TO_LOG(canHwChannel)    ((vsintx)(0-kCanHwTxStartIndex))

# define CAN_HL_TX_STARTINDEX(channel)               ((CanTransmitHandle)0)
# define CAN_HL_TX_STAT_STARTINDEX(channel)          ((CanTransmitHandle)0)
# define CAN_HL_TX_DYN_ROM_STARTINDEX(channel)       (kCanNumberOfTxStatObjects)
# define CAN_HL_TX_DYN_RAM_STARTINDEX(channel)       ((CanTransmitHandle)0)
# define CAN_HL_RX_STARTINDEX(channel)               ((CanReceiveHandle)0)
/* index to access the ID tables - Basic index only for linear search
   for hash search this is the start index of the ??? */
# define CAN_HL_RX_BASIC_STARTINDEX(channel)         ((CanReceiveHandle)0)
# if defined( C_SEARCH_HASH )
#  define CAN_HL_RX_FULL_STARTINDEX(canHwChannel)    ((CanReceiveHandle)0)
# else
#  define CAN_HL_RX_FULL_STARTINDEX(canHwChannel)    (kCanNumberOfRxBasicCANObjects)
# endif
# define CAN_HL_INIT_OBJ_STARTINDEX(channel)         ((canuint8)0)
# define CAN_HL_LOG_HW_TX_STARTINDEX(canHwChannel)   ((CanObjectHandle)0)
# define CAN_HL_HW_TX_STARTINDEX(canHwChannel)       (kCanHwTxStartIndex)
# define CAN_HL_HW_RX_FULL_STARTINDEX(canHwChannel)  (kCanHwRxFullStartIndex)
# define CAN_HL_HW_RX_BASIC_STARTINDEX(canHwChannel) (kCanHwRxBasicStartIndex)
# define CAN_HL_HW_UNUSED_STARTINDEX(canHwChannel)   (kCanHwUnusedStartIndex)

# define CAN_HL_TX_STOPINDEX(channel)                (kCanNumberOfTxObjects)
# define CAN_HL_TX_STAT_STOPINDEX(channel)           (kCanNumberOfTxStatObjects)
# define CAN_HL_TX_DYN_ROM_STOPINDEX(channel)        (kCanNumberOfTxObjects)
# define CAN_HL_TX_DYN_RAM_STOPINDEX(channel)        (kCanNumberOfTxDynObjects)
# define CAN_HL_RX_STOPINDEX(channel)                (kCanNumberOfRxObjects)
# define CAN_HL_RX_BASIC_STOPINDEX(channel)          (kCanNumberOfRxBasicCANObjects)
# if defined( C_SEARCH_HASH )
#  define CAN_HL_RX_FULL_STOPINDEX(canHwChannel)     (kCanNumberOfRxFullCANObjects)
# else
#  define CAN_HL_RX_FULL_STOPINDEX(canHwChannel)     (kCanNumberOfRxBasicCANObjects+kCanNumberOfRxFullCANObjects)
# endif
# define CAN_HL_INIT_OBJ_STOPINDEX(channel)          (kCanNumberOfInitObjects)
# define CAN_HL_LOG_HW_TX_STOPINDEX(canHwChannel)    (kCanNumberOfUsedTxCANObjects)
# define CAN_HL_HW_TX_STOPINDEX(canHwChannel)        (kCanHwTxStartIndex     +kCanNumberOfUsedTxCANObjects)
# define CAN_HL_HW_RX_FULL_STOPINDEX(canHwChannel)   (kCanHwRxFullStartIndex +kCanNumberOfRxFullCANObjects)
# define CAN_HL_HW_RX_BASIC_STOPINDEX(canHwChannel)  (kCanHwRxBasicStartIndex+kCanNumberOfUsedRxBasicCANObjects)
# define CAN_HL_HW_UNUSED_STOPINDEX(canHwChannel)    (kCanHwUnusedStartIndex +kCanNumberOfUnusedObjects)

#else
#  define canHwChannel                               channel   /*brackets are not allowed here due to compiler error with Renesas HEW compiler for SH2*/
#  define CAN_HL_HW_CHANNEL_STARTINDEX(channel)      (channel)
#  define CAN_HL_HW_CHANNEL_STOPINDEX(channel)       (channel)

# define CAN_HL_HW_MSG_TRANSMIT_INDEX(canHwChannel)  (CanHwMsgTransmitIndex[(canHwChannel)])
# define CAN_HL_HW_TX_NORMAL_INDEX(canHwChannel)     (CanHwTxNormalIndex[(canHwChannel)])
/* Offset which has to be added to change the hardware Tx handle into a logical handle, which is unique over all channels */
/*        Tx-Hardware-Handle - CAN_HL_HW_TX_STARTINDEX(canHwChannel) + CAN_HL_LOG_HW_TX_STARTINDEX(canHwChannel) */
# define CAN_HL_TX_OFFSET_HW_TO_LOG(canHwChannel)    (CanTxOffsetHwToLog[(canHwChannel)])

# define CAN_HL_TX_STARTINDEX(channel)               (CanTxStartIndex[(channel)])
# define CAN_HL_TX_STAT_STARTINDEX(channel)          (CanTxStartIndex[(channel)])
# define CAN_HL_TX_DYN_ROM_STARTINDEX(channel)       (CanTxDynRomStartIndex[(channel)])
# define CAN_HL_TX_DYN_RAM_STARTINDEX(channel)       (CanTxDynRamStartIndex[(channel)])
# define CAN_HL_RX_STARTINDEX(channel)               (CanRxStartIndex[(channel)])
/* index to access the ID tables - Basic index only for linear search */
# define CAN_HL_RX_BASIC_STARTINDEX(channel)         (CanRxBasicStartIndex[(channel)])
# define CAN_HL_RX_FULL_STARTINDEX(canHwChannel)     (CanRxFullStartIndex[(canHwChannel)])
# define CAN_HL_INIT_OBJ_STARTINDEX(channel)         (CanInitObjectStartIndex[(channel)])
# define CAN_HL_LOG_HW_TX_STARTINDEX(canHwChannel)   (CanLogHwTxStartIndex[(canHwChannel)])
# define CAN_HL_HW_TX_STARTINDEX(canHwChannel)       (CanHwTxStartIndex[(canHwChannel)])
# define CAN_HL_HW_RX_FULL_STARTINDEX(canHwChannel)  (CanHwRxFullStartIndex[(canHwChannel)])
# define CAN_HL_HW_RX_BASIC_STARTINDEX(canHwChannel) (CanHwRxBasicStartIndex[(canHwChannel)])
# define CAN_HL_HW_UNUSED_STARTINDEX(canHwChannel)   (CanHwUnusedStartIndex[(canHwChannel)])

# define CAN_HL_TX_STOPINDEX(channel)                (CanTxStartIndex[(channel) + 1])
# define CAN_HL_TX_STAT_STOPINDEX(channel)           (CanTxDynRomStartIndex[(channel)])
# define CAN_HL_TX_DYN_ROM_STOPINDEX(channel)        (CanTxStartIndex[(channel) + 1])
# define CAN_HL_TX_DYN_RAM_STOPINDEX(channel)        (CanTxDynRamStartIndex[(channel) + 1])
# define CAN_HL_RX_STOPINDEX(channel)                (CanRxStartIndex[(channel) + 1])
/* index to access the ID tables - Basic index only for linear search */
# define CAN_HL_RX_BASIC_STOPINDEX(channel)          (CanRxFullStartIndex[CAN_HL_HW_CHANNEL_STARTINDEX(channel)])
# define CAN_HL_INIT_OBJ_STOPINDEX(channel)          (CanInitObjectStartIndex[(channel) + 1])
# define CAN_HL_LOG_HW_TX_STOPINDEX(canHwChannel)    (CanLogHwTxStartIndex[(canHwChannel) +1])
# define CAN_HL_HW_TX_STOPINDEX(canHwChannel)        (CanHwTxStopIndex[(canHwChannel)])
# define CAN_HL_HW_RX_FULL_STOPINDEX(canHwChannel)   (CanHwRxFullStopIndex[(canHwChannel)])
# define CAN_HL_HW_RX_BASIC_STOPINDEX(canHwChannel)  (CanHwRxBasicStopIndex[(canHwChannel)])
# define CAN_HL_HW_UNUSED_STOPINDEX(canHwChannel)    (CanHwUnusedStopIndex[(canHwChannel)])

#endif


#if defined ( C_SINGLE_RECEIVE_CHANNEL )

# define CANRANGE0ACCMASK(i)        C_RANGE0_ACC_MASK
# define CANRANGE0ACCCODE(i)        C_RANGE0_ACC_CODE
# define CANRANGE1ACCMASK(i)        C_RANGE1_ACC_MASK
# define CANRANGE1ACCCODE(i)        C_RANGE1_ACC_CODE
# define CANRANGE2ACCMASK(i)        C_RANGE2_ACC_MASK
# define CANRANGE2ACCCODE(i)        C_RANGE2_ACC_CODE
# define CANRANGE3ACCMASK(i)        C_RANGE3_ACC_MASK
# define CANRANGE3ACCCODE(i)        C_RANGE3_ACC_CODE

# define APPL_CAN_MSG_RECEIVED( i ) ApplCanMsgReceived( i )

# define APPLCANRANGE0PRECOPY( i )  ApplCanRange0Precopy( i )
# define APPLCANRANGE1PRECOPY( i )  ApplCanRange1Precopy( i )
# define APPLCANRANGE2PRECOPY( i )  ApplCanRange2Precopy( i )
# define APPLCANRANGE3PRECOPY( i )  ApplCanRange3Precopy( i )

# define APPL_CAN_BUSOFF( i )       ApplCanBusOff()
# define APPL_CAN_WAKEUP( i )       ApplCanWakeUp()

# if defined(C_ENABLE_CAN_CANCEL_NOTIFICATION)
#  define APPLCANCANCELNOTIFICATION( i, j ) ApplCanCancelNotification( j )
# else
#  define APPLCANCANCELNOTIFICATION( i, j )
# endif
# if defined( C_ENABLE_CAN_MSG_TRANSMIT_CANCEL_NOTIFICATION )
#  define APPLCANMSGCANCELNOTIFICATION( i ) ApplCanMsgCancelNotification()
# else
#  define APPLCANMSGCANCELNOTIFICATION( i )
# endif


#else

# define CANRANGE0ACCMASK(i)        (CanChannelObject[i].RangeMask[0])
# define CANRANGE0ACCCODE(i)        (CanChannelObject[i].RangeCode[0])
# define CANRANGE1ACCMASK(i)        (CanChannelObject[i].RangeMask[1])
# define CANRANGE1ACCCODE(i)        (CanChannelObject[i].RangeCode[1])
# define CANRANGE2ACCMASK(i)        (CanChannelObject[i].RangeMask[2])
# define CANRANGE2ACCCODE(i)        (CanChannelObject[i].RangeCode[2])
# define CANRANGE3ACCMASK(i)        (CanChannelObject[i].RangeMask[3])
# define CANRANGE3ACCCODE(i)        (CanChannelObject[i].RangeCode[3])

# define APPL_CAN_MSG_RECEIVED( i )    (CanChannelObject[(i)->Channel].ApplCanMsgReceivedFct(i))

# define APPLCANRANGE0PRECOPY( i )  (CanChannelObject[(i)->Channel].ApplCanRangeFct[0](i))
# define APPLCANRANGE1PRECOPY( i )  (CanChannelObject[(i)->Channel].ApplCanRangeFct[1](i))
# define APPLCANRANGE2PRECOPY( i )  (CanChannelObject[(i)->Channel].ApplCanRangeFct[2](i))
# define APPLCANRANGE3PRECOPY( i )  (CanChannelObject[(i)->Channel].ApplCanRangeFct[3](i))

# define APPL_CAN_BUSOFF( i )         (CanChannelObject[i].ApplCanBusOffFct(i))
# define APPL_CAN_WAKEUP( i )         (CanChannelObject[i].ApplCanWakeUpFct(i))

# if defined(C_ENABLE_CAN_CANCEL_NOTIFICATION)
#  define APPLCANCANCELNOTIFICATION( i, j ) (CanChannelObject[i].ApplCanCancelNotificationFct( j ))
# else
#  define APPLCANCANCELNOTIFICATION( i, j )
# endif

# if defined( C_ENABLE_CAN_MSG_TRANSMIT_CANCEL_NOTIFICATION )
#  define APPLCANMSGCANCELNOTIFICATION( i ) (CanChannelObject[i].ApplCanMsgTransmitCancelNotifyFct( i ))
# else
#  define APPLCANMSGCANCELNOTIFICATION( i )
# endif

#endif

#if defined ( C_SINGLE_RECEIVE_CHANNEL )
# define CAN_HW_CHANNEL_CANTYPE_ONLY           void
# define CAN_HW_CHANNEL_CANTYPE_FIRST
# define CAN_HW_CHANNEL_CANTYPE_LOCAL
# define CAN_HW_CHANNEL_CANPARA_ONLY
# define CAN_HW_CHANNEL_CANPARA_FIRST
#else
# define CAN_HW_CHANNEL_CANTYPE_ONLY          CanChannelHandle canHwChannel
# define CAN_HW_CHANNEL_CANTYPE_FIRST         CanChannelHandle canHwChannel,
# define CAN_HW_CHANNEL_CANTYPE_LOCAL         CanChannelHandle canHwChannel;
# define CAN_HW_CHANNEL_CANPARA_ONLY          canHwChannel
# define CAN_HW_CHANNEL_CANPARA_FIRST         canHwChannel,
#endif

#ifndef CAN_POLLING_IRQ_DISABLE
# define CAN_POLLING_IRQ_DISABLE(i)  CanCanInterruptDisable(i)
#endif
#ifndef CAN_POLLING_IRQ_RESTORE
# define CAN_POLLING_IRQ_RESTORE(i)  CanCanInterruptRestore(i)
#endif

/* mask for range enable status */
#define kCanRange0  ((canuint16)1)
#define kCanRange1  ((canuint16)2)
#define kCanRange2  ((canuint16)4)
#define kCanRange3  ((canuint16)8)


/* Assertions ----------------------------------------------------------------*/
#if defined( C_ENABLE_USER_CHECK )
# if defined ( C_SINGLE_RECEIVE_CHANNEL )
#  define assertUser(p,c,e)     if (!(p))   {ApplCanFatalError(e);}
# else
#  define assertUser(p,c,e)     if (!(p))   {ApplCanFatalError((c),(e));}
# endif
#else
# define assertUser(a,c,b)
#endif

#if defined ( C_ENABLE_GEN_CHECK )
# if defined ( C_SINGLE_RECEIVE_CHANNEL )
#  define assertGen(p,c,e)      if (!(p))   {ApplCanFatalError(e);}
# else
#  define assertGen(p,c,e)      if (!(p))   {ApplCanFatalError((c),(e));}
# endif
#else
# define assertGen(a,c,b)
#endif

#if defined ( C_ENABLE_HARDWARE_CHECK )
# if defined ( C_SINGLE_RECEIVE_CHANNEL )
#  define assertHardware(p,c,e) if (!(p))   {ApplCanFatalError(e);}
# else
#  define assertHardware(p,c,e) if (!(p))   {ApplCanFatalError((c),(e));}
# endif
#else
# define assertHardware(a,c,b)
#endif

#if defined ( C_ENABLE_INTERNAL_CHECK )
# if defined ( C_SINGLE_RECEIVE_CHANNEL )
#  define assertInternal(p,c,e) if (!(p))   {ApplCanFatalError(e);}
# else
#  define assertInternal(p,c,e) if (!(p))   {ApplCanFatalError((c),(e));}
# endif
#else
# define assertInternal(p,c,e)
#endif


/* Macros for Can-Interrupt enable/disable---------------------------------*/
/* these macros are only neccessary, if polling and interrupt is mixed or  */
/* if several receive interrupts are available.                            */
#define CanLL_CanInterruptDisable(channel, localInterruptOldFlagPtr)              \
        {tCanHLIntOld localIntOldFlag;                                            \
         CanLL_GlobalInterruptDisable(&localIntOldFlag);                          \
         (*localInterruptOldFlagPtr).oldSlimk = ((*CAN_BASE_ADR(channel)).slimk); \
         (*localInterruptOldFlagPtr).oldErimk = ((*CAN_BASE_ADR(channel)).erimk); \
         ((*CAN_BASE_ADR(channel)).slimk) = 0;                                    \
         ((*CAN_BASE_ADR(channel)).erimk) = 0;                                    \
         CanLL_GlobalInterruptRestore(localIntOldFlag);}

#define CanLL_CanInterruptRestore(channel, localInterruptOldFlag)                 \
        {tCanHLIntOld localIntOldFlag;                                            \
         CanLL_GlobalInterruptDisable(&localIntOldFlag);                          \
         ((*CAN_BASE_ADR(channel)).slimk) = localInterruptOldFlag.oldSlimk;       \
         ((*CAN_BASE_ADR(channel)).erimk) = localInterruptOldFlag.oldErimk;       \
         CanLL_GlobalInterruptRestore(localIntOldFlag);}

#define CanLL_TxIsHWObjFree( channel, txObjHandle ) \
(!(((*CAN_BASE_ADR(channel)).mslcnt[txObjHandle]) & kTRSTAT))


# define CanLL_HwIsSleep( CAN_CHANNEL_CANPARA_ONLY)  kCanFalse


#define CanLL_HwIsStop( CAN_CHANNEL_CANPARA_ONLY ) \
(((*CAN_BASE_ADR(channel)).stat) & kCRS)


#define CanLL_HwIsBusOff( CAN_CHANNEL_CANPARA_ONLY ) \
(((*CAN_BASE_ADR(channel)).stat) & kBOS)


#if defined( C_ENABLE_EXTENDED_STATUS )
# define CanLL_HwIsPassive( CAN_CHANNEL_CANPARA_ONLY ) \
(((*CAN_BASE_ADR(channel)).stat) & kEPS)


# define CanLL_HwIsWarning( CAN_CHANNEL_CANPARA_ONLY ) \
(((((*CAN_BASE_ADR(channel)).rec) >= 96) && (((*CAN_BASE_ADR(channel)).rec) < 128)) || \
((((*CAN_BASE_ADR(channel)).tec) >= 96) && (((*CAN_BASE_ADR(channel)).tec) < 128)))
#endif

/***************************************************************************/
/* Defines / data types / structs / unions                                 */
/***************************************************************************/

#if defined(C_ENABLE_RX_QUEUE)
typedef struct
{
  tCanMsgTransmitStruct  CanChipMsgObj;
  CanReceiveHandle       Handle;
  CanChannelHandle       Channel;
} tCanRxQueueObject;
#endif

#define CAN_INLINE_FCT

#define CAN_IMASK(channel)        (*((canuint8*)((canuint32)(0x00800004))))

#if (C_CAN_BASE_ADR_A == 0x00801000)
# define kCanChannelIndex_0  0
# define kCanChannelIndex_1  1
#else
# define kCanChannelIndex_0  1
# define kCanChannelIndex_1  0
#endif

#if defined( C_SINGLE_RECEIVE_CHANNEL )
# define CAN_INT_LEVEL(channel)  C_CAN_INT_LEVEL
# define CAN_BASE_ADR(channel)   ((tCanRegs MEMORY_CAN *) C_CAN_BASE_ADR_A)
#else
# define CAN_INT_LEVEL(channel)   CanIntLevel[channel]
# define CAN_BASE_ADR(channel)    ((tCanRegs MEMORY_CAN *) CanBaseAdr[channel])
# if defined( C_ENABLE_MULTI_ECU_CONFIG )
/* extern table CanBaseAdr[] used for macro CAN_BASE_ADR() */
# else
#  if( kCanNumberOfChannels == 1 )
V_MEMROM0 V_MEMROM1 canuint32 V_MEMROM2 CanBaseAdr[1] = {C_CAN_BASE_ADR_A};
#  endif
#  if( kCanNumberOfChannels == 2 )
V_MEMROM0 V_MEMROM1 canuint32 V_MEMROM2 CanBaseAdr[2] = {C_CAN_BASE_ADR_A, C_CAN_BASE_ADR_B};
#  endif
# endif
#endif

#if defined (C_PROCESSOR_32170) || \
    defined (C_PROCESSOR_32174)
# define CAN_ICAN0CR  ((canuint32)(0x00800060))
#endif

#if defined (C_PROCESSOR_32172) || \
    defined (C_PROCESSOR_32173)
# define CAN_ICAN0CR  ((canuint32)(0x00800061))
# define CAN_ICAN1CR  ((canuint32)(0x00800060))
#endif

#if defined (C_PROCESSOR_32182)
# define CAN_ICAN0CR  ((canuint32)(0x00800060))
# define CAN_ICAN1CR  ((canuint32)(0x0080007F))
#endif

#if defined (C_PROCESSOR_32176) || \
    defined (C_PROCESSOR_32192)
# define CAN_ICAN0CR  ((canuint32)(0x00800060))
# define CAN_ICAN1CR  ((canuint32)(0x0080007F))
#endif

#if defined (C_SINGLE_RECEIVE_CHANNEL)
# if(C_CAN_BASE_ADR_A == 0x00801000)
/* base addr channel A = 0x00801000 */
#  define CAN_ICANx() (*(canuint8 MEMORY_CAN *) CAN_ICAN0CR)
# else
/* base addr channel A = 0x00801400 */
#  define CAN_ICANx() (*(canuint8 MEMORY_CAN *) CAN_ICAN1CR)
# endif
#else
# define CAN_ICAN0() (*(canuint8 MEMORY_CAN *) CAN_ICAN0CR)
# define CAN_ICAN1() (*(canuint8 MEMORY_CAN *) CAN_ICAN1CR)
#endif

/* Can message slot type */
typedef volatile struct {
  canuint8  stdId0;               /* standard ID0 value                    */
  canuint8  stdId1;               /* standard ID1 value                    */
  canuint8  extId0;               /* extended ID0 value                    */
  canuint8  extId1;               /* extended ID1 value                    */
  canuint8  extId2;               /* extended ID2 value                    */
  canuint8  dlc;                  /* data length code                      */
  canuint8  data[8];              /* access as 8-bit array                 */
  canuint16 tsp;                  /* timestamp                             */
} tCanMsgSlot;

/* Can registers type */
#if defined (C_PROCESSOR_32192)
typedef volatile struct {
  canuint16   cnt;                /* control register                      */
  canuint16   stat;               /* status register                       */
  canuint8    unused0[2];         /* unused                                */

  canuint16   conf;               /* configuration register                */
  canuint16   tstmp;              /* timestamp count register              */
  canuint8    rec;                /* receive error count register          */
  canuint8    tec;                /* transmit error count register         */

  canuint32   slist;              /* slot interrupt status register        */
  canuint32   slimk;              /* slot interrupt mask register          */

  canuint8    erist;              /* error interrupt status register       */
  canuint8    erimk;              /* error interrupt mask register         */
  canuint8    brp;                /* baudrate pre-scaler register          */
  canuint8    coerr;              /* cause of error                        */
  canuint8    mod;                /* mode register                         */
  canuint8    dmarq;              /* transfer request select               */
  canuint8    msn;                /* message slot number                   */
  canuint8    clksel;             /* clock select                          */
  canuint32   extid;              /* frame format select                   */

  canuint8    gmskas0;            /* global mask std0 register             */
  canuint8    gmskas1;            /* global mask std1 register             */
  canuint8    gmskae0;            /* global mask ext0 register             */
  canuint8    gmskae1;            /* global mask ext1 register             */
  canuint8    gmskae2;            /* global mask ext2 register             */
  canuint8    unused1[3];         /* unused                                */

  canuint8    gmskbs0;            /* global mask std0 register             */
  canuint8    gmskbs1;            /* global mask std1 register             */
  canuint8    gmskbe0;            /* global mask ext0 register             */
  canuint8    gmskbe1;            /* global mask ext1 register             */
  canuint8    gmskbe2;            /* global mask ext2 register             */
  canuint8    unused2[3];         /* unused                                */

  canuint8    lmskas0;            /* local mask A std0 register            */
  canuint8    lmskas1;            /* local mask A std1 register            */
  canuint8    lmskae0;            /* local mask A ext0 register            */
  canuint8    lmskae1;            /* local mask A ext1 register            */
  canuint8    lmskae2;            /* local mask A ext2 register            */
  canuint8    unused3[3];         /* unused                                */

  canuint8    lmskbs0;            /* local mask B std0 register            */
  canuint8    lmskbs1;            /* local mask B std1 register            */
  canuint8    lmskbe0;            /* local mask B ext0 register            */
  canuint8    lmskbe1;            /* local mask B ext1 register            */
  canuint8    lmskbe2;            /* local mask B ext2 register            */
  canuint8    unused4[3];         /* unused                                */

  canuint32   slshmode;           /* single shot mode control              */
  canuint32   slsist;             /* single shot interrupt request status  */
  canuint32   slsimk;             /* single shot interrupt request mask    */
  canuint8    unused5[4];         /* unused                                */

  canuint8    mslcnt[32];         /* message slot control register (*32)   */
  canuint8    unused6[144];       /* unused                                */
  tCanMsgSlot msl[32];            /* message slot (*16)                    */
} tCanRegs;
#else
typedef volatile struct {
  canuint16   cnt;                /* control register                      */
  canuint16   stat;               /* status register                       */
  canuint16   extid;              /* extended id register                  */
  canuint16   conf;               /* configuration register                */
  canuint16   tstmp;              /* timestamp count register              */
  canuint8    rec;                /* receive error count register          */
  canuint8    tec;                /* transmit error count register         */
  canuint16   slist;              /* slot interrupt status register        */
  canuint16   unused1;            /* unused                                */

  canuint16   slimk;              /* slot interrupt mask register          */
  canuint16   unused2;            /* unused                                */
  canuint8    erist;              /* error interrupt status register       */
  canuint8    erimk;              /* error interrupt mask register         */
  canuint8    brp;                /* baudrate pre-scaler register          */
  canuint8    unused3[17];        /* unused                                */

  canuint8    gmsks0;             /* global mask std0 register             */
  canuint8    gmsks1;             /* global mask std1 register             */
  canuint8    gmske0;             /* global mask ext0 register             */
  canuint8    gmske1;             /* global mask ext1 register             */
  canuint8    gmske2;             /* global mask ext2 register             */
  canuint8    unused4[3];         /* unused                                */

  canuint8    lmskas0;            /* local mask A std0 register            */
  canuint8    lmskas1;            /* local mask A std1 register            */
  canuint8    lmskae0;            /* local mask A ext0 register            */
  canuint8    lmskae1;            /* local mask A ext1 register            */
  canuint8    lmskae2;            /* local mask A ext2 register            */
  canuint8    unused5[3];         /* unused                                */

  canuint8    lmskbs0;            /* local mask B std0 register            */
  canuint8    lmskbs1;            /* local mask B std1 register            */
  canuint8    lmskbe0;            /* local mask B ext0 register            */
  canuint8    lmskbe1;            /* local mask B ext1 register            */
  canuint8    lmskbe2;            /* local mask B ext2 register            */
  canuint8    unused6[19];        /* unused                                */

  canuint8    mslcnt[16];         /* message slot control register (*16)   */
  canuint8    unused7[160];       /* unused                                */
  tCanMsgSlot msl[16];            /* message slot (*16)                    */
} tCanRegs;
#endif

/****************************************************************************/
/* Constants                                                                */
/****************************************************************************/

V_MEMROM0 V_MEMROM1 canuint8 V_MEMROM2 kCanMainVersion   = (canuint8)(( DRVCAN_M32RCANMODULEHLL_VERSION & 0xFF00 ) >> 8);
V_MEMROM0 V_MEMROM1 canuint8 V_MEMROM2 kCanSubVersion    = (canuint8)( DRVCAN_M32RCANMODULEHLL_VERSION & 0x00FF );
V_MEMROM0 V_MEMROM1 canuint8 V_MEMROM2 kCanBugFixVersion = (canuint8)( DRVCAN_M32RCANMODULEHLL_RELEASE_VERSION );

/* for ICAN0CR register. level 7 means that the interrupts are disabled */
#define kLvlIrqDisabled  ((canuint8)7)

/* for CanInterrupt() to determine if an object handle with a pending
 * interrupt is valid
 */
#define kCanInvalidObjectHandle ((CanObjectHandle)0xff)

/* table used to quickly and efficiently obtain the bit mask for
 * a message slot number.
 */
#if defined (C_PROCESSOR_32192)
static MEMORY_ROM canuint32 msgSlotBitmask[32] = {
  0x80000000, 0x40000000, 0x20000000, 0x10000000, 0x08000000, 0x04000000, 0x02000000, 0x01000000,
  0x00800000, 0x00400000, 0x00200000, 0x00100000, 0x00080000, 0x00040000, 0x00020000, 0x00010000,
  0x00008000, 0x00004000, 0x00002000, 0x00001000, 0x00000800, 0x00000400, 0x00000200, 0x00000100,
  0x00000080, 0x00000040, 0x00000020, 0x00000010, 0x00000008, 0x00000004, 0x00000002, 0x00000001
};
#else
static MEMORY_ROM canuint16 msgSlotBitmask[16] = {
  0x8000, 0x4000, 0x2000, 0x1000, 0x0800, 0x0400, 0x0200, 0x0100,
  0x0080, 0x0040, 0x0020, 0x0010, 0x0008, 0x0004, 0x0002, 0x0001
};
#endif

#if defined ( C_ENABLE_TX_POLLING )
/* table used to quickly and efficiently obtain a bit mask to determine
 * if a Tx interrupt is pending. the generated constant
 * (CAN_HL_HW_TX_STOPINDEX(channel)+1) should be used as an index. there
 * will never be more than 16/32 tx objects per channel.
 */
# if defined (C_PROCESSOR_32192)
static MEMORY_ROM canuint32 txGlobalConfMask[33] = {
  0x00000000,                                               /* no tx objects used          */
  0x80000000, 0xc0000000, 0xe0000000, 0xf0000000,           /* 1..4   tx objects used      */
  0xf8000000, 0xfc000000, 0xfe000000, 0xff000000,           /* 5..8   tx objects used      */
  0xff800000, 0xffc00000, 0xffe00000, 0xfff00000,           /* 9..12  tx objects used      */
  0xfff80000, 0xfffc0000, 0xfffe0000, 0xffff0000,           /* 13..16 tx objects used      */
  0xffff8000, 0xffffc000, 0xffffe000, 0xfffff000,           /* 17..20 tx objects used      */
  0xfffff800, 0xfffffc00, 0xfffffe00, 0xffffff00,           /* 21..24 tx objects used      */
  0xffffff80, 0xffffffc0, 0xffffffe0, 0xfffffff0,           /* 25..28 tx objects used      */
  0xfffffff8, 0xfffffffc, 0xfffffffe, 0xffffffff            /* 29..32 tx objects used      */
};
# else
static MEMORY_ROM canuint16 txGlobalConfMask[17] = {
  0x0000,                                   /* no tx objects used          */
  0x8000, 0xc000, 0xe000, 0xf000,           /* 1..4   tx objects used      */
  0xf800, 0xfc00, 0xfe00, 0xff00,           /* 5..8   tx objects used      */
  0xff80, 0xffc0, 0xffe0, 0xfff0,           /* 9..12  tx objects used      */
  0xfff8, 0xfffc, 0xfffe, 0xffff            /* 13..16 tx objects used      */
};
# endif
#endif

#if defined ( C_ENABLE_RX_FULLCAN_OBJECTS ) && defined ( C_ENABLE_RX_FULLCAN_POLLING )
# if defined ( C_ENABLE_RX_BASICCAN_OBJECTS )
/* table used to quickly and efficiently obtain a bit mask to determine
 * if a RxFull interrupt is pending. the generated constant
 * (CAN_HL_HW_RX_BASIC_STARTINDEX(channel)-CAN_HL_HW_RX_FULL_STARTINDEX(channel))
 * should be used as an index. there will never be more than 13 RxFull
 * objects per channel because 14 and 15 are always used for BasicCAN and
 * there will always be one message object used for normal tx.
 */

#  if defined (C_PROCESSOR_32192)
static MEMORY_ROM canuint32 rxFullGlobalIndMask[30] = {
  0x00000000,                                         /* no rx full objects used     */
  0x00000004, 0x0000000c, 0x0000001c, 0x0000003c,     /* 1..4   rx full objects used */
  0x0000007c, 0x000000fc, 0x000001fc, 0x000003fc,     /* 5..8   rx full objects used */
  0x000007fc, 0x00000ffc, 0x00001ffc, 0x00003ffc,     /* 9..12  rx full objects used */
  0x00007ffc, 0x0000fffc, 0x0001fffc, 0x0003fffc,
  0x0007fffc, 0x000ffffc, 0x001ffffc, 0x003ffffc,
  0x007ffffc, 0x00fffffc, 0x01fffffc, 0x03fffffc,
  0x07fffffc, 0x0ffffffc, 0x1ffffffc, 0x3ffffffc,
  0x7ffffffc
};
#  else
static MEMORY_ROM canuint16 rxFullGlobalIndMask[14] = {
  0x0000,                                   /* no rx full objects used     */
  0x0004, 0x000c, 0x001c, 0x003c,           /* 1..4   rx full objects used */
  0x007c, 0x00fc, 0x01fc, 0x03fc,           /* 5..8   rx full objects used */
  0x07fc, 0x0ffc, 0x1ffc, 0x3ffc,           /* 9..12  rx full objects used */
  0x7ffc                                    /* 13     rx full objects used */
};
#  endif
# else
/* table used to quickly and efficiently obtain a bit mask to determine
 * if a RxFull interrupt is pending. the generated constant
 * (16-CAN_HL_HW_RX_FULL_STARTINDEX(channel))
 * should be used as an index. there will never be more than 15 RxFull
 * objects per channel because there will always be one message object used
 * for normal tx.
 */
#  if defined (C_PROCESSOR_32192)
static MEMORY_ROM canuint32 rxFullGlobalIndMask[32] = {
  0x00000000,
  0x00000001, 0x00000003, 0x00000007, 0x0000000f,
  0x0000001f, 0x0000003f, 0x0000007f, 0x000000ff,
  0x000001ff, 0x000003ff, 0x000007ff, 0x00000fff,
  0x00001fff, 0x00003fff, 0x00007fff, 0x0000ffff,
  0x0001ffff, 0x0003ffff, 0x0007ffff, 0x000fffff,
  0x001fffff, 0x003fffff, 0x007fffff, 0x00ffffff,
  0x01ffffff, 0x03ffffff, 0x07ffffff, 0x0fffffff,
  0x1fffffff, 0x3fffffff, 0x7fffffff
};
#  else
static MEMORY_ROM canuint16 rxFullGlobalIndMask[16] = {
  0x0000,                                   /* no rx full objects used     */
  0x0001, 0x0003, 0x0007, 0x000f,           /* 1..4   rx full objects used */
  0x001f, 0x003f, 0x007f, 0x00ff,           /* 5..8   rx full objects used */
  0x01ff, 0x03ff, 0x07ff, 0x0fff,           /* 9..12  rx full objects used */
  0x1fff, 0x3fff, 0x7fff                    /* 13..15 rx full objects used */
};
#  endif
# endif /* C_ENABLE_RX_BASICCAN_OBJECTS */
#endif

/***************************************************************************/
/* CAN-Hardware Data Definitions                                            */
/***************************************************************************/


/***************************************************************************/
/* external declarations                                                    */
/***************************************************************************/

#if !defined (CANDRV_SET_CODE_TEST_POINT)
# define CANDRV_SET_CODE_TEST_POINT(x)
#else
extern vuint8 tscCTKTestPointState[CTK_MAX_TEST_POINT];
#endif

/***************************************************************************/
/* global data definitions                                                 */
/***************************************************************************/

tCanRxInfoStruct          canRxInfoStruct[kCanNumberOfChannels];

volatile CanReceiveHandle canRxHandle[kCanNumberOfChannels];

/* pCanChipMsgObject is a pointer to current receive object.
   This pointer is only valid during receive-interrupt routine,
   e.g. CanMsgReceived() or PreCopy(). The pointer is used to
   directly access to DLC, ID and DATA. The pointer has
   globally scope.  */
#if defined( C_ENABLE_CONFIRMATION_FCT ) && \
    defined( C_ENABLE_DYN_TX_OBJECTS )   && \
    defined( C_ENABLE_TRANSMIT_QUEUE )
CanTransmitHandle          confirmHandle[kCanNumberOfChannels];
#endif

#if defined( C_ENABLE_CONFIRMATION_FLAG )
/* Msg(4:0750) A union type has been used. MISRA Rules 110 - no change */
volatile union CanConfirmationBits MEMORY_NEAR CanConfirmationFlags;
#endif

#if defined( C_ENABLE_INDICATION_FLAG )
/* Msg(4:0750) A union type has been used. MISRA Rules 110 - no change */
volatile union CanIndicationBits   MEMORY_NEAR CanIndicationFlags;
#endif

#if defined( C_ENABLE_VARIABLE_RX_DATALEN )
/* ##RI1.4 - 3.31: Dynamic Receive DLC */
volatile canuint8 canVariableRxDataLen[kCanNumberOfRxObjects];
#endif

/* this variable is used in the RDSBasic and RDSxx for FullCAN access
 * macros generated by CANgen. At the beginning of a Rx complete event, this
 * variable is set to point to the beginning of the data from the hardware
 * message slot, which is stored in a temporary buffer. This variable
 * (and the temporary buffer) is necessary because the M32R CAN
 * controller requires the data to be read out in one sequence. If this
 * variable is not used, the application would be given direct access to the
 * data in the hardware messsage slot in a PreCopy function, which could then
 * have invalid data.
 */
#if defined( C_ENABLE_MULTI_ECU_CONFIG )
CanChipDataPtr canRDSRxPtr[kCanNumberOfChannels];
#else
# if defined( C_SINGLE_RECEIVE_CHANNEL )
CanChipDataPtr canRDSRxPtr[1];
# else
CanChipDataPtr canRDSRxPtr[2];
# endif
#endif

/***************************************************************************/
/* local data definitions                                                  */
/***************************************************************************/

/* support for CAN driver features : */
static volatile CanTransmitHandle canHandleCurTxObj[kCanNumberOfUsedTxCANObjects];

#if defined( C_ENABLE_ECU_SWITCH_PASS )
static canuint8 canPassive[kCanNumberOfChannels];
#endif

#if defined( C_ENABLE_PART_OFFLINE )
static canuint8 canTxPartOffline[kCanNumberOfChannels];
#endif

#if defined(C_ENABLE_CAN_RAM_CHECK)
static canuint8 canComStatus[kCanNumberOfChannels]; /* stores the decision of the App after the last CAN RAM check */
#endif

#if defined( C_ENABLE_DYN_TX_OBJECTS )
static volatile canuint8 canTxDynObjReservedFlag[kCanNumberOfTxDynObjects];

 #if defined( C_ENABLE_DYN_TX_ID )
static tCanTxId0 canDynTxId0[kCanNumberOfTxDynObjects];
    #if (kCanNumberOfUsedCanTxIdTables > 1)
static tCanTxId1 canDynTxId1[kCanNumberOfTxDynObjects];
    #endif
    #if (kCanNumberOfUsedCanTxIdTables > 2)
static tCanTxId2 canDynTxId2[kCanNumberOfTxDynObjects];
    #endif
    #if (kCanNumberOfUsedCanTxIdTables > 3)
static tCanTxId3 canDynTxId3[kCanNumberOfTxDynObjects];
    #endif
    #if (kCanNumberOfUsedCanTxIdTables > 4)
static tCanTxId4 canDynTxId4[kCanNumberOfTxDynObjects];
    #endif
    #if defined( C_ENABLE_MIXED_ID )
     #if defined( C_HL_ENABLE_IDTYPE_IN_ID )
     #else
static tCanIdType                 canDynTxIdType[kCanNumberOfTxDynObjects];
     #endif
    #endif
 #endif

 #if defined( C_ENABLE_DYN_TX_DLC )
static canuint8                   canDynTxDLC[kCanNumberOfTxDynObjects];
 #endif
 #if defined( C_ENABLE_DYN_TX_DATAPTR )
static canuint8*                  canDynTxDataPtr[kCanNumberOfTxDynObjects];
 #endif
 #if defined( C_ENABLE_CONFIRMATION_FCT )
 #endif
#endif /* C_ENABLED_DYN_TX_OBJECTS */


#if defined(C_ENABLE_TX_MASK_EXT_ID)
static tCanTxId0 canTxMask0[kCanNumberOfChannels];
    #if (kCanNumberOfUsedCanTxIdTables > 1)
static tCanTxId1 canTxMask1[kCanNumberOfChannels];
    #endif
    #if (kCanNumberOfUsedCanTxIdTables > 2)
static tCanTxId2 canTxMask2[kCanNumberOfChannels];
    #endif
    #if (kCanNumberOfUsedCanTxIdTables > 3)
static tCanTxId3 canTxMask3[kCanNumberOfChannels];
    #endif
    #if (kCanNumberOfUsedCanTxIdTables > 4)
static tCanTxId4 canTxMask4[kCanNumberOfChannels];
    #endif
#endif

#if defined( C_ENABLE_VARIABLE_DLC )
static canuint8 canTxDLC_RAM[kCanNumberOfTxObjects];
#endif

#if defined( C_ENABLE_TRANSMIT_QUEUE )
static volatile canuint8 canTxQueueCnt[kCanNumberOfChannels];
/* tx queue flags          */
static canuint8 canTxQueueFlags[kCanNumberOfTxObjects];
# endif

static volatile canuint8 canStatus[kCanNumberOfChannels];

#if defined( C_ENABLE_INTCTRL_BY_APPL ) || \
    ( C_SECURITY_LEVEL == 0 )  || \
    ( defined ( C_ENABLE_OSEK_OS ) && defined ( C_ENABLE_OSEK_OS_INTCTRL ) )
#else
/* canInterruptOldStatus is necessary to save the status of IEN before
   disabling CAN interrupts and restore THIS(!) status when restoring
   CAN interrupts. */
/*disabled lint -esym(528,canInterruptOldStatus)*/
static tCanHLIntOld    canInterruptOldStatus;
#endif
static cansint8        canGlobalInterruptCounter;
static CANSINTX        canCanInterruptCounter[kCanNumberOfChannels];
#if defined(C_HL_ENABLE_CAN_IRQ_DISABLE)
static tCanLLCanIntOld canCanInterruptOldStatus[kCanNumberOfHwChannels];
#endif
#if defined(C_HL_ENABLE_LAST_INIT_OBJ)
static CanInitHandle lastInitObject[kCanNumberOfChannels];
#endif
#if defined( C_ENABLE_TX_POLLING )          || \
    defined( C_ENABLE_RX_FULLCAN_POLLING )  || \
    defined( C_ENABLE_RX_BASICCAN_POLLING ) || \
    defined( C_ENABLE_ERROR_POLLING )       || \
    defined( C_ENABLE_CANCEL_IN_HW )
# if defined(C_DISABLE_TASK_RECURSION_CHECK) && defined(C_DISABLE_USER_CHECK)
# else
static canuint8 canPollingTaskActive[kCanNumberOfChannels];
# endif
#endif

#if defined ( C_ENABLE_CAN_TX_CONF_FCT )
/* ##RI-1.10 Common Callbackfunction in TxInterrupt */
static tCanTxConfInfoStruct    txInfoStructConf[kCanNumberOfChannels];
#endif

#if defined( C_ENABLE_COND_RECEIVE_FCT )
static volatile canuint8 canMsgCondRecState[kCanNumberOfChannels];
#endif

#if defined(C_ENABLE_RX_QUEUE)
/* Buffer for Receive-FIFO */
static tCanRxQueueObject canRxQueueBuf[kCanRxQueueSize];  /* buffer for msg and handle           */
static volatile vuintx   canRxQueueWriteIndex;            /* index in canRxQueueBuf              */
static volatile vuintx   canRxQueueReadIndex;             /* index in canRxQueueBuf              */
static volatile vuintx   canRxQueueCount;                 /* count of messages in canRxQueueBuf  */
#endif

#if defined ( C_COMP_MITSUBISHI_M32R )
/* used in the functions CanLL_GlobalInterruptDisable and
 * CanLL_GlobalInterruptRestore, because the inline assembler
 * can only access global variables and not variables passed on as
 * function parameters. For this reason we use this variable to read and
 * write to in inline assembly.
 */
/*lint -esym(728,gblInterruptFlag)*/
static volatile tCanHLIntOld gblInterruptFlag;
#endif

/* counter used in CanLL_RxCopyFromCan operation. higher layer doesn't
 * allow local parameter here therefore a module global has to be used.
 * counter is only accessed in CanLL_RxCopyFromCan so no read/write mo-
 * dify issues exist.
 */
static canuint8  canMemCopyCnt;

#if defined( C_ENABLE_CANCEL_IN_HW )
static canuint8  CanMsgControl[kCanNumberOfChannels];
#endif

/***************************************************************************/
/*  local prototypes                                                       */
/***************************************************************************/
#if defined ( C_ENABLE_RX_FULLCAN_OBJECTS )  || \
    defined ( C_ENABLE_RX_BASICCAN_OBJECTS )
# if defined( C_ENABLE_RX_QUEUE )
static canuint8 CanHL_ReceivedRxHandleQueue(CAN_CHANNEL_CANTYPE_FIRST CanReceiveHandle rxHandle);
# endif
canuint8 CanHL_ReceivedRxHandle( CAN_CHANNEL_CANTYPE_FIRST CanReceiveHandle rxHandle );
# if defined( C_ENABLE_INDICATION_FLAG ) || \
     defined( C_ENABLE_INDICATION_FCT )
static void CanHL_IndRxHandle( CanReceiveHandle rxHandle );
# endif
#endif
#if defined ( C_ENABLE_RX_BASICCAN_OBJECTS )
static void CanBasicCanMsgReceived(CAN_HW_CHANNEL_CANTYPE_FIRST CanObjectHandle rxObjHandle);
#endif
#if defined ( C_ENABLE_RX_FULLCAN_OBJECTS )
static void CanFullCanMsgReceived(CAN_HW_CHANNEL_CANTYPE_FIRST CanObjectHandle rxObjHandle);
#endif

static void CanHL_TxConfirmation(CAN_CHANNEL_CANTYPE_FIRST CanObjectHandle txObjHandle);
static canuint8 CanCopyDataAndStartTransmission(CAN_CHANNEL_CANTYPE_FIRST CanObjectHandle txObjHandle, CanTransmitHandle txHandle)  C_API_3;   /*lint !e14 !e31*/

#if defined(C_ENABLE_CAN_RAM_CHECK)
static canuint8 CanCheckMemory(CAN_CHANNEL_CANTYPE_ONLY);
#endif

#if defined( C_ENABLE_TRANSMIT_QUEUE )
static void CanDelQueuedObj( CAN_CHANNEL_CANTYPE_ONLY );
#endif
#if defined ( C_HL_ENABLE_TX_MSG_DESTROYED )
static CANUINTX CanTxMsgDestroyed ( CAN_CHANNEL_CANTYPE_FIRST CanObjectHandle txObjHandle);
#endif

static void CanHL_ErrorHandling( CAN_HW_CHANNEL_CANTYPE_ONLY );

/* this function processes the CAN events and is called by CanIsr() */
#if defined ( C_ENABLE_INTERRUPT )
# if defined (C_PROCESSOR_32192)
static CanObjectHandle CanGetIntPendingObjectHandle(canuint32 mask);
# else
static CanObjectHandle CanGetIntPendingObjectHandle(canuint16 mask);
# endif
void CanInterrupt( CAN_CHANNEL_CANTYPE_ONLY );
#endif

/***************************************************************************/
/*  Error Check                                                            */
/***************************************************************************/
#if defined( C_CPUTYPE_8BIT )
# if (kCanNumberOfTxObjects > 250)
#  error "Too many transmit messages. This driver can only handle up to 250 transmit messages"
# endif
# if (kCanNumberOfRxObjects > 250)
#  error "Too many receive messages. This driver can only handle up to 250 receive messages"
# endif
#endif

#if defined ( C_SEARCH_HASH )
# if defined( C_ENABLE_EXTENDED_ID )
#  if (((kHashSearchListCountEx >  8192) && (kHashSearchMaxStepsEx == 1)) || \
     ((kHashSearchListCountEx > 16384) && (kHashSearchMaxStepsEx <  1)))
#   error "Hash table for extended ID is too large"
#  endif
# endif
# if defined(C_ENABLE_MIXED_ID) || !defined( C_ENABLE_EXTENDED_ID )
#  if (((kHashSearchListCount >  8192) && (kHashSearchMaxSteps == 1)) || \
     ((kHashSearchListCount > 16384) && (kHashSearchMaxSteps <  1)))
#   error "Hash table for standard ID is too large"
#  endif
# endif
#endif


#if defined ( C_ENABLE_RX_QUEUE )
# if defined ( C_CPUTYPE_8BIT ) && ( kCanRxQueueSize > 256 )
#  error "With 8 Bit CPU the Rx queue size has to be smaller or equal to 256"
# endif
#endif


/***************************************************************************/
/*  Functions                                                              */
/***************************************************************************/

#if defined (C_ENABLE_MEMCOPY_SUPPORT)
/****************************************************************************
| NAME:             CanCopyFromCan
| CALLED BY:        Application
| PRECONDITIONS:    none
|
| INPUT PARAMETERS: void *             dst        | pointer to destionation buffer
|                   CanChipDataPtr     src        | pointer to CAN buffer
|                   canuint8           len        | number of bytes to copy
|
| RETURN VALUES:    -
|
| DESCRIPTION:      copy data from CAN receive buffer to RAM.
|
| ATTENTION:
****************************************************************************/
void CanCopyFromCan(void *dst, CanChipDataPtr src, canuint8 len)
{
  /* counter used to copy all bytes */
  canuint8 cnt;

  /* copy all bytes from the CAN buffer to the RAM buffer */
  for (cnt=0; cnt<len; cnt++)
  {
    ((canuint8*)dst)[cnt] = src[cnt];
  }
}


/****************************************************************************
| NAME:             CanCopyToCan
| CALLED BY:        Application
| PRECONDITIONS:    none
|
| INPUT PARAMETERS: void *             src        | pointer to source buffer
|                   CanChipDataPtr     dst        | pointer to CAN buffer
|                   canuint8           len        | number of bytes to copy
|
| RETURN VALUES:    -
|
| DESCRIPTION:      copy data from CAN receive buffer to RAM.
|
| ATTENTION:
****************************************************************************/
void CanCopyToCan(CanChipDataPtr dst, void * src, canuint8 len)
{
  /* counter used to copy all bytes */
  canuint8 cnt;

  /* copy all bytes from the RAM buffer to the CAN buffer */
  for (cnt=0; cnt<len; cnt++)
  {
    dst[cnt] = ((canuint8*)src)[cnt];
  }
}
#endif




/****************************************************************************
| NAME:             CanLL_GlobalInterruptDisable
|
| INPUT PARAMETERS: ptr to flag where old interrupt status should be stored.
|
| RETURN VALUES:    none
|
| DESCRIPTION:      Disables the global interrupts and stores the original
|                   value of the PSW register at address localInterrupt-
|                   OldFlagPtr
|
| NOTE:             The global variable gblInterruptFlag had to be introduced
|                   to make this work, because the inline assembler can't
|                   access function parameters.
|
****************************************************************************/
static void CanLL_GlobalInterruptDisable(tCanHLIntOld * localInterruptOldFlagPtr)
{
#ifndef CAN_SIM_CFG
#if defined ( C_COMP_MITSUBISHI_M32R )
  /*lint -save -e**/
  #pragma keyword asm on
  /* save r0, r1, r2 to the stack */
  asm ( " ST r0, @-sp " );
  asm ( " ST r1, @-sp " );
  asm ( " ST r2, @-sp " );
  /* save the psw to r0 and save the last state of IE for restore */
  asm ( " MVFC r0, psw " );
  /* make a backup copy of the psw, because there is the
   * possibility of changing the contents through another interrupt
   * while manipulating the psw in this context
   */
  asm ( " MV r2, r0 " );
  /* disable global interrupts; Bit IE at 0x00000040 */
  asm ( " LDI r1, #~H'0040 " );
  asm ( " AND r0, r1 " );
  /* give the changed psw back from r0 */
  asm ( " MVTC r0, psw " );
  /* announce the C variable to the assembler */
  asm ( " .GLOBAL _gblInterruptFlag " );
  /* get the address of the variable */
  asm ( " LD24 r1, #_gblInterruptFlag " );
  /* save the psw to the global variable */
  asm ( " STH r2, @r1 " );
  /* restore r0, r1, r2 from the stack */
  asm ( " LD r2, @sp+ " );
  asm ( " LD r1, @sp+ " );
  asm ( " LD r0, @sp+ " );
  #pragma keyword asm off
  /*lint -restore*/
#endif
#endif

  *localInterruptOldFlagPtr = gblInterruptFlag;
} /* end of CanLL_GlobalInterruptDisable */


/****************************************************************************
| NAME:             CanLL_GlobalInterruptRestore
|
| INPUT PARAMETERS: flag where old interrupt status is stored.
|
| RETURN VALUES:    none
|
| DESCRIPTION:      Restores the original value of the PSW register from
|                  localInterruptOldFlag
|
| NOTE:             The global variable gblInterruptFlag had to be introduced
|                   to make this work, because the inline assembler can't
|                   access function parameters.
|
****************************************************************************/
static void CanLL_GlobalInterruptRestore(tCanHLIntOld  localInterruptOldFlag)
{
  /* only accept new interrupts, if the Bit EI was set in
   * localInterruptOldFlag
   */
  if((localInterruptOldFlag & (tCanHLIntOld)0x0040) == (tCanHLIntOld)0x0040)
  {
#ifndef CAN_SIM_CFG
#if defined ( C_COMP_MITSUBISHI_M32R )
    #pragma keyword asm on
    /* save r0 and r1 to the stack */
    asm ( " ST r0, @-sp " );
    asm ( " ST r1, @-sp " );
    /* save the psw to r0 */
    asm ( " MVFC r0, psw " );
    /* enable global interrupts; Bit IE at 0x00000040 */
    asm ( " LDI r1, #H'0040 " );
    asm ( " OR r0, r1 " );
    /* give the changed psw back from r0 */
    asm ( " MVTC r0, psw  " );
    /* restore r0 and r1 from the stack */
    asm ( " LD r1, @sp+ " );
    asm ( " LD r0, @sp+ " );
    #pragma keyword asm off
#endif
#endif
  }
} /* end of CanLL_GlobalInterruptRestore */


#if defined ( C_ENABLE_INTERRUPT )
/****************************************************************************
| NAME:             CanGetIntPendingObjectHandle
| CALLED BY:        CanInterrupt()
| PRECONDITIONS:    CAN interrupt pending
|
| INPUT PARAMETERS: bit mask of message slots with a pending interrupt.
|
| RETURN VALUES:    object handle to object with pending interrupt or
|                   kCanInvalidObjectHandle instead
|
| DESCRIPTION:      this function obtains the object handle from a bit mask
|
****************************************************************************/
# if defined (C_PROCESSOR_32192)
static CanObjectHandle CanGetIntPendingObjectHandle(canuint32 mask)
#else
static CanObjectHandle CanGetIntPendingObjectHandle(canuint16 mask)
#endif
{
  CanObjectHandle result;
  cansint8  cnt;

  result = kCanInvalidObjectHandle; /* initialize to invalid value */

  /* go through all message slots that could have a pending interrupt */
  #if defined (C_PROCESSOR_32192)
  for (cnt=31; cnt>=0; cnt--)
  #else
  for (cnt=15; cnt>=0; cnt--)
  #endif
  { /* interrupt pending? */
    if ((mask & msgSlotBitmask[(CanObjectHandle)cnt]) == msgSlotBitmask[(CanObjectHandle)cnt])
    {
      result = (CanObjectHandle)cnt; /* store object handle */
      break; /* done here so break from for loop */
    }
  }

  return result;  /* return the object handle */
} /* end of CanGetIntPendingObjectHandle */


/****************************************************************************
| NAME:             CanInterrupt
| CALLED BY:        CanIsr()
| PRECONDITIONS:    CAN interrupt pending
|
| INPUT PARAMETERS: CanChannelHandle  channel        | current CAN channel
|
| RETURN VALUES:    none
|
| DESCRIPTION:      this function processes the CAN events and is called by
|                   CanIsr()
|
****************************************************************************/
void CanInterrupt( CAN_CHANNEL_CANTYPE_ONLY )
{
  /* hardware object handle. holds the object number which has a pending
   * event.
   */
  CanObjectHandle hwObjHandle;

# if defined ( C_ENABLE_HW_LOOP_TIMER )
  /* start hw loop timer before entering while loop */
  ApplCanTimerStart(kCanLoopInterrupt);
# endif

  /* is there a msg slot irq pending? */
# if defined ( C_ENABLE_ERROR_POLLING )
  while ((CAN_BASE_ADR(channel)->slist & CAN_BASE_ADR(channel)->slimk )!= 0)
# else
  while (((CAN_BASE_ADR(channel)->erist & kOIS) != 0) || ((CAN_BASE_ADR(channel)->slist & CAN_BASE_ADR(channel)->slimk )!= 0))
# endif
  {
# if defined ( C_ENABLE_HW_LOOP_TIMER )
    if(!ApplCanTimerLoop(kCanLoopInterrupt))
    {
      /* stop loop if application indicates it wants to */
      break;
    }
# endif

# if defined ( C_ENABLE_ERROR_POLLING )
# else
    /* process a possible pending bus off event */
    CanHL_ErrorHandling( CAN_CHANNEL_CANPARA_ONLY );
# endif

    /* obtain the number of the message slot that finished receiving or
     * transmitting
     */
    hwObjHandle = CanGetIntPendingObjectHandle((CAN_BASE_ADR(channel)->slist & CAN_BASE_ADR(channel)->slimk));

    if (hwObjHandle != kCanInvalidObjectHandle)
    {

      /* process the event */
# if !defined ( C_ENABLE_RX_BASICCAN_POLLING ) && defined ( C_ENABLE_RX_BASICCAN_OBJECTS )
      if (hwObjHandle >= CAN_HL_HW_RX_BASIC_STARTINDEX(channel))
      {
        /* clear the interrupt flag for the pending event */
        CAN_BASE_ADR(channel)->slist = ~msgSlotBitmask[hwObjHandle];
        /* process rx basic msg */
        CanBasicCanMsgReceived( CAN_CHANNEL_CANPARA_FIRST hwObjHandle );
      }
# endif /* !C_ENABLE_RX_BASICCAN_POLLING && C_ENABLE_RX_BASICCAN_OBJECTS */

# if !defined ( C_ENABLE_RX_FULLCAN_POLLING ) && defined ( C_ENABLE_RX_FULLCAN_OBJECTS )
      if ((hwObjHandle >= CAN_HL_HW_RX_FULL_STARTINDEX(channel)) && \
          (hwObjHandle <CAN_HL_HW_RX_BASIC_STARTINDEX(channel)))
      {
        /* clear the interrupt flag for the pending event */
        CAN_BASE_ADR(channel)->slist = ~msgSlotBitmask[hwObjHandle];
        /* process rx full msg */
        CanFullCanMsgReceived( CAN_CHANNEL_CANPARA_FIRST hwObjHandle );
      }
# endif /* !C_ENABLE_RX_FULLCAN_POLLING && C_ENABLE_RX_FULLCAN_OBJECTS */

# if !defined ( C_ENABLE_TX_POLLING )
      if (hwObjHandle < CAN_HL_HW_UNUSED_STARTINDEX(channel))
      {
        /* clear the interrupt flag for the pending event */
        CAN_BASE_ADR(channel)->slist = ~msgSlotBitmask[hwObjHandle];
        /* process tx msg */
        CanHL_TxConfirmation(CAN_CHANNEL_CANPARA_FIRST hwObjHandle );
      }
# endif /* C_ENABLE_TX_POLLING */
    } /* (hwObjHandle != kCanInvalidObjectHandle) */
  } /* (CAN_BASE_ADR(channel)->erist & kOIS) || (CAN_BASE_ADR(channel)->slist != 0) */

# if defined ( C_ENABLE_HW_LOOP_TIMER )
  /* stop hw loop timer because loop no longer active */
  ApplCanTimerEnd(kCanLoopInterrupt);
# endif
} /* end of CanInterrupt() */
#endif /* C_ENABLE_INTERRUPT */

/****************************************************************************
| NAME:             CanIsr_0
| CALLED BY:
| PRECONDITIONS:
| INPUT PARAMETERS: none
| RETURN VALUES:    none
| DESCRIPTION:      Interrupt service functions according to the CAN controller
|                   interrupt stucture
|                   - check for the interrupt reason ( interrupt source )
|                   - work appropriate interrupt:
|                     + error interrupt
|                     + basic can receive
|                     + full can receive
|                     + can transmit
|
****************************************************************************/
#if defined( C_ENABLE_OSEK_OS ) && defined( C_ENABLE_INT_OSCAT2 )
ISR(CanIsr_0)
{
# if defined( C_ENABLE_INTERRUPT )
#  if defined( C_SINGLE_RECEIVE_CHANNEL )
  CanInterrupt();
#  else
#   if defined( C_ENABLE_MULTI_ECU_CONFIG )
  CanInterrupt(CanPhysToLogChannel[V_ACTIVE_IDENTITY_LOG][0]);
#   else
  CanInterrupt(kCanChannelIndex_0);
#   endif
#  endif
# endif
}
#else
void CanIsr_0(void)
{
# if defined ( C_ENABLE_INT_REG_SAVING )
/* push the registers that possible currently in use to the stack */
#  if defined ( C_COMP_MITSUBISHI_M32R )
#pragma keyword asm on
  /* r0 to r7, r14 to the stack */
  asm ( " ST r0, @-sp " );
  asm ( " ST r1, @-sp " );
  asm ( " ST r2, @-sp " );
  asm ( " ST r3, @-sp " );
  asm ( " ST r4, @-sp " );
  asm ( " ST r5, @-sp " );
  asm ( " ST r6, @-sp " );
  asm ( " ST r7, @-sp " );
  asm ( " ST r14, @-sp " );
#pragma keyword asm off
#  endif /* C_COMP_MITSUBISHI_M32R */
# endif /* C_ENABLE_INT_REG_SAVING */
# if defined ( C_ENABLE_INTERRUPT )
#  if defined( C_SINGLE_RECEIVE_CHANNEL )
  CanInterrupt();
#  else
#   if defined( C_ENABLE_MULTI_ECU_CONFIG )
  CanInterrupt(CanPhysToLogChannel[V_ACTIVE_IDENTITY_LOG][0]);
#   else
  CanInterrupt(kCanChannelIndex_0);
#   endif
#  endif
# endif

# if defined ( C_ENABLE_INT_REG_SAVING )
/* restore registers that not saved by the Compiler */
#  if defined ( C_COMP_MITSUBISHI_M32R )
#pragma keyword asm on
  /* r14, r7 to r0 from the stack */
  asm ( " LD r14, @sp+ " );
  asm ( " LD r7, @sp+ " );
  asm ( " LD r6, @sp+ " );
  asm ( " LD r5, @sp+ " );
  asm ( " LD r4, @sp+ " );
  asm ( " LD r3, @sp+ " );
  asm ( " LD r2, @sp+ " );
  asm ( " LD r1, @sp+ " );
  asm ( " LD r0, @sp+ " );
#pragma keyword asm off
#  endif /* C_COMP_MITSUBISHI_M32R */
# endif /* C_ENABLE_INT_REG_SAVING */
} /* end of CanIsr */
#endif /* C_ENABLE_OSEK_OS && C_ENABLE_INT_OSCAT2 */
/****************************************************************************
| NAME:             CanIsr_1
| CALLED BY:
| PRECONDITIONS:
| INPUT PARAMETERS: none
| RETURN VALUES:    none
| DESCRIPTION:      Interrupt service functions according to the CAN controller
|                   interrupt stucture
|                   - check for the interrupt reason ( interrupt source )
|                   - work appropriate interrupt:
|                     + error interrupt
|                     + basic can receive
|                     + full can receive
|                     + can transmit
|
****************************************************************************/
#if defined( C_ENABLE_OSEK_OS ) && defined( C_ENABLE_INT_OSCAT2 )
ISR(CanIsr_1)
{
# if defined( C_ENABLE_INTERRUPT )
#  if defined( C_SINGLE_RECEIVE_CHANNEL )
  CanInterrupt();
#  else
#   if defined( C_ENABLE_MULTI_ECU_CONFIG )
  CanInterrupt(CanPhysToLogChannel[V_ACTIVE_IDENTITY_LOG][1]);
#   else
  CanInterrupt(kCanChannelIndex_1);
#   endif
#  endif
# endif
}
#else
void CanIsr_1(void)
{
# if defined ( C_ENABLE_INT_REG_SAVING )
/* push the registers that possible currently in use to the stack */
#  if defined ( C_COMP_MITSUBISHI_M32R )
#pragma keyword asm on
  /* r0 to r7, r14 to the stack */
  asm ( " ST r0, @-sp " );
  asm ( " ST r1, @-sp " );
  asm ( " ST r2, @-sp " );
  asm ( " ST r3, @-sp " );
  asm ( " ST r4, @-sp " );
  asm ( " ST r5, @-sp " );
  asm ( " ST r6, @-sp " );
  asm ( " ST r7, @-sp " );
  asm ( " ST r14, @-sp " );
#pragma keyword asm off
#  endif /* C_COMP_MITSUBISHI_M32R */
# endif /* C_ENABLE_INT_REG_SAVING */
# if defined ( C_ENABLE_INTERRUPT )
#  if defined( C_SINGLE_RECEIVE_CHANNEL )
  CanInterrupt();
#  else
#   if defined( C_ENABLE_MULTI_ECU_CONFIG )
  CanInterrupt(CanPhysToLogChannel[V_ACTIVE_IDENTITY_LOG][1]);
#   else
  CanInterrupt(kCanChannelIndex_1);
#   endif
#  endif
# endif

# if defined ( C_ENABLE_INT_REG_SAVING )
/* restore registers that not saved by the Compiler */
#  if defined ( C_COMP_MITSUBISHI_M32R )
#pragma keyword asm on
  /* r14, r7 to r0 from the stack */
  asm ( " LD r14, @sp+ " );
  asm ( " LD r7, @sp+ " );
  asm ( " LD r6, @sp+ " );
  asm ( " LD r5, @sp+ " );
  asm ( " LD r4, @sp+ " );
  asm ( " LD r3, @sp+ " );
  asm ( " LD r2, @sp+ " );
  asm ( " LD r1, @sp+ " );
  asm ( " LD r0, @sp+ " );
#pragma keyword asm off
#  endif /* C_COMP_MITSUBISHI_M32R */
# endif /* C_ENABLE_INT_REG_SAVING */
} /* end of CanIsr */
#endif /* C_ENABLE_OSEK_OS && C_ENABLE_INT_OSCAT2 */

/****************************************************************************
| NAME:             CanInit
| CALLED BY:        CanInitPowerOn(), Network management
| PRECONDITIONS:    none
| INPUT PARAMETERS: Handle to initstructure
| RETURN VALUES:    none
| DESCRIPTION:      initialization of chip-hardware
|                   initialization of receive and transmit message objects
****************************************************************************/
C_API_1 void C_API_2 CanInit( CAN_CHANNEL_CANTYPE_FIRST CanInitHandle initObject )
{
  CanObjectHandle        hwObjHandle;
#if defined( C_ENABLE_TX_FULLCAN_OBJECTS )      ||\
    defined( C_ENABLE_CAN_CANCEL_NOTIFICATION ) || \
    defined( C_ENABLE_CAN_MSG_TRANSMIT_CANCEL_NOTIFICATION )
  CanTransmitHandle      txHandle;
#endif
#if defined ( C_ENABLE_RX_FULLCAN_OBJECTS )
  CanReceiveHandle       rxHandle;
#endif
  CanObjectHandle        logTxObjHandle;

  canuint8 obj;

#if defined(C_HL_ENABLE_LAST_INIT_OBJ)
  lastInitObject[channel] = initObject;
#endif

#if defined ( C_MULTIPLE_RECEIVE_CHANNEL )
/* Msg(4:3759) Implicit conversion: int to unsigned short. MISRA Rule 43 - no change in RI 1.4 */
  initObject  += CAN_HL_INIT_OBJ_STARTINDEX(channel);
#endif


  assertUser(initObject < CAN_HL_INIT_OBJ_STOPINDEX(channel), channel, kErrorInitObjectHdlTooLarge);
  assertGen(initObject < kCanNumberOfInitObjects, channel, kErrorInitObjectHdlTooLarge);
#if defined ( C_MULTIPLE_RECEIVE_CHANNEL )
  assertUser(channel < kCanNumberOfChannels, channel, kErrorChannelHdlTooLarge);
#endif
#if defined ( C_ENABLE_MULTI_ECU_CONFIG )
  assertUser(( (CanChannelIdentityAssignment[channel] & V_ACTIVE_IDENTITY_MSK) != (tVIdentityMsk)0 ), channel, kErrorDisabledChannel);
#endif


  {
    /* ESCAN00007150, ESCAN00009086 - Transmit Abort */
    for(obj = 0; obj < CAN_HL_HW_TX_STOPINDEX(channel); obj++)
    {
      if((CAN_BASE_ADR(channel)->mslcnt[obj] & 0x81) == 0x80)
      {
        /* abort only if msg slot is in transmit mode and sending is not completed */
        CAN_BASE_ADR(channel)->mslcnt[obj] = kTA;
      }
    }

    #if defined ( C_PROCESSOR_32176 ) || \
        defined ( C_PROCESSOR_32192 )
    if((CAN_BASE_ADR(channel)->stat & kBOS) == kBOS)
    {
      /* First clear BusOff: this is necessary, because the CAN controller does */
      /* not enter Reset mode if it is in BusOff state with dominant CAN bus.   */
      CAN_BASE_ADR(channel)->cnt |= kRBO;
    }
    #endif

    /* request CAN controller to enter reset state */
    CAN_BASE_ADR(channel)->cnt |= kRST;

    #if defined ( C_ENABLE_HW_LOOP_TIMER )
    /* start hw loop timer before entering while loop for hardware handshake */
    ApplCanTimerStart(kCanLoopResetSet);
    #endif

    /* wait until CAN controller is in reset state */
    while ((CAN_BASE_ADR(channel)->stat & kCRS) != kCRS)
    {
      #if defined ( C_ENABLE_HW_LOOP_TIMER )
      if(!ApplCanTimerLoop(kCanLoopResetSet))
      {
        /* stop loop if application indicates it wants to */
        break;
      }
      #endif
    }

    #if defined ( C_ENABLE_HW_LOOP_TIMER )
    /* stop hw loop timer because loop no longer active */
    ApplCanTimerEnd(kCanLoopResetSet);
    #endif

    #if defined ( C_ENABLE_INTERRUPT )
    /* set interrupt priority level to enable the CAN interrupts for M32R
     * NOTE: this level also has to be enabled for the M32R system using the
     *       Interrupt Mask Register (IMASK). IMASK can't be written unless
     *       the IE bit is disabled in the PSW register in the EIT handler.
     *       for this reason, the configuration of the IMASK register has to
     *       be done on application level in the EIT handler. */
    # if defined( C_SINGLE_RECEIVE_CHANNEL )
    CAN_ICANx() = CAN_INT_LEVEL(channel);
    # else
    if(CanBaseAdr[channel] == 0x00801000)
    { CAN_ICAN0() = CAN_INT_LEVEL(channel); }
    else{ CAN_ICAN1() = CAN_INT_LEVEL(channel); }
    # endif
    #else
    /* disable CAN interrupts */
    # if defined( C_SINGLE_RECEIVE_CHANNEL )
    CAN_ICANx() = kLvlIrqDisabled;
    # else
    if(CanBaseAdr[channel] == 0x00801000)
    { CAN_ICAN0() = kLvlIrqDisabled; }
    else{ CAN_ICAN1() = kLvlIrqDisabled; }
    # endif
    #endif

    /* initialize the CAN error and status interrupts by clearing all potential
     * pending CAN error and status interrupt requests.
     */
    CAN_BASE_ADR(channel)->erist = 0;

    /* configure the CAN error and status interrupts. this driver only uses the
     * bus off error interrupt.
     */
    #if defined ( C_ENABLE_ERROR_POLLING )
    if(canCanInterruptCounter[channel] == 0)
    {
      CAN_BASE_ADR(channel)->erimk &= (canuint8)~kOIM;/* disable bus off interrupt   */
    }
    #else
    if(canCanInterruptCounter[channel] == 0)
    {
      CAN_BASE_ADR(channel)->erimk |= kOIM; /* enable bus off interrupts   */
    }
    #endif

    /* initialize all message slot interrupts by clearing potentially pending
     * interrupt requests.
     */
    CAN_BASE_ADR(channel)->slist = 0;

    /* configure the BasicCAN message slot interrupts (objects 14 and 15). the
     * interrupts for the other message slots will be configured at a later point
     * for each messag slot independantly.
     */

    #if defined ( C_ENABLE_RX_BASICCAN_OBJECTS )
    # if defined ( C_ENABLE_RX_BASICCAN_POLLING )
    /* disable BasicCAN interrupts*/
    if(canCanInterruptCounter[channel] == 0)
    {
      CAN_BASE_ADR(channel)->slimk &= ~(kIRBCA|kIRBCB);
    }
    # else
    /* enable BasicCAN interrupts */
    if(canCanInterruptCounter[channel] == 0)
    {
      CAN_BASE_ADR(channel)->slimk |= (kIRBCA|kIRBCB);
    }
    # endif
    #endif

    #if defined (C_ENABLE_EXTENDED_ID)
    # if defined (C_ENABLE_MIXED_ID)
    CAN_BASE_ADR(channel)->extid = CanInitIDType[channel];
    # else
    CAN_BASE_ADR(channel)->extid = kIDEALL;
    # endif
    #else
    CAN_BASE_ADR(channel)->extid = ~kIDEALL;
    #endif

    /* configure baudrate and bittiming parameters from generated init-structures  */
    CAN_BASE_ADR(channel)->conf = CanInitBT[initObject];   /* configure bittiming  */
    CAN_BASE_ADR(channel)->brp  = CanInitCCLK[initObject]; /* configure baudrate   */

    /* configure global mask, which is valid for FullCAN receive msg objects*/
    #if defined( C_ENABLE_RX_MASK_EXT_ID )
    # if defined (C_PROCESSOR_32192)
    /* global mask A */
    CAN_BASE_ADR(channel)->gmskas0 = MK_IDSTD0(C_MASK_EXT_ID); /*stdid0*/
    CAN_BASE_ADR(channel)->gmskas1 = MK_IDSTD1(C_MASK_EXT_ID); /*stdid1*/
    /* global mask B */
    CAN_BASE_ADR(channel)->gmskbs0 = MK_IDSTD0(C_MASK_EXT_ID); /*stdid0*/
    CAN_BASE_ADR(channel)->gmskbs1 = MK_IDSTD1(C_MASK_EXT_ID); /*stdid1*/
    # else
    CAN_BASE_ADR(channel)->gmsks0 = MK_IDSTD0(C_MASK_EXT_ID);  /*stdid0*/
    CAN_BASE_ADR(channel)->gmsks1 = MK_IDSTD1(C_MASK_EXT_ID);  /*stdid1*/
    # endif
    #else
    /* set all bits of ID to must match */
    # if defined (C_PROCESSOR_32192)
    /* global mask A */
    CAN_BASE_ADR(channel)->gmskas0 = ((canuint8) 0x1F); /*stdid0*/
    CAN_BASE_ADR(channel)->gmskas1 = ((canuint8) 0x3F); /*stdid1*/
    /* global mask B */
    CAN_BASE_ADR(channel)->gmskbs0 = ((canuint8) 0x1F); /*stdid0*/
    CAN_BASE_ADR(channel)->gmskbs1 = ((canuint8) 0x3F); /*stdid1*/
    # else
    CAN_BASE_ADR(channel)->gmsks0 = ((canuint8) 0x1F); /*stdid0*/
    CAN_BASE_ADR(channel)->gmsks1 = ((canuint8) 0x3F); /*stdid1*/
    # endif
    #endif

    #if defined ( C_ENABLE_EXTENDED_ID )
    # if defined( C_ENABLE_RX_MASK_EXT_ID )
    #  if defined (C_PROCESSOR_32192)
    /* global mask A */
    CAN_BASE_ADR(channel)->gmskae0 = MK_IDEXT0(C_MASK_EXT_ID);  /*extid0*/
    CAN_BASE_ADR(channel)->gmskae1 = MK_IDEXT1(C_MASK_EXT_ID);  /*extid1*/
    CAN_BASE_ADR(channel)->gmskae2 = MK_IDEXT2(C_MASK_EXT_ID);  /*extid2*/
    /* global mask B */
    CAN_BASE_ADR(channel)->gmskbe0 = MK_IDEXT0(C_MASK_EXT_ID);  /*extid0*/
    CAN_BASE_ADR(channel)->gmskbe1 = MK_IDEXT1(C_MASK_EXT_ID);  /*extid1*/
    CAN_BASE_ADR(channel)->gmskbe2 = MK_IDEXT2(C_MASK_EXT_ID);  /*extid2*/
    #  else
    CAN_BASE_ADR(channel)->gmske0 = MK_IDEXT0(C_MASK_EXT_ID);  /*extid0*/
    CAN_BASE_ADR(channel)->gmske1 = MK_IDEXT1(C_MASK_EXT_ID);  /*extid1*/
    CAN_BASE_ADR(channel)->gmske2 = MK_IDEXT2(C_MASK_EXT_ID);  /*extid2*/
    #  endif
    # else
    /* set all bits of ID to must match */
    #  if defined (C_PROCESSOR_32192)
    /* global mask A */
    CAN_BASE_ADR(channel)->gmskae0 = ((canuint8) 0x0F); /*extid0*/
    CAN_BASE_ADR(channel)->gmskae1 = ((canuint8) 0xFF); /*extid1*/
    CAN_BASE_ADR(channel)->gmskae2 = ((canuint8) 0x3F); /*extid2*/
    /* global mask B */
    CAN_BASE_ADR(channel)->gmskbe0 = ((canuint8) 0x0F); /*extid0*/
    CAN_BASE_ADR(channel)->gmskbe1 = ((canuint8) 0xFF); /*extid1*/
    CAN_BASE_ADR(channel)->gmskbe2 = ((canuint8) 0x3F); /*extid2*/
    #  else
    CAN_BASE_ADR(channel)->gmske0 = ((canuint8) 0x0F); /*extid0*/
    CAN_BASE_ADR(channel)->gmske1 = ((canuint8) 0xFF); /*extid1*/
    CAN_BASE_ADR(channel)->gmske2 = ((canuint8) 0x3F); /*extid2*/
    #  endif
    # endif
    #endif

    #if defined ( C_ENABLE_RX_BASICCAN_OBJECTS )
    # if defined ( C_ENABLE_MIXED_ID )
    /* configure mask for BasicCAN object 14/30 */
    CAN_BASE_ADR(channel)->lmskas0 = CanInitMsg14MskStd0[initObject];       /*stdid0*/
    CAN_BASE_ADR(channel)->lmskas1 = CanInitMsg14MskStd1[initObject];       /*stdid1*/
    CAN_BASE_ADR(channel)->lmskbe0 = CanInitMsg14MskExt0[initObject];       /*extid0*/
    CAN_BASE_ADR(channel)->lmskbe1 = CanInitMsg14MskExt1[initObject];       /*extid1*/
    CAN_BASE_ADR(channel)->lmskbe2 = CanInitMsg14MskExt2[initObject];       /*extid2*/
    /* configure mask for BasicCAN object 15/31 */
    CAN_BASE_ADR(channel)->lmskbs0 = CanInitMsg15MskStd0[initObject];       /*stdid0*/
    CAN_BASE_ADR(channel)->lmskbs1 = CanInitMsg15MskStd1[initObject];       /*stdid1*/
    CAN_BASE_ADR(channel)->lmskbe0 = CanInitMsg15MskExt0[initObject];       /*extid0*/
    CAN_BASE_ADR(channel)->lmskbe1 = CanInitMsg15MskExt1[initObject];       /*extid1*/
    CAN_BASE_ADR(channel)->lmskbe2 = CanInitMsg15MskExt2[initObject];       /*extid2*/

    /* configure code for BasicCAN object 14/30 */
    CAN_BASE_ADR(channel)->msl[kCanBCA].stdId0 = CanInitMsg14CodStd0[initObject];/*stdid0*/
    CAN_BASE_ADR(channel)->msl[kCanBCA].stdId1 = CanInitMsg14CodStd1[initObject];/*stdid1*/
    CAN_BASE_ADR(channel)->msl[kCanBCA].extId0 = CanInitMsg14CodExt0[initObject];/*extid0*/
    CAN_BASE_ADR(channel)->msl[kCanBCA].extId1 = CanInitMsg14CodExt1[initObject];/*extid1*/
    CAN_BASE_ADR(channel)->msl[kCanBCA].extId2 = CanInitMsg14CodExt2[initObject];/*extid2*/

    /* configure code for BasicCAN object 15/31 */
    CAN_BASE_ADR(channel)->msl[kCanBCB].stdId0 = CanInitMsg15CodStd0[initObject];/*stdid0*/
    CAN_BASE_ADR(channel)->msl[kCanBCB].stdId1 = CanInitMsg15CodStd1[initObject];/*stdid1*/
    CAN_BASE_ADR(channel)->msl[kCanBCB].extId0 = CanInitMsg15CodExt0[initObject];/*extid0*/
    CAN_BASE_ADR(channel)->msl[kCanBCB].extId1 = CanInitMsg15CodExt1[initObject];/*extid1*/
    CAN_BASE_ADR(channel)->msl[kCanBCB].extId2 = CanInitMsg15CodExt2[initObject];/*extid2*/
    # else
    /* when mixed mode is disabled, the M32R CAN controller is configured to run
     * in BasicCAN mode and here only one mask is used as recommended by Mitsu-
     * bishi's documentation. So only use CanInitMsg15xxx.
     */
    #  if defined ( C_ENABLE_EXTENDED_ID )
    /* configure mask for BasicCAN object 14/30 */
    CAN_BASE_ADR(channel)->lmskae0 = CanInitMsg15MskExt0[initObject];       /*extid0*/
    CAN_BASE_ADR(channel)->lmskae1 = CanInitMsg15MskExt1[initObject];       /*extid1*/
    CAN_BASE_ADR(channel)->lmskae2 = CanInitMsg15MskExt2[initObject];       /*extid2*/
    /* configure mask for BasicCAN object 15/31 */
    CAN_BASE_ADR(channel)->lmskbe0 = CanInitMsg15MskExt0[initObject];       /*extid0*/
    CAN_BASE_ADR(channel)->lmskbe1 = CanInitMsg15MskExt1[initObject];       /*extid1*/
    CAN_BASE_ADR(channel)->lmskbe2 = CanInitMsg15MskExt2[initObject];       /*extid2*/

    /* configure code for BasicCAN object 14/30 */
    CAN_BASE_ADR(channel)->msl[kCanBCA].extId0 = CanInitMsg15CodExt0[initObject];/*extid0*/
    CAN_BASE_ADR(channel)->msl[kCanBCA].extId1 = CanInitMsg15CodExt1[initObject];/*extid1*/
    CAN_BASE_ADR(channel)->msl[kCanBCA].extId2 = CanInitMsg15CodExt2[initObject];/*extid2*/
    /* configure code for BasicCAN object 15/31 */
    CAN_BASE_ADR(channel)->msl[kCanBCB].extId0 = CanInitMsg15CodExt0[initObject];/*extid0*/
    CAN_BASE_ADR(channel)->msl[kCanBCB].extId1 = CanInitMsg15CodExt1[initObject];/*extid1*/
    CAN_BASE_ADR(channel)->msl[kCanBCB].extId2 = CanInitMsg15CodExt2[initObject];/*extid2*/
    #  endif /* C_ENABLE_EXTENDED_ID */
    /* configure mask for BasicCAN object 14/30 */
    CAN_BASE_ADR(channel)->lmskas0 = CanInitMsg15MskStd0[initObject];       /*stdid0*/
    CAN_BASE_ADR(channel)->lmskas1 = CanInitMsg15MskStd1[initObject];       /*stdid1*/
    /* configure mask for BasicCAN object 15/31 */
    CAN_BASE_ADR(channel)->lmskbs0 = CanInitMsg15MskStd0[initObject];       /*stdid0*/
    CAN_BASE_ADR(channel)->lmskbs1 = CanInitMsg15MskStd1[initObject];       /*stdid1*/

    /* configure code for BasicCAN object 14/30 */
    CAN_BASE_ADR(channel)->msl[kCanBCA].stdId0 = CanInitMsg15CodStd0[initObject];/*stdid0*/
    CAN_BASE_ADR(channel)->msl[kCanBCA].stdId1 = CanInitMsg15CodStd1[initObject];/*stdid1*/
    /* configure code for BasicCAN object 15/31 */
    CAN_BASE_ADR(channel)->msl[kCanBCB].stdId0 = CanInitMsg15CodStd0[initObject];/*stdid0*/
    CAN_BASE_ADR(channel)->msl[kCanBCB].stdId1 = CanInitMsg15CodStd1[initObject];/*stdid1*/
    # endif /* C_ENABLE_MIXED_ID */

    /* configure BasicCAN objects to receive standard or extended identifiers */
    /* depending on the configuration in CANgen. */

    # if defined ( C_ENABLE_EXTENDED_ID )
    #  if defined ( C_ENABLE_MIXED_ID )
    if (CanInitBasic0[initObject] == kCanIdTypeExt)
    {
      CAN_BASE_ADR(channel)->extid |= kIDEBCA;           /* configure BasicCAN for extended  */
    }
    else
    {
      CAN_BASE_ADR(channel)->extid &= ~kIDEBCA;          /* configure BasicCAN for standard  */
    }

    if (CanInitBasic1[initObject] == kCanIdTypeExt)
    {
      CAN_BASE_ADR(channel)->extid |= kIDEBCB;           /* configure BasicCAN for extended  */
    }
    else
    {
      CAN_BASE_ADR(channel)->extid &= ~kIDEBCB;          /* configure BasicCAN for standard  */
    }
    #  endif
    # endif
    #endif /* C_ENABLE_RX_BASICCAN_OBJECTS */

    /* Init Tx-Objects -------------------------------------------------------- */
    /* init saved Tx handles: */
    /* in case of CommonCAN, transmission is always on the frist HW channel of a CommonCAN channel */

    for (hwObjHandle=CAN_HL_HW_TX_STARTINDEX(canHwChannel); hwObjHandle<CAN_HL_HW_TX_STOPINDEX(canHwChannel); hwObjHandle++ )
    {
      logTxObjHandle = (CanObjectHandle)((vsintx)hwObjHandle + CAN_HL_TX_OFFSET_HW_TO_LOG(canHwChannel));

#if defined( C_ENABLE_CAN_CANCEL_NOTIFICATION ) || \
    defined( C_ENABLE_CAN_MSG_TRANSMIT_CANCEL_NOTIFICATION )
      if((canStatus[channel] & kCanHwIsInit) != 0)                    /*lint !e661*/
      {
        /* inform application, if a pending transmission is canceled */
        txHandle = canHandleCurTxObj[logTxObjHandle];

# if defined( C_ENABLE_CAN_CANCEL_NOTIFICATION )
        if( txHandle < kCanNumberOfTxObjects )
        {
          APPLCANCANCELNOTIFICATION(channel, txHandle);
        }
# endif
# if defined( C_ENABLE_CAN_MSG_TRANSMIT_CANCEL_NOTIFICATION )
        if( txHandle == kCanBufferMsgTransmit)
        {
          APPLCANMSGCANCELNOTIFICATION(channel);
        }
# endif
      }
#endif

      canHandleCurTxObj[logTxObjHandle] = kCanBufferFree;                   /* MsgObj is free */

      /* configure msg slot as a transmit message slot. this is done by setting
       * the messag slot inactive first. whenever a msg transmission should be
       * started, the kTR bit should be set.
       */
      CAN_BASE_ADR(channel)->mslcnt[hwObjHandle] = 0;           /* msg slot inactive */

      /* configure the msg slot interrupt */
      #if defined ( C_ENABLE_TX_POLLING )
      /* disable interrupt */
      if(canCanInterruptCounter[channel] == 0)
      {
        CAN_BASE_ADR(channel)->slimk &= ~msgSlotBitmask[hwObjHandle];
      }
      #else
      /* enable interrupt */
      if(canCanInterruptCounter[channel] == 0)
      {
        CAN_BASE_ADR(channel)->slimk |= msgSlotBitmask[hwObjHandle];
      }
      #endif
    }

#if defined( C_ENABLE_TX_FULLCAN_OBJECTS )
    {
      for (txHandle=CAN_HL_TX_STAT_STARTINDEX(channel); txHandle<CAN_HL_TX_STAT_STOPINDEX(channel); txHandle++ )    /*lint !e661*/
      {
        hwObjHandle = CanGetTxHwObj(txHandle);
        if ( hwObjHandle  != CAN_HL_HW_TX_NORMAL_INDEX(canHwChannel) )    /* is message <txHandle> a direct message? */
        {
          #if defined ( C_ENABLE_EXTENDED_ID )
          /* write the identifier in the 5 8-bit registers */
          *((canuint32*) &(CAN_BASE_ADR(channel)->msl[hwObjHandle].stdId0)) = CanGetTxId0(txHandle);/* write 32-bits*/
          CAN_BASE_ADR(channel)->msl[hwObjHandle].extId2 = CanGetTxId1(txHandle);                /* write 8-bits */
          #else
          /* write the identifier in the 2 8-bit registers and set all the bits in the
           * unused registers to zero.
           */
          *((canuint16*) &(CAN_BASE_ADR(channel)->msl[hwObjHandle].stdId0)) = CanGetTxId0(txHandle);/* write 16-bits*/
          #endif
          /* write the Data Length Code into the msg slot */
          CAN_BASE_ADR(channel)->msl[hwObjHandle].dlc = CanGetTxDlc(txHandle);

# if defined( C_HL_ENABLE_IDTYPE_OWN_REG )
# endif
        }
      }
    }
#endif

    /* init unused msg objects ------------------------------------------------ */
    for (hwObjHandle=CAN_HL_HW_UNUSED_STARTINDEX(canHwChannel); hwObjHandle<CAN_HL_HW_UNUSED_STOPINDEX(canHwChannel); hwObjHandle++ )  /*lint !e681*/
    {
      /* configure msg slot as unused */
      CAN_BASE_ADR(channel)->mslcnt[hwObjHandle] = 0;
      /* disable msg slot interrupts */
      if(canCanInterruptCounter[channel] == 0)
      {
        CAN_BASE_ADR(channel)->slimk &= ~msgSlotBitmask[hwObjHandle];
      }
    }


    #if defined ( C_ENABLE_RX_FULLCAN_OBJECTS )
    /* init full can receive msg objects: ------------------------------------- */
    for (hwObjHandle=CAN_HL_HW_RX_FULL_STARTINDEX(canHwChannel); hwObjHandle<CAN_HL_HW_RX_FULL_STOPINDEX(canHwChannel); hwObjHandle++ )
    {
      /* brackets to avoid lint info 834 */
      rxHandle = (hwObjHandle-CAN_HL_HW_RX_FULL_STARTINDEX(canHwChannel))+CAN_HL_RX_FULL_STARTINDEX(canHwChannel);

      /* configure msg slot as a receive message slot */
      CAN_BASE_ADR(channel)->mslcnt[hwObjHandle] = kRR;

      /* configure the msg slot interrupt */
      # if defined ( C_ENABLE_RX_FULLCAN_POLLING )
      /* disable interrupt */
      if(canCanInterruptCounter[channel] == 0)
      {
        CAN_BASE_ADR(channel)->slimk &= ~msgSlotBitmask[hwObjHandle];
      }
      # else
      /* enable interrupt */
      if(canCanInterruptCounter[channel] == 0)
      {
        CAN_BASE_ADR(channel)->slimk |= msgSlotBitmask[hwObjHandle];
      }
      # endif

      # if defined ( C_ENABLE_EXTENDED_ID )
      /* write the identifier in the 5 8-bit registers */
      *((canuint32*) &(CAN_BASE_ADR(channel)->msl[hwObjHandle].stdId0)) = (CanGetRxId0(rxHandle));/* write 32-bits*/
      CAN_BASE_ADR(channel)->msl[hwObjHandle].extId2 = (CanGetRxId1(rxHandle));                /* write 8-bits */

      # else
      /* write the identifier in the 2 8-bit registers and set all the bits in the
       * unused registers to zero.
       */
      *((canuint16*) &(CAN_BASE_ADR(channel)->msl[hwObjHandle].stdId0)) = (CanGetRxId0(rxHandle));/* write 16-bits*/
      # endif /* C_ENABLE_EXTENDED_ID */
    }
    #endif

    #if defined ( C_ENABLE_RX_BASICCAN_OBJECTS )
    /* init basic can receive msg object: ------------------------------------- */
    for (hwObjHandle=CAN_HL_HW_RX_BASIC_STARTINDEX(canHwChannel); hwObjHandle<CAN_HL_HW_RX_BASIC_STOPINDEX(canHwChannel); hwObjHandle++ )
    {
      /* the LL driver has to know which ID tpyes have to be received by which object */
      CAN_BASE_ADR(channel)->mslcnt[hwObjHandle] = kRR; /* configure msg slot as receive slot */
    }
    #endif

    /* initialize the CAN controller:
     *  return bus off      - yes
     *  basicCAN mode       - yes (no when in mixed mode)
     *  timestamp cnt reset - yes
     *  timestamp prescaler - use CAN bus bit clock
     *  loopback mode       - no
     */

    #if defined( C_ENABLE_MIXED_ID )
    /* for extended id's BasicCAN mode shouldn't be used because rx message slots
     * 14 and 15 are not used as double buffers.
     */
    CAN_BASE_ADR(channel)->cnt |= (kRBO|kTSR);
    #else
    CAN_BASE_ADR(channel)->cnt |= (kRBO|kTSR|kBCM);
    #endif

    CAN_BASE_ADR(channel)->cnt &= (canuint16)~(kTSP|kLBM);

    /* request to leave reset mode and synchronize with the CAN bus */
    /* clear CAN reset and forcible reset bits */
    CAN_BASE_ADR(channel)->cnt &= (canuint16)~(kRST|kFRST);


    #if defined ( C_ENABLE_HW_LOOP_TIMER )
    /* start hw loop timer before entering while loop for hardware handshake */
    ApplCanTimerStart(kCanLoopResetUnSet);
    #endif

    /* wait until CAN controller is out of reset state */
    while ((CAN_BASE_ADR(channel)->stat & kCRS) == kCRS)
    {
      #if defined ( C_ENABLE_HW_LOOP_TIMER )
      if(!ApplCanTimerLoop(kCanLoopResetUnSet))
      {
        /* stop loop if application indicates it wants to */
        break;
      }
      #endif
    }

    #if defined ( C_ENABLE_HW_LOOP_TIMER )
    /* stop hw loop timer because loop no longer active */
    ApplCanTimerEnd(kCanLoopResetUnSet);
    #endif
  } /* end of loop over all hw channels */

  #if defined ( C_ENABLE_TX_OBSERVE )
  ApplCanInit( CAN_CHANNEL_CANPARA_FIRST CAN_HL_LOG_HW_TX_STARTINDEX(canHwChannel), CAN_HL_LOG_HW_TX_STOPINDEX(canHwChannel) );
  #endif
  #ifdef C_ENABLE_MSG_TRANSMIT_CONF_FCT
  ApplCanMsgTransmitInit( CAN_CHANNEL_CANPARA_ONLY );
  #endif


} /* END OF CanInit */



/****************************************************************************
| NAME:             CanInitPowerOn
| CALLED BY:        Application
| PRECONDITIONS:    This function must be called by the application before
|                   any other CAN driver function
|                   Interrupts must be disabled
| INPUT PARAMETERS: Handle to initstructure
| RETURN VALUES:    none
| DESCRIPTION:      Initialization of the CAN chip
****************************************************************************/
C_API_1 void C_API_2 CanInitPowerOn( void )
{

  #if defined( C_ENABLE_VARIABLE_DLC )          || \
      defined( C_ENABLE_DYN_TX_OBJECTS )        || \
      defined( C_ENABLE_INDICATION_FLAG )       || \
      defined( C_ENABLE_CONFIRMATION_FLAG )     || \
      defined( C_ENABLE_VARIABLE_RX_DATALEN )
  CanSignedTxHandle i;
  #endif
  CAN_CHANNEL_CANTYPE_LOCAL

#if defined ( MISRA_CHECK )
  canCanInterruptOldStatus[0] = canCanInterruptOldStatus[0] ;
# if defined(C_HL_ENABLE_LAST_INIT_OBJ)
  lastInitObject[0]= lastInitObject[0];
# endif
#endif

  canGlobalInterruptCounter = 0;

  #if defined( C_ENABLE_VARIABLE_DLC )
  for (i= kCanNumberOfTxObjects-1; i >= 0; i--)
  {
    assertGen(XT_TX_DLC(CanGetTxDlc(i))<9, kCanAllChannels, kErrorTxROMDLCTooLarge);
    canTxDLC_RAM[i] = CanGetTxDlc(i);
  }
  #endif

  #if defined(  C_ENABLE_DYN_TX_OBJECTS )
  /*  Reset dynamic transmission object management -------------------------- */
  for (i= kCanNumberOfTxDynObjects-1; i >= 0; i--)
  {
    /*  Reset management information  */
    canTxDynObjReservedFlag[i] = 0;
  }
  #endif /* C_ENABLE_DYN_TX_OBJECTS */

  #if defined( C_ENABLE_VARIABLE_RX_DATALEN )
  /* ##RI1.4 - 3.31: Dynamic Receive DLC */
  /*  Initialize the dynamic dlc for reception -------------------------- */
  for (i= kCanNumberOfRxObjects-1; i >= 0; i--)
  {
    canVariableRxDataLen[i] = CanGetRxDataLen(i);
  }
  #endif

  #if defined( C_ENABLE_INDICATION_FLAG )
  for (i = 0; i < kCanNumberOfIndBytes; i++) {
    CanIndicationFlags._c[i] = 0;
  }
  #endif

  #if defined( C_ENABLE_CONFIRMATION_FLAG )
  for (i = 0; i < kCanNumberOfConfBytes; i++) {
    CanConfirmationFlags._c[i] = 0;
  }
  #endif

  #if defined( C_ENABLE_RX_QUEUE )
  CanDeleteRxQueue();
  #endif


  #if defined ( C_MULTIPLE_RECEIVE_CHANNEL )
  for (channel=0; channel<kCanNumberOfChannels; channel++)
  #endif
  {

    canStatus[channel]              = kCanTxOff;

#if defined ( C_ENABLE_CAN_TX_CONF_FCT )
    txInfoStructConf[channel].Channel = channel;
#endif
    canRxInfoStruct[channel].Channel  = channel;
    canCanInterruptCounter[channel] = 0;

  #if defined( C_ENABLE_TX_POLLING )          || \
      defined( C_ENABLE_RX_FULLCAN_POLLING )  || \
      defined( C_ENABLE_RX_BASICCAN_POLLING ) || \
      defined( C_ENABLE_ERROR_POLLING )       || \
      defined( C_ENABLE_CANCEL_IN_HW )
# if defined(C_DISABLE_TASK_RECURSION_CHECK) &&\
     defined(C_DISABLE_USER_CHECK)
# else
    canPollingTaskActive[channel] = 0;
# endif
  #endif

#if defined(  C_ENABLE_DYN_TX_OBJECTS )
  /*  Reset dynamic transmission object management -------------------------- */
    #if defined( C_ENABLE_CONFIRMATION_FCT ) && \
        defined( C_ENABLE_TRANSMIT_QUEUE )
    confirmHandle[channel] = kCanBufferFree;
    #endif
#endif

#if defined(C_ENABLE_TX_MASK_EXT_ID)
    canTxMask0[channel] = 0;
    #if (kCanNumberOfUsedCanTxIdTables > 1)
    canTxMask1[channel] = 0;
    #endif
    #if (kCanNumberOfUsedCanTxIdTables > 2)
    canTxMask2[channel] = 0;
    #endif
    #if (kCanNumberOfUsedCanTxIdTables > 3)
    canTxMask3[channel] = 0;
    #endif
    #if (kCanNumberOfUsedCanTxIdTables > 4)
    canTxMask4[channel] = 0;
    #endif
#endif

#ifdef C_ENABLE_ECU_SWITCH_PASS
    canPassive[channel]             = 0;
#endif

#if defined(C_ENABLE_PART_OFFLINE)
    canTxPartOffline[channel]       = kCanTxPartInit;
#endif

#if defined ( C_ENABLE_MULTI_ECU_CONFIG )
    if ( (CanChannelIdentityAssignment[channel] & V_ACTIVE_IDENTITY_MSK) != (tVIdentityMsk)0 )
#endif
    {
#if defined ( C_ENABLE_TRANSMIT_QUEUE )
  /* clear all Tx queue flags */
      CanDelQueuedObj( CAN_CHANNEL_CANPARA_ONLY );
#endif
#if defined(C_ENABLE_CAN_RAM_CHECK)
      canComStatus[channel] = kCanEnableCommunication;
      if(kCanRamCheckFailed == CanCheckMemory(CAN_CHANNEL_CANPARA_ONLY))
      {
        canComStatus[channel] = ApplCanMemCheckFailed(CAN_CHANNEL_CANPARA_ONLY); /* let the application decide if communication is disabled */
      }
#endif

      CanInit( CAN_CHANNEL_CANPARA_FIRST 0 );

      /* canStatus is only set to init and online, if CanInit() is called for this channel. */
      canStatus[channel]              |= (kCanHwIsInit | kCanTxOn);
    }

#if defined( C_ENABLE_COND_RECEIVE_FCT )
    canMsgCondRecState[channel]     = kCanTrue;
#endif
  }

} /* END OF CanInitPowerOn */


#if defined( C_ENABLE_TRANSMIT_QUEUE )
/************************************************************************
* NAME:               CanDelQueuedObj
* CALLED BY:
* PRECONDITIONS:
* PARAMETER:          notify: if set to 1 for every deleted obj the appl is notified
* RETURN VALUE:       -
* DESCRIPTION:        Resets the bits with are set to 0 in mask
*                     Clearing the Transmit-queue
*************************************************************************/
static void CanDelQueuedObj( CAN_CHANNEL_CANTYPE_ONLY )
{
  CanTransmitHandle i;

#if defined ( C_ENABLE_MULTI_ECU_CONFIG )
  assertUser(( (CanChannelIdentityAssignment[channel] & V_ACTIVE_IDENTITY_MSK) != (tVIdentityMsk)0 ), channel, kErrorDisabledChannel);
#endif

  /* Attention: QueueCounter must be cleard befor clearing the flags,
                to supress an assertion in CanFullcanTxInterrupt()  */
   canTxQueueCnt[channel] = 0;

   for (i = CAN_HL_TX_STARTINDEX(channel); i < CAN_HL_TX_STOPINDEX(channel); i++)
   {
# if defined(C_ENABLE_CAN_CANCEL_NOTIFICATION)
     if((canStatus[channel] & kCanHwIsInit) != 0)
     {
       if(canTxQueueFlags[i] != 0)
       {
         APPLCANCANCELNOTIFICATION(channel, i);
       }
     }
# endif
     canTxQueueFlags[i] = 0;
   }
}
#endif

#if defined( C_ENABLE_CAN_TRANSMIT )
/****************************************************************************
| NAME:             CanCancelTransmit
| CALLED BY:        Application
| PRECONDITIONS:    none
| INPUT PARAMETERS: Tx-Msg-Handle
| RETURN VALUES:    none
| DESCRIPTION:      delete on Msg-Object
****************************************************************************/
C_API_1 void C_API_2 CanCancelTransmit( CanTransmitHandle txHandle )
{
  CanDeclareGlobalInterruptOldStatus
  CAN_CHANNEL_CANTYPE_LOCAL
  CanObjectHandle        logTxObjHandle;
  /* ##RI1.4 - 1.6: CanCancelTransmit and CanCancelMsgTransmit */
#if defined(C_ENABLE_CANCEL_IN_HW)
  CanObjectHandle        txObjHandle;
#endif

  if (txHandle < kCanNumberOfTxObjects)         /* legal txHandle ? */
  {
  #if defined ( C_MULTIPLE_RECEIVE_CHANNEL)
    channel = CanGetChannelOfTxObj(txHandle);
  #endif

#if defined ( C_ENABLE_MULTI_ECU_PHYS )
  assertUser(((CanTxIdentityAssignment[txHandle] & V_ACTIVE_IDENTITY_MSK) != (tVIdentityMsk)0 ), channel , kErrorDisabledTxMessage);
#endif

    CanNestedGlobalInterruptDisable();
#ifdef C_ENABLE_TRANSMIT_QUEUE
    if ( canTxQueueFlags[txHandle] != 0 )        /*lint !e661*/
    {
      canTxQueueCnt[channel]--;
      canTxQueueFlags[txHandle] = 0;             /*lint !e661*/
      APPLCANCANCELNOTIFICATION(channel, txHandle);
    }
#endif

#if defined( C_ENABLE_TX_FULLCAN_OBJECTS )
    logTxObjHandle = (CanObjectHandle)((vsintx)CanGetTxHwObj(txHandle) + CAN_HL_TX_OFFSET_HW_TO_LOG(canHwChannel));
#else
    logTxObjHandle = (CanObjectHandle)((vsintx)CAN_HL_HW_TX_NORMAL_INDEX(canHwChannel) + CAN_HL_TX_OFFSET_HW_TO_LOG(canHwChannel));
#endif/* C_ENABLE_TX_FULLCAN_OBJECTS */
    if (canHandleCurTxObj[logTxObjHandle] == txHandle)
    {
      canHandleCurTxObj[logTxObjHandle] = kCanBufferCancel;

      /* ##RI1.4 - 1.6: CanCancelTransmit and CanCancelMsgTransmit */
#if defined(C_ENABLE_CANCEL_IN_HW)
# if defined( C_ENABLE_TX_FULLCAN_OBJECTS )
      txObjHandle = CanGetTxHwObj(txHandle);
# else
      txObjHandle = CAN_HL_HW_TX_NORMAL_INDEX(canHwChannel);
# endif /* C_ENABLE_TX_FULLCAN_OBJECTS */
      if((CAN_BASE_ADR(channel)->mslcnt[txObjHandle] & 0x81) == 0x80)
      {
        /* abort only if msg slot is in transmit mode and sending is not completed */
        CAN_BASE_ADR(channel)->mslcnt[txObjHandle] = kTA;
      }
#endif /* C_ENABLE_CANCEL_IN_HW */
      APPLCANCANCELNOTIFICATION(channel, txHandle);
    }

    CanNestedGlobalInterruptRestore();
  } /* if (txHandle < kCanNumberOfTxObjects) */
}

# if defined ( C_HL_ENABLE_TX_MSG_DESTROYED )
/****************************************************************************
| NAME:             CanTxMsgDestroyed
| CALLED BY:        Application
| PRECONDITIONS:    none
| INPUT PARAMETERS: Hardware Object number and channel
| RETURN VALUES:    kCanOk, if the status has been changed
|                   kCanFailed, if the status was already free.
| DESCRIPTION:      set status of HW Msg-Object to destroyed, notify application
|                   and supress confirmation for this object
****************************************************************************/
#  if defined ( MISRA_CHECK )
   /* suppress misra message about multiple return */
#   pragma PRQA_MESSAGES_OFF 2006
#  endif

static CANUINTX CanTxMsgDestroyed ( CAN_CHANNEL_CANTYPE_FIRST CanObjectHandle txObjHandle )
{
#  if defined(C_ENABLE_CAN_CANCEL_NOTIFICATION)
  CanTransmitHandle txHandle;
#  endif


  if ((canHandleCurTxObj[txObjHandle + CAN_HL_TX_OFFSET_HW_TO_LOG(canHwChannel)]) != kCanBufferFree)
  {
#  if defined(C_ENABLE_CAN_CANCEL_NOTIFICATION)
    txHandle = canHandleCurTxObj[txObjHandle + CAN_HL_TX_OFFSET_HW_TO_LOG(canHwChannel)];
#  endif
    canHandleCurTxObj[txObjHandle + CAN_HL_TX_OFFSET_HW_TO_LOG(canHwChannel)] = kCanBufferMsgDestroyed;

#  if defined(C_ENABLE_CAN_CANCEL_NOTIFICATION)                || \
      defined( C_ENABLE_CAN_MSG_TRANSMIT_CANCEL_NOTIFICATION )
#   if defined( C_ENABLE_MSG_TRANSMIT )
    if (txObjHandle == CAN_HL_HW_MSG_TRANSMIT_INDEX(canHwChannel))
    {
      APPLCANMSGCANCELNOTIFICATION(channel);
    }
    else
#   endif
    {
      APPLCANCANCELNOTIFICATION(channel, txHandle);
    }
#  endif

    return  kCanOk;
  }
  return kCanFailed;
}

#  if defined ( MISRA_CHECK )
#   pragma PRQA_MESSAGES_ON 2006
#  endif
# endif
#endif /* if defined( C_ENABLE_CAN_TRANSMIT ) */


#ifdef C_ENABLE_MSG_TRANSMIT_CONF_FCT
/****************************************************************************
| NAME:             CanCancelMsgTransmit
| CALLED BY:        Application
| PRECONDITIONS:    none
| INPUT PARAMETERS: none or channel
| RETURN VALUES:    none
| DESCRIPTION:      delete on Msg-Object
****************************************************************************/
C_API_1 void C_API_2 CanCancelMsgTransmit( CAN_CHANNEL_CANTYPE_ONLY )
{
  CanDeclareGlobalInterruptOldStatus
  CanObjectHandle  logTxObjHandle;
#if defined(C_ENABLE_CANCEL_IN_HW)
  CanObjectHandle  txObjHandle;    /* ##RI1.4 - 1.6: CanCancelTransmit and CanCancelMsgTransmit */
#endif

#if defined ( C_ENABLE_MULTI_ECU_CONFIG )
  assertUser(( (CanChannelIdentityAssignment[channel] & V_ACTIVE_IDENTITY_MSK) != (tVIdentityMsk)0 ), channel, kErrorDisabledChannel);
#endif

  logTxObjHandle = (CanObjectHandle)((vsintx)CAN_HL_HW_MSG_TRANSMIT_INDEX(canHwChannel) + CAN_HL_TX_OFFSET_HW_TO_LOG(canHwChannel));

  CanNestedGlobalInterruptDisable();
  if (canHandleCurTxObj[logTxObjHandle] == kCanBufferMsgTransmit)
  {
    canHandleCurTxObj[logTxObjHandle] = kCanBufferCancel;

    /* ##RI1.4 - 1.6: CanCancelTransmit and CanCancelMsgTransmit */
#if defined(C_ENABLE_CANCEL_IN_HW)
    txObjHandle = CAN_HL_HW_MSG_TRANSMIT_INDEX(canHwChannel);
    if((CAN_BASE_ADR(channel)->mslcnt[txObjHandle] & 0x81) == 0x80)
    {
      /* abort only if msg slot is in transmit mode and sending is not completed */
      CAN_BASE_ADR(channel)->mslcnt[txObjHandle] = kTA;
    }
#endif
    APPLCANMSGCANCELNOTIFICATION(channel);
  }
  CanNestedGlobalInterruptRestore();
}
#endif


#if defined( C_ENABLE_CAN_TRANSMIT )
# if defined( C_ENABLE_VARIABLE_DLC )
/****************************************************************************
| NAME:             CanTransmitVarDLC
| CALLED BY:        Netmanagement, application
| PRECONDITIONS:    Can driver must be initialized
| INPUT PARAMETERS: Handle to Tx message, DLC of Tx message
| RETURN VALUES:    kCanTxFailed: transmit failed
|                   kCanTxOk    : transmit was succesful
| DESCRIPTION:      If the CAN driver is not ready for send, the application
|                   decide, whether the transmit request is repeated or not.
****************************************************************************/
C_API_1 canuint8 C_API_2 CanTransmitVarDLC(CanTransmitHandle txHandle, canuint8 dlc)
{
  assertUser(dlc<9, kCanAllChannels, kErrorTxVarDLCTooLarge);

  canTxDLC_RAM[ txHandle ] = (canTxDLC_RAM[ txHandle ] & CanLL_DlcMask) | MK_TX_DLC(dlc);

  return CanTransmit( txHandle );
} /* END OF CanTransmitVarDLC */
# endif

/****************************************************************************
| NAME:             CanTransmit
| CALLED BY:        application
| PRECONDITIONS:    Can driver must be initialized
| INPUT PARAMETERS: Handle of the transmit object to be send
| RETURN VALUES:    kCanTxFailed: transmit failed
|                   kCanTxOk    : transmit was succesful
| DESCRIPTION:      If the CAN driver is not ready for send, the application
|                   decide, whether the transmit request is repeated or not.
****************************************************************************/
# if defined ( MISRA_CHECK )
  /* suppress misra message about multiple return */
#  pragma PRQA_MESSAGES_OFF 2006
# endif

C_API_1 canuint8 C_API_2 CanTransmit(CanTransmitHandle txHandle)  C_API_3   /*lint !e14 !e31*/
{
  CanDeclareGlobalInterruptOldStatus

# if !defined( C_ENABLE_TX_POLLING )          ||\
     !defined( C_ENABLE_TRANSMIT_QUEUE )      ||\
     defined( C_ENABLE_TX_FULLCAN_OBJECTS )   ||\
     defined( C_ENABLE_INDIVIDUAL_POLLING )
  CanObjectHandle      txObjHandle;
  CanObjectHandle      logTxObjHandle;
  canuint8             rc;
# endif   /* ! C_ENABLE_TX_POLLING  || ! C_ENABLE_TRANSMIT_QUEUE || C_ENABLE_TX_FULLCAN_OBJECTS || C_ENABLE_INDIVIDUAL_POLLING */

  CAN_CHANNEL_CANTYPE_LOCAL




  assertUser(txHandle<kCanNumberOfTxObjects, kCanAllChannels , kErrorTxHdlTooLarge);

# if defined ( C_MULTIPLE_RECEIVE_CHANNEL)
  channel = CanGetChannelOfTxObj(txHandle);          /*lint !e661*/
# endif

#if defined ( C_ENABLE_MULTI_ECU_PHYS )
  assertUser(((CanTxIdentityAssignment[txHandle] & V_ACTIVE_IDENTITY_MSK) != (tVIdentityMsk)0 ), channel , kErrorDisabledTxMessage);
#endif

  /* test offline ---------------------------------------------------------- */
  if ( (canStatus[channel] & kCanTxOn) == kCanTxOff )           /* transmit path switched off */
  {
    return kCanTxFailed;
  }

#ifdef C_ENABLE_PART_OFFLINE
  if ( (canTxPartOffline[channel] & CanTxSendMask[txHandle]) != 0)   /*lint !e661*/ /* CAN off ? */
  {
    return (kCanTxPartOffline);
  }
#endif

#if defined(C_ENABLE_CAN_RAM_CHECK)
  if(canComStatus[channel] == kCanDisableCommunication)
  {
    return(kCanCommunicationDisabled);
  }
#endif

  assertInternal((canStatus[channel] & kCanHwIsStop) != kCanHwIsStop, channel, kErrorCanStop);

  /* passive mode ---------------------------------------------------------- */
  #if defined( C_ENABLE_ECU_SWITCH_PASS )
  if ( canPassive[channel] != 0)                             /*  set passive ? */
  {
#if defined ( C_ENABLE_CAN_TX_CONF_FCT ) || \
    defined( C_ENABLE_CONFIRMATION_FCT )
    CanCanInterruptDisable(CAN_CHANNEL_CANPARA_ONLY);      /* avoid CAN Rx interruption */
#endif

#if defined ( C_ENABLE_CAN_TX_CONF_FCT )
/* ##RI-1.10 Common Callbackfunction in TxInterrupt */
    txInfoStructConf[channel].Channel = channel;
    txInfoStructConf[channel].Handle  = txHandle;
    ApplCanTxConfirmation(&txInfoStructConf[channel]);
#endif

    #if defined ( C_ENABLE_CONFIRMATION_FLAG )       /* set transmit ready flag  */
      #if C_SECURITY_LEVEL > 20
    CanSingleGlobalInterruptDisable();
      #endif
    CanConfirmationFlags._c[CanGetConfirmationOffset(txHandle)] |= CanGetConfirmationMask(txHandle);      /*lint !e661*/
      #if C_SECURITY_LEVEL > 20
    CanSingleGlobalInterruptRestore();
      #endif
    #endif

    #if defined( C_ENABLE_CONFIRMATION_FCT )
    {
      #if defined ( C_HL_ENABLE_DUMMY_FCT_CALL )
      #else
      if ( CanGetApplConfirmationPtr(txHandle) != NULL )
      #endif
      {
         (CanGetApplConfirmationPtr(txHandle))(txHandle);   /* call completion routine  */
      }
    }
    #endif /* C_ENABLE_CONFIRMATION_FCT */

#if defined ( C_ENABLE_CAN_TX_CONF_FCT ) || \
    defined( C_ENABLE_CONFIRMATION_FCT )
    CanCanInterruptRestore(CAN_CHANNEL_CANPARA_ONLY);
#endif

    return kCanTxOk;
  }
  #endif

  #if defined ( C_HL_ENABLE_HW_EXIT_TRANSMIT )
    return kCanTxFailed;
  }
  #endif

   /* can transmit enabled ================================================== */

   /* ----------------------------------------------------------------------- */
   /* ---  transmit queue with one objects ---------------------------------- */
   /* ---  transmit using fullcan objects ----------------------------------- */
   /* ----------------------------------------------------------------------- */

# if !defined( C_ENABLE_TX_POLLING )          ||\
     !defined( C_ENABLE_TRANSMIT_QUEUE )      ||\
     defined( C_ENABLE_TX_FULLCAN_OBJECTS )   ||\
     defined( C_ENABLE_INDIVIDUAL_POLLING )

#  if defined( C_ENABLE_TX_FULLCAN_OBJECTS )
  txObjHandle = CanGetTxHwObj(txHandle);    /*lint !e661*/
#  else
  txObjHandle = CAN_HL_HW_TX_NORMAL_INDEX(canHwChannel);                                          /* msg in object 0 */
#  endif
  logTxObjHandle = (CanObjectHandle)((vsintx)txObjHandle + CAN_HL_TX_OFFSET_HW_TO_LOG(canHwChannel));

# endif   /* ! C_ENABLE_TX_POLLING  || ! C_ENABLE_TRANSMIT_QUEUE || C_ENABLE_TX_FULLCAN_OBJECTS || C_ENABLE_INDIVIDUAL_POLLING */


  CanNestedGlobalInterruptDisable();

  /* test offline after interrupt disable ---------------------------------- */
  if ( (canStatus[channel] & kCanTxOn) == kCanTxOff )                /* transmit path switched off */
  {
    CanNestedGlobalInterruptRestore();
    return kCanTxFailed;
  }

  #if defined( C_ENABLE_TRANSMIT_QUEUE )
    #if defined( C_ENABLE_TX_FULLCAN_OBJECTS )  ||\
        !defined( C_ENABLE_TX_POLLING )         ||\
        defined( C_ENABLE_INDIVIDUAL_POLLING )
  if (

    #if defined( C_ENABLE_TX_FULLCAN_OBJECTS )
    (txObjHandle == CAN_HL_HW_TX_NORMAL_INDEX(canHwChannel))                                   /*disabled - lint !e774 */
    #endif

    #if defined( C_ENABLE_TX_FULLCAN_OBJECTS )  &&\
        ( !defined( C_ENABLE_TX_POLLING )         ||\
          defined( C_ENABLE_INDIVIDUAL_POLLING ) )
     &&
    #endif

    #if defined( C_ENABLE_TX_POLLING )
     #if defined( C_ENABLE_INDIVIDUAL_POLLING )
     (
     ) || (canHandleCurTxObj[logTxObjHandle] != kCanBufferFree)     /* MsgObj used?  */
     #endif
    #else
     ( canHandleCurTxObj[logTxObjHandle] != kCanBufferFree)    /* MsgObj used?  */
    #endif
    )
   #endif

  {
    /* tx object 0 used -> set msg in queue: -----------------------------*/

    if (canTxQueueFlags[txHandle] == 0 ) /*lint !e661*/ /* msg already in queue? */
    {
      canTxQueueFlags[txHandle] = 1;     /*lint !e661*/ /* set message in queue */
      canTxQueueCnt[channel]++;
    }
    CanNestedGlobalInterruptRestore();
    return kCanTxOk;
  }
  #endif

# if !defined( C_ENABLE_TX_POLLING )          ||\
     !defined( C_ENABLE_TRANSMIT_QUEUE )      ||\
     defined( C_ENABLE_TX_FULLCAN_OBJECTS )   ||\
     defined( C_ENABLE_INDIVIDUAL_POLLING )

    #if defined( C_ENABLE_TRANSMIT_QUEUE )    && \
        ( defined( C_ENABLE_TX_FULLCAN_OBJECTS )  ||\
          !defined( C_ENABLE_TX_POLLING )         ||\
          defined( C_ENABLE_INDIVIDUAL_POLLING )  )
  else
    #endif
  {
  /* check for transmit message object free ---------------------------------*/
    if (( canHandleCurTxObj[logTxObjHandle] != kCanBufferFree)    /* MsgObj used?  */
       || ( !CanLL_TxIsHWObjFree( canHwChannel, txObjHandle ) )

      /* hareware-txObject is not free --------------------------------------*/
       )  /* end of if question */

    {  /* object used */
      /* tx object n used, quit with error */
      CanNestedGlobalInterruptRestore();
      return kCanTxFailed;
    }
  }

  /* Obj, pMsgObject points to is free, transmit msg object: ----------------*/
  canHandleCurTxObj[logTxObjHandle] = txHandle;/* Save hdl of msgObj to be transmitted*/
  CanNestedGlobalInterruptRestore();

  rc = CanCopyDataAndStartTransmission( CAN_CHANNEL_CANPARA_FIRST txObjHandle, txHandle);

#  if defined(C_ENABLE_CAN_CANCEL_NOTIFICATION)
  if ( rc == kCanTxNotify)
  {
    rc = kCanTxFailed;      /* ignore notification if calls of CanCopy.. is performed within CanTransmit */
  }
#  endif


  return(rc);

# else   /* ! C_ENABLE_TX_POLLING  || ! C_ENABLE_TRANSMIT_QUEUE || C_ENABLE_TX_FULLCAN_OBJECTS || C_ENABLE_INDIVIDUAL_POLLING */
# endif   /* ! C_ENABLE_TX_POLLING  || ! C_ENABLE_TRANSMIT_QUEUE || C_ENABLE_TX_FULLCAN_OBJECTS || C_ENABLE_INDIVIDUAL_POLLING */

} /* END OF CanTransmit */
# if defined ( MISRA_CHECK )
#  pragma PRQA_MESSAGES_ON 2006
# endif



/****************************************************************************
| NAME:             CanCopyDataAndStartTransmission
| CALLED BY:        CanTransmit and CanTransmitQueuedObj
| PRECONDITIONS:    - Can driver must be initialized
|                   - canTxCurHandle[logTxObjHandle] must be set
|                   - the hardwareObject (txObjHandle) must be free
| INPUT PARAMETERS: txHandle: Handle of the transmit object to be send
|                   txObjHandle:  Nr of the HardwareObjects to use
| RETURN VALUES:    kCanTxFailed: transmit failed
|                   kCanTxOk    : transmit was succesful
| DESCRIPTION:      If the CAN driver is not ready for send, the application
|                   decide, whether the transmit request is repeated or not.
****************************************************************************/
# if defined ( MISRA_CHECK )
  /* suppress misra message about goto */
#  pragma PRQA_MESSAGES_OFF 2001
# endif
static canuint8 CanCopyDataAndStartTransmission( CAN_CHANNEL_CANTYPE_FIRST CanObjectHandle txObjHandle, CanTransmitHandle txHandle) C_API_3   /*lint !e14 !e31*/
{
   CanDeclareGlobalInterruptOldStatus
   canuint8             rc;
   CanObjectHandle      logTxObjHandle;
    #if defined( C_ENABLE_COPY_TX_DATA )
   TxDataPtr   CanMemCopySrcPtr;
    #endif
   #if defined(  C_ENABLE_DYN_TX_OBJECTS )
   CanTransmitHandle    dynTxObj;
   #endif /* C_ENABLE_DYN_TX_OBJECTS */
   #if defined( C_ENABLE_PRETRANSMIT_FCT )
   CanTxInfoStruct      txStruct;
   #endif

   /* counter to copy the message data byte for byte to the CAN message slot */
   canuint8  txCopyCnt;

   #if defined(  C_ENABLE_DYN_TX_OBJECTS )
   if (txHandle >= CAN_HL_TX_DYN_ROM_STARTINDEX(channel))
   {
     dynTxObj = txHandle - CAN_HL_TX_DYN_ROM_STARTINDEX(channel) + CAN_HL_TX_DYN_RAM_STARTINDEX(channel);
   }
   else
   {
     dynTxObj = 0;
   }
   #endif /* C_ENABLE_DYN_TX_OBJECTS */

   logTxObjHandle = (CanObjectHandle)((vsintx)txObjHandle + CAN_HL_TX_OFFSET_HW_TO_LOG(canHwChannel));

   assertHardware( CanLL_TxIsHWObjFree( canHwChannel, txObjHandle ), channel, kErrorTxBufferBusy);


   /* set id and dlc  -------------------------------------------------------- */
#if defined( C_ENABLE_TX_FULLCAN_OBJECTS )
   if ( txObjHandle == CAN_HL_HW_TX_NORMAL_INDEX(canHwChannel) )
#endif
   {
 #if defined(  C_ENABLE_DYN_TX_DLC ) || \
      defined(  C_ENABLE_DYN_TX_ID )
     if (txHandle >= CAN_HL_TX_DYN_ROM_STARTINDEX(channel))
     {           /* set dynamic part of dynamic objects ----------------------*/
  #if defined( C_ENABLE_DYN_TX_ID )
        #if defined ( C_ENABLE_EXTENDED_ID )
        /* write the identifier in the 5 8-bit registers */
        *((canuint32*) &(CAN_BASE_ADR(channel)->msl[txObjHandle].stdId0)) = canDynTxId0[dynTxObj];/* write 32-bits*/
        CAN_BASE_ADR(channel)->msl[txObjHandle].extId2 = canDynTxId1[dynTxObj];                /* write 8-bits */
        #else
        /* write the identifier in the 2 8-bit registers and set all the bits in the
         * unused registers to zero.
         */
        *((canuint16*) &(CAN_BASE_ADR(channel)->msl[txObjHandle].stdId0)) = canDynTxId0[dynTxObj];/* write 16-bits*/
        #endif
  #endif

  #if defined( C_ENABLE_DYN_TX_DLC )
        /* write the Data Length Code into the msg slot */
        CAN_BASE_ADR(channel)->msl[txObjHandle].dlc = (canDynTxDLC[dynTxObj]);
  #endif
     }
     else
     {          /* set part of static objects assocciated the dynamic --------*/
  #if defined( C_ENABLE_DYN_TX_ID )
    #if defined( C_ENABLE_TX_MASK_EXT_ID )
     #if defined( C_ENABLE_MIXED_ID )
        if (CanGetTxIdType(txHandle)==kCanIdTypeStd)
        {
          #if defined ( C_ENABLE_EXTENDED_ID )
          /* write the identifier in the 5 8-bit registers */
          *((canuint32*) &(CAN_BASE_ADR(channel)->msl[txObjHandle].stdId0)) = CanGetTxId0(txHandle);/* write 32-bits*/
          CAN_BASE_ADR(channel)->msl[txObjHandle].extId2 = CanGetTxId1(txHandle);                /* write 8-bits */
          #else
          /* write the identifier in the 2 8-bit registers and set all the bits in the
           * unused registers to zero.
           */
          *((canuint16*) &(CAN_BASE_ADR(channel)->msl[txObjHandle].stdId0)) = CanGetTxId0(txHandle);/* write 16-bits*/
          #endif
        }
        else
     #endif
        {
          /* mask extened ID */
          #if defined ( C_ENABLE_EXTENDED_ID )
          /* write the identifier in the 5 8-bit registers */
          *((canuint32*) &(CAN_BASE_ADR(channel)->msl[txObjHandle].stdId0)) = (CanGetTxId0(txHandle)|canTxMask0[channel]);/* write 32-bits*/
          CAN_BASE_ADR(channel)->msl[txObjHandle].extId2 = (CanGetTxId1(txHandle)|canTxMask1[channel]);                /* write 8-bits */
          #else
          /* write the identifier in the 2 8-bit registers and set all the bits in the
           * unused registers to zero.
           */
          *((canuint16*) &(CAN_BASE_ADR(channel)->msl[txObjHandle].stdId0)) = (CanGetTxId0(txHandle)|canTxMask0[channel]);/* write 16-bits*/
          #endif
        }
    #else
        #if defined ( C_ENABLE_EXTENDED_ID )
        /* write the identifier in the 5 8-bit registers */
        *((canuint32*) &(CAN_BASE_ADR(channel)->msl[txObjHandle].stdId0)) = CanGetTxId0(txHandle);/* write 32-bits*/
        CAN_BASE_ADR(channel)->msl[txObjHandle].extId2 = CanGetTxId1(txHandle);                /* write 8-bits */
        #else
        /* write the identifier in the 2 8-bit registers and set all the bits in the
         * unused registers to zero.
         */
        *((canuint16*) &(CAN_BASE_ADR(channel)->msl[txObjHandle].stdId0)) = CanGetTxId0(txHandle);/* write 16-bits*/
        #endif
    #endif
  #endif

  #if defined( C_ENABLE_DYN_TX_DLC )
    #if defined( C_ENABLE_VARIABLE_DLC )
        /* init DLC, RAM */
        /* write the Data Length Code into the msg slot */
        CAN_BASE_ADR(channel)->msl[txObjHandle].dlc = (canTxDLC_RAM[txHandle]);
    #else
        /* init DLC, ROM */
        /* write the Data Length Code into the msg slot */
        CAN_BASE_ADR(channel)->msl[txObjHandle].dlc = CanGetTxDlc(txHandle);
    #endif
  #endif
     }
 #endif
     /* set static part commen for static and dynamic objects ----------------*/
 #if defined( C_ENABLE_DYN_TX_ID )
 #else
  #if defined( C_ENABLE_TX_MASK_EXT_ID )
   #if defined( C_ENABLE_MIXED_ID )
     if (CanGetTxIdType(txHandle)==kCanIdTypeStd)
     {
       #if defined ( C_ENABLE_EXTENDED_ID )
       /* write the identifier in the 5 8-bit registers */
       *((canuint32*) &(CAN_BASE_ADR(channel)->msl[txObjHandle].stdId0)) = CanGetTxId0(txHandle);/* write 32-bits*/
       CAN_BASE_ADR(channel)->msl[txObjHandle].extId2 = CanGetTxId1(txHandle);                /* write 8-bits */
       #else
       /* write the identifier in the 2 8-bit registers and set all the bits in the
        * unused registers to zero.
        */
       *((canuint16*) &(CAN_BASE_ADR(channel)->msl[txObjHandle].stdId0)) = CanGetTxId0(txHandle);/* write 16-bits*/
       #endif
     }
     else
   #endif
     {
       /* mask extened ID */
       #if defined ( C_ENABLE_EXTENDED_ID )
       /* write the identifier in the 5 8-bit registers */
       *((canuint32*) &(CAN_BASE_ADR(channel)->msl[txObjHandle].stdId0)) = (CanGetTxId0(txHandle)|canTxMask0[channel]);/* write 32-bits*/
       CAN_BASE_ADR(channel)->msl[txObjHandle].extId2 = (CanGetTxId1(txHandle)|canTxMask1[channel]);                /* write 8-bits */
       #else
       /* write the identifier in the 2 8-bit registers and set all the bits in the
        * unused registers to zero.
        */
       *((canuint16*) &(CAN_BASE_ADR(channel)->msl[txObjHandle].stdId0)) = (CanGetTxId0(txHandle)|canTxMask0[channel]);/* write 16-bits*/
       #endif
     }
  #else
     #if defined ( C_ENABLE_EXTENDED_ID )
     /* write the identifier in the 5 8-bit registers */
     *((canuint32*) &(CAN_BASE_ADR(channel)->msl[txObjHandle].stdId0)) = CanGetTxId0(txHandle);/* write 32-bits*/
     CAN_BASE_ADR(channel)->msl[txObjHandle].extId2 = CanGetTxId1(txHandle);                /* write 8-bits */
     #else
     /* write the identifier in the 2 8-bit registers and set all the bits in the
      * unused registers to zero.
      */
     *((canuint16*) &(CAN_BASE_ADR(channel)->msl[txObjHandle].stdId0)) = CanGetTxId0(txHandle);/* write 16-bits*/
     #endif
  #endif
 #endif
 #if defined( C_ENABLE_DYN_TX_DLC )
 #else
  #if defined( C_ENABLE_VARIABLE_DLC )
     /* init DLC, RAM */
     /* write the Data Length Code into the msg slot */
     CAN_BASE_ADR(channel)->msl[txObjHandle].dlc = (canTxDLC_RAM[txHandle]);
  #else
     /* init DLC, ROM */
     /* write the Data Length Code into the msg slot */
     CAN_BASE_ADR(channel)->msl[txObjHandle].dlc = CanGetTxDlc(txHandle);
  #endif
 #endif

#if defined( C_ENABLE_MIXED_ID )
 #if defined( C_HL_ENABLE_IDTYPE_IN_ID )
 #else
  #if defined(  C_ENABLE_DYN_TX_DLC ) || \
       defined(  C_ENABLE_DYN_TX_ID )
     if (txHandle >=  CAN_HL_TX_DYN_ROM_STARTINDEX(channel))
     {                      /* set dynamic part of dynamic objects */
   #if defined( C_ENABLE_DYN_TX_ID )
       if (canDynTxIdType[dynTxObj] == kCanIdTypeExt)
       {
         /* configure msg slot for extended 29-bit identifiers */
         CAN_BASE_ADR(channel)->extid |= msgSlotBitmask[txObjHandle];
       }
       else
       {
         /* configure msg slot for standard 11-bit identifiers */
         CAN_BASE_ADR(channel)->extid &= ~msgSlotBitmask[txObjHandle];
       }
   #else
       if (CanGetTxIdType(txHandle) == kCanIdTypeExt)
       {
         /* configure msg slot for extended 29-bit identifiers */
         CAN_BASE_ADR(channel)->extid |= msgSlotBitmask[txObjHandle];
       }
       else
       {
         /* configure msg slot for standard 11-bit identifiers */
         CAN_BASE_ADR(channel)->extid &= ~msgSlotBitmask[txObjHandle];
       }
   #endif
     }
   #if defined( C_HL_ENABLE_IDTYPE_OWN_REG )
     else
     {
       if (CanGetTxIdType(txHandle) == kCanIdTypeExt)
       {
         /* configure msg slot for extended 29-bit identifiers */
         CAN_BASE_ADR(channel)->extid |= msgSlotBitmask[txObjHandle];
       }
       else
       {
         /* configure msg slot for standard 11-bit identifiers */
         CAN_BASE_ADR(channel)->extid &= ~msgSlotBitmask[txObjHandle];
       }
     }
   #endif
  #else
   #if defined( C_HL_ENABLE_IDTYPE_OWN_REG )
     if (CanGetTxIdType(txHandle) == kCanIdTypeExt)
     {
       /* configure msg slot for extended 29-bit identifiers */
       CAN_BASE_ADR(channel)->extid |= msgSlotBitmask[txObjHandle];
     }
     else
     {
       /* configure msg slot for standard 11-bit identifiers */
       CAN_BASE_ADR(channel)->extid &= ~msgSlotBitmask[txObjHandle];
     }
   #endif
  #endif
 #endif
#endif

   }


 /* call pretransmit function ----------------------------------------------- */
 #if defined( C_ENABLE_PRETRANSMIT_FCT )

   /* pointer needed for other modules */
   (txStruct.pChipData) = (CanChipDataPtr) CAN_BASE_ADR(channel)->msl[txObjHandle].data;
   txStruct.Handle      = txHandle;

   {
    #if defined ( C_HL_ENABLE_DUMMY_FCT_CALL )
    #else
    /* Is there a PreTransmit function ? ------------------------------------- */
    if ( CanGetApplPreTransmitPtr(txHandle) != NULL )    /* if PreTransmit exists */
    #endif
    {
      if ( (CanGetApplPreTransmitPtr(txHandle)) (txStruct) == kCanNoCopyData)
      {


        /* Do not copy the data - already done by the PreTransmit-function */
        /* --- start transmission --- */
        goto startTransmission;
      }
    }
   }
 #endif /* C_ENABLE_PRETRANSMIT_FCT */

 /* copy data --------------------------------------------------------------- */
 #if defined( C_ENABLE_COPY_TX_DATA )
   #if defined(  C_ENABLE_DYN_TX_DATAPTR )
   if (txHandle >=  CAN_HL_TX_DYN_ROM_STARTINDEX(channel))
   {
      CanMemCopySrcPtr = canDynTxDataPtr[dynTxObj];
   }
   else
   #endif
   {
     CanMemCopySrcPtr = CanGetTxDataPtr(txHandle);
   }
 /* copy via index in MsgObj data field, copy always 8 bytes -----------*/
   if ( CanMemCopySrcPtr != NULL )   /* copy if buffer exists */
   {
     #if C_SECURITY_LEVEL > 10
     CanSingleGlobalInterruptDisable();
     #endif

     /* copy 8 bytes from RAM buffer to CAN message slot. larger than 8-bit acces-
      * ses to the message slot data field are not allowed.
      */
     for (txCopyCnt=0; txCopyCnt<8; txCopyCnt++)
     {
       CAN_BASE_ADR(channel)->msl[txObjHandle].data[txCopyCnt] = ((canuint8*)CanMemCopySrcPtr)[txCopyCnt];
     }

     #if C_SECURITY_LEVEL > 10
     CanSingleGlobalInterruptRestore();
     #endif
   }
 #endif /* ( C_ENABLE_COPY_TX_DATA ) */

   CANDRV_SET_CODE_TEST_POINT(0x10A);

#if defined( C_ENABLE_PRETRANSMIT_FCT )
/* Msg(4:2015) This label is not a case or default label for a switch statement. MISRA Rule 55 */
startTransmission:
#endif

   /* test offline and handle and start transmission ------------------------ */
   CanNestedGlobalInterruptDisable();
   /* If CanTransmit was interrupted by a re-initialization or CanOffline */
   /* no transmitrequest of this action should be started      */
   if ((canHandleCurTxObj[logTxObjHandle] == txHandle) && ((canStatus[channel] & kCanTxOn) != kCanTxOff))
   {
     CAN_BASE_ADR(channel)->mslcnt[txObjHandle] |= kTR;      /* request start of tx */

     #if defined( C_ENABLE_TX_OBSERVE )
     ApplCanTxObjStart( CAN_CHANNEL_CANPARA_FIRST logTxObjHandle );
     #endif
     rc = kCanTxOk;
   }
   else
   {
# if defined(C_ENABLE_CAN_CANCEL_NOTIFICATION)
     if (canHandleCurTxObj[logTxObjHandle] == txHandle)
     {
       /* only CanOffline was called on higher level */
       rc = kCanTxNotify;
     }
     else
#endif
     {
       rc = kCanTxFailed;
     }
     canHandleCurTxObj[logTxObjHandle] = kCanBufferFree;  /* release TxHandle (CanOffline) */
   }

   CanNestedGlobalInterruptRestore();


   return (rc);

} /* END OF CanCopyDataAndStartTransmission */
# if defined ( MISRA_CHECK )
#  pragma PRQA_MESSAGES_ON 2001
# endif
#endif /* if defined( C_ENABLE_CAN_TRANSMIT ) */


#if defined( C_ENABLE_TX_POLLING ) || \
    defined( C_ENABLE_RX_FULLCAN_POLLING )  || \
    defined( C_ENABLE_RX_BASICCAN_POLLING ) || \
    defined( C_ENABLE_ERROR_POLLING ) || \
    defined( C_ENABLE_CANCEL_IN_HW )
/****************************************************************************
| NAME:             CanTask
| CALLED BY:        application
| PRECONDITIONS:
| INPUT PARAMETERS: none
| RETURN VALUES:    none
| DESCRIPTION:      - cyclic Task,
|                   - polling error bus off
|                   - polling Tx objects
|                   - polling Rx objects
****************************************************************************/
C_API_1 void C_API_2 CanTask(void)
{
  CAN_CHANNEL_CANTYPE_LOCAL

#if defined ( C_MULTIPLE_RECEIVE_CHANNEL)
  for (channel = 0; channel < kCanNumberOfChannels; channel++)
#endif
  {
#if defined ( C_ENABLE_MULTI_ECU_CONFIG )
    if ( (CanChannelIdentityAssignment[channel] & V_ACTIVE_IDENTITY_MSK) != (tVIdentityMsk)0 )
#endif
    {
#if defined( C_ENABLE_ERROR_POLLING )
      CanErrorTask(CAN_CHANNEL_CANPARA_ONLY);
#endif


#if defined( C_ENABLE_TX_POLLING ) || \
    defined( C_ENABLE_CANCEL_IN_HW )
      CanTxTask(CAN_CHANNEL_CANPARA_ONLY);
#endif

#if defined( C_ENABLE_RX_FULLCAN_POLLING ) && \
    defined( C_ENABLE_RX_FULLCAN_OBJECTS )
      CanRxFullCANTask(CAN_CHANNEL_CANPARA_ONLY);
#endif

#if defined( C_ENABLE_RX_BASICCAN_OBJECTS ) && \
    defined( C_ENABLE_RX_BASICCAN_POLLING )
      CanRxBasicCANTask(CAN_CHANNEL_CANPARA_ONLY);
#endif
    }
  }
}
#endif

#if defined( C_ENABLE_ERROR_POLLING )
/****************************************************************************
| NAME:             CanErrorTask
| CALLED BY:        application
| PRECONDITIONS:
| INPUT PARAMETERS: none
| RETURN VALUES:    none
| DESCRIPTION:      - cyclic Task,
|                   - polling error status
****************************************************************************/
C_API_1 void C_API_2 CanErrorTask( CAN_CHANNEL_CANTYPE_ONLY )
{

#if defined ( C_ENABLE_MULTI_ECU_CONFIG )
  assertUser(( (CanChannelIdentityAssignment[channel] & V_ACTIVE_IDENTITY_MSK) != (tVIdentityMsk)0 ), channel, kErrorDisabledChannel);
#endif

# if defined(C_DISABLE_TASK_RECURSION_CHECK)
#  if defined(C_ENABLE_USER_CHECK)
  canPollingTaskActive[channel]++;
  assertUser((canPollingTaskActive[channel] == 1), channel, kErrorPollingTaskRecursion);
#  endif
# else
  if (canPollingTaskActive[channel] == 0)  /* avoid reentrance */
  {
    canPollingTaskActive[channel] = 1;
# endif

    {
      CAN_POLLING_IRQ_DISABLE(CAN_CHANNEL_CANPARA_ONLY);
      CanHL_ErrorHandling(CAN_HW_CHANNEL_CANPARA_ONLY);
      CAN_POLLING_IRQ_RESTORE(CAN_CHANNEL_CANPARA_ONLY);
    }

# if defined(C_DISABLE_TASK_RECURSION_CHECK)
#  if defined(C_ENABLE_USER_CHECK)
    canPollingTaskActive[channel]--;
#  endif
# else
    canPollingTaskActive[channel] = 0;
  }
# endif
}
#endif


#if defined( C_ENABLE_TX_POLLING ) || \
    defined( C_ENABLE_CANCEL_IN_HW )
/****************************************************************************
| NAME:             CanTxTask
| CALLED BY:        application
| PRECONDITIONS:
| INPUT PARAMETERS: none
| RETURN VALUES:    none
| DESCRIPTION:      - cyclic Task,
|                   - polling Tx objects
****************************************************************************/
C_API_1 void C_API_2 CanTxTask( CAN_CHANNEL_CANTYPE_ONLY )
{
  CanSignedTxHandle    i;
#if defined(C_ENABLE_TRANSMIT_QUEUE) && \
    defined(C_ENABLE_CAN_CANCEL_NOTIFICATION)
  canuint8             rc;
#endif


  #if defined( C_ENABLE_TRANSMIT_QUEUE )
  CanDeclareGlobalInterruptOldStatus
  #endif


#if defined ( C_ENABLE_MULTI_ECU_CONFIG )
  assertUser(( (CanChannelIdentityAssignment[channel] & V_ACTIVE_IDENTITY_MSK) != (tVIdentityMsk)0 ), channel, kErrorDisabledChannel);
#endif

# if defined(C_DISABLE_TASK_RECURSION_CHECK)
#  if defined(C_ENABLE_USER_CHECK)
  canPollingTaskActive[channel]++;
  assertUser((canPollingTaskActive[channel] == 1), channel, kErrorPollingTaskRecursion);
#  endif
# else
  if (canPollingTaskActive[channel] == 0)      /* avoid reentrance */
  {
    canPollingTaskActive[channel] = 1;
# endif


    /*--  polling Tx objects ----------------------------------------*/

# if defined( C_ENABLE_TX_POLLING )
    /* check for global confirmation Pending and may be reset global pending confirmation */
    /* assert generated number of tx can objects before using it as array index*/
    assertGen(CAN_HL_HW_UNUSED_STARTINDEX(channel)<16, channel, kErrorTooManyTxHwObjects);

    /* is one of the bits associated with a tx msg slot set in the slot
     * interrupt status register?
     */
    if (CAN_BASE_ADR(channel)->slist & txGlobalConfMask[(CAN_HL_HW_TX_STOPINDEX(channel)+1)])
    {
      for ( i = (CanSignedTxHandle)CAN_HL_HW_TX_STARTINDEX(canHwChannel); i < (CanSignedTxHandle)CAN_HL_HW_TX_STOPINDEX(canHwChannel) ; i++ )
      {
        /* check for dedicated confirmation pending */
        /* is the bit associated with tx msg slot [i] set in the slot interrupt
         * status register?
         */
        if (CAN_BASE_ADR(channel)->slist & msgSlotBitmask[i])
        {
          /* clear the interrupt flag for the pending event */
          CAN_BASE_ADR(channel)->slist = ~msgSlotBitmask[i];
          CANDRV_SET_CODE_TEST_POINT(0x110);
          CAN_POLLING_IRQ_DISABLE(CAN_CHANNEL_CANPARA_ONLY);
          /* do tx confirmation */
          CanHL_TxConfirmation(CAN_HW_CHANNEL_CANPARA_FIRST (CanObjectHandle) i );
          CAN_POLLING_IRQ_RESTORE(CAN_CHANNEL_CANPARA_ONLY);
        }
      }
    }
# endif /*( C_ENABLE_TX_POLLING ) */

    #if defined( C_ENABLE_CANCEL_IN_HW ) && \
        defined( C_HL_ENABLE_CANCEL_IN_HW_TASK )
    /* search for pending cancelation */

    for ( i = (CanSignedTxHandle)CAN_HL_HW_TX_STARTINDEX(canHwChannel); i < (CanSignedTxHandle)CAN_HL_HW_TX_STOPINDEX(canHwChannel) ; i++ )
    {
      /* check for dedicated cancel pending */
      if((CAN_BASE_ADR(channel)->mslcnt[i] == 0x00) && (canHandleCurTxObj[i+CAN_HL_TX_OFFSET_HW_TO_LOG(canHwChannel)] == kCanBufferCancel))
      {
        canHandleCurTxObj[i+ CAN_HL_TX_OFFSET_HW_TO_LOG(canHwChannel)] = kCanBufferFree;     /* release the hardware buffer */
      }
    }
    #endif

    #if defined( C_ENABLE_TRANSMIT_QUEUE )
    if (canHandleCurTxObj[CAN_HL_HW_TX_NORMAL_INDEX(canHwChannel) + CAN_HL_TX_OFFSET_HW_TO_LOG(canHwChannel)] == kCanBufferFree)
    {
      if (canTxQueueCnt[channel] != 0)
      {
        /* Transmit Queued Objects ( instead of function CanTransmitQueuedObj() */
        for (i = (CanSignedTxHandle)CAN_HL_TX_STOPINDEX(channel) - (CanSignedTxHandle)1; i >= (CanSignedTxHandle)CAN_HL_TX_STARTINDEX(channel); i--)
        {                           /*look for obj ready to transmit*/
          if ((canTxQueueFlags[i]) != 0)
          {
            CanSingleGlobalInterruptDisable();
            if ((canHandleCurTxObj[CAN_HL_HW_TX_NORMAL_INDEX(canHwChannel) + CAN_HL_TX_OFFSET_HW_TO_LOG(canHwChannel)] == kCanBufferFree)
                                                                                               && (canTxQueueCnt[channel] != 0))
            {
              canTxQueueFlags[i] = 0;        /* remove msg from queue */
              canTxQueueCnt[channel]--;
              /* Save hdl of msgObj to be transmitted*/
              canHandleCurTxObj[CAN_HL_HW_TX_NORMAL_INDEX(canHwChannel) + CAN_HL_TX_OFFSET_HW_TO_LOG(canHwChannel)] = (CanTransmitHandle)i;
              CanSingleGlobalInterruptRestore();
#  if defined(C_ENABLE_CAN_CANCEL_NOTIFICATION)
              rc = CanCopyDataAndStartTransmission(CAN_CHANNEL_CANPARA_FIRST CAN_HL_HW_TX_NORMAL_INDEX(canHwChannel), (CanTransmitHandle)i);
              if ( rc == kCanTxNotify)
              {
                APPLCANCANCELNOTIFICATION(channel, (CanTransmitHandle)i);
              }
#  else
              (void)CanCopyDataAndStartTransmission(CAN_CHANNEL_CANPARA_FIRST CAN_HL_HW_TX_NORMAL_INDEX(canHwChannel), (CanTransmitHandle)i);
#  endif
              break;
            }
            else
            {
              CanSingleGlobalInterruptRestore();
              break;
            }
          }
        }
      }
    }
    #endif /*  C_ENABLE_TRANSMIT_QUEUE */


# if defined(C_DISABLE_TASK_RECURSION_CHECK)
#  if defined(C_ENABLE_USER_CHECK)
    canPollingTaskActive[channel]--;
#  endif
# else
    canPollingTaskActive[channel] = 0;
  }
# endif


} /* END OF CanTxTask */
#endif /* C_ENABLE_TX_POLLING */

#if defined( C_ENABLE_RX_FULLCAN_OBJECTS ) && \
    defined( C_ENABLE_RX_FULLCAN_POLLING )
/****************************************************************************
| NAME:             CanRxFullCANTask
| CALLED BY:        application
| PRECONDITIONS:
| INPUT PARAMETERS: none
| RETURN VALUES:    none
| DESCRIPTION:      - cyclic Task,
|                   - polling Rx FullCAN objects
****************************************************************************/
C_API_1 void C_API_2 CanRxFullCANTask(CAN_CHANNEL_CANTYPE_ONLY)
{

  register CanObjectHandle     rxObjHandle;


#if defined ( C_ENABLE_MULTI_ECU_CONFIG )
  assertUser(( (CanChannelIdentityAssignment[channel] & V_ACTIVE_IDENTITY_MSK) != (tVIdentityMsk)0 ), channel, kErrorDisabledChannel);
#endif

# if defined(C_DISABLE_TASK_RECURSION_CHECK)
#  if defined(C_ENABLE_USER_CHECK)
  canPollingTaskActive[channel]++;
  assertUser((canPollingTaskActive[channel] == 1), channel, kErrorPollingTaskRecursion);
#  endif
# else
  if (canPollingTaskActive[channel] == 0)           /* avoid reentrance */
  {
    canPollingTaskActive[channel] = 1;
# endif

    {
      /*--  polling fullcan Rx objects ----------------------------------------*/

      /* check for global fullCan Rx indication pending and may be reset global */
      /* indication pending */
      /* is one of the bits associated with a rx full msg slot set in the slot
       * interrupt status register?
       */
      #if defined ( C_ENABLE_RX_BASICCAN_OBJECTS )
      /* assert generated number of rx can objects before using it as array index*/
      # if defined( C_PROCESSOR_32192 )
      assertGen(((CAN_HL_HW_RX_BASIC_STARTINDEX(channel)-CAN_HL_HW_RX_FULL_STARTINDEX(channel))<=30), \
                channel, kErrorTooManyRxFullHwObjects);
      # else
      assertGen(((CAN_HL_HW_RX_BASIC_STARTINDEX(channel)-CAN_HL_HW_RX_FULL_STARTINDEX(channel))<=14), \
                channel, kErrorTooManyRxFullHwObjects);
      # endif

      if (CAN_BASE_ADR(channel)->slist & rxFullGlobalIndMask[(CAN_HL_HW_RX_BASIC_STARTINDEX(channel)- \
                            CAN_HL_HW_RX_FULL_STARTINDEX(channel))])
      #else

      # if defined( C_PROCESSOR_32192 )
      /* assert generated number of rx can objects before using it as array index*/
      assertGen(((32-CAN_HL_HW_RX_FULL_STARTINDEX(channel))<=30), channel, kErrorTooManyRxFullHwObjects);
      if (CAN_BASE_ADR(channel)->slist & rxFullGlobalIndMask[(32-CAN_HL_HW_RX_FULL_STARTINDEX(channel))])
      # else
      /* assert generated number of rx can objects before using it as array index*/
      assertGen(((16-CAN_HL_HW_RX_FULL_STARTINDEX(channel))<=14), channel, kErrorTooManyRxFullHwObjects);

      if (CAN_BASE_ADR(channel)->slist & rxFullGlobalIndMask[(16-CAN_HL_HW_RX_FULL_STARTINDEX(channel))])
      # endif
      #endif
      {
        for (rxObjHandle=CAN_HL_HW_RX_FULL_STARTINDEX(canHwChannel); rxObjHandle<CAN_HL_HW_RX_FULL_STOPINDEX(canHwChannel); rxObjHandle++ )
        {
          /* check for dedicated indication pending */
          /* is the bit associated with rx msg slot [rxObjHandle] set in the slot
           * interrupt status register?
           */
          if (CAN_BASE_ADR(channel)->slist & msgSlotBitmask[rxObjHandle])
          {
            /* clear the interrupt flag for the pending event */
            CAN_BASE_ADR(channel)->slist = ~msgSlotBitmask[rxObjHandle];

            CANDRV_SET_CODE_TEST_POINT(0x109);
            CAN_POLLING_IRQ_DISABLE(CAN_CHANNEL_CANPARA_ONLY);
            CanFullCanMsgReceived( CAN_HW_CHANNEL_CANPARA_FIRST rxObjHandle);
            CAN_POLLING_IRQ_RESTORE(CAN_CHANNEL_CANPARA_ONLY);
          }
        }
      } /* if (global pending) */
    }  /* for (all associated HW channel) */
# if defined(C_DISABLE_TASK_RECURSION_CHECK)
#  if defined(C_ENABLE_USER_CHECK)
    canPollingTaskActive[channel]--;
#  endif
# else
    canPollingTaskActive[channel] = 0;
  }
# endif

} /* END OF CanRxTask */
#endif /*  C_ENABLE_RX_FULLCAN_OBJECTS && C_ENABLE_RX_FULLCAN_POLLING */

#if defined( C_ENABLE_RX_BASICCAN_POLLING ) && \
    defined ( C_ENABLE_RX_BASICCAN_OBJECTS )
/****************************************************************************
| NAME:             CanRxBasicCANTask
| CALLED BY:        application
| PRECONDITIONS:
| INPUT PARAMETERS: none
| RETURN VALUES:    none
| DESCRIPTION:      - cyclic Task,
|                   - polling Rx BasicCAN objects
****************************************************************************/
C_API_1 void C_API_2 CanRxBasicCANTask(CAN_CHANNEL_CANTYPE_ONLY)
{

  register CanObjectHandle     rxObjHandle;


#if defined ( C_ENABLE_MULTI_ECU_CONFIG )
  assertUser(( (CanChannelIdentityAssignment[channel] & V_ACTIVE_IDENTITY_MSK) != (tVIdentityMsk)0 ), channel, kErrorDisabledChannel);
#endif

# if defined(C_DISABLE_TASK_RECURSION_CHECK)
#  if defined(C_ENABLE_USER_CHECK)
  canPollingTaskActive[channel]++;
  assertUser((canPollingTaskActive[channel] == 1), channel, kErrorPollingTaskRecursion);
#  endif
# else
  if (canPollingTaskActive[channel] == 0)           /* avoid reentrance */
  {
    canPollingTaskActive[channel] = 1;
# endif


    /* is one of the bits associated with a BasicCAN msg slot set in the slot
     * interrupt status register?
     */
    if (CAN_BASE_ADR(channel)->slist & (kSSBCA | kSSBCB))
    {
      for (rxObjHandle=CAN_HL_HW_RX_BASIC_STARTINDEX(canHwChannel); rxObjHandle<CAN_HL_HW_RX_BASIC_STOPINDEX(canHwChannel); rxObjHandle++ )
      {
        /* check for dedicated indication pending */
        /* is the bit associated with rx msg slot [rxObjHandle] set in the slot
         * interrupt status register?
         */
        if (CAN_BASE_ADR(channel)->slist & msgSlotBitmask[rxObjHandle])
        {
          /* clear the interrupt flag for the pending event */
          CAN_BASE_ADR(channel)->slist = ~msgSlotBitmask[rxObjHandle];
          CANDRV_SET_CODE_TEST_POINT(0x108);

          CAN_POLLING_IRQ_DISABLE(CAN_CHANNEL_CANPARA_ONLY);
          CanBasicCanMsgReceived( CAN_HW_CHANNEL_CANPARA_FIRST rxObjHandle);
          CAN_POLLING_IRQ_RESTORE(CAN_CHANNEL_CANPARA_ONLY);
        }
      }
    }
# if defined(C_DISABLE_TASK_RECURSION_CHECK)
#  if defined(C_ENABLE_USER_CHECK)
    canPollingTaskActive[channel]--;
#  endif
# else
    canPollingTaskActive[channel] = 0;
  }
# endif

} /* END OF CanRxTask */
#endif /* C_ENABLE_RX_BASICCAN_POLLING && C_ENABLE_RX_BASICCAN_OBJECTS */

/****************************************************************************
| NAME:             CanHL_ErrorHandling
| CALLED BY:        CanISR(), CanErrorTask()
| PRECONDITIONS:
| INPUT PARAMETERS: none
| RETURN VALUES:    none
| DESCRIPTION:      - error interrupt (busoff, error warning,...)
****************************************************************************/
static void CanHL_ErrorHandling( CAN_HW_CHANNEL_CANTYPE_ONLY )
{


#if defined ( C_ENABLE_MULTI_ECU_CONFIG )
  assertUser(( (CanChannelIdentityAssignment[channel] & V_ACTIVE_IDENTITY_MSK) != (tVIdentityMsk)0 ), channel, kErrorDisabledChannel);
#endif


  /* check for status register (bus error)--*/
  if((CAN_BASE_ADR(channel)->erist & kOIS) == kOIS)    /* bus off event pending? */
  {
    /*==BUS OFF ERROR=========================*/
    APPL_CAN_BUSOFF( CAN_CHANNEL_CANPARA_ONLY );            /* call application specific function */
  }

  #if defined( C_HL_ENABLE_OVERRUN_IN_STATUS )
  /* check for status register (overrun occured)--*/
    #if defined( C_ENABLE_OVERRUN )
  /* if(overun occured == true) */
  {
    ApplCanOverrun( CAN_CHANNEL_CANPARA_ONLY );
  }
    #endif
    #if defined( C_ENABLE_FULLCAN_OVERRUN )
  if (CAN_BASE_ADR(channel)->mslcnt[rxObjHandle] & kML)       /* overrun occured?         */
  {
    /* clear overrun event flag */
    CAN_BASE_ADR(channel)->mslcnt[rxObjHandle] &= (canuint8)~kML;
     ApplCanFullCanOverrun( CAN_CHANNEL_CANPARA_ONLY );
  }
    #endif
  #endif
  CAN_BASE_ADR(channel)->erist = 0; /* clear all pending error events */

} /* END OF CanStatusInterrupt */


#if defined ( C_ENABLE_RX_BASICCAN_OBJECTS )
/****************************************************************************
| NAME:             CanBasicCanMsgReceived
| CALLED BY:        CanISR()
| PRECONDITIONS:
| INPUT PARAMETERS: internal can chip number
| RETURN VALUES:    none
| DESCRIPTION:      - basic can receive
****************************************************************************/
# if defined ( MISRA_CHECK )
  /* suppress misra message about multiple return and usage of goto */
#  pragma PRQA_MESSAGES_OFF 2006,2001,2015
# endif
static void CanBasicCanMsgReceived( CAN_HW_CHANNEL_CANTYPE_FIRST CanObjectHandle rxObjHandle)
{
# if defined( C_HL_ENABLE_RX_INFO_STRUCT_PTR )
  tCanRxInfoStruct    *pCanRxInfoStruct;
# endif

# if !defined (C_SEARCH_HASH) || \
     defined ( C_HL_ENABLE_HW_RANGES_FILTER ) || \
     defined ( C_ENABLE_RANGE_0 ) || \
     defined ( C_ENABLE_RANGE_1 ) || \
     defined ( C_ENABLE_RANGE_2 ) || \
     defined ( C_ENABLE_RANGE_3 )
  tCanRxId0 idRaw0;
#  if (kCanNumberOfUsedCanRxIdTables > 1)
  tCanRxId1 idRaw1;
#  endif
#  if (kCanNumberOfUsedCanRxIdTables > 2)
  tCanRxId2 idRaw2;
#  endif
#  if (kCanNumberOfUsedCanRxIdTables > 3)
  tCanRxId3 idRaw3;
#  endif
#  if (kCanNumberOfUsedCanRxIdTables > 4)
  tCanRxId4 idRaw4;
#  endif
# endif

  #if defined( C_SEARCH_HASH )
    #if defined( C_ENABLE_EXTENDED_ID )
  canuint32          id;
  canuint32          wintern;        /* prehashvalue         */
    #else
  canuint16          id;
  canuint16          wintern;        /* prehashvalue         */
    #endif
  canuint16          i_increment;    /* delta for next step  */
  cansint16          count;
  #endif

  /* the M32R CAN controller doesn't offer overwrite protection when reading
   * out the message slot. therefore read out the entire contents at once
   * and store into a tempbuffer for further processing. this tempbuffer is
   * also used in CanLL_RxBasicGetCANObjPtr and CanLL_RxBasicGetCANDataPtr.
   */
  static tCanTmpMsgSlot tempMsgSlot;

  /* counter used to copy data from CAN to the tempMsgSlot */
  canuint8 rxCopyCnt;

#if defined( C_ENABLE_GENERIC_PRECOPY ) || \
    defined( C_ENABLE_PRECOPY_FCT )     || \
    defined( C_ENABLE_COPY_RX_DATA )    || \
    defined( C_ENABLE_INDICATION_FLAG ) || \
    defined( C_ENABLE_INDICATION_FCT )  || \
    defined( C_ENABLE_DLC_CHECK )       || \
    defined( C_ENABLE_NOT_MATCHED_FCT )

# if defined( C_SEARCH_HASH )
  CanReceiveHandle        i = (CanReceiveHandle)kCanBufferFree;
# else
  /* Msg    (6:0274) [I] Value of integer constant expression is not representable in the signed result type. (Misra) */
  CanSignedRxHandle        i = (CanSignedRxHandle)kCanBufferFree;
# endif
#endif

  CANDRV_SET_CODE_TEST_POINT(0x100);


#if defined ( C_ENABLE_MULTI_ECU_CONFIG )
  assertUser(( (CanChannelIdentityAssignment[channel] & V_ACTIVE_IDENTITY_MSK) != (tVIdentityMsk)0 ), channel, kErrorDisabledChannel);
#endif

  /* assert the hardware to make sure the rx message slot is idle and not busy
   * with the reception of a message.
   */
  assertHardware(((CAN_BASE_ADR(channel)->mslcnt[rxObjHandle] & kTRSTAT) != kTRSTAT), channel, kErrorRxBufferBusy);

  if(CAN_BASE_ADR(channel)->mslcnt[rxObjHandle] & kRA) /* ESCAN00009085 */
  {
    /*
    Discard the Remote Frame and cancel the standard process.
    Clear transmission work and finished bit and confirm the Remote Abort, to be on the save side.
    If the Remote Frame causes an Overrun, the Overrun must be cleared, because invalid.
    */
    CAN_BASE_ADR(channel)->mslcnt[rxObjHandle] &= ~(kTRFIN | kTRSTAT | kML | kRA);
    return;
  }

  /* ID type information is stored on a seperate register and not in the msg
   * slot. therefore an additional structure member was introduced for the
   * tCanRxInfoStruct. this member is set here.
   */
  #if defined ( C_ENABLE_EXTENDED_ID )
  # if defined ( C_ENABLE_MIXED_ID )
  if (CAN_BASE_ADR(channel)->extid & msgSlotBitmask[rxObjHandle])
  {
    canRxInfoStruct[channel].idType = kCanIdTypeExt;
  }
  else
  {
    canRxInfoStruct[channel].idType = kCanIdTypeStd;
  }
  # else
   canRxInfoStruct[channel].idType = kCanIdTypeExt;
  # endif /* C_ENABLE_MIXED_ID */
  #else
  canRxInfoStruct[channel].idType = kCanIdTypeStd;
  #endif /*  C_ENABLE_EXTENDED_ID */

  /* the M32R CAN controller doesn't offer overwrite protection when reading
   * out the message slot. therefore read out the entire contents at once
   * and store into a tempbuffer for further processing.
   */
  #if defined ( C_ENABLE_HW_LOOP_TIMER )
  /* start hw loop timer before entering while loop for hardware handshake */
  ApplCanTimerStart(kCanLoopRxFinUnset);
  #endif

  do
  {
    /* clear reception finished bit */
    CAN_BASE_ADR(channel)->mslcnt[rxObjHandle] &= (canuint8)~kTRFIN;

    /* copy the entire msg object to the temporary local variable */
    tempMsgSlot.stdId0 = CAN_BASE_ADR(channel)->msl[rxObjHandle].stdId0;
    tempMsgSlot.stdId1 = CAN_BASE_ADR(channel)->msl[rxObjHandle].stdId1;
  #if defined ( C_ENABLE_EXTENDED_ID )
    tempMsgSlot.extId0 = CAN_BASE_ADR(channel)->msl[rxObjHandle].extId0;
    tempMsgSlot.extId1 = CAN_BASE_ADR(channel)->msl[rxObjHandle].extId1;
    tempMsgSlot.extId2 = CAN_BASE_ADR(channel)->msl[rxObjHandle].extId2;
  #endif
    tempMsgSlot.dlc = CAN_BASE_ADR(channel)->msl[rxObjHandle].dlc;
    for (rxCopyCnt=0; rxCopyCnt<8; rxCopyCnt++)
    {
      tempMsgSlot.data[rxCopyCnt] = CAN_BASE_ADR(channel)->msl[rxObjHandle].data[rxCopyCnt];
    }

  #if defined ( C_PROCESSOR_32176 ) || \
      defined ( C_PROCESSOR_32192 )
  # if defined ( C_ENABLE_MSG_TIMESTAMP )
    tempMsgSlot.tsp = CAN_BASE_ADR(channel)->msl[rxObjHandle].tsp;
  # endif
  #endif

    /* get the id type which is used in CanMsgTransmit() */
    tempMsgSlot.idType = canRxInfoStruct[channel].idType;

  #if defined ( C_ENABLE_HW_LOOP_TIMER )
    if(!ApplCanTimerLoop(kCanLoopRxFinUnset))
    {
      /* stop loop if application indicates it wants to */
      break;
    }
  #endif
  } while ((CAN_BASE_ADR(channel)->mslcnt[rxObjHandle] & kTRFIN) == kTRFIN);

  #if defined ( C_ENABLE_HW_LOOP_TIMER )
  /* stop hw loop timer because loop no longer active */
  ApplCanTimerEnd(kCanLoopRxFinUnset);
  #endif

#if defined( C_HL_ENABLE_RX_INFO_STRUCT_PTR )
  pCanRxInfoStruct =  &canRxInfoStruct[channel];
  (pCanRxInfoStruct->pChipMsgObj) = (CanChipMsgPtr) &tempMsgSlot;
  (pCanRxInfoStruct->pChipData) = (CanChipDataPtr) &tempMsgSlot.data[0];
  /* set RDS pointer for generated RDSBasic macro */
  canRDSRxPtr[canHwChannel] = (CanChipMsgPtr) &tempMsgSlot.data[0];
  pCanRxInfoStruct->Handle      = kCanRxHandleNotUsed;
#else
  (canRxInfoStruct[channel].pChipMsgObj) = (CanChipMsgPtr) &tempMsgSlot;
  (canRxInfoStruct[channel].pChipData) = (CanChipDataPtr) &tempMsgSlot.data[0];
  /* set RDS pointer for generated RDSBasic macro */
  canRDSRxPtr[canHwChannel] = (CanChipMsgPtr) &tempMsgSlot.data[0];
  canRxInfoStruct[channel].Handle      = kCanRxHandleNotUsed;
#endif

#if defined(C_ENABLE_CAN_RAM_CHECK)
  if(canComStatus[channel] == kCanDisableCommunication)
  {
    goto finishBasicCan; /* ignore reception */
  }
#endif

  /* reject messages with unallowed ID type */
  #if defined( C_ENABLE_EXTENDED_ID )
  # if defined( C_ENABLE_MIXED_ID )
  # else
  if (CanRxActualIdType( CAN_HL_P_RX_INFO_STRUCT(channel) ) != kCanIdTypeExt)
  {
    goto finishBasicCan;
  }
  # endif
  #else
  if (CanRxActualIdType( CAN_HL_P_RX_INFO_STRUCT(channel) ) != kCanIdTypeStd)
  {
    goto finishBasicCan;
  }
  #endif


  #if defined( C_HL_ENABLE_OVERRUN_IN_STATUS )
  #else
    #if defined( C_ENABLE_OVERRUN )
  /* overrun occured in one of the two BasicCAN message slots? */
  if ((CAN_BASE_ADR(channel)->mslcnt[kCanBCA] & kML) || (CAN_BASE_ADR(channel)->mslcnt[kCanBCB] & kML))
  {
    /* Note: not necessary to clear on both message slots. it doesn't hurt
     *       either and saves a local variable to store the message slot
     *       where the overrun occurred.
     */
    CAN_BASE_ADR(channel)->mslcnt[kCanBCA] &= (canuint8)~kML;
    CAN_BASE_ADR(channel)->mslcnt[kCanBCB] &= (canuint8)~kML;
    ApplCanOverrun( CAN_CHANNEL_CANPARA_ONLY );
  }
    #endif
  #endif

  #if defined( C_ENABLE_COND_RECEIVE_FCT )
  if(canMsgCondRecState[channel]==kCanTrue)
  {
    ApplCanMsgCondReceived( CAN_HL_P_RX_INFO_STRUCT(channel) );
  }
  #endif

  #if defined( C_ENABLE_RECEIVE_FCT )
  if (APPL_CAN_MSG_RECEIVED( CAN_HL_P_RX_INFO_STRUCT(channel) ) == kCanNoCopyData)
  {
    goto finishBasicCan;
  }
  #endif

# if !defined (C_SEARCH_HASH) || \
     defined ( C_HL_ENABLE_HW_RANGES_FILTER ) || \
     defined ( C_ENABLE_RANGE_0 ) || \
     defined ( C_ENABLE_RANGE_1 ) || \
     defined ( C_ENABLE_RANGE_2 ) || \
     defined ( C_ENABLE_RANGE_3 )
#  if defined( C_ENABLE_EXTENDED_ID )
#   if defined( C_ENABLE_MIXED_ID )
  if (CanRxActualIdType(CAN_HL_P_RX_INFO_STRUCT(channel)) == kCanIdTypeExt)
#   endif
  {
#   if defined( C_ENABLE_RX_MASK_EXT_ID )
    idRaw0 = CanRxActualIdRaw0( CAN_HL_P_RX_INFO_STRUCT(channel) ) & MK_EXTID0(C_MASK_EXT_ID);
#    if (kCanNumberOfUsedCanRxIdTables > 1)
    idRaw1 = CanRxActualIdRaw1( CAN_HL_P_RX_INFO_STRUCT(channel) ) & MK_EXTID1(C_MASK_EXT_ID);
#    endif
#    if (kCanNumberOfUsedCanRxIdTables > 2)
    idRaw2 = CanRxActualIdRaw2( CAN_HL_P_RX_INFO_STRUCT(channel) ) & MK_EXTID2(C_MASK_EXT_ID);
#    endif
#    if (kCanNumberOfUsedCanRxIdTables > 3)
    idRaw3 = CanRxActualIdRaw3( CAN_HL_P_RX_INFO_STRUCT(channel) ) & MK_EXTID3(C_MASK_EXT_ID);
#    endif
#    if (kCanNumberOfUsedCanRxIdTables > 4)
    idRaw4 = CanRxActualIdRaw4( CAN_HL_P_RX_INFO_STRUCT(channel) ) & MK_EXTID4(C_MASK_EXT_ID);
#    endif
#   else
    idRaw0 = CanRxActualIdRaw0( CAN_HL_P_RX_INFO_STRUCT(channel) ) & MK_EXTID0(0x1FFFFFFF);
#    if (kCanNumberOfUsedCanRxIdTables > 1)
    idRaw1 = CanRxActualIdRaw1( CAN_HL_P_RX_INFO_STRUCT(channel) ) & MK_EXTID1(0x1FFFFFFF);
#    endif
#    if (kCanNumberOfUsedCanRxIdTables > 2)
    idRaw2 = CanRxActualIdRaw2( CAN_HL_P_RX_INFO_STRUCT(channel) ) & MK_EXTID2(0x1FFFFFFF);
#    endif
#    if (kCanNumberOfUsedCanRxIdTables > 3)
    idRaw3 = CanRxActualIdRaw3( CAN_HL_P_RX_INFO_STRUCT(channel) ) & MK_EXTID3(0x1FFFFFFF);
#    endif
#    if (kCanNumberOfUsedCanRxIdTables > 4)
    idRaw4 = CanRxActualIdRaw4( CAN_HL_P_RX_INFO_STRUCT(channel) ) & MK_EXTID4(0x1FFFFFFF);
#    endif
#   endif /*  C_ENABLE_RX_MASK_EXT_ID */
  }
#   if defined( C_ENABLE_MIXED_ID )
  else
  {
    idRaw0 = CanRxActualIdRaw0( CAN_HL_P_RX_INFO_STRUCT(channel) ) & MK_STDID0(0x7FF);
#    if (kCanNumberOfUsedCanRxIdTables > 1)
    idRaw1 = CanRxActualIdRaw1( CAN_HL_P_RX_INFO_STRUCT(channel) ) & MK_STDID1(0x7FF);
#    endif
#    if (kCanNumberOfUsedCanRxIdTables > 2)
    idRaw2 = CanRxActualIdRaw2( CAN_HL_P_RX_INFO_STRUCT(channel) ) & MK_STDID2(0x7FF);
#    endif
#    if (kCanNumberOfUsedCanRxIdTables > 3)
    idRaw3 = CanRxActualIdRaw3( CAN_HL_P_RX_INFO_STRUCT(channel) ) & MK_STDID3(0x7FF);
#    endif
#    if (kCanNumberOfUsedCanRxIdTables > 4)
    idRaw4 = CanRxActualIdRaw4( CAN_HL_P_RX_INFO_STRUCT(channel) ) & MK_STDID4(0x7FF);
#    endif
  }
#   endif
#  else /* C_ENABLE_EXTENDED_ID */
  {
    idRaw0 = CanRxActualIdRaw0( CAN_HL_P_RX_INFO_STRUCT(channel) ) & MK_STDID0(0x7FF);
#   if (kCanNumberOfUsedCanRxIdTables > 1)
    idRaw1 = CanRxActualIdRaw1( CAN_HL_P_RX_INFO_STRUCT(channel) ) & MK_STDID1(0x7FF);
#   endif
#   if (kCanNumberOfUsedCanRxIdTables > 2)
    idRaw2 = CanRxActualIdRaw2( CAN_HL_P_RX_INFO_STRUCT(channel) ) & MK_STDID2(0x7FF);
#   endif
#   if (kCanNumberOfUsedCanRxIdTables > 3)
    idRaw3 = CanRxActualIdRaw3( CAN_HL_P_RX_INFO_STRUCT(channel) ) & MK_STDID3(0x7FF);
#   endif
#   if (kCanNumberOfUsedCanRxIdTables > 4)
    idRaw4 = CanRxActualIdRaw4( CAN_HL_P_RX_INFO_STRUCT(channel) ) & MK_STDID4(0x7FF);
#   endif
  }
#  endif /* C_ENABLE_EXTENDED_ID */
# endif /* !defined (C_SEARCH_HASH) || ...  defined ( C_ENABLE_RANGE_3 )*/

# if defined(C_HL_ENABLE_HW_RANGES_FILTER)


# else

  #if defined( C_ENABLE_MIXED_ID )
  #  if defined( C_ENABLE_RANGE_EXTENDED_ID )
  if (CanRxActualIdType( CAN_HL_P_RX_INFO_STRUCT(channel) ) == kCanIdTypeExt)
  #  else
  if (CanRxActualIdType( CAN_HL_P_RX_INFO_STRUCT(channel) ) == kCanIdTypeStd)
  #  endif
  #endif
  {
    #if defined( C_ENABLE_RANGE_0 )
    # if defined ( C_MULTIPLE_RECEIVE_CHANNEL )
    if ( (CanChannelObject[channel].RangeActiveFlag & kCanRange0) != 0 )
    # endif
    {
      if ( C_RANGE_MATCH( CAN_RX_IDRAW_PARA, CANRANGE0ACCMASK(channel), CANRANGE0ACCCODE(channel)) )
      {
      #if defined( C_HL_ENABLE_RX_INFO_STRUCT_PTR )
        pCanRxInfoStruct->EcuNumber = C_MK_ECU_NUMBER(CAN_RX_IDRAW_PARA, CANRANGE0ACCMASK(channel));
      #else
        canRxInfoStruct[channel].EcuNumber = C_MK_ECU_NUMBER(CAN_RX_IDRAW_PARA, CANRANGE0ACCMASK(channel));
      #endif
        (void)APPLCANRANGE0PRECOPY( CAN_HL_P_RX_INFO_STRUCT(channel) );
        goto finishBasicCan;
      }
    }
    #endif  /* C_ENABLE_RANGE_0 */

    #if defined( C_ENABLE_RANGE_1 )
    # if defined ( C_MULTIPLE_RECEIVE_CHANNEL )
    if ( (CanChannelObject[channel].RangeActiveFlag & kCanRange1) != 0 )
    # endif
    {
      if ( C_RANGE_MATCH( CAN_RX_IDRAW_PARA, CANRANGE1ACCMASK(channel), CANRANGE1ACCCODE(channel)) )
      {
      #if defined( C_HL_ENABLE_RX_INFO_STRUCT_PTR )
        pCanRxInfoStruct->EcuNumber = C_MK_ECU_NUMBER(CAN_RX_IDRAW_PARA, CANRANGE1ACCMASK(channel));
      #else
        canRxInfoStruct[channel].EcuNumber = C_MK_ECU_NUMBER(CAN_RX_IDRAW_PARA, CANRANGE1ACCMASK(channel));
      #endif
        (void)APPLCANRANGE1PRECOPY( CAN_HL_P_RX_INFO_STRUCT(channel) );
        goto finishBasicCan;
      }
    }
    #endif

    #if defined( C_ENABLE_RANGE_2 )
    # if defined ( C_MULTIPLE_RECEIVE_CHANNEL )
    if ( (CanChannelObject[channel].RangeActiveFlag & kCanRange2) != 0 )
    # endif
    {
      if ( C_RANGE_MATCH( CAN_RX_IDRAW_PARA, CANRANGE2ACCMASK(channel), CANRANGE2ACCCODE(channel)) )
      {
      #if defined( C_HL_ENABLE_RX_INFO_STRUCT_PTR )
        pCanRxInfoStruct->EcuNumber = C_MK_ECU_NUMBER(CAN_RX_IDRAW_PARA, CANRANGE2ACCMASK(channel));
      #else
        canRxInfoStruct[channel].EcuNumber = C_MK_ECU_NUMBER(CAN_RX_IDRAW_PARA, CANRANGE2ACCMASK(channel));
      #endif
        (void)APPLCANRANGE2PRECOPY( CAN_HL_P_RX_INFO_STRUCT(channel) );
        goto finishBasicCan;
      }
    }
    #endif

    #if defined( C_ENABLE_RANGE_3 )
    # if defined ( C_MULTIPLE_RECEIVE_CHANNEL )
    if ( (CanChannelObject[channel].RangeActiveFlag & kCanRange3) != 0 )
    # endif
    {
      if ( C_RANGE_MATCH( CAN_RX_IDRAW_PARA, CANRANGE3ACCMASK(channel), CANRANGE3ACCCODE(channel)) )
      {
      #if defined( C_HL_ENABLE_RX_INFO_STRUCT_PTR )
        pCanRxInfoStruct->EcuNumber = C_MK_ECU_NUMBER(CAN_RX_IDRAW_PARA, CANRANGE3ACCMASK(channel));
      #else
        canRxInfoStruct[channel].EcuNumber = C_MK_ECU_NUMBER(CAN_RX_IDRAW_PARA, CANRANGE3ACCMASK(channel));
      #endif
        (void)APPLCANRANGE3PRECOPY( CAN_HL_P_RX_INFO_STRUCT(channel) );
        goto finishBasicCan;
      }
    }
    #endif
  }

# endif /* defined(C_HL_ENABLE_HW_RANGES_FILTER) */

#if defined( C_ENABLE_GENERIC_PRECOPY ) || \
    defined( C_ENABLE_PRECOPY_FCT )     || \
    defined( C_ENABLE_COPY_RX_DATA )    || \
    defined( C_ENABLE_INDICATION_FLAG ) || \
    defined( C_ENABLE_INDICATION_FCT )  || \
    defined( C_ENABLE_DLC_CHECK )       || \
    defined( C_ENABLE_NOT_MATCHED_FCT )
   /* search the received id in ROM table: */


# if defined( C_SEARCH_LINEAR )
  /* ************* Linear search ******************************************** */
  for (i = (CanSignedRxHandle)CAN_HL_RX_BASIC_STOPINDEX(channel)-(CanSignedRxHandle)1;
                                      i >= (CanSignedRxHandle)CAN_HL_RX_BASIC_STARTINDEX(channel) ;i--)
  {
    if( idRaw0 == CanGetRxId0(i) )
    {
#  if (kCanNumberOfUsedCanRxIdTables > 1)
      if( idRaw1 == CanGetRxId1(i) )
#  endif
      {
#  if (kCanNumberOfUsedCanRxIdTables > 2)
        if( idRaw2 == CanGetRxId2(i) )
#  endif
        {
#  if (kCanNumberOfUsedCanRxIdTables > 3)
          if( idRaw3 == CanGetRxId3(i) )
#  endif
          {
#  if (kCanNumberOfUsedCanRxIdTables > 4)
            if( idRaw4 == CanGetRxId4(i) )
#  endif
            {
#  if defined(C_ENABLE_MIXED_ID)
#   if defined(C_HL_ENABLE_IDTYPE_IN_ID)
#   else
              /* verify ID type, if not already done with the ID raw */
              if (CanRxActualIdType( CAN_HL_P_RX_INFO_STRUCT(channel) ) == CanGetRxIdType(i))
#   endif
#  endif
              {
                break;    /*exit loop with index i */
              }
            }
          }
        }
      }
    }
  }
# endif

# if defined ( C_SEARCH_HASH )
  /* ************* Hash search ********************************************* */
#  if defined ( C_CPUTYPE_8BIT )
#   error "Hash search with 8-Bit CPU not tested yet"
#  endif

#  if defined( C_ENABLE_EXTENDED_ID )
  /* one or more Extended ID listed */
#   if defined(C_ENABLE_MIXED_ID)
  if((CanRxActualIdType( CAN_HL_P_RX_INFO_STRUCT(channel) )) == kCanIdTypeExt)
#   endif
#   if (kHashSearchListCountEx > 0)
  {
  /* calculate the logical ID */
#    if defined(C_ENABLE_RX_MASK_EXT_ID)
    id          = (CanRxActualId( CAN_HL_P_RX_INFO_STRUCT(channel) ) &  C_MASK_EXT_ID ) | \
                                                                               ((canuint32)channel << 29);
#    else
    id          = CanRxActualId( CAN_HL_P_RX_INFO_STRUCT(channel) )| ((canuint32)channel << 29);
#    endif

    wintern     = id + kHashSearchRandomNumberEx;
    i           = (CanReceiveHandle)(wintern % kHashSearchListCountEx);
#    if (kHashSearchListCountEx == 1)
    i_increment = 0;
#    else
    i_increment = (wintern % (kHashSearchListCountEx - 1) + 1);
#    endif
    count       = kHashSearchMaxStepsEx-1;

    while(id != CanRxHashIdEx[i])
    {
      if(count == 0)
      {
#    if defined(C_ENABLE_NOT_MATCHED_FCT)
        ApplCanMsgNotMatched( CAN_HL_P_RX_INFO_STRUCT(channel) );
#    endif
        goto finishBasicCan;
      }
      count--;
      i += i_increment;
      if( i >= (canuint16)kHashSearchListCountEx )
      {
        i -= kHashSearchListCountEx;
      }
    }
    i = CanRxMsgIndirection[i+kHashSearchListCount];
  }
#   else /* (kHashSearchListCountEx > 0) */
  {
#    if defined(C_ENABLE_NOT_MATCHED_FCT)
    ApplCanMsgNotMatched( CAN_HL_P_RX_INFO_STRUCT(channel) );
#    endif
    goto finishBasicCan;
  }
#   endif /* (kHashSearchListCountEx > 0) */

#   if defined(C_ENABLE_MIXED_ID)
  else if((CanRxActualIdType( CAN_HL_P_RX_INFO_STRUCT(channel) )) == kCanIdTypeStd)
#   endif
#  endif /* IF defined( C_ENABLE_EXTENDED_ID ) */

#  if defined(C_ENABLE_MIXED_ID) || !defined( C_ENABLE_EXTENDED_ID )
#   if (kHashSearchListCount > 0)
  {
    id          = (canuint16)(CanRxActualId( CAN_HL_P_RX_INFO_STRUCT(channel) )
                               | ((canuint16)channel << 11));                /* calculate the logical ID */
    wintern     = id + kHashSearchRandomNumber;
    i           = (CanReceiveHandle)(wintern % kHashSearchListCount);
#    if (kHashSearchListCount == 1)
    i_increment = 0;
#    else
    i_increment = (wintern % (kHashSearchListCount - 1) + 1);
#    endif
    count       = kHashSearchMaxSteps-1;

    /* type of CanRxHashId table depends on the used type of Id */
    while ( id != CanRxHashId[i])
    {
      if (count == 0)
      {
        #if defined ( C_ENABLE_NOT_MATCHED_FCT )
        ApplCanMsgNotMatched( CAN_HL_P_RX_INFO_STRUCT(channel) );
        #endif
        goto finishBasicCan;
      }
      count--;
      i += i_increment;
      if ( i >= kHashSearchListCount )
      {
        i -= kHashSearchListCount;
      }
    }
    i = CanRxMsgIndirection[i];
  }
#   else /* (kHashSearchListCount > 0) */
  {
#    if defined(C_ENABLE_NOT_MATCHED_FCT)
    ApplCanMsgNotMatched( CAN_HL_P_RX_INFO_STRUCT(channel) );
#    endif
    goto finishBasicCan;
  }
#   endif /* (kHashSearchListCount > 0) */
#  endif /* defined(C_ENABLE_MIXED_ID) || !defined( C_ENABLE_EXTENDED_ID ) */
# endif /* defined ( C_SEARCH_HASH ) */

# if defined ( C_SEARCH_HASH )
  assertInternal((i <= kCanNumberOfRxObjects), kCanAllChannels , kErrorRxHandleWrong);  /* legal txHandle ? */
# else
  if ( i >= (CanSignedRxHandle)CAN_HL_RX_BASIC_STARTINDEX(channel))
# endif
  {
    /* ID found in table */
    #if defined ( C_SEARCH_HASH )
    #else
     #if defined( C_ENABLE_RX_MSG_INDIRECTION )
    i = CanRxMsgIndirection[i];       /* indirection for special sort-algoritms */
     #endif
    #endif
    #if defined(C_ENABLE_RX_QUEUE)
    if (CanHL_ReceivedRxHandleQueue( CAN_CHANNEL_CANPARA_FIRST (CanReceiveHandle)i) == kCanHlContinueRx)
    #else
    if (CanHL_ReceivedRxHandle( CAN_CHANNEL_CANPARA_FIRST (CanReceiveHandle)i ) == kCanHlContinueRx)
    #endif
    {
      #if defined( C_ENABLE_INDICATION_FLAG ) || \
          defined( C_ENABLE_INDICATION_FCT )

      CanHL_IndRxHandle( (CanReceiveHandle)i );


      return;
      #endif
    }
  }
  #if defined ( C_ENABLE_NOT_MATCHED_FCT )
    #if defined( C_SEARCH_HASH )
    #else
  else
  {
    ApplCanMsgNotMatched( CAN_HL_P_RX_INFO_STRUCT(channel) );
  }
    #endif
  #endif

#endif

  goto finishBasicCan;     /* to avoid compiler warning */

/* if defined( C_ENABLE_RANGE_0 ) || \
       defined( C_ENABLE_RANGE_1 ) || \
       defined( C_ENABLE_RANGE_2 ) || \
       defined( C_ENABLE_RANGE_3 ) || \
       defined( C_ENABLE_RECEIVE_FCT ) || \
       defined( C_SEARCH_HASH )  */
/* Msg(4:2015) This label is not a case or default label for a switch statement. MISRA Rule 55 */
finishBasicCan:
/* endif */

  /* make receive buffer free*/


  return;    /* to avoid compiler warnings about label without code */

} /* end of BasicCan */
# if defined ( MISRA_CHECK )
#  pragma PRQA_MESSAGES_ON 2006,2001,2015
# endif
#endif

#if defined ( C_ENABLE_RX_FULLCAN_OBJECTS )
/****************************************************************************
| NAME:             CanFullCanMsgReceived
| CALLED BY:        CanISR()
| PRECONDITIONS:
| INPUT PARAMETERS: internal can chip number
| RETURN VALUES:    none
| DESCRIPTION:      - full can receive
****************************************************************************/
# if defined ( MISRA_CHECK )
  /* suppress misra message about multiple return and usage of goto */
#  pragma PRQA_MESSAGES_OFF 2006,2001,2015
# endif
static void CanFullCanMsgReceived( CAN_HW_CHANNEL_CANTYPE_FIRST CanObjectHandle rxObjHandle )
{
  CanReceiveHandle   rxHandle;

#if defined( C_HL_ENABLE_RX_INFO_STRUCT_PTR )
  tCanRxInfoStruct    *pCanRxInfoStruct;
#endif

  /* the M32R CAN controller doesn't offer overwrite protection when reading
   * out the message slot. therefore read out the entire contents at once
   * and store into a tempbuffer for further processing. this tempbuffer is
   * also used in CanLL_RxBasicGetCANObjPtr and CanLL_RxBasicGetCANDataPtr.
   */
  static tCanTmpMsgSlot tempMsgSlot;

  /* counter used to copy data from CAN to the tempMsgSlot */
  canuint8 rxCopyCnt;

  CANDRV_SET_CODE_TEST_POINT(0x101);


#if defined ( C_ENABLE_MULTI_ECU_CONFIG )
  assertUser(( (CanChannelIdentityAssignment[channel] & V_ACTIVE_IDENTITY_MSK) != (tVIdentityMsk)0 ), channel, kErrorDisabledChannel);
#endif

  /* assert the hardware to make sure the rx message slot is idle and not busy
   * with the reception of a message.
   */
  assertHardware(((CAN_BASE_ADR(channel)->mslcnt[rxObjHandle] & kTRSTAT) != kTRSTAT), channel, kErrorRxBufferBusy);

  if(CAN_BASE_ADR(channel)->mslcnt[rxObjHandle] & kRA) /* ESCAN00009085 */
  {
    /*
    Discard the Remote Frame and cancel the standard process.
    Clear transmission work and finished bit and confirm the Remote Abort, to be on the save side.
    If the Remote Frame causes an Overrun, the Overrun must be cleared, because invalid.
    */
    CAN_BASE_ADR(channel)->mslcnt[rxObjHandle] &= ~(kTRFIN | kTRSTAT | kML | kRA);
    return;
  }

  /* ID type information is stored on a seperate register and not in the msg
   * slot. therefore an additional structure member was introduced for the
   * tCanRxInfoStruct. this member is set here.
   */
  #if defined ( C_ENABLE_EXTENDED_ID )
  # if defined ( C_ENABLE_MIXED_ID )
  if (CAN_BASE_ADR(channel)->extid & msgSlotBitmask[rxObjHandle])
  {
    canRxInfoStruct[channel].idType = kCanIdTypeExt;
  }
  else
  {
    canRxInfoStruct[channel].idType = kCanIdTypeStd;
  }
  # else
  canRxInfoStruct[channel].idType = kCanIdTypeExt;
  # endif /* C_ENABLE_MIXED_ID */
  #else
  canRxInfoStruct[channel].idType = kCanIdTypeStd;
  #endif /* C_ENABLE_EXTENDED_ID */

  /* the M32R CAN controller doesn't offer overwrite protection when reading
   * out the message slot. therefore read out the entire contents at once
   * and store into a tempbuffer for further processing.
   */
  #if defined ( C_ENABLE_HW_LOOP_TIMER )
  /* start hw loop timer before entering while loop for hardware handshake */
  ApplCanTimerStart(kCanLoopRxFinUnset);
  #endif

  do
  {
    /* clear reception finished bit */
    CAN_BASE_ADR(channel)->mslcnt[rxObjHandle] &= (canuint8)~kTRFIN;

    /* copy the entire msg object to the temporary local variable */
    tempMsgSlot.stdId0 = CAN_BASE_ADR(channel)->msl[rxObjHandle].stdId0;
    tempMsgSlot.stdId1 = CAN_BASE_ADR(channel)->msl[rxObjHandle].stdId1;
  #if defined ( C_ENABLE_EXTENDED_ID )
    tempMsgSlot.extId0 = CAN_BASE_ADR(channel)->msl[rxObjHandle].extId0;
    tempMsgSlot.extId1 = CAN_BASE_ADR(channel)->msl[rxObjHandle].extId1;
    tempMsgSlot.extId2 = CAN_BASE_ADR(channel)->msl[rxObjHandle].extId2;
  #endif
    tempMsgSlot.dlc = CAN_BASE_ADR(channel)->msl[rxObjHandle].dlc;
    for (rxCopyCnt=0; rxCopyCnt<8; rxCopyCnt++)
    {
      tempMsgSlot.data[rxCopyCnt] = CAN_BASE_ADR(channel)->msl[rxObjHandle].data[rxCopyCnt];
    }

  #if defined ( C_PROCESSOR_32176 ) || \
      defined ( C_PROCESSOR_32192 )
  # if defined ( C_ENABLE_MSG_TIMESTAMP )
    tempMsgSlot.tsp = CAN_BASE_ADR(channel)->msl[rxObjHandle].tsp;
  # endif
  #endif

    /* get the id type which is used in CanMsgTransmit() */
    tempMsgSlot.idType = canRxInfoStruct[channel].idType;

  #if defined ( C_ENABLE_HW_LOOP_TIMER )
    if(!ApplCanTimerLoop(kCanLoopRxFinUnset))
    {
      /* stop loop if application indicates it wants to */
      break;
    }
  #endif
  } while ((CAN_BASE_ADR(channel)->mslcnt[rxObjHandle] & kTRFIN) == kTRFIN);

  #if defined ( C_ENABLE_HW_LOOP_TIMER )
  /* stop hw loop timer because loop no longer active */
  ApplCanTimerEnd(kCanLoopRxFinUnset);
  #endif

#if defined( C_HL_ENABLE_RX_INFO_STRUCT_PTR )
  /* pointer needed for other modules */
  pCanRxInfoStruct =  &canRxInfoStruct[channel];
  (pCanRxInfoStruct->pChipMsgObj) = (CanChipMsgPtr)&tempMsgSlot;
  (pCanRxInfoStruct->pChipData) = (CanChipDataPtr) &tempMsgSlot.data[0];
  /* set RDS pointer for generated RDSxx FullCAN macros */
  canRDSRxPtr[canHwChannel] = (CanChipMsgPtr) &tempMsgSlot.data[0];
#else
  (canRxInfoStruct[channel].pChipMsgObj) = (CanChipMsgPtr)&tempMsgSlot;
  (canRxInfoStruct[channel].pChipData) = (CanChipDataPtr) &tempMsgSlot.data[0];
  /* set RDS pointer for generated RDSxx FullCAN macros */
  canRDSRxPtr[canHwChannel] = (CanChipMsgPtr) &tempMsgSlot.data[0];
#endif

#if defined(C_ENABLE_CAN_RAM_CHECK)
  if(canComStatus[channel] == kCanDisableCommunication)
  {
    goto finishRxFullCan; /* ignore reception */
  }
#endif

#if defined( C_ENABLE_EXTENDED_ID )
# if defined( C_ENABLE_MIXED_ID )
# else
  if (CanRxActualIdType( CAN_HL_P_RX_INFO_STRUCT(channel) ) != kCanIdTypeExt)
  {
    goto finishRxFullCan;
  }
# endif
#else
  if (CanRxActualIdType( CAN_HL_P_RX_INFO_STRUCT(channel) ) != kCanIdTypeStd)
  {
    goto finishRxFullCan;
  }
#endif

#if defined( C_HL_ENABLE_OVERRUN_IN_STATUS )
#else
# if defined( C_ENABLE_FULLCAN_OVERRUN )

  if (CAN_BASE_ADR(channel)->mslcnt[rxObjHandle] & kML)       /* overrun occured?         */
  {
    /* clear overrun event flag */
    CAN_BASE_ADR(channel)->mslcnt[rxObjHandle] &= (canuint8)~kML;
     ApplCanFullCanOverrun( CAN_CHANNEL_CANPARA_ONLY );
  }
# endif
#endif

#if defined( C_ENABLE_COND_RECEIVE_FCT )
  if(canMsgCondRecState[channel]==kCanTrue)
  {
    ApplCanMsgCondReceived( CAN_HL_P_RX_INFO_STRUCT(channel) );
  }
#endif

#if defined( C_ENABLE_RECEIVE_FCT )
  if (APPL_CAN_MSG_RECEIVED( CAN_HL_P_RX_INFO_STRUCT(channel) )==kCanNoCopyData)
  {
     goto finishRxFullCan;
  }
#endif

  /* calculate the message handle to access the generated data for the received message */

  /* brackets to avoid lint info 834 */
  rxHandle = (rxObjHandle - CAN_HL_HW_RX_FULL_STARTINDEX(canHwChannel))
#if defined( C_SEARCH_HASH )
                         + kHashSearchListCount
                         + kHashSearchListCountEx
#endif
                         + CAN_HL_RX_FULL_STARTINDEX(canHwChannel);

#if defined(C_HL_ENABLE_ADJUST_RXHANDLE)
#endif

# if defined( C_ENABLE_RX_MSG_INDIRECTION ) || \
     defined( C_SEARCH_HASH )
  rxHandle = CanRxMsgIndirection[rxHandle];
# endif


  if (rxHandle != kCanBufferFree)      /* if msg exists in ROM table */
  {
    #if defined(C_ENABLE_RX_QUEUE)
    if (CanHL_ReceivedRxHandleQueue( CAN_CHANNEL_CANPARA_FIRST rxHandle) == kCanHlContinueRx)
    #else
    if (CanHL_ReceivedRxHandle( CAN_CHANNEL_CANPARA_FIRST rxHandle ) == kCanHlContinueRx)
    #endif
    {
      #if defined( C_ENABLE_INDICATION_FLAG ) || \
          defined( C_ENABLE_INDICATION_FCT )

      CanHL_IndRxHandle( rxHandle );


      return;
      #endif
    }
  }

  goto finishRxFullCan;     /* to avoid compiler warning */

/* Msg(4:2015) This label is not a case or default label for a switch statement. MISRA Rule 55 */
finishRxFullCan:

  /* make receive buffer free*/


  return;    /* to avoid compiler warnings about label without code */
}
# if defined ( MISRA_CHECK )
#  pragma PRQA_MESSAGES_ON 2006,2001,2015
# endif
#endif

#if defined ( C_ENABLE_RX_FULLCAN_OBJECTS )  || \
    defined ( C_ENABLE_RX_BASICCAN_OBJECTS )
/****************************************************************************
| NAME:             CanHL_ReceivedRxHandle
| CALLED BY:        CanBasicCanMsgReceived, CanFullCanMsgReceived
| PRECONDITIONS:
| INPUT PARAMETERS: Handle of received Message to access generated data
| RETURN VALUES:    none
| DESCRIPTION:      DLC-check, Precopy and copy of Data for received message
****************************************************************************/
# if defined ( MISRA_CHECK )
  /* suppress misra message about multiple return  */
#  pragma PRQA_MESSAGES_OFF 2006
# endif
canuint8 CanHL_ReceivedRxHandle( CAN_CHANNEL_CANTYPE_FIRST CanReceiveHandle rxHandle )
{
#if defined( C_HL_ENABLE_RX_INFO_STRUCT_PTR )
  tCanRxInfoStruct    *pCanRxInfoStruct;
#endif

  #if defined( C_ENABLE_COPY_RX_DATA )
    #if C_SECURITY_LEVEL > 20
  CanDeclareGlobalInterruptOldStatus
    #endif
  #endif

# if defined( C_HL_ENABLE_RX_INFO_STRUCT_PTR )
  pCanRxInfoStruct =  &canRxInfoStruct[channel];
  pCanRxInfoStruct->Handle = rxHandle;
# else
  canRxInfoStruct[channel].Handle = rxHandle;
# endif

#if defined ( C_ENABLE_MULTI_ECU_PHYS )
  if ( (CanRxIdentityAssignment[rxHandle] & V_ACTIVE_IDENTITY_MSK) == (tVIdentityMsk)0 )
  {
    /* message is not a receive message in the active indentity */
    CANDRV_SET_CODE_TEST_POINT(0x10B);
    return  kCanHlFinishRx;
  }
#endif


#if defined( C_ENABLE_DLC_CHECK )
# if defined( C_ENABLE_VARIABLE_RX_DATALEN )
  /* ##RI1.4 - 3.31: Dynamic Receive DLC */
  if ( canVariableRxDataLen[rxHandle]       > CanRxActualDLC( CAN_HL_P_RX_INFO_STRUCT(channel) ) )
# else
  if ( (CanGetRxDataLen(rxHandle)) > CanRxActualDLC( CAN_HL_P_RX_INFO_STRUCT(channel) ) )
# endif
  {
    /* ##RI1.4 - 2.7: Callbackfunction-DLC-Check */
# if defined ( C_ENABLE_DLC_FAILED_FCT )
    ApplCanMsgDlcFailed( CAN_HL_P_RX_INFO_STRUCT(channel) );
# endif  /*C_ENABLE_DLC_FAILED_FCT */
    return  kCanHlFinishRx;
  }
#endif

# if defined ( C_ENABLE_VARIABLE_RX_DATALEN_COPY )
  CanSetVariableRxDatalen(rxHandle, CanRxActualDLC( CAN_HL_P_RX_INFO_STRUCT(channel) ));
# endif

  #if defined( C_ENABLE_PRECOPY_FCT )
    #if defined ( C_HL_ENABLE_DUMMY_FCT_CALL )
    #else
  if ( CanGetApplPrecopyPtr(rxHandle) != NULL )    /*precopy routine */
    #endif
  {
    /* canRxHandle in indexed drivers only for consistancy check in higher layer modules */
    canRxHandle[channel] = rxHandle;

    if ( CanGetApplPrecopyPtr(rxHandle)( CAN_HL_P_RX_INFO_STRUCT(channel) )==kCanNoCopyData )
    {  /* precopy routine returns kCanNoCopyData:   */
      return  kCanHlFinishRx;
    }                      /* do not copy data check next irpt */
  }
  #endif

  #if defined( C_ENABLE_GENERIC_PRECOPY )
  if ( ApplCanGenericPrecopy( CAN_HL_P_RX_INFO_STRUCT(channel) ) != kCanCopyData)
  {
    return kCanHlFinishRx;
  }
  #endif

  #if defined( C_ENABLE_COPY_RX_DATA )
  /* no precopy or precopy returns kCanCopyData : copy data -- */
  /* copy via index -------------------------------------------*/
  if ( CanGetRxDataPtr(rxHandle) != NULL )      /* copy if buffer exists */
  {
    /* copy data ---------------------------------------------*/
    #if C_SECURITY_LEVEL > 20
    CanSingleGlobalInterruptDisable();
    #endif
# if defined( C_ENABLE_VARIABLE_RX_DATALEN )
    CANDRV_SET_CODE_TEST_POINT(0x106);
  /* ##RI1.4 - 3.31: Dynamic Receive DLC */
    #if defined( C_HL_ENABLE_RX_INFO_STRUCT_PTR )
    for (canMemCopyCnt=0; canMemCopyCnt < canVariableRxDataLen[rxHandle]; canMemCopyCnt++)
    {
      ((canuint8*)CanGetRxDataPtr(rxHandle))[canMemCopyCnt] = pCanRxInfoStruct->pChipData[canMemCopyCnt];
    }
    #else
    for (canMemCopyCnt=0; canMemCopyCnt < canVariableRxDataLen[rxHandle]; canMemCopyCnt++)
    {
      ((canuint8*)CanGetRxDataPtr(rxHandle))[canMemCopyCnt] = canRxInfoStruct[channel].pChipData[canMemCopyCnt];
    }
    #endif
# else
    CANDRV_SET_CODE_TEST_POINT(0x107);
    #if defined( C_HL_ENABLE_RX_INFO_STRUCT_PTR )
    for (canMemCopyCnt=0; canMemCopyCnt < CanGetRxDataLen(rxHandle); canMemCopyCnt++)
    {
      ((canuint8*)CanGetRxDataPtr(rxHandle))[canMemCopyCnt] = pCanRxInfoStruct->pChipData[canMemCopyCnt];
    }
    #else
    for (canMemCopyCnt=0; canMemCopyCnt < CanGetRxDataLen(rxHandle); canMemCopyCnt++)
    {
      ((canuint8*)CanGetRxDataPtr(rxHandle))[canMemCopyCnt] = canRxInfoStruct[channel].pChipData[canMemCopyCnt];
    }
    #endif
# endif
    #if C_SECURITY_LEVEL > 20
    CanSingleGlobalInterruptRestore();
    #endif
  }
  #endif /* ( C_ENABLE_COPY_RX_DATA ) */

  CANDRV_SET_CODE_TEST_POINT(0x105);
  return kCanHlContinueRx;
} /* end of CanReceivceRxHandle() */
# if defined ( MISRA_CHECK )
#  pragma PRQA_MESSAGES_ON 2006
# endif

# if defined( C_ENABLE_INDICATION_FLAG ) || \
     defined( C_ENABLE_INDICATION_FCT )
/****************************************************************************
| NAME:             CanHL_IndRxHandle
| CALLED BY:        CanBasicCanMsgReceived, CanFullCanMsgReceived
| PRECONDITIONS:
| INPUT PARAMETERS: Handle of received Message to access generated data
| RETURN VALUES:    none
| DESCRIPTION:      DLC-check, Precopy and copy of Data for received message
****************************************************************************/
static void CanHL_IndRxHandle( CanReceiveHandle rxHandle )
{
#  if defined( C_ENABLE_INDICATION_FLAG )
#   if C_SECURITY_LEVEL > 20
  CanDeclareGlobalInterruptOldStatus
#   endif
#  endif

#  if defined( C_ENABLE_INDICATION_FLAG )
#   if C_SECURITY_LEVEL > 20
  CanSingleGlobalInterruptDisable();
#   endif
  CanIndicationFlags._c[CanGetIndicationOffset(rxHandle)] |= CanGetIndicationMask(rxHandle);
#   if C_SECURITY_LEVEL > 20
  CanSingleGlobalInterruptRestore();
#   endif
#  endif

#  if defined( C_ENABLE_INDICATION_FCT )
#   if defined ( C_HL_ENABLE_DUMMY_FCT_CALL )
#   else
  if ( CanGetApplIndicationPtr(rxHandle) != NULL )
#   endif
  {
    CanGetApplIndicationPtr(rxHandle)(rxHandle);  /* call IndicationRoutine */
  }
#  endif
}
# endif /* C_ENABLE_INDICATION_FLAG || C_ENABLE_INDICATION_FCT  */
#endif


/****************************************************************************
| NAME:             CanHL_TxConfirmation
| CALLED BY:        CanISR()
| PRECONDITIONS:
| INPUT PARAMETERS: - internal can chip number
|                   - interrupt ID
| RETURN VALUES:    none
| DESCRIPTION:      - full can transmit
****************************************************************************/
#if defined ( MISRA_CHECK )
 /* suppress misra message about multiple return  */
# pragma PRQA_MESSAGES_OFF 2006,2001,2015
#endif
static void CanHL_TxConfirmation( CAN_HW_CHANNEL_CANTYPE_FIRST CanObjectHandle txObjHandle)
{
  CanObjectHandle       logTxObjHandle;
  CanTransmitHandle     txHandle;


#if defined( C_ENABLE_TRANSMIT_QUEUE )
  CanSignedTxHandle   i;
  CanDeclareGlobalInterruptOldStatus
#else
# if defined( C_ENABLE_CONFIRMATION_FLAG )
#  if C_SECURITY_LEVEL > 20
  CanDeclareGlobalInterruptOldStatus
#  endif
# endif
#endif


#if defined(C_ENABLE_CAN_CANCEL_NOTIFICATION) && \
    defined( C_ENABLE_TRANSMIT_QUEUE )
  canuint8 rc;
#endif



#if defined ( C_ENABLE_MULTI_ECU_CONFIG )
  assertUser(( (CanChannelIdentityAssignment[channel] & V_ACTIVE_IDENTITY_MSK) != (tVIdentityMsk)0 ), channel, kErrorDisabledChannel);
#endif

  logTxObjHandle = (CanObjectHandle)((vsintx)txObjHandle + CAN_HL_TX_OFFSET_HW_TO_LOG(canHwChannel));

  /* assert the hardware to make sure the tx message slot is idle and not busy
   * with the transmission of a message.
   */
  assertHardware(((CAN_BASE_ADR(channel)->mslcnt[txObjHandle] & kTRSTAT) != kTRSTAT), channel, kErrorTxBufferBusy);

  #if defined( C_ENABLE_CANCEL_IN_HW )
  CanMsgControl[channel] = CAN_BASE_ADR(channel)->mslcnt[txObjHandle]; /* store the message control status */
  #endif

  /* clear all bits for transmission finished detection in the msg slot's
   * control register.
   */
  CAN_BASE_ADR(channel)->mslcnt[txObjHandle] = 0;        /* msg slot inactive    */

  txHandle = canHandleCurTxObj[logTxObjHandle];           /* get saved handle */


  /* check associated transmit handle */
  if (txHandle == kCanBufferFree)
  {
    assertInternal (0, channel, kErrorTxHandleWrong);          /*lint !e506 !e774*/
    goto finishCanHL_TxConfirmation;
  }

#if defined( C_ENABLE_TX_OBSERVE ) || \
    defined ( C_ENABLE_CAN_TX_CONF_FCT )
# if defined(C_ENABLE_CANCEL_IN_HW)
  if((CanMsgControl[channel] & kTRFIN) == kTRFIN)
# endif
  {
# if defined( C_ENABLE_TX_OBSERVE )
#  if defined ( C_HL_ENABLE_TX_MSG_DESTROYED )
    if (txHandle != kCanBufferMsgDestroyed)
#  endif
    {
      ApplCanTxObjConfirmed( CAN_CHANNEL_CANPARA_FIRST logTxObjHandle );
    }
# endif

# if defined ( C_ENABLE_CAN_TX_CONF_FCT )
/* ##RI-1.10 Common Callbackfunction in TxInterrupt */
    txInfoStructConf[channel].Handle  = txHandle;
    ApplCanTxConfirmation(&txInfoStructConf[channel]);
# endif
  }
#endif /* defined( C_ENABLE_TX_OBSERVE ) || defined ( C_ENABLE_CAN_TX_CONF_FCT ) */

#if defined( C_ENABLE_TRANSMIT_QUEUE )
# if defined( C_ENABLE_TX_FULLCAN_OBJECTS )  || \
     defined( C_ENABLE_MSG_TRANSMIT )
  if (txObjHandle != CAN_HL_HW_TX_NORMAL_INDEX(canHwChannel))
  {
    canHandleCurTxObj[logTxObjHandle] = kCanBufferFree;                 /* free msg object of FullCAN or LowLevel Tx obj. */
  }
# endif
#else
  canHandleCurTxObj[logTxObjHandle] = kCanBufferFree;                   /* free msg object if queue is not used */
#endif

#if defined ( C_HL_ENABLE_TX_MSG_DESTROYED )
  if ((txHandle != kCanBufferCancel) && (txHandle != kCanBufferMsgDestroyed))
#else
  if (txHandle != kCanBufferCancel)
#endif
  {
#if defined( C_ENABLE_MSG_TRANSMIT )
    if (txObjHandle == CAN_HL_HW_MSG_TRANSMIT_INDEX(canHwChannel))
    {
#if defined( C_ENABLE_MSG_TRANSMIT_CONF_FCT )
      ApplCanMsgTransmitConf( CAN_CHANNEL_CANPARA_ONLY );
#endif

      goto finishCanHL_TxConfirmation;
    }
#endif

#if defined ( C_ENABLE_MULTI_ECU_PHYS )
    assertUser(((CanTxIdentityAssignment[txHandle] & V_ACTIVE_IDENTITY_MSK) != (tVIdentityMsk)0 ), channel , kErrorDisabledTxMessage);
#endif

#if defined ( C_ENABLE_CONFIRMATION_FLAG )       /* set transmit ready flag  */
# if C_SECURITY_LEVEL > 20
    CanSingleGlobalInterruptDisable();
# endif
    CanConfirmationFlags._c[CanGetConfirmationOffset(txHandle)] |= CanGetConfirmationMask(txHandle);
# if C_SECURITY_LEVEL > 20
    CanSingleGlobalInterruptRestore();
# endif
#endif

#if defined( C_ENABLE_CONFIRMATION_FCT )
    {
# if defined ( C_HL_ENABLE_DUMMY_FCT_CALL )
# else
      if ( CanGetApplConfirmationPtr(txHandle) != NULL )
# endif
      {
        (CanGetApplConfirmationPtr(txHandle))(txHandle);   /* call completion routine  */
      }
    }
#endif /* C_ENABLE_CONFIRMATION_FCT */

  } /* end if kCanBufferCancel */

#if defined( C_ENABLE_TRANSMIT_QUEUE )
# if defined( C_ENABLE_TX_FULLCAN_OBJECTS ) ||\
     defined( C_ENABLE_MSG_TRANSMIT )
  if (txObjHandle == CAN_HL_HW_TX_NORMAL_INDEX(canHwChannel))
# endif
  {
    CanSingleGlobalInterruptDisable();                /* ESCAN00008914 */
    if (canTxQueueCnt[channel] != 0)
    {
      CanSingleGlobalInterruptRestore();              /* ESCAN00008914 */
      /* Transmit Queued Objects ( instead of function CanTransmitQueuedObj() */
      /*look for obj ready to transmit*/
      for (i = (CanSignedTxHandle)CAN_HL_TX_STOPINDEX(channel) - (CanSignedTxHandle)1; i >= (CanSignedTxHandle)CAN_HL_TX_STARTINDEX(channel); i--)
      {
        if ((canTxQueueFlags[i]) != 0)
        {
          CanSingleGlobalInterruptDisable();
          if (canTxQueueCnt[channel] != 0) {
            canTxQueueFlags[i] = 0;        /* remove msg from queue */
            canTxQueueCnt[channel]--;
          }
          CanSingleGlobalInterruptRestore();
          canHandleCurTxObj[logTxObjHandle] = (CanTransmitHandle)i;/* Save hdl of msgObj to be transmitted*/
# if defined(C_ENABLE_CAN_CANCEL_NOTIFICATION)
          rc = CanCopyDataAndStartTransmission( CAN_CHANNEL_CANPARA_FIRST txObjHandle,(CanTransmitHandle)i);
          if ( rc == kCanTxNotify)
          {
            APPLCANCANCELNOTIFICATION(channel, (CanTransmitHandle)i);
          }
# else  /* C_ENABLE_CAN_CANCEL_NOTIFICATION */
          (void)CanCopyDataAndStartTransmission( CAN_CHANNEL_CANPARA_FIRST txObjHandle,(CanTransmitHandle)i);
# endif  /* C_ENABLE_CAN_CANCEL_NOTIFICATION */

          goto finishCanHL_TxConfirmation;
        }
      }
      CanSingleGlobalInterruptDisable();                /* ESCAN00008914 */
    }
    canHandleCurTxObj[logTxObjHandle] = kCanBufferFree;  /* free msg object if queue is empty */
    CanSingleGlobalInterruptRestore();                 /* ESCAN00008914 */
  }
#endif
  /* check for next msg object in queue and transmit it */

/* Msg(4:2015) This label is not a case or default label for a switch statement. MISRA Rule 55 */
finishCanHL_TxConfirmation:


  return;

} /* END OF CanTxInterrupt */
#if defined ( MISRA_CHECK )
# pragma PRQA_MESSAGES_ON 2006,2001,2015
#endif


#if defined( C_ENABLE_ECU_SWITCH_PASS )
/************************************************************************
* NAME:               CanSetActive
* CALLED BY:          application
* PRECONDITIONS:      none
* PARAMETER:          none or channel
* RETURN VALUE:       none
* DESCRIPTION:        Set the CAN driver into active mode
*************************************************************************/
C_API_1 void C_API_2 CanSetActive( CAN_CHANNEL_CANTYPE_ONLY )
{
  canPassive[channel] = 0;
} /* END OF CanSetActive */

/************************************************************************
* NAME:               CanSetPassive
* CALLED BY:          application
* PRECONDITIONS:      none
* PARAMETER:          none or channel
* RETURN VALUE:       none
* DESCRIPTION:        Set the can driver into passive mode
*************************************************************************/
C_API_1 void C_API_2 CanSetPassive( CAN_CHANNEL_CANTYPE_ONLY )
{
  canPassive[channel] = 1;

  #if defined( C_ENABLE_TRANSMIT_QUEUE )
  /* clear all Tx queue flags: */
  CanDelQueuedObj( CAN_CHANNEL_CANPARA_ONLY );
  #endif


} /* END OF CanSetPassive */
#endif /* IF defined( C_ENABLE_ECU_SWITCH_PASS ) */


#if defined ( C_ENABLE_OFFLINE )
/************************************************************************
* NAME:               CanOnline( CanChannelHandle channel )
* CALLED BY:          netmanagement
* PRECONDITIONS:      none
* PARAMETER:          none or channel
* RETURN VALUE:       none
* DESCRIPTION:        Switch on transmit path
*************************************************************************/
C_API_1 void C_API_2 CanOnline(CAN_CHANNEL_CANTYPE_ONLY)
{
  CanDeclareGlobalInterruptOldStatus

  CanSingleGlobalInterruptDisable();
  canStatus[channel] |= kCanTxOn;
  CanSingleGlobalInterruptRestore();
}


/************************************************************************
* NAME:               CanOffline( CanChannelHandle channel )
* CALLED BY:          netmanagement
* PRECONDITIONS:      none
* PARAMETER:          none or channel
* RETURN VALUE:       none
* DESCRIPTION:        Switch off transmit path
*************************************************************************/
C_API_1 void C_API_2 CanOffline(CAN_CHANNEL_CANTYPE_ONLY)
{
  CanDeclareGlobalInterruptOldStatus

  CanSingleGlobalInterruptDisable();
  canStatus[channel] &= kCanTxNotOn;
  CanSingleGlobalInterruptRestore();

#ifdef C_ENABLE_TRANSMIT_QUEUE
  CanDelQueuedObj( CAN_CHANNEL_CANPARA_ONLY );
#endif
}
#endif /* if defined ( C_ENABLE_OFFLINE ) */


#if defined ( C_ENABLE_PART_OFFLINE )
/************************************************************************
* NAME:               CanSetPartOffline
* CALLED BY:          application
* PRECONDITIONS:      none
* PARAMETER:          (channel), sendGroup
* RETURN VALUE:       none
* DESCRIPTION:        Switch partial off transmit path
*************************************************************************/
C_API_1 void C_API_2 CanSetPartOffline(CAN_CHANNEL_CANTYPE_FIRST canuint8 sendGroup)
{
  CanDeclareGlobalInterruptOldStatus

  CanSingleGlobalInterruptDisable();
  canTxPartOffline[channel] |= sendGroup;   /* set offlinestate and Save for use of CanOnline/CanOffline */
  CanSingleGlobalInterruptRestore();
}


/************************************************************************
* NAME:               CanSetPartOnline
* CALLED BY:          application
* PRECONDITIONS:      none
* PARAMETER:          (channel), invSendGroup
* RETURN VALUE:       none
* DESCRIPTION:        Switch partial on transmit path
*************************************************************************/
C_API_1 void C_API_2 CanSetPartOnline(CAN_CHANNEL_CANTYPE_FIRST canuint8 invSendGroup)
{
  CanDeclareGlobalInterruptOldStatus

  CanSingleGlobalInterruptDisable();
  canTxPartOffline[channel] &= invSendGroup;
  CanSingleGlobalInterruptRestore();
}


/************************************************************************
* NAME:               CanGetPartMode
* CALLED BY:          application
* PRECONDITIONS:      none
* PARAMETER:          none or channel
* RETURN VALUE:       canTxPartOffline
* DESCRIPTION:        return status of partoffline-Mode
*************************************************************************/
C_API_1 canuint8 C_API_2 CanGetPartMode(CAN_CHANNEL_CANTYPE_ONLY)
{
  return canTxPartOffline[channel];
}
#endif


/****************************************************************************
| NAME:             CanGetStatus
| CALLED BY:
| PRECONDITIONS:
| INPUT PARAMETERS: none or channel
| RETURN VALUES:    kCanTxOff
|                   kCanTxOn
| DESCRIPTION:      returns the status of the transmit path and the CAN hardware.
|                   Only one of the statusbits Sleep,Busoff,Passiv,Warning is set.
|                   Sleep has the highest priority, error warning the lowerst.
****************************************************************************/
#if defined ( MISRA_CHECK )
 /* suppress misra message about multiple return  */
# pragma PRQA_MESSAGES_OFF 2006
#endif
C_API_1 canuint8 C_API_2 CanGetStatus( CAN_CHANNEL_CANTYPE_ONLY )
{
#if defined( C_ENABLE_EXTENDED_STATUS )
#endif

#if defined ( C_ENABLE_MULTI_ECU_CONFIG )
  assertUser(( (CanChannelIdentityAssignment[channel] & V_ACTIVE_IDENTITY_MSK) != (tVIdentityMsk)0 ), channel, kErrorDisabledChannel);
#endif


#if defined( C_ENABLE_EXTENDED_STATUS )


  /***************************** verify Stop mode *************************************/
  if ( CanLL_HwIsStop(CAN_HW_CHANNEL_CANPARA_ONLY)    )  { return ( canStatus[channel] | kCanHwIsStop ); }

  /***************************** verify Busoff *************************************/
  if ( CanLL_HwIsBusOff(CAN_HW_CHANNEL_CANPARA_ONLY)  )  { return ( canStatus[channel] | kCanHwIsBusOff ); }

  /***************************** verify Error Passiv *******************************/
  {
    if ( CanLL_HwIsPassive(CAN_HW_CHANNEL_CANPARA_ONLY) )  { return ( canStatus[channel] | kCanHwIsPassive ); }
  }

  /***************************** verify Error Warning ******************************/
  {
    if ( CanLL_HwIsWarning(CAN_HW_CHANNEL_CANPARA_ONLY) )  { return ( canStatus[channel] | kCanHwIsWarning ); }
  }
#endif
  return (canStatus[channel] & kCanTxOn);

} /* END OF CanGetStatus */
#if defined ( MISRA_CHECK )
# pragma PRQA_MESSAGES_ON 2006
#endif


/****************************************************************************
| NAME:             CanSleep
| CALLED BY:
| PRECONDITIONS:
| INPUT PARAMETERS: none or channel
| RETURN VALUES:    kCanOk, if CanSleep was successfull
|                   kCanFailed, if function failed
|                   kCanNotSupported, if this function is not supported
| DESCRIPTION:      disable CAN
****************************************************************************/
C_API_1 canuint8 C_API_2 CanSleep(CAN_CHANNEL_CANTYPE_ONLY)
{

#if defined ( C_ENABLE_MULTI_ECU_CONFIG )
  assertUser(( (CanChannelIdentityAssignment[channel] & V_ACTIVE_IDENTITY_MSK) != (tVIdentityMsk)0 ), channel, kErrorDisabledChannel);
#endif

#if defined( C_ENABLE_COND_RECEIVE_FCT )
  /* this has to be done, even if SLEEP_WAKEUP is not enabled */
  canMsgCondRecState[channel] = kCanTrue;
#endif

# if defined ( C_MULTIPLE_RECEIVE_CHANNEL) && \
     defined( V_ENABLE_USE_DUMMY_STATEMENT )
  channel = channel;
# endif
  return kCanNotSupported;
} /* END OF CanSleep */

/****************************************************************************
| NAME:             CanWakeUp
| CALLED BY:
| PRECONDITIONS:
| INPUT PARAMETERS: none or channel
| RETURN VALUES:    kCanOk, if CanWakeUp was successfull
|                   kCanFailed, if function failed
|                   kCanNotSupported, if this function is not supported
| DESCRIPTION:      enable CAN
****************************************************************************/
C_API_1 canuint8 C_API_2 CanWakeUp( CAN_CHANNEL_CANTYPE_ONLY )
{
# if defined ( C_MULTIPLE_RECEIVE_CHANNEL) && \
     defined( V_ENABLE_USE_DUMMY_STATEMENT )
  channel = channel;
# endif
  return kCanNotSupported;
} /* END OF CanWakeUp */


#if defined ( C_ENABLE_STOP )
/****************************************************************************
| NAME:             CanStop
| CALLED BY:
| PRECONDITIONS:
| INPUT PARAMETERS: none
| RETURN VALUES:    kCanOk, if success
|                   kCanFailed, if function failed
|                   kCanNotSupported, if this function is not supported
| DESCRIPTION:      stop CAN-controller
****************************************************************************/
C_API_1 canuint8 C_API_2 CanStop( CAN_CHANNEL_CANTYPE_ONLY )
{
  canuint8         canReturnCode;

#if defined ( C_ENABLE_MULTI_ECU_CONFIG )
  assertUser(( (CanChannelIdentityAssignment[channel] & V_ACTIVE_IDENTITY_MSK) != (tVIdentityMsk)0 ), channel, kErrorDisabledChannel);
#endif

  {
    /* ESCAN00007150, ESCAN00009086 - Transmit Abort */
    canuint8 obj;
    for(obj = 0; obj < CAN_HL_HW_TX_STOPINDEX(channel); obj++)
    {
      if((CAN_BASE_ADR(channel)->mslcnt[obj] & 0x81) == 0x80)
      {
        /* abort only if msg slot is in transmit mode and sending is not completed */
        CAN_BASE_ADR(channel)->mslcnt[obj] = kTA;
      }
    }

    /* request CAN controller to enter reset state */
    CAN_BASE_ADR(channel)->cnt |= kRST;

    #if defined ( C_ENABLE_HW_LOOP_TIMER )
    /* start hw loop timer before entering while loop for hardware handshake */
    ApplCanTimerStart(kCanLoopResetSet);
    #endif

    /* wait until CAN controller is in reset state */
    while ((CAN_BASE_ADR(channel)->stat & kCRS) != kCRS) {
      #if defined ( C_ENABLE_HW_LOOP_TIMER )
      if(!ApplCanTimerLoop(kCanLoopResetSet))
      {
        /* stop loop if application indicates it wants to */
        break;
      }
      #endif
    }

    #if defined ( C_ENABLE_HW_LOOP_TIMER )
    /* stop hw loop timer because loop no longer active */
    ApplCanTimerEnd(kCanLoopResetSet);

    /* application could have cancelled the loop using the hw loop timer feature
     * therefor check if CAN controller is actually in reset state when the hw
     * loop timer feature is enabled.
     */
    if ((CAN_BASE_ADR(channel)->stat & kCRS) != kCRS)
    {
      canReturnCode = kCanFailed;                  /* CAN controller not in reset state */
    }
    else
    #endif /* C_ENABLE_HW_LOOP_TIMER */
    {
      /* when we get here, then the CAN controller is in reset state */
      canReturnCode = kCanOk;        /* CAN controller in reset state */
    }
  }
  return canReturnCode;
}

/****************************************************************************
| NAME:             CanStart
| CALLED BY:
| PRECONDITIONS:
| INPUT PARAMETERS: none
| RETURN VALUES:    kCanOk, if success
|                   kCanFailed, if function failed
|                   kCanNotSupported, if this function is not supported
| DESCRIPTION:      restart CAN-controller
****************************************************************************/
C_API_1 canuint8 C_API_2 CanStart( CAN_CHANNEL_CANTYPE_ONLY )
{
  canuint8         canReturnCode;

#if defined ( C_ENABLE_MULTI_ECU_CONFIG )
  assertUser(( (CanChannelIdentityAssignment[channel] & V_ACTIVE_IDENTITY_MSK) != (tVIdentityMsk)0 ), channel, kErrorDisabledChannel);
#endif

  {
    /* request to leave reset mode and synchronize with the CAN bus */
    /* clear CAN reset and forcible reset bits */
    CAN_BASE_ADR(channel)->cnt &= (canuint16)~(kRST|kFRST);

    #if defined ( C_ENABLE_HW_LOOP_TIMER )
    /* start hw loop timer before entering while loop for hardware handshake */
    ApplCanTimerStart(kCanLoopResetUnSet);
    #endif

    /* wait until CAN controller is out of reset state */
    while ((CAN_BASE_ADR(channel)->stat & kCRS) == kCRS) {
      #if defined ( C_ENABLE_HW_LOOP_TIMER )
      if(!ApplCanTimerLoop(kCanLoopResetUnSet))
      {
        /* stop loop if application indicates it wants to */
        break;
      }
      #endif
    }

    #if defined ( C_ENABLE_HW_LOOP_TIMER )
    /* stop hw loop timer because loop no longer active */
    ApplCanTimerEnd(kCanLoopResetUnSet);

    /* application could have cancelled the loop using the hw loop timer feature
     * therefor check if CAN controller is actually out of reset state when the
     * hw loop timer feature is enabled.
     */
    if ((CAN_BASE_ADR(channel)->stat & kCRS) == kCRS)
    {
      canReturnCode = kCanFailed;  /* CAN controller still in reset state */
    }
    else
    #endif
    {
      /* when we get here, then the CAN controller is out of reset state */
      canReturnCode = kCanOk; /* CAN controller synchronized to CAN bus */
    }
  }
  return canReturnCode;
}
#endif /* if defined ( C_ENABLE_STOP ) */


/****************************************************************************
| NAME:             CanGlobalInterruptDisable
| CALLED BY:
| PRECONDITIONS:
| INPUT PARAMETERS: none
| RETURN VALUES:    none
| DESCRIPTION:      disables global interrupts and stores old interrupt status
****************************************************************************/
C_API_1 void C_API_2 CanGlobalInterruptDisable(void) C_API_3
{
#if defined( C_ENABLE_INTCTRL_BY_APPL )
#else
  CanDeclareGlobalInterruptOldStatus
#endif

  /* local variable must reside on stack or registerbank, switched */
  /* in interrupt level                                            */
  /* disable global interrupt                                      */
  assertUser(canGlobalInterruptCounter<(cansint8)0x7f, kCanAllChannels, kErrorIntDisableTooOften);

  if (canGlobalInterruptCounter == (cansint8)0)  /* if 0 then save old interrupt status */
  {
#if defined( C_ENABLE_INTCTRL_BY_APPL )
    ApplCanInterruptDisable();
#else
    CanNestedGlobalInterruptDisable();
    CanGetGlobalInterruptOldStatus( canInterruptOldStatus );            /*lint !e530 */
#endif
  }

  canGlobalInterruptCounter++;               /* common for all platforms */

} /* END OF CanGlobalInterruptDisable */

/****************************************************************************
| NAME:             CanGlobalInterruptRestore
| CALLED BY:
| PRECONDITIONS:
| INPUT PARAMETERS: none
| RETURN VALUES:    none
| DESCRIPTION:      restores the old interrupt status if canGlobalInterruptCounter is zero
****************************************************************************/
C_API_1 void C_API_2 CanGlobalInterruptRestore(void)  C_API_3
{
# if defined( C_ENABLE_INTCTRL_BY_APPL )
# else
  CanDeclareGlobalInterruptOldStatus
# endif
  assertUser(canGlobalInterruptCounter>(cansint8)0, kCanAllChannels, kErrorIntRestoreTooOften);

  /* restore global interrupt */
  canGlobalInterruptCounter--;

  if (canGlobalInterruptCounter == (cansint8)0)         /* restore interrupt if canGlobalInterruptCounter=0 */
  {
#if defined( C_ENABLE_INTCTRL_BY_APPL )
    ApplCanInterruptRestore();
#else
    CanPutGlobalInterruptOldStatus( canInterruptOldStatus );
    CanNestedGlobalInterruptRestore();
#endif
  }

} /* END OF CanGlobalInterruptRestore */

/****************************************************************************
| NAME:             CanCanInterruptDisable
| CALLED BY:
| PRECONDITIONS:
| INPUT PARAMETERS: none
| RETURN VALUES:    none
| DESCRIPTION:      disables CAN interrupts and stores old interrupt status
****************************************************************************/
C_API_1 void C_API_2 CanCanInterruptDisable( CAN_CHANNEL_CANTYPE_ONLY )
{
  CanDeclareGlobalInterruptOldStatus
#if defined(C_HL_ENABLE_CAN_IRQ_DISABLE)
  tCanLLCanIntOld localInterruptOldFlag;
#endif

  /* local variable must reside on stack or registerbank, switched */
  /* in interrupt level                                            */
  /* disable global interrupt                                      */
#if defined ( C_MULTIPLE_RECEIVE_CHANNEL )
  assertUser(channel < kCanNumberOfChannels, kCanAllChannels, kErrorChannelHdlTooLarge);
#endif
  assertUser(canCanInterruptCounter[channel]<(cansint8)0x7f, kCanAllChannels, kErrorIntDisableTooOften);
#if defined ( C_ENABLE_MULTI_ECU_CONFIG )
  assertUser(( (CanChannelIdentityAssignment[channel] & V_ACTIVE_IDENTITY_MSK) != (tVIdentityMsk)0 ), channel, kErrorDisabledChannel);
#endif

  CanNestedGlobalInterruptDisable();
  if (canCanInterruptCounter[channel] == (CANSINTX)0)  /* if 0 then save old interrupt status */
  {
#if defined(C_HL_ENABLE_CAN_IRQ_DISABLE)
    {
      CanLL_CanInterruptDisable(canHwChannel, &localInterruptOldFlag);
      canCanInterruptOldStatus[canHwChannel] = localInterruptOldFlag;            /*lint !e530 */
    }
#endif
#if defined( C_ENABLE_INTCTRL_ADD_CAN_FCT )
    ApplCanAddCanInterruptDisable(channel);
#endif
  }
  canCanInterruptCounter[channel]++;               /* common for all platforms */

  CanNestedGlobalInterruptRestore();

} /* END OF CanCanInterruptDisable */

/****************************************************************************
| NAME:             CanCanInterruptRestore
| CALLED BY:
| PRECONDITIONS:
| INPUT PARAMETERS: none
| RETURN VALUES:    none
| DESCRIPTION:      restores the old interrupt status of the CAN interrupt if
|                   canCanInterruptCounter[channel] is zero
****************************************************************************/
C_API_1 void C_API_2 CanCanInterruptRestore( CAN_CHANNEL_CANTYPE_ONLY )
{
  CanDeclareGlobalInterruptOldStatus
#if defined ( C_MULTIPLE_RECEIVE_CHANNEL )
  assertUser(channel < kCanNumberOfChannels, kCanAllChannels, kErrorChannelHdlTooLarge);
#endif
  assertUser(canCanInterruptCounter[channel]>(CANSINTX)0, kCanAllChannels, kErrorIntRestoreTooOften);
#if defined ( C_ENABLE_MULTI_ECU_CONFIG )
  assertUser(( (CanChannelIdentityAssignment[channel] & V_ACTIVE_IDENTITY_MSK) != (tVIdentityMsk)0 ), channel, kErrorDisabledChannel);
#endif

  CanNestedGlobalInterruptDisable();
  /* restore CAN interrupt */
  canCanInterruptCounter[channel]--;

  if (canCanInterruptCounter[channel] == (CANSINTX)0)         /* restore interrupt if canGlobalInterruptCounter=0 */
  {
#if defined(C_HL_ENABLE_CAN_IRQ_DISABLE)
    {
      CanLL_CanInterruptRestore(canHwChannel, canCanInterruptOldStatus[canHwChannel]);
    }
#endif

#if defined( C_ENABLE_INTCTRL_ADD_CAN_FCT )
    ApplCanAddCanInterruptRestore(channel);
#endif
  }
  CanNestedGlobalInterruptRestore();
} /* END OF CanCanInterruptRestore */

#ifdef C_ENABLE_MSG_TRANSMIT
/************************************************************************
* NAME:               CanMsgTransmit
* CALLED BY:          CanReceivedFunction
* PRECONDITIONS:      Called in Receive Interrupt
* PARAMETER:          Pointer to message buffer data block; This can either be
*                     a RAM structure data block or the receive buffer in the
*                     CAN chip
* RETURN VALUE:       The return value says that a transmit request was successful
*                     or not
* DESCRIPTION:        Transmit functions for gateway issues (with dynamic
*                     messages). If the transmit buffer is not free, the message
*                     is inserted in the FIFO ring buffer.
*************************************************************************/
# if defined ( MISRA_CHECK )
  /* suppress misra message about multiple return  */
#  pragma PRQA_MESSAGES_OFF 2006,2015
# endif
/* Msg(4:3673) The object addressed by the pointer "txMsgStruct" is not modified in this function.
   The use of "const" should be considered to indicate that it never changes. MISRA Rule 81 - no change */
C_API_1 canuint8 C_API_2 CanMsgTransmit( CAN_CHANNEL_CANTYPE_FIRST tCanMsgTransmitStruct *txMsgStruct )
{
  CanDeclareGlobalInterruptOldStatus
  canuint8                 rc;
  CanObjectHandle          txObjHandle;
  CanObjectHandle          logTxObjHandle;

  /* counter to copy the message data byte for byte to the CAN message slot */
  canuint8  txCopyCnt;

#if defined ( C_ENABLE_MULTI_ECU_CONFIG )
  assertUser(( (CanChannelIdentityAssignment[channel] & V_ACTIVE_IDENTITY_MSK) != (tVIdentityMsk)0 ), channel, kErrorDisabledChannel);
#endif


  CanNestedGlobalInterruptDisable();

  /* --- test on CAN transmit switch --- */
  if ( (canStatus[channel] & kCanTxOn) == kCanTxOff )                /* transmit path switched off */
  {
    CanNestedGlobalInterruptRestore();
    return kCanTxFailed;
  }

#if defined(C_ENABLE_CAN_RAM_CHECK)
  if(canComStatus[channel] == kCanDisableCommunication)
  {
    CanNestedGlobalInterruptRestore();
    return(kCanCommunicationDisabled);
  }
#endif

  assertInternal((canStatus[channel] & kCanHwIsStop) != kCanHwIsStop, channel, kErrorCanStop);

  /* --- check on passive state --- */
  #if defined( C_ENABLE_ECU_SWITCH_PASS )
  if ( canPassive[channel] != 0)                             /*  set passive ? */
  {
    CanNestedGlobalInterruptRestore();
    #if defined( C_ENABLE_MSG_TRANSMIT_CONF_FCT )
    ApplCanMsgTransmitConf( CAN_CHANNEL_CANPARA_ONLY );
    #endif
    return (kCanTxOk);
  }
  #endif /* C_ENABLE_ECU_SWITCH_PASS */

  /* calculate index for canhandleCurTxObj (logical object handle) */
  logTxObjHandle = (CanObjectHandle)((vsintx)CAN_HL_HW_MSG_TRANSMIT_INDEX(canHwChannel) + CAN_HL_TX_OFFSET_HW_TO_LOG(canHwChannel));

  /* check for transmit message object free ---------------------------------*/
  /* MsgObj used?  */
  if (( canHandleCurTxObj[logTxObjHandle] != kCanBufferFree ))
  {
    CanNestedGlobalInterruptRestore();
    return kCanTxFailed;
  }

  /* Obj, pMsgObject points to is free, transmit msg object: ----------------*/
  /* Save hdl of msgObj to be transmitted*/
  canHandleCurTxObj[logTxObjHandle] = kCanBufferMsgTransmit;
  CanNestedGlobalInterruptRestore();


  #if defined ( C_HL_ENABLE_HW_EXIT_TRANSMIT )
    /* Free object again */
    canHandleCurTxObj[logTxObjHandle] = kCanBufferFree;
    return kCanTxFailed;
  }
  #endif

  assertHardware( CanLL_TxIsHWObjFree(canHwChannel, CAN_HL_HW_MSG_TRANSMIT_INDEX(canHwChannel) ), channel, kErrorTxBufferBusy);

  txObjHandle = CAN_HL_HW_MSG_TRANSMIT_INDEX(canHwChannel);

  CanNestedGlobalInterruptDisable();
  /* Copy all data into transmit object */


  /* If CanTransmit was interrupted by a re-initialization or CanOffline */
  /* no transmitrequest of this action should be started      */
  if ((canHandleCurTxObj[logTxObjHandle] == kCanBufferMsgTransmit) &&
                                   ( (canStatus[channel] & kCanTxOn) != kCanTxOff ) )
  {
     /* copy id to tx message slot */
     *((canuint16*) &(CAN_BASE_ADR(channel)->msl[txObjHandle].stdId0)) = txMsgStruct->IdRaw;
     #if defined ( C_ENABLE_EXTENDED_ID )
     *((canuint16*) &(CAN_BASE_ADR(channel)->msl[txObjHandle].extId0)) = txMsgStruct->IdRawExt;
     CAN_BASE_ADR(channel)->msl[txObjHandle].extId2 = txMsgStruct->IdRawExtLo;
     #endif

     /* copy dlc to tx message slot */
     CAN_BASE_ADR(channel)->msl[txObjHandle].dlc = txMsgStruct->DlcRaw;

     /* copy 8 bytes from RAM buffer to CAN message slot. larger than 8-bit acces-
      * ses to the message slot data field are not allowed.
      */
     for (txCopyCnt=0; txCopyCnt<8; txCopyCnt++)
     {
       CAN_BASE_ADR(channel)->msl[txObjHandle].data[txCopyCnt] = txMsgStruct->DataFld[txCopyCnt];
     }

     #if defined ( C_ENABLE_EXTENDED_ID )
     # if defined ( C_ENABLE_MIXED_ID )
     /* configure tx msg slot for either standard or extended id's */
     if (txMsgStruct->IdType == kCanIdTypeExt)
     {
       CAN_BASE_ADR(channel)->extid |= msgSlotBitmask[txObjHandle];
     }
     else
     {
       CAN_BASE_ADR(channel)->extid &= ~msgSlotBitmask[txObjHandle];
     }
     # else
     /* extended id message */
     CAN_BASE_ADR(channel)->extid |= msgSlotBitmask[txObjHandle];
     # endif /* C_ENABLE_MIXED_ID */
     #else
     /* standard id message */
     CAN_BASE_ADR(channel)->extid &= ~msgSlotBitmask[txObjHandle];
     #endif /* C_ENABLE_EXTENDED_ID */

     CAN_BASE_ADR(channel)->mslcnt[txObjHandle] |= kTR;     /* request start of tx  */

     #if defined( C_ENABLE_TX_OBSERVE )
     ApplCanTxObjStart( CAN_CHANNEL_CANPARA_FIRST logTxObjHandle );
     #endif

     rc = kCanTxOk;
  }
  else
  {
    /* release TxHandle (CanOffline) */
    canHandleCurTxObj[logTxObjHandle] = kCanBufferFree;
    rc = kCanTxFailed;
  }

  CanNestedGlobalInterruptRestore();


  return rc;
} /*end of CanMsgTransmit() */
# if defined ( MISRA_CHECK )
#  pragma PRQA_MESSAGES_ON 2006,2015
# endif
#endif


#if defined( C_ENABLE_DYN_TX_OBJECTS )
/************************************************************************
* NAME:           CanGetDynTxObj
* PARAMETER:      txHandle - Handle of the dynamic object to reserve
* RETURN VALUE:   kCanNoTxDynObjAvailable (0xFF) -
*                   object not available
*                 0..F0 -
*                   Handle to dynamic transmission object
* DESCRIPTION:    Function reserves and return a handle to a dynamic
*                   transmission object
*
*                 To use dynamic transmission, an application must get
*                 a dynamic object from CAN-driver.
*                 Before transmission, application must set all attributes
*                 (id, dlc, data, confirmation function/flag, pretransmission
*                 etc. - as configurated).
*                 Application can use a dynamic object for one or many
*                 transmissions (as it likes) - but finally, it must
*                 release the dynamic object by calling CanReleaseDynTxObj.
*************************************************************************/
# if defined ( MISRA_CHECK )
  /* suppress misra message about multiple return  */
#  pragma PRQA_MESSAGES_OFF 2006
# endif
C_API_1 CanTransmitHandle C_API_2 CanGetDynTxObj(CanTransmitHandle txHandle )
{
  CanTransmitHandle nTxDynObj;
  CanDeclareGlobalInterruptOldStatus
  CAN_CHANNEL_CANTYPE_LOCAL

  assertUser((txHandle < kCanNumberOfTxObjects), kCanAllChannels, kErrorTxHdlTooLarge);

  #if defined ( C_MULTIPLE_RECEIVE_CHANNEL)
  channel = CanGetChannelOfTxObj(txHandle);
  #endif

  assertUser((txHandle <  CAN_HL_TX_DYN_ROM_STOPINDEX(channel)), channel, kErrorAccessedInvalidDynObj);
  assertUser((txHandle >= CAN_HL_TX_DYN_ROM_STARTINDEX(channel)), channel, kErrorAccessedStatObjAsDyn);

  nTxDynObj = txHandle - CAN_HL_TX_DYN_ROM_STARTINDEX(channel) + CAN_HL_TX_DYN_RAM_STARTINDEX(channel);

  CanSingleGlobalInterruptDisable();
  if ( canTxDynObjReservedFlag[nTxDynObj] != 0)
  {
    CanSingleGlobalInterruptRestore();
    return kCanNoTxDynObjAvailable;
  }
  /*  Mark dynamic object as used  */
  canTxDynObjReservedFlag[nTxDynObj] = 1;

  #if defined( C_ENABLE_CONFIRMATION_FLAG )
  CanConfirmationFlags._c[CanGetConfirmationOffset(txHandle)] &=
                            (canuint8)(~CanGetConfirmationMask(txHandle));
  #endif
  CanSingleGlobalInterruptRestore();

  /* Initialize dynamic object */
  #if defined(  C_ENABLE_DYN_TX_DATAPTR )
  canDynTxDataPtr[nTxDynObj] = NULL;
  #endif


  return (txHandle);
}
# if defined ( MISRA_CHECK )
#  pragma PRQA_MESSAGES_ON 2006
# endif

/************************************************************************
* NAME:           CanReleaseDynTxObj
* PARAMETER:      hTxObj -
*                   Handle of dynamic transmission object
* RETURN VALUE:   --
* DESCRIPTION:    Function releases dynamic transmission object
*                   which was reserved before (calling CanGetDynTxObj)
*
*                 After a transmission of one or more messages is finished,
*                 application must free the reserved resource, formally the
*                 dynamic transmission object calling this function.
*
*                 As the number of dynamic transmission object is limited,
*                 application should not keep unused dynamic transmission
*                 objects for a longer time.
*************************************************************************/
# if defined ( MISRA_CHECK )
  /* suppress misra message about multiple return  */
#  pragma PRQA_MESSAGES_OFF 2006
# endif
C_API_1 canuint8 C_API_2 CanReleaseDynTxObj(CanTransmitHandle txHandle)
{
  CanTransmitHandle dynTxObj;
  CAN_CHANNEL_CANTYPE_LOCAL

  assertUser((txHandle < kCanNumberOfTxObjects), kCanAllChannels, kErrorTxHdlTooLarge);

  #if defined ( C_MULTIPLE_RECEIVE_CHANNEL)
  channel = CanGetChannelOfTxObj(txHandle);
  #endif

  assertUser((txHandle <  CAN_HL_TX_DYN_ROM_STOPINDEX(channel)), channel, kErrorAccessedInvalidDynObj);
  assertUser((txHandle >= CAN_HL_TX_DYN_ROM_STARTINDEX(channel)), channel, kErrorAccessedStatObjAsDyn);

  dynTxObj = txHandle - CAN_HL_TX_DYN_ROM_STARTINDEX(channel) + CAN_HL_TX_DYN_RAM_STARTINDEX(channel);

  assertInternal((canTxDynObjReservedFlag[dynTxObj] != 0), channel, kErrorReleasedUnusedDynObj);

#if defined( C_ENABLE_TRANSMIT_QUEUE )
  if ((canTxQueueFlags[txHandle]) == 0)      /*lint !e661 !e662*/
#endif
  {
    if (
#if defined( C_ENABLE_CONFIRMATION_FCT ) && \
    defined( C_ENABLE_TRANSMIT_QUEUE )
         (confirmHandle[channel] == txHandle) ||       /* confirmation active ? */
#endif
         (canHandleCurTxObj[CAN_HL_HW_TX_NORMAL_INDEX(canHwChannel) + CAN_HL_TX_OFFSET_HW_TO_LOG(canHwChannel)] != txHandle) )
    {
      /*  Mark dynamic object as not used  */
      canTxDynObjReservedFlag[dynTxObj] = 0;
      return(kCanDynReleased);
    }
  }
  return(kCanDynNotReleased);
}
# if defined ( MISRA_CHECK )
#  pragma PRQA_MESSAGES_ON 2006
# endif
#endif /* C_ENABLE_DYN_TX_OBJECTS */


#if defined( C_ENABLE_DYN_TX_ID )
# if !defined( C_ENABLE_EXTENDED_ID ) ||\
     defined ( C_ENABLE_MIXED_ID )
/************************************************************************
* NAME:           CanDynTxObjSetId
* PARAMETER:      hTxObj -
*                   Handle of dynamic transmission object
*                 id -
*                   Id (standard-format) to register with dynamic object
* RETURN VALUE:   --
* DESCRIPTION:    Function registers submitted id (standard format)
*                 with dynamic object referenced by handle.
*************************************************************************/
C_API_1 void C_API_2 CanDynTxObjSetId(CanTransmitHandle txHandle, canuint16 id)
{
  CanTransmitHandle dynTxObj;

  CAN_CHANNEL_CANTYPE_LOCAL

  assertUser((txHandle < kCanNumberOfTxObjects), kCanAllChannels, kErrorTxHdlTooLarge);

#  if defined ( C_MULTIPLE_RECEIVE_CHANNEL)
  channel = CanGetChannelOfTxObj(txHandle);
#  endif

  assertUser((txHandle <  CAN_HL_TX_DYN_ROM_STOPINDEX(channel)), channel, kErrorAccessedInvalidDynObj);
  assertUser((txHandle >= CAN_HL_TX_DYN_ROM_STARTINDEX(channel)), channel, kErrorAccessedStatObjAsDyn);

  dynTxObj = txHandle - CAN_HL_TX_DYN_ROM_STARTINDEX(channel) + CAN_HL_TX_DYN_RAM_STARTINDEX(channel);

#  if defined( C_ENABLE_MIXED_ID )
#   if defined( C_HL_ENABLE_IDTYPE_IN_ID )
#   else
  canDynTxIdType[dynTxObj]  = kCanIdTypeStd;
#   endif
#  endif

  canDynTxId0[dynTxObj] = MK_STDID0(id);
#  if (kCanNumberOfUsedCanTxIdTables > 1)
  canDynTxId1[dynTxObj] = MK_STDID1(id);
#  endif
#  if (kCanNumberOfUsedCanTxIdTables > 2)
  canDynTxId2[dynTxObj] = MK_STDID2(id);
#  endif
#  if (kCanNumberOfUsedCanTxIdTables > 3)
  canDynTxId3[dynTxObj] = MK_STDID3(id);
#  endif
#  if (kCanNumberOfUsedCanTxIdTables > 4)
  canDynTxId4[dynTxObj] = MK_STDID4(id);
#  endif
}
# endif /* !defined( C_ENABLE_EXTENDED_ID ) || defined ( C_ENABLE_MIXED_ID ) */
#endif /* C_ENABLE_DYN_TX_ID */

#if defined( C_ENABLE_DYN_TX_ID ) && \
    defined( C_ENABLE_EXTENDED_ID )
/************************************************************************
* NAME:           CanDynTxObjSetExtId
* PARAMETER:      hTxObj -  Handle of dynamic transmission object
*                 idExtHi - Id low word (extended-format) to register with
*                                                         dynamic object
*                 idExtLo - Id high word (extended-format)
* RETURN VALUE:   --
* DESCRIPTION:    Function registers submitted id (standard format)
*                 with dynamic object referenced by handle.
*************************************************************************/
C_API_1 void C_API_2 CanDynTxObjSetExtId(CanTransmitHandle txHandle, canuint16 idExtHi, canuint16 idExtLo)
{
  CanTransmitHandle dynTxObj;
  CAN_CHANNEL_CANTYPE_LOCAL

  assertUser((txHandle < kCanNumberOfTxObjects), kCanAllChannels, kErrorTxHdlTooLarge);

# if defined ( C_MULTIPLE_RECEIVE_CHANNEL)
  channel = CanGetChannelOfTxObj(txHandle);
# endif

  assertUser((txHandle <  CAN_HL_TX_DYN_ROM_STOPINDEX(channel)), channel, kErrorAccessedInvalidDynObj);
  assertUser((txHandle >= CAN_HL_TX_DYN_ROM_STARTINDEX(channel)), channel, kErrorAccessedStatObjAsDyn);

  dynTxObj = txHandle - CAN_HL_TX_DYN_ROM_STARTINDEX(channel) + CAN_HL_TX_DYN_RAM_STARTINDEX(channel);

# if defined( C_ENABLE_MIXED_ID )
#  if defined( C_HL_ENABLE_IDTYPE_IN_ID )
#  else
  canDynTxIdType[dynTxObj] = kCanIdTypeExt;
#  endif
# endif

  canDynTxId0[dynTxObj]      = MK_EXTID0( ((canuint32)idExtHi<<16) | idExtLo );
# if (kCanNumberOfUsedCanTxIdTables > 1)
  canDynTxId1[dynTxObj]      = MK_EXTID1( ((canuint32)idExtHi<<16) | idExtLo );
# endif
# if (kCanNumberOfUsedCanTxIdTables > 2)
  canDynTxId2[dynTxObj]      = MK_EXTID2( ((canuint32)idExtHi<<16) | idExtLo );
# endif
# if (kCanNumberOfUsedCanTxIdTables > 3)
  canDynTxId3[dynTxObj]      = MK_EXTID3( ((canuint32)idExtHi<<16) | idExtLo );
# endif
# if (kCanNumberOfUsedCanTxIdTables > 4)
  canDynTxId4[dynTxObj]      = MK_EXTID4( ((canuint32)idExtHi<<16) | idExtLo );
# endif
}
#endif


#if defined( C_ENABLE_DYN_TX_DLC )
/************************************************************************
* NAME:           CanDynTxObjSetDlc
* PARAMETER:      hTxObj -
*                   Handle of dynamic transmission object
*                 dlc -
*                   data length code to register with dynamic object
* RETURN VALUE:   --
* DESCRIPTION:    Function registers data length code with
*                 dynamic object referenced by submitted handle.
*************************************************************************/
C_API_1 void C_API_2 CanDynTxObjSetDlc(CanTransmitHandle txHandle, canuint8 dlc)
{
  CanTransmitHandle dynTxObj;
  CAN_CHANNEL_CANTYPE_LOCAL

  assertUser((txHandle < kCanNumberOfTxObjects), kCanAllChannels, kErrorTxHdlTooLarge);

# if defined ( C_MULTIPLE_RECEIVE_CHANNEL)
  channel = CanGetChannelOfTxObj(txHandle);
# endif

  assertUser((txHandle <  CAN_HL_TX_DYN_ROM_STOPINDEX(channel)), channel, kErrorAccessedInvalidDynObj);
  assertUser((txHandle >= CAN_HL_TX_DYN_ROM_STARTINDEX(channel)), channel, kErrorAccessedStatObjAsDyn);

  dynTxObj = txHandle - CAN_HL_TX_DYN_ROM_STARTINDEX(channel) + CAN_HL_TX_DYN_RAM_STARTINDEX(channel);

# if defined(C_ENABLE_EXTENDED_ID)
  canDynTxDLC[dynTxObj] = MK_TX_DLC_EXT(dlc);
# else
  canDynTxDLC[dynTxObj] = MK_TX_DLC(dlc);
# endif
}

#endif /* C_ENABLE_DYN_TX_DLC */


#if defined( C_ENABLE_DYN_TX_DATAPTR )
/************************************************************************
* NAME:           CanDynTxObjSetData
* PARAMETER:      hTxObj -
*                   Handle of dynamic transmission object
*                 pData -
*                   data reference to be stored in data buffer of dynamic object
* RETURN VALUE:   --
* DESCRIPTION:    Functions stores reference to data registered with
*                 dynamic object.
*
*                 The number of byte copied is (always) 8. The number of
*                 relevant (and consequently evaluated) byte is to be
*                 taken from function CanDynObjGetDLC.
*************************************************************************/
C_API_1 void C_API_2 CanDynTxObjSetDataPtr(CanTransmitHandle txHandle, void* pData)
{
  CanTransmitHandle dynTxObj;
  CAN_CHANNEL_CANTYPE_LOCAL

  assertUser((txHandle < kCanNumberOfTxObjects), kCanAllChannels, kErrorTxHdlTooLarge);

  #if defined ( C_MULTIPLE_RECEIVE_CHANNEL)
  channel = CanGetChannelOfTxObj(txHandle);
  #endif

  assertUser((txHandle <  CAN_HL_TX_DYN_ROM_STOPINDEX(channel)), channel, kErrorAccessedInvalidDynObj);
  assertUser((txHandle >= CAN_HL_TX_DYN_ROM_STARTINDEX(channel)), channel, kErrorAccessedStatObjAsDyn);

  dynTxObj = txHandle - CAN_HL_TX_DYN_ROM_STARTINDEX(channel) + CAN_HL_TX_DYN_RAM_STARTINDEX(channel);

  canDynTxDataPtr[dynTxObj] = pData;
}

#endif /* C_ENABLE_DYN_TX_DATAPTR */





#if defined (C_ENABLE_TX_MASK_EXT_ID)
/************************************************************************
* NAME:               CanSetTxIdExtHi
* CALLED BY:
* PRECONDITIONS:      CanInitPower should already been called.
* PARAMETER:          new source address for the 29-bit CAN-ID
* RETURN VALUE:       -
* DESCRIPTION:        Sets the source address in the lower 8 bit of the
*                     29-bit CAN identifier.
*************************************************************************/
C_API_1 void C_API_2 CanSetTxIdExtHi( CAN_CHANNEL_CANTYPE_FIRST  canuint8 mask )
{
  canTxMask0[channel] = (canTxMask0[channel] & MK_EXTID0(0x00FFFFFFUL)) | MK_EXTID0((canuint32)mask<<24);
  #if (kCanNumberOfUsedCanTxIdTables > 1)
  canTxMask1[channel] = (canTxMask1[channel] & MK_EXTID1(0x00FFFFFFUL)) | MK_EXTID1((canuint32)mask<<24);
  #endif
  #if (kCanNumberOfUsedCanTxIdTables > 2)
  canTxMask2[channel] = (canTxMask2[channel] & MK_EXTID2(0x00FFFFFFUL)) | MK_EXTID2((canuint32)mask<<24);
  #endif
  #if (kCanNumberOfUsedCanTxIdTables > 3)
  canTxMask3[channel] = (canTxMask3[channel] & MK_EXTID3(0x00FFFFFFUL)) | MK_EXTID3((canuint32)mask<<24);
  #endif
  #if (kCanNumberOfUsedCanTxIdTables > 4)
  canTxMask4[channel] = (canTxMask4[channel] & MK_EXTID4(0x00FFFFFFUL)) | MK_EXTID4((canuint32)mask<<24);
  #endif
}

/************************************************************************
* NAME:               CanSetTxIdExtMidHi
* CALLED BY:
* PRECONDITIONS:      CanInitPower should already been called.
* PARAMETER:          new source address for the 29-bit CAN-ID
* RETURN VALUE:       -
* DESCRIPTION:        Sets the source address in the lower 8 bit of the
*                     29-bit CAN identifier.
*************************************************************************/
C_API_1 void C_API_2 CanSetTxIdExtMidHi( CAN_CHANNEL_CANTYPE_FIRST  canuint8 mask )
{
  canTxMask0[channel] = (canTxMask0[channel] & MK_EXTID0(0xFF00FFFFUL)) | MK_EXTID0((canuint32)mask<<16);   /*lint !e572*/
  #if (kCanNumberOfUsedCanTxIdTables > 1)
  canTxMask1[channel] = (canTxMask1[channel] & MK_EXTID1(0xFF00FFFFUL)) | MK_EXTID1((canuint32)mask<<16);   /*lint !e572*/
  #endif
  #if (kCanNumberOfUsedCanTxIdTables > 2)
  canTxMask2[channel] = (canTxMask2[channel] & MK_EXTID2(0xFF00FFFFUL)) | MK_EXTID2((canuint32)mask<<16);   /*lint !e572*/
  #endif
  #if (kCanNumberOfUsedCanTxIdTables > 3)
  canTxMask3[channel] = (canTxMask3[channel] & MK_EXTID3(0xFF00FFFFUL)) | MK_EXTID3((canuint32)mask<<16);   /*lint !e572*/
  #endif
  #if (kCanNumberOfUsedCanTxIdTables > 4)
  canTxMask4[channel] = (canTxMask4[channel] & MK_EXTID4(0xFF00FFFFUL)) | MK_EXTID4((canuint32)mask<<16);   /*lint !e572*/
  #endif
}

/************************************************************************
* NAME:               CanSetTxIdExtMidLo
* CALLED BY:
* PRECONDITIONS:      CanInitPower should already been called.
* PARAMETER:          new source address for the 29-bit CAN-ID
* RETURN VALUE:       -
* DESCRIPTION:        Sets the source address in the lower 8 bit of the
*                     29-bit CAN identifier.
*************************************************************************/
C_API_1 void C_API_2 CanSetTxIdExtMidLo( CAN_CHANNEL_CANTYPE_FIRST  canuint8 mask )
{
  canTxMask0[channel] = (canTxMask0[channel] & MK_EXTID0(0xFFFF00FFUL)) | MK_EXTID0((canuint32)mask<<8);    /*lint !e572*/
  #if (kCanNumberOfUsedCanTxIdTables > 1)
  canTxMask1[channel] = (canTxMask1[channel] & MK_EXTID1(0xFFFF00FFUL)) | MK_EXTID1((canuint32)mask<<8);    /*lint !e572*/
  #endif
  #if (kCanNumberOfUsedCanTxIdTables > 2)
  canTxMask2[channel] = (canTxMask2[channel] & MK_EXTID2(0xFFFF00FFUL)) | MK_EXTID2((canuint32)mask<<8);    /*lint !e572*/
  #endif
  #if (kCanNumberOfUsedCanTxIdTables > 3)
  canTxMask3[channel] = (canTxMask3[channel] & MK_EXTID3(0xFFFF00FFUL)) | MK_EXTID3((canuint32)mask<<8);    /*lint !e572*/
  #endif
  #if (kCanNumberOfUsedCanTxIdTables > 4)
  canTxMask4[channel] = (canTxMask4[channel] & MK_EXTID4(0xFFFF00FFUL)) | MK_EXTID4((canuint32)mask<<8);    /*lint !e572*/
  #endif
}

/************************************************************************
* NAME:               CanSetTxIdExtLo
* CALLED BY:
* PRECONDITIONS:      CanInitPower should already been called.
* PARAMETER:          new source address for the 29-bit CAN-ID
* RETURN VALUE:       -
* DESCRIPTION:        Sets the source address in the lower 8 bit of the
*                     29-bit CAN identifier.
*************************************************************************/
C_API_1 void C_API_2 CanSetTxIdExtLo( CAN_CHANNEL_CANTYPE_FIRST  canuint8 mask )
{
  canTxMask0[channel] = (canTxMask0[channel] & MK_EXTID0(0xFFFFFF00UL)) | MK_EXTID0((canuint32)mask);     /*lint !e572*/
  #if (kCanNumberOfUsedCanTxIdTables > 1)
  canTxMask1[channel] = (canTxMask1[channel] & MK_EXTID1(0xFFFFFF00UL)) | MK_EXTID1((canuint32)mask);     /*lint !e572*/
  #endif
  #if (kCanNumberOfUsedCanTxIdTables > 2)
  canTxMask2[channel] = (canTxMask2[channel] & MK_EXTID2(0xFFFFFF00UL)) | MK_EXTID2((canuint32)mask);     /*lint !e572*/
  #endif
  #if (kCanNumberOfUsedCanTxIdTables > 3)
  canTxMask3[channel] = (canTxMask3[channel] & MK_EXTID3(0xFFFFFF00UL)) | MK_EXTID3((canuint32)mask);     /*lint !e572*/
  #endif
  #if (kCanNumberOfUsedCanTxIdTables > 4)
  canTxMask4[channel] = (canTxMask4[channel] & MK_EXTID4(0xFFFFFF00UL)) | MK_EXTID4((canuint32)mask);    /*lint !e572*/
  #endif
}
#endif

#if defined( C_ENABLE_TX_OBSERVE )
/************************************************************************
* NAME:               CanTxGetActHandle
* CALLED BY:
* PRECONDITIONS:
* PARAMETER:          logical hardware object handle
* RETURN VALUE:       handle of the message in the assigned mailbox
* DESCRIPTION:        get transmit handle of the message, which is currently
*                     in the mailbox txHwObject.
*************************************************************************/
C_API_1 CanTransmitHandle C_API_2 CanTxGetActHandle( CanObjectHandle logicalTxHdl )
{
  assertUser(logicalTxHdl < kCanNumberOfUsedTxCANObjects, kCanAllChannels, kErrorTxHwHdlTooLarge);

  return (canHandleCurTxObj[logicalTxHdl]);       /*lint !e661*/
}
#endif

#if defined( C_ENABLE_VARIABLE_RX_DATALEN )
/************************************************************************
* NAME:               CanSetVariableRxDatalen
* CALLED BY:
* PRECONDITIONS:
* PARAMETER:          rxHandle: Handle of receive Message for which the datalen has
*                               to be changed
*                     dataLen:  new number of bytes, which have to be copied to the
*                               message buffer.
* RETURN VALUE:       -
* DESCRIPTION:        change the dataLen of a receive message to copy a
*                     smaller number of bytes than defined in the database.
*                     the dataLen can only be decreased. If the parameter
*                     dataLen is bigger than the statically defined value
*                     the statically defined value will be set.
*************************************************************************/
C_API_1 void C_API_2 CanSetVariableRxDatalen (CanReceiveHandle rxHandle, canuint8 dataLen)
{
  assertUser(rxHandle < kCanNumberOfRxObjects, kCanAllChannels , kErrorRxHandleWrong);  /* legal txHandle ? */

  if (dataLen < CanGetRxDataLen(rxHandle))
  {
    canVariableRxDataLen[rxHandle]=dataLen;
  }
  else
  {
    canVariableRxDataLen[rxHandle] = CanGetRxDataLen(rxHandle);
  }
}
#endif

#if defined( C_ENABLE_COND_RECEIVE_FCT )
/************************************************************************
* NAME:               CanSetMsgReceivedCondition
* CALLED BY:          Application
* PRECONDITIONS:
* PARAMETER:          -.
* RETURN VALUE:       -
* DESCRIPTION:        The service function CanSetMsgReceivedConditional()
*                     enables the calling of ApplCanMsgCondReceived()
*************************************************************************/
C_API_1 void C_API_2 CanSetMsgReceivedCondition( CAN_CHANNEL_CANTYPE_ONLY )
{
# if defined( C_MULTIPLE_RECEIVE_CHANNEL )
  assertUser((channel < kCanNumberOfChannels), kCanAllChannels, kErrorChannelHdlTooLarge);
# endif

  canMsgCondRecState[channel] = kCanTrue;
}

/************************************************************************
* NAME:               CanResetMsgReceivedCondition
* CALLED BY:          Application
* PRECONDITIONS:
* PARAMETER:          -
* RETURN VALUE:       -
* DESCRIPTION:        The service function CanResetMsgReceivedCondition()
*                     disables the calling of ApplCanMsgCondReceived()
*************************************************************************/
C_API_1 void C_API_2 CanResetMsgReceivedCondition( CAN_CHANNEL_CANTYPE_ONLY )
{
# if defined( C_MULTIPLE_RECEIVE_CHANNEL )
  assertUser((channel < kCanNumberOfChannels), kCanAllChannels, kErrorChannelHdlTooLarge);
# endif

  canMsgCondRecState[channel] = kCanFalse;
}

/************************************************************************
* NAME:               CanSetMsgReceivedCondition
* CALLED BY:          Application
* PRECONDITIONS:
* PARAMETER:          -
* RETURN VALUE:       status of Conditional receive function:
*                     kCanTrue : Condition is set -> ApplCanMsgCondReceived
*                                will be called
*                     kCanFalse: Condition is not set -> ApplCanMsgCondReceived
*                                will not be called
* DESCRIPTION:        The service function CanGetMsgReceivedConditional()
*                     returns the status of the condition for calling
*                     ApplCanMsgCondReceived()
*************************************************************************/
C_API_1 canuint8 C_API_2 CanGetMsgReceivedCondition( CAN_CHANNEL_CANTYPE_ONLY )
{
# if defined( C_MULTIPLE_RECEIVE_CHANNEL )
  assertUser((channel < kCanNumberOfChannels), kCanAllChannels, kErrorChannelHdlTooLarge);
# endif

  return( canMsgCondRecState[channel] );
}
#endif

#if defined(C_ENABLE_CAN_RAM_CHECK)
/************************************************************************
* NAME:               CanCheckMemory
* CALLED BY:          CanInitPowerOn
* PRECONDITIONS:      Global Interrupts must be disabled
* PARAMETER:          -
* RETURN VALUE:       kCanRamCheckOk    : all mailboxes for this channel are okay
*                     kCanRamCheckFailed: at least one mailbox on this channel is corrupt
*
* DESCRIPTION:        The service function CanCheckMemory() checks if the
*                     mailboxes on this channel are corrupt. The function checks
*                     only those mailboxes which are used in the current configuration.
*************************************************************************/
static canuint8 CanCheckMemory(CAN_CHANNEL_CANTYPE_ONLY)
{
  CanObjectHandle hwObjHandle;
  canuint8 retval;

#if defined ( C_ENABLE_MULTI_ECU_CONFIG )
  assertUser(( (CanChannelIdentityAssignment[channel] & V_ACTIVE_IDENTITY_MSK) != (tVIdentityMsk)0 ), channel, kErrorDisabledChannel);
#endif

  retval = kCanRamCheckOk; /* assume everthing is okay */

  {
    for(hwObjHandle = CAN_HL_HW_TX_STARTINDEX(canHwChannel); hwObjHandle < CAN_HL_HW_TX_STOPINDEX(canHwChannel); hwObjHandle++)
    {
      if(kCanTrue == CanLL_IsMailboxCorrupt(CAN_HW_CHANNEL_CANPARA_FIRST hwObjHandle))
      {
# if defined(C_ENABLE_NOTIFY_CORRUPT_MAILBOX)
        ApplCanCorruptMailbox(CAN_CHANNEL_CANPARA_FIRST hwObjHandle);
# endif
        retval = kCanRamCheckFailed;
      }
    }

# if defined(C_ENABLE_RX_FULLCAN_OBJECTS)
    for(hwObjHandle = CAN_HL_HW_RX_FULL_STARTINDEX(canHwChannel); hwObjHandle < CAN_HL_HW_RX_FULL_STOPINDEX(canHwChannel); hwObjHandle++)
    {
      if(kCanTrue == CanLL_IsMailboxCorrupt(CAN_HW_CHANNEL_CANPARA_FIRST hwObjHandle))
      {
#  if defined(C_ENABLE_NOTIFY_CORRUPT_MAILBOX)
        ApplCanCorruptMailbox(CAN_CHANNEL_CANPARA_FIRST hwObjHandle);
#  endif
        retval = kCanRamCheckFailed;
      }
    }
# endif

# if defined(C_ENABLE_RX_BASICCAN_OBJECTS)
    for(hwObjHandle = CAN_HL_HW_RX_BASIC_STARTINDEX(canHwChannel); hwObjHandle<CAN_HL_HW_RX_BASIC_STOPINDEX(canHwChannel); hwObjHandle++)
    {
      if(kCanTrue == CanLL_IsMailboxCorrupt(CAN_HW_CHANNEL_CANPARA_FIRST hwObjHandle))
      {
#  if defined(C_ENABLE_NOTIFY_CORRUPT_MAILBOX)
        ApplCanCorruptMailbox(CAN_CHANNEL_CANPARA_FIRST hwObjHandle);
#  endif
        retval = kCanRamCheckFailed;
      }
    }
# endif
  } /* for ( all HW channels ) */

  return(retval);
}
#endif


#if defined( C_MULTIPLE_RECEIVE_CHANNEL )
/************************************************************************
* NAME:           ApplCanChannelDummy
* PARAMETER:      channel
*                 current receive channel
* RETURN VALUE:   ---
* DESCRIPTION:    dummy-function for unused Callback-functions
*************************************************************************/
C_API_1 void C_API_2 ApplCanChannelDummy( CanChannelHandle channel )
{
# if defined( V_ENABLE_USE_DUMMY_STATEMENT )
  channel = channel;     /* to avoid lint warnings */
# endif
}
#endif   /* C_MULTIPLE_RECEIVE_CHANNEL */


#if defined( C_MULTIPLE_RECEIVE_CHANNEL ) || \
    defined ( C_HL_ENABLE_DUMMY_FCT_CALL )
/************************************************************************
* NAME:           ApplCanRxStructPtrDummy
* PARAMETER:      rxStruct
*                 pointer of CanRxInfoStruct
* RETURN VALUE:   kCanCopyData
* DESCRIPTION:    dummy-function for unused Callback-functions
*************************************************************************/
C_API_1 canuint8 C_API_2 ApplCanRxStructPtrDummy( CanRxInfoStructPtr rxStruct )
{
# if defined( V_ENABLE_USE_DUMMY_STATEMENT )
  rxStruct = rxStruct;     /* to avoid lint warnings */
# endif
  return kCanCopyData;
}

/************************************************************************
* NAME:           ApplCanTxHandleDummy
* PARAMETER:      txHandle
*                 transmit handle
* RETURN VALUE:   ---
* DESCRIPTION:    dummy-function for unused Callback-functions
*************************************************************************/
C_API_1 void C_API_2 ApplCanTxHandleDummy( CanTransmitHandle txHandle )
{
# if defined( V_ENABLE_USE_DUMMY_STATEMENT )
  txHandle = txHandle;     /* to avoid lint warnings */
# endif
}
#endif   /* C_MULTIPLE_RECEIVE_CHANNEL || C_HL_ENABLE_DUMMY_FCT_CALL */

#if defined ( C_HL_ENABLE_DUMMY_FCT_CALL )
/************************************************************************
* NAME:           ApplCanTxStructDummy
* PARAMETER:      txStruct
*                 pointer of CanTxInfoStruct
* RETURN VALUE:   kCanCopyData
* DESCRIPTION:    dummy-function for unused Callback-functions
*************************************************************************/
C_API_1 canuint8 C_API_2 ApplCanTxStructDummy( CanTxInfoStruct txStruct )
{
# if defined( V_ENABLE_USE_DUMMY_STATEMENT )
  txStruct = txStruct;     /* to avoid lint warnings */
# endif
  return kCanCopyData;
}

/************************************************************************
* NAME:           ApplCanRxHandleDummy
* PARAMETER:      rxHandle
*                 receive handle
* RETURN VALUE:   ---
* DESCRIPTION:    dummy-function for unused Callback-functions
*************************************************************************/
C_API_1 void C_API_2 ApplCanRxHandleDummy( CanReceiveHandle rxHandle )
{
# if defined( V_ENABLE_USE_DUMMY_STATEMENT )
  rxHandle = rxHandle;     /* to avoid lint warnings */
# endif
}
#endif /* C_HL_ENABLE_DUMMY_FCT_CALL */

#if defined( C_ENABLE_RX_QUEUE )
/************************************************************************
* NAME:               CanHL_ReceivedRxHandleQueue
* CALLED BY:          CanBasicCanMsgReceived, CanFullCanMsgReceived
* Preconditions:      none
* PARAMETER:          none
* RETURN VALUE:       none
* DESCRIPTION:        Writes receive data into queue or starts further
*                     processing for this message
*************************************************************************/
static canuint8 CanHL_ReceivedRxHandleQueue(CAN_CHANNEL_CANTYPE_FIRST CanReceiveHandle rxHandle)
{
  CanDeclareGlobalInterruptOldStatus

# if defined( C_HL_ENABLE_RX_INFO_STRUCT_PTR )
  tCanRxInfoStruct    *pCanRxInfoStruct;
# endif



# if defined( C_HL_ENABLE_RX_INFO_STRUCT_PTR )
  pCanRxInfoStruct =  &canRxInfoStruct[channel];
  pCanRxInfoStruct->Handle = rxHandle;
# else
  canRxInfoStruct[channel].Handle = rxHandle;
# endif


  /* if C_ENABLE_APPLCANPRERXQUEUE is not set, a macro ApplCanPreRxQueue has to be provided by the tool */
  if(ApplCanPreRxQueue(CAN_HL_P_RX_INFO_STRUCT(channel)) == kCanCopyData)
  {
    /* Disable the interrupts because nested interrupts can take place */
    CanNestedGlobalInterruptDisable();
    if(canRxQueueCount < kCanRxQueueSize)   /* Queue full ? */
    {
      if (canRxQueueWriteIndex == (kCanRxQueueSize - 1) )
      {
        canRxQueueWriteIndex = 0;
      }
      else
      {
        canRxQueueWriteIndex++;
      }
      canRxQueueBuf[canRxQueueWriteIndex].Channel = channel;
      canRxQueueBuf[canRxQueueWriteIndex].Handle  = rxHandle;

      canRxQueueCount++;
    }
# if defined(C_ENABLE_RXQUEUE_OVERRUN_NOTIFY)
    else
    {
      ApplCanRxQueueOverrun();
    }
# endif
    CanNestedGlobalInterruptRestore();
  }
# if defined(C_ENABLE_APPLCANPRERXQUEUE)
  else
  {
    /* Call the application call-back functions and set flags */
    return CanHL_ReceivedRxHandle(CAN_CHANNEL_CANPARA_FIRST rxHandle);
  }
# endif
  return kCanHlFinishRx;
}
/************************************************************************
* NAME:               CanHandleRxMsg
* CALLED BY:          Application
* Preconditions:      none
* PARAMETER:          none
* RETURN VALUE:       none
* DESCRIPTION:        Calls PreCopy and/or Indication, if existent and
*                     set the indication flag
*************************************************************************/
C_API_1 void C_API_2 CanHandleRxMsg(void)
{
  CanDeclareGlobalInterruptOldStatus
  CAN_CHANNEL_CANTYPE_LOCAL

  while ( canRxQueueCount != 0 )
  {

# if defined(C_MULTIPLE_RECEIVE_CHANNEL)
    channel = canRxQueueBuf[canRxQueueReadIndex].Channel;
# endif

    CanCanInterruptDisable( CAN_CHANNEL_CANPARA_ONLY );

    /* Call the application call-back functions and set flags */
    canRxInfoStruct[channel].Handle      = canRxQueueBuf[canRxQueueReadIndex].Handle;
    canRxInfoStruct[channel].pChipData   = (CanChipDataPtr)&(canRxQueueBuf[canRxQueueReadIndex].CanChipMsgObj.DataFld[0]);
    canRxInfoStruct[channel].pChipMsgObj = (CanChipMsgPtr) &(canRxQueueBuf[canRxQueueReadIndex].CanChipMsgObj);

# if defined( C_ENABLE_INDICATION_FLAG ) || \
     defined( C_ENABLE_INDICATION_FCT )
    if( CanHL_ReceivedRxHandle( CAN_CHANNEL_CANPARA_FIRST canRxQueueBuf[canRxQueueReadIndex].Handle )
        == kCanHlContinueRx )
    {
      CanHL_IndRxHandle(canRxQueueBuf[canRxQueueReadIndex].Handle);
    }
# else
    (void)CanHL_ReceivedRxHandle( CAN_CHANNEL_CANPARA_FIRST canRxQueueBuf[canRxQueueReadIndex].Handle );
# endif
    CanCanInterruptRestore( CAN_CHANNEL_CANPARA_ONLY );

    CanSingleGlobalInterruptDisable();
    if (canRxQueueReadIndex == (kCanRxQueueSize - 1) )
    {
      canRxQueueReadIndex = 0;
    }
    else
    {
      canRxQueueReadIndex++;
    }
    canRxQueueCount--;
    CanSingleGlobalInterruptRestore();
  }
  return;
} /* end of CanHandleRxMsg() */
/************************************************************************
* NAME:               CanDeleteRxQueue
* CALLED BY:          Application, CAN driver
* Preconditions:      none
* PARAMETER:          none
* RETURN VALUE:       none
* DESCRIPTION:        delete receive queue
*************************************************************************/
C_API_1 void C_API_2 CanDeleteRxQueue(void)
{
  CanDeclareGlobalInterruptOldStatus

  CanSingleGlobalInterruptDisable();
  canRxQueueWriteIndex  = (vuintx)0xFFFFFFFF;
  canRxQueueReadIndex   = 0;
  canRxQueueCount       = 0;
  CanSingleGlobalInterruptRestore();
} /* end of CanDeleteRxQueue() */

#endif /* C_ENABLE_RX_QUEUE */

/* End of channel */
/* STOPSINGLE_OF_MULTIPLE */
/* Kernbauer Version: 1.09 Konfiguration: can_driver Erzeugungsgangnummer: 817 */

/************   Organi, Version 3.2.4 Vector-Informatik GmbH  ************/
/************   Organi, Version 3.6.2 Vector-Informatik GmbH  ************/

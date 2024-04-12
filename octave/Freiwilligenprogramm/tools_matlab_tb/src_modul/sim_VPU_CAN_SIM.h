/******************************************************************************
 * @file  sim_VPU_CAN_SIM.h
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
#ifndef _SIM_VPU_CAN_SIM_H_INC_
#define _SIM_VPU_CAN_SIM_H_INC_
/*##FUNCTION_CODE_NAMEXYZ_START##*/
/*##FUNCTION_CODE_NAMEXYZ_END##*/

#include "ReadCanAscii.h"
#include "SlfBasic.h"

#define SIM_CAN_DT           (1.e-6)
#define SIM_10MS_LOOP_COUNT  ((__int64)(0.01/SIM_CAN_DT))

/*##VPU_CAN_SIM_START_H##*/
#define SIM_VPU_CAN_SIM_N_OUT 1
#define SIM_VPU_CAN_SIM_N_PAR 1
/*##VPU_CAN_SIM_END_H##*/
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
extern SSimPar SimPar[SIM_VPU_CAN_SIM_N_PAR];
typedef struct
{
  std::vector<double> time;
  std::vector<double> vec;
  std::string         comment;
  bool          found;
  std::vector<std::vector<double>> vecvec;
  std::vector<size_t>              nvecvec;
  bool          isvecofvec;
}SSimOut;
extern SSimOut SimOut[SIM_VPU_CAN_SIM_N_OUT];

typedef std::vector<__int64> CRecTimerCountT;
typedef std::vector<double> CParamValues;

typedef struct
{
	std::string         MessAsciiCanFile;              /* Messdatei */
	CVecIdCh            VecIdCh;                       /* Vector mit ID und Channel, die eingelesen werden */
  bool                RecBufListIsRead;              /* Flag, ob RecBufList gelesen */
	CRecBufListT        RecBufList;                    /* Buffer, der eingelesen wird */
  CRecTimerCountT     RecTimerList;                  /* Timer der eingelsenen Botschaften, um in integer rechnen zu können */
  double              tstart;                        /* Startzeit, entweder null oder durch Odometrie-Trajektorienabgleich */
  double              tend;                          /* Endzeit                     */
  std::vector<std::string>   ParamNames;             /* Parameternamen aus mex-Eingabe */
  std::vector<CParamValues>  ParamValues;            /* Parameterwerte (numerisch) aus mex-Eingabe */

} SSimVpu;
extern SSimVpu SimVpu;
#ifdef SIM_CAN_CFG_HAF1
typedef struct
{
  bool                 UseMeasOdo;                  /*     Kennzeichnung ob Odometrie von Messung verwendet werden soll */
  size_t               iact;                        /*     aktuelles Datum aus time-Vektor */
  double               delta_t;                     /* s   zeitliche Verschiebung nach vorne, da Messung erst spät */
  std::vector<double>  time;                        /* s   Zeitvektor */
  std::vector<double>  x;                           /* m   x-Position */
  std::vector<double>  y;                           /* m   y-Position */
  std::vector<double>  theta;                       /* rad Gierwinkel */
  std::vector<double>  timestamp;                   /* ms  TimeStamp */
} SSimOdo;
extern SSimOdo SimOdo;
#endif
extern char *pSimOutVarNames[];
extern char *pSimOutUnitNames[];
extern char *pSimParVarNames[];
extern char *pSimParUnitNames[];

status_t sim_VPU_CAN_SIM_init(std::string *pmessAcsCanFile,std::vector<size_t> *plisteCANID,std::vector<unsigned char> *plisteCANCHAN,char *errtext,size_t lerrtext);
status_t sim_VPU_CAN_SIM(char * errtext,size_t lerrtext);

#endif

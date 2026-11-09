/******************************************************************************
 * @file  sim_VPU_CAN_SIM.c
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
//#include "fct.he"
#include "mat_std.he"
#include "sim_VPU_CAN_SIM.h"
#include "fkt_VPU_CAN_SIM.h"
#ifdef SIM_CAN_CFG_HAF1
#include "can_database_ch1.h"
#endif

double  SimDebugTime=11.81;

/*##VPU_CAN_SIM_START_INC##*/
#ifdef __cplusplus
extern "C" {
#endif
#include "fctext_.h"
#ifdef __cplusplus
}
#endif
char *pSimOutVarNames[] = {"dummy"
                          };
char *pSimOutUnitNames[] = {"-"
                           };
char *pSimParVarNames[] = {"ghhj"
                          };
char *pSimParUnitNames[] = {"enum"
                           };
/*##VPU_CAN_SIM_END_INC##*/
SSimOut SimOut[SIM_VPU_CAN_SIM_N_OUT];
SSimParTime SimParTime;
SSimPar SimPar[SIM_VPU_CAN_SIM_N_PAR];



/*****************************************************************************
  FUNCTIONS
*****************************************************************************/
status_t sim_VPU_CAN_SIM_init_change_channel(char *errtext,size_t lerrtext);
status_t sim_VPU_CAN_SIM_out_id(double *ptime,struct SRecBuf *p_rec_buf,char *errtext,size_t lerrtext);
status_t sim_VPU_CAN_SIM_out_loop(double *ptime,char *errtext,size_t lerrtext);
status_t sim_VPU_CAN_SIM_par_loop(size_t itime,char *errtext,size_t lerrtext);
status_t sim_VPU_CAN_SIM_par_perm(char *errtext,size_t lerrtext);
status_t sim_VPU_CAN_SIM_par_init0(char *errtext,size_t lerrtext);
status_t sim_VPU_CAN_SIM_par_init1(char *errtext,size_t lerrtext);
bool sim_VPU_CAN_SIM_get_qparam_one_value(char *param_name,double *pval);
bool sim_VPU_CAN_SIM_get_qparam_vector(char *param_name,std::vector<double> *pvec);

#ifdef __cplusplus
extern "C" {
#endif
#include "IOMap32192TimerPwm.h"
#include "octim.h"
#ifdef __cplusplus
}
#endif
/*****************************************************************************
  DECLARATIONS
*****************************************************************************/
SSimVpu SimVpu;
double  SimTime;

status_t sim_VPU_CAN_SIM_init(std::string *pmessAsciiCanFile,std::vector<size_t> *plisteCANID,std::vector<unsigned char> *plisteCANCHAN,char *errtext,size_t lerrtext)
{
	status_t status = OKAY;
  bool     flag;
  double   dval;
  size_t   i;
//  double   tstart;

  // CAN-ascii-Datei einlesen
  //=========================
  if( !(SimVpu.RecBufListIsRead) )
  {

	  // Ids und channel einsortieren
	  for(size_t i=0;i<plisteCANID->size();i++)
	  {
      SIdCh  idch;

		  idch.id      = (*plisteCANID)[i];
		  idch.channel = (*plisteCANCHAN)[i];
      SimVpu.VecIdCh.push_back(idch);
    }

    SimVpu.tend = ReadDatFile(*pmessAsciiCanFile,&SimVpu.VecIdCh,&SimVpu.RecBufList);
    SimVpu.RecBufListIsRead = true;
  }

  if( SimVpu.RecBufList.size() == 0 )
  {
    status = NOT_OKAY;
    sprintf_s(errtext,lerrtext,"Datei: %s enthält keine Daten !!!",pmessAsciiCanFile->c_str());
    return status;
  }
  else
  {
    // Aus dem Zeitverlauf der Messung einen TimerListe erstellen
    // anhand der ein Aufruf der CAN-Interrupt-Routine gemacht wird
    //-------------------------------------------------------------

    CRecBufListT::iterator iter = SimVpu.RecBufList.begin();
    double  t0 = (*iter).time;

    SimVpu.tend -= t0;
    for( iter = SimVpu.RecBufList.begin(); iter != SimVpu.RecBufList.end(); ++iter )
    {
      (*iter).time -= t0;
      SimVpu.RecTimerList.push_back((__int64)(((*iter).time/SIM_CAN_DT)+0.5));
    }
  }

#if SIM_VPU_CAN_SIM_N_LOOP_PAR > 0
  /* Parameterzeit wird nur bei loop-Ausfrufen benötigt */
  if( !SimParTime.found )
  {
    status = NOT_OKAY;
    sprintf_s(errtext,lerrtext,"Kein Zeitvektor 'time' in der eingelesenen parameter-Struktur gefunden (notwendig, da type = ''single'' verwendet!!!");
    return status;
  }
#endif
  for( i=0;i<SIM_VPU_CAN_SIM_N_PAR;i++)
  {
    if( !SimPar[i].found && (SimPar[i].vecname.compare("dummy") != 0) )
    {
      status = NOT_OKAY;
      sprintf_s(errtext,lerrtext,"Kein Vektor '%s' in der eingelesenen parameter-Struktur gefunden !!!",SimPar[i].vecname.c_str());
      return status;
    }
  }
  /* Change channel 1->2 2->1                   */
  /* wenn Parameter change_channel gesetzt (=1) */
  /*============================================*/
  flag = sim_VPU_CAN_SIM_get_qparam_one_value("change_channel",&dval);
  if( flag && (dval > 0.5) ) if( sim_VPU_CAN_SIM_init_change_channel(errtext,lerrtext) != OKAY ) return NOT_OKAY;

  // Parameter vor Initialisierung setzen
  //=====================================
  if( sim_VPU_CAN_SIM_par_init0(errtext,lerrtext) != OKAY) return NOT_OKAY;

  /* CAN- initialisierung */
  /*======================*/
  int ivaldt = int(double(SIM_10MS_LOOP_COUNT*SIM_CAN_DT)*1000);
  if( fkt_VPU_CAN_SIM_init(double(ivaldt)*0.001,errtext,lerrtext) != OKAY ) return NOT_OKAY;

  // Parameter nach Initialisierung setzen
  //======================================
  if( sim_VPU_CAN_SIM_par_init1(errtext,lerrtext) != OKAY) return NOT_OKAY;

  return status;
}

status_t sim_VPU_CAN_SIM(char *errtext,size_t lerrtext)
{

  __int64  TimeCounter,NTimeCounter;
  __int64  LoopTimeCounter10ms;
  CRecTimerCountT::iterator iterRecTimer = SimVpu.RecTimerList.begin();
  CRecBufListT::iterator    iterRecBuffer = SimVpu.RecBufList.begin();
#if SIM_VPU_CAN_SIM_N_LOOP_PAR > 0
  size_t  TimeParCounter=0;
#endif

  NTimeCounter = (__int64)((SimVpu.tend/SIM_CAN_DT)+0.5)+1;

  LoopTimeCounter10ms = SIM_10MS_LOOP_COUNT-1;

  for(TimeCounter=0;TimeCounter<NTimeCounter;TimeCounter++)
  {
    SimTime = TimeCounter * SIM_CAN_DT;

    TIPWM_TMSXCOUNTER_REGISTER.Tml0Ct.TML01CT  = OCTIM_MICROSECONDS_2_TML_TICKS((ui32_t)(SimTime*1.e6));


    if( SimTime >= SimDebugTime )
    {
      char a;
      a = 0;
    }

    /* CAN Interrupt */
    if( TimeCounter >= (*iterRecTimer) )
    {

      /* Funktionsaufruf CAN Receive*/
      /*----------------------------*/
      if( can_receive_VPU_CAN_SIM(&(*iterRecBuffer),errtext,lerrtext) != OKAY )
      {
         return NOT_OKAY;
      }

      /* Ausgabewerte */
      if( sim_VPU_CAN_SIM_out_id(&SimTime,&(*iterRecBuffer),errtext,lerrtext) != OKAY )
      {
         return NOT_OKAY;
      }

      if( iterRecTimer != SimVpu.RecTimerList.end() ) ++iterRecTimer;
      if( iterRecBuffer != SimVpu.RecBufList.end() )  ++iterRecBuffer;
    }

    /* Konstante Parameter */
    if( sim_VPU_CAN_SIM_par_perm(errtext,lerrtext) != OKAY )
    {
       return NOT_OKAY;
    }

    /* loop-weise ändernte Parameter */
#if SIM_VPU_CAN_SIM_N_LOOP_PAR > 0
    if( (TimeParCounter < SimParTime.ntime) && (SimParTime.ptime[TimeParCounter] <= (SimTime+SIM_CAN_DT)) )
    {
      if( sim_VPU_CAN_SIM_par_loop(TimeParCounter,errtext,lerrtext) != OKAY ) return NOT_OKAY;
      ++TimeParCounter;
    }
#endif

    /* Loop Aufruf */
    if( ++LoopTimeCounter10ms == SIM_10MS_LOOP_COUNT )
    {
      LoopTimeCounter10ms = 0;

      /* Loop-Aufruf */
      if( fkt_VPU_CAN_SIM_loop(errtext,lerrtext) != OKAY )
      {
         return NOT_OKAY;
      }

      if( sim_VPU_CAN_SIM_out_loop(&SimTime,errtext,lerrtext) != OKAY )
      {
         return NOT_OKAY;
      }


    }

  }
  /* End-Aufruf */
  if( fkt_VPU_CAN_SIM_end(errtext,lerrtext) != OKAY )
  {
     return NOT_OKAY;
  }
  return OKAY;
}
/* ***********************************************************************/ /*!
  @fn               sim_VPU_CAN_SIM_init_change_channel(char *errtext,size_t lerrtext)

  @brief            channels der CAN-Messages werden getauscht 1->2 2->1 ...;

  @desription

  @return           status = OKAY

  @pre

  @post

  @author           Thomas Berthold; 29.04.2014
**************************************************************************** */
status_t sim_VPU_CAN_SIM_init_change_channel(char *errtext,size_t lerrtext)
{
  CRecBufListT::iterator    iterRecBuffer = SimVpu.RecBufList.begin();

  while( (iterRecBuffer != SimVpu.RecBufList.end()) )
  {
    /* Channel umsetzen   */
    /*--------------------*/
    if( (*iterRecBuffer).channel == 1 )
    {
      (*iterRecBuffer).channel = 2;
    }
    else if( (*iterRecBuffer).channel == 2 )
    {
      (*iterRecBuffer).channel = 1;
    }
    ++iterRecBuffer;
  }
  return OKAY;
}
/* ***********************************************************************/ /*!
  @fn               status_t sim_VPU_CAN_SIM_par_perm(char *errtext,size_t lerrtext)

  @brief            Parameter während der loop ...;

  @desription

  @return           status = OKAY

  @pre

  @post

  @author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t sim_VPU_CAN_SIM_par_perm(char *errtext,size_t lerrtext)
{
  /*##VPU_CAN_SIM_START_PAR_PERM##*/
  {
    double *pdval;

    /* ODO_Type */
    pdval = SimPar[0].pvec[0];
    FctParam.ODO_Type = (unsigned char)(pdval[0] * 1.000000 + 0.000000);
  }
  /*##VPU_CAN_SIM_END_PAR_PERM##*/
  return OKAY;
}
/* ***********************************************************************/ /*!
  @fn               status_t sim_VPU_CAN_SIM_par_loop(size_t itime,char *errtext,size_t lerrtext)

  @brief            Parameter während der loop ...;

  @desription

  @return           status = OKAY

  @pre

  @post

  @author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t sim_VPU_CAN_SIM_par_loop(size_t itime,char *errtext,size_t lerrtext)
{
  /*##VPU_CAN_SIM_START_PAR_LOOP##*/
  {
    double *pdval;
    size_t ndval,i;
    /* IQF1_LdwStatus */
    pdval = SimPar[0].pvec[0];
    ndval = SimPar[0].nvec[0];
    CAN1InputData.IQFLdwStatus = (unsigned char)(pdval[MIN(itime,ndval-1)] * 1.000000 + 0.000000);
  }
  /*##VPU_CAN_SIM_END_PAR_LOOP##*/
  return OKAY;
}
/* ***********************************************************************/ /*!
  @fn               status_t sim_VPU_CAN_SIM_par_init0(char *errtext,size_t lerrtext)

  @brief            Parameter vor initialisierung ...;

  @desription

  @return           status = OKAY

  @pre

  @post

  @author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t sim_VPU_CAN_SIM_par_init0(char *errtext,size_t lerrtext)
{
  /*##VPU_CAN_SIM_START_PAR_INIT0##*/
  /*##VPU_CAN_SIM_END_PAR_INIT0##*/
  return OKAY;
}
;
/* ***********************************************************************/ /*!
  @fn               status_t sim_VPU_CAN_SIM_par_init1(char *errtext,size_t lerrtext)

  @brief            Parameter nach Initialisierung ...;

  @desription

  @return           status = OKAY

  @pre

  @post

  @author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t sim_VPU_CAN_SIM_par_init1(char *errtext,size_t lerrtext)
{
  /*##VPU_CAN_SIM_START_PAR_INIT1##*/
  /*##VPU_CAN_SIM_END_PAR_INIT1##*/
  return OKAY;
}
/* ***********************************************************************/ /*!
  @fn               status_t sim_VPU_CAN_SIM_output_id(double *ptime,struct SRecBuf *p_rec_buf,char *errtext,size_t lerrtext)

  @brief            Output Id ...;

  @desription

  @return           status = OKAY

  @pre

  @post

  @author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t sim_VPU_CAN_SIM_out_id(double *ptime,struct SRecBuf *p_rec_buf,char *errtext,size_t lerrtext)
{
  /*##VPU_CAN_SIM_START_OUT_ID##*/
  /*##VPU_CAN_SIM_END_OUT_ID##*/


  return OKAY;
}
/* ***********************************************************************/ /*!
  @fn               status_t sim_VPU_CAN_SIM_out_loop(double *ptime,struct SRecBuf *p_rec_buf,char *errtext,size_t lerrtext)

  @brief            Output nach der loop ...;

  @desription

  @return           status = OKAY

  @pre

  @post

  @author           Thomas Berthold; 13.03.2014
**************************************************************************** */
status_t sim_VPU_CAN_SIM_out_loop(double *ptime,char *errtext,size_t lerrtext)
{
  /*##VPU_CAN_SIM_START_OUT_LOOP##*/
  /*##VPU_CAN_SIM_END_OUT_LOOP##*/
  return OKAY;
}
/* ***********************************************************************/ /*!
  @fn               bool sim_VPU_CAN_SIM_get_qparam_one_value(char *param_name,double *pval)

  @brief            Sucht Parameterwert;

  @desription       Sucht Parametername in der Liste SimVpu.ParamNames
                    Wenn gefunden, wird der Wert in *pval geschrieben und true zurückgegeben
                    Wenn nicht vorhanden wird false zurückgegeben

  @return           status = OKAY

  @pre

  @post

  @author           Thomas Berthold; 13.03.2014
**************************************************************************** */
bool sim_VPU_CAN_SIM_get_qparam_one_value(char *param_name,double *pval)
{
  std::vector<std::string>::iterator  iterN;
  std::vector<CParamValues>::iterator iterV = SimVpu.ParamValues.begin();
  bool                                flag = false;

  for( iterN = SimVpu.ParamNames.begin(); iterN != SimVpu.ParamNames.end(); ++iterN )
  {
    if( (*iterN).compare(param_name) == 0 )
    {
      CParamValues Vec = *iterV;
      if( Vec.size() > 0 ) *pval = Vec[0];
      else                 *pval = 0.0;
      flag = true;
      break;
    }
    ++iterV;
  }
  return flag;
}
/* ***********************************************************************/ /*!
  @fn               bool sim_VPU_CAN_SIM_get_qparam_vector(char *param_name,std::vector<double> *pvec)

  @brief            Sucht Parameterwert;

  @desription       Sucht Parametername in der Liste SimVpu.ParamNames
                    Wenn gefunden, wird die Werte in *pvec geschrieben und true zurückgegeben
                    Wenn nicht vorhanden wird false zurückgegeben

  @return           status = OKAY

  @pre

  @post

  @author           Thomas Berthold; 13.03.2014
**************************************************************************** */
bool sim_VPU_CAN_SIM_get_qparam_vector(char *param_name,std::vector<double> *pvec)
{
  std::vector<std::string>::iterator  iterN;
  std::vector<CParamValues>::iterator iterV = SimVpu.ParamValues.begin();
  bool                                flag = false;
  size_t                              i;

  for( iterN = SimVpu.ParamNames.begin(); iterN != SimVpu.ParamNames.end(); ++iterN )
  {
    if( (*iterN).compare(param_name) == 0 )
    {
      CParamValues Vec = *iterV;
      pvec->clear();
      for(i=0;i<Vec.size();i++) pvec->push_back(Vec[i]);
      flag = true;
      break;
    }
    ++iterV;
  }
  return flag;
}

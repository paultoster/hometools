"""

Minimumsaufgabe mit den Methoden:
        - Methode des steilsten Abstiegs
        - BFGS-Verfahren (Newton-ähnlich
        - Trust-Region-Verfahren
        - BFGS-Verfahren (Newton-ähnlich mit penality)

"""
from dataclasses import dataclass
import os, sys, copy, time
import numpy as np
import scipy
import math
import datetime

# -------------------------------------------------------------------------------
t_path, _ = os.path.split(__file__)
if (t_path == os.getcwd()):

    import hfkt_log as hlog
    import hfkt_def as hdef
    import hfkt_io as hio
    import hfkt_file_path as hfp
else:
    p_list = os.path.normpath(t_path).split(os.sep)
    if (len(p_list) > 1): p_list = p_list[: -1]
    t_path = ""
    for i, item in enumerate(p_list): t_path += item + os.sep
    if (os.path.normpath(t_path) not in sys.path): sys.path.append(t_path)

    from tools import hfkt_log as hlog
    from tools import hfkt_def as hdef
    from tools import hfkt_io as hio
    from tools import hfkt_file_path as hfp
@dataclass
class XType():
    name: str
    type: str = 'float'

@dataclass
class PenalityClass():
    xmin: float
    xmax: float
    dxP: float

@dataclass
class DataOpt:
    # Ausgabe:

    name : str
"""
    x0: list                            # Anfangwerte
    xtype_list: list                    # jede Variable in opt.x0 = [w0,w1] wir din der Liste eingetragen
    func: callable                      # (muss) Funktionsaufruf f  = opt.func(x); (Funktionswert f skalar), muss definiert sein
    dfunc: callable                     # (kann) Funktionsaufruf df = opt.func(x); (Funktionsableitung Länge df entspricht x)
    Hfunc: callable                     # (kann) Funktionsaufruf H  = opt.Hfunc(x); (Hesse-Matrix L�nge H entspricht length(x) x length(x) )
    use_df_func: bool                   # analytische Ableitfunktion (dfunc()) verwenden
    use_H_func: bool                    # soll analytische Hessematrix funktion verwendet werden,
                                        #                  Wenn null wird die zweite Ableitung der
                                        #                  Hauptdiagonale für den Startwert (BFGS,Trust-Region)
                                        #                  berechnet und verwendet H0 und B0= H0^-1 (es kann aber
                                        #                  auch ein Startwert für die zweite Ableitung vorgegeben
                                        #                  werden H0
    H0 = None                           # für BFGS- und RT-Verfahren wird symetrische positiv-definite Startmatrix
                                        #                  vorgegeben, wenn nicht, dann wird H-Matrix gebildet oder analytisch berechnet
                                        #                  gilt aber nur, wenn use_H_func = 0, bez. nicht gesetzt ist
    kmax: int                           # Anzahl der maximalen Iterationen (def 1000)
    err: float                     # Fehlerschranke (def 1e-6) zum Abbruch df = dfunc(x) norm(df) < err
    type: int                           # Berechnungsart
                                        #                  0: Methode Steilster Abstieg (Hfunc wird nicht benutzt)
                                        #                  1: Quasi-Newton-Verfahren, wenn Hfunc nicht vorhanden, dann mit BFGS-Verfahren () mit Powell-Wolfe-Regel
                                        #                  2: Trust-Region-Verfahren, wenn Hfunc nicht vorhanden, dann mit BFGS-Verfahren
                                        #                  3: Trust-Region-Verfahren mit wedge
                                        #                  4: Quasi-Newton-Verfahren mit penality, wenn Hfunc nicht vorhanden, dann mit BFGS-Verfahren
                                        #
                                        # Wenn type = 0: Methode Steilster Abstieg (Hfunc wird nicht benutzt)
    stype: int                          #   0: Schrittweiten Regelung für steilsetn Abstieg nach Armijo-Regel
                                        #   1: Schrittweiten Regelung für steilsetn Abstieg nach Powell-Wolfe
                                        #   für stype=0:     Armijo-Regel
    beta: float                    #        Skalierungsfaktor für Schrittweitensteuerung 0 < beta < 1  (def 0.5)
    gamma: float                   #        Skalierungsfaktor Gradient für Schrittweiensteuerung 0 < gamma < 1 (def 1e-2)
                                        #   für stype=1:     Powell-Wolfe-Regel
                                        #        Skalierungsfaktor Gradient für Schrittweiensteuerung 0 < gamma < 1 (def 1e-4)
    eta : float                    #        gamma < eta < 1 skaliert Gradienten gröber
                                        # Wenn type = 1: Quasi-Newton-Verfahren
                                        #       stype      0: Schrittweiten Regelung für steilsetn Abstieg nach Armijo-Regel
                                        #                  1: Schrittweiten Regelung für steilsetn Abstieg nach Powell-Wolfe
                                        #       stype=0:     Armijo-Regel
                                        #           beta      Skalierungsfaktor f�r Schrittweiensteuerung 0 < beta < 1  (def 0.5)
                                        #           gamma     Skalierungsfaktor Gradient für Schrittweiensteuerung 0 < gamma < 1 (def 1e-2)
                                        #       stype=1:     Powell-Wolfe-Regel
                                        #           gamma     Skalierungsfaktor Gradient für Schrittweiensteuerung 0 < gamma < 1 (def 1e-4)
                                        #           eta       gamma < eta < 1 skaliert Gradienten gröber
                                        # Wenn type = 2   Trust-Region-Verfahren
    delta0 : float                 #    Startwert für Trust-Region-Radius (def 1.0)
    deltamin: float                #    minimal Trust-Region-Radius (def 10*eps)
    rho1: float                    #    opt.       Bestimmung des Radius deltak (def 0.25)
    rho2: float                    #    Bestimmung des Radius deltak 0 < rho1 < rho2 < 1 ((def 0.75)
    sigma1: float                  #    Bestimmung des Radius deltak (def 0.5)
    sigma2: float                  #    Bestimmung des Radius deltak 0 < sigma1 < 1 < sigma2 (def 2)
    TP_itermax: int                     #   maximale Iterationsloop des Teilproblems (def 100)
    TP_rtol: float                 #   relative Toleranz Teilproblem (def eps)
    TP_atol: float                 #   absolute Toleranz Teilproblem (def eps)
    TP_par: float                  # Unbekannt  zu TeilProblem (def 0)
                                        #
                                        # Wenn opt.type = 4    Quasi-Newton-Verfahren mit penality
    Penality: float                #  Strafhöhe bei dxP
    P_liste: list[PenalityClass]        #  P[i].xmin    minimaler Wert
                                        #  P[i].xmax max
                                        #  P[i].dxP  Strafabstand bis Penality erreicht
                                        #  stype wie Quasi-Newton-Verfahren
# Ausgabe:

    status: int                         # Status
    errtext: str                        #
    inform: int                         # the algorithm stops if either of the following
                                        #               - criterias reached                             (inform =  0)
                                        #               - trust region radius < deltamin                (inform =  1)
                                        #               - number of iterations >= kmax                  (inform =  2)
                                        #               - relative stopping test
                                        #                 (f - fminimum)/(f0 - fminimum) <= tol_fmin
                                        #                 satisfied                                     (inform =  3)
                                        #               - maximal function call reached                 (inform =  4)
                                        #               - crieria df_norm < err reached                 (inform =  5)
                                        #               - Quasi-Newton Matrix Bk = inv(Hk) singular     (inform =  6)
                                        #               - no further progress can be made               (inform = -1)
    calc_time: float               # Berechnungszeit elapsed time
    xs: list[float]                #  letzter berechneter x-Vektor
    f: float                       #  Funktionswert in xs
    df: float                      #  Ableitung in xs
    df_norm: float                 #  Norm der Ableitung
"""

class OptNlinNbegrenzt():

    TYPE_STEILSTER_ABSTIEG = 0
    TYPE_QUASI_NEWTON = 1
    TYPE_TRUST_REGION = 2
    TYPE_TRUST_REGION_WEDGE = 3
    TYPE_QUASI_NEWTON_PENALITY = 4

    def __init__(self,log_obj=None):


        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""

        self.opt = None

        # Log-File start
        # ---------------
        if log_obj is None:
            self.log = hlog.log(consol_func=True, log_window=False)
        else:
            self.log = log_obj
        # end if
        self.log_file_name = self.log.get_logfilename()



        return
    # end def
    def get_status(self):
        return self.status
    # end def
    def get_errtext(self):
        return self.errtext
    # end def
    def get_infotext(self):
        return self.infotext
    # end def
    def reset_status(self):
        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""
        return
    # end def
    def check_opt(self):

        self.opt.eps = 2.2204e-16

        if not hasattr(self.opt, 'x0'):
            self.status = hdef.NOT_OKAY
            self.errtext = f"Kein x0 gesetzt"
            return
        elif not isinstance(self.opt.x0,(list,np.ndarray)):
            self.status = hdef.NOT_OKAY
            self.errtext = f"x0 ist nicht als Liste oder ndarray gesetzt"
            return
        # end if
        if isinstance(self.opt.x0,list):
            self.opt.x0 = np.array(self.opt.x0)
        # end if


        if not hasattr(self.opt, 'type'):
            self.status = hdef.NOT_OKAY
            self.errtext = f"type ist nicht als Liste gesetzt"
            return
        elif self.opt.type not in [0,1,2,3,4]:
            self.status = hdef.NOT_OKAY
            self.errtext = f"type ist falsch type = {self.opt.type} gesetzt siehe Definition"
            return
        # end if

        if not hasattr(self.opt, 'kmax'):
            self.opt.kmax = 1000
        # end fi

        if not hasattr(self.opt, 'err'):
            self.opt.err = 1e-06
        else:
            self.opt.err = abs(self.opt.err)
        # end fi

        # steilster Abstieg, BFGS, BFGS mit Strafe
        if ((self.opt.type == self.TYPE_STEILSTER_ABSTIEG) or
            (self.opt.type == self.TYPE_QUASI_NEWTON) or
            (self.opt.type == self.TYPE_QUASI_NEWTON_PENALITY)):

            if not hasattr(self.opt, 'stype'):
                self.opt.stype = 0

            if (self.opt.stype == 0):

                if not hasattr(self.opt, 'beta'):
                    self.opt.beta = 0.5
                else:
                    if (self.opt.beta >= 1.0):
                        self.opt.beta = 0.999999999
                    else:
                        if (self.opt.beta <= 0.0):
                            self.opt.beta = 1e-07
                        # end if
                    # end if
                # end if

                if not hasattr(self.opt, 'gamma'):
                    self.opt.gamma = 0.01
                else:
                    if (self.opt.gamma >= 1.0):
                        self.opt.gamma = 0.999999999
                    else:
                        if (self.opt.gamma <= 0.0):
                            self.opt.gamma = 1e-07
            else:
                if not hasattr(self.opt, 'gamma'):
                    self.opt.gamma = 0.01
                else:
                    if (self.opt.gamma >= 1.0):
                        self.opt.gamma = 0.999999999
                    else:
                        if (self.opt.gamma <= 0.0):
                            self.opt.gamma = 1e-07

                if not hasattr(self.opt, 'eta'):
                    self.opt.eta = 0.1
                else:
                    if (self.opt.eta >= 1.0):
                        self.opt.eta = 0.999999999
                    else:
                        if (self.opt.eta <= self.opt.gamma):
                            self.opt.eta = self.opt.gamma * 1.1
                        # end if
                    # end if
                # end if

                if (self.opt.eta >= 1.0):
                    self.opt.eta = 0.999999999
                else:
                    if (self.opt.eta <= self.opt.gamma):
                        self.opt.eta = self.opt.gamma * 1.1
                    # end if
                # end if
            # end if
        # end if

        # BFGS mit Straffunktion
        if ((self.opt.type == self.TYPE_QUASI_NEWTON_PENALITY)):
            if not hasattr(self.opt, 'P'):
                raise Exception('opt.P fehlt sie Beschreibung')
            # end if
            if not hasattr(self.opt, 'Penality'):
                raise Exception('opt.Penality fehlt sie Beschreibung')
            # end if
        # end if

        # Trust-Region-Verfahren
        if ((self.opt.type == self.TYPE_TRUST_REGION) or (self.opt.type == self.TYPE_TRUST_REGION_WEDGE)):
            if not hasattr(self.opt, 'deltamin'):
                self.opt.deltamin = 10 * 1e-16

            self.opt.deltamin = abs(self.opt.deltamin)

            if (self.opt.deltamin == 0.0):
                raise Exception('Trust-Region: deltamin muss im Bereich liegen (deltamin > 0.0)')

            if not hasattr(self.opt, 'delta0'):
                self.opt.delta0 = 1.0

            if (self.opt.delta0 <= self.opt.deltamin):
                raise Exception('Trust-Region: delta0(%f) muss im Bereich gr��er deltmin(%f) liegen (delta0 > deltamin)',self.opt.delta0,self.opt.deltamin)

            if not hasattr(self.opt, 'rho1'):
                self.opt.rho1 = 0.25

            if not hasattr(self.opt, 'rho2'):
                self.opt.rho2 = 0.75

            if ((self.opt.rho1 <= 0.0) or (self.opt.rho2 >= 1.0) or (self.opt.rho2 <= self.opt.rho1)):
                raise Exception('Trust-Region: rho1,rho2 muss im Bereich liegen (0 < rho1(%f) < rho2(%f) < 1)',self.opt.rho1,self.opt.rho2)

            if not hasattr(self.opt, 'sigma1'):
                self.opt.sigma1 = 0.5

            if not hasattr(self.opt, 'sigma2'):
                self.opt.sigma2 = 2.0

            if ((self.opt.sigma1 <= 0.0) or (self.opt.sigma1 >= 1.0)):
                raise Exception('Trust-Region: sigma1 muss im Bereich liegen (0 < sigma1(%f) <  1)',self.opt.sigma1)

            if ((self.opt.sigma2 <= 1.0)):
                raise Exception('Trust-Region: sigma2 muss im Bereich liegen (1 < sigma2(%f) )',self.opt.sigma2)

            # self.opt.TP_itermax maximale Iterationsloop des Teilproblems (def 100)
            if not hasattr(self.opt, 'TP_itermax') :
                self.opt.TP_itermax = 1000

            self.opt.TP_itermax = abs(self.opt.TP_itermax)

            # self.opt.TP_rtol    relative Toleranz Teilproblem (def eps)
            if not hasattr(self.opt, 'TP_rtol'):
                self.opt.TP_rtol = 1e-16

            self.opt.TP_rtol = abs(self.opt.TP_rtol)

            # self.opt.TP_atol    absolute Toleranz Teilproblem (def eps)
            if not hasattr(self.opt, 'TP_atol'):
                self.opt.TP_atol = 1e-16

            self.opt.TP_atol = abs(self.opt.TP_atol)

            # self.opt.TP_par     Unbekannt  zu TeilProblem (def 0)
            if not hasattr(self.opt, 'TP_par'):
                self.opt.TP_par = 0
        # end if

        # Anzahl der Variablen
        self.opt.n = len(self.opt.x0)
        self.opt.xs = np.copy(self.opt.x0)

        if not hasattr(self.opt, 'func') :
            raise Exception('Functioncall opt.func  (f=funx(x)) not defined in option-structure')

        if hasattr(self.opt, 'use_df_func'):
            if (self.opt.use_df_func):
                if not hasattr(self.opt, 'dfunc'):
                    raise Exception('differentiation of func opt.dfunc not defined in option-structure')
                # end if
            # end if
        else:
            if hasattr(self.opt, 'dfunc'):
                self.opt.use_df_func = 1
            else:
                self.opt.use_df_func = 0
            # end if
        # end if

        if self.opt.use_df_func:
            if not hasattr(self.opt, 'dfunc') :
                raise Exception('differentiation of func opt.dfunc not defined in option-structure')
            # end if
        # end if

        # B0/H0 BFGS-Verfahren und Trust-Region
        if ((self.opt.type == self.TYPE_QUASI_NEWTON) or
            (self.opt.type == self.TYPE_TRUST_REGION) or
            (self.opt.type == self.TYPE_QUASI_NEWTON_PENALITY)):

            # Festlegung, wie Ableitung berechnet wird

            # Berechnung Ableitung mit Anfangswert
            #-----------------------------------------
            if hasattr(self.opt, 'use_H_func'):
                if (self.opt.use_H_func):
                    if not hasattr(self.opt, 'use_H_func'):
                        raise Exception('analytical Hesse-Matrix calculation function opt.Hfunc not defined in option-structure')
            else:
                if hasattr(self.opt, 'Hfunc'):
                    self.opt.use_H_func = 1
                else:
                    self.opt.use_H_func = 0
                # end if
            # end if
        else:
            self.opt.use_H_func = 0
        # end if

        if hasattr(self.opt, 'x_int_def'):

            if self.opt.type != self.TYPE_STEILSTER_ABSTIEG:
                self.status = hdef.NOT_OKAY
                self.errtext = f"Wenn x_int_def definiert (integer Rechnung) dann self.opt.type = TYPE_STEILSTER_ABSTIEG {self.TYPE_STEILSTER_ABSTIEG} sein"
                return
            # end if

            self.opt.int_def_dict_list = []
            self.opt.int_def_flag = True
            self.opt.int_sk = np.copy(self.opt.x0) * 0.0

            # sammelt alle Ergebnisse um Rechenzeit zu sparen
            self.opt.int_erg_lliste = []
            # sammelt nur die im Hauptmodul errechneten Funtionswerte, damit wird auf doppelt gesucht
            self.opt.int_func_lliste = []

            if hasattr(self.opt, 'int_json_file'):
                self.opt.int_jsonobj  = hio.DataJson(hfp.add_to_filebody("int_erg_lliste_",self.opt.int_json_file,""))
            else:
                self.opt.int_jsonobj = None
            # end if

            if len(self.opt.x_int_def) != self.opt.n:
                self.status = hdef.NOT_OKAY
                self.errtext = f"len(self.opt.x_int_def) != self.opt.n, n = {self.opt.n}  x_int_def: {self.opt.x_int_def}"
                return
            # end if
            for i in range(self.opt.n):

                x_def_dict = self.opt.x_int_def[i]

                key = "format"
                if key not in x_def_dict.keys():
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"Definition dict von self.opt.x_int_def[{i}] enthält kein key= {key}"
                    return
                # end if

                format = x_def_dict[key]

                if format not in ["int","float"]:
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"Definition self.opt.x_int_def[{i}]{'format':val} musss 'int' oder 'float' sein "
                    return

                key = "res"
                if key not in x_def_dict.keys():
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"Definition dict von self.opt.x_int_def[{i}] enthält kein key= {key}"
                    return
                # end if

                res  = x_def_dict[key]

                key = "xmin"
                if key in x_def_dict.keys():

                    (xmin, rest, intxmin) = bilde_int_mit_res(x_def_dict[key],res)

                else:
                    xmin = None
                    intxmin = None
                # end if

                key = "xmax"
                if key in x_def_dict.keys():

                    (xmax, rest, intxmax) = bilde_int_mit_res(x_def_dict[key], res)

                else:
                    xmax = None
                    intxmax = None
                # end if

                self.opt.int_def_dict_list.append({"format":format,
                                                   "res":res,
                                                   "xmin":xmin,
                                                   "intxmin":intxmin,
                                                   "xmax":xmax,
                                                   "intxmax":intxmax,
                                                   "x":0.0,"intx":0,"rest":0.0})
            # end if
        else:
            self.opt.int_def_flag = False
        # end if



        return
    # end def
    def check_functions(self):

        if self.opt.int_def_flag:
            self.opt.xs = self.set_xmin_xmax(np.copy(self.opt.x0))
        else:
            self.opt.xs = np.copy(self.opt.x0)
        # end if

        # Function
        #---------
        try:
            if self.opt.int_def_flag:
                self.opt.f = self.func_integer(self.opt.xs)
            else:
                self.opt.f = self.opt.func(self.opt.xs)
            # end if
        except:
            self.status = hdef.NOT_OKAY
            self.errtext = f"Die Funktion opt.func(opt.x0) kann nicht ausgeführt werden"
            return
        # end try

        # Ableitung
        #----------
        if (self.opt.use_df_func):
            try:
                if self.opt.int_def_flag:
                    self.opt.df = self.dfunc_integer(self.opt.xs)
                else:
                    self.opt.df = self.opt.dfunc(self.opt.xs)
            except:
                self.status = hdef.NOT_OKAY
                self.errtext = f"Die Ableitung opt.dfunc(opt.x0) kann nicht ausgeführt werden"
                return
            finally:
                pass
            if (len(self.opt.df) != self.opt.n):
                self.status = hdef.NOT_OKAY
                self.errtext = f"Länge Ergbnisvektor der Ableitungsfunktion opt.dfunc ist nicht gleich n={self.opt.n} (aus opt.x0)"
                return
            # end if
        else:
            if self.opt.int_def_flag:
                self.opt.df = self.optnlin_nbegrenzt_build_df_int(self.opt.xs,self.opt.f)
            else:
                self.opt.df = self.optnlin_nbegrenzt_build_df()
        # end if

        # B0/H0 BFGS-Verfahren und Trust-Region
        if ((self.opt.type == self.TYPE_QUASI_NEWTON) or
            (self.opt.type == self.TYPE_TRUST_REGION) or
            (self.opt.type == self.TYPE_QUASI_NEWTON_PENALITY)):

            # Hesse-Matrix
            #-------------
            if self.opt.use_H_func == 1:
                try:
                    self.opt.H0 = self.opt.Hfunc(self.opt.x0)
                except:
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"Die Hesse-Matrix opt.Hfunc(opt.x0) kann nicht ausgeführt werden"
                    return
                finally:
                    pass
                n,m = self.opt.H0.shape
                if (n != self.opt.n) or (m != self.opt.n):
                    self.status = hdef.NOT_OKAY
                    self.errtext = f"Länge Ergbnismatrix der Hessefunktion opt.Hfunc ist nicht gleich n={self.opt.n} ({n}x{m}) (aus opt.x0)"
                    return
                # end if

                self.opt.B0 = np.linalg.inv(self.opt.H0)
            else:

                if hasattr(self.opt, 'H0'):
                    self.opt.B0 = np.linalg.inv(self.opt.H0)
                else:
                    (H0, B0) = self.optnlin_nbegrenzt_build_H0()
                    self.opt.H0 = copy.copy(H0)
                    self.opt.B0 = copy.copy(B0)
                # end if
            # end if

            # B0 prüfen
            try:
                R,p = scipy.linalg.cho_factor(self.opt.B0)
                if p != False:
                    self.opt.B0 = np.eye(self.opt.n)
                # end if
            except:
                self.opt.B0 = np.eye(self.opt.n)
            # end try
        # end if


        return
    # end def
    def optimize(self,
                 opt,
                 x0,
                 func,
                 dfunc =None,
                 Hfunc =None):

        self.opt = copy.copy(opt)
        self.opt.x0 = x0
        self.opt.func = func
        if dfunc is not None:
            self.opt.dfunc = dfunc
        if Hfunc is not None:
            self.opt.Hfunc = Hfunc

        self.check_opt()

        if self.status != hdef.OKAY:
            self.opt.status = self.status
            self.opt.errtext = self.errtext
            return self.opt

        self.check_functions()

        if self.status != hdef.OKAY:
            self.opt.status = self.status
            self.opt.errtext = self.errtext
            return self.opt


        match self.opt.type:
            case self.TYPE_STEILSTER_ABSTIEG:
                if self.opt.int_def_flag:

                    self.steilsterAbstiegInteger()
                else:
                    self.steilsterAbstieg()

            case self.TYPE_QUASI_NEWTON:

                self.opt.flag_penality = 0
                self.BFGS()

            case self.TYPE_TRUST_REGION:

                self.TrustRegion()

            case self.TYPE_TRUST_REGION_WEDGE:

                self.TrustRegionWedge()

            case self.TYPE_QUASI_NEWTON_PENALITY:
                self.opt.flag_penality = 1
                self.BFGS()
        # end match

        self.opt.status = self.status
        self.opt.errtext = self.errtext

        return self.opt
    # end def
    def steilsterAbstieg(self):

        self.log.write_info('Methode steilsten Abstieg')
        if self.opt.stype == 0:
            self.log.write_info(' mit Armaijo-Regel (Schrittweitensteuerung)\n')
        else:
            self.log.write_info(' mit Powell-Wolfe (Schrittweitensteuerung)\n')

        # Zähler Iteration
        self.opt.k = 0
        self.opt.inform = 0

        # Ausgabezähler
        kout = np.round(self.opt.kmax / 100)
        if (kout == 0):
            kout = 1

        # Betrag der Ableitung aus Startwert
        self.opt.df_norm = np.linalg.norm(self.opt.df)
        if (self.opt.df_norm <= self.opt.err):
            findflag = 1
        else:
            findflag = 0

        sigmak = 0.0
        while ((self.opt.k < self.opt.kmax) and not findflag):

            # Anzeige
            if (self.opt.k < 10) or (np.mod(self.opt.k, kout) == 0):

                self.log.write_info("k = %i f = %20.5g err = %20.5g sigma = %20.5g" % (self.opt.k, self.opt.f, self.opt.df_norm, sigmak))
                for ii in range(self.opt.n):
                    self.log.write_info("x%i = %g" % (ii, self.opt.xs[ii]))
                # end for
            # end if

            self.opt.k = self.opt.k + 1
            sk = self.opt.df * (- 1.0)

            # Armaijo-Regel
            if self.opt.stype == 0:
                sigmak = self.optnlin_nbegrenzt_Armijo( sk)
            else:
                sigmak = self.optnlin_nbegrenzt_PowellWolfe( sk)
            # end if

            if self.status != hdef.OKAY:
                return
            self.opt.xs = self.opt.xs + sigmak * sk
            self.opt.f = self.opt.func(self.opt.xs)
            if self.opt.use_df_func:
                self.opt.df = self.opt.dfunc(self.opt.xs)
            else:
                self.opt.df = self.optnlin_nbegrenzt_build_df()
            # end def
            self.opt.df_norm = np.linalg.norm(self.opt.df)
            if (self.opt.df_norm <= self.opt.err):
                findflag = 1

        self.log.write_info("> k = %i f = %20.5g err = %20.5g sigma = %20.5g"% ( self.opt.k, self.opt.f, self.opt.df_norm, sigmak) )
        for i in range(self.opt.n):
            self.log.write_info("x%s = %f" % ( str(i), self.opt.xs[i]))

        if self.opt.k >= self.opt.kmax:
            self.opt.okay = 0
            self.opt.inform = 2
            self.opt.errtext = 'steilster Abstieg: maximale Anzahl der Interationen erreicht'
        # end if
        return

    # end def
    def steilsterAbstiegInteger(self):

        self.log.write_info('Methode steilsten Abstieg für Integer Größen')
        if self.opt.stype == 0:
            self.log.write_info(' mit Armaijo-Regel (Schrittweitensteuerung)\n')
        else:
            self.log.write_info(' mit Powell-Wolfe (Schrittweitensteuerung)\n')

        # Zähler Iteration
        self.opt.k = 0
        self.opt.inform = 0

        # Ausgabezähler
        kout = np.round(self.opt.kmax / 100)
        if (kout == 0):
            kout = 1

        # Betrag der Ableitung aus Startwert
        self.opt.df_norm = np.linalg.norm(self.opt.df)
        if (self.opt.df_norm <= self.opt.err):
            self.log.write_info(f'MinValue found by df_norm = {self.opt.df_norm}')
            findflag = 1
        else:
            findflag = 0

        sigmak = 0.0
        while ((self.opt.k < self.opt.kmax) and not findflag):

            if self.opt.k >= 5:
                a = 0

            # Anzeige
            # if (self.opt.k < 10) or (np.mod(self.opt.k, kout) == 0):

            self.log.write_info("k = %i f = %20.5g err = %20.5g sigma = %20.5g" % (self.opt.k, self.opt.f, self.opt.df_norm, sigmak))
            for ii in range(self.opt.n):
                self.log.write_info("x%i = %g" % (ii, self.opt.xs[ii]))
            # end for
            # end if

            self.opt.k = self.opt.k + 1

            # Abstiegsrichtung
            sk = self.opt.df * (- 1.0)

            self.opt.int_sk = np.copy(sk)

            # Armaijo-Regel
            if self.opt.stype == 0:
                sigmak = self.optnlin_nbegrenzt_Armijo_int( sk)
            else:
                sigmak = self.optnlin_nbegrenzt_PowellWolfe_int( sk)
            # end if

            if self.status != hdef.OKAY:
                return

            self.opt.xs = self.set_xmin_xmax(self.opt.xs + sigmak * sk)

            # self.opt.xs = self.opt.xs + sigmak * sk
            self.opt.f = self.func_integer(self.opt.xs)
            self.add_func_ergebnisse( self.opt.xs, self.opt.f)

            if self.opt.use_df_func:
                self.opt.df = self.dfunc_integer()
            else:
                self.opt.df = self.optnlin_nbegrenzt_build_df_int(self.opt.xs,self.opt.f)
            # end def
            self.opt.df_norm = np.linalg.norm(self.opt.df)
            if (self.opt.df_norm <= self.opt.err):
                self.log.write_info(f'MinValue found by df_norm = {self.opt.df_norm}')
                findflag = 1

            # seacrh if twice same result
            if self.exist_double_values_in_result_liste():
                self.log.write_info(f'MinValue found by double value')
                findflag = 1

        self.find_and_set_fmin_value()

        self.log.write_info("> k = %i f = %20.5g err = %20.5g sigma = %20.5g"% ( self.opt.k, self.opt.f, self.opt.df_norm, sigmak) )
        for i in range(self.opt.n):
            self.log.write_info("x%s = %f" % ( str(i), self.opt.xs[i]))

        if self.opt.k >= self.opt.kmax:
            self.opt.okay = 0
            self.opt.inform = 2
            self.opt.errtext = 'steilster Abstieg: maximale Anzahl der Interationen erreicht'
        # end if
        return

    # end def
    def BFGS(self):

        self.log.write_info('Methode Quasi-Newton-Verfahren')
        if self.opt.type == 4:
            self.log.write_info(' mit Straffunktion')

        if self.opt.stype == 0:
            self.log.write_info(' mit Armaijo-Regel (Schrittweitensteuerung)\n')
        else:
            self.log.write_info(' mit Powell-Wolfe (Schrittweitensteuerung)\n')

        # Zähler Iteration
        self.opt.k = 0
        self.opt.inform = 0
        # Ausgabez�hler
        kout = np.round(self.opt.kmax / 100)
        if (kout == 0):
            kout = 1

        # Betrag der Ableitung aus Startwert
        self.opt.df_norm = np.linalg.norm(self.opt.df)
        if (self.opt.df_norm <= self.opt.err):
            findflag = 1
        else:
            findflag = 0

        sigmak = 0.0
        self.opt.Bk = np.copy(self.opt.B0)
        while ((self.opt.k < self.opt.kmax) and not findflag):

            # Anzeige
            if ((self.opt.k < 10) or (np.mod(self.opt.k, kout) == 0)):

                self.log.write_info("k = %i f = %20.5g err = %20.5g sigma = %20.5g" % (self.opt.k, self.opt.f, self.opt.df_norm, sigmak))
                for ii in range(self.opt.n):
                    self.log.write_info('x%i = %g;' % ( ii, self.opt.xs[ii]))

            self.opt.k = self.opt.k + 1

            # Suchrichtung
            sk = - np.matmul(self.opt.Bk , self.opt.df)

            # Armaijo-Regel
            if (self.opt.stype == 0):
                sigmak = self.optnlin_nbegrenzt_Armijo_BFGS(sk)
            else:
                sigmak = self.optnlin_nbegrenzt_PowellWolfe_BFGS(sk)
            # end if
            if self.status != hdef.OKAY:
                return
            # end if

            # Differenzbildung alter Wert
            self.opt.xs_last = np.copy(self.opt.xs)
            self.opt.df_last = np.copy(self.opt.df)
            self.opt.xs = self.opt.xs + sigmak * sk
            self.opt.f = self.optnlin_nbegrenzt_BFGS_func(self.opt.xs)
            if (self.opt.use_df_func):
                self.opt.df = self.opt.dfunc(self.opt.xs)
            else:
                self.opt.df = self.optnlin_nbegrenzt_build_df()
            self.opt.df_norm = np.linalg.norm(self.opt.df)
            if (self.opt.df_norm <= self.opt.err):
                findflag = 1
            else:
                if (self.opt.use_df_func):
                    self.opt.Hk = self.opt.Hfunc(self.opt.xs)
                    R, p = scipy.linalg.cho_factor(self.opt.Hk)
                    if (p != 0):
                        self.opt.status = hdef.NOT_OKAY
                        self.errtext    = "Quasi-Newton Matrix Bk = inv(Hk) singular"
                        self.opt.inform = 6
                        return
                    else:
                        self.opt.Bk = np.linalg.inv(self.opt.Hk)
                else:
                    # Differenzbildung mit neuem Wert
                    dk = self.opt.xs - self.opt.xs_last
                    yk = self.opt.df - self.opt.df_last
                    # Berechnung Bk
                    dBy = dk - np.matmul(self.opt.Bk , yk)
                    dy = np.dot(dk , yk)
                    if (np.abs(dy) < 1e-16):
                        self.status = hdef.NOT_OKAY
                        self.errtext = "Quasi-Newton Matrix Bk = inv(Hk) singular"
                        self.opt.inform = 6
                        return
                    # dy = eps * sign(dy);
                    B1 = (np.outer(dBy , dk) + np.outer(dk , dBy)) / dy
                    b  = (np.dot(dBy,yk)/dy/dy)*dk
                    B2 = np.outer(b , dk)
                    self.opt.Bk = self.opt.Bk + B1 - B2

        self.log.write_info( '=> k = %i f = %20.5g err = %20.5g sigma = %20.5g' % (self.opt.k, self.opt.f, self.opt.df_norm, sigmak))
        for i in range(self.opt.n):
            self.log.write_info(  "x%s = %f" % ( str(i), self.opt.xs[i]))

        if (self.opt.k >= self.opt.kmax):
            self.status = hdef.NOT_OKAY
            self.opt.inform = 2
            self.errtext = 'Quasi-Newton maximale Anzahl der Interationen erreicht'
        # end if
        return

    def optnlin_nbegrenzt_Armijo(self,sk):
        i = 0
        fac = self.opt.gamma * np.matmul(np.transpose(self.opt.df) , sk)
        sigmak = 1.0
        delta = (self.opt.func(self.opt.xs + sigmak * sk) - self.opt.f)
        val = sigmak * self.opt.gamma * np.matmul(np.transpose(self.opt.df) , sk)
        while ((delta > val) and i < 100):

            i = i + 1
            sigmak = sigmak * self.opt.beta
            delta = (self.opt.func(self.opt.xs + sigmak * sk) - self.opt.f)
            val = sigmak * fac


        if (i >= 100):
            self.opt.okay = 0
            self.opt.errtext = 'Schrittweitensteuerung Armijo-Regel > 100 Iterationen'

        return sigmak
    # end def
    def optnlin_nbegrenzt_PowellWolfe(self,sk):
        sw = 1
        while (sw < 6):

            if 1 == (sw):
                sigmak = 1.0
                delta = (self.opt.func(self.opt.xs + sigmak * sk) - self.opt.f)
                val = sigmak * self.opt.gamma * np.matmul(np.transpose(self.opt.df) , sk)
                if (delta <= val):
                    sw = 3
                else:
                    sw = 2
            else:
                if 2 == (sw):
                    i = 0
                    sigmam = 2 ** - (i + 1)
                    delta = (self.opt.func(self.opt.xs + sigmam * sk) - self.opt.f)
                    val = sigmam * self.opt.gamma * np.matmul(np.transpose(self.opt.df) , sk)
                    while (delta > val and i < 100):
                        i = i + 1
                        sigmam = 2 ** - (i + 1)
                        delta = (self.opt.func(self.opt.xs + sigmam * sk) - self.opt.f)
                        val = sigmam * self.opt.gamma * np.matmul(np.transpose(self.opt.df) , sk)

                    if (i >= 100):
                        self.okay = 0
                        self.errtext = 'Schrittweitensteuerung(2) Powell-Wolfe-Regel > 100 Iterationen'
                        return sigmak
                    sigmap = 2.0 * sigmam
                    sw = 5
                else:
                    if 3 == (sw):
                        if (self.opt.use_df_func):
                            val1 = np.dot( (self.opt.dfunc(self.opt.xs + sigmak * sk)) , sk)
                        else:
                            val1 = np.dot((self.optnlin_nbegrenzt_build_df(self.opt.xs + sigmak * sk)) , sk)
                        # end if
                        val2 = self.opt.eta * np.dot(self.opt.df , sk)
                        if (val1 >= val2):
                            sw = 6
                        else:
                            sw = 4
                    else:
                        if 4 == (sw):
                            i = 0
                            sigmap = 2 ** (i + 1)
                            delta = (self.opt.func(self.opt.xs + sigmap * sk) - self.opt.f)
                            val = sigmap * self.opt.gamma * np.matmul(np.transpose(self.opt.df) , sk)
                            while (delta <= val and i < 100):
                                i = i + 1
                                sigmap = 2 ** (i + 1)
                                delta = (self.opt.func(self.opt.xs + sigmap * sk) - self.opt.f)
                                val = sigmap * self.opt.gamma * np.matmul(np.transpose(self.opt.df) , sk)

                            if (i >= 100):
                                self.okay = 0
                                self.errtext = 'Schrittweitensteuerung(4) Powell-Wolfe-Regel > 100 Iterationen'
                                return opt, sigmak
                            sigmam = 0.5 * sigmap
                            sw = 5
                        else:
                            if 5 == (sw):
                                i = 0
                                sigmak = sigmam
                                if (self.opt.use_df_func):
                                    v = self.opt.dfunc(self.opt.xs + sigmak * sk)
                                    val1 = np.matmul(np.transpose(v) , sk)
                                else:
                                    v = self.optnlin_nbegrenzt_build_df(self.opt.xs + sigmak * sk)
                                    val1 = np.matmul(np.transpose(v) , sk)
                                val2 = self.opt.eta * np.matmul(np.transpose(self.opt.df) , sk)
                                while (val1 < val2 and i < 100):

                                    i = i + 1
                                    sigmak = (sigmam + sigmap) * 0.5
                                    delta = (self.opt.func(self.opt.xs + sigmak * sk) - self.opt.f)
                                    val = sigmak * self.opt.gamma * np.matmul(np.transpose(self.opt.df) , sk)
                                    if (delta <= val):
                                        sigmam = sigmak
                                    else:
                                        sigmap = sigmak
                                    sigmak = sigmam
                                    if (self.opt.use_df_func):
                                        v = self.opt.dfunc(self.opt.xs + sigmak * sk)
                                        val1 = np.matmul(np.transpose(v) , sk)
                                    else:
                                        v = self.optnlin_nbegrenzt_build_df(self.opt.xs + sigmak * sk)
                                        val1 = np.matmul(np.transpose(v) , sk)
                                    val2 = self.opt.eta * np.matmul(np.transpose(self.opt.df) , sk)

                                if (i >= 100):
                                    self.opt.okay = 0
                                    self.opt.errtext = 'Schrittweitensteuerung(5) Powell-Wolfe-Regel > 100 Iterationen'
                                    return opt, sigmak
                                sigmak = sigmam
                                sw = 6

        return sigmak
    # end def
    def optnlin_nbegrenzt_Armijo_int(self,sk):
        i = 0
        fac = self.opt.gamma * np.dot(self.opt.df , sk)
        sigmak = 1.0
        xs = np.copy(self.opt.xs + sigmak * sk)
        xs = self.set_xmin_xmax(xs)
        f  = self.func_integer(xs)
        delta = f - self.opt.f
        val = sigmak * self.opt.gamma * np.dot(self.opt.df , sk)
        while ((delta > val) and i < 10):

            i = i + 1
            sigmak = sigmak * self.opt.beta
            xs = np.copy(self.opt.xs + sigmak * sk)
            xs = self.set_xmin_xmax(xs)
            f = self.func_integer(xs)
            delta = f - self.opt.f
            val = sigmak * fac


        if (i >= 10):
            self.opt.okay = 0
            self.opt.errtext = 'Schrittweitensteuerung Armijo-Regel > 10 Iterationen'

        return sigmak
    # end def
    def optnlin_nbegrenzt_PowellWolfe_int(self,sk):
        sw = 1
        while (sw < 6):

            if 1 == (sw):
                sigmak = 1.0
                xs = np.copy(self.opt.xs + sigmak * sk)
                xs = self.set_xmin_xmax(xs)
                f = self.func_integer(xs)
                delta = f - self.opt.f
                val = sigmak * self.opt.gamma * np.dot(self.opt.df , sk)
                if (delta <= val):
                    sw = 3
                else:
                    sw = 2
            else:
                if 2 == (sw):
                    i = 0
                    sigmam = 2 ** - (i + 1)
                    xs = np.copy(self.opt.xs + sigmam * sk)
                    xs = self.set_xmin_xmax(xs)
                    f = self.func_integer(xs)
                    delta = f - self.opt.f
                    val = sigmam * self.opt.gamma * np.dot(self.opt.df , sk)
                    while (delta > val and i < 100):
                        i = i + 1
                        sigmam = 2 ** - (i + 1)
                        xs = np.copy(self.opt.xs + sigmam * sk)
                        xs = self.set_xmin_xmax(xs)
                        f = self.func_integer(xs)
                        delta = f - self.opt.f
                        val = sigmam * self.opt.gamma * np.dot(self.opt.df , sk)

                    if (i >= 100):
                        self.okay = 0
                        self.errtext = 'Schrittweitensteuerung(2) Powell-Wolfe-Regel > 100 Iterationen'
                        return sigmak
                    sigmap = 2.0 * sigmam
                    sw = 5
                else:
                    if 3 == (sw):
                        xs = np.copy(self.opt.xs + sigmak * sk)
                        xs = self.set_xmin_xmax(xs)
                        if self.opt.use_df_func:
                            df = self.dfunc_integer(xs)
                        else:
                            df = self.optnlin_nbegrenzt_build_df_int(xs,self.opt.f)
                        # end def
                        val1 = np.dot(df, sk)
                        val2 = self.opt.eta * np.dot(self.opt.df , sk)
                        if (val1 >= val2):
                            sw = 6
                        else:
                            sw = 4
                    else:
                        if 4 == (sw):
                            i = 0
                            sigmap = 2 ** (i + 1)
                            xs = np.copy(self.opt.xs + sigmap * sk)
                            xs = self.set_xmin_xmax(xs)
                            f = self.func_integer(xs)
                            delta = f - self.opt.f
                            val = sigmap * self.opt.gamma * np.dot(self.opt.df , sk)
                            while (delta <= val and i < 100):
                                i = i + 1
                                sigmap = 2 ** (i + 1)
                                xs = np.copy(self.opt.xs + sigmap * sk)
                                xs = self.set_xmin_xmax(xs)
                                f = self.func_integer(xs)
                                delta = f - self.opt.f
                                val = sigmap * self.opt.gamma * np.dot(self.opt.df , sk)

                            if (i >= 100):
                                self.okay = 0
                                self.errtext = 'Schrittweitensteuerung(4) Powell-Wolfe-Regel > 100 Iterationen'
                                return opt, sigmak
                            sigmam = 0.5 * sigmap
                            sw = 5
                        else:
                            if 5 == (sw):
                                i = 0
                                sigmak = sigmam
                                xs = np.copy(self.opt.xs + sigmak * sk)
                                xs = self.set_xmin_xmax(xs)
                                if self.opt.use_df_func:
                                    df = self.dfunc_integer(xs)
                                else:
                                    df = self.optnlin_nbegrenzt_build_df_int(xs, self.opt.f)
                                # end def
                                val1 = np.dot(df, sk)
                                val2 = self.opt.eta * np.dot(self.opt.df , sk)
                                while (val1 < val2 and i < 100):

                                    i = i + 1
                                    sigmak = (sigmam + sigmap) * 0.5
                                    xs = np.copy(self.opt.xs + sigmak * sk)
                                    xs = self.set_xmin_xmax(xs)
                                    f = self.func_integer(xs)
                                    delta = f - self.opt.f
                                    val = sigmak * self.opt.gamma * np.dot(self.opt.df , sk)
                                    if (delta <= val):
                                        sigmam = sigmak
                                    else:
                                        sigmap = sigmak
                                    sigmak = sigmam
                                    xs = np.copy(self.opt.xs + sigmak * sk)
                                    xs = self.set_xmin_xmax(xs)
                                    if self.opt.use_df_func:
                                        df = self.dfunc_integer(xs)
                                    else:
                                        df = self.optnlin_nbegrenzt_build_df_int(xs, self.opt.f)
                                    # end def
                                    val1 = np.dot(df, sk)
                                    val2 = self.opt.eta * np.dot(self.opt.df , sk)

                                if (i >= 100):
                                    self.opt.okay = 0
                                    self.opt.errtext = 'Schrittweitensteuerung(5) Powell-Wolfe-Regel > 100 Iterationen'
                                    return opt, sigmak
                                sigmak = sigmam
                                sw = 6

        return sigmak
    # end def
    def optnlin_nbegrenzt_Armijo_BFGS(self, sk=None):
        i = 0
        fac = opt.gamma * np.dot(self.opt.df , sk)
        sigmak = 1.0
        delta = (self.optnlin_nbegrenzt_BFGS_func(self.opt.xs + sigmak * sk) - self.opt.f)
        val = sigmak * opt.gamma * np.dot(self.opt.df , sk)

        while ((delta > val) and i < 100):
            i = i + 1
            sigmak = sigmak * self.opt.beta
            delta = (self.optnlin_nbegrenzt_BFGS_func(self.opt.xs + sigmak * sk) - self.opt.f)
            val = sigmak * fac

        if (i >= 100):
            self.status = hdef.NOT_OKAY
            self.errtext = 'Schrittweitensteuerung Armijo-Regel > 100 Iterationen'

        return sigmak

    def optnlin_nbegrenzt_PowellWolfe_BFGS(self, sk=None):

        sigmak = 0.0
        sw = 1
        while (sw < 6):

            if 1 == (sw):
                sigmak = 1.0
                delta = (self.optnlin_nbegrenzt_BFGS_func(self.opt.xs + sigmak * sk) - self.opt.f)
                val = sigmak * self.opt.gamma * np.dot(self.opt.df , sk)
                if (delta <= val):
                    sw = 3
                else:
                    sw = 2
            else:
                if 2 == (sw):
                    i = 0
                    sigmam = 2 ** (- (i + 1))
                    delta = (self.optnlin_nbegrenzt_BFGS_func(self.opt.xs + sigmam * sk) - self.opt.f)
                    val = sigmam * self.opt.gamma * np.dot(self.opt.df , sk)
                    while (delta > val and i < 100):
                        i = i + 1
                        sigmam = 2 ** (- (i + 1))
                        delta = (self.optnlin_nbegrenzt_BFGS_func(self.opt.xs + sigmam * sk) - self.opt.f)
                        val = sigmam * self.opt.gamma * np.dot(self.opt.df , sk)

                    if (i >= 100):
                        self.status = hdef.NOT_OKAY
                        self.errtext = 'Schrittweitensteuerung(2) Powell-Wolfe-Regel > 100 Iterationen'
                        return sigmak
                    sigmap = 2.0 * sigmam
                    sw = 5
                else:
                    if 3 == (sw):
                        if (self.opt.use_df_func):
                            val1 = np.dot(self.opt.dfunc(self.opt.xs + sigmak * sk) , sk)
                        else:
                            val1 = np.dot(self.optnlin_nbegrenzt_build_df(self.opt.xs + sigmak * sk) , sk)
                        val2 = opt.eta * np.dot(self.opt.df , sk)
                        if val1 >= val2:
                            sw = 6
                        else:
                            sw = 4
                    else:
                        if 4 == sw:
                            i = 0
                            sigmap = 2 ** (i + 1)
                            delta = (self.optnlin_nbegrenzt_BFGS_func(self.opt.xs + sigmap * sk) - self.opt.f)
                            val = sigmap * opt.gamma * np.dot(self.opt.df , sk)
                            while (delta <= val and i < 100):
                                i = i + 1
                                sigmap = 2 ** (i + 1)
                                delta = (self.optnlin_nbegrenzt_BFGS_func(self.opt.xs + sigmap * sk) - self.opt.f)
                                val = sigmap * opt.gamma * np.dot(self.opt.df , sk)

                            if (i >= 100):
                                self.status = hdef.NOT_OKAY
                                self.errtext = 'Schrittweitensteuerung(4) Powell-Wolfe-Regel > 100 Iterationen'
                                return sigmak
                            sigmam = 0.5 * sigmap
                            sw = 5
                        else:
                            if 5 == (sw):
                                i = 0
                                sigmak = sigmam
                                if (self.opt.use_df_func):
                                    v = self.opt.dfunc(self.opt.xs + sigmak * sk)
                                    val1 = np.dot(v , sk)
                                else:
                                    v = self.optnlin_nbegrenzt_build_df(self.opt.xs + sigmak * sk)
                                    val1 = np.dot(v , sk)
                                val2 = opt.eta * np.dot(self.opt.df , sk)
                                while (val1 < val2 and i < 100):

                                    i = i + 1
                                    sigmak = (sigmam + sigmap) * 0.5
                                    delta = (self.optnlin_nbegrenzt_BFGS_func(self.opt.xs + sigmak * sk) - self.opt.f)
                                    val = sigmak * opt.gamma * np.dot(self.opt.df , sk)
                                    if (delta <= val):
                                        sigmam = sigmak
                                    else:
                                        sigmap = sigmak
                                    sigmak = sigmam
                                    if (self.opt.use_df_func):
                                        v = self.opt.dfunc(self.opt.xs + sigmak * sk)
                                        val1 = np.dot(v , sk)
                                    else:
                                        v = self.optnlin_nbegrenzt_build_df(self.opt.xs + sigmak * sk)
                                        val1 = np.dot(v , sk)
                                    val2 = opt.eta * np.dot(self.opt.df , sk)

                                if (i >= 100):
                                    self.status = hdef.NOT_OKAY
                                    self.errtext = 'Schrittweitensteuerung(5) Powell-Wolfe-Regel > 100 Iterationen'
                                    return sigmak
                                sigmak = sigmam
                                sw = 6
        # end while
        return sigmak
    # end def
    def optnlin_nbegrenzt_build_df(self, xs=None):


        df = np.copy(self.opt.xs) * 0.0   # np.array([0.0 for i in range(len(self.opt.xs))])

        if xs is None:
            f0 = self.opt.f
            x0 = self.opt.xs
        else:
            f0 = self.opt.func(xs)
            x0 = xs

        for i in range(self.opt.n):
            x = np.copy(x0)
            dx = np.sqrt(self.opt.eps * max(abs(x[i]), 1e-05))
            x[i] = x[i] + dx
            f = self.opt.func(x)
            df[i] = (f - f0) / dx

        return df
    # end def
    def optnlin_nbegrenzt_BFGS_func(self, xs=None):

        f = self.opt.func(xs)

        if (self.opt.flag_penality):
            for i in range(self.opt.n):
                if (xs[i] > self.opt.P[i].xmax):
                    d = (xs[i] - self.opt.P[i].xmax) / self.opt.P[i].dxP
                    f = f * (self.opt.Penality * (d ** 6) + 1.0)
                else:
                    if (xs[i] < self.opt.P[i].xmin):
                        d = (self.opt.P[i].xmin - xs[i]) / self.opt.P[i].dxP
                        f = f * (self.opt.Penality * (d ** 6) + 1.0)

        return f
    # end def
    def optnlin_nbegrenzt_build_H0(self):


        H0 = np.eye(self.opt.n)
        B0 = np.copy(H0)
        if opt.use_df_func:

            for i in range(self.opt.n):
                x = np.copy(self.opt.x0)
                dx = np.sqrt(1e-16 * max(abs(x[i]), 1e-05))
                df1 = self.opt.df[i]
                x[i] = x[i] + dx
                df = self.opt.dfunc(x)
                df2 = df[i]
                H0[i, i] = (df2 - df1) / dx
                B0[i, i] = 1 / not_zero(H0[i, i])
            # end for
        else:
            for i in range(self.opt.n):
                x = np.copy(self.opt.x0)
                f0 = self.opt.f
                dx = np.sqrt(self.opt.eps * max(abs(x[i]), 1e-05))
                x[i] = x[i] + dx
                f1 = self.opt.func(x)
                df1 = (f1 - f0) / dx
                x[i] = x[i] + dx
                f2 = self.opt.func(x)
                df2 = (f2 - f1) / dx
                H0[i, i] = (df2 - df1) / dx
                B0[i, i] = 1. / not_zero(H0[i, i])
            # end ofr
        # end if
        return H0, B0

    def TrustRegion(self):
        self.status = hdef.NOT_OKAY
        self.errtext = 'TrustRegion nicht implementiert'
        return
    # end def
    def TrustRegionWedge(self):
        self.status = hdef.NOT_OKAY
        self.errtext = 'TrustRegionWedge nicht implementiert'
        return
    # end def
    def func_integer(self,xs_in,fname="fun"):

        (xs,intx_liste) = self.build_integer_xs(xs_in)

        (flag,f) = self.search_in_old_results(intx_liste)
        if flag:
            return f
        else:
            f = self.opt.func(xs)
            self.add_f_xs_liste(f,fname)
        # end if
        return f
    # end def
    def func_integer_df(self,idf,xs_in):

        _ = self.build_integer_xs( xs_in)
        # Bilde zum speichern die Liste mit integerwerten
        int_liste = []
        for i in range(self.opt.n):
            int_liste.append(self.opt.int_def_dict_list[i]["intx"])
        # end for

        # modifiziere für idf

        if (self.opt.int_def_dict_list[idf]["intxmax"] is not None) and \
           ((int_liste[idf]+1) > self.opt.int_def_dict_list[idf]["intxmax"]):
                int_liste[idf] -= 1
                dx = -self.opt.int_def_dict_list[idf]["res"]
        else:
            int_liste[idf] += 1
            dx = self.opt.int_def_dict_list[idf]["res"]
        # end if


        # Bilde x-Vektor
        x1 = np.copy(xs_in)
        x1[idf] = int_liste[idf] * self.opt.int_def_dict_list[idf]["res"]

        f1 = self.func_integer(x1,"dfun")

        # self.add_f1_x0_liste2(int_liste,f1)

        return (f1, dx)
    # end def
    def dfunc_integer(self,xs_in):
        xs = self.build_integer_xs(xs_in)
        df = self.opt.dfunc(xs)
        return df
    # end def
    def optnlin_nbegrenzt_build_df_int(self,xs_in,f0):


        df = np.copy(self.opt.xs) * 0.0   # np.array([0.0 for i in range(len(self.opt.xs))])

        # f0 wird von der letzen Berechnung genommen
        # f0 = self.opt.int_erg_lliste[-1][-1]

        for i in range(self.opt.n):

            (f1,dx) = self.func_integer_df(i,xs_in)

            df[i] = (f1 - f0) / dx
        # end for
        return df
    # end def
    def exist_double_values_in_result_liste(self):

        # Vergleiche letzen Wert mit dem Rest
        n = len(self.opt.int_func_lliste)
        if n > 1:
            liste_proof = self.opt.int_func_lliste[-1]
            fmin_proof        = liste_proof[-1]
            liste_proof = liste_proof[0:self.opt.n]
            ifound = None
            for i in range(n-1):

                liste = self.opt.int_func_lliste[i]
                liste = liste[0:self.opt.n]
                if liste == liste_proof:
                    ifound = i
                # end if
            # end for

            # 2. proof
            if ifound is not None:
                for i in range(n - 1):
                    liste = self.opt.int_func_lliste[i]
                    fmin = liste[-1]
                    if i != ifound:
                        if fmin < fmin_proof: # Es gibt noch einen kleineren Wert
                            return False
                        # end if
                    # end if
                # end for
                return True
            # end if
        # end if
        return False
    # end def
    def find_and_set_fmin_value(self):

        if len(self.opt.int_erg_lliste):

            # search in int_erg_lliste for Minimum
            fmin = self.opt.int_erg_lliste[0][-1]
            imin = 0
            for i,liste in enumerate(self.opt.int_erg_lliste):
                if liste[-1] < fmin:
                    fmin = liste[-1]
                    imin = i
                # end if
            # end for

            # flag = False
            # for i, liste in enumerate(self.opt.int_erg_lliste_df):
            #     if liste[-1] < fmin:
            #         fmin = liste[-1]
            #         imin = i
            #         flag = True
            #     # end if
            # # end for
            #
            # if flag:
            #     self.log.write_info(f"Found Minimum in df-Calculation")
            # # end if

            self.opt.f = fmin
            for i in range(self.opt.n):
                # if flag:
                #     self.opt.xs[i] = self.opt.int_erg_lliste_df[imin][i] * self.opt.int_def_dict_list[i]["res"]
                # else:
                self.opt.xs[i] = self.opt.int_erg_lliste[imin][i] * self.opt.int_def_dict_list[i]["res"]
            # end if
        # end if
        return
    # end def
    def set_xmin_xmax(self,xs):

        for i in range(self.opt.n):

            if self.opt.int_def_dict_list[i]["xmin"] is not None:
                if xs[i] < self.opt.int_def_dict_list[i]["xmin"]:
                    xs[i] = self.opt.int_def_dict_list[i]["xmin"]
                # end if
            # end if

            if self.opt.int_def_dict_list[i]["xmax"] is not None:
                if xs[i] > self.opt.int_def_dict_list[i]["xmax"]:
                    xs[i] = self.opt.int_def_dict_list[i]["xmax"]
                # end if
            # end if
        # end for
        return xs
    # end def
    def build_integer_xs(self,xs_in):

        xs = np.copy(xs_in)
        intx_liste = []
        for i,ddict in enumerate(self.opt.int_def_dict_list):

            (x,rest,intx) = bilde_int_mit_res(xs_in[i],ddict["res"])

            if rest != 0.0:
                if self.opt.xs[i] >= 0.0:
                    if self.opt.int_sk[i] >= 0.0:
                        intx += 1
                        x    =  ddict["res"] * intx
                        rest =  self.opt.xs[i] - x
                    # end if
                else:
                    if self.opt.int_sk[i] < 0.0:
                        intx -= 1
                        x    = ddict["res"] * intx
                        rest = self.opt.xs[i] - x
                    # end if
                # end if
            # end if

            ddict["x"]    = x
            ddict["intx"] = intx
            ddict["rest"] = rest

            self.log.write_info(f"build_integer_xs: xs{i} => x:{ddict["x"]} intx:{ddict["intx"]} rest:{ddict["rest"]}")

            xs[i] = x
            intx_liste.append(intx)
            self.opt.int_def_dict_list[i] = ddict
        # end if

        return (xs,intx_liste)
    # end def
    def search_in_old_results(self,intx_liste):
        flag = False
        f = None

        for liste in self.opt.int_erg_lliste:
            count = 0
            for i in range(self.opt.n):
                if liste[i] == intx_liste[i]:
                    count += 1
                # end if
            # end for
            if count == self.opt.n:
                flag = True
                f = liste[-1]
                break
            # end if
        # end for

        return (flag,f)
    # end def
    def add_func_ergebnisse(self,xs_in,f):

        (_, intx_liste) = self.build_integer_xs(xs_in)
        intx_liste.append(f)
        self.opt.int_func_lliste.append(intx_liste)
        return
    # end def
    def add_f_xs_liste(self,f,fname):

        liste = []
        for i in range(self.opt.n):
            liste.append(int(self.opt.int_def_dict_list[i]["intx"]))
        # end if
        liste.append(f)

        self.opt.int_erg_lliste.append(liste)

        if self.opt.int_jsonobj is not None:
            self.log.write_info(f"Adding Ergebnis {fname} to liste")
            self.add_to_json_output(fname,liste)
        # end if
        return
    # end def
    # def add_f1_x0_liste2(self,xint_liste,f1):
    #
    #     liste = []
    #     for i in range(self.opt.n):
    #         liste.append(int(xint_liste[i]))
    #     # end if
    #     liste.append(f1)
    #
    #     self.opt.int_erg_lliste_df.append(liste)
    #
    #     if self.opt.int_jsonobj is not None:
    #         self.log.write_info(f"Adding Ergebnis 'dfun' to liste")
    #         self.add_to_json_output("dfun",liste)
    #     # end if
    #
    #     return
    # # end def
    def add_to_json_output(self,name,liste):

        if self.opt.int_jsonobj.exist_file():
            lliste = self.opt.int_jsonobj.read_and_get_data()
        else:
            lliste = []
        # end if

        new_liste = copy.copy(liste)
        for i in range(self.opt.n):
            new_liste[i] = new_liste[i] * self.opt.int_def_dict_list[i]["res"]
        # end if

        lliste.append([name]+new_liste)

        self.opt.int_jsonobj.save(lliste)

        return
    # end def
# end class
def bilde_int_mit_res(x_in,res):

    val = x_in/res
    (rest,xint) = math.modf(val)

    rest *= res
    intx = int(xint)
    x    = xint * res
    return (x,rest,intx)
# end def
def not_zero(val,eps=1e-16):

    if val >= 0.0:
        val = max(eps,val)
    else:
        val = min(-eps,val)
    # end if

    return val
# end def

if __name__ == '__main__':


    par1 = 4.
    par2 = 2.
    def funcRosenbrock(x):

        # f = 100.0 * (x[1] - x[0] * x[0]) ** 2 + (1.0 - x[0]) ** 2
        f = math.pow((par1-x[0]) , 2.0) + math.pow((par2-x[1]) , 2.0)
        return f
    # end def
    def diffRosenbrock(x):

        df = np.copy(x) * 0.0   # np.array([0.0 for x in range(len(x))])

        # df[0] = -400.0 * x[0] * (x[1] - x[0] * x[0]) - 2.0 * (1.0 - x[0])
        # df[1] = 200.0 * (x[1]-x[0] * x[0])

        df[0] = - 2. * (par1 - x[0])
        df[1] = - 2. * (par2 - x[1])

        return df
    # end def
    def HRosenbrock(x):

        H = np.eye(len(x))

        # H[0,0] = -400.0 * (x[1] - 3 * x[0] * x[0]) + 2.0
        # H[0,1] = -400.0 * x[0]
        # H[1,0] = -400.0 * x[0]
        # H[1,1] = 200.0

        H[0, 0] = + 2.
        H[0, 1] = 0.0
        H[1, 0] = 0.0
        H[1, 1] = 2.

        return H
    # end def

    opt = DataOpt("test")

    opt.type  = 0              # 0: Methode des steilsten Abstiegs
                               # 1: BFGS-Verfahren (Quasi-Newton-Verfahren) mit
                               #    Powell-Wolfe-Regel
                               # 2: Trust-Region
                               # 3: Trust-Region-Wedge
                               # Methode des steilsten Abstiegs:
    # opt.stype = 0              # 0: Schrittweiten Regelung nach Armijo-Regel
                               # 1: Schrittweiten Regelung nach Powell-Wolfe
    # opt.use_df_func = 0          # Soll Ableitung aus der Funktion berechnet werden
    # opt.use_H_func  = 0

    # opt.beta  = 0.5            # Armijo-Regel 0 < beta < 1  skaliert Schrittweite
    # opt.gamma = 1e-4           # Armijo-Regel,Powell-Wolfe-Regel 0 < gamma < 1 skaliert Gradienten
    # opt.eta   = 0.9            # Powell-Wolfe-Regel gamma < eta < 1 skaliert Gradienten gröber


    opt.kmax  = 100
    opt.err   = 1e-5

    opt.x_int_def = [{"format":"float","res":0.1,"xmin":3.0},
                     {"format":"float","res":0.01}]
    opt.int_json_file = datetime.datetime.now().strftime("%Y%m%d_%H%M.json")


    obj = OptNlinNbegrenzt()
    erg = obj.optimize(opt,[10.0,10.0],funcRosenbrock)

    if erg.status != hdef.OKAY:
        print(erg.errtext)

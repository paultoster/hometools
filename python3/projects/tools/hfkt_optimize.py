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

# -------------------------------------------------------------------------------
t_path, _ = os.path.split(__file__)
if (t_path == os.getcwd()):

    import hfkt_log as hlog
    import hfkt_def as hdef
else:
    p_list = os.path.normpath(t_path).split(os.sep)
    if (len(p_list) > 1): p_list = p_list[: -1]
    t_path = ""
    for i, item in enumerate(p_list): t_path += item + os.sep
    if (os.path.normpath(t_path) not in sys.path): sys.path.append(t_path)

    from tools import hfkt_log as hlog
    from tools import hfkt_def as hdef

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


        if not hasattr(self.opt, 'x0'):
            self.status = hdef.NOT_OKAY
            self.errtext = f"Kein x0 gesetzt"
            return
        elif not isinstance(self.opt.x0,list):
            self.status = hdef.NOT_OKAY
            self.errtext = f"x0 ist nicht als Liste gesetzt"
            return
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
        self.opt.xs = self.opt.x0

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

        # end if

        return
    # end def
    def check_functions(self):

        self.opt.xs = self.opt.x0

        # Function
        #---------
        try:
            self.opt.f = self.opt.func(self.opt.xs)
        except:
            self.status = hdef.NOT_OKAY
            self.errtext = f"Die Funktion opt.func(opt.x0) kann nicht ausgeführt werden"
            return
        # end try

        # Ableitung
        #----------
        if (self.opt.use_df_func):
            try:
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
        # end if

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
            if ((n != self.opt.n) or (m != self.opt.n)):
                self.status = hdef.NOT_OKAY
                self.errtext = f"Länge Ergbnismatrix der Hessefunktion opt.Hfunc ist nicht gleich n={self.opt.n} ({n}x{m}) (aus opt.x0)"
                return
            # end if

            self.opt.B0 = np.invert(self.opt.H0)

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
            self.errtext = self.errtext
            return None

        self.check_functions()

        if self.status != hdef.OKAY:
            self.opt.status = self.status
            self.errtext = self.errtext
            return None

        # Ausführen:
        start_real = time.perf_counter()

        match self.opt.type:
            case self.TYPE_STEILSTER_ABSTIEG:

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

        end_real = time.perf_counter()
        self.opt.calc_time = end_real - start_real

        self.opt.status = self.status
        self.errtext = self.errtext

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
                for ii in np.arange(1, self.opt.n + 1).reshape(-1):
                    self.log.write_info("x%i = %g"%(ii, self.opt.xs[ii]))
                self.log.write_info('\n')
            # end if

            self.opt.k = self.opt.k + 1
            sk = self.opt.df * (- 1.0)

            # Armaijo-Regel
            if (self.opt.stype == 0):
                sigmak = self.optnlin_nbegrenzt_Armijo( sk)
            else:
                sigmak = self.optnlin_nbegrenzt_PowellWolfe( sk)
            if (not self.opt.okay):
                return opt
            self.opt.xs = self.opt.xs + sigmak * sk
            self.opt.f = self.opt.func(self.opt.xs)
            if (self.opt.use_df_func):
                self.opt.df = self.opt.dfunc(self.opt.xs)
            else:
                self.opt.df = self.optnlin_nbegrenzt_build_df()
            self.opt.df_norm = np.linalg.norm(self.opt.df)
            if (self.opt.df_norm <= self.opt.err):
                findflag = 1

        self.log.write_info("> k = %i f = %20.5g err = %20.5g sigma = %20.5g"% ( self.opt.k, self.opt.f, self.opt.df_norm, sigmak) )
        for i in np.arange(1, self.opt.n + 1).reshape(-1):
            self.log.write_info("x%s = %f" % ( str(i), self.opt.xs[i]))

        if (self.opt.k >= self.opt.kmax):
            self.opt.okay = 0
            self.opt.inform = 2
            self.opt.errtext = 'steilster Abstieg: maximale Anzahl der Interationen erreicht'
        # end if
        return

    # end def
    def optnlin_nbegrenzt_Armijo(self,sk):
        i = 0
        fac = self.opt.gamma * (np.transpose(self.opt.df) * sk)
        sigmak = 1.0
        delta = (self.opt.func(self.opt.xs + sigmak * sk) - self.opt.f)
        val = sigmak * self.opt.gamma * (np.transpose(self.opt.df) * sk)
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
                val = sigmak * self.opt.gamma * (np.transpose(self.opt.df) * sk)
                if (delta <= val):
                    sw = 3
                else:
                    sw = 2
            else:
                if 2 == (sw):
                    i = 0
                    sigmam = 2 ** - (i + 1)
                    delta = (self.opt.func(self.opt.xs + sigmam * sk) - self.opt.f)
                    val = sigmam * self.opt.gamma * (np.transpose(self.opt.df) * sk)
                    while (delta > val and i < 100):
                        i = i + 1
                        sigmam = 2 ** - (i + 1)
                        delta = (self.opt.func(self.opt.xs + sigmam * sk) - self.opt.f)
                        val = sigmam * self.opt.gamma * (np.transpose(self.opt.df) * sk)

                    if (i >= 100):
                        self.okay = 0
                        self.errtext = 'Schrittweitensteuerung(2) Powell-Wolfe-Regel > 100 Iterationen'
                        return sigmak
                    sigmap = 2.0 * sigmam
                    sw = 5
                else:
                    if 3 == (sw):
                        if (self.opt.use_df_func):
                            val1 = np.transpose(self.opt.dfunc(self.opt.xs + sigmak * sk)) * sk
                        else:
                            val1 = np.transpose(self.optnlin_nbegrenzt_build_df(self.opt.xs + sigmak * sk)) * sk
                        val2 = self.opt.eta * (np.transpose(self.opt.df) * sk)
                        if (val1 >= val2):
                            sw = 6
                        else:
                            sw = 4
                    else:
                        if 4 == (sw):
                            i = 0
                            sigmap = 2 ** (i + 1)
                            delta = (self.opt.func(self.opt.xs + sigmap * sk) - self.opt.f)
                            val = sigmap * self.opt.gamma * (np.transpose(self.opt.df) * sk)
                            while (delta <= val and i < 100):
                                i = i + 1
                                sigmap = 2 ** (i + 1)
                                delta = (self.opt.func(self.opt.xs + sigmap * sk) - self.opt.f)
                                val = sigmap * self.opt.gamma * (np.transpose(self.opt.df) * sk)

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
                                    val1 = np.transpose(v) * sk
                                else:
                                    v = self.optnlin_nbegrenzt_build_df(self.opt.xs + sigmak * sk)
                                    val1 = np.transpose(v) * sk
                                val2 = self.opt.eta * (np.transpose(self.opt.df) * sk)
                                while (val1 < val2 and i < 100):

                                    i = i + 1
                                    sigmak = (sigmam + sigmap) * 0.5
                                    delta = (self.opt.func(self.opt.xs + sigmak * sk) - self.opt.f)
                                    val = sigmak * self.opt.gamma * (np.transpose(self.opt.df) * sk)
                                    if (delta <= val):
                                        sigmam = sigmak
                                    else:
                                        sigmap = sigmak
                                    sigmak = sigmam
                                    if (self.opt.use_df_func):
                                        v = self.opt.dfunc(self.opt.xs + sigmak * sk)
                                        val1 = np.transpose(v) * sk
                                    else:
                                        v = self.optnlin_nbegrenzt_build_df(self.opt.xs + sigmak * sk)
                                        val1 = np.transpose(v) * sk
                                    val2 = self.opt.eta * (np.transpose(self.opt.df) * sk)

                                if (i >= 100):
                                    self.opt.okay = 0
                                    self.opt.errtext = 'Schrittweitensteuerung(5) Powell-Wolfe-Regel > 100 Iterationen'
                                    return opt, sigmak
                                sigmak = sigmam
                                sw = 6

        return sigmak
    # end def
    def optnlin_nbegrenzt_build_df(self, xs=None):

        df = self.opt.xs * 0.0

        if xs is None:
            f0 = self.opt.f
            x0 = self.opt.xs
        else:
            f0 = self.opt.func(xs)
            x0 = xs

        for i in np.arange(1, self.opt.n + 1).reshape(-1):
            x = x0
            dx = np.sqrt(1e-16 * np.amax(np.abs(x(i)), 1e-05))
            x[i] = x(i) + dx
            f = self.opt.func(x)
            df[i] = (f - f0) / dx

        return df
    # end def
    def BFGS(self):
        pass
        return
    # end def
    def TrustRegion(self):
        pass
        return
    # end def
    def TrustRegionWedge(self):
        pass
        return
    # end def



if __name__ == '__main__':

    def funcRosenbrock(x):

        f = 100.0 * (x[1] - x[0] * x[0]) ** 2 + (1.0 - x[0]) ** 2

        return f
    # end def

    opt = DataOpt("test")

    opt.type  = 1              # 0: Methode des steilsten Abstiegs
                               # 1: BFGS-Verfahren (Quasi-Newton-Verfahren) mit
                               #    Powell-Wolfe-Regel
                               # 2: Trust-Region
                               # 3: Trust-Region-Wedge
                               # Methode des steilsten Abstiegs:
    opt.stype = 0              # 0: Schrittweiten Regelung nach Armijo-Regel
                               # 1: Schrittweiten Regelung nach Powell-Wolfe
    opt.use_df_func = 0          # Soll Ableitung aus der Funktion berechnet werden
    opt.use_H_func  = 0

    opt.beta  = 0.5            # Armijo-Regel 0 < beta < 1  skaliert Schrittweite
    opt.gamma = 1e-4           # Armijo-Regel,Powell-Wolfe-Regel 0 < gamma < 1 skaliert Gradienten
    opt.eta   = 0.9            # Powell-Wolfe-Regel gamma < eta < 1 skaliert Gradienten gröber


    opt.delta0   = 1.            # opt.deltaT0   Trust-Region Startwert für Trust-Region-Radius
    opt.deltamin = 1e-3         # opt.deltaTmin Trust-Region minimal Trust-Region-Radius

    opt.kmax  = 100000
    opt.err   = 1e-3


    obj = OptNlinNbegrenzt()
    erg = obj.optimize(opt,[-1.2,1.0],funcRosenbrock)

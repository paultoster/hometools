import os, sys
import copy, random
import datetime, time

from win32comext.mapi.mapi import fnevCriticalError

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_log as hlog
import tools.hfkt_ini as hini
import tools.hfkt_list as hlist
import tools.hfkt_io as hio
import tools.hfkt_file_path as hfp
import tools.hfkt_optimize as hopt


import wp_test.wp_test_base as wp_test_base
import wp_test.wp_test_param as wp_test_param

COUNTER = 0
INI_DICT_PROOF_LISTE =   [("store_path", "str"),
                          ("wptest_func_ini_file_name","str"),
                          ("no_grid_search","int")]

def build_log_file_name(store_path,parametername,act_time_str):
    """

    :param store_path:
    :param parametername:
    :return: log_file = build_log_file_name(store_path,parametername)
    """


    p = os.path.join(store_path,"log_"+parametername)
    if not os.path.exists(p):
        os.makedirs(p)
    # end if

    log_file = os.path.join(p,"log_"+parametername+"_"+act_time_str+".log")
    return log_file
# end if
def build_json_file_name(store_path,pre_name,parametername,act_time_str):
    """

    :param store_path:
    :param parametername:
    :return: log_file = build_log_file_name(store_path,parametername)
    """


    p = os.path.join(store_path,"log_"+parametername)
    if not os.path.exists(p):
        os.makedirs(p)
    # end if

    json_file = os.path.join(p,pre_name+"_"+parametername+"_"+act_time_str+".json")
    return json_file
# end if
class WPOpt:
    """

    """

    def __init__(self, param_filename: str, ini_filename: str, log_obj=None) -> None:

        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""

        (path, fbody, extension) = hfp.get_pfe(param_filename)
        fbody = fbody.replace("wp_opt_", "")
        fbody = fbody.replace("wp_test_", "")

        self.param_filename = param_filename
        self.param_name = fbody
        self.param_path = path

        self.act_time_str = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        # Ausführen:
        self.start_time_perf = time.perf_counter()
        self.end_time_perf = 0.0
        self.search_in_grid_time_perf = 0
        self.search_by_optimize_time_perf = 0.0

        # ini
        self.ini = hini.get_tomlib_ini_dict(ini_filename, INI_DICT_PROOF_LISTE)

        if hini.get_status() != hdef.OKAY:
            self.status = hdef.OKAY
            self.errtext = hini.get_errtext()
            hini.reset_status()
            print(self.errtext)
            return
        # end if

        # Log-File start
        # ---------------
        if log_obj is None:
            log_file = build_log_file_name(self.ini["store_path"],self.param_name,self.act_time_str)
            self.log = hlog.log(log_file=log_file,consol_func=True, log_window=False)
        else:
            self.log = log_obj
        # end if
        self.log_file_name = self.log.get_logfilename()

        self.log.write_info(f"wp_opt_base: Start run parameterset: {self.param_name} acttime: {self.act_time_str}")


        if self.status != hdef.OKAY:
            self.log.write_err(self.errtext)
            return
        # end if

        # wp_screen
        # ----------
        self.wptestfunc = wp_test_base.WPTest(ini_filename=self.ini["wptest_func_ini_file_name"],
                                              log_obj=self.log)

        if self.wptestfunc.get_status() != hdef.OKAY:
            self.status = hdef.NOT_OKAY
            self.errtext = self.wptestfunc.get_errtext()
            self.log.write_err(self.errtext)
            self.wptestfunc.reset_status()
            return
        # end if

        # Parameter par_dict und platzhalter
        # ---------
        (self.par_dict, self.platzhalter_dict_liste) = wp_test_param.get_split_param_dicts(self, self.param_filename)

        if self.status != hdef.OKAY:
            self.log.write_err(self.errtext)
            return

        # Teste Parameter Set
        #---------------------
        (_,_) = wp_test_param.get_par_struct_liste(self, self.par_dict, self.platzhalter_dict_liste)
        if self.status != hdef.OKAY:
            self.log.write_err(self.errtext)
            return
        # end if

        return
    # end def
    def run_opt(self):

        def cal_cost_function(x):
            global COUNTER

            # set value
            platzhalter_dict_liste = copy.copy(self.platzhalter_dict_liste)
            for i in range(len(x)):
                if platzhalter_dict_liste[i]["format_value"] == "int":
                    platzhalter_dict_liste[i]["liste"] = [int(x[i])]
                else:
                    platzhalter_dict_liste[i]["liste"] = [x[i]]
                # end if
                platzhalter_dict_liste[i]["n"] = 1

                self.log.write_info("cal_cost_function start:x%s = %f" % (str(i), x[i]))
            # end ofr

            # Teste Parameter Set
            #---------------------
            (par_struct_liste,comment_struct) = wp_test_param.get_par_struct_liste(self, self.par_dict, platzhalter_dict_liste)
            if self.status != hdef.OKAY:
                raise Exception(self.errtext)
            # end if

            self.wptestfunc.set_param(par_struct_liste=par_struct_liste)

            if self.wptestfunc.get_status() != hdef.OKAY:
                raise Exception(self.wptestfunc.get_errtext())
            # end if

            self.wptestfunc.run()

            if self.wptestfunc.get_status() != hdef.OKAY:
                raise Exception(self.wptestfunc.get_errtext())
            # end if

            ferror = self.wptestfunc.get_ferror()
            COUNTER += 1

            self.log.write_info(f"cal_cost_function end: n: {COUNTER} ferror: {ferror}")

            return ferror
        # end def

        global COUNTER
        COUNTER = 0

        # Ausgabe abstellen
        self.par_dict["BildeAusgabe"] = False

        # Liste mit allen permutierenden Werten erstellen
        xsearch_lliste = []
        for ddict in self.platzhalter_dict_liste:
            xsearch_lliste.append(ddict["liste"])
        # end for

        if self.ini["no_grid_search"] > 0:

            self.log.write_info("run_opt no_grid_search-------------------------------------------" )
            self.log.write_info("-----------------------------------------------------------------------" )

            xfound_liste = []
            for ddict in self.platzhalter_dict_liste:

                if "value_start" not in ddict.keys():
                    raise Exception(f"Platzhalter hat kein 'value_start' nicht gefunden. ddict= {ddict}")
                elif ddict["value_start"] is None:
                    raise Exception(f"Platzhalter hat kein 'value_start' nicht gesetzt. ddict= {ddict}")
                else:
                    xfound_liste.append(float(ddict["value_start"]))
                # end if
            # end for
        else:
            self.log.write_info("run_opt start:grid_search-------------------------------------------" )
            self.log.write_info("-----------------------------------------------------------------------" )
            # Suche nach besten Wert mit Liste
            #----------------------------------
            xfound_liste = self.search_in_grid(xsearch_lliste,cal_cost_function)

            self.search_in_grid_time_perf = time.perf_counter()
            self.log.write_info(f"Rechenzeit search_in_grid calc_time = {self.search_in_grid_time_perf- self.start_time_perf} sec")
        # end if


        # gefundener wert in die Platzhalterliste schreiben
        #--------------------------------------------------
        for i in range(len(xfound_liste)):
            self.platzhalter_dict_liste[i]["value_min"] = xfound_liste[i]
        # end for

        # Zeit Stoppen

        self.log.write_info("run_opt start:optimize-------------------------------------------------")
        self.log.write_info("-----------------------------------------------------------------------")

        # Suche nach besten Wert mit Optimieren
        #--------------------------------------
        xfound_liste = self.search_by_optimize(cal_cost_function)

        # gefundener wert in die Platzhalterliste schreiben
        #--------------------------------------------------
        for i in range(len(xfound_liste)):
            self.platzhalter_dict_liste[i]["value_min"] = xfound_liste[i]
        # end for

        # Zeit Stoppen
        self.search_by_optimize_time_perf = time.perf_counter()
        self.log.write_info(f"Rechenzeit search_by_optimize calc_time = {self.search_by_optimize_time_perf-self.search_in_grid_time_perf} sec")

        self.log.write_info("run_opt start:calc optimized  value------------------------------------")
        self.log.write_info("-----------------------------------------------------------------------")

        # Parameterfile umbenennen und die neuen Werte reinschreiben
        #----------------------------------------------------------
        wp_test_param_filename = self.bilde_paramfile_mit_ergebnis()

        # Neuen Parameter Set einlesen
        #-----------------------------
        (par_struct_liste,comment_struct) = wp_test_param.set_param(self, wp_test_param_filename)
        if self.status != hdef.OKAY:
            raise Exception(self.errtext)
        # end if

        self.wptestfunc.set_param(par_struct_liste=par_struct_liste)

        # run final calculation mit ergebnis
        self.wptestfunc.run()

        if self.wptestfunc.get_status() != hdef.OKAY:
            raise Exception(self.wptestfunc.get_errtext())
        # end if

        # Zeit Stoppen
        self.end_time_perf = time.perf_counter()
        self.log.write_info(f"Rechenzeit last calulation calc_time = {self.end_time_perf-self.search_by_optimize_time_perf} sec")
        self.log.write_info(f"Rechenzeit gesamt {self.param_name} calc_time = {self.end_time_perf-self.start_time_perf} sec")

        return
    # end def
    def search_in_grid(self,xsearch_lliste,func):
        """ search with xsearch_liste
        xsearch_lliste: all lists from self.platzhalter_dict_liste put into llist
        """

        # Eine art Protokollfile erstellen
        #---------------------------------
        filename = build_json_file_name(self.ini["store_path"], "search",self.param_name,self.act_time_str)
        jsonobj = hio.DataJson(filename)

        # Bilde Permutation von allen einzel listen
        search_lliste = hlist.build_permutation_llist_from_llist(xsearch_lliste,1)

        n = len(search_lliste)

        for i in range(n):

            result = func(search_lliste[i][:-1])

            search_lliste[i][-1] = result

            jsonobj.save(search_lliste)

        # end ofr
        for i in reversed(range(n)):
            if search_lliste[i][-1] is None:
                print(f"Weglöschen wegen None: {search_lliste[i]}")
                del search_lliste[i][-1]
            # end if
        # end for

        index = len(search_lliste[0])-1

        sort_lliste = hlist.sort_list_of_list(search_lliste, index)

        return sort_lliste[0][:-1]
    # end def
    def search_by_optimize(self,func):

        # Startvektor
        x0_liste = []
        x_int_def_liste = []
        for platzhalter_dict in self.platzhalter_dict_liste:
            x0_liste.append(float(platzhalter_dict["value_min"]))

            xmin = platzhalter_dict["minvalue"]
            xmax = platzhalter_dict["maxvalue"]
            format = platzhalter_dict["format_value"]
            if format == "int":
                res = 1.
            else:
                res = 0.001
            # end if
            ddict = {"format":format,"res":res,"xmin":xmin,"xmax":xmax}
            x_int_def_liste.append(ddict)
        # end for

        opt = hopt.DataOpt("wp_opt")

        opt.type = 0  # 0: Methode des steilsten Abstiegs
        opt.kmax = 100
        opt.err = 1e-5
        opt.x_int_def = x_int_def_liste
        opt.int_json_file = build_json_file_name(self.ini["store_path"], "opt",self.param_name,self.act_time_str)


        obj = hopt.OptNlinNbegrenzt(self.log)
        erg = obj.optimize(opt, x0_liste, func)

        if erg.status != hdef.OKAY:
            print(erg)
            raise Exception(f"{erg.errtext}")
        # end if

        xfound_liste = []
        for i in range(erg.n):
            xfound_liste.append(float(erg.xs[i]))
        # end for

        return xfound_liste

    # end def
    def bilde_paramfile_mit_ergebnis(self):



        # lese inhalt des Parameterfiles
        (okay, data) = hio.read_ascii(file_name=self.param_filename)

        # Ersetze Platzhalter mit Ergebnis
        for platzhalter_dict in self.platzhalter_dict_liste:

            if platzhalter_dict["format_value"] == "int":
                data = data.replace(platzhalter_dict["name"],str(int(platzhalter_dict["value_min"])))
            else:
                data = data.replace(platzhalter_dict["name"], str(platzhalter_dict["value_min"]))
            # end if
        # end for

        # Ersetze "par_" zu "nopar_" to take out parameter replacemant
        data = data.replace("par_","nopar_")

        wp_test_param_filename = hfp.set_pfe(self.param_path,"wp_test_opt_"+self.param_name,"yaml")

        okay = hio.write_ascii(wp_test_param_filename, data,preferred_encoding="utf-8")

        if okay != hdef.OKAY:
            print(data)
            raise Exception(f"hio.write_ascii({wp_test_param_filename}, data)")
        # end if

        return wp_test_param_filename
# end class

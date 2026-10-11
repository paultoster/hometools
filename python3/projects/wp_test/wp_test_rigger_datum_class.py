import os, sys
import datetime

t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import tools.hfkt_def as hdef
import tools.hfkt_date_time as hdt
import tools.hfkt_type as htype
import tools.hfkt_np_calc as hnpcalc

import wp_test_bank_class


class WPTriggerDatum:
    """

    """

    def __init__(self,start_dat_datClass,end_dat_datClass,ersterTag,wiederholTag) -> None:

        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""

        self.Start_datClass = start_dat_datClass
        self.End_datClass = end_dat_datClass


        if isinstance(ersterTag,str):
            self.ErsterWochentag = ersterTag
            self.ErsterDatumstag = 0
            self.FlagErsterWochentag = True
        else:
            self.ErsterWochentag = ""
            self.ErsterDatumstag = ersterTag
            self.FlagErsterWochentag = False
        # end if
        if isinstance(wiederholTag,str):
            self.WiederholWochentag = wiederholTag
            self.WiederholDatumstag = 0
            self.FlagWiederholWochentag = True
        else:
            self.WiederholWochentag = ""
            self.WiederholDatumstag = wiederholTag
            self.FlagWiederholWochentag = False
        # end if

        # Bestimmung nächster Prüftag
        if self.FlagErsterWochentag:

            self.NaechstTriggerTag_datClass = hdt.get_next_weekday(self.Start_datClass,
                                                          self.ErsterWochentag)
        else:

            self.NaechstTriggerTag_datClass = hdt.get_next_datumday(self.Start_datClass,
                                                                 self.ErsterDatumstag)

        # end if

        # Prüfen, ob über end-Datum
        if (self.NaechstTriggerTag_datClass - self.End_datClass) > datetime.timedelta(0):
            self.status = hdef.NOT_OKAY
            self.errtext = f"WPTriggerDatum: Bei Init NaechsterTriggerTag: {self.NaechstTriggerTag_datClass} nach Ende: {self.End_datClass}"
            return

        # end if


        return
    # end def
    def triggerStatus(self,akt_dat_datClass):
        """
        flag = self.triggerStatus(akt_dat_datClass)

        Prüft, ob das aktuelle Datum vor, gleich bzw. nach dem nächsten Trigger Tag liegt
        (self.NaechstTriggerTag_datClass)

            wenn nächster Trigger vor dem aktuellen Datum dann flag = False
            wenn nächster Trigger gleich oder nach dem aktuellen Datum dann flag = True

        :param akt_dat_datClass:
        :return:
        """

        if akt_dat_datClass < self.NaechstTriggerTag_datClass:
            return False
        else:
            return True
        # end if
    # end def
    def set_next_trigger_day(self):
        """
        setzt den nächsten Triggertag voraus nach vorgegebener Regel
        :return:
        """
        # Bestimmung nächster Prüftag
        if self.FlagWiederholWochentag:

            self.NaechstTriggerTag_datClass = hdt.get_next_weekday(self.NaechstTriggerTag_datClass,
                                                          self.WiederholWochentag)
        else:

            self.NaechstTriggerTag_datClass = hdt.get_next_datumday(self.NaechstTriggerTag_datClass,
                                                                 self.WiederholDatumstag)

        # end if
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

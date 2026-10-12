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

import konto_class


class WPTriggerDatum:
    """

    """

    def __init__(self,start_dat_datetime,end_dat_datetime,ersterTag,wiederholTag) -> None:

        self.status = hdef.OKAY
        self.errtext = ""
        self.infotext = ""

        self.StartDat_datetime = start_dat_datetime
        self.EndDat_datetime = end_dat_datetime


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

            self.NaechstTriggerTag_datetime = hdt.get_next_weekday(self.StartDat_datetime,
                                                          self.ErsterWochentag)
        else:

            self.NaechstTriggerTag_datetime = hdt.get_next_datumday(self.StartDat_datetime,
                                                                 self.ErsterDatumstag)

        # end if

        # Prüfen, ob über end-Datum
        if (self.NaechstTriggerTag_datetime - self.EndDat_datetime) > datetime.timedelta(0):
            self.status = hdef.NOT_OKAY
            self.errtext = f"WPTriggerDatum: Bei Init NaechsterTriggerTag: {self.NaechstTriggerTag_datetime} nach Ende: {self.EndDat_datetime}"
            return

        # end if


        return
    # end def
    def triggerStatus(self,akt_dat_datetime):
        """
        flag = self.triggerStatus(akt_dat_datetime)

        Prüft, ob das aktuelle Datum vor, gleich bzw. nach dem nächsten Trigger Tag liegt
        (self.NaechstTriggerTag_datetime)

            wenn nächster Trigger vor dem aktuellen Datum dann flag = False
            wenn nächster Trigger gleich oder nach dem aktuellen Datum dann flag = True

        :param akt_dat_datetime:
        :return:
        """

        if akt_dat_datetime < self.NaechstTriggerTag_datetime:
            return False
        else:
            return True
        # end if
    # end def
    def setNextTriggerDay(self):
        """
        setzt den nächsten Triggertag voraus nach vorgegebener Regel
        :return:
        """
        # Bestimmung nächster Prüftag
        if self.FlagWiederholWochentag:

            self.NaechstTriggerTag_datetime = hdt.get_next_weekday(self.NaechstTriggerTag_datetime,
                                                          self.WiederholWochentag)
        else:

            self.NaechstTriggerTag_datetime = hdt.get_next_datumday(self.NaechstTriggerTag_datetime,
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

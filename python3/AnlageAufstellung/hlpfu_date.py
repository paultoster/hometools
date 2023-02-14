#
# import hlpfu_date hd
#
#---------------------------------------------------
# secs = hd.secs_time_epoch_from_str(str_dat,delim=".")
#
# Das Str-Datum intval (z.B. "17.12.2004") wird in 
# Sekunden in epochaler Zeit umgerechnet
#----------------------------------------------------
# str = hd.str_from_secs_time_epoch(secs):
#
# Wandelt epochen Zeist in secs nach Datum als string tt.m.yyyy
#----------------------------------------------------
from datetime import datetime,timedelta

#====================================================
def secs_time_epoch_from_str(str_dat : str,delim=".") -> int: 
  # Das Str-Datum intval (z.B. "17.12.2004") wird in 
  # Sekunden in epochaler Zeit umgerechnet
  # secs = secs_time_epoch_from_str(str_dat,delim=".")
  
  form = "%d"+delim+"%m"+delim+"%Y"
  str_to_dt = datetime.strptime(str_dat, form)
  epoch = datetime(1970, 1, 1)
  dt = (datetime.strptime(str_dat, form) - epoch).total_seconds()
  return int(dt)
#enddef
#====================================================
def str_from_secs_time_epoch(secs: int) -> str :
  #
  # Wandelt epochen Zeist in secs nach Datum als string tt.m.yyyy
  
  epoch = datetime(1970, 1, 1)
  if( secs < 0 ):
      dt = timedelta(seconds=-secs)
      dtdt = epoch-dt
  else:
    dt = timedelta(seconds=secs)
    dtdt = dt+epoch
  #endif
  return dtdt.strftime("%d.%m.%Y")

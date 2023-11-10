import sys


# Hilfsfunktionen
from hfkt import hfkt as h
from hfkt import hfkt_def as hdef
from hfkt import sguicommand
from hfkt import hfkt_status as status
from hfkt import hfkt_commands as hcommand


from AADatabase import DatabaseDef as dbdef,Database
# from AADatabase import FktDatabaseSetAnlagenkontoDaten as SetAnlagenkontoDaten

cells_which_must_be_filled = [dbdef.CELL_KONTONAME,dbdef.CELL_KONTONR \
                             ,dbdef.CELL_KONTOBLZ,dbdef.CELL_KONTOIBAN \
                            ,dbdef.CELL_KONTOSTAND,dbdef.CELL_ANFANGSDATUM]

#------------------------------------------------------------
# Anlage bearbeiten
#------------------------------------------------------------
def fkt_steu_anlage_konto_bearbeit(db : Database.db,commands : hcommand.commands, stat : status.status,anlagekontoname : str):
  """
  Daten zu Anlagekonto bearbeiten oder neu erstellen
  wenn anlagekontoname = "" dann neues Konto
  """
  stat.reset()

  if( len(anlagekontoname) == 0 ):

    cellname_liste = db.getAnlagenkontenHeaderList()

    title = "Neues Konto"

  else:

    cellname_liste = db.getAnlagenkontenHeaderList()

    d = db.getAnlagenkontenDaten(anlagekontoname)

    title = anlagekontoname
  #endif

  # Namensliste erstellen
  #----------------------
  namesliste = cellname_liste

  # Vorgabenliste erstellen
  #------------------------
  if( len(anlagekontoname) == 0 ):
    vorgabe_liste = None
  else:

    vorgabe_liste = []
    for cell_name in cellname_liste:
       vorgabe_liste.append(d[cell_name])
    #endofr
  #endif

  # Werte abfragen
  liste_cellnamen_belegt = []
  error_flag = True
  while(error_flag ):

    # reset flag at first
    #--------------------
    error_flag = False

    out_liste = sguicommand.abfrage_n_eingabezeilen(namesliste,vorgabe_liste=vorgabe_liste,commands=commands,title=title)

    # cancel
    if(len(out_liste) < len(namesliste)):  #123456
      return
    else:

      dout = {}
      for i, cell_name in enumerate(cellname_liste):

        outdata = h.elim_ae(out_liste[i],' ')
        # Hat out_litse[i] Inhalt
        if( (cell_name in cells_which_must_be_filled)  and (len(outdata) == 0)  ):

          t = f"Zelle mit Name {cell_name} ist leer"
          sguicommand.anzeige_error(texteingabe=t,commands=commands,title="Error Inhalt")
          error_flag = True

        # Anfangsdatum prüfen
        elif( dbdef.CELL_ANFANGSDATUM == cell_name ):

          outdata = h.datum_str_make_correction(outdata)

          if( h.datum_str_is_correct(outdata) == False ):

            t = f"Anfangsdatum vom Konto {title} ist nicht richtig geschrieben {out_liste[i]}"
            sguicommand.anzeige_error(texteingabe=t,commands=commands,title="Error Datum Format")
            error_flag = True
          else:
            dout[cell_name] = outdata
          #endif

        else:
          dout[cell_name] = outdata
        #endif
        if( error_flag):
          break
    #endfor
  #endwhile

  # Werte in Datenbank schreiben
  db.setAnlagenkontoDaten(anlagekontoname,dout)

  # Fehlerabfrage
  #------------------------------------------------------------
  if( db.status != hdef.OKAY ):
    t = f"run_Anlagekonto_bearbeiten: Daten von Konto {anlagekontoname} konnten nicht in db gespeichert werden\n {db.errtext}"
    stat.set_NOT_OKAY(t)
    sguicommand.anzeige_error(texteingabe=t,commands=commands,title="Error Kontoname")
    return
  #endif

  return
#enddef

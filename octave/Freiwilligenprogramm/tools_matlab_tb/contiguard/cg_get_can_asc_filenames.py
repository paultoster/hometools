# Generated with SMOP  0.41-beta
from libsmop import *
# cg_get_can_asc_filenames.m

    
@function
def cg_get_can_asc_filenames(q=None,*args,**kwargs):
    varargin = cg_get_can_asc_filenames.varargin
    nargin = cg_get_can_asc_filenames.nargin

    
    # fliste = cg_get_asc_filenames(q)
    
    # q.read_type      = 1  Verzeichnisse müssen ausgewählt werden
#                       q.start_dir angeben, um
#                       Daten-Verzeichnis auszuwählen
#                       (tacc-Messordner oder Ordner mit
#                       CAN-ascii-Dateien)
#                       (q.start_dir angeben)
#                  = 2  CAN-ascii-Dateien auswählen
#                       (q.start_dir angeben)
#                  = 3  übergeordnetes Verzeichnis zu Einlesen 
#                       angeben q.read_meas_path angeben
#                       (q.read_meas_path angeben)
#                  = 4  Liste mit einzulesenden Messverzeichnissen 
#                       q.read_list = {'dir1',dir2'}oder
#                       explizite Canalyser-Ascii Dateien in
#                       q.read_list = {'datei1.asc','datei2.asc'}
#                       angeben
                  # = 5  namexyz_e.mat-Datei einlesen und
                  #      Nachbearbeitung nochmal durchführen
                  # = 6  Verzeichnis auswählen, mit dem
                  #      Namen des  Verzeichnisses wird die
                  #      gespeichert
#                  (default: 2)
    
    # q.start_dir        (q.read_type = 1,2) Start-Dir zum Suchen
    
    # q.file_number      (q.read_type = 2)  Anzahl der Dateien =0 beliebig (=0 default) 
# 
# q.read_meas_path   (q.read_type = 3) Verzeichnis unter dem alle 
#                                      Messungen gewandelt werden
# q.read_list        (q.read_type = 4) Liste mit Dateien (Canalyser-ascii)
#                                      oder Verzeichnissen
    
    # q.TACCread         = 1   TACC-Messungen sollen eingelsen werden (default 0)
# q.CANread          = 1   CAN-Daten sollen einegelesen werden (default 1)
# q.ECALread         = 1   ECAL-Daten sollen eingelsen werden
    
    # q.CANFileNameExclude   cell  auszuschliessende can-Datei-Namen
# q.CANFileNameTACC      char  ausschliesslicher can-Datei-Name bei
#                              TACC-Messung
    
    # Ausgabe:
# Struktur-Liste:
    
    # fliste(i).name        = 'measxyz'          Name
# fliste(i).meas_dir    = 'd:\abc\measxyz'   Verzeichnis
# fliste(i).can_file    = 'calogXXX.asc'     can-asc-file
# fliste(i).ecal        = 0/1                ist ecal-Messung vorhanden
# fliste(i).tacc        = 0/1                ist TaskData-Verzeichnis vorhanden
# fliste(i).description = 0/1                ist description-file vorhanden
# fliste(i).ecal_files  = {...}              liste mit hdf5-Files
    
    if (logical_not(check_val_in_struct(q,'TACCread','num',1))):
        q.TACCread = copy(0)
# cg_get_can_asc_filenames.m:57
    
    if (logical_not(check_val_in_struct(q,'ECALread','num',1))):
        q.ECALread = copy(0)
# cg_get_can_asc_filenames.m:60
    
    if (logical_not(check_val_in_struct(q,'CANread','num',1))):
        q.CANread = copy(1)
# cg_get_can_asc_filenames.m:63
    
    if (logical_not(check_val_in_struct(q,'read_type','num',1))):
        q.read_type = copy(2)
# cg_get_can_asc_filenames.m:66
    
    if (logical_not(check_val_in_struct(q,'start_dir','char',1))):
        q.start_dir = copy(get_drive(pwd))
# cg_get_can_asc_filenames.m:69
    
    if (logical_not(check_val_in_struct(q,'file_number','numeric',1))):
        q.file_number = copy(0)
# cg_get_can_asc_filenames.m:72
    
    
    if (q.read_type == 3 and logical_not(check_val_in_struct(q,'read_meas_path','char',1))):
        error('%s_error: q.read_meas_path nicht angegeben',mfilename)
    
    if (q.read_type == 3 and logical_not(exist(q.read_meas_path,'dir'))):
        error('%s_error: q.read_meas_path = <%s> konnte nicht gefunden werden',mfilename,q.read_meas_path)
    
    
    if (q.read_type == 4 and logical_not(check_val_in_struct(q,'read_list','cell',1))):
        error('%s_error: q.read_list nicht angegeben',mfilename)
    
    
    if (logical_not(check_val_in_struct(q,'CANFileNameExclude','cell'))):
        q.CANFileNameExclude = copy(cellarray([]))
# cg_get_can_asc_filenames.m:87
    
    if (check_val_in_struct(q,'CANFileNameTACC','cell')):
        error('%s_error: q.CANFileNameTACC ist cellarray, soll aber char sein',mfilename)
    
    if (logical_not(check_val_in_struct(q,'CANFileNameTACC','char'))):
        q.CANFileNameTACC = copy('')
# cg_get_can_asc_filenames.m:93
    else:
        s_file=str_get_pfe_f(q.CANFileNameTACC)
# cg_get_can_asc_filenames.m:95
        q.CANFileNameTACC = copy(s_file.name)
# cg_get_can_asc_filenames.m:96
    
    # Proof Names
    for i in arange(1,length(q.CANFileNameExclude)).reshape(-1):
        s_file=str_get_pfe_f(q.CANFileNameExclude[i])
# cg_get_can_asc_filenames.m:101
        q.CANFileNameExclude[i]=s_file.name
# cg_get_can_asc_filenames.m:102
    
    
    can_gz_files_len=0
# cg_get_can_asc_filenames.m:105
    
    if (q.read_type == 1):
        # Path auswählen
    #---------------
        s_frage.comment = copy('Pfad mit den Messungen auswählen')
# cg_get_can_asc_filenames.m:110
        s_frage.start_dir = copy(q.start_dir)
# cg_get_can_asc_filenames.m:111
        path_okay,c_dirname=o_abfragen_dir_f(s_frage,nargout=2)
# cg_get_can_asc_filenames.m:112
        if (path_okay):
            q.read_meas_path = copy(c_dirname[1])
# cg_get_can_asc_filenames.m:114
        else:
            fliste=[]
# cg_get_can_asc_filenames.m:116
            return fliste
        # Datei auswählen, wenn read_type == 2
    else:
        if (q.read_type == 2):
            # Path auswählen
    #---------------
            s_frage.comment = copy('CAN-Ascii-Dateien auswählen')
# cg_get_can_asc_filenames.m:123
            s_frage.start_dir = copy(q.start_dir)
# cg_get_can_asc_filenames.m:124
            s_frage.file_spec = copy('*.asc')
# cg_get_can_asc_filenames.m:125
            s_frage.file_number = copy(q.file_number)
# cg_get_can_asc_filenames.m:126
            file_okay,c_filenames=o_abfragen_files_f(s_frage,nargout=2)
# cg_get_can_asc_filenames.m:128
            if (file_okay):
                q.read_list = copy(c_filenames)
# cg_get_can_asc_filenames.m:131
                q.read_type = copy(4)
# cg_get_can_asc_filenames.m:132
            else:
                fliste=[]
# cg_get_can_asc_filenames.m:134
                return fliste
        else:
            if (q.read_type == 5):
                # Path auswählen
    #---------------
                s_frage.comment = copy('Pfad mit den Messungen auswählen')
# cg_get_can_asc_filenames.m:140
                s_frage.start_dir = copy(q.start_dir)
# cg_get_can_asc_filenames.m:141
                path_okay,c_dirname=o_abfragen_dir_f(s_frage,nargout=2)
# cg_get_can_asc_filenames.m:142
                if (path_okay):
                    q.read_meas_path = copy(c_dirname[1])
# cg_get_can_asc_filenames.m:144
                else:
                    fliste=[]
# cg_get_can_asc_filenames.m:146
                    return fliste
    
    # Anlegen von allen tacc-dirs (inclusive TaskData)
  # und can_files
  #-------------------------------------------------
    if ((q.read_type == 1) or (q.read_type == 3) or (q.read_type == 5)):
        if (q.ECALread):
            ecal_dirs=get_ecal_files(q.read_meas_path)
# cg_get_can_asc_filenames.m:157
            can_files=suche_files_ext(get_sub_dirs(ecal_dirs),'asc')
# cg_get_can_asc_filenames.m:158
            can_files_len=length(can_files)
# cg_get_can_asc_filenames.m:159
        else:
            if (q.CANread):
                can_files,can_files_len=suche_files_f(q.read_meas_path,'asc',1,nargout=2)
# cg_get_can_asc_filenames.m:164
                can_gz_files,can_gz_files_len=suche_files_f(q.read_meas_path,'gz',1,nargout=2)
# cg_get_can_asc_filenames.m:165
            else:
                can_files=[]
# cg_get_can_asc_filenames.m:167
                can_files_len=0
# cg_get_can_asc_filenames.m:167
            if (q.TACCread):
                tacc_dirs,tacc_dirs_len=suche_dir(q.read_meas_path,1,'TaskData',nargout=2)
# cg_get_can_asc_filenames.m:171
            else:
                tacc_dirs=cellarray([])
# cg_get_can_asc_filenames.m:173
                tacc_dirs_len=0
# cg_get_can_asc_filenames.m:173
    else:
        n=length(q.read_list)
# cg_get_can_asc_filenames.m:178
        can_files=[]
# cg_get_can_asc_filenames.m:179
        can_files_len=0
# cg_get_can_asc_filenames.m:180
        can_gz_files=[]
# cg_get_can_asc_filenames.m:181
        can_gz_files_len=0
# cg_get_can_asc_filenames.m:182
        tacc_dirs=cellarray([])
# cg_get_can_asc_filenames.m:183
        tacc_dirs_len=0
# cg_get_can_asc_filenames.m:184
        for i in arange(1,n).reshape(-1):
            if (exist(q.read_list[i],'file') == 2):
                can_file=suche_files_f(q.read_list[i],'asc',0,1)
# cg_get_can_asc_filenames.m:187
                can_files_len=can_files_len + 1
# cg_get_can_asc_filenames.m:188
                if (can_files_len == 1):
                    can_files=copy(can_file)
# cg_get_can_asc_filenames.m:190
                else:
                    can_files[can_files_len]=can_file
# cg_get_can_asc_filenames.m:192
                can_gz_file=suche_files_f(q.read_list[i],'gz',0,1)
# cg_get_can_asc_filenames.m:194
                if (logical_not(isempty(can_gz_file))):
                    can_gz_files_len=can_gz_files_len + 1
# cg_get_can_asc_filenames.m:196
                    if (can_gz_files_len == 1):
                        can_gz_files=copy(can_gz_file)
# cg_get_can_asc_filenames.m:198
                    else:
                        can_gz_files[can_gz_files_len]=can_gz_file
# cg_get_can_asc_filenames.m:200
            else:
                if (exist(q.read_list[i],'dir') == 7):
                    tt=str_change_f(q.read_list[i],'/','\')
# cg_get_can_asc_filenames.m:207
                    c_names,icount=str_split(tt,'\',nargout=2)
# cg_get_can_asc_filenames.m:208
                    if (strcmpi(c_names[icount],'TaskData')):
                        tacc_dirs_len=tacc_dirs_len + 1
# cg_get_can_asc_filenames.m:212
                        tacc_dirs[tacc_dirs_len]=q.read_list[i]
# cg_get_can_asc_filenames.m:213
                        dd=c_names[1]
# cg_get_can_asc_filenames.m:215
                        for idd in arange(2,icount - 1).reshape(-1):
                            dd=fullfile(dd,c_names[idd])
# cg_get_can_asc_filenames.m:216
                        cf,cf_len=suche_files_f(dd,'asc',1,nargout=2)
# cg_get_can_asc_filenames.m:218
                        for j in arange(1,cf_len).reshape(-1):
                            can_files_len=can_files_len + 1
# cg_get_can_asc_filenames.m:220
                            if (can_files_len == 1):
                                can_files=cf(j)
# cg_get_can_asc_filenames.m:222
                            else:
                                can_files[can_files_len]=cf(j)
# cg_get_can_asc_filenames.m:224
                        cf,cf_len=suche_files_f(q.read_list[i],'gz',1,nargout=2)
# cg_get_can_asc_filenames.m:227
                        for j in arange(1,cf_len).reshape(-1):
                            can_gz_files_len=can_gz_files_len + 1
# cg_get_can_asc_filenames.m:229
                            if (can_gz_files_len == 1):
                                can_gz_files=cf(j)
# cg_get_can_asc_filenames.m:231
                            else:
                                can_gz_files[can_gz_files_len]=cf(j)
# cg_get_can_asc_filenames.m:233
                    else:
                        dd=fullfile(q.read_list[i],'TaskData')
# cg_get_can_asc_filenames.m:237
                        if (exist(dd,'dir') == 7):
                            tacc_dirs_len=tacc_dirs_len + 1
# cg_get_can_asc_filenames.m:239
                            tacc_dirs[tacc_dirs_len]=dd
# cg_get_can_asc_filenames.m:240
                        cf,cf_len=suche_files_f(q.read_list[i],'asc',1,nargout=2)
# cg_get_can_asc_filenames.m:242
                        for j in arange(1,cf_len).reshape(-1):
                            can_files_len=can_files_len + 1
# cg_get_can_asc_filenames.m:244
                            if (can_files_len == 1):
                                can_files=cf(j)
# cg_get_can_asc_filenames.m:246
                            else:
                                can_files[can_files_len]=cf(j)
# cg_get_can_asc_filenames.m:248
                        cf,cf_len=suche_files_f(q.read_list[i],'gz',1,nargout=2)
# cg_get_can_asc_filenames.m:251
                        for j in arange(1,cf_len).reshape(-1):
                            can_gz_files_len=can_gz_files_len + 1
# cg_get_can_asc_filenames.m:253
                            if (can_gz_files_len == 1):
                                can_gz_files=cf(j)
# cg_get_can_asc_filenames.m:255
                            else:
                                can_gz_files[can_gz_files_len]=cf(j)
# cg_get_can_asc_filenames.m:257
                    # ecal
                    ecal_dirs=get_ecal_files(q.read_list[i])
# cg_get_can_asc_filenames.m:263
                else:
                    error('cg_get_filenames: Angegebenes Verzeichnis oder Datei <%s> nicht vorhanden',q.read_list[i])
    
    if (can_gz_files_len > 0):
        can_files,can_files_len=cg_get_filenames_unzip(can_files,can_files_len,can_gz_files,can_gz_files_len,1,nargout=2)
# cg_get_can_asc_filenames.m:270
    
    if (q.ECALread):
        fliste=cg_read_meas_data_get_ecal_filenames_find(ecal_dirs,can_files,can_files_len)
# cg_get_can_asc_filenames.m:273
    else:
        fliste=cg_read_meas_data_get_filenames_find(can_files,can_files_len,tacc_dirs,tacc_dirs_len,q.TACCread,q.CANFileNameExclude,q.CANFileNameTACC)
# cg_get_can_asc_filenames.m:275
    
    
    if (q.read_type == 5):
        fliste=fliste(1)
# cg_get_can_asc_filenames.m:279
        rel_dir=get_rel_dir(fliste.meas_dir,q.read_meas_path)
# cg_get_can_asc_filenames.m:281
        if (logical_not(isempty(fliste.can_file))):
            fliste.can_file = copy(fullfile(rel_dir,fliste.can_file))
# cg_get_can_asc_filenames.m:283
        # measure-path
        fliste.meas_dir = copy(q.read_meas_path)
# cg_get_can_asc_filenames.m:286
        liste=cell_get_from_pathname(fliste.meas_dir)
# cg_get_can_asc_filenames.m:288
        fliste.name = copy(liste[end()])
# cg_get_can_asc_filenames.m:289
        liste=suche_files_f(fliste.meas_dir,concat([fliste.name,'.hdf5']),1,0)
# cg_get_can_asc_filenames.m:293
        files=cellarray([])
# cg_get_can_asc_filenames.m:294
        for iii in arange(1,length(liste)).reshape(-1):
            files=cell_add(files,liste(iii).full_name)
# cg_get_can_asc_filenames.m:296
        fliste.ecal_files = copy(files)
# cg_get_can_asc_filenames.m:298
    
    return fliste
    
if __name__ == '__main__':
    pass
    
    
@function
def cg_read_meas_data_get_filenames_find(can_files=None,can_files_len=None,tacc_dirs=None,tacc_dirs_len=None,tacc_read=None,CANFileNameExclude=None,CANFileNameTACC=None,*args,**kwargs):
    varargin = cg_read_meas_data_get_filenames_find.varargin
    nargin = cg_read_meas_data_get_filenames_find.nargin

    
    # Bildet Liste aus can_files und tacc_dirs
    
    fliste=[]
# cg_get_can_asc_filenames.m:306
    fliste_len=0
# cg_get_can_asc_filenames.m:307
    can_files,can_files_len=cg_read_meas_data_proof_can_files(can_files,can_files_len,CANFileNameExclude,nargout=2)
# cg_get_can_asc_filenames.m:309
    
    # A) keine tacc_dir angegeben
  #----------------------------
    if ((can_files_len > 0) and (tacc_dirs_len == 0)):
        for i in arange(1,can_files_len).reshape(-1):
            fliste_len=fliste_len + 1
# cg_get_can_asc_filenames.m:316
            f=cg_read_meas_data_get_filenames_f_can_files(can_files(i))
# cg_get_can_asc_filenames.m:318
            if (logical_not(tacc_read)):
                f.tacc = copy(0)
# cg_get_can_asc_filenames.m:320
            if (isempty(fliste)):
                fliste=copy(f)
# cg_get_can_asc_filenames.m:323
            else:
                fliste[fliste_len]=f
# cg_get_can_asc_filenames.m:325
        #----------------------------
  # B) keine can_files angegeben
  #----------------------------
    else:
        if ((can_files_len == 0) and (tacc_dirs_len > 0)):
            for i in arange(1,tacc_dirs_len).reshape(-1):
                f=cg_read_meas_data_get_filenames_f_tacc_dirs(tacc_dirs[i])
# cg_get_can_asc_filenames.m:333
                if (f.tacc > 0):
                    f.can_file = copy('')
# cg_get_can_asc_filenames.m:335
                    fliste_len=fliste_len + 1
# cg_get_can_asc_filenames.m:336
                    if (isempty(fliste)):
                        fliste=copy(f)
# cg_get_can_asc_filenames.m:338
                    else:
                        fliste[fliste_len]=f
# cg_get_can_asc_filenames.m:340
            #-------------------------------------
  # C) tacc_dirs und can_files angegeben
  #-------------------------------------
        else:
            if ((can_files_len > 0) and (tacc_dirs_len > 0)):
                # CAN-Files durchgehen
                for i in arange(1,can_files_len).reshape(-1):
                    # Alle CAN-Files nehmen, wenn CANFileNameTACC leer
      # aber wenn nicht leer, dann nur dieses File nehmen
                    if (isempty(CANFileNameTACC) or strcmpi(CANFileNameTACC,can_files(i).body)):
                        fliste_len=fliste_len + 1
# cg_get_can_asc_filenames.m:355
                        f=cg_read_meas_data_get_filenames_f_can_files(can_files(i))
# cg_get_can_asc_filenames.m:357
                        ifound=cell_find_f(tacc_dirs,fullfile(f.meas_dir,'TaskData'),'fl')
# cg_get_can_asc_filenames.m:360
                        if (logical_not(isempty(ifound))):
                            f.tacc = copy(1)
# cg_get_can_asc_filenames.m:362
                            tacc_dirs=cell_cut(tacc_dirs,ifound(1))
# cg_get_can_asc_filenames.m:363
                        else:
                            f.tacc = copy(0)
# cg_get_can_asc_filenames.m:365
                        if (isempty(fliste)):
                            fliste=copy(f)
# cg_get_can_asc_filenames.m:369
                        else:
                            fliste[fliste_len]=f
# cg_get_can_asc_filenames.m:371
                # Tacc-Verzeichnis durchsuchen
                tacc_dirs_len=length(tacc_dirs)
# cg_get_can_asc_filenames.m:376
                for i in arange(1,tacc_dirs_len).reshape(-1):
                    f=cg_read_meas_data_get_filenames_f_tacc_dirs(tacc_dirs[i])
# cg_get_can_asc_filenames.m:379
                    if (f.tacc > 0):
                        f.can_file = copy('')
# cg_get_can_asc_filenames.m:381
                        fliste_len=fliste_len + 1
# cg_get_can_asc_filenames.m:382
                        if (isempty(fliste)):
                            fliste=copy(f)
# cg_get_can_asc_filenames.m:384
                        else:
                            fliste[fliste_len]=f
# cg_get_can_asc_filenames.m:386
    
    #       fliste(1).name        = s2_file.body;
#       fliste(1).meas_dir    = ecal_master_dir;
#       fliste(1).tacc        = 0;
#       fliste(1).can_file    = '';
#       fliste(1).ecal        = 1;
#       fliste(1).ecal_files  = ecal_files;
#       fliste(1).description = 0;
    
    
    return fliste
    
if __name__ == '__main__':
    pass
    
    
@function
def cg_read_meas_data_get_ecal_filenames_find(ecaldirs=None,can_files=None,can_files_len=None,*args,**kwargs):
    varargin = cg_read_meas_data_get_ecal_filenames_find.varargin
    nargin = cg_read_meas_data_get_ecal_filenames_find.nargin

    #       fliste(1).name        = s2_file.body;
    #       fliste(1).meas_dir    = ecal_master_dir;
    #       fliste(1).tacc        = 0;
    #       fliste(1).can_file    = '';
    #       fliste(1).ecal        = 1;
    #       fliste(1).ecal_files  = ecal_files;
    #       fliste(1).description = 0;
    fliste=struct([])
# cg_get_can_asc_filenames.m:409
    for i in arange(1,length(ecaldirs)).reshape(-1):
        fliste(i).name = copy(get_last_name_from_dir(ecaldirs[i]))
# cg_get_can_asc_filenames.m:411
        fliste(i).meas_dir = copy(ecaldirs[i])
# cg_get_can_asc_filenames.m:412
        fliste(i).tacc = copy(0)
# cg_get_can_asc_filenames.m:413
        fliste(i).can_file = copy('')
# cg_get_can_asc_filenames.m:414
        for j in arange(1,can_files_len).reshape(-1):
            if (is_dir_in_dir(ecaldirs[i],can_files(j).dir)):
                fliste(i).can_file = copy(fullfile(get_subdirs_from_dir(ecaldirs[i],can_files(j).dir),concat([can_files(j).name,'.',can_files(j).ext])))
# cg_get_can_asc_filenames.m:417
        fliste(i).ecal = copy(1)
# cg_get_can_asc_filenames.m:421
        fliste(i).ecal_files = copy(cellarray([]))
# cg_get_can_asc_filenames.m:422
        fliste(i).description = copy(0)
# cg_get_can_asc_filenames.m:423
    
    return fliste
    
if __name__ == '__main__':
    pass
    
    
@function
def cg_read_meas_data_proof_can_files(can_files=None,can_files_len=None,CANFileNameExclude=None,*args,**kwargs):
    varargin = cg_read_meas_data_proof_can_files.varargin
    nargin = cg_read_meas_data_proof_can_files.nargin

    # double files
    i=1
# cg_get_can_asc_filenames.m:429
    while (i <= can_files_len):

        flag=1
# cg_get_can_asc_filenames.m:431
        for j in arange(i + 1,can_files_len).reshape(-1):
            if (strcmpi(can_files(i).full_name,can_files(j).full_name)):
                flag=0
# cg_get_can_asc_filenames.m:434
                for k in arange(j + 1,can_files_len).reshape(-1):
                    can_files[k - 1]=can_files(k)
# cg_get_can_asc_filenames.m:436
                can_files_len=can_files_len - 1
# cg_get_can_asc_filenames.m:438
                break
        if (flag):
            i=i + 1
# cg_get_can_asc_filenames.m:443

    
    
    n=length(CANFileNameExclude)
# cg_get_can_asc_filenames.m:447
    n1=length(can_files)
# cg_get_can_asc_filenames.m:448
    if (n and n1):
        for j in arange(1,length(CANFileNameExclude)).reshape(-1):
            indexlist=struct_find_all_in_field(can_files,'body',CANFileNameExclude[j])
# cg_get_can_asc_filenames.m:451
            can_files=struct_delete_item(can_files,indexlist)
# cg_get_can_asc_filenames.m:452
            #       flag = 0;
#       for i=1:length(can_files)
#         if( strcmpi(can_files(i).body,CANFileNameExclude{j}) )
#           iout = i;
#           flag = 1;
#           break;
#         end
#       end
#       if( flag )
#         can_files = struct_delete_item(can_files,iout);
#       end
    
    can_files_len_out=length(can_files)
# cg_get_can_asc_filenames.m:466
    return can_files,can_files_len_out
    
if __name__ == '__main__':
    pass
    
    
@function
def cg_read_meas_data_get_filenames_f_can_files(can_file=None,*args,**kwargs):
    varargin = cg_read_meas_data_get_filenames_f_can_files.varargin
    nargin = cg_read_meas_data_get_filenames_f_can_files.nargin

    # bildet aus can_file ein struktur-element mit
# f.name        = 'measxyz'          Name
# f.meas_dir    = 'd:\abc\measxyz'   Verzeichnis
# f.can_file    = 'calogXXX.asc'     can-asc-file
# f.tacc        = 0/1                ist TaskData-Verzeichnis vorhanden
# f.description = 0/1                ist description-file vorhanden
    
    f.meas_dir = copy(can_file.dir)
# cg_get_can_asc_filenames.m:476
    f.can_file = copy(concat([can_file.body,'.',can_file.ext]))
# cg_get_can_asc_filenames.m:477
    
    #-------------------
    i0=str_find_f(can_file.name,'canlog','vs')
# cg_get_can_asc_filenames.m:480
    if (i0 > 0):
        c_names,ncount=str_split(can_file.dir,'\',nargout=2)
# cg_get_can_asc_filenames.m:482
        name='mat_out'
# cg_get_can_asc_filenames.m:483
        for i in arange(ncount,1,- 1).reshape(-1):
            if (logical_not(isempty(c_names[i]))):
                name=c_names[i]
# cg_get_can_asc_filenames.m:486
                break
        f.name = copy(name)
# cg_get_can_asc_filenames.m:490
        if (exist(fullfile(can_file.dir,'description.txt'),'file')):
            f.description = copy(1)
# cg_get_can_asc_filenames.m:493
        else:
            f.description = copy(0)
# cg_get_can_asc_filenames.m:495
    else:
        f.name = copy(can_file.body)
# cg_get_can_asc_filenames.m:499
        f.description = copy(0)
# cg_get_can_asc_filenames.m:500
    
    
    tacc_dir=fullfile(can_file.dir,'TaskData')
# cg_get_can_asc_filenames.m:503
    if (exist(tacc_dir,'dir')):
        f.tacc = copy(1)
# cg_get_can_asc_filenames.m:505
    else:
        f.tacc = copy(0)
# cg_get_can_asc_filenames.m:507
    
    return f
    
if __name__ == '__main__':
    pass
    
    
    
@function
def cg_read_meas_data_get_filenames_f_tacc_dirs(tacc_dir=None,*args,**kwargs):
    varargin = cg_read_meas_data_get_filenames_f_tacc_dirs.varargin
    nargin = cg_read_meas_data_get_filenames_f_tacc_dirs.nargin

    # bildet aus tacc_dir
# f.name        = 'measxyz'          Name
# f.meas_dir    = 'd:\abc\measxyz'   Verzeichnis
# f.can_file    = 'calogXXX.asc'     can-asc-file
# f.tacc        = 0/1                ist TaskData-Verzeichnis vorhanden
# f.description = 0/1                ist description-file vorhanden
    
    # tacc
    i0=str_find_f(lower(tacc_dir),'taskdata','vs')
# cg_get_can_asc_filenames.m:522
    if (exist(tacc_dir,'dir')):
        dd=dir(tacc_dir)
# cg_get_can_asc_filenames.m:524
    else:
        dd=[]
# cg_get_can_asc_filenames.m:526
    
    if (i0 > 0 and length(dd) > 1):
        if ((i0 > 1) and ((tacc_dir(i0 - 1) == '\') or (tacc_dir(i0 - 1) == '/'))):
            i0=i0 - 1
# cg_get_can_asc_filenames.m:531
        if (i0 > 1):
            i0=i0 - 1
# cg_get_can_asc_filenames.m:534
        f.meas_dir = copy(tacc_dir(arange(1,i0)))
# cg_get_can_asc_filenames.m:536
        f.tacc = copy(1)
# cg_get_can_asc_filenames.m:537
        c_names,ncount=str_split(f.meas_dir,'\',nargout=2)
# cg_get_can_asc_filenames.m:539
        name='mat_out'
# cg_get_can_asc_filenames.m:540
        for i in arange(ncount,1,- 1).reshape(-1):
            if (logical_not(isempty(c_names[i]))):
                name=c_names[i]
# cg_get_can_asc_filenames.m:543
                break
        f.name = copy(name)
# cg_get_can_asc_filenames.m:547
        f.can_file = copy('')
# cg_get_can_asc_filenames.m:549
        can_files,can_files_len=suche_files_f(f.meas_dir,'asc',0,nargout=2)
# cg_get_can_asc_filenames.m:550
        for i in arange(1,can_files_len).reshape(-1):
            i0=str_find_f(lower(can_files(i).name),'canlog','vs')
# cg_get_can_asc_filenames.m:552
            if (i0 > 0):
                f.can_file = copy(can_files(i).name)
# cg_get_can_asc_filenames.m:554
        if (exist(fullfile(f.meas_dir,'description.txt'),'file')):
            f.description = copy(1)
# cg_get_can_asc_filenames.m:559
        else:
            f.description = copy(0)
# cg_get_can_asc_filenames.m:561
    else:
        f.meas_dir = copy(tacc_dir)
# cg_get_can_asc_filenames.m:565
        f.tacc = copy(0)
# cg_get_can_asc_filenames.m:566
        f.can_file = copy('')
# cg_get_can_asc_filenames.m:567
        f.description = copy(0)
# cg_get_can_asc_filenames.m:568
        f.name = copy('')
# cg_get_can_asc_filenames.m:569
    
    ff.meas_dir = copy(f.meas_dir)
# cg_get_can_asc_filenames.m:572
    ff.can_file = copy(f.can_file)
# cg_get_can_asc_filenames.m:573
    ff.name = copy(f.name)
# cg_get_can_asc_filenames.m:574
    ff.description = copy(f.description)
# cg_get_can_asc_filenames.m:575
    ff.tacc = copy(f.tacc)
# cg_get_can_asc_filenames.m:576
    return ff
    
if __name__ == '__main__':
    pass
    
    
@function
def cg_get_filenames_unzip(cf=None,cf_len=None,cfgz=None,cfgz_len=None,delete_gz=None,*args,**kwargs):
    varargin = cg_get_filenames_unzip.varargin
    nargin = cg_get_filenames_unzip.nargin

    if (logical_not(exist('delete_gz','var'))):
        delete_gz=0
# cg_get_can_asc_filenames.m:581
    
    for i in arange(1,cfgz_len).reshape(-1):
        tt=str_cut_ae_f(cfgz(i).dir,'\')
# cg_get_can_asc_filenames.m:584
        c_names,ncount=str_split(tt,'\',nargout=2)
# cg_get_can_asc_filenames.m:585
        flag=1
# cg_get_can_asc_filenames.m:586
        dirout=cfgz(i).dir
# cg_get_can_asc_filenames.m:587
        if (strcmp(c_names[ncount],'TaskData')):
            flag=2
# cg_get_can_asc_filenames.m:589
            dirout=''
# cg_get_can_asc_filenames.m:590
            for ii in arange(1,ncount - 1).reshape(-1):
                dirout=fullfile(dirout,c_names[ii])
# cg_get_can_asc_filenames.m:592
        if (flag):
            # entzippen
            fprintf('%s: Unzip: <%s>\n',mfilename,cfgz(i).full_name)
            try:
                gunzip(cfgz(i).full_name,dirout)
                if (delete_gz):
                    fprintf('%s: Delete: <%s>\n',mfilename,cfgz(i).full_name)
                    delete(cfgz(i).full_name)
                # Suchen in cf-Liste
                flag=1
# cg_get_can_asc_filenames.m:605
                for j in arange(1,cf_len).reshape(-1):
                    if (strcmp(cfgz(i).dir,cf(j).dir)):
                        flag=0
# cg_get_can_asc_filenames.m:608
                        break
                if (flag):
                    file_list,i_file_list=suche_files_f(fullfile(dirout,cfgz(i).body),'*',0,1,nargout=2)
# cg_get_can_asc_filenames.m:613
                    cf_len=cf_len + 1
# cg_get_can_asc_filenames.m:614
                    if (cf_len == 1):
                        cf=file_list(1)
# cg_get_can_asc_filenames.m:616
                    else:
                        cf[cf_len]=file_list(1)
# cg_get_can_asc_filenames.m:618
            finally:
                pass
    
    
    return cf,cf_len
    
if __name__ == '__main__':
    pass
    
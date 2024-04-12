function   [okay,f] = duh_daten_speichern_format(s_data,filename,type)
%
% Datenspeichern im Format type = 'dspa'    Dspace-Format (Matlab) (für Wave
%                                           geeignet, der erste Vektor ist dann der unabhängige Vektor
%                               = 'duh'     Data-Unit-Header-Format (Matlab) (wie
%                                           diaread)
%                               = 'vec'     Einzelne Vektoren (Matlab)
%                               = 'csv'     CSV-Format
%                               = 'dia'     Diadem-Format r32
%                               = 'dia_asc' Diadem-Format ascii
%                               = 'm'       M-Datenformat
% s_data                        Struktur mit s_data.d Daten, s_data.u
%                               Einheit und s_data.h Header (cellarrays)
% filename                      Name der Datei einschliesslich Verzeichnis
%

[okay,f] = d_data_save(filename,s_data.d,s_data.u,s_data.h,type);



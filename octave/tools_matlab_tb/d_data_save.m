function [okay,f] = d_data_save(filename,d,u,h,type)
%
% okay = d_data_save(filename,d,u,h,type)
%
% filename          Dateiname mit Pfad
% d                 Datenstruktur äquidistant fängt mit Zeitvektor (Spaltenvektor) an
%                   d.time = [0;0.01;0.02; ... ]
%                   d.F    = [1;1.05;1.10; ... ]
%                   ...
% u                 Unitstruktur mit Unitnamen
%                   u.time = 's'
%                   u.F    = 'N'
%                    ...
% h                Header-Cellarray
% type = 'dspa','mat_dspa'    Dspace-Format (Matlab) (für Wave
%                  geeignet, der erste Vektor ist dann der unabhängige Vektor
%      = 'duh','mat_duh'     Data-Unit-Header-Format (Matlab) (wie
%                  diaread)
%      = 'vec'     Einzelne Vektoren (Matlab)
%      = 'csv'     CSV-Format
%      = 'dia'     Diadem-Format r32
%      = 'dia_asc' Diadem-Format ascii
%      = 'm'       M-Datenformat

okay = 1;
f    = '';

if( ~exist('type','var') )
    type = 'duh';
end

sfile = str_get_pfe_f(filename);

if( ~exist(sfile.dir,'dir') && ~isempty(sfile.dir) )
    mkdir(sfile.dir)
end

if( strcmp(type,'dspa') || strcmp(type,'mat_dspadspa')  )
    
    f        = change_file_ext(filename,'mat',1);
    xname    = fieldnames(d);
    xname    = char(xname{1});
    data     = conv_dia_to_dspa_f(d, ...
                                  u, ...
                                  xname,f, ...
                                  h);
   v = version('-release');
   if( strcmp(v(1:2),'14') )
      command  =  ['save -v6 ''',f,''' data'];
   else
      command  =  ['save ''',f,''' data'];
   end
   eval(command);
   
elseif( strcmp(type,'duh') ||  strcmp(type,'mat_duh'))
    
   f        = change_file_ext(filename,'mat',1);
   v = version('-release');
   if( strcmp(v(1:2),'14') )
       command  =  ['save -v6 ''',f,''' d u h'];
   else
       command  =  ['save ''',f,''' d u h'];
   end
   eval(command);
elseif( strcmp(type,'vec') )

   f        = change_file_ext(filename,'mat',1);
   c_names = fieldnames(d);
   
   tliste = '';
   for i=1:length(c_names)
       
       tliste = [tliste,' ',c_names{i}];
       command = [c_names{i},' = d.',c_names{i},';'];
       eval(command)
   end

   v = version('-release');
   if( strcmp(v(1:2),'14') )
       command  =  ['save -v6 ''',f,''' ',tliste];
   else
       command  =  ['save ''',f,''' ',tliste];
   end
   eval(command);
   
elseif( strcmp(type,'csv') )
    
    f        = change_file_ext(filename,'csv',1);
   dascsvsave(f,d,u);
   
elseif( strcmp(type,'dia') || strcmp(type,'dia_asc'))
    
    f        = change_file_ext(filename,'dat',1);
   diasave(d,u,f,type);
   
elseif( strcmp(type,'m') )
    f        = change_file_ext(filename,'m',1);
    msave(f, d,u);
end



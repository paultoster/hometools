function [d,u,f]=csvread(filename,seperator,cut_varname,c_signame,typ)
%
% [d,u,f]=csvread(filename,seperator,cut_varname,c_signame,typ)
% CSV-Datei von einlesen
% cut_varname    cell    Liste mit Teile des Variablennamen, die aus dem Namen rausgeschnitten werden
%                        sollen, '.',',',':' z. B.  default {}
% c_signame      cell    Liste mit einzulesenden Signalnamen default {}
% typ            double  0: kein Headerlinie mit Namen
%                        1: eine Headerlinie mit Namen
%                        2: erste Zeile Namen, 2. Zeile Units
%                        default 1
% '.dat'-Datei wählen, wenn kein Eingabeargument

d={};
u={};
f='';
if( ~exist('seperator','var') )
    seperator = ';';
end
if( ~exist('cut_varname','var') )
    cut_varname = {};
end
if( ischar(cut_varname) )
    cut_varname = {cut_varname};
end
if( ~exist('c_signame','var') )
  c_signame = {};
end
if( ischar(c_signame) )
    c_signame = {c_signame};
end
if( ~iscell(c_signame) )
  c_signame = {};
end
if( ~exist('typ','var') )
  typ = 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dat-Datei auswählen und öffnen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
OriginalPathName = cd;
if nargin==0 || (nargin==1 && isempty(remblank(filename)))
   [file,path]=uigetfile('*.csv','(.csv)-Datenfile auswählen');
   if file==0
     d = 0;
     u = 0;
     f = 0;
     h = {};
     return
   end
   filename=[path, file];
else
    path = extract_path(filename);
end
cd (path)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% '.dat'-Datei einlesen
fprintf('\n[d,u,f]=csvread(''%s'',''%s'')\n',filename,seperator);
  
[d,u,f] = csvread_importdata(filename,seperator,c_signame,cut_varname,typ);

% M = importdata(filename,seperator);
% % Da die Standrdfunktion bei großen Dateien nicht funktioniert
% % selbst geschrieben
% 
% if( isfield(M,'colheaders') && ~isempty(M.colheaders) )
%     
%     f = filename;
%     
%     c_names = M.colheaders;
%     nn      = length(c_names);
%     
%     [ndata,mdata] = size(M.data);
%     
%     if( mdata ~= nn )
%         error('error in csvread: Daten Block ist größer als der Tabellenheader (Namenslänge)')
%     end
%     fprintf('===================================\n');
%     for i=1:length(c_names)
%         
%         c_names{i} = change_varname(c_names{i});
%         for j = 1:length(cut_varname)
%             c_names{i} = str_change_f(c_names{i},cut_varname{j},'');
%         end
%         
%         
%         fprintf('%i:%s\n',i,c_names{i});
%         
%         command = ['d.',c_names{i},'= M.data(:,i);'];
%         eval(command);
%         command = ['u.',c_names{i},'=''-'';'];
%         eval(command);
%     end
%     fprintf('===================================\n');
%     
% elseif( isfield(M,'textdata') )
%   
%   
% 
%    f = filename;
%    
%    [ndata,msig] = size(M.textdata);
%    
%    for isig = 1:msig
%      
%      name = M.textdata{1,isig};
%      
%      if( ~isempty(name) && isstrprop(name(1), 'alpha') ) % Sollte ein Name sein
%        
%        
%        if( strcmp(name,'VehicleDynamics_v_mps') )
%          abc = 0;
%        end
%        name = change_varname(name);
%         for j = 1:length(cut_varname)
%            name = str_change_f(name,cut_varname{j},'');
%         end
%       
%        if( strcmp(name,'VehicleDynamics_v_mps') )
%          abc = 0;
%        end
%        
%        ncount = 0;
%        vec    = [];
%        for j = 2:ndata
%          
%          data = str2num(M.textdata{j,isig});
%          if( isempty(data) )
%            break;
%          else
%            ncount = ncount+1;
%            vec    = [vec;data];
%          end
%        end
%        if( ncount > 0 )
%          d.(name) = vec;
%          u.(name) = '';
%        end
%      end
%    end
% 
%    
% end

cd(OriginalPathName);
fprintf(' Ende\n')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h=remblank(str)
%Entfernt saemtliche Leerzeichen des Strings
h='';
for i=1:length(str)
   if (str(i) ~= 32)
      h=strcat(h,str(i));
   end
end

%Extrahiere den Pfadname
function p=extract_path(str)

pos=strfind(str,'\');
if( isempty(pos) )
    p = '.\';
else
    pos=max(pos);
    p=str(1:pos);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [d,u,f] = csvread_importdata(filename,seperator,c_signame,cut_varname,typ)

d = struct;
u = struct;
f = '';

first_line_value_flag = 0;

[fid,message] = fopen(filename,'r');

if( fid < 0 )
  warning(message);
  return;
else
  f = filename;
end

tline = fgetl(fid);
if( ~ischar(tline) )
  error('Datei %s kann nicht gelesen werden ',filename);
end

[c_names,ncount] = str_split(tline,seperator);

if(typ == 1 || typ == 2)
  for i=1:length(c_names)  
    c_names{i} = change_varname(c_names{i});
  end
end

% Prüfen, ob erste Zeile Variablennamen sind oder
% wenn type == 0 dann ist kein Name in der ersten Zeile
% first_line_value_flag wird eins gesetzt
for i=1:ncount
  if( ~isvarname(c_names{i}) || (typ == 0) )
    first_line_value_flag = 1;
  end
end
for i=1:ncount
  
  if(first_line_value_flag)
    c_names{i} = sprintf('var%i',i);
  end
  
  for j = 1:length(cut_varname)
      c_names{i} = str_change_f(c_names{i},cut_varname{j},'');
  end
      
end

if( isempty(c_signame) )
  index_liste = [1:1:ncount]';
  c_out_names = c_names;
else
  index_liste = [];
  c_out_names = {};
  for i=1:ncount
    for j=1:length(c_signame)
      
      if( strcmp(c_signame{j},c_names{i}) )
        index_liste = [index_liste;i];
        c_out_names{length(c_out_names)+1} = c_names{i};
        break;
      end
    end
  end
end

ndata = length(c_out_names);

if( typ == 2 && ~first_line_value_flag ) % nächste Zeile Einheiten
  tline = fgetl(fid);
  if( ~ischar(tline) )
    error('Datei %s hat keine Daten',filename);
  end
  [c_names,ncount] = str_split(tline,seperator);
  
  c_out_units =  cell(length(c_out_names),1);
  
  for i=1:ndata
    if( index_liste(i) <= ncount )
      c_out_units{i} = c_names{index_liste(i)};
    else
      c_out_units{i} = '';
    end
  end 
else % ansonsten
  c_out_units =  cell(length(c_out_names),1);
  for i=1:length(c_out_names)
    c_out_units{i} = '';
  end
end

% Datenstruktur anlegen
%----------------------
for i=1:ndata
  d.(c_out_names{i}) = [];
  u.(c_out_names{i}) = c_out_units{i};
end

while 1
  
  if( first_line_value_flag )
    first_line_value_flag = 0;
    % tline = tline;
  else
    tline = fgetl(fid);
  end
  
  if( ~ischar(tline) )
    break;
  end
  [c_names,ncount] = str_split(tline,seperator);
  for i=1:ndata
    if( index_liste(i) <= ncount )
      data = str2double(c_names{index_liste(i)});
      if( ~isnan(data) )
        d.(c_out_names{i}) = [d.(c_out_names{i});data];
      end
    end
  end
  
end

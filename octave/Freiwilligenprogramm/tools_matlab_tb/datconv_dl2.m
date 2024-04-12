function okay = datconv_dl2_mit_asap(varargin)

okay = 1;

par_file_name    = '';
asap2_file_name  = '';
map_file_name    = '';
exe_file      = 'D:\tools\exe\DatConv\DatConv.exe';
dl2_file        = '';
dl2_dir         = '';
name_list       = {};

i = 1;
while( i+1 <= length(varargin) )

    c = lower(varargin{i}(1));
    switch c
        case 'p'
            par_file_name = varargin{i+1};
        case 'a'
            asap2_file_name = varargin{i+1};
        case 'm'
            map_file_name = varargin{i+1};
        case 'e'
            exe_file   = varargin{i+1};
        case 'd'
            
            if( strcmp(lower(varargin{i}),'dl2_file') )
                dl2_file = varargin{i+1};
            elseif( strcmp(lower(varargin{i}),'dl2_dir') )
                dl2_dir = varargin{i+1};
            else
               error('%s: Attribut <%s> nicht okay',mfilename,varargin{i}) 
            end
        case 'n'
            name_list   = varargin{i+1};
            
        otherwise

            error('%s: Attribut <%s> nicht okay',mfilename,varargin{i})

    end
    i = i+2;
end

% Parameterfile muß angegeben werden
%===================================
if( isempty(par_file_name) )
    error('%s: par_file_name nicht übergeben',mfilename)
end
[tmpDir, tmpName, tmpExt] = fileparts(par_file_name);
if( isempty(tmpDir) )    
    tmpDir = pwd;
end
if( isempty(tmpExt) )    
    tmpExt = '.prc';
end
par_file_name = fullfile(tmpDir,[tmpName,tmpExt]);

% ASap File kann ausgelesen werden ( funktioniert noch nicht)
%============================================================
if( isempty(asap2_file_name) )
    flag_asap_file = 0;
else
    flag_asap_file = 1;
    if( ~exist(asap2_file_name,'file') )
        error('%s: asap2_file <%s> nicht vorhanden',mfilename,asap2_file_name)
    end
end
% Map File kann ausgelesen werden ( funktioniert noch nicht)
%============================================================
if( isempty(map_file_name) )
    flag_map_file = 0;
else
    flag_map_file = 1;
    if( ~exist(map_file_name,'file') )
        error('%s: map_file <%s> nicht vorhanden',mfilename,map_file_name)
    end
end

% Exe-File DatConv prüfen
%========================
if( ~exist(exe_file,'file') )
    error('%s: exe_file <%s> nicht vorhanden',mfilename,exe_file)
end

% Messdateien
%============
flag_dl2_dir  =  ~isempty(dl2_dir);
flag_dl2_file =  ~isempty(dl2_file);
if( ~flag_dl2_dir && ~flag_dl2_file )
    error('%s: dl2_file oder dl2_dir nicht übergeben',mfilename)
end
if( ischar(dl2_file) )
    dl2_file = {dl2_file};
end
if( ischar(dl2_dir) )
    dl2_dir = {dl2_dir};
end

% alle Messdateien auflisten
%===========================
if(flag_dl2_dir)
    
    for i=1:length(dl2_dir)
    
        file_list = suche_files_f(dl2_dir{i},'dl2',0);
    
        for j=1:length(file_list)
        
            dl2_file{length(dl2_file)+1} = file_list(j).full_name;
        end
    end
end
    
    

if( flag_asap_file )
    
    % muß noch erstellt werden
    if( flag_map_file )
        mex_erstelle_prc(par_file_name,asap2_file_name,map_file_name);
    else
        mex_erstelle_prc(par_file_name,asap2_file_name,map_file_name);
    end
    
else
    %prc-File per HAnd erstellen
    
    if( isempty(name_list) )
        error('%s: name_list ist nicht vorhanden',mfilename)
    end
    
    if( ~iscell(name_list) )
        error('%s: name_list muß cell-array sein n={{name_datalayser,name_asap,format},{...,...},...}',mfilename)
    end
        
    
    fid = fopen(par_file_name,'w');
    
    fprintf(fid,'TKM_VERSION: 0200\n');
    fprintf(fid,'TRANSDUCERS: 0\n');
    fprintf(fid,'CHANNELS: %i\n',length(name_list));
    fprintf(fid,'\n');
    fprintf(fid,'ProtocolLength: 8192\n');
    fprintf(fid,'ProtocolPeriod: 10000	ProtocolFactor: 1\n');
    fprintf(fid,'BackgroundColor: 000000\n');
    fprintf(fid,'\n');

    for i=1:length(name_list)
        
        if( length(name_list{i}) < 3 )
            error('%s: name_list{i} muß cell mit 3 ELementen sein n={{name_datalayser,name_asap,format},{...,...},...}',mfilename)
        end
        itest = strmatch(name_list{i}{3},strvcat('none','char','phas','bina','hexa','uint','sint','dd.d','d.dd','.ddd','real'),'exact');
        if( isempty(itest) )
            error('%s: name_list{%i} name_datalayser=%s,name_asap=%s, hat falsches format=%s',mfilename,i,name_list{i}{1},name_list{i}{2},name_list{i}{3});
        end
        if( length(name_list{i}{1}) > 24 )
            error('%s: name_list{%i} name_datalayser=%s  darf nur max 24 Zeichen haben',mfilename,i,name_list{i}{1},name_list{i}{2},name_list{i}{3});
        end            
        fprintf(fid,'Channel: %i Discription: %s\n',i,name_list{i}{1});
        fprintf(fid,'Color: FFFFFF	DataUnits: \n');
        fprintf(fid,'Calc: %s\n',name_list{i}{2});
        fprintf(fid,'TraceOffset: 0	DataFormat: %s	Type: 0\n',name_list{i}{3});
        fprintf(fid,'TraceAmpl: 1	TraceFormat: none\n');
        fprintf(fid,'\n');
    end
    
    fclose(fid);
    
end

% DatConv ausführen
for i=1:length(dl2_file)

    if( exist(dl2_file{i},'file') )
        [tmpDir, tmpName, tmpExt] = fileparts(dl2_file{i});
        mat_file = fullfile(tmpDir,[tmpName,'.mat']);
        
        command = sprintf('%s -p=%s -f=%s -l=3 -m=-1 -o=0 -s=4 -x=%s' ...
                         ,exe_file ...
                         ,par_file_name ...
                         ,dl2_file{i} ...
                         ,mat_file ...
                         );
        dos(command);
    end
end
                     
        
        
        



    
    
    
    








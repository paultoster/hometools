function make_simulink_output(varargin)
%
% make_simulink_output(['mdl','name']
%                     ,['sub','Output'] ...
%                     ,['inp','In1'] ...
%                     ,['pre','res_'] ...
%                     ,['sample',0.001);
%
% Funktion sucht im aktuellen Simulinkmodell (gcs) nach dem
% angegebenen subblock und darin den angegebenen Inputport.
% Wertet Busstruktur aus und erstellt einen Ausgang für jedes gefundene
% Signal in der Samplerate und stellt jedem Signalnamen das pre-Wort davor
%
% (mit wandel_vektor_in_struct kann dann jedes Signal res_**** in res.****
% gewandelt werden, struct_name_wand = 'res';start_name_wand  = 'res_'; 
% sollte vorher angegeben werden wenn abweichende Namen)
%
%
sub    = 'Output';
inp    = 'In1';
pre    = 'res_';
sample = 0.001;

i = 1;
while( i+1 <= length(varargin) )

    varargin{i} = lower(varargin{i});
    c = varargin{i}(1);
    switch c
        case 'm'
            mdl = varargin{i+1};
        case 'i'
            inp = varargin{i+1};
        case 'p'
            pre = varargin{i+1};
        case 's'
            
            if( strcmp(varargin{i}(1:2),'su') )
                sub = varargin{i+1};
            elseif( strcmp(varargin{i}(1:2),'sa') )
                sample = varargin{i+1};
            end
            
        otherwise

            error('%s: Attribut <%s> nicht okay',mfilename,varargin{i})

    end
    i = i+2;
end

if( ~exist('mdl','var') )
    % mdl = gcs;
    mdl = bdroot(gcb);
end
if( isempty(mdl) || strcmp(mdl,'simulink_need_slupdate') )
    
    error('Ein Modell muß geöffnet sein (mdl: %s)',mdl);
end

if( ~ischar(sub) )
    error('Sublockname muß char sein')
end
if( ~ischar(inp) )
    error('Inputportname muß char sein')
end
if( ~ischar(pre) )
    error('Pre-Name muß char sein')
end
if( ~isnumeric(sample) )
    error('Sampletime muß numerisch sein')
end

model_const_add_to_workspace(mdl,sub,inp,pre,sample);

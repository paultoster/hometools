function [okay,fig_num_o]=plot_from_struct(varargin)
%
% [okay,fig_num_o]=plot_from_struct( ...
%                'struct',var_struct ... % Die Struktur, die geplottet werden soll
% %
% % optionale Parameter:
% %                 
%               ,'fig_num',double ...          % > 0 figure-Nummer < 0 automatisch neu (default)
%               ,'fig_type',char ...           % 'new' (default), 'old'
%               ,'fig_name',char ...           % Figure-Name
%               ,'xname',char ...              % Name des x-Vektors, wenn leer dann über Index plotten (default '')
%               ,'yname',char oder cell ...    % Liste mit Namen der y-Vektoren (default alles)
%               ,'find_yname',char o. cell ... % Such-Text der im ynname enthalten sein soll
%               ,'exclude_yname',char o. cell  % Such-Text der nicht im ynname enthalten sein soll
%               ,'dina4',double ...            % Format =1 Dina4 hoch =2 DinA4 quer, =0 ohne Formatierung
%               ,'nrows',double ...            % Zeilenzahl  mit subplot (default = 1)
%               ,'ncols',double ...            % Spaltenzahl  mit subplot (default = 1)
%               ,'title',char ...              % Titel plotten
%               ,'xlabel',char ...             % Xlabel plotten
%               ,'ylabel',char,cell,double ... % Ylabel plotten Namen (char o cell) 1: Namen aus Struktur
%                                              % übernehmen 0: keine Namen
%               ,'grid',char ...               % 'on' oder 'off' oder 0, 1
%               ,'xlimit',[double,double] ...  % xlimit
%               ,'ylimit',[double,double] ...  % ylimit
%               ,'chs_on',double ...           % 1: chs cursor-Position ablesen einschalten
%               ,'bottom',char                 % plottet am Boden diesen Text in sehr klein (Dateiname z.B.)
%               ,'line_width',double           % Linienstärke
%                                  );
okay = 1;

s_data_set      = 0;
fig_num         = -1;
fig_type        = 'new';
fig_name        = '';
xname           = '';
xname_set       = 0;
yname           = {};
find_yname      = {};
exclude_yname   = {};
dina4           = 0;
nrows           = 1;
ncols           = 1;
plot_title      = '';
plot_xlabel     = '';
plot_ylabel     = {};
plot_ylabel_set = 0;
plot_xlimit_set = 0;
plot_ylimit_set = 0;
plot_grid       = 1;
chs_on          = 0;
plot_bot        = 0;
text_bot        = '';
line_width      = 1;

% Übergabeparameter auswerten ================================================================================
% ============================================================================================================


i = 1;
while( i+1 <= length(varargin) )
    
    switch lower(varargin{i})
    	case 'struct'
            
            s_data = varargin{i+1};
            if( ~isstruct(s_data) )
                error('Keyword:''struct'': Übergebene Variable ist keine Struktur')
            end
            s_data_set = 1;
            
        case 'fig_num'
            
            fig_num = varargin{i+1};
            if( ~isnumeric(fig_num) )
                error('Keyword:''fig_num'': Übergebene Variable ist keine double')
            end

        case 'fig_type'
            
            fig_type = varargin{i+1};
            if( ~ischar(fig_type) )
                error('Keyword:''fig_type'': Übergebene Variable ist keine char')
            end

        case 'fig_name'
            
            fig_name = varargin{i+1};
            if( ~ischar(fig_name) )
                error('Keyword:''fig_name'': Übergebene Variable ist keine char')
            end

        case 'xname'
                
            xname = varargin{i+1};
            if( ~ischar(xname) )
                error('Keyword:''xname'': Übergebene Variable ist keine char')
            end

        case 'yname'
                
            yname = varargin{i+1};
            if( ischar(yname) )
                if( length(yname) == 0 )
                    yname = {};
                else
                    yname = {yname};
                end
            end
            if( ~iscell(yname))
                error('Keyword:''yname'': Übergebene Variable ist keine char oder cellarray mit char')
            end

        case 'find_yname'
                
            find_yname = varargin{i+1};
            if( ischar(find_yname) )
                
                if( length(find_yname) == 0 )
                    
                    find_yname = {};
                else
                    find_yname = {find_yname};
                end
            end
            if( ~iscell(find_yname) )
                error('Keyword:''find_yname'': Übergebene Variable ist keine char oder cellarray mit chars')
            end
            
        case 'exclude_yname'
                
            exclude_yname = varargin{i+1};
            if( ischar(exclude_yname) )
                
                if( length(exclude_yname) == 0 )
                    
                    exclude_yname = {};
                else
                    exclude_yname = {exclude_yname};
                end
            end
            if( ~iscell(exclude_yname) )
                error('Keyword:''exclude_yname'': Übergebene Variable ist keine char oder cellarray mit chars')
            end
            
        case 'dina4'
            
            dina4 = varargin{i+1};
            if( ~isnumeric(dina4) )
                error('Keyword:''dina4'': Übergebene Variable ist keine double')
            end
            
        case 'nrows'
            
            nrows = varargin{i+1};
            if( ~isnumeric(nrows) )
                error('Keyword:''nrows'': Übergebene Variable ist keine double')
            end

        case 'ncols'
            
            ncols = varargin{i+1};
            if( ~isnumeric(ncols) )
                error('Keyword:''ncols'': Übergebene Variable ist keine double')
            end
            
        case 'title'
                
            plot_title = varargin{i+1};
            if( ~ischar(plot_title) )
                error('Keyword:''title'': Übergebene Variable ist keine char')
            end
        case 'xlabel'
                
            plot_xlabel = varargin{i+1};
            if( ~ischar(plot_xlabel) )
                error('Keyword:''xlabel'': Übergebene Variable ist keine char')
            end
            
        case 'ylabel'
                
            plot_ylabel = varargin{i+1};
            if( ischar(plot_ylabel) )
                plot_ylabel     = {plot_ylabel};
                plot_ylabel_set = 1;
            elseif( iscell(plot_ylabel) )
                plot_ylabel_set = 1;
            elseif( isnumeric(plot_ylabel) )
                
                if( plot_ylabel )
                    plot_ylabel     ={};
                    plot_ylabel_set = 1;
                else
                    plot_ylabel_set = 0;
                end
            else
                error('Keyword:''ylabel'': Übergebene Variable ist keine char,cellaray oder double')
            end
            
        case 'xlimit'
            
            plot_xlimit = varargin{i+1};
            
            if( isempty(plot_xlimit) )
                plot_xlimit = [0,0];
            end
            
            if( ~isnumeric(plot_xlimit) )
                error('Keyword:''plot_xlimit'': Übergebene Variable ist kein double-Vektor [xmin,xmax]')
            else
                if( length(plot_xlimit) < 2 )
                    error('Keyword:''plot_xlimit'': Übergebene Variable ist kein Vektor [xmin,xmax]')
                end
            end
            
            if( plot_xlimit(1) == 0.0 && plot_xlimit(2) == 0.0 )
                plot_xlimit_set = 0;
            else
                plot_xlimit_set = 1;
            end
            
        case 'ylimit'
            
            plot_ylimit = varargin{i+1};
            
            if( ~isnumeric(plot_ylimit) )
                error('Keyword:''plot_ylimit'': Übergebene Variable ist kein double-Vektor [ymin,ymax]')
            else
                if( length(plot_ylimit) < 2 )
                    error('Keyword:''plot_ylimit'': Übergebene Variable ist kein Vektor [ymin,ymax]')
                end
            end
            plot_ylimit_set = 1;

        case 'grid'
            
            plot_grid = varargin{i+1};
            
            if( ischar(plot_grid) )
                if( strcmp(plot_grid,'on') || strcmp(plot_grid,'ON') )
                    plot_grid = 1;
                else
                    plot_grid = 0;
                end
            end
            
            if( ~isnumeric(plot_grid) )
                error('Keyword:''plot_grid'': Übergebene Variable ist kein double-wert oder char')
            end
        case 'chs_on'
            chs_on = varargin{i+1};
            
            if( ischar(plot_grid) )
                if( strcmp(chs_on,'on') || strcmp(chs_on,'ON') )
                    chs_on = 1;
                else
                    chs_on = 0;
                end
            end
            
        case 'bottom'
            
            plot_bot = 1;
            text_bot = varargin{i+1};
            if( iscell(text_bot) )
                c_text = text_bot;
                text_bot = '';
                for icell=1:length(c_text)
                    if( icell < length(c_text) )
                        text_bot = sprintf('%s%s\n',text_bot,c_text{icell}); 
                    else
                        text_bot = sprintf('%s%s',text_bot,c_text{icell}); 
                    end
                end
            end
                    
            if( ~ischar(text_bot) )
                warning('Wert für ''bottom'': ist kein Typ char');
                plot_bot = 0;
            end

        case 'line_width'
            line_width = varargin{i+1};
            
            
            if( ischar(line_width) )
                line_width = str2num(line_width)
            end
            
            if( ~isnumeric(line_width) )
                error('Keyword:''line_width'': Übergebene Variable ist kein double-wert oder wandel bares char')
            end
        otherwise
                error(sprintf('%s: Attribut <%s> ist nicht okay',mfilename,varargin{i}))
                
    end
    i = i+2;
end

if( ~s_data_set )
    
    error(sprintf('%s: Es ist keine DAtenstruktur mit Keyword ''struct'' übergeben worden ',mfilename))
end

% Struktur auswerten ==========================================================================================
% =============================================================================================================
s_names = fieldnames(s_data(1));

% X-Vektor
%====================================================
if( length(xname) > 0 ) % Name ist angegeben
    
    if( length(cell_find_f(s_names,xname)) == 0 )
        
        error(sprintf('%s: X-Vektorname <%s> ist nicht in der Tsruktur enthalten',mfilename,xname))        
    end
    
    xname_set = 1;
end

% Y-Vektor
%====================================================
% Name
ny = 0;
    
liste = cell_find_f(s_names,yname); 

for i=1:length(liste)
    
    ny = ny+1;
    yname{ny} = s_names{liste(i)};
    
end

% Teilnamen
liste = cell_find_f(s_names,find_yname,'n');

for i=1:length(liste)
    
    if( length(cell_find_f(yname,s_names{liste(i)})) == 0 )
        
        ny = ny+1;
        yname{ny} = s_names{liste(i)};
    end
end

%Teilnamen rausnehmen
liste = cell_find_f(yname,exclude_yname,'n');

while( length(liste) > 0 )
    
    for i=1:length(liste)
        
        for j= liste(i):length(yname)-1
            
            yname{j} = yname{j+1}
        end
        yname = reshape(yname,1,length(yname)-1);
        for j=i+1:length(liste)
            liste(j) = liste(j)-1;
        end
    end

    liste = cell_find_f(yname,exclude_yname,'n');
end

% Wenn keine y-Namen vorhanden
nyname = length(yname);
if( nyname == 0 )
    fprintf('%s: Keine Y-Vektoren wurden zugeorndet\n',mfilename);
    okay = 0;
    return
end

%====================================================
% Anzahl der Plots
%====================================================

nfg = ceil(nyname/nrows/ncols);

nyy = 0;

for ifg = 1:nfg

    
    %====================================================
    % Figure anlegen
    %====================================================

    set_plot_standards
    fig_num_o(ifg) = p_figure(fig_num(min(length(fig_num),ifg)),dina4,fig_name);

    if( fig_num_o(ifg) <= 0 )
        
        frpintf('%s: Figure (fig_num:%g) konnte nicht erstellt werden\n',mfilename,fig_num(min(length(fig_num),ifg)));
    
        okay = 0;
        return;
    end

    for is = 1:nrows*ncols
        
        %===================================================
        % Datensatz
        %===================================================
        nyy = nyy+1;
        if( nyy > nyname )
            break;
        end

        %====================================================
        % Subplot anlegen
        %====================================================
        subplot(nrows,ncols,is)
        
        %====================================================
        % old new
        %====================================================
        if( fig_type(1) == 'o' || fig_type(1) == 'O' )
            
            hold on
        end
        
        %====================================================
        % Plotten
        %====================================================
        for ist = 1:length(s_data)
            if( xname_set )
            
            
                xvec    = s_data(ist).(xname);
                [nx,mx] = size(s_data(ist).(xname));
                yvec    = s_data(ist).(yname{nyy});
                [ny,my] = size(s_data(ist).(yname{nyy}));
            
                plot(xvec(1:min(nx,ny),1:min(mx,my)) ...
                    ,yvec(1:min(nx,ny),1:min(mx,my)) ...
                    ,'Color',PlotStandards.Farbe{ist} ...
                    ,'LineWidth',line_width)
                
            else
            
                plot(s_data.(yname{nyy}),'Color',PlotStandards.Farbe{ist})
            end
            hold on
        end
        
        %====================================================
        % grid
        %====================================================
        if( plot_grid )
            grid on
        else
            grid off
        end
        
        %====================================================
        % xlimit_set
        %====================================================
        if( plot_xlimit_set )
            
            xlim([min(plot_xlimit),max(plot_xlimit)]);
        end

        %====================================================
        % ylimit_set
        %====================================================
        if( plot_ylimit_set )
            
            ylim([min(plot_ylimit),max(plot_ylimit)]);
        end
        
        %====================================================
        % Title
        %====================================================
        if( is == 1 && length(plot_title) > 0 )
            
            title(str_change_f(plot_title,'_',' '));
        end
        
        
        %====================================================
        % plot_xlabel
        %====================================================
        if( length(plot_xlabel) )
            
            xlabel(str_change_f(plot_xlabel,'_',' '))
        end
        
        %====================================================
        % plot_ylabel
        %====================================================
        if( plot_ylabel_set )
            
            if( length(plot_ylabel) == 0  )
                ylabel(str_change_f(yname{nyy},'_',' '))
            else            
                ylabel(str_change_f(plot_ylabel{min(length(plot_ylabel),nyy)},'_',' '))
            end
        end
        
        %====================================================
        % legend
        %====================================================
        if( (nrows*ncols == 1 || is == 2) && length(s_data) > 1 )
           
            c_names = {};
            for ist = 1:length(s_data)
                c_names{ist} = num2str(ist);
            end
            legend(c_names);
        end
        
    end
    
    %====================================================
    % plot_bot
    %====================================================
    if( plot_bot )
        if( ncols > 1 )
            n = nrows*ncols-1;
            subplot(nrows,ncols,n)
        end
        
        plot_bottom(text_bot)
    end
    
    %====================================================
    % chs_on
    %====================================================
    if( chs_on )
        chs('set')
    end
    
end
    
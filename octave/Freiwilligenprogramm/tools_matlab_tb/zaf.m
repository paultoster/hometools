%version 1 TBert/TZS/3052 20050126
% Aufruf: zaf     
% - zaf erstellt zwei buttons im Menü aller Grafikfiguren
%   Button1: zaf -> zoomt alle Grafiken auf die gleiche x-Limitierung der aktuellen Grafik
%                   (zaf:zoom all figures)
%   Button2: zafr -> Die aktuelle Grafik wird wieder in den Ursprungszustand der x-Limitierung gebracht
%                   (zafr: reset)
%   in der Menüleiste im aktuellen figure
% - Wenn zaf nochmals aufgerufen wird, werden die Button wieder rausgenommen
% - zaf('set') alle Setzen
% - zaf('set_silent') alle Setzen
% - zaf('setact') aktuelle Setzen
% - zaf('setact_silent') aktuelle Setzen
% - zaf('del') Löschen
% - zaf('forbid') keine zaf-Funktion für die aktuelle figure
function zaf(mode)

if ~exist('mode','var') 
    mode = 'toggle';
elseif isempty(mode)
    mode = 'toggle';
end

mode = lower(mode);

switch mode,

case {'setact','setact_silent'},

        
        
    label_set = 0;
    childs = get(gcf,'children');
    for (ch=1:size(childs,1))
        if ((strcmp( get(childs(ch),'type'),'axes') == 1) && (strcmp(get(childs(ch),'Tag'), 'legend') == 0))
          
          if( ~label_set )
            
            label_set = 1;
            hmenu = findobj(gcf,'label','zaf');
            if (isempty(hmenu)),

                uimenu(gcf,'label','zaf','callback','zaf(''zoom'');');
                if( strcmp(mode,'setact') )
                  fprintf('\n');
                  fprintf('zoom all figures(zaf) menu has been added to figure %i\n',gcf);
                end

            end,
            hmenu = findobj(gcf,'label','zafr');
            if (isempty(hmenu)),

                uimenu(gcf,'label','zafr','callback','zaf(''resize'');');

            end,
          end
          
          % allow zoom
          data = get_user_data_zaf(childs(ch));
          data.allow_zoom = 1;
          set_user_data_zaf(childs(ch),data);
          
        end
    end

case {'set','set_silent'},

    parents = get_fig_numbers;
    for (p=1:size(parents,1))
        
        
        label_set = 0;
        childs = get(parents(p),'children');
        for (ch=1:size(childs,1))
            if ((strcmp( get(childs(ch),'type'),'axes') == 1) && (strcmp(get(childs(ch),'Tag'), 'legend') == 0))
                if( ~label_set )
                    label_set = 1;
                    hmenu = findobj(parents(p),'label','zaf');
                    if (isempty(hmenu)),

                        uimenu(parents(p),'label','zaf','callback','zaf(''zoom'');');
                        if( strcmp(mode,'set') )
                          fprintf('\n');
                          fprintf('zoom all figures(zaf) menu has been added to figure %i\n',parents(p));
                        end
                    end,
                    hmenu = findobj(parents(p),'label','zafr');
                    if (isempty(hmenu)),

                        uimenu(parents(p),'label','zafr','callback','zaf(''resize'');');

                    end,
                end 
                data = get_user_data_zaf(childs(ch));
                if( isfield(data,'allow_zoom') && ~isempty(data.allow_zoom) && (data.allow_zoom == 0) )
                  data.allow_zoom = 0;
                else
                  data.allow_zoom = 1;
                end
                set_user_data_zaf(childs(ch),data);
                
            end
        end
        
    end
case 'del'
    
    parents = get_fig_numbers;
    for (p=1:size(parents,1))
        
        
        label_set = 0;
        childs = get(parents(p),'children');
        for (ch=1:size(childs,1))
            if ((strcmp( get(childs(ch),'type'),'axes') == 1) && (strcmp(get(childs(ch),'Tag'), 'legend') == 0))
                if( ~label_set )
                    label_set = 1;

                    hmenu = findobj(parents(p),'label','zaf');
                    if (~isempty(hmenu)),

                        delete(hmenu);
                        fprintf('zoom all figures(zaf)  menu has been deleted to figure %i\n',parents(p));
                    end,
                    hmenu = findobj(parents(p),'label','zafr');

                    if (~isempty(hmenu)),

                        delete(hmenu);
                        zaf('resize_all');
                    end,
                end
                
                data = get_user_data_zaf(childs(ch));
                data.allow_zoom = 0;
                set_user_data_zaf(childs(ch),data);
                
            end
        end
        
    end
case 'del_act'
    
    fig = gcf;
        
    label_set = 0;
    childs = get(fig,'children');
    for (ch=1:size(childs,1))
        if ((strcmp( get(childs(ch),'type'),'axes') == 1) && (strcmp(get(childs(ch),'Tag'), 'legend') == 0))
                if( ~label_set )
                    label_set = 1;

                    hmenu = findobj(parents(p),'label','zaf');
                    if (~isempty(hmenu)),

                        delete(hmenu);
                        fprintf('zoom all figures(zaf)  menu has been deleted to figure %i\n',parents(p));
                    end,
                    hmenu = findobj(parents(p),'label','zafr');

                    if (~isempty(hmenu)),

                        delete(hmenu);
                        zaf('resize_all');
                    end,
                end
                
                data = get_user_data_zaf(childs(ch));
                data.allow_zoom = 0;
                set_user_data_zaf(childs(ch),data);
        end
    end
        
case 'toggle',

    parents = get_fig_numbers;
    fprintf('\n');
    for (p=1:size(parents,1))
        
        
        axes_flag = 0;
        childs = get(parents(p),'children');
        for (ch=1:size(childs,1))
            if ((strcmp( get(childs(ch),'type'),'axes') == 1) && (strcmp(get(childs(ch),'Tag'), 'legend') == 0))
              if( ~axes_flag )
                  axes_flag = 1;
                  hmenu = findobj(parents(p),'label','zaf');
                  if (isempty(hmenu)),
                      set_menu = 1;
                      uimenu(parents(p),'label','zaf','callback','zaf(''zoom'');');
                      fprintf('zoom all figures(zaf) menu has been added to figure %i\n',parents(p));


                  else
                      set_menu = 0;
                      delete(hmenu);
                      fprintf('zoom all figures(zaf)  menu has been deleted to figure %i\n',parents(p));

                  end,
                  hmenu = findobj(parents(p),'label','zafr');
                  if (isempty(hmenu)),

                      uimenu(parents(p),'label','zafr','callback','zaf(''resize'');');
                  else
                      delete(hmenu);
                      zaf('resize_all');

                  end,
              end
              data = get_user_data_zaf(childs(ch));
              if( set_menu )
                if( isfield(data,'allow_zoom') && ~isempty(data.allow_zoom) && (data.allow_zoom == 0) )
                  data.allow_zoom = 0;
                else
                  data.allow_zoom = 1;
                end
              else
                  data.allow_zoom = 0;
              end
              set_user_data_zaf(childs(ch),data);

            end
        end
        
    end
    
case 'zoom',
    
    parents = get_fig_numbers;
    
    x_lim = get(gca,'XLim');

    %fprintf('\n Xlim_min = %g Xlim_max = %g',x_lim(1),x_lim(2));

    parents = get_fig_numbers;
    for (p=1:size(parents,1))
        hmenu = findobj(parents(p),'label','zaf');
        if( ~isempty(hmenu) )
            childs = get(parents(p),'children');
            for (ch=1:size(childs,1))
                if ((strcmp( get(childs(ch),'type'),'axes') == 1) && (strcmp(get(childs(ch),'Tag'), 'legend') == 0))

                    % data = get(childs(ch),'userdata');
                    data = get_user_data_zaf(childs(ch));
                    if( isempty(data) || ~isfield(data,'x_lim_org') || isempty(data.x_lim_org) )

                        data.x_lim_org = get(childs(ch),'Xlim');
                        %set(childs(ch),'userdata',data);
                        set_user_data_zaf(childs(ch),data);
                    end
                    if( data.allow_zoom )
                      set(childs(ch),'Xlim',x_lim);
                    end
                end
            end
        end
    end
    
case 'resize',

    % data = get(gca,'userdata');
    data = get_user_data_zaf(gca);
    if( ~isempty(data) && isfield(data,'x_lim_org') )
        if( data.allow_zoom )           
         set(gca,'XLim',data.x_lim_org);
        end
    end
   
case 'resize_all',
    
    parents = get_fig_numbers;
    for (p=1:size(parents,1))
        hmenu = findobj(parents(p),'label','zaf');
        if( ~isempty(hmenu) )
            childs = get(parents(p),'children');
            for (ch=1:size(childs,1))
                if ((strcmp( get(childs(ch),'type'),'axes') == 1) && (strcmp(get(childs(ch),'Tag'), 'legend') == 0))

                    %data = get(childs(ch),'userdata');
                    data = get_user_data_zaf(childs(ch));
                    if( ~isempty(data) && isfield(data,'x_lim_org') )
                        if( data.allow_zoom )
                          set(childs(ch),'XLim',data.x_lim_org);
                        end                  
                    end
                end
            end
        end
    end
case 'forbid'
  if( ~isempty(get_fig_numbers) )
    data = get_user_data_zaf(gca);
    data.allow_zoom = 0;
    set_user_data_zaf(gca,data)
  end
end
function data = get_user_data_zaf(fid)
% Userdaten aus Figure/Diagramm holen
% zaf ist Kennzeichnung gegenüber anderen Daten von anderen Programmen
  FH = get(fid,'userdata');
  
  if(  ~isempty(FH) && isfield(FH,'zaf') )
    data = FH.zaf;
  else
    data = [];
  end
  return

function set_user_data_zaf(fid,data)
% Userdaten in Figure/Diagramm schreiben
% zaf ist Kennzeichnung gegenüber anderen Daten von anderen Programmen
  FH = get(fid,'userdata');
  
  FH.zaf = data;
  
  set(fid,'userdata',FH);
  return


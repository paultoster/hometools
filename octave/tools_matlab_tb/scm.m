%version 1 TBert/TZS/3052 20050126
% Aufruf: scm     
% - scm erstellt erstellt ein button im Menü aller Grafikfiguren
%   scm -> startet scroll_meas() scrollen in der Graphik mit Anzeige
% - scm('set') in allen Figuren Setzen
% - scm('set_silent') in allen Figuren Setzen
% - scm('setact') aktuelle Setzen
% - scm('setact_silent') aktuelle Setzen
% - scm('del') Löschen
function scm(mode)

if ~exist('mode','var') 
    mode = 'setact';
elseif isempty(mode)
    mode = 'setact';
end

mode = lower(mode);

switch mode,

case {'setact','setact_silent'},

  if( strcmp(mode,'setact') )
    fprintf('\n');
  end      
        
    axes_flag = 0;
    childs = get(gcf,'children');
    for (ch=1:size(childs,1))
        if ((strcmp( get(childs(ch),'type'),'axes') == 1) && (strcmp(get(childs(ch),'Tag'), 'legend') == 0))
            axes_flag = 1;
            break;
        end
    end

    if( axes_flag )

        hmenu = findobj(gcf,'label','scm');
        if (isempty(hmenu)),

            uimenu(gcf,'label','scm','callback','scroll_meas(''init'');');
            if( strcmp(mode,'setact') )
              fprintf('scroll measure(scm) menu has been added to figure %i\n',gcf);
            end

        end,
    end

case {'set','set_silent'},

  parents = get_fig_numbers;
  fprintf('\n');
  for (p=1:size(parents,1))
      axes_flag = 0;
      childs = get(parents(p),'children');
      for (ch=1:size(childs,1))
          if ((strcmp( get(childs(ch),'type'),'axes') == 1) && (strcmp(get(childs(ch),'Tag'), 'legend') == 0))
              axes_flag = 1;
              break;
          end
      end
      if( axes_flag )
        hmenu = findobj(parents(p),'label','scm');
        if (isempty(hmenu)),
          uimenu(parents(p),'label','scm','callback','scroll_meas(''init'');');
          if( strcmp(mode,'set') )
            fprintf('scroll measure(scm) menu has been added to figure %i\n',gcf);
          end
        end
      end 
  end
case 'del'
    
    parents = get_fig_numbers;
    fprintf('\n');
    for (p=1:size(parents,1))
        
        
        axes_flag = 0;
        childs = get(parents(p),'children');
        for (ch=1:size(childs,1))
            if ((strcmp( get(childs(ch),'type'),'axes') == 1) && (strcmp(get(childs(ch),'Tag'), 'legend') == 0))
                axes_flag = 1;
                break;
            end
        end
        
        if( axes_flag )
            
            hmenu = findobj(parents(p),'label','scm');
            if (~isempty(hmenu)),
        
                delete(hmenu);
                fprintf('scroll measure(scm)  menu has been deleted to figure %i\n',parents(p));
            end,
        end 
    end
end

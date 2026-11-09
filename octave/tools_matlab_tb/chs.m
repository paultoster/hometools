function chs(mode)
%version 1 TBert/TZS/3052 20050126
%
% Aufruf: chs     
% - chs startet crosshair_subplots und generiert einen button 
%   in der Menüleiste im aktuellen figure
% - Mit dem chs-Button kann crosshair_subplots an und ausgestellt werden
% - Wenn chs nochmals aufgerufen wird, wird der button wieder rausgenommen
% - chs('set') setzt chs
% - chs('del') nimmt chs raus

if ~exist('mode','var') 
    mode = 'find';
elseif isempty(mode)
    mode = 'find';
end

mode = lower(mode);

switch mode,

case 'find',
    
    hmenu = findobj(gcf,'label','chs');

    if (isempty(hmenu)),
        uimenu(gcf,'label','chs','callback','chs(''check'');');
        disp('crosshair_subplots(chs) menu has been added');
    
    % situar la figura en primer plano
%    figure(gcf);
    else,
        delete(hmenu);

        disp('crosshair_subplots(chs) menu has been deleted');  
    end,
case 'set',
    
    hmenu = findobj(gcf,'label','chs');

    if (isempty(hmenu)),
        uimenu(gcf,'label','chs','callback','chs(''check'');');
        disp('crosshair_subplots(chs) menu has been added');
    
    end,
case 'del',
    
    hmenu = findobj(gcf,'label','chs');

    if( ~isempty(hmenu)),
        delete(hmenu);

        disp('crosshair_subplots(chs) menu has been deleted');  
    end,
case 'check',
    FIGURE_HANDLES = get_user_data_chs(gcf);
    
    if( isempty(FIGURE_HANDLES) ...
      || ~isfield(FIGURE_HANDLES,'chs_set') ...
      || FIGURE_HANDLES.chs_set ~= 1 ...
      )
        
        crosshair_subplots('init');
        FIGURE_HANDLES = get_user_data_chs(gcf);
        FIGURE_HANDLES.chs_set = 1;
        set_user_data_chs(gcf,FIGURE_HANDLES)
    else
        FIGURE_HANDLES.chs_set = 0;
        set_user_data_chs(gcf,FIGURE_HANDLES)
        crosshair_subplots('done');
        
    end
        
    
end
function data = get_user_data_chs(fid)
% Userdaten aus Figure/Diagramm holen
% chs ist Kennzeichnung gegenüber anderen Daten von anderen Programmen
  FH = get(fid,'userdata');
  
  if(  ~isempty(FH) && isfield(FH,'chs') )
    data = FH.chs;
  else
    data = [];
  end
  return

function set_user_data_chs(fid,data)
% Userdaten in Figure/Diagramm schreiben
% chs ist Kennzeichnung gegenüber anderen Daten von anderen Programmen
  FH = get(fid,'userdata');
  
  FH.chs = data;
  
  set(fid,'userdata',FH);
  return


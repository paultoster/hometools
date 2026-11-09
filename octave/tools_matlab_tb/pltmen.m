function fig = pltmen(select_struct_name,x_vec_name)

global pltmen_ctrl_select_struct_name
global pltmen_ctrl_x_vec_name   
global pltmen_h0

pltmen_title='pltmen1.0';


if( exist('select_struct_name','var') & ischar(select_struct_name) )
    
    pltmen_ctrl_select_struct_name = select_struct_name;

    if( exist('x_vec_name','var') & ischar(x_vec_name) )
        pltmen_ctrl_x_vec_name = x_vec_name;
    else
        pltmen_ctrl_x_vec_name = '';        
    end
else
    pltmen_ctrl_select_struct_name = '';
    pltmen_ctrl_x_vec_name = '';        
end

set(0,'Units','points');
scrsz = get(0,'ScreenSize');
% scrsz = [xlinks, yunten, xrechts, yoben]

n_push_button = 11;

mainpos_w  = 100;
mainpos_h  = 25.5*n_push_button+1;
mainpos_x0 = scrsz(1)+5;
mainpos_y0 = scrsz(4)-mainpos_h-50;
mainpos = [mainpos_x0,mainpos_y0,mainpos_w,mainpos_h];

subpos_w  = 54;
subpos_h  = 25.5;
subpos_x  = 20.25;
subpos_y0 = mainpos_h-1;

h0 = figure('Units','points', ...
	'Color',[0.8 0.8 0.8], ...
	'Position',mainpos, ...
	'Tag','Fig2', ...
	'ToolBar','none', ...
	'NumberTitle','off',...
	'Name',pltmen_title,...
   'WindowButtonDownFcn','zoom down');

pltmen_h0 = h0;

for i=1:n_push_button
     subpos_y = subpos_y0-subpos_h*i;
     subpos = [subpos_x,subpos_y,subpos_w,subpos_h];
     switch i
     case 1
        callback_string = sprintf('pltmen_task=''select_figure'';\npltmen_execute;');
        string_string   = 'select figure';
     case 2
        callback_string = sprintf('pltmen_task=''select_struct'';\npltmen_execute;');
        string_string   = 'select struct';
     case 3
        callback_string = sprintf('pltmen_task=''select_x_vec'';\npltmen_execute;');
        string_string   = 'select x-vec';
     case 4
        callback_string = sprintf('pltmen_task=''plot_y_vec'';\npltmen_execute;');
        string_string   = 'plot y-vec';
     case 5
        callback_string = sprintf('pltmen_task=''delete_line'';\npltmen_execute;');
        string_string   = 'delete y-vec';
     case 6
        callback_string = sprintf('pltmen_task=''zaf_set'';\npltmen_execute;');
        string_string   = 'zoom an/aus';
     case 7
        callback_string = sprintf('pltmen_task=''logsave'';\npltmen_execute;');
        string_string   = 'log speichern';
     case 8
        callback_string = sprintf('pltmen_task=''logload'';\npltmen_execute;');
        string_string   = 'log laden';
     case 9
        callback_string = sprintf('pltmen_task=''close_fig'';\npltmen_execute;');
        string_string   = 'close fig';
     case 10
        callback_string = sprintf('pltmen_task=''abbruch'';\npltmen_execute;');
        string_string   = 'Abbruch';
     case 11
        callback_string = sprintf('pltmen_task=''exit'';\npltmen_execute;');
        string_string   = 'Exit';

     otherwise
        disp(' Unknown switch in p.m')
        exit
     end
   
     h1 = uicontrol('Parent',h0, ...
	       'Units','points', ...
	       'BackgroundColor',[0.8,0.8,0.8], ...
	       'Callback',callback_string, ...
	       'ListboxTop',0, ...
	       'Position',subpos, ...
	       'String',string_string, ...
	       'Tag','Pushbutton1');
      
end


set(0,'Units','pixel');
if nargout > 0, fig = h0; end

%----------------------------------------
% Ende function fig = push_button_fkt()
%----------------------------------------

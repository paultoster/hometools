function okay = plot_bottom(textvar,fig_num)
%
% okay = plot_bottom(textvar[,fig_num])
% 
% Plottet einen Text klein unten rein
% z.B. plot_bottom(mfilename)
% Output:
% okay == 1 ist okay
%
% (aus plot_f.m) 

okay = 1;

if( ~exist('fig_num','var') )
    fig_num = gcf;
end

if( ischar(textvar) )
    textvar = {textvar};
end
itext = 0;
if( iscell(textvar) )
    for i=1:length(textvar)
        
        textvari = str_change_f(textvar{i},'\','/');
        textvari = str_change_once_f(textvari,'_','\_');
        
        
        if( ischar(textvari) )
            
            itext = itext + 1;
            if( itext < 6 )
                x_text = -1.5;
                y_text = -0.75-0.25*(itext-1);
            else
                x_text = 7;
                y_text = -0.75-0.25*(itext-6);
            end
            text('String',              textvari ...
                ,'HorizontalAlignment', 'left' ...
                ,'VerticalAlignment',   'bottom' ...
                ,'Rotation',            0 ...
                ,'Units',               'centimeters' ...
                ,'Position',            [x_text,y_text] ...
                ,'Fontsize',            8 ...
                );
        end
    end
end
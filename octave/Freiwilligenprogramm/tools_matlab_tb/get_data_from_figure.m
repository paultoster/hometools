function a = get_data_from_figure(figurefilename)
%
% a = get_data_from_figure(figurefilename)
%
% figurefilename          Name des Figurenfiles z.B. plot1.fig
%
% a                       Ausgabestruktur mit 
%                         a.name.xdata
%                         a.name.ydata
%                         a.name.zdata, wenn vorhanden

a = [];
na = 0;
h = open(figurefilename);
%h = gcf; %current figure handle
childs = get(h, 'Children'); %axes handles
for (ch=1:size(childs,1))
  if ((strcmp( get(childs(ch),'type'),'axes') == 1) && (strcmp(get(childs(ch),'Tag'), 'legend') == 0))
    
    axesObjs = childs(ch);
    dataObjs = get(axesObjs, 'Children'); %handles to low-level graphics objects in axes
    for (idd=1:size(dataObjs,1))
      objType = get(dataObjs(idd), 'Type'); %type of low-level graphics object
      if( strcmp(objType,'line') )
        lname = get(dataObjs(idd), 'DisplayName');
        xdata = get(dataObjs(idd), 'XData'); %data from low-level grahics objects
        ydata = get(dataObjs(idd), 'YData');
        zdata = get(dataObjs(idd), 'ZData');
        
        na = na + 1;
        lname = str_cut_ae_f(lname,' ');
        if( isempty(lname) )
          lname = ['data_',num2str(na)];
        else
          lname = str_change_f(lname,' ','_','a');
          lname = str_change_f(lname,':','_','a');
          lname = str_change_f(lname,'-','_','a');
          lname = str_change_f(lname,';','_','a');
          lname = str_change_f(lname,'.','_','a');
          lname = str_change_f(lname,',','_','a');
          lname = str_change_f(lname,'[','_','a');
          lname = str_change_f(lname,']','_','a');
          lname = str_change_f(lname,'{','_','a');
          lname = str_change_f(lname,'}','_','a');
        end
        if( ~isempty(xdata) ), a.(lname).xdata = xdata';end
        if( ~isempty(ydata) ), a.(lname).ydata = ydata';end
        if( ~isempty(zdata) ), a.(lname).zdata = zdata';end
        
      end
    end
  end
end
close(h)

 







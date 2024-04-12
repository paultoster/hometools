function [found,time0,time1] = e_data_find_x_limit_by_plot(e,fieldname)
%
% [found,time0,time1] = e_data_find_x_limit_by_plot(d,fieldname)
% [found,time0,time1] = e_data_find_x_limit_by_plot(d,{fieldname1,fieldname2,...})
%
%   Eingabe der Limit x0, x1 über plot mit den ausgewählten Signalen
%
%  e      e-Struktur mit e.sig_name1.time (Zeitvektor) und
%                        e.sig_name1.vec  (Signalvektor)

  
  found = 0;
  x0 = 0.;
  x1 = 0.;
  if( ischar(fieldname) )
    fieldname = {fieldname};
  end
  ee = [];
  cxvec = {};
  cyvec = {};
  clegend = {};
  time_min = 1e39;
  time_max = -1e39;
  for i=1:length(fieldname)
    if(  struct_find_f(e,fieldname{i}) ...
      && isnumeric(e.(fieldname{i}).vec) ...
      )
      ee.(fieldname{i}) = e.(fieldname{i});
      clegend           = cell_add(clegend,str_change_f(fieldname{i},'_',' '));
      cxvec             = cell_add(cxvec,ee.(fieldname{i}).time);
      cyvec             = cell_add(cyvec,ee.(fieldname{i}).vec);
      
      time_min = min(time_min,min(ee.(fieldname{i}).time));
      time_max = max(time_max,max(ee.(fieldname{i}).time));     
    end
  end
  if( isempty(cxvec) ), return; end
  
  cfields = fieldnames(ee);
  n       = length(cfields);
  

  [px,py,ncount,okay] = get_xy_points_by_plot('xvec',cxvec,'yvec',cyvec ...
                                             ,'legend',clegend ...
                                             ,'xlimit',[time_min,time_max] ...
                                             ,'text','klicke Anfang und Ende für Star- und Endindex an' ...
                                             ,'npoints',2);
  if( okay && ncount >= 2)                             
    time0 = px(1);
    time1 = px(2);
    found = 1;
  end

end


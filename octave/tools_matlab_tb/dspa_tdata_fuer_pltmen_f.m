function pdata = dspa_tdata_fuer_pltmen_f(dspa_data,i_set,data_name,time_start,time_end, ...
                                          y_scale,y_offset,Farbe);
% pdata = dspa_tdata_fuer_pltmen_f(dspa_data,i_set,data_name,time_start,time_end, ...
%                                  y_scale,y_offset,Farbe);
% index = dspa_suche_data_index_f(data,Name);
%
% Dspace-Datenstruktur für plot-menü pltmen aufbereiten
%
                                      
set_standards                                      
                                      
index = dspa_suche_data_index_f(dspa_data,data_name);

pdata.n_start      = suche_index(dspa_data.X.Data,time_start);
if( time_end < 0.0 )
    pdata.n_end        = length(dspa_data.X.Data);
else
    pdata.n_end        = suche_index(dspa_data.X.Data,time_end);
end
pdata.x_vec        = dspa_data.X.Data;
pdata.y_vec        = dspa_data.Y(index).Data*y_scale+y_offset;
pdata.legend       = dspa_data.Y(index).Name;

itype              = floor(i_set);
pdata.line_type    = char(Standards.Ltype(itype));
isize                 = floor(i_set/(Standards.Ltype_diff_max+1))+1;
pdata.line_size    = Standards.Lsize{isize};
pdata.line_color   = Farbe;

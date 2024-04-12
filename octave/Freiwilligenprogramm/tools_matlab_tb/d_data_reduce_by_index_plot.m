function [okay,d] = d_data_reduce_by_index_plot(d,fieldname,zero_flag)
%
% [okay,d] = d_data_reduce_by_index_plot(d,fieldname,zero_flag)
% [okay,d] = d_data_reduce_by_index_plot(d,{fieldname1,fieldname2,...},zero_flag)
%
%   reduziert Datensatz mit plot und Abstecken von i0,i1
%   d.(fieldname) muﬂ vorhanden sein
% mit zero_flag = 1 wird der Erste Vektor (time) genullt

  if( iscell(fieldname) )
    c_fieldnames = fieldname;
  elseif( ischar(fieldname) )
    c_fieldnames = {fieldname};
  else
    error('d_data_reduce_by_index_plot: fieldname is kein char bzw. cell')
  end
  nfields = length(c_fieldnames);
  nmat    = 1e39;
  for ifield=1:nfields
    fieldname = c_fieldnames{ifield};
    if( ~isfield(d,fieldname) )
      error('in Datenstruktur d ist <%s> kein Element',fieldname);
    end
    nmat = min(nmat,length(d.(fieldname)));
  end
  dmat    = zeros(nmat,nfields);
  for ifield=1:nfields
    fieldname = c_fieldnames{ifield};
    [n,m] = size(d.(fieldname));
    if( n >= m )
      dmat(:,ifield) = d.(fieldname)(1:nmat);
    else
      dmat(:,ifield) = (d.(fieldname)(1:nmat))';
    end
  end
  
  [okay,i0,i1]=find_start_end_index_vec_by_plot(dmat,'d data reduce by index plot');
  if( okay )
    d = d_data_reduce_by_index(d,i0,i1,zero_flag);
  else
    error('Kein Index gescannt')
  end
end


function e = e_data_read_d(d,u,c)
%
% e = e_data_read_d(d,u,c);
% e = e_data_read_d(d,u);
%
% Input:
%    erster Vektor ist Zeit
%
%    d.('signame')    Wertevektor (erster ist immer time)
%    u.('signame')    Einheit
%    c.('signame')    Kommentar
%
% d-struktur in e-Struktur überführen
%
%    e.('signame').time    zeitvektor
%    e.('signame').vec     Wertevektor
%    e.('signame').unit    Einheit
%    e.('signame').comment Kommentar
%    e.('signame').lin     1 linear interpolieren
%                          0 konstant interpolieren
%    e.('signame').leading_time_name    Damit wird alle mit diesem Namen
%                                       versehenen Vektoren mit dieser Zeitbasis aus e gleich in d-STruktur
%                                       gewandelt
%
%

  c_name = fieldnames(d);
  n        = length(c_name);
  t_name   = c_name{1};
  sig_name = {};
  for i=2:n,sig_name = cell_add(sig_name,c_name{i});end
  n        = length(sig_name);
  
  if( n > 1 )
    
    if( ~exist('u','var') )
      u = d_data_build_empty_cstruct(d);
    end
    if( ~exist('c','var') )
      c = d_data_build_empty_cstruct(d);
    end
    
  
    e = [];
    t_vec    = d.(t_name);
    if( isfield(u,t_name) )
      t_unit = u.(t_name);
    else
      t_unit = '';
    end
  
    for i = 1:n
      
      if( isfield(u,sig_name{i}) )
        v_unit = u.(sig_name{i});
      else
        v_unit = '';
      end
      if( isfield(c,sig_name{i}) )
        comment = c.(sig_name{i});
      else
        comment = '';
      end
      
      e.(sig_name{i}).time    = t_vec;
      e.(sig_name{i}).vec     = d.(sig_name{i});
      e.(sig_name{i}).unit    = v_unit;
      e.(sig_name{i}).comment = comment;
      e.(sig_name{i}).lin     = 0;
    end
  end
end


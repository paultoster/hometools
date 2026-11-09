function [e,basename] = cg_read_ecal_get_vector_struct(d,channel_name,unit_lin_datei)
%
% liest aus ecal-Struktur die Werte ein und bringt sie in eine 
% flache Vektor struct, dabei werden unit und lin-flag (lineariserung
% möglich) aus der Datei unit_lin_datei gelesen
%
% e          Daten-Sruktur des channels
% basename   channelname ohne Pb
%
  q.CELL_TYPE    = 4;
  q.STRUCT_TYPE  = 3;
  q.FLOAT_TYPE   = 2;
  q.INT_TYPE     = 1;
  q.CHAR_TYPE    = 5;

  basename            = cg_read_ecal_get_vector_struct_reduce_Pb(channel_name);  
  [timevec,timestamp] = cg_read_ecal_get_vector_struct_get_time(d,channel_name);
  s                   = cg_read_ecal_get_vector_struct_get_vec_struct_hiearch(d.data,basename,q);
  
  [r,ri]       = cg_read_ecal_get_vector_struct_get_vec_struct_inum(s);
  
  e            = cg_read_ecal_get_vector_struct_get_e(r,ri,timevec,timestamp,d.data,q);
  
  e            = e_data_add_value(e,[basename,'_timestamp'],'us','time stamp',timevec,timestamp,0);
  
  e            = cg_read_ecal_get_vector_struct_get_unit_lin(e,unit_lin_datei);
  
end
function name = cg_read_ecal_get_vector_struct_reduce_Pb(channel_name)
  ii = str_find_f(channel_name,'Pb');
  if( ii > 0 )
    name = channel_name(1:max(1,ii-1));
  else
    name = channel_name;
  end
end
function [timevec,timestamp] = cg_read_ecal_get_vector_struct_get_time(d,channel_name)
  n    = length(d.data);
  if( isfield(d.data{1},'header') )
    timestamp = zeros(n,1);
    for j=1:n
      timestamp(j) = d.data{j}.header.timestamp;
    end
  end
  
  if( isfield(d,'timestamps') )
    timevec = double(d.timestamps)*1.0e-6;
  elseif( exist('timestamp','var') )
    timevec = double(timestamp)*1.0e-6;
  else
    error('%_err: time is not available with %s',mfilename,channel_name)
  end
end
function s  = cg_read_ecal_get_vector_struct_get_vec_struct_hiearch(data,channel_name,q)
%
% s.n    = length(data)
% s.type = 1: numeric, 2: cell, 3: struct
% s.name = name
  type = cg_read_ecal_get_vector_struct_get_type(data,channel_name,q);
  
  if( type == q.CELL_TYPE )
    s = cg_read_ecal_get_vector_struct_get_struct(data{1},channel_name,channel_name,q);
    s.length = length(data);
  else
    error('Dürfte nicht sein')
  end
  % check length
  for i= 1:length(data)
   s = cg_read_ecal_get_vector_struct_get_vec_struct_check_length(data{i},s,q);
  end
end
function type = cg_read_ecal_get_vector_struct_get_type(data,channel_name,q)
% type = 1: numeric, 2: cell, 3: struct

  if( isnumeric( data ) )
    if( isinteger( data ) )
      type = q.INT_TYPE;
    elseif( isfloat( data ) )
      type = q.FLOAT_TYPE;
    else
      error(' unbekannter Type ');
    end
  elseif( iscell( data ) )
    type = q.CELL_TYPE;
  elseif( isstruct( data ) )
    type = q.STRUCT_TYPE;
  elseif( ischar( data ) )
    type = q.CHAR_TYPE;
  else
    error('%_err: type is not detected %s',mfilename,channel_name)
  end
end
function s    = cg_read_ecal_get_vector_struct_get_struct(data,var_name,channel_name,q)
  
  
  s.type  = cg_read_ecal_get_vector_struct_get_type(data,channel_name,q);
  s.name  = var_name;
  if( s.type == q.STRUCT_TYPE )
    
    names = fieldnames(data);
    s.n     = length(names);
    s.length = 1;
    for i = 1:s.n
      s.s(i) = cg_read_ecal_get_vector_struct_get_struct(data.(names{i}),names{i},channel_name,q);
    end
  elseif( s.type == q.FLOAT_TYPE )
    s.n      = 0;
    s.length = 1;
    s.s      = [];
  elseif( s.type == q.INT_TYPE )
    s.n      = 0;
    s.length = 1;
    s.s      = [];
  elseif( s.type == q.CHAR_TYPE )
    s.n      = 0;
    s.length = 1;
    s.s      = [];
  else % cell
    data = data{1};
    if( ~isstruct(data) )
      error('was für type ist hier??')
    else
      names = fieldnames(data);
      s.n      = length(names);
      s.length = 0;

      for i = 1:s.n
        s.s(i) = cg_read_ecal_get_vector_struct_get_struct(data.(names{i}),names{i},channel_name,q);
      end
    end      
  end
    
end
function s = cg_read_ecal_get_vector_struct_get_vec_struct_check_length(data,s,q)

  if( s.type == q.STRUCT_TYPE )
    names = fieldnames(data);
    for i = 1:length(names)
      try
      s.s(i) = cg_read_ecal_get_vector_struct_get_vec_struct_check_length(data.(names{i}),s.s(i),q);
      catch
        a = 0;
      end
    end
  elseif( s.type == q.FLOAT_TYPE )
    return
  elseif( s.type == q.INT_TYPE )
    return
  else % cell
    n        = length(data);
    s.length = max(s.length,n);
    for i=1:n
      try
        d = data{i};
      catch
        break;
      end
      if( ~isstruct(d) )
        error('was für type ist hier??')
      else
        names = fieldnames(d);
        for j = 1:s.n
          s.s(j) = cg_read_ecal_get_vector_struct_get_vec_struct_check_length(d.(names{j}),s.s(j),q);
        end
      end
    end      
  end
    
 
end
function [r,ri]  = cg_read_ecal_get_vector_struct_get_vec_struct_inum(s)
  cc = {s.name,s.type,s.length};
  c = {cc};
  r.c = c;
  ri  = 1;
  [r,ri] = cg_read_ecal_get_vector_struct_get_vec_struct_inum_next(s,r,ri);
end
function [r,ri] = cg_read_ecal_get_vector_struct_get_vec_struct_inum_next(s,r,ri)
  
  c0 = r(ri).c;
  if( s.n == 0 )
    return
  else
    for i=1:s.n
      cc = {s.s(i).name,s.s(i).type,s.s(i).length};
      c  = c0;
      c{length(c)+1} = cc;
      
      if( i == 1 )
        r(ri).c = c;
      else
        ri = ri + 1;
        r(ri) = r(ri-1);
        r(ri).c = c;
      end
      [r,ri] = cg_read_ecal_get_vector_struct_get_vec_struct_inum_next(s.s(i),r,ri);
    end

    
  end
end
function name = cg_read_ecal_get_vector_struct_get_name_from_struct(c,q)

  name = '';
  
  n = length(c);
  
  for i=1:n
    
    if( i > 1 )
      name = [name, '_'];
    end
    name = [name,c{i}{1}];
    
    if( (i < (n-1)) && (c{i}{2} == q.CELL_TYPE)  )
      name = [name,sprintf('%i',c{i}{3}-1)];
    end
      
  end
end
function  e = cg_read_ecal_get_vector_struct_get_e(r,ri,timevec,timestamp,data,q)

  e = [];
  for i=1:ri
     
    p  = cg_read_ecal_get_vector_struct_get_cnames_from_r(r(i),q);
    for j=1:length(p)
      ee = cg_read_ecal_get_vector_struct_get_e_one(p(j),timevec,data,q);
      e = merge_struct_f(e,ee);
    end
    
  end
end 
function p  = cg_read_ecal_get_vector_struct_get_cnames_from_r(r,q)
  np = 1;
  p(1).befehl = 'data{i1}';
  p(1).ni     = r.c{1}{3};
  p(1).name   = r.c{1}{1};
  nicount   = 1;
  n = length(r.c);
  
  if( strcmp(r.c{2}{1},'section') )
    a = 0;
  end
  
  for i=2:n
    ni        = r.c{i}{3};
    nmulti    = 0;
    flagmulti = 0;
    % proof for mulityvektor
    if( (r.c{i}{2} == q.CELL_TYPE) )
      for j=i+1:n
        if( r.c{j}{2} == q.CELL_TYPE )
          flagmulti = 1;
        end
      end
      for j=i+1:n
        if( r.c{j}{3} > 1 )
          nmulti = ni;
          break;
        end
      end
      if( (ni > 1) && (nmulti > 0))
        nn  = 0;
        np0 = np;
        pp  = p;
        for j=1:np
          for k=1:nmulti
            nn = nn+1;
            pp(nn) = p(j);
          end
        end
        np = nn;
        p  = pp;
      end
    end
    for j=1:np
      p(j).befehl = [p(j).befehl,'.'];
      p(j).name   = [p(j).name,'_'];
    
      if( (r.c{i}{2} == q.FLOAT_TYPE) || (r.c{i}{2} == q.INT_TYPE) || (r.c{i}{2} == q.STRUCT_TYPE) )

        p(j).befehl = [p(j).befehl,'(''',r.c{i}{1},''')(1)'];
        p(j).name   = [p(j).name,r.c{i}{1}];

      else % cell
        if( flagmulti )
          if( nmulti==0 )
            p(j).befehl = [p(j).befehl,'(''',r.c{i}{1},'''){1}'];
            p(j).name   = [p(j).name,r.c{i}{1},num2str(1)];
          else              
            kk = mod(j,nmulti);
            if( kk == 0 )
              kk=nmulti;
            end
            p(j).befehl = [p(j).befehl,'(''',r.c{i}{1},'''){',num2str(kk),'}'];
            p(j).name   = [p(j).name,r.c{i}{1},num2str(kk)];                         
          end            
        elseif( ni == 1 )
          p(j).befehl = [p(j).befehl,'(''',r.c{i}{1},'''){1}'];
          p(j).name   = [p(j).name,r.c{i}{1}];
        else
          nicount = nicount + 1;
          p(j).befehl = [p(j).befehl,'(''',r.c{i}{1},'''){i',num2str(nicount),'}'];
          p(j).name   = [p(j).name,r.c{i}{1}];
          p(j).ni     = [p(j).ni;r.c{i}{3}];

        end
      end
    end
    
  end
end
   
function  e = cg_read_ecal_get_vector_struct_get_e_one(p,timevec,data,q)

  e = [];  
  if( length(p.ni) == 1 )
    
    vec = zeros(p.ni,1);
    b = ['vec(i1) = ',p.befehl,';'];
    for i1=1:p.ni
      try
      eval(b)
      catch
        vec(i1) = 0.0;
      end
    end
  elseif( length(p.ni) == 2 )
    
    vec = cell(1,p.ni(1));
    for i1=1:p.ni(1)
      vecvec = zeros(p.ni(2),1);
      b = ['vecvec(i2) = ',p.befehl,';'];
      for i2=1:p.ni(2)
        try
        eval(b)
        catch
          vecvec = [];
          break;
        end
      end
      vec{i1} = vecvec;
    end

  else
    error('ni > 2')
  end
    
  e = e_data_add_value(e,p.name,'','',timevec,vec,0);
  
end
function e = cg_read_ecal_get_vector_struct_get_unit_lin(e,unit_lin_datei)  
%
% Liest unit-datai ein
%
  [ okay,c,nc ] = read_ascii_file( unit_lin_datei );
  
  if( ~okay )
    warning('Die Unit-Datei %s konnte nicht gelesen werden')
    Csigname = {};
    CUnit     = {};
    CLin      = {};
  else
    [Csigname,CUnit,CLin] = cg_read_ecal_get_vector_struct_get_sig_unit_lin(c);
  end
  
  csignames = fieldnames(e);
  
  WarnSigListe = {};
  WarnFlag     = 0;
  for i=1:length(csignames)
    [e,Csigname,CUnit,CLin,Flag,WarnSig] = cg_read_ecal_get_vector_struct_get_e_sig_unit(e,csignames{i},Csigname,CUnit,CLin);
    if( Flag )
      WarnSigListe = cell_add(WarnSigListe,WarnSig);
      WarnFlag     = Flag;
    end
  end
  
  if( WarnFlag )
    fprintf('========================================================================\n');
    for i=1:length(WarnSigListe)
      fprintf('(%i) %s\n',i,WarnSigListe{i})
    end
    fprintf('========================================================================\n');
    warning('Bei obige Signalen fehlen unit und lin, Datei: %s',unit_lin_datei);
  end
  
  % Zurück schreiben
  c = cg_read_ecal_get_vector_struct_set_sig_unit_lin(Csigname,CUnit,CLin);
  
  okay = write_ascii_file( unit_lin_datei, c );
  
  if( ~okay )
    error('Writing File: %s',unit_lin_datei);
  end

end
function [e,Csigname,CUnit,CLin,WarnFlag,WarnSig] = cg_read_ecal_get_vector_struct_get_e_sig_unit(e,signame,Csigname,CUnit,CLin)
  WarnSig  = '';
  WarnFlag = 0;
  ifound   = cell_find_f(Csigname,signame,'v');
  
  % wenn mehrfach vorkommt:
  if( length(ifound) > 1)
      Csigname = cell_delete(Csigname,ifound(2),ifound(end));
      CUnit    = cell_delete(CUnit,ifound(2),ifound(end));
      CLin     = cell_delete(CLin,ifound(2),ifound(end));
      ifound   = cell_find_f(Csigname,signame,'v');
  end
  
  if( isempty(ifound) ) % nicht gefunden
    
    WarnFlag = 1;
    WarnSig  = signame;
    c = str_split(signame,'_');
    signamebody = c{1};
    sigunit     = e.(signame).unit;
    siglin      = e.(signame).lin;
    if( ~isempty(Csigname) )
      [jcell,jpos] = cell_find_from_ipos(Csigname ...
                                        ,length(Csigname) ...
                                        ,length(Csigname{length(Csigname)}) ...
                                        ,signamebody,'back');
                                      
       Csigname = cell_insert(Csigname,jcell+1,signame);
       CUnit    = cell_insert(CUnit,jcell+1,sigunit);
       CLin     = cell_insert(CLin,jcell+1,siglin);
    else
      Csigname = cell_add(Csigname,signame);
      CUnit    = cell_add(CUnit,sigunit);
      CLin     = cell_add(CLin,siglin);
    end
  else
    try
     if( ~isempty(CUnit{ifound}) )
      e.(signame).unit =  CUnit{ifound};
      e.(signame).lin  =  CLin{ifound};
     else
      WarnFlag = 1;
      WarnSig  = signame;
     end 
    catch
     a = 0;
    end
  end
end
      
function [Csigname,CUnit,CLin] = cg_read_ecal_get_vector_struct_get_sig_unit_lin(c)

 Csigname  = {};
 CUnit     = {};
 CLin      = {};
 
 for i = 1:length(c)
   
   cc = str_split(c{i},',');
   
   if( length(cc) >= 3 )
     Csigname = cell_add(Csigname,str_cut_ae_f(cc{1},' '));
     CUnit    = cell_add(CUnit,str_cut_ae_f(cc{2},' '));
     CLin     = cell_add(CLin,str_cut_ae_f(str2double(cc{3}),' '));
   end
 end

end
function c = cg_read_ecal_get_vector_struct_set_sig_unit_lin(Csigname,CUnit,CLin)

  n1 = cell_char_max_length(Csigname);
  n2 = cell_char_max_length(CUnit);
  for i=1:length(CLin)
    CLin{i} = num2str(CLin{i});
  end
  n3 = cell_char_max_length(CLin);
  
  Csigname = cell_char_fill_w_string(Csigname,n1,' ');
  CUnit    = cell_char_fill_w_string(CUnit,n2,' ');
  CLin     = cell_char_fill_w_string(CLin,n3,' ');

  c = {};
  for i=1:length(Csigname)
    c = cell_add(c,[Csigname{i},' , ',CUnit{i},' , ',CLin{i}]);
  end
end

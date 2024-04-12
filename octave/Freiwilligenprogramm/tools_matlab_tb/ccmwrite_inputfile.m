function okay = ccmwrite_inputfile(varargin)
%
% Ausgabe von Vektoren in Input-File für Car-Maker
%
% okay = ccmwrite_inputfile('file_name',file_name ...
%                          ,'vec_list',cvec ...
%                          [,'name_list',cnames ...]
%                          [,'istart',istart ...]
%                          [,'iend',iend ...]
%
% vec_list    cell array mit neum Vektor mit  den Daten
% name_list   cell array mit char Name der Vektoren, die als erste Zeile
%                                 in Kommentarform geschrieben wird
% istart      Startindex
% iend end Index

  okay     = 1;
  lspalte  = 20;
  laufloes = 10;
  file_name   = 'input.asc';
  vec_list    = {};
  name_list   = {};
  istart      = 1;
  iend        = -1;
  i = 1;
  while( i+1 <= length(varargin) )

      switch lower(varargin{i})
          case {'file_name','file'};
              file_name = varargin{i+1};
          case {'vec_list','veclist'};
              vec_list = varargin{i+1};
          case {'name_list','namelist'};
              name_list = varargin{i+1};
          case {'i_start','istart'};
              istart = varargin{i+1};
          case {'i_end','iend'};
              iend = varargin{i+1};
          otherwise
              error('%s: Attribut <%s> ist nicht okay',mfilename,varargin{i}); 

      end
      i = i+2;
  end

  if( isempty(vec_list) )
    okay = 0;
    return
  end
  
  n = length(vec_list);
  
  m = length(name_list);
  
  if( n > m )
    
    for i=m+1:n
      name_list{i} = ['vec',num2str(i)];
    end
  end
  
  % vecliste prüfen
  %----------------
  nlim = 1e10;
  for i=1:n
    vec     = vec_list{i};
    [nv,mv] = size(vec);
    if( mv > nv )
      vec_list{i} = vec';
      nv = mv;
    end
    if( nv < nlim )
      nlim = nv;
    end
  end
  
  if( iend < 0 )
    iend = nlim;
  elseif( iend > nlim )
    iend = nlim;
  end
  
  if( istart > iend )
    error('istart=%i ist größer iend=%i',istart,iend);
  end
    
  
  fid = fopen(file_name,'w');
  if( fid < 0 )
    error('File <%s> kann nicht geöffnet werden !!!',file_name);
  end
  
  % erste Zeile
  form = sprintf('# %%%is',lspalte-1);
  fprintf(fid,form,name_list{1});
  form = sprintf('%%%is',lspalte);
  for i=2:n
    fprintf(fid,form,name_list{i});
  end
  fprintf(fid,'\n');
  
  form = sprintf('%%%i.%if',lspalte,laufloes);
  for j=istart:iend
    for i=1:n
      fprintf(fid,form,vec_list{i}(j));
    end
    fprintf(fid,'\n');
  end
  
  fclose(fid)
  
  
  
  
    
  
  
end
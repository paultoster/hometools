function [foundflag,s] = e_data_find_situation(e,s)
%
% [found,s] = e_data_find_situation(e,s)
%
% find situation in measurement e given by several contidions:
%
% s.cond(1)   is the pre condition to find the first situation
% s.cond(2:n) is the next condition to find in situation with all former conditions
%              in a time gap between s.delta_t_min and s.delta_t_max 
% 
%              cond(i) has m sets which all be set in 'and' or 'or' - relation
%
% all necessary data will be transformed in one time base by
% [d,u,c] = d_data_read_e(e,s.dt)          
%
% s.dt                         = 0.01;      % default 0.01 s
%
% s.cond(1).set(1).e_signal_name = '';
% s.cond(1).set(1).condition     = '>';
% s.cond(1).set(1).value         = 1;
%
% s.cond(1).set(2).e_signal_name = '';
% s.cond(1).set(2).condition     = '<';
% s.cond(1).set(2).value         = 0.01;
% s.cond(1).set(2).type          = 'and';
% 
% s.cond(2).delta_t_min          = 0.1;       % default -1  to search after
%                                                           finding of
%                                                           condition i-1
%                                                           minimal
% s.cond(2).delta_t_max          = 1.;        % default -1  to search after
%                                                           finding of
%                                                           condition i-1
%                                                           maximal
% s.cond(2).set(1).e_signal_name = '';
% s.cond(2).set(1).condition     = '>';
% s.cond(2).set(1).value         = 1;
% s.cond(2).set(2).e_signal_name = '';
% s.cond(2).set(2).condition     = '<';
% s.cond(2).set(2).value         = 0.01;
% s.cond(1).set(2).type          = 'and';
%
% Output
% s.cond(i).out(j).t0
% s.cond(i).out(j).t1
%
% sout is indexed structure with start value and end value with all
%         conditions, at least sout(1).t0 and sout(1).t1
%         otherwise sout is empty
%
%
% structure of e-struct:
%  
%      e.('signame').time    zeitvektor
%      e.('signame').vec     Wertevektor
%      e.('signame').unit    Einheit
%      e.('signame').comment Kommentar
%      e.('signame').lin     1  linear interpolieren
%                            0  konstant interpolieren
%      e.('signame').leading_time_name    Damit wird alle mit diesem Namen
%                                         versehenen Vektoren mit dieser Zeitbasis aus e gleich in d-STruktur
%                                         gewandelt
 
 s = s(1);
 if( ~check_val_in_struct(s,'dt','num',1) )
   s.dt = 0.01;
 end

 if( ~check_val_in_struct(s,'cond','struct',1) )
   error('no condition s.cond set')
 end

 nc = length(s.cond);
  
 % proof condition
 for i=1:nc
   
   if( ~check_val_in_struct(s.cond(i),'set','struct',1) )
     error('in s.cond(%i) no set is in struct (s.cond(%i).set',i,i)
   end
   
   s.cond(i).ns = length( s.cond(i).set);
   
   for j=1:s.cond(i).ns
     
     if( ~check_val_in_struct(s.cond(i),'delta_t_min','num',1) )
       s.cond(i).delta_t_min = -1;
     end
     if( ~check_val_in_struct(s.cond(i),'delta_t_max','num',1) )
       s.cond(i).delta_t_max = -1;
     end
     if( ~check_val_in_struct(s.cond(i).set(j),'e_signal_name','char',1) )
       error(' s.cond(%i).set(%i).e_signal_name not set',i,j);
     end
     
     if( ~isfield(e,s.cond(i).set(j).e_signal_name) )
       warning(' s.cond(%i).set(%i).e_signal_name = %s is not in data set e',i,j,s.cond(i).set(j).e_signal_name);
       foundflag = 0;
       return
     end
     if( ~check_val_in_struct(s.cond(i).set(j),'condition','char',1) )
       error(' s.cond(%i).set(%i).condition not set',i,j);
     end
     
     if(  ~strcmp(s.cond(i).set(j).condition,'==') ...
       && ~strcmp(s.cond(i).set(j).condition,'<') ...
       && ~strcmp(s.cond(i).set(j).condition,'>') ...
       )
       error( ' s.cond(%i).set(%i).condition = %s not implemnted (use ''=='',''<'',''>'')',i,j,s.cond(i).set(j).condition);
     end
     if( ~check_val_in_struct(s.cond(i).set(j),'value','num',1) )
       error(' s.cond(%i).set(%i).value not set',i,j);
     end
     
     if( ~check_val_in_struct(s.cond(i).set(j),'type','char',1) )
       s.cond(i).set(j).type = 'and';
     elseif(  ~strcmp(s.cond(i).set(j).type,'and') ...
           && ~strcmp(s.cond(i).set(j).type,'or') ...
           )
         error( ' s.cond(%i).set(%i).type = %s wrong (use ''and'',''or'')',i,j,s.cond(i).set(j).type);
     end
   end
   
 end
   
 % collect all signals
 ee = [];
 for i=1:nc  
   for j=1:s.cond(i).ns        
       ee.(s.cond(i).set(j).e_signal_name) = e.(s.cond(i).set(j).e_signal_name);
   end
 end
 
 % transform into one time base
 [d,~,~] = d_data_read_e(ee,s.dt);
 
 
 % search for conditions
 %----------------------
 foundflag = 1;
 for i=1:nc
   
   if( i == 1 )  
  
     sout = e_data_find_situation_find_first(d,s.cond(i));
     
   else
          
     sout = e_data_find_situation_find_next(d,s.cond(i),sout,s.dt);
   end
   
   if( isempty(sout) )
     foundflag = 0;
   else
     for j=1:length(sout)
       s.cond(i).out(j) = convert_to_time(d.time,sout(j));
     end
   end
 end
  
end
function sout = e_data_find_situation_find_first(d,cond)

  %first condition of first set
  sout = e_data_find_situation_find_first_values(d,cond.set(1));

  % all other sets conditions
  for j=2:cond.ns
    
    if( isempty(sout) && ( cond.set(j).type(1) == 'a') ) % and condition
      return
    else    
      sout = e_data_find_situation_find_first_in_sout(d,cond.set(j),sout);
      if( isempty(sout) && ( cond.set(j).type == 'a') ) % and condition
        return
      end
    end
  end


end
function sout = e_data_find_situation_find_first_values(d,set)
  sout = [];
 
  s = vec_find_values('type',set.condition,'vec',d.(set.e_signal_name),'val',set.value);
  
  if( ~isempty(s) )
      
    for k=1:length(s) 
      sout0.i0 = s(k).i0;
      sout0.i1 = s(k).i1;
      sout = struct_add_struct_items(sout,sout0);
    end
    
  end
end
function s = e_data_find_situation_find_first_in_sout(d,set,s)


  % and - condition between set
  if( (set.type(1) == 'a') )
    ss = [];
    for k=1:length(s)
      dd   = d_data_reduce_by_index(d,s(k).i0,s(k).i1);
      sout = vec_find_values('type',set.condition,'vec',dd.(set.e_signal_name),'val',set.value);
      
      if( ~isempty(sout) )
        for kk=1:length(sout)
          ss0.i0 = sout(kk).i0 + s(k).i0 - 1;
          ss0.i1 = sout(kk).i1 + s(k).i0 - 1;
          ss = struct_add_struct_items(ss,ss0);
        end
      end
    end
    
    s = ss;
    
  % or condition between set
  else
    
    sout = vec_find_values('type',set.condition,'vec',d.(set.e_signal_name),'val',set.value);
  
    if( ~isempty(sout) )
      s = struct_add_struct_items(s,sout);
    end
    
  end
  
end
function sout = e_data_find_situation_find_next(d,cond,sin,dt)

  sout = [];
  if( cond.delta_t_min < 0 )
    di0 = 0;
  else
    di0 = max(0,round(cond.delta_t_min/dt));
  end

  if( cond.delta_t_max < 0 )
    di1 = length(d.time);
  else
    di1 = max(1,round(cond.delta_t_max/dt));
  end
  
  
  for i=1:length(sin)
    
    i0 = sin(i).i0 + di0;
    i1 = sin(i).i1 + di1;
    
    % da and-beziehung zwischen den condition cond(i) besteht, wird hier
    % beschnitten
    dd   = d_data_reduce_by_index(d,i0,i1);
    
    sout = e_data_find_situation_find_first_values(dd,cond.set(1));

    for j=2:cond.ns
      sout = e_data_find_situation_find_first_in_sout(dd,cond.set(j),sout);
    end
    
    for k=1:length(sout)
      sout(k).i0 = sout(k).i0 +di0 - 1;
      sout(k).i1 = sout(k).i1 +di0 - 1;
    end
  end

end
function sout = convert_to_time(timevec,sin)

  sout.t0 = timevec(sin.i0);
  sout.t1 = timevec(sin.i1);
  
end
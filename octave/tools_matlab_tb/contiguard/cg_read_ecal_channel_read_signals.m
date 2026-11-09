function e = cg_read_ecal_channel_read_signals(e,name_channel,time,d,sigliste)

  ndata = length(d.data);
  
  cnames = cell_collect_all_struct_names(d.data);
  
  for i=1:length(cnames)
    for j=1:length(sigliste)
      
      s.dstructnames = str_split(sigliste{j}{1},'.');
      s.dname        = cell_concatenate_str_cells(s.dstructnames,'_');
      s.dindex = sigliste{j}{2};
      s.dunit  = sigliste{j}{3};
      s.dtype  = sigliste{j}{4};
      s.dlin   = sigliste{j}{5};
      s.dcom   = sigliste{j}{6};
      
      if( strcmpi(cnames{i},s.dstructnames{1}) )
        e = cg_read_ecal_channel_read_signals0(e,name_channel,time,d.data,ndata,cnames{i},s);
      end
    end 
  end
  % e =  cg_read_ecal_channel_read_signals_elim_123456789(e);
end

function e = cg_read_ecal_channel_read_signals0(e,name_channel,time,data,ndata,cname,s)

  n = length(s.dstructnames);
  
  % nur eine Ebene
  if( n == 1 )
    e = cg_read_ecal_channel_read_signals_eine_Ebene(e,name_channel,time,data,ndata,cname,s);
  elseif( n == 2)
    e = cg_read_ecal_channel_read_signals_zwei_Ebenen(e,name_channel,time,data,ndata,cname,s);
  end

      
  end
  function e = cg_read_ecal_channel_read_signals_eine_Ebene(e,name_channel,time,data,ndata,cname,s)
    %==================================================================
    % Länge von Struktur
    m2data = 0;
    txtflag = 1;
    for jj=1:ndata
      if( isfield(data{jj},cname) )
        m2data = max(m2data,length(data{jj}.(cname))); 
        
        if( ~ischar(data{jj}.(cname) ) )
          txtflag = 0;
        end
      end      
    end
    
    % Text
    if( txtflag )
      
      if( ~strcmpi(s.dtype,'string') )
        error('text-Vector (cell), but not described as <string>');
      else
        cvec = {};
        for jj=1:ndata
          cvec = cell_add(cvec,data{jj}.(cname));
        end
        sout.vin = cvec;
        tin      = time;
      end
      
    
    % einfacher Vektor
    %-----------------
    elseif( m2data == 1 )
      
      vec = zeros(ndata,1);
      if( strcmpi(s.dtype,'double') )
        for jj=1:ndata
          try
            vec(jj) = double(data{jj}.(cname)(s.dindex));
          catch
            error('Error: name: <%s> is not in data-struct any more (data{%i})',cname,jj);
          end
        end
      else
        for jj=1:ndata
          try
          vec(jj) = round(double(data{jj}.(cname)(s.dindex)));
          catch
          vec(jj) = -123.;
          end
        end
      end
      
      % Monotonie
      %---------------------------------------  
        [tin,vin] = elim_nicht_monoton(time,vec);
        sout.vin = vin;
        
    % cell array
    %-----------
    else
      
      sout.vin = {};
      tin = time(1:ndata);
      for jj=1:ndata
        if( isfield(data{jj},cname) )
          vec = data{jj}.(cname);
        else
          vec = [];
        end

        
        if( strcmpi(s.dtype,'double') )
          sout.vin = cell_add(sout.vin,double(vec));
        else
          sout.vin = cell_add(sout.vin,round(double(vec)));                
        end
      end

      % Monotonie
      %---------------------------------------   
      index_liste = index_nicht_monoton(tin);
      if( ~isempty(index_liste) )
        tin  = vec_delete(tin,index_liste);
        nvin = length(s);
        if( nvin == 1 )
          sout.vin  = cell_delete(sout.vin,index_liste);
        else
          for k=1:nvin
            sout(k).vin = cell_delete(sout(k).vin,index_liste);
          end
        end
      end
      
    end
    
    % sout.vin einsortieren in e
    %---------------------------------------   
    nvin = length(sout);
    if( nvin == 1 )        
      e = e_data_add_value(e,[name_channel,'_',s.dname],s.dunit,s.dcom,tin,sout.vin,s.dlin);
    else
      for k=1:nvin
        s.dname = sprintf('%s%i_%s',cname,k,s.dstructnames{2});
        e = e_data_add_value(e,[name_channel,'_',s.dname],s.dunit,s.dcom,tin,sout(k).vin,s.dlin);
      end
    end

  end
  
  
  function e = cg_read_ecal_channel_read_signals_zwei_Ebenen(e,name_channel,time,data,ndata,cname,s)
  %==================================================================
  sout.vin = {};
  tin = time(1:ndata);
  cellflag = 0;
  for i=1:ndata
    if( isfield(data{i},cname) )
      if( iscell(data{i}.(cname)) )
        cellflag = 1;
        break;
      end
    end
  end

  if( cellflag )
    sout = cg_read_ecal_channel_read_signals_zwei_Ebenen_cell(time,data,ndata,cname,s,sout);
  else   
    sout = cg_read_ecal_channel_read_signals_zwei_Ebenen_not_cell(time,data,ndata,cname,s,sout);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  end

  % Monotonie
  %---------------------------------------   
  index_liste = index_nicht_monoton(tin);
  if( ~isempty(index_liste) )
    tin  = vec_delete(tin,index_liste);
    nvin = length(sout);
    if( nvin == 1 )
      sout.vin  = cell_delete(sout.vin,index_liste);
    else
      for k=1:nvin
        sout(k).vin = cell_delete(sout(k).vin,index_liste);
      end
    end
  end
  % s.vin einsortieren in e
  %---------------------------------------   
  nvin = length(sout);
  if( nvin == 1 )        
  tname = [name_channel,'_',s.dname];
    if( length(tname) > 63 ) 
      tname = reduce_name_in_name_channel_to_fit_63(name_channel,['_',s.dname]);
    end
    e = e_data_add_value(e,tname,s.dunit,s.dcom,tin,sout.vin,s.dlin);
  else
    for k=1:nvin
      s.dname = sprintf('%s_%i_%s',cname,k,s.dstructnames{2});
      tname = [name_channel,'_',s.dname];
      if( length(tname) > 63 ) 
        tname = reduce_name_in_name_channel_to_fit_63(name_channel,['_',s.dname]);
      end
      e = e_data_add_value(e,tname,s.dunit,s.dcom,tin,sout(k).vin,s.dlin);
    end
  end


end

function tname = reduce_name_in_name_channel_to_fit_63(name_channel,dname)

  l1 = length(name_channel);
  l2 = length(dname);
  
  dl = (l1+l2)-63;
  if( dl > 0 )
    if( l1 > dl+4 )
      name_channel = name_channel(1:l1-dl);
    else
      name_channel = name_channel(1:min(length(name_channel),4));
      l1           = length(name_channel);
      dl           = (l1+l2)-63;
      dname        = dname(1:l2-dl);
    end
  end
  tname = [name_channel,dname];
end
  
 function sout = cg_read_ecal_channel_read_signals_zwei_Ebenen_cell(time,data,ndata,cname,s,sout) 
  
    % Länge von Unterstruktur
    m1data = 0;
    m2data = 0;
    for jj=1:ndata

      if(  isfield(data{jj},cname) ...
        && isfield(data{jj}.(cname){1},s.dstructnames{2}) )
        
        m1data = max(m1data,length(data{jj}.(cname)));
        for jjj=1:length(data{jj}.(cname))
          if( isfield(data{jj}.(cname){jjj},s.dstructnames{2}) )
            m2data = max(m2data,length(data{jj}.(cname){jjj}.(s.dstructnames{2})));
          end
        end
      end
    end
    
    if( m2data <= 1 )
      for jj=1:m1data
        sout(jj).vin = [];
      end
      flag_cell = 0;
    else
      for jj=1:m1data
        sout(jj).vin = {};
      end
      flag_cell = 1;
    end
    
    vecspez = [];
    for jj=1:ndata
%       if( jj >= 785 )
%         a = 0;
%       end

%       try
      flag = 0;
      for kkk=1:m1data
        if( isfield(data{jj},cname) )
          if( kkk <= length(data{jj}.(cname)) )
            if( isfield(data{jj}.(cname){kkk},s.dstructnames{2}) )
              flag = 1;
              break;
            end
          end
        end
      end
%       catch
%         a = 0;
%       end

      if(  isfield(data{jj},cname) ...
        && flag )

        mdata = length(data{jj}.(cname));
%         if( mdata > 1 )
%           a = 0;
%         end

        % leere Unterstruktur
        if( m2data == 0 )
          for jjj=1:m1data
            if( iscell(s.vin) )
              sout(jjj).vin = cell_add(sout(jjj).vin,[]);
            end
          end
        % eine Unterstruktur
        elseif( m2data == 1 ) 

          if( m1data == 1 )
            
            if( isempty(vecspez) )
              vecspez = zeros(ndata,1);
              if( strcmpi(s.dtype,'double') )
                for jjj=1:ndata
                  try
                  vecspez(jjj) = double(data{jjj}.(cname){1}.(s.dstructnames{2}));       
                  catch
                  vecspez(jjj) = NaN;
                  end
                end
              else
                for jjj=1:ndata
                  try
                  vecspez(jjj) = round(double(data{jjj}.(cname){1}.(s.dstructnames{2})));
                  catch
                  vecspez(jjj) = NaN;
                  end
                end
              end
              [tin,vin] = elim_nicht_monoton(time,vecspez);
              sout.vin = vin;
            end 
            
          % m1data > 1  
          else 
            vec = zeros(m1data,1);
            for k=1:mdata
              if( isfield(data{jj}.(cname){k},s.dstructnames{2}) )
                vec(k) = data{jj}.(cname){k}.(s.dstructnames{2});
              else
                vec(k) = 0;
              end
            end
            if( flag_cell )
              if( strcmpi(s.dtype,'double') )
                for jjj=1:m1data
                  v   = double(vec);
                  val = v(min(length(v),jjj));
                  sout(jjj).vin = cell_add(sout(jjj).vin,val);
                end
              else
                for jjj=1:m1data
                  v = round(double(vec));
                  val = v(min(length(v),jjj));
                  sout(jjj).vin = cell_add(sout(jjj).vin,val);  
                end
              end
            else
              if( strcmpi(s.dtype,'double') )
                for jjj = 1:m1data
                  sout(jjj).vin = [sout(jjj).vin;double(vec(jjj))];
                end
              else
                for jjj = 1:m1data
                  sout(jjj).vin = [sout(jjj).vin;round(double(vec(jjj)))];
                end
              end
            end
          end              
        else
          if( flag_cell )
            for jjj=1:m1data
              vec  = [];
              if( jjj <= length(data{jj}.(cname)) )
              
                nnnn = length(data{jj}.(cname){jjj}.(s.dstructnames{2}));
                if( isnumeric(data{jj}.(cname){jjj}.(s.dstructnames{2})) )
                  for jjjj=1:nnnn
                    vec = [vec;data{jj}.(cname){jjj}.(s.dstructnames{2})(jjjj)];
                  end
                else
                  for jjjj=1:nnnn
                    vec = [vec;data{jj}.(cname){jjj}.(s.dstructnames{2}){jjjj}];
                  end
                end
%               else
%                 vec = [];
              end
              sout(jjj).vin = cell_add(sout(jjj).vin,vec);
            end
          else
            for jjj=1:m1data
              if( isfield(data{jj}.(cname){jjj},s.dstructnames{2}) )
                sout(jjj).vin = [sout(jjj).vin;data{jj}.(cname){jjj}.(s.dstructnames{2})];
              else
                sout(jjj).vin = [sout(jjj).vin;0];
              end
            end
          end
        end
      else
        try
          if( flag_cell )
            for jjj=1:m1data
              sout(jjj).vin = cell_add(sout(jjj).vin,[]);
            end
          else
            for jjj=1:m1data
              sout(jjj).vin = [sout(jjj).vin;0];
            end
          end
        catch
          a = 0;
        end
      end
    end
 end
  
 function sout = cg_read_ecal_channel_read_signals_zwei_Ebenen_not_cell(time,data,ndata,cname,s,sout)
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Länge Unterstruktur
  m2data = 0;
  for jj=1:ndata

      if(  isfield(data{jj},cname) ...
        && isfield(data{jj}.(cname),s.dstructnames{2}) )
        m2data = max(m2data,length(data{jj}.(cname).(s.dstructnames{2})));
      end
  end
  
  vecspez = [];
       
    
  for jj=1:ndata

    if(  isfield(data{jj},cname) ...
      && isfield(data{jj}.(cname),s.dstructnames{2}) )

    % Anzahl Daten
      mdata = length(data{jj}.(cname));
      
      % leer
      if( m2data == 0 )
        if( iscell(sout.vin) )
          sout.vin = cell_add(sout.vin,[]);
        end
      % Länge Unterstruktur == 1
      elseif( m2data == 1 ) 

        if( mdata == 1 )
          if( isempty(vecspez) )
            vecspez = zeros(ndata,1);
            if( strcmpi(s.dtype,'double') )
              
              for jjj=1:ndata
                try
                  vecspez(jjj) = double(data{jjj}.(cname).(s.dstructnames{2})); 
                catch
                  vecspez(jjj) = NaN;
                end
              end
            else
              for jjj=1:ndata
                try
                  vecspez(jjj) = round(double(data{jjj}.(cname).(s.dstructnames{2})));
                catch
                  vecspez(jjj) = NaN;
                end
              end
            end
            [tin,vin] = elim_nicht_monoton(time,vecspez);
            sout.vin = vin;
          end                 
        else
          if( mdata == 1 )
            sout.vin = cell_add(sout.vin,data{jj}.(cname).(s.dstructnames{2}));
          else
            error('not programed');
          end
        end
        
      % grösser eine Unterstruktur
      else
        if( iscell(sout.vin) )
          sout.vin = cell_add(sout.vin,data{jj}.(cname).(s.dstructnames{2}));
        end
      end
    end
  end
 end
%  function e = cg_read_ecal_channel_read_signals_elim_123456789(e)
%  
%   signames = fieldnames(e);
%   
%   for i=1:length(signames)
%     if( e_data_is_timevec(e,signames{i}) )
%       jliste = [];
%       flag   = 0;
%       for  j=1:length(e.(signames{i}).time)
%         if( abs(e.(signames{i}).vec(j)+1234567890) > 0.01 )
%           jliste = [jliste;j];     
%         else
%           flag = 1;
%         end
%       end
%       if( flag )
%         e.(signames{i}).time = e.(signames{i}).time(jliste);
%         e.(signames{i}).vec  = e.(signames{i}).vec(jliste);
%       end
%     end
%   end
%  end
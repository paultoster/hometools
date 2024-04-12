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
    for jj=1:ndata
      if( isfield(data{jj},cname) )
        m2data = max(m2data,length(data{jj}.(cname))); 
      end
    end
    
    % einfacher Vektor
    %-----------------
    if( m2data == 1 )
      
      vec = zeros(ndata,1);
      if( strcmpi(dtype,'double') )
        for jj=1:ndata
          vec(jj) = double(data{jj}.(cname)(dindex));
        end
      else
        for jj=1:ndata
          vec(jj) = round(double(data{jj}.(cname)(dindex)));
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

        if( strcmpi(dtype,'double') )
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
    
    % s.vin einsortieren in e
    %---------------------------------------   
    nvin = length(sout);
    if( nvin == 1 )        
      e = e_data_add_value(e,[name_channel,'_',s.dname],dunit,dcom,tin,sout.vin,dlin);
    else
      for k=1:nvin
        dname = sprintf('%s%i_%s',cname,k,s.dstructnames{2});
        e = e_data_add_value(e,[name_channel,'_',dname],dunit,dcom,tin,sout(k).vin,dlin);
      end
    end

  end
  
  
  function e = cg_read_ecal_channel_read_signals_zwei_Ebenen(e,name_channel,time,data,ndata,cname,s)
  %==================================================================
  sout.vin = {};
  tin = time(1:ndata);

  if( iscell(data{1}.(cname)) )
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
    e = e_data_add_value(e,[name_channel,'_',s.dname],dunit,dcom,tin,sout.vin,dlin);
  else
    for k=1:nvin
      dname = sprintf('%s%i_%s',cname,k,s.dstructnames{2});
      e = e_data_add_value(e,[name_channel,'_',dname],dunit,dcom,tin,sout(k).vin,dlin);
    end
  end


  end


  
 function sout = cg_read_ecal_channel_read_signals_zwei_Ebenen_cell(time,data,ndata,cname,s,sout) 
  
    % Länge von Unterstruktur
    m2data = 0;
    for jj=1:ndata

      if(  isfield(data{jj},cname) ...
        && isfield(data{jj}.(cname){1},s.dstructnames{2}) )
        
        m2data = max(m2data,length(data{jj}.(cname){1}.(s.dstructnames{2})));
        
      end
    end
    
    vecspez = [];
    for jj=1:ndata

      if(  isfield(data{jj},cname) ...
        && isfield(data{jj}.(cname){1},s.dstructnames{2}) )

        mdata = length(data{jj}.(cname));

        % leere Unterstruktur
        if( m2data == 0 )
          if( iscell(s.vin) )
            sout.vin = cell_add(sout.vin,[]);
          end
        % eine Unterstruktur
        elseif( m2data == 1 ) 

          if( mdata == 1 )
            
            if( isempty(vecspez) )
              vecspez = zeros(ndata,1);
              if( strcmpi(dtype,'double') )
                for jjj=1:ndata
                  vecspez(jjj) = double(data{jjj}.(cname){1}.(s.dstructnames{2}));                       
                end
              else
                for jjj=1:ndata
                  try
                  vecspez(jjj) = round(double(data{jjj}.(cname){1}.(s.dstructnames{2})));
                  catch
                  vecspez(jjj) = -123;
                  end
                end
              end
              [tin,vin] = elim_nicht_monoton(time,vecspez);
              sout.vin = vin;
            end 
            
          % mdata > 1  
          else 
            vec = zeros(mdata,1);
            for k=1:mdata
              vec(k) = data{jj}.(cname){k}.(s.dstructnames{2});
            end

            if( strcmpi(dtype,'double') )
              sout.vin = cell_add(sout.vin,double(vec));
            else
              sout.vin = cell_add(sout.vin,round(double(vec)));                
            end
          end              
        else
          if( mdata == 1 )
            sout.vin = cell_add(sout.vin,data{jj}.(cname){1}.(s.dstructnames{2}));
          else
            for k=1:mdata                    
              sout(k).vin = data{jj}.(cname){k}.(sout.dstructnames{2});
            end
          end
        end
      else
        if( iscell(s.vin) )
          sout.vin = cell_add(sout.vin,[]);
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
        if( iscell(s.vin) )
          sout.vin = cell_add(sout.vin,[]);
        end
      % Länge Unterstruktur == 1
      elseif( m2data == 1 ) 

        if( mdata == 1 )
          if( isempty(vecspez) )
            vecspez = zeros(ndata,1);
            if( strcmpi(dtype,'double') )
              for jjj=1:ndata
                vecspez(jjj) = double(data{jjj}.(cname).(s.dstructnames{2}));                       
              end
            else
              for jjj=1:ndata
                try
                vecspez(jjj) = round(double(data{jjj}.(cname).(s.dstructnames{2})));
                catch
                vecspez(jjj) = -123;
                end
              end
            end
            [tin,vin] = elim_nicht_monoton(time,vecspez);
            sout.vin = vin;
          end                 
        else
          if( mdata == 1 )
            sout.vin = cell_add(s.vin,data{jj}.(cname).(s.dstructnames{2}));
          else
            error('not programed');
          end
        end
        
      % grösser eine Unterstruktur
      else
        if( iscell(s.vin) )
          sout.vin = cell_add(sout.vin,[]);
        end
      end
    end
  end
end
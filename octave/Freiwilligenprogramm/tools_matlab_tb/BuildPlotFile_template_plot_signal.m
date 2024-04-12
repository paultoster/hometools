function c = BuildPlotFile_template_plot_signal(signame,unit,flag,linesize,farbe,xname,xunit,xytype,yfacflag,yfac,yoffsflag,yoffs,linetypflag,linetyp,markertypflag,markertyp,legtextflag,legtext,use_e_struct)

  c = {};
  if( ~exist('flag','var') )
    flag = 0;
  end
  
  nsig = 0;
  cnames =  {};
  csigns  = {};
  s      = '';
  n = length(signame);
  for i=1:n;
    if( signame(i) == '+' )
      s = '+';
    elseif(signame(i) == '-' )
      s = '-';
    elseif(signame(i) == '*' )
      s = '.*';
    elseif(signame(i) == '/' )
      s = './';
    else
      s = '';
    end
    if( (i == 1) || ~isempty(s) )
      nsig = nsig + 1;
      cnames{nsig} = '';
      csigns{nsig}  = s;
    end
    if( isempty(s) )
    cnames{nsig} = [cnames{nsig},signame(i)];
    end
  end
  
  %[cnames,nsig] = str_split(signame,'+');
  
  if( nsig == 1 )
      flag_new_sig  = 0;
      zeile_new_sig      = '';
      zeile_new_sig_unit = '';
      zeile_new_sig0     = '';
      zeile_new_sig1     = '';
  else
      flag_new_sig  = 1;
      signame       = sprintf('%s___%i',cnames{1},nsig);
      if( use_e_struct )
        zeile_new_sig0  = sprintf('    if( ');
        for i=1:nsig
          if( i == 1 )
            zeile_new_sig0  = sprintf('%s isfield(e,''%s'') ' ...
                            ,zeile_new_sig0,cnames{i});
          elseif( i == nsig )
            zeile_new_sig0  = sprintf('%s && isfield(e,''%s'') )' ...
                            ,zeile_new_sig0,cnames{i});
          else
            zeile_new_sig0  = sprintf('%s && isfield(e,''%s'') ' ...
                            ,zeile_new_sig0,cnames{i});
          end
          if( i == 1 )  
            zeile_new_sig = sprintf('      e = e_data_merge_2_signals(e,''%s'',''%s'',''%s'',''%s'');' ...
                                   ,cnames{i},cnames{i+1},signame,csigns{i+1});
          elseif( i < nsig )
             zeile_new_sig = [zeile_new_sig,sprintf('      e = e_data_merge_2_signals(e,''%s'',''%s'',''%s'',''%s'');' ...
                                   ,signame,cnames{i+1},signame,csigns{i+1})];
          end
        end
        zeile_new_sig_unit = sprintf('      e.%s.unit = e.%s.unit;',signame,cnames{1});
        zeile_new_sig1     = sprintf('    end');
      else
        zeile_new_sig = sprintf('      d.%s = ',signame);
        zeile_new_sig0  = sprintf('    if( ');
        for i=1:nsig
          zeile_new_sig0  = [zeile_new_sig0,sprintf('isfield(d,''%s'')',cnames{i})];
          if( i == nsig ) zeile_new_sig0 = [zeile_new_sig0,' )'];
          else            zeile_new_sig0 = [zeile_new_sig0,sprintf('&& isfield(d,''%s'')',cnames{i+1})];
          end
          zeile_new_sig = [zeile_new_sig,sprintf('d.%s',cnames{i})];
          if( i == nsig ) zeile_new_sig = [zeile_new_sig,';'];
          else            zeile_new_sig = [zeile_new_sig,csigns{i+1}];
          end
        end
        zeile_new_sig_unit = sprintf('      u.%s = u.%s;',signame,cnames{1});
        zeile_new_sig1     = sprintf('    end');
      end
      
  end
   
  if( isempty(xname) )
    
    if( isempty(unit) )
      zeiley = sprintf('        fac = 1.0;offset = 0.0;');
    else
      if( use_e_struct )
        zeiley = sprintf('        [fac,offset] = get_unit_convert_fac_offset(e(idata).(sig_name).unit,''%s'');',unit);
      else
        zeiley = sprintf('        [fac,offset] = get_unit_convert_fac_offset(u(idata).(sig_name),''%s'');',unit);
      end
    end
    
    if( yfacflag || yoffsflag )
      zeiley1 = sprintf('        fac = fac * %f;offset = offset - (%f);',yfac,yoffs);
    else
      zeiley1 = '';
    end
    if( use_e_struct ) 
      zeilexvec = sprintf('        ,''x_vec'',          e(idata).(sig_name).time ...');
      zeileyvec = sprintf('        ,''y_vec'',          e(idata).(sig_name).vec ...');
    else
      zeilexvec = sprintf('        ,''x_vec'',          d(idata).(q.x_sig_name) ...');
      zeileyvec = sprintf('        ,''y_vec'',          d(idata).(sig_name) ...');
    end
    legendname = '[sig_name';
    if( yfacflag )
      legendname = sprintf('%s,''*'',num2str(%f)',legendname,yfac);
    end
    if( yoffsflag )
      legendname = sprintf('%s,''+'',num2str(%f)',legendname,yoffs);
    end
    if( flag )    
      legendname = sprintf('%s,''[%s]''',legendname,unit);
    end
    legendname = sprintf('%s]',legendname);
    
    if( linetypflag )
      linetypname = ['''',linetyp,''''];
    else
      linetypname = 'PlotStandards.Ltype{1}';
    end
    if( markertypflag )
      zeilem1 = sprintf('        ,''marker_type'',    %s ...',['''',markertyp,'''']);
      zeilem2 = sprintf('        ,''marker_n'',       -1 ...');
    else
      zeilem1 = sprintf('        ,''marker_type'',    %s ...','PlotStandards.Marker{idataset}');
      zeilem2 = '        ...';
    end
    
    if( legtextflag )
      legendname = ['''',legtext,''''];
    end
    
    if( use_e_struct ) 
      vecinfieldzeile = '      if( isfield(e(idata),sig_name) && isfield(e(idata).(sig_name),''vec'') && ~isempty(e(idata).(sig_name).vec) )';
    else
      vecinfieldzeile = '      if( is_vecinfield(d(idata),sig_name) )';
    end

    c = ...
    {'    %%--------------------------------------------------------------------------' ...
    ,sprintf('    sig_name = ''%s'';',signame) ...
    ,zeile_new_sig0 ...
    ,zeile_new_sig ...
    ,zeile_new_sig_unit ...
    ,zeile_new_sig1 ...
    ,'    %%--------------------------------------------------------------------------' ...
    ,'    for idataset = 1:ndataset' ...
    ,'      idata = dataset(idataset);' ...
    ,'' ...
    ,vecinfieldzeile ...
    ,'        iplotdata = iplotdata+1;' ...
    ,'' ...
    ,zeiley ...
    ,zeiley1 ...
    ,'        s_fig = plot_set_data_f(s_fig,iplot,iplotdata ...' ...
    ,zeilexvec ...
    ,zeileyvec ...
    ,'        ,''y_factor'',       fac ...' ...
    ,'        ,''y_offset'',       offset ...' ...
    ,sprintf('        ,''line_type'',      %s ...',linetypname) ...
    ,sprintf('        ,''line_size'',      q.%s ...',linesize) ...
    ,sprintf('        ,''line_color'',     PlotStandards.%s ...',farbe) ...
    ,zeilem1 ...
    ,zeilem2 ...
    ,sprintf('        ,''legend'',         %s ...',legendname) ...
    ,'        );' ...
    ,'      end' ...
    ,'    end' ...
    ,'    %-------------------------------------------------------------------------' ...
    ,'    %-------------------------------------------------------------------------' ...
    };
  else
    if( isempty(unit) )
      zeiley = sprintf('        fac_y = 1.0;offset_y = 0.0;');
    else
      if( use_e_struct )
        zeiley = sprintf('        [fac_y,offset_y] = get_unit_convert_fac_offset(e(idata).(sig_name_y).unit,''%s'');',unit);
      else
        zeiley = sprintf('        [fac_y,offset_y] = get_unit_convert_fac_offset(u(idata).(sig_name_y),''%s'');',unit);
      end
    end
    if( yfacflag || yoffsflag )
      zeiley1 = sprintf('        fac_y = fac_y * %f;offset_y = offset_y - (%f);',yfac,yoffs);
    else
      zeiley1 = '';
    end
    if( isempty(xunit) )
      zeilex = sprintf('        fac_x = 1.0;offset_x = 0.0;');
    else
      if( use_e_struct )
        zeilex = sprintf('        [fac_x,offset_x] = get_unit_convert_fac_offset(e(idata).(sig_name_x).unit,''%s'');',xunit);
      else
        zeilex = sprintf('        [fac_x,offset_x] = get_unit_convert_fac_offset(u(idata).(sig_name_x),''%s'');',xunit);
      end
    end
    
    legendname = '[sig_name_y';
    if( yfacflag )
      legendname = sprintf('%s,''*'',num2str(%f)',legendname,yfac);
    end
    if( yoffsflag )
      legendname = sprintf('%s,''+'',num2str(%f)',legendname,yoffs);
    end
    if( flag )    
      legendname = sprintf('%s,''[%s]''',legendname,unit);
    end
    legendname = sprintf('%s]',legendname);
    
    if( legtextflag )
      legendname = ['''',legtext,''''];
    end
    
    % Aus einem Cellarray Vektor soll der erste Vektor genommen werden
    if( strcmpi(xytype,'cellfirst') )
      
      zeilexvec = sprintf('        ,''x_vec'',          x_vector ...');
      zeileyvec = sprintf('        ,''y_vec'',          y_vector ...');
      if( use_e_struct )
        zeile_get_xvec = sprintf('      if(iscell(e(idata).(sig_name_x).vec)),[x_vector,found1] = cell_get_numvec(e(idata).(sig_name_x).vec);else found1 = 0;end');
        zeile_get_yvec = sprintf('      if(iscell(e(idata).(sig_name_y).vec)),[y_vector,found2] = cell_get_numvec(e(idata).(sig_name_y).vec);else found2 = 0;end');
      else
        zeile_get_xvec = sprintf('      if(iscell(d(idata).(sig_name_x))),[x_vector,found1] = cell_get_numvec(d(idata).(sig_name_x));else found1 = 0;end');
        zeile_get_yvec = sprintf('      if(iscell(d(idata).(sig_name_y))),[y_vector,found2] = cell_get_numvec(d(idata).(sig_name_y));else found2 = 0;end');
      end
      if( use_e_struct ) 
        vecinfieldzeile0     = '     if( isfield(e(idata),sig_name_y) && isfield(e(idata),sig_name_x) && ~isempty(e(idata).(sig_name_y).vec) && ~isempty(e(idata).(sig_name_x).vec) )';
        vecinfieldzeile      = '      if( found1 && found2 )';
        vecinfieldzeile_end0 = '     end';
      else
        vecinfieldzeile0     = '     if( is_vecinfield(d(idata),sig_name_y) && is_vecinfield(d(idata),sig_name_x) )';
        vecinfieldzeile      = '      if( found1 && found2 )';
        vecinfieldzeile_end0 = '     end';
      end
    else
    
      if( use_e_struct ) 
        zeilexvec = sprintf('        ,''x_vec'',          e(idata).(sig_name_x).vec ...');
        zeileyvec = sprintf('        ,''y_vec'',          e(idata).(sig_name_y).vec ...');
      else
        zeilexvec = sprintf('        ,''x_vec'',          d(idata).(sig_name_x) ...');
        zeileyvec = sprintf('        ,''y_vec'',          d(idata).(sig_name_y) ...');
      end
      zeile_get_xvec = sprintf(' ');
      zeile_get_yvec = sprintf(' ');
      if( use_e_struct ) 
        vecinfieldzeile0 = '';
        vecinfieldzeile = '      if( isfield(e(idata),sig_name_y) && isfield(e(idata),sig_name_x) && ~isempty(e(idata).(sig_name_y).vec) && ~isempty(e(idata).(sig_name_x).vec) )';
        vecinfieldzeile_end0 = '';
      else
        vecinfieldzeile0 = '';
        vecinfieldzeile = '      if( is_vecinfield(d(idata),sig_name_y) && is_vecinfield(d(idata),sig_name_x) )';
        vecinfieldzeile_end0 = '';
      end
    end    
    
    c = ...
    {'    %%--------------------------------------------------------------------------' ...
    ,sprintf('    sig_name_x = ''%s'';',xname) ...
    ,sprintf('    sig_name_y = ''%s'';',signame) ...
    ,zeile_new_sig0 ...
    ,zeile_new_sig ...
    ,zeile_new_sig_unit ...
    ,zeile_new_sig1 ...
    ,'    %%--------------------------------------------------------------------------' ...
    ,'    for idataset = 1:ndataset' ...
    ,'      idata = dataset(idataset);' ...
    ,'' ...
    ,vecinfieldzeile0 ...
    ,zeile_get_xvec ...
    ,zeile_get_yvec ...
    ,'' ...
    ,vecinfieldzeile ...
    ,'        iplotdata = iplotdata+1;' ...
    ,'' ...
    ,zeilex ...
    ,zeiley ...
    ,zeiley1 ...
    ,'        s_fig = plot_set_data_f(s_fig,iplot,iplotdata ...' ...
    ,zeilexvec ...
    ,zeileyvec ...
    ,'        ,''x_factor'',       fac_x ...' ...
    ,'        ,''x_offset'',       offset_x ...' ...
    ,'        ,''y_factor'',       fac_y ...' ...
    ,'        ,''y_offset'',       offset_y ...' ...
    ,'        ,''line_type'',      PlotStandards.Ltype{1} ...' ...
    ,sprintf('        ,''line_size'',      q.%s ...',linesize) ...
    ,sprintf('        ,''line_color'',     PlotStandards.%s ...',farbe) ...
    ,'        ,''marker_type'',    PlotStandards.Marker{idataset} ...' ...
    ,sprintf('        ,''legend'',         %s ...',legendname) ...
    ,'        );' ...
    ,'      end' ...
    ,vecinfieldzeile_end0 ...
    ,'    end' ...
    ,'    %-------------------------------------------------------------------------' ...
    ,'    %-------------------------------------------------------------------------' ...
    };
  end
end
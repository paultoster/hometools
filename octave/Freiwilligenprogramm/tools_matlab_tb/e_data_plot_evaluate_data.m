function [okay,errtext] = e_data_plot_evaluate_data(varargin)
%
%
%
%  [okay,errtext] = e_data_plot_evaluate_data('basedir','D:temp' ...
%                                             ,'cplot',  {{'CanCtrlRequest_traj_req_vel','km/h',1,'Mschwarz'} ...
%                                                     ,{'VehicleDynamicsIn_signals_speed','km/h',1,'Mgruen'} ...
%                                                     } ... 
%                                             ,'nplot',  {{'CanCtrlRequest_traj_req_vel','km/h',1,'Mschwarz'} ...
%                                                        ,{'VehicleDynamicsIn_signals_speed','km/h',1,'Mgruen'} ...
%                                                        } ...   
%                                             'plotnfirst', 10 ...
%                                             'plotnlast',  10 );
%
%   'basedir'    search in in path and subpaths for *_e.mat (e-structure
%   'nplot'      definition of a new plot figure one axis
%   'cplot'      add a new axis
%                 definition of nplot,cplot
%                 {{'signal_name','unit',dicke,'color'},{}, ... }
%   'plotnfirst' number of first plots from list  as limit
%   'plotnlast'  number of last plots from list as limit

%
  okay = 1;
  errtext = '';
  
  q = q_build_default;
  
  q.basedir  = '';
  q.plotdef  = struct([]);
  q.nplotdef   = 0;
  q.plotnfirst = 1e6;
  q.plotnlast  = 1e6;
  q.plotnflag  = 0;
  
  i = 1;
  while( i+1 <= length(varargin) )

      switch lower(varargin{i})
          case {'basedir'}
            q.basedir = varargin{i+1};
          case {'nplot'}
            q.nplotdef = q.nplotdef + 1;
            q.plotdef(q.nplotdef).cplot{1} = varargin{i+1};
            q.plotdef(q.nplotdef).ncplot   = 1;
            
          case {'cplot'}
            if( q.nplotdef == 0 )
              q.nplotdef = q.nplotdef + 1;
              q.plotdef(q.nplotdef).cplot{1} = varargin{i+1};
              q.plotdef(q.nplotdef).ncplot = 1;
            else
              q.plotdef(q.nplotdef).ncplot = q.plotdef(q.nplotdef).ncplot + 1;
              q.plotdef(q.nplotdef).cplot{q.plotdef(q.nplotdef).ncplot} = varargin{i+1};
            end
          case {'plotnfirst'}
            q.plotnfirst = varargin{i+1};
            if( ~q.plotnflag ) 
              q.plotnflag = 1;
              q.plotnlast = 0;
            end
          case {'plotnlast'}
            q.plotnlast = varargin{i+1};
            if( ~q.plotnflag ) 
              q.plotnflag = 1;
              q.plotnfirst = 0;
            end
          otherwise
            error('%s: Attribut <%s> nicht in der Liste vorhanden',mfilename,varargin{i});
      end
      i = i+2;
  end
  
  % search for mat-Files in base dir
  %-------------------------------- 
  if( ~isempty(q.basedir) )
  
    cfiles = get_files_from_path('ext','mat' ...
                                ,'part_of_name','_e' ...                              
                                ,'path',q.basedir ...
                                ,'all_pathes',1);

    nfiles = length(cfiles);
  else
    cfiles = {};
    nfiles = 0;
  end
  
  q.nplotfigues = nfiles*q.nplotdef;
  
  for i=1:nfiles
    
    if( (q.fig_num < q.plotnfirst ) || ((nfiles-i)*q.nplotdef < q.plotnlast ) )
      [okay,e] = e_data_read_mat(cfiles{i});
      q.filename = cfiles{i};
      q.name     = get_file_name(cfiles{i},1);
      if( okay )

        if( q.nplotdef )

          q = e_data_plot_evaluate_data_plot(q,e,i);


        end
      end
    end
  end
  if( q.fig_num > 1 )
    figmen
  end
  



end
function q = e_data_plot_evaluate_data_plot(q,e,ie)

  set_plot_standards
  
  
    
  % Auswertung über plotdef
  for i=1:q.nplotdef
    
    q.fig_num = q.fig_num + 1;
    p_figure(q.fig_num,1,num2str(ie*100+i),1);

    cplot  = q.plotdef(i).cplot;
    ncplot = q.plotdef(i).ncplot;
    for j = 1:ncplot

      cp  = cplot{j};
      ncp = length(cp);

      subplot(ncplot,1,j)
      
      if( j == 1 )
        title(str_change_f(q.name,'_',' '))
      end

      if( ncp > 1 )
        hold on
      end

      clegname = {};
      for k=1:ncp

       % Signal
        csig  = cp{k};      
        ncsig = length(csig);

        signame = csig{1};

        if( isfield(e,signame) )

          clegname = cell_add(clegname,str_change_f(signame,'_',' '));

          if( ncsig > 1 )
            unit = csig{2};
          else
            unit = '';
          end

          [fac,offset] = get_unit_convert_fac_offset(e.(signame).unit,unit);

          if( ncsig > 2 )
            thick = csig{3};
          else
            thick = 1;
          end

          if( ncsig > 3 )                    
            ifound = cell_find_f(PlotStandards.color_names,csig{4});
            if( ~isempty(ifound) )
              colo = PlotStandards.Mfarbe{ifound(1)};
            else
              colo = PlotStandards.Mfarbe{k};
            end
          else
            colo = PlotStandards.Mfarbe{k};
          end
          
          plot(e.(signame).time,e.(signame).vec*fac+offset,'-','Color',colo,'LineWidth',thick);
          
        end

      end
      if( ncp > 1 )
        hold off
      end

      grid on
      legend(clegname);
      xlabel('t [s]');
      ylabel(unit);
    end
    plot_bottom({'',q.filename},q.fig_num);
  end
end

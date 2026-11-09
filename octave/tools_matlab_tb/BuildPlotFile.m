function [okay,errtext] = BuildPlotFile(varargin)
%
%
% [okay,errtext] = BuildPlotFile(,'name', 'TestVal' ...
%                               ,'cplot',{{'HAF_T1_TYPE','enum',1,'Mschwarz'}} ...
%                               ,'cplot',{{'HAF_T1_StatusReqVal','enum',1,'Mschwarz'}} ...
%                               ,'cplot',{{'HAF_T1_ReqVal','-',1},{'HAF_T1_ReqVal1','-',1}} ...
%                               ,'cplot',{{'yGPS','m',1,'Mblau','xGPS','m'},{'HAF_T1_ReqVal1','-',1}} ...
%                               ,'yfactor',{1,1,0.1} ...
%                               ,'yoffset',{1,2,2.0} ...
%                               ,'yminmax',{2,-1,1} ...
%                               ,'yminmax',{4,0,100.} ...
%                               ,'markertyp',{1,1,'*'} ...
%                               ,'linetyp',{1,1,'none'} ...
%                               ,'linetyp',{1,2,'--'} ...
%                               ,'ctitle',{'Testvariablen',''} ...
%                               ,'legtext',{1,2,'abc'} ...
%                               ,'askforoverwrite',0 ...
%                               ,'use_e_struct', 1 ...
%                               );
%
% pre_name     char             Name vor PlotName einfügen
% name         char             PlotName
% cplot        cell(cell)       Definition eines Diagramms im Plot 
%                               z.B. ,'cplot',{{'HAF_T1_ReqVal','-',1,'Mblau'},{'HAF_T1_ReqVal1','-',1}}
%                               Signalname  der Struktur z.B. 'HAF_T1_ReqVal' => d.HAF_T1_ReqVal
%                               Unit                     z.B. '-' => u.HAF_T1_ReqVal 
%                               (wenn unit = '', dann wird keine Unit berücksichtigt !!!!)
%                               Linienstärke             z.B. 1
%                               Farbe (set_plot_standards) z.B 'Mblau' mittleres Blau
%
%                               Erweiterung auf x-Namen
%                               z.B. ,'cplot',{{'yGPS','m',1,'Mblau','xGPS','m'}}
%                               zusätzlich
%                               x-Signalname    Beispiel 'xGPS'
%                               x-unit          Beispiel 'm'
%
%                               Erweiterung auf x-Name und spezieller Typ
%                               z.B. ,'cplot',{{'yGPS','m',1,'Mblau','xGPS','m','cellfirst'}}
%                               x-y-Type        'first' bedeutet wenn Signal cell arrays mit Vektoren
%                                               dann wird der erste Vektor aus dem Signal verwendet  
%
% yfactor        {iplot,igraf,fac} Faktor für iplot und den iten-Graf mit
%                                 dem Wert fac für den y-Wert
% yoffset        {iplot,igraf,ofs} Offset für iplot und den iten-Graf mit
%                                 dem Wert ofs f+r den y-Wert
% markertyp      {iplot,igraf,markertyp} Marker für iplot und den iten-Graf mit
%                                     mit markertyp = '+','o','*','.','x','s','d'
%                                                   , '^','v','>','<','p','h''','none'	
% linetyp        {iplot,igraf,linetyp} LineType für iplot und den iten-Graf mit
%                                     mit linetyp = '-','--',':','-.','none'	
%
% ctitle        cell(char)      Titel der einzelnen Diagramme, wenn
%                               gewünscht
% legtext         {iplot,igraf,legend_text}  andere Legendenbezeichnung
%                                           anstatt Signalname
% yminmax        {iplot,ymin,ymax}
%
% askforoverwrite   0/1         Soll beim Überschreiben des m-files gefragt
%                               werden? (default askforoverwrite=1)
% use_e_struct      0/1         Soll die e-Struktur verwendet werden 
%                               e.SigName.time und e.SigName.vec und
%                               e.SigName.unit (default use_e_struct = 0 )
%
% Ergebnis: Es wird ein m-File erstellt z.B. HAFplot_TestVal.m mit
%                                            HAFplot_TestVal(fig_title,d,u,q)
%
  okay = 1;
  errtext = '';
  
  name = 'dummy';
  pre_name = '';
  cplot    = {};
  ncplot   = 0;
  pplot    = {};
  npplot   = 0;
  nyfactor  = 0;
  cyfactor  = {};
  nyoffset  = 0;
  cyoffset  = {};
  ctitle   = {};
  nctitle  = 0;
  cyminmax = {};
  nyminmax = 0;
  cmarkertyp = {};
  nmarkertyp = 0;
  clinetyp = {};
  nlinetyp = 0;
  askforoverwrite = 1;
  use_e_struct    = 0;
  clegtext  = {};
  nclegtext = 0;
  i = 1;
  while( i+1 <= length(varargin) )

      switch lower(varargin{i})
          case {'name'}
            name = varargin{i+1};
          case {'cplot'}
            cplot{ncplot+1} = varargin{i+1};
            ncplot = length(cplot);
          case {'ctitle'}
            ctitle = varargin{i+1};
            nctitle = length(ctitle);
          case {'pre_name'}
            pre_name = varargin{i+1};
          case 'yfactor'
            cyfactor{nyfactor+1} = varargin{i+1};
            nyfactor = length(cyfactor);
          case 'yoffset'
            cyoffset{nyoffset+1} = varargin{i+1};
            nyoffset = length(cyoffset);
          case 'yminmax'
            cyminmax{nyminmax+1} = varargin{i+1};
            nyminmax = length(cyminmax);
          case 'markertyp'
            cmarkertyp{nmarkertyp+1} = varargin{i+1};
            nmarkertyp = length(cmarkertyp);
          case 'linetyp'
            clinetyp{nlinetyp+1} = varargin{i+1};
            nlinetyp = length(clinetyp);
          case 'askforoverwrite'
            askforoverwrite = varargin{i+1};
          case 'use_e_struct'
            use_e_struct = varargin{i+1};
          case 'legtext'
            clegtext{nclegtext+1} = varargin{i+1};
            nclegtext = nclegtext+1;
          case 'parken'
            pplot{npplot+1} = varargin{i+1};
          otherwise
            error('%s: Attribut <%s> nicht in der Liste vorhanden',mfilename,varargin{i});
      end
      i = i+2;
  end
  
  filename = [pre_name,name];
  % Filename
  s_file = str_get_pfe_f(filename);
  fullfilename  = fullfile(s_file.dir,[s_file.name,'.m']);
  filename = s_file.name;
  
  if( exist(fullfilename,'file') && askforoverwrite )
    s_frage.comment = sprintf('Soll das m-File: <%s> überschrieben werden?',filename);
    s_frage.def_value = 'j';
    flag = o_abfragen_jn_button_f(s_frage);
    if( ~flag )
      return;
      
    end
  end
  % Header bilden (cell-array)
  c = BuildPlotFile_template_start(filename,use_e_struct);
  
  % Auswertung über cplot
  for i=1:ncplot
    
    % iter-Plot anlegen
    cp = cplot{i};
    ncp = length(cp);
    
    % Title aus ctitle nehmen, wenn vorhanden
    if( i <= nctitle )
      ttit = ctitle{i};
    else
      ttit = '';
    end
    
    % Signalliste für unit auswerten
    %-------------------------------
    if( ncp )
      
      % erstes Signal
      csig = cp{1};
      
      ncsig = length(csig);
      % unit vorhanden
      if( ncsig > 1 )
        unit_same_name = csig{2};
      else
        unit_same_name = '';
      end
    else
      unit_same_name = '';
    end
    flag = 0;
    for j = 2:ncp
      csig = cp{j};
      ncsig = length(csig);
      if( ncsig > 1 )
        unit2 = csig{2};
      else
        unit2 = '';
      end
      if( ~strcmp(unit_same_name,unit2) )
        flag = 1;  % keine Übereinstimmung
      end
    end
    if( flag )
      unit_same_name = '';
    end
    %-----------------------------------
    
    % ymin/ymax auswerten
    [yminmaxflag,yminmax] = BuildPlotFileSucheYMinMax(cyminmax,nyminmax,i);
    
    c1 = BuildPlotFile_template_plot(i,ttit,unit_same_name,yminmaxflag,yminmax);
    c = cell_add(c,c1);

    
    % ncp-Signale schreiben
    %-----------------------------------
    for j = 1:ncp
      
      % Signal
      csig = cp{j};
      
      % Anzahl der Infos im Signal
      ncsig = length(csig);
      
      % Unit
      if( ncsig >= 2 && ~isempty(csig{2}))
        unit = csig{2};
      else
        unit = '';
      end
      
      % Linesize
      if( ncsig >= 3 && ~isempty(csig{3}) )
        if( csig{3} < 1.5 )
          linesize = 'line_size';
        elseif( csig{3} < 2.5 )
          linesize = 'line_size_1';
        else
          linesize = 'line_size_2';
        end
      else
        linesize = 'line_size_2';
      end
      
      % Farbe
      if( ncsig >= 4 && ~isempty(csig{4}))
        farbe = csig{4};
      else
        farbe = 'Mschwarz';
      end
      
      % x-Signal
      if( ncsig >= 5 && ~isempty(csig{5}))
        xname = csig{5};
      else
        xname = '';
      end
      
      % Unit x-Signal
      if( ncsig >= 6 && ~isempty(csig{6}))
        xunit = csig{6};
      else
        xunit = '';
      end
      
      % Type des Signals x-y-Plots
      if( ncsig >= 7 && ~isempty(csig{7}))
        xytype = csig{7};
        
        if( ~strcmpi(xytype,'cellfirst') )
          error('Error_%s: xytype = <%s> ist noch nicht programmiert',mfilename,xytype);
        end
      elseif( ~isempty(xname) )
        xytype = 'xy';
      else
        xytype = '';
      end

        
      [yfacflag,yfac]   = BuildPlotFileSucheYFac(cyfactor,nyfactor,i,j);
      [yoffsflag,yoffs] = BuildPlotFileSucheYOffs(cyoffset,nyoffset,i,j);
      [linetypflag,linetyp] = BuildPlotFileSucheLineType(clinetyp,nlinetyp,i,j);
      [markertypflag,markertyp] = BuildPlotFileSucheMarkerType(cmarkertyp,nmarkertyp,i,j);
      [legtextflag,legtext] = BuildPlotFileSucheLegText(clegtext,nclegtext,i,j);
      
      
          
      c1 = BuildPlotFile_template_plot_signal(csig{1},unit,flag,linesize,farbe,xname,xunit,xytype ...
                                             ,yfacflag,yfac,yoffsflag,yoffs ...
                                             ,linetypflag,linetyp,markertypflag,markertyp ...
                                             ,legtextflag,legtext,use_e_struct);
      c = cell_add(c,c1);
    end
  end
  
  c1 = BuildPlotFile_template_end(xytype,xunit);
  c = cell_add(c,c1);
  
  
  % cellarrays in File schreiben
  okay = write_ascii_file(fullfilename,c);
  
  if( ~okay )
    errtext = sprintf('Datei: %s konnte nicht geschrieben werden',fullfilename);
  end
  
end
function [yfacflag,yfac] = BuildPlotFileSucheYFac(cyfactor,nyfactor,iplot,igraf)

  yfacflag = 0;
  yfac     = 1.0;

  for i=1:nyfactor
    cyf = cyfactor{i};
    if( (cyf{1} == iplot) && (cyf{2} == igraf) )
      yfacflag = 1;
      yfac     = cyf{3};
      return
    end
  end
end
function [yoffsflag,yoffs] = BuildPlotFileSucheYOffs(cyoffset,nyoffset,iplot,igraf)

  yoffsflag = 0;
  yoffs     = 0.0;

  for i=1:nyoffset
    cyo = cyoffset{i};
    if( (cyo{1} == iplot) && (cyo{2} == igraf) )
      yoffsflag = 1;
      yoffs     = cyo{3};
      return
    end
  end
end
function [yminmaxflag,yminmax] = BuildPlotFileSucheYMinMax(cyminmax,nyminmax,iplot)

  yminmaxflag = 0;
  yminmax     = [];

  for i=1:nyminmax
    cymm = cyminmax{i};
    if( (cymm{1} == iplot) )
      yminmaxflag = 1;
      yminmax     = [cymm{2},cymm{3}];
      return
    end
  end
end
function [linetypflag,linetyp] = BuildPlotFileSucheLineType(clinetyp,nlinetyp,iplot,igraf)
  linetypflag = 0;
  linetyp     = '-';

  for i=1:nlinetyp
    cline = clinetyp{i};
    if( (cline{1} == iplot) && (cline{2} == igraf) )
      linetypflag = 1;
      linetyp     = cline{3};
      return
    end
  end
end
function [markertypflag,markertyp] = BuildPlotFileSucheMarkerType(cmarkertyp,nmarkertyp,iplot,igraf)
  markertypflag = 0;
  markertyp     = 'none';

  for i=1:nmarkertyp
    cmarker = cmarkertyp{i};
    if( (cmarker{1} == iplot) && (cmarker{2} == igraf) )
      markertypflag = 1;
      markertyp     = cmarker{3};
      return
    end
  end
end
function [legtextflag,legtext] = BuildPlotFileSucheLegText(clegtext,nclegtext,iplot,igraf)
  legtextflag = 0;
  legtext     = '';

  for i=1:nclegtext
    clt = clegtext{i};
    if( (clt{1} == iplot) && (clt{2} == igraf) )
      legtextflag = 1;
      legtext     = clt{3};
      return
    end
  end
end


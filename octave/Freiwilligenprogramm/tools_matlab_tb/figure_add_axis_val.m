function p = figure_add_axis_val(p,hfig,haxis,xvec,yvec,hline,ccolor,linestyle,marker,writeindex,yawvec,xfigure,yfigure)
%
% p = figure_add_axis_val(p,hfig,haxis,xvec,yvec)
% oder
% p = figure_add_axis_val(p,hfig,haxis)
%
% setzt für eine x-y-plotlinie horizontal/Vertikal die Achsenwert
%
% p = figure_add_axis_val(p,hfig,haxis,xvec,yvec,hline,ccolor)
%
% Wenn xvec und yvec cellarrays mit Vektoren sind
% wird bei entsprechendem Index die Vektoren gezeichnet
% mit hline mitübergeben, wenn schon gezeichnet wurde
%
% p = figure_add_axis_val(p,hfig,haxis,xvec,yvec,hline,ccolor,yawvec,xfigure,yfigure)
%
% Zeichnet eine Figure (xfigure,yfigure) zum jeweiligen Index mit
% Koordinaten xvec(index),yvec(index),yawvec(index)
%
%  okay = figure_show_at_index(p,index[,color])
%
%   p(i).hfig      handle figure
%   p(i).haxis     handle axis
%   p(i).xvec      x-Vektor oder cellarray
%   p(i).yvec      y-Vektor oder cellarray
%   p(i).hxline    anlegen;
%   p(i).hyline    anlegen;
%   p(i).yawvec    yaw-angle-Vektor [rad];
%   p(i).xfigure   Figur;
%   p(i).yfigure   ;
%       p(i).linestyle 'none','-', '..', ':', ...   nur p(i).type = 'v'
%       p(i).writeindex 0,1    nur p(i).type = 'v'
%       p(i).marker    'none','*', '+', '<', ...    nur p(i).type = 'v'

  if( ~exist('xvec','var') )
    xvec = [];
  end
  if( ~exist('yvec','var') )
    yvec = [];
  end
  if( ~exist('hline','var') )
    hline = [];
  end
  if( ~exist('ccolor','var') )
    ccolor = [];
  end
  if( ~exist('linestyle','var') )
    linestyle = '-';
  end
  if( ~exist('marker','var') )
    marker = 'none';
  end
  if( ~exist('writeindex','var') )
    writeindex = 0;
  end
  if( ~exist('yawvec','var') )
    yawvec = [];
  end
  if( ~exist('xfigure','var') )
    xfigure = [];
  end
  if( ~exist('yfigure','var') )
    yfigure = [];
  end
  
 
  for j = 1:length(haxis)
    
    i = length(p)+1;
    
    if( ~isempty(yawvec) && ~isempty(xfigure)  && ~isempty(yfigure))
      p(i).type  = 'f';
    elseif( iscell(xvec) )
      p(i).type  = 'v';
    else
      p(i).type  = 'i';
    end
  
    p(i).hfig  = hfig;
    p(i).haxis = haxis(j);
    p(i).hxline = [];
    p(i).hyline = [];
    p(i).xvec  = xvec;
    p(i).yvec  = yvec;
    p(i).hline = hline;
    p(i).color = ccolor;
    p(i).yawvec = yawvec;
    p(i).xfigure = xfigure;
    p(i).yfigure = yfigure;
    p(i).linestyle = linestyle;
    p(i).marker = marker;
    p(i).writeindex = writeindex;
    
  end 
end


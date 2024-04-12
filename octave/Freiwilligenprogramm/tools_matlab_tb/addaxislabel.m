function varargout = addaxislabel(varargin)
%ADDAXISLABEL adds axis labels to axes made with ADDAXIS.m
%
%  handle_to_text = addaxislabel(axis_number, label);
%
%  See also
%  ADDAXISPLOT, ADDAXIS, SPLOT 
  
  if isstr(varargin{1}), 
     axnum = varargin{2}; 
     label = varargin{1};
  else
     label = varargin{2};
     axnum = varargin{1};
  end
  i = 3;
  iv = 0;
  varargin1 = {};
  while( i < length(varargin) )
    if( strcmp(lower(varargin{i}),'fontsize') )
        iv = iv + 1;
        varargin1{iv} = 'FontSize';
        iv = iv + 1;
        varargin1{iv} = varargin{i+1};
    end
    i = i+2;
  end
  lvar1 = length(varargin1);
  
%  get current axis
  cah = gca;
%  axh = get(cah,'userdata');
  axh = getaddaxisdata(cah,'axisdata');
  
%  get axis handles
  axhand = cah;
  postot(1,:) = get(cah,'position');
  for I = 1:length(axh)
    axhand(I+1) = axh{I}(1);
    postot(I+1,:) = get(axhand(I+1),'position');
  end  

%  set current axis to the axis to be labeled
axes(axhand(axnum));
if( lvar1 > 0 )
    varargin2{1} = label;
    for i=1:lvar1
        varargin2{i+1} = varargin1{i};
    end
    htxt = ylabel(varargin2{:});
else
    htxt = ylabel(label);
end

set(htxt,'color',get(axhand(axnum),'ycolor'));

%  set current axis back to the main axis
axes(cah);

if nargout == 1
  varargout{1} = htxt;
end

function node = xml_struct_build_node(varargin)
%
% node = xml_struct_build_node('Name','abc','Attributes',attrib,'Data',data,'Children',childs);
% node = xml_struct_build_node('Name','abc','Attributes',attrib,'Data',data,'Children',childs ...
%                      ,'Name','def','Attributes',attrib2,'Data',data2,'Children',childs2);
%
% Buid Node-Struct (a child/children) with Name,Attributes,Data,Children,
% could be n nodes
% to buid Attributes (see xml_struct_build_attributes())
  node = [];
  cname   = {};
  cattrib = {};
  cdata   = {};
  cchilds = {};
  i = 1;
  while( i+1 <= length(varargin) )

      switch lower(varargin{i})
          case {'name'}
            cname = cell_add(cname,varargin{i+1});
          case {'attributes'}
            cattrib{length(cattrib)+1} = varargin{i+1};
          case {'data'}
            cdata = cell_add(cdata,varargin{i+1});
          case {'children'}
            cchilds{length(cchilds)+1} = varargin{i+1};
          otherwise
            error('%s: Attribut <%s> nicht in der Liste vorhanden',mfilename,varargin{i});
      end
      i = i+2;
  end
  
  n =length(cname);
  allocCell = cell(1, n);
  node = struct('Name', allocCell, 'Attributes', allocCell    ...
               ,'Data', allocCell, 'Children', allocCell);
  
  for i=1:n
    if( length(cattrib) >= i )
      attb = cattrib{i};
    else
      attb = [];
    end
    if( length(cdata) >= i )
      data = cdata{i};
    else
      data = '';
    end
    if( length(cchilds) >= i )
      childs = cchilds{i};
    else
      childs = '';
    end
    nodeStruct = struct('Name', cname{i},       ...
                        'Attributes', attb,  ...
                        'Data', data,    ...
                        'Children', childs);
    node(i)  = nodeStruct;
  end
end
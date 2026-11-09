function attrib = xml_struct_build_attributes(varargin)
%
% attrib = xml_struct_build_attributes('Name','abc','Value','zzz');
% attrib = xml_struct_build_attributes('Name','abc','Value','zzz','Name','def','Value','yyy');
%
% Buid Attributes-Struct with Name an Value (char), could be n attributes
% Use this to build node (see xml_struct_build_node())
  attrib = [];
  cname  = {};
  cvalue = {};
  i = 1;
  while( i+1 <= length(varargin) )

      switch lower(varargin{i})
          case {'name'}
            cname = cell_add(cname,varargin{i+1});
          case {'value'}
            cvalue = cell_add(cvalue,varargin{i+1});
          otherwise
            error('%s: Attribut <%s> nicht in der Liste vorhanden',mfilename,varargin{i});
      end
      i = i+2;
  end
  
  n =min(length(cname),length(cvalue));
  allocCell = cell(1, n);
  attrib = struct('Name', allocCell, 'Value', allocCell);
  
  for i=1:n
    attrib(i).Name  = cname{i};
    attrib(i).Value = cvalue{i};
  end
end
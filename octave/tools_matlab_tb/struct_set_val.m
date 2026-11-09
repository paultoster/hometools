function p = struct_set_val(p,cn,val,type)
%
% p = struct_set_val(p,cn,val)
% p = struct_set_val(p,cn,val,type)
% p = struct_set_val(p,name,val)
% p = struct_set_val(p,name,val,type)
%
% p     struct    Struktur
% cn    cell      Strukturhierachie mit Feldnamen z.B. {'abc','def'}
% name  char      einzelner Hierachiename zb. 'abc' 
% val   ?     Wert der für den namen eingesetzt wird 
% type       (default : 0)   0: val will be set allways
%                            1: value will only be set if value does not
%                               exist or is empty
%
% p = struct([]);
% d = 0.1;
% p = struct_set_val(p,{'gruppe','d'},d);
% oder
% p = struct_set_val(p,'gruppe.d',d);
% entspricht
% p.gruppe.d = 0.1
%
%                            

if( ~exist('type','var' ) )
  type = 0;
end
if( ischar(cn) )
    [cn,l] = str_split(cn,'.');
else
    l = length(cn);
end
if( l == 0 )
    p = val;
elseif( l == 1 )
    
    if( type == 0 )
      p = setfield(p,{1,1},cn{l},val);
    else
     if( ischar(val) )
       checktype = 'char';
     elseif( iscell(val) )
       checktype = 'cell';
     elseif( isnumeric(val) )
       checktype = 'num';
     elseif( isstruct(val) )
       checktype = 'struct';
     else
       checktype = 'any';
     end
       
     if( ~check_val_in_struct(p,cn{l},checktype,1) )
        p = setfield(p,{1,1},cn{l},val);
     end
    end
else
    
%    if( ~isfield(p,cn{1}) || ~struct_find_f(p,cn{1}) || ~isstruct(p.(cn{1})) )
     if(  ~struct_find_f(p,cn{1}) || ~isstruct(p.(cn{1})) )
                
        p = setfield(p,{1,1},cn{1},struct([]));        
    end
    
    cnn = cell_cut(cn,1);
    p.(cn{1}) = struct_set_val(p.(cn{1}),cnn,val,type);
end

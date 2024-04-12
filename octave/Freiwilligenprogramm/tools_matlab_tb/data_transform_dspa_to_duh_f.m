function  [okay,d,u,c_h] = data_transform_dspa_to_duh_f(dspa)                      

% Transformiert dspa-Datenformat in duh-Datenformat
                        
                 
okay = 1;
c_h = {};
% Prüfen ob dspa-Format stimmt                        
                        
% dspa-Datensatz muß eine Struktur sein und muß X und Y
% als Struktur besitzen, und Data muß darin als double enthalten sein
if( strcmp(class(dspa),'struct') ...
  & isfield(dspa,'X') & isfield(dspa,'Y') ...
  & strcmp(class(dspa.X),'struct') & strcmp(class(dspa.Y),'struct') ...
  & isfield(dspa.X(1),'Data') & strcmp(class(dspa.X(1).Data),'double') ...
  & isfield(dspa.Y(1),'Data') & strcmp(class(dspa.Y(1).Data),'double') ...
  )

    % X-Komponente
    var_name = '';
    if( isfield(dspa.X(1),'Name') )
        var_name = char(dspa.X(1).Name);
    end
    if( length(var_name) == 0 )
        var_name = 'x';
    end
    if( isfield(dspa.X(1),'Unit') )
        unit_name = char(dspa.X(1).Unit);
    else
        unit_name = '';
    end
    
    val = dspa.X(1).Data;
    
    % alles in Spaltenvektor
    [n,m] = size(val);
    if( m > n )
        val = val';
    end
    
    if( exist('d','var') )
        d = setfield(d,var_name,val);
    else
        d = struct(var_name,val);
    end
    if( exist('u','var') )
        u = setfield(u,var_name,unit_name);
    else
        u = struct(var_name,unit_name);
    end
    
    %Y-Komponente
    for i = 1:length(dspa.Y)
        % Y-Komponente
        var_name = '';
        if( isfield(dspa.Y(i),'Name') )
            var_name = char(dspa.Y(i).Name);
            var_name = data_transform_dspa_to_duh_name_bereinigen(var_name);
        else
            var_name = '';
        end
        if( length(var_name) == 0 )
            var_name = sprintf('y_%i',i);
        end
        
        if( isfield(dspa.Y(i),'Unit') )
            unit_name = char(dspa.Y(i).Unit);
        else
            unit_name = '';
        end
        
        val = double(dspa.Y(i).Data);
        
        % alles in Spaltenvektor
        [n,m] = size(val);
        if( m > n )
            val = val';
        end
%        fprintf('%s\n',var_name)
        if( var_name(1) >= 48 & var_name(1) <= 57 ) % Variablenname beginnt mit Ziffer, darf nicht sein
            
            var_name = ['b',var_name];
        end
        
        d = setfield(d,var_name,val);
        u = setfield(u,var_name,unit_name);
    end
    
    if( isfield(dspa,'Comment') )
        if( strcmp(class(dspa.Comment),'char') )
            c_h{1} = dspa.Comment;
        elseif( strcmp(class(dspa.Comment),'cell') )
            c_h = dspa.Comment;
        end
    end
    len = length(c_h);
    c_h{len+1} = [datestr(now),' read-dspa-data'];
else
    okay = 0;
end
                       
function var_name = data_transform_dspa_to_duh_name_bereinigen(var_name)

if( str_find_f(var_name,'"','vs') > 0 )
    
   c_dum = str_get_quot_f(var_name,'"','"');
   if( length(c_dum) > 0 )
       var_name = char(c_dum(length(c_dum)));
   else
       var_name = str_cut_f(var_name,'"');
   end
end

var_name = str_cut_f(var_name,'/');
var_name = str_cut_f(var_name,' ');
var_name = str_cut_ae_f(var_name,'_');

tname = var_name;
while( 1 )

    var_name = str_cut_ae_f(var_name,'[');
    var_name = str_cut_ae_f(var_name,']');
    var_name = str_cut_ae_f(var_name,'{');
    var_name = str_cut_ae_f(var_name,'}');
    var_name = str_cut_ae_f(var_name,'<');
    var_name = str_cut_ae_f(var_name,'>');
    var_name = str_cut_ae_f(var_name,',');
    var_name = str_cut_ae_f(var_name,';');

    var_name = str_cut_a_f(var_name,'_');

    if( strcmp(var_name,tname) )
        break;
    else
        tname = var_name;
    end
end

if( str_find_f(var_name,',','vs') > 0 | ...
    str_find_f(var_name,';','vs') > 0 ...
  )
    var_name = '';
end
% A = isstrprop(var_name, 'alpha');
% 
% if( sum(A) ~= length(var_name) )
%     
%     new_name = '';
%     for i=1:length(A)
%         if( A(i) )
%             new_name = [new_name,var_name(i)];
%         end
%     end
%     var_name = new_name;
% end

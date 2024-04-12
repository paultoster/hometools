% $JustDate:: 31.03.05  $, $Revision:: 1 $ $Author:: Admin     $
% $JustDate:: 31 $, $Revision:: 1 $ $Author:: Admin     $
function        dspa_data = conv_dia_to_dspa_f(d,u,xname,file,comment,prc_file)

% structure:
% dspa_data.X.Name string
% dspa_data.X.Type double
% dspa_data.X.Data double array
% dspa_data.X.Unit string
% i=1:length
% dspa_data.Y(i).Name string
% dspa_data.Y(i).Type double
% dspa_data.Y(i).Data double array
% dspa_data.Y(i).Unit string
% dspa_data.Y(i).Xindex double

% dspa_data.File string
% dspa_data.Comment string
% dspa_data.Prc_file string

dspa_data = {};


dnames  = fieldnames(d);
unames = fieldnames(u);
        
data_x_set = 0;
data_y_set = 0;

iY = 0;
for i=1:length(dnames)
    
    uname_found = 0;
            
   if( length(dnames{i}) > 0 )
                
       vec  = getfield(d,dnames{i});
       
       for j=1:length(unames)
           
           if( strcmp(dnames(i),unames(j)) )
               
                unit = getfield(u,unames{j});
                uname_found = 1;
                break;
           end
       end
       if( ~uname_found )
           unit = '-';
       end
       
       if( strcmp(dnames(i),xname) )
           
           dspa_data.X.Name = char(dnames(i));
           dspa_data.X.Type = 4;
           dspa_data.X.Data = vec';
           dspa_data.X.Unit = unit;
           
           data_x_set = 1;
       else
           
            iY = iY + 1;

            dspa_data.Y(iY).Name = char(dnames(i));
            dspa_data.Y(iY).Type = 5;
            dspa_data.Y(iY).Data = vec';
            dspa_data.Y(iY).Unit = unit;
           
            data_y_set = 1;
        end
    end
end

if( ~data_x_set & data_y_set )
    dspa_data.X.Name = 'x';
    dspa_data.X.Type = 4;
    dspa_data.X.Data = [1:1:length(dspa_data.Y(1).Data)];
    dspa_data.X.Unit = '-';
end


if( nargin >= 4 )
    
    dspa_data.File = file;
end
if( nargin >= 5 )
    
    dspa_data.Comment = comment;
end

if( nargin >= 6 )
    
    dspa_data.Prc_file = prc_file;
end
            


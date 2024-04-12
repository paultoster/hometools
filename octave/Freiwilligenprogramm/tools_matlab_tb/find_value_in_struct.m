function [flag,tt] =find_value_in_struct(s,val,tt)
%
% flag =find_value_in_struct(s,val)
% 
% Sucht Wert in der Struktur und Bring es an den Bildschirm
%
flag      = 0;
startflag = 0;
try
    if( ~isempty(s) )

        if( isstruct(s) )
            if( ~exist('tt','var') )
                tt        = 's';
                startflag = 1;
            end

            [n,m] = size(s);
            cnames = fieldnames(s);
            for i = 1:n
                for j=1:m

                    for ic=1:length(cnames)

                        item = s(i,j).(cnames{ic});

                        flag =find_value_in_struct(item,val,[tt,'(',num2str(i),',',num2str(j),').',cnames{ic}]);

                        if( flag )
                            return;
                        end
                    end
                end
            end
        elseif( iscell(s) )

            if( ~exist('tt','var') )
                tt        = 'c';
                startflag = 1;
            end

            [n,m] = size(s);

            for i = 1:n
                for j=1:m

                    item = s{i,j};

                    flag =find_value_in_struct(item,val,[tt,'{',num2str(i),',',num2str(j),'}']);

                    if( flag )
                        return;
                    end
                end
            end
        elseif( isnumeric(s) && isnumeric(val) )

            if( ~exist('tt','var') )
                tt        = 'val';
                startflag = 1;
            end

            [n,m] = size(s);

            for i = 1:n
                for j=1:m

                    item = s(i,j);

                    if( abs(item-val(1,1)) <= eps )
                        flag = 1;
                        fprintf('%s = %g\n',tt,item);
                        return;
                    end
                end
            end


        elseif( ischar(s) && ischar(val) )

            if( ~exist('tt','var') )
                tt        = 'string';
                startflag = 1;
            end

            [n,m] = size(s);

            for i = 1:n
                    item = s(i,:);

                    if( strcmp(item,val) )
                        flag = 1;
                        fprintf('%s = %s\n',tt,item);
                        return;
                    end
            end


        end    
    end
catch
    error('Fehler')
end
if( startflag )
    tt= 'not found';
end
    
                
    
    
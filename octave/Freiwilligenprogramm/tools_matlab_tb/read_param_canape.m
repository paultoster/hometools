function d = read_param_canape(param_datei);
%
% Einlesen Parameterdatei aus Canape Parameter in Struktur zusammengefaßt
%
d = [];
[fid,message]= fopen(param_datei,'r');

if( fid == -1 )
    fprintf('fopen mit %s hat Probleme !!!\n',param_datei)
    error(message)
end

ns = 0;
nz = 0;
name = '';

while( 1 )
    
    tline = fgetl(fid);
    if( ~ischar(tline) )
        break
    end
    
    tline = str_cut_ae_f(tline,' ');
    
    % Kommentar
    i = str_find_f(tline,';','vs');
    if( i == 1 )
        tline = '';
    elseif( i > 1 )
        tline = tline(1:i-1);
    end
    
    if(  (str_find_f(tline,'CANape','vs') ~= 1) ...
      && (str_find_f(tline,' ','vn') > 0) ...
      )
  
        % Keine Zustazinfos zum Vektor einlesen
        if( str_find_f(tline,'X:','vs') ~= 1 )
        
            % Wert lesen
            if(  str_find_f(tline,':','vs') == 1  && vek_flag )



                    % Zähler
                    if( is == 0 || iz >= nz )

                        is = is + 1;
                        if( is > ns )
                            vname = '';
                        end
                        iz = 0;
                    end
                    if( length(vname) > 0 )
                        % Wert
                        val = str2num(tline(2:length(tline)));

                        iz = iz + 1;

                        d.(vname)(iz,is) = val;
                    end
                      

            else % Variable lesen

                tline            = str_cut_ae_f(str_change_f(tline,'  ',' '),' ');
                [c_names,icount] = str_split(tline,' ');

                % Name
                %=====
                vname = str_change_f(c_names{1},'[','_');
                vname = str_change_f(vname,']','_');
                vname = str_change_f(vname,'.','_');
                vname = str_change_f(vname,'@','_');

                % Single/Vektor
                %==============
                if( icount == 2 ) %Vektor

                    vek_flag = 1;

                    %fprintf('%s\n',tline);
                    c_text = str_get_quot_f(c_names{2},',',']','i');
                    c_text = str_get_quot_f(c_text{1},'(',')','i');

                    [c_text,n] = str_split(c_text{1},',');

                    ns = str2num(c_text{1});
                    nz = str2num(c_text{2});

                    d.(vname) = zeros(nz,ns);

                    is = 0;
                    iz = 0;

                else
                    vek_flag = 0;

                    d.(vname) = str2num(c_names{icount});
                end
            end

        end
    end
    
end

fclose(fid);
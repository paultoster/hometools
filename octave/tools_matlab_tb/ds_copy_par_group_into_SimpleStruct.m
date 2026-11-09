function parout = ds_copy_par_group_into_SimpleStruct(par,group,parout)
%
% parout = ds_copy_par_group_into_SimpleStruct(par,group,[parout=struct([])])
%
% Kopiert eine Gruppe aus der Struktur par (in ds-Struktur beschrieben) 
% in parout als SimpleStruct.
%
if( ~exist('parout','var') )
    parout = [];
end
if( ~ischar(group) )
    error('Group <%s> muss ein string sein (char)',group);
end
[found,parf] = find_item_in_struct(par,group,1);

if( found )
    
    liste = fieldnames(parf.(group));
    for i=1:length(liste)
        
        if( isfield(parf.(group).(liste{i}),'t') )
            
            if( strcmp(parf.(group).(liste{i}).t,'single') )
                [okay,unit,fak,offset] = make_SI_unit(parf.(group).(liste{i}).u);
                if(okay)
                    parout.(group).(liste{i}) = parf.(group).(liste{i}).v*fak+offset;
                else
                    error('Die Einheit <%s> aus Variable <%s> konnte nicht in SI gewandelt werden' ...
                         ,parf.(group).(liste{i}).u,liste{i});
                end
            elseif( strcmp(parf.(group).(liste{i}).t,'string') )
                parout.(group).(liste{i}) = parf.(group).(liste{i}).v;
            elseif( strcmp(parf.(group).(liste{i}).t,'1dtable') )
                [okay,unit,fak,offset] = make_SI_unit(parf.(group).(liste{i}).xu);
                if(okay)
                    parout.(group).(parf.(group).(liste{i}).xn) = parf.(group).(liste{i}).xv*fak+offset;
                else
                    error('Die Einheit <%s> konnte nicht in SI gewandelt werden',parf.(group).(liste{i}).u);
                end
                [okay,unit,fak,offset] = make_SI_unit(parf.(group).(liste{i}).yu);
                if(okay)
                    parout.(group).(parf.(group).(liste{i}).yn) = parf.(group).(liste{i}).yv*fak+offset;
                else
                    error('Die Einheit <%s> konnte nicht in SI gewandelt werden',parf.(group).(liste{i}).u);
                end
            elseif( strcmp(parf.(group).(liste{i}).t,'2dtable') )
                [okay,unit,fak,offset] = make_SI_unit(parf.(group).(liste{i}).xu);
                if(okay)
                    parout.(group).(parf.(group).(liste{i}).xn) = parf.(group).(liste{i}).xv*fak+offset;
                else
                    error('Die Einheit <%s> konnte nicht in SI gewandelt werden',parf.(group).(liste{i}).u);
                end
                [okay,unit,fak,offset] = make_SI_unit(parf.(group).(liste{i}).yu);
                if(okay)
                    parout.(group).(parf.(group).(liste{i}).yn) = parf.(group).(liste{i}).yv*fak+offset;
                else
                    error('Die Einheit <%s> konnte nicht in SI gewandelt werden',parf.(group).(liste{i}).u);
                end
                [okay,unit,fak,offset] = make_SI_unit(parf.(group).(liste{i}).zu);
                if(okay)
                    parout.(group).(parf.(group).(liste{i}).zn) = parf.(group).(liste{i}).zm*fak+offset;
                else
                    error('Die Einheit <%s> konnte nicht in SI gewandelt werden',parf.(group).(liste{i}).u);
                end
            end
        end
    end
else
    error('Item <%s> in Struktur par nicht gefunden',group);
end
    
    


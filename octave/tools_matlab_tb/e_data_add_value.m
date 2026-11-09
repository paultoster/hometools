function e = e_data_add_value(e,signame,sigunit,sigcomment,sigtime,sigvalue,siglin)
%
% e = e_data_add_value(e,signame,sigunit,sigcomment,sigtime,value,siglin);
%
% Erweitert die e-Struktur um das signal zum einem Zeitpunkt
%
% e            e-Datenstruktur mit e.signame.time    Zeitvektor
%                                  e.signame.vec     Vektor oder cellaray
%                                                    mit Vektor zu jedem Zeitpunkt
%                                  e.signame.lin     Linear/constant bei
%                                                    Interpolation
%                                  e.signame.unit    Einheit
%                                  e.signame.comment Kommentar
%
% signame               char Signalname
% sigunit               char Einheit
% sigcomment            char Kommentar
% sigtime                  num           Zeitwert
% sigvalue                 num/cellarray Signalwert (kann auch cellarray sein)
% siglin                   soll linear behandelt werden

  if( ~exist('signame','var') || isempty(signame) )
    error('%s: ''signame muss'' angegeben werden',mfilename)
  end
  if( ~exist('sigunit','var')  )
    sigunit = '-';
  end
  if( ~exist('sigcomment','var') || isempty(sigcomment) )
    sigcomment = '';
  end
  if( ~exist('siglin','var') || isempty(siglin) )
    siglin = 0;
  end
  

  if( ~isfield(e,signame) || iscellstring(sigvalue) ) % neu anlegen
    if( isempty(e) )
      e = struct(signame,[]);
    else
      e.(signame) = [];
    end
    e.(signame).time    = sigtime;
    e.(signame).vec    = sigvalue;
    e.(signame).lin     = siglin;
    e.(signame).unit    = sigunit;
    e.(signame).comment = sigcomment;

  else 
    time = e.(signame).time;
    vec  = e.(signame).vec;
    [time,index] = vec_insert_value(time,sigtime,1);

    if( isnumeric(vec) )
      if( (length(sigvalue) > 1) || isempty(sigvalue) )
        for ii=1:length(vec)
          cvec{ii} = vec(ii);
        end
        vec = cell_insert(cvec,index,sigvalue);
      else
        vec = vec_insert_at_index(vec,sigvalue,index);
      end
    else
      vec = cell_insert(vec,index,sigvalue);
    end
    e.(signame).time = time;
    e.(signame).vec  = vec;
    e.(signame).lin  = siglin;
    
    if( ~isempty(sigunit) )
      e.(signame).unit    = sigunit;
    end
    if( ~isempty(sigcomment) )
      e.(signame).comment    = sigcomment;
    end
      
  end
end
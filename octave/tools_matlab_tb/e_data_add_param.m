function e = e_data_add_param(e,paramname,paramvalue,paramunit,paramcomment)
%
% e =e_data_add_param(e,paramname,paramvalue,paramunit,paramcomment);
%
% Erweitert die e-Struktur um das paramnal zum einem Zeitpunkt
%
% e            e-Datenstruktur mit e.paramname.param     Wert oder Vektor
%                                                        des Parameters
%                                  e.paramname.unit      Einheit
%                                  e.paramname.comment   Kommentar
%
% paramname               char Signalname
% paramunit               char Einheit
% paramcomment            char Kommentar

  if( ~exist('paramname','var') || isempty(paramname) )
    error('%s: ''paramname muss'' angegeben werden',mfilename)
  end
  if( ~exist('paramunit','var') || isempty(paramunit) )
    paramunit = '-';
  end
  if( ~exist('paramcomment','var') || isempty(paramcomment) )
    paramcomment = '';
  end
  

  if( ~isfield(e,paramname) ) % neu anlegen
    if( isempty(e) )
      e = struct(paramname,[]);
    else
      e.(paramname) = [];
    end
    e.(paramname).param   = paramvalue;
    e.(paramname).unit    = paramunit;
    e.(paramname).comment = paramcomment;

  else 
    
    
    e.(paramname).param   = paramvalue;
    e.(paramname).unit    = paramunit;
    e.(paramname).comment = paramcomment;
    
      
  end
end
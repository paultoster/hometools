function name_list = e_data_search_signal(e,signame,fullname)
%
% name_list = e_data_search_signal(e,signame,fullname)
% name_list = e_data_search_signal(e,signame)
%
% sucht in e-Struktur nach signame 
%
% e            e-Datenstruktur mit e.signame.time    Zeitvektor
%                                  e.signame.vec     Vektor oder cellaray
%                                                    mit Vektor zu jedem Zeitpunkt
%                                  e.signame.lin     Linear/constant bei
%                                                    Interpolation
%                                  e.signame.unit    Einheit
%                                  e.signame.comment Kommentar
%
% signame               Signalname oder Teile vom Signalname
% fullname              [0,1]  Soll der volle Name gesucht werden (default
% 0)

  if( ~exist('signame','var') || isempty(signame) )
    error('%s: ''signame muss'' angegeben werden',mfilename)
  end
  if( ~exist('e','var') || isempty(e) )
     error('%s: ''e'' muss angegeben werden',mfilename)
  end
  if( ~exist('fullname','var') || isempty(fullname) )
    fullname = 0;
  end

  
  c_names = fieldnames(e);
  if( fullname )
   iselection  = cell_find_f(c_names,signame,'vl');
  else
   iselection  = cell_find_f(c_names,signame,'nl');
  end
  
  name_list = cell_get_icell_selection(c_names,iselection);
end
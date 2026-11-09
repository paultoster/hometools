function S = d_data_find_situation(d,sit)
%
% Suche in dir_path nach mat-Dateien in duh-Format
% und suche die Situation wie in sit-Struktur beschrieben
% sit(j).signame{i}        char        Signalname
% sit(j).vorschrift{i}     char        '>>' Vektorwert wird von kleiner zu größer gleich dem Wert
%                                   '<<' Vektorwert wird von größer zu kleiner gleich dem Wert
% sit(j).wert{i}           num         Vergleichswert
% sit(j).richtung{i}       char        'v' vorwärts
%                                   'r' rückwärts
% sit(j).toleranz{i}       num         Toleranz
%
% Variation über i ist eine und-Bedingung
% Variation über j ist eine oder-Bedingung
%
% Ausgabe
% S = sit;
% S.index_liste         num         Index-Liste mit Start
% z.B.
%   sit.signame    = {'SALaLoIqf2_TypeLeft','SALaLoIqf2_TypeLeft'};
%   sit.vorschrift = {'>>','<'};
%   sit.wert       = {0.5,1.5};
%   S = d_data_find_situation(d(i),sit);
%
  S = sit;
  if( ~isfield(sit,'signame') )
    error('sit.signame nicht definiert')
  end
  if( ~isfield(sit,'vorschrift') )
    error('sit.vorschrift ''>>'', ''<<'' nicht definiert')
  end
  n = length(sit);
  index_liste = [];
  for i=1:n
    index_l1 = d_data_find_situation_1(d,sit(i));
    for j=1:length(index_l1)
      flag = suche_wert_in_vek(index_liste,index_l1(j) ,0.1);
      if( ~flag )
        index_liste = [index_liste,index_l1(j)];
      end
    end
  end
  S.index_liste = index_liste;
end
function index_liste = d_data_find_situation_1(d,sit)

  n = length(sit.signame);
  if( ~isfield(sit,'wert') )
    sit.wert = num2cell(zeros(1,n));
  end
  if( ~isfield(sit,'richtung') )
    sit.richtung = cell(1,n);
    for i=1:n
      sit.richtung{i} = 'v';
    end
  end
  if( ~isfield(sit,'toleranz') )
    sit.toleranz = num2cell(ones(1,n)*1e-6);
  end
  
  
  % Erste Bedingung
  %================
  flag        = 1;
  start_index = 1;
  index_liste = [];
  while( flag )

    index = suche_index(d.(sit.signame{1}),sit.wert{1},sit.vorschrift{1},sit.richtung{1},sit.toleranz{1},start_index);

    if( index > 0 )
      index_liste = [index_liste,index];
      start_index = index;
    else
      flag = 0;
    end

  end   

  % Verknüpft mit den weiteren Bedingungen
  %=======================================
  for i = 2:length(sit.signame)
    
    index_liste_neu =  [];
    for j=1:length(index_liste)
      
      if( ~strcmp(sit.vorschrift{i},'>>') && ~strcmp(sit.vorschrift{i},'<<') )
        index = suche_index(d.(sit.signame{i}),sit.wert{i},sit.vorschrift{i},sit.richtung{i},sit.toleranz{i},index_liste(j));
      else
        error('Verknüpfung mit ''>>'' oder ''<<'' geht so noch nicht')
      end
      
      if( index == index_liste(j) )
        index_liste_neu = [index_liste_neu,index];
      end
    end
    index_liste = index_liste_neu;
  end
end
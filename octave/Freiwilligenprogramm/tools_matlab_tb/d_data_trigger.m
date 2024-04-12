function   d = d_data_trigger(d,signal_name,schwelle,vorschrift,vorlaufzeit)
%
% d = d_data_trigger(d,signal_name,schwelle,vorschrift,vorlaufzeit)
%
% d           Data-struktur mit äquidistanten Vektoren und erster Vektor ist Zeit
%             d.time
%             d.F
%             ...
% signal_name zu triggerndes Signal
% schwelle    zu triggernde Schwelle
% vorschrift   '>='          Wenn Signal größer gleich wird(default)
%              '>','<','<='  größer/kleiner/kleiner gleich
%              '=='          gleich innerhalb der Toleranz
%              '==='         nächster Index, es wird der Index mit einem Rest bestimmt z.B index=10.3)
%              '===='        (Index mit dem nächsten Wert)
%              '>>'          vektor wird von kleiner zu größer als Wert
%              '<<'          vektor wird größer zu kleiner als Wert
% vorlaufzeit  Vorlaufzeit zum Abschneiden
% 

  c_names = fieldnames(d);
  if( isempty(cell_find_f(c_names,signal_name,'f')) )
    error('Der Signalname <%s> kann in d nicht gefunden werden!!!');
  end
  nd      = length(d);
  
  for id=1:nd
    
     dt = mean(diff(d(id).time));
     n  = length(d(id).time);
     index = suche_index(d(id).(signal_name),schwelle,vorschrift,'v');
     if( index == 0 )
       warning('Die Schwelle in der %i. Messung kann nicht erreicht werden',id);
     else
       index = min(n-1,max(1,index - vorlaufzeit/dt));
     
       d(id) = d_data_reduce_by_index(d(id),index,n,1);
     end
  end
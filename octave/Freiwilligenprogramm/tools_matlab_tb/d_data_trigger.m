function   d = d_data_trigger(d,signal_name,schwelle,vorschrift,vorlaufzeit)
%
% d = d_data_trigger(d,signal_name,schwelle,vorschrift,vorlaufzeit)
%
% d           Data-struktur mit �quidistanten Vektoren und erster Vektor ist Zeit
%             d.time
%             d.F
%             ...
% signal_name zu triggerndes Signal
% schwelle    zu triggernde Schwelle
% vorschrift   '>='          Wenn Signal gr��er gleich wird(default)
%              '>','<','<='  gr��er/kleiner/kleiner gleich
%              '=='          gleich innerhalb der Toleranz
%              '==='         n�chster Index, es wird der Index mit einem Rest bestimmt z.B index=10.3)
%              '===='        (Index mit dem n�chsten Wert)
%              '>>'          vektor wird von kleiner zu gr��er als Wert
%              '<<'          vektor wird gr��er zu kleiner als Wert
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
function ee  = e_data_wandle_mit_Ssig(e,Ssig,type)
%
% e  = e_data_wandle_mit_Ssig(e,Ssig,type)
%
% Bearbeitet e-struktur mit Ssig-Struktur
%
% e      e-Struktur mit e.sig_name1.time (Zeitvektor) und
%                       e.sig_name1.vec  (Signalvektor)
% Ssig   Ssig-Struktur zur bearbeitung der Signale
%
%   Ssig(i).name_in      = 'signal name';
%   Ssig(i).unit_in      = 'dbc unit';              (default '')
%   Ssig(i).lin_in       = 0/1;                     (default 0)
%   Ssig(i).name_sign_in = 'signal name for sign';  (default '')
%   Ssig(i).name_out     = 'output signal name';    (default name_in)
%   Ssig(i).unit_out     = 'output unit';           (default 'unit_in')
%   Ssig(i).comment      = 'description';           (default '')
%
% type                    0:   alle Signale von e (Eingang werden
%                              verwendet, wenn in Ssig vorhanden dann
%                              bearbeiten)
%                         1:   nur Signale aus Ssig werden verwendet
%
%                        +10:  Zeit wird mit kleinsetr Zeit genullt
  ee = struct;

  if( type > 9.99); time0flag = 1;
  else              time0flag = 0;
  end
  a = mod(type,10);
  if( a < 0.5 ),    useallflag = 1;
  else              useallflag = 0;
  end
    
  
  % Namen der e-Struktur
  c_name = fieldnames(e);
  n      = length(c_name);

  if( ~isempty(Ssig) )
    % Länge der SSig-Struktur
    Ssig = proofSsig(Ssig);
    ns     = length(Ssig);
  else
    ns = 0;
  end
    
  for i=1:n
    
    % Signal in Ssig-Strukturliste suchen
    jsig = 0;
    for j=1:ns
      if( strcmp(c_name{i},Ssig(j).name_in) )
        jsig = j;
        break;
      end
    end
        
    if( useallflag || (~useallflag && jsig > 0 ) )
      % NAme
      if( jsig )
        name_in  = c_name{i};
        name_out = Ssig(jsig).name_out;
      else
        name_in  = c_name{i};
        name_out = c_name{i};
      end
      % Kommentar
      if( jsig )
        comment = Ssig(jsig).comment;
        if( isempty(comment) && isfield(e.(c_name{i}),'comment') )
          comment = e.(c_name{i}).comment;
        end
      else
        if( isfield(e.(c_name{i}),'comment') )
          comment = e.(c_name{i}).comment;
        else
          comment = '';
        end
      end
      % linearisieren
      if( jsig )        
        lin_in = Ssig(jsig).lin_in;
      else
        if( isfield(e.(c_name{i}),'lin') )
          lin_in = e.(c_name{i}).lin;
        else
          lin_in = 0;
        end
      end
      % Factor und Offset für Einheitenäanderung
      %-----------------------------------------
      if( ~isempty(e.(c_name{i}).unit) )
        unit_in  = e.(c_name{i}).unit;
      else
        if( jsig )
          unit_in  = Ssig(jsig).unit_in;
        else
          unit_in  = '-';
        end
      end
      if( isempty(unit_in ) )
        unit_in = '-';
      end
      if( jsig )
        if( strcmp(Ssig(jsig).unit_out,'unit_in') )
          unit_out = unit_in;
        elseif( isempty(Ssig(jsig).unit_out) )
          unit_out = unit_in;
        else
          unit_out = Ssig(jsig).unit_out;
        end
      else
        unit_out = unit_in;
      end

      [fac,offset,errtext] = get_unit_convert_fac_offset(unit_in,unit_out);

      if( ~isempty(errtext) )
        error('Fehler bei unit-convert in Signal <%s> \n%s',c_name{i},errtext)
      end

      % pause(1.0);        
      ee.(name_out).time    = e.(c_name{i}).time;
      ee.(name_out).vec     = e.(c_name{i}).vec* fac + offset;
      ee.(name_out).unit    = unit_out;
      ee.(name_out).comment = comment;
      ee.(name_out).lin     = lin_in;
    end
  end
  
  if( time0flag )
    
    % Namen der e-Struktur
    c_name = fieldnames(ee);
    n      = length(c_name);
    % Zeit muss genullt werden, geht nur mit erstem Wert
    time0 = 1e39;
    for i=1:n
      time0 = min(time0,min(ee.(c_name{i}).time));
    end
    for i=1:n
      ee.(c_name{i}).time = ee.(c_name{i}).time - time0;
    end
  end
end

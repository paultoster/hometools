function [okay,e] = can_asc_read_and_filter(mess_file,dbcfile,channel,Ssig)
%
%  [e] = iqf_read_can_and_filter(mess_file,dbcfile,channel,Ssig)
%
%  mess_file     CAN-asc-File
%  channel       1,2,3,...
%  Ssig          Signalstruktur mit
%                     q.Ssig(i).name_meas = 'VehSpd';
%                     q.Ssig(i).name_out  = 'VehSpd';
%                     q.Ssig(i).unit      = 'km/h';
%                     q.Ssig(i).lin       = 0;
%                     q.Ssig(i).comment   = 'Fahrzeuggeschwindigkeit';
%
%  e - CAN-strukur mit Zeitstempel
    
% Daten einlesen
%-------------------------
%
  
  nsig = length(Ssig);
  Ssig = proofSsig(Ssig);
  
  % Signalliste
  %============ 
  c_signame = cell(nsig,1);
  for i=1:nsig
    c_signame{i} = Ssig(i).name_in;
  end
  tic
  fprintf('CAN-Ascii-Datei: <%s>\n',mess_file);
  fprintf('Dbc-Datei (channel %i): <%s>\n',channel,dbcfile);
 
  % CAn-Messung einlesen und in gemeinsame Struktur bringen
  %--------------------------------------------------------
  [okay,e]  = read_can_ascii(mess_file,dbcfile,channel,c_signame);
  
  if( ~okay || isempty(e) )
    warning('can_asc_read_and_filter: Datei: <%s> enthält keine Daten\ndbc-File: %s\nchannel: %i\n',mess_file,dbcfile,channel);
  else

    % Vorzeichen setzen nach VW-Konvention
    %-------------------------------------
    sign_liste = {};
    for i=1:nsig
      if( ~isempty(Ssig(i).name_sign_in) )  
        sign_liste{length(sign_liste)+1} = {Ssig(i).name_in,Ssig(i).name_sign_in};
      end
    end
    e = can_asc_read_and_filter_sign(e,sign_liste);

    % read
    %-------------------------------------
    [e]  = can_asc_read_and_filter_wand_e(e,Ssig);

%     % Daten beschneiden, wenn gewünscht tstart, tend
%     %-----------------------------------------------
%     d = can_asc_read_and_filter_cut_time(d,tstart,tend);
  end  
  toc
end
function e = can_asc_read_and_filter_sign(e,sign_liste)

  for i=1:length(sign_liste)
    name_m = sign_liste{i}{1};
    name_s = sign_liste{i}{2};
    
    if( isfield(e,name_m) && isfield(e,name_s) )
      
      for j=1:min(length(e.(name_m).time),length(e.(name_s).time))
        
        if( e.(name_s).vec(j) > 0.5 )
          e.(name_m).vec(j) = e.(name_m).vec(j)*(-1.);
        end
      end
    end
  end
end
function ee  = can_asc_read_and_filter_wand_e(e,Ssig)

  ee = struct;

  % Namen der e-Struktur
  c_name = fieldnames(e);
  n      = length(c_name);

  % Länge der SSig-Struktur
  ns     = length(Ssig);
  
  % Zeit muss genullt werden, geht nur mit erstem Wert
  time0 = 1e39;
  for i=1:n
    time0 = min(time0,min(e.(c_name{i}).time));
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
    
%     if( strcmp('ST_DRVDIR_DVCH',Ssig(jsig).name_in) )
%        aaa= 0;
%     end
    
        
    
    % Factor und Offset für Einheitenäanderung
    %-----------------------------------------
    if( ~isempty(e.(c_name{i}).unit) )
      unit_in  = e.(c_name{i}).unit;
    else
      unit_in  = Ssig(jsig).unit_in;
    end
    if( isempty(unit_in ) )
      unit_in = '-';
    end
    if( strcmp(Ssig(jsig).unit_out,'unit_in') )
      Ssig(jsig).unit_out = unit_in;
    elseif( isempty(Ssig(jsig).unit_out) )
      Ssig(jsig).unit_out = '-';
    end
    
    [fac,offset,errtext] = get_unit_convert_fac_offset(unit_in,Ssig(jsig).unit_out);
    
    if( ~isempty(errtext) )
      error('Fehler bei unit-convert in Signal <%s> \n%s',c_name{i},errtext)
    end

    % pause(1.0);   
    ee.(Ssig(jsig).name_out).time    = e.(c_name{i}).time - time0;
    ee.(Ssig(jsig).name_out).vec     = e.(c_name{i}).vec* fac + offset;
    ee.(Ssig(jsig).name_out).unit    = Ssig(jsig).unit_out;
    ee.(Ssig(jsig).name_out).comment = Ssig(jsig).comment;
    ee.(Ssig(jsig).name_out).lin     = Ssig(jsig).lin_in;
  end
end
function d = can_asc_read_and_filter_cut_time(d,tstart,tend)

  if( tstart >= 0.0 && tend < 0.0 )
      tend = d.time(length(d.time));
  elseif(  tend >= 0.0  && tstart < 0.0 )
      tstart = d.time(1);
  end
  if( tstart >= 0.0 && tend >= 0.0 )            
      istart=suche_index(d.time,q.tstart);
      iend=suche_index(time,tend);

      if( istart >= 0 && iend >= 0 && iend >= istart)
          fields = fieldnames(d);

          for i = 1:length(fields)
              if( length(d.(fields{i})) >= iend )
                  d.(fields{i}) = d.(fields{i})(istart:iend);
              end
          end
      end
  end
end




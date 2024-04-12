function [d,u,c,h] = read_cm_erg_and_filter(mess_file,q)
%
%  [d,u,c] = iqf_read_can_and_filter(mess_file,q)
%  d -Datenstruktur
%  u - Einheitenstruktur
%  c - Kommentarstruktur
% Daten einlesen
% q.index_start = 1   Index Start
% q.index_end = -1    Index Start
% q.tstart = -1.;     startzeit (default -1.)
% q.tend = -1.;       endzeit (default -1.)
% q.zero_time = 1;    Zeit nullen 
%
% q.delta_t = 0.01;   Zeitschritt
%
% q.Ssig              Signalliste mit
%   Ssig(i).name_in        Name in der CAN-Messung dbc-File
%   Ssig(i).unit_in        Einheit Eingang
%                     (VW-Konvention)
%   Ssig(i).lin_in         Linearisierungsflag
%   Ssig(i).name_out       Ausgabename
%   Ssig(i).unit_out       Einheit Ausgabe
%   Ssig(i).comment        Kommentar
%
%-------------------------
%
  % Ausschnitt bearbeiten
  %----------------------
  if( ~isfield(q,'index_start') )
    q.index_start = 1;
  end
  if( ~isfield(q,'index_end') )
    q.index_end   = -1.;
  end
  if( ~isfield(q,'tstart') )
    q.tstart = -1.;
  end
  if( ~isfield(q,'tend') )
    q.tend   = -1.;
  end
  if( ~isfield(q,'zero_time') )
    q.zero_time   = 1;
  end
  %  Zeit bei null beginnen lassen
  
  if( ~isfield(q,'zero_time') )
    q.zero_time = 1;
  end
  
  % Zeitschritt
  %------------
  if( ~isfield(q,'delta_t') )
    q.delta_t = 0.01;
  end
  
  % Ssig (wird nicht mehr benutzt)
  if( ~isfield(q,'Ssig') || isempty(q.Ssig) )
      q.Ssig = [];
  end
  
  % Signalliste
  %============ 
%   c_signame = cell(nsig,1);
%   lin_liste = zeros(nsig,1);
%   for i=1:nsig
%     c_signame{i} = q.Ssig(i).name_in;
%     lin_liste(i) = q.Ssig(i).lin_in;
%   end
  tic
  [d,u,h,okay] =ccmread('erg_file',mess_file);
  
  
  if( ~okay )
  
    warning('iqf_read_ipg_and_filt: Datei: <%s> enthält keine Daten',mess_file);
    d = [];
    u = [];
    c = [];
  else

    d = d_data_set_nan_to_zero(d);
    
    % d erstellen
    %-------------------------------------
    [d,u,c]  = read_cm_erg_and_filter_wand(d,u,q);

    % bekannte Signalnamen einführen
    %----------------------------------------------
    [d,u,c] = d_data_add_known_name_signals(d,u,c);


    % Daten beschneiden, wenn gewünscht tstart, tend
    %-----------------------------------------------
    d = read_cm_erg_and_filter_cut_time(d,q);
    
  end
  toc
end
function e = iqf_read_can_and_filter_sign(e,sign_liste)

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
function [d,u,c]  = read_cm_erg_and_filter_wand(de,ue,q)

  d = struct;
  u = struct;
  c = struct;

  % Namen der e-Struktur
  c_name = fieldnames(de);
  n      = length(c_name);

  % Länge der SSig-Struktur
  ns     = length(q.Ssig);
  
  % Anfangszeit t0
  t0 = 1e300;
  for i=1:n
    t0 = min(t0,de.time(1));
  end
  
  % Endzeit t1
  t1 = 0;
  for i=1:n
    t1 = max(t1,max(de.time));
  end

  % Zeitvektor
  d.time = [t0:q.delta_t:t1]';
  nt     = length(d.time);
  u.time = 's';
  
  if( ns == 0 )
      for i=1:n
          % Einheit
          %-----------------------------------------
          if( ~strcmp(c_name{i},'time') )
              u.(c_name{i})=ue.(c_name{i});

              c.(c_name{i}) = '';
              d.(c_name{i}) = interp1(de.time,de.(c_name{i}),d.time,'linear');

          end
      end  
      
  else 
      for i=1:n

        % Signal in Ssig-Strukturliste suchen
        jsig = 0;
        for j=1:ns

          if( strcmp(c_name{i},q.Ssig(j).name_in) )
            jsig = j;
            break;
          end
        end
    %     if( strcmp(c_name{i},'ContiUser_LinQfOut_IQF1_RefPriority') )
    %       st = 0;
    %     end

        if( jsig )
          % pause(1.0);
          % Factor und Offset für Einheitenäanderung
          %-----------------------------------------
          if( ~isempty(ue.(c_name{i})) )
            unit_in  = ue.(c_name{i});
          else
            unit_in  = q.Ssig(j).unit_in;
          end
          try
            [fac,offset,errtext] = get_unit_convert_fac_offset(unit_in,q.Ssig(jsig).unit_out);
          catch
            fac = 1;
            offset = 0;
            warning('%s -> %s ; Einheit <%s> konnte nicht in <%s> gewandelt werden.',q.Ssig(jsig).name_in,q.Ssig(jsig).name_out,unit_in,q.Ssig(jsig).unit_out)
          end
          if( ~isempty(errtext) )
            error('Fehler bei unit-convert in Signal <%s> \n%s',c_name{i},errtext)
          end

          if( q.Ssig(jsig).lin_in )

            name     = q.Ssig(j).name_out;

            if(  ~isa(de.(c_name{i}),'double') ...
              && ~isa(de.(c_name{i}),'float') ...
              && ~isa(de.(c_name{i}),'single') ...
              )

              if(  isa(de.(c_name{i}),'numeric') )
                 de.(c_name{i}) = double(de.(c_name{i}));
              end
            end

            try
             if( max(isnan(de.(c_name{i}))) > 0 )
               a = 0;
             end
             d.(name) = interp1(de.time,de.(c_name{i}),d.time,'linear');
             d.(name) =  d.(name)* fac + offset;
            catch
              error('interp1');
            end

            % Einheit
            u.(name) = q.Ssig(jsig).unit_out;

            % Comment
            c.(c_name{i}) = q.Ssig(j).comment;

          else
            name = q.Ssig(j).name_out;
            try
              d.(name) = interp1_const(de.time,de.(c_name{i}),d.time);
              d.(name) =  d.(name)* fac + offset;
            catch
              error('interp1_const');
            end
            % Einheit
            u.(name) = q.Ssig(jsig).unit_out;

            % Comment
            c.(c_name{i}) = q.Ssig(j).comment;
          end

        end

      end  
  end
  if( q.zero_time )
    d.time = d.time - d.time(1);
  end
end
function d = read_cm_erg_and_filter_cut_time(d,q)

  % Zuerst Index
  index_start = 1;
  index_end   = length(d.time);
  flag        = 0;
  if( q.index_start > 0 )
    index_start = max(index_start,q.index_start);
    flag        = 1;
  end
  if( q.index_end > 0 )
    index_end = min(index_end,q.index_end);
    flag      = 1;
  end
  if( q.tstart >= 0.0 )
    index_start = max(index_start,suche_index(d.time,q.tstart));
    flag        = 1;
  end
  if( q.tend >= 0.0 )
    index_end = min(index_end,suche_index(d.time,q.tstart));
    flag      = 1;
  end
  if( flag )            
      if( index_start > 0 && index_end > 0 && index_end >= index_start )
          fields = fieldnames(d);

          for i = 1:length(fields)
              if( length(d.(fields{i})) >= index_end )
                  d.(fields{i}) = d.(fields{i})(index_start:index_end);
              end
          end
          if( q.zero_time )
            d.time = d.time - d.time(1);
          end
      end
  end
end



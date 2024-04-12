function index = suche_index(vek,wert,vorschrift,richtung,toleranz,start_index,find_all)
%
% index = suche_index(vek,wert,vorschrift,richtung,toleranz,start_index,find_all)
% Sucht im Vektor vek  nach der Vorschrift in der Richtung vorwärts oder rückwärts
% nach dem passenden Index. Kein Index gefunden bedeutet index = 0;
% =========================================================================
% index = suche_index(vek[,wert,vorschrift,richtung,toleranz,start_index,find_all])
% vek          Vektor
% wert         Wert auf den verglichen wird (default 0)
% vorschrift   '>='          Wenn Signal größer gleich wird(default)
%              '>','<','<='  größer/kleiner/kleiner gleich
%              '=='          gleich innerhalb der Toleranz
%              '==='         nächster Index, es wird der Index mit einem Rest bestimmt z.B index=10.3)
%              '===='        (Index mit dem nächsten Wert)
%              '>>'          vektor wird von kleiner zu größer als Wert
%              '<<'          vektor wird größer zu kleiner als Wert
% richtung     'v' vorwärts
%              'r' rückwerts
% toleranz     Toleranz, wenn == verwendet (default 1e-3)
% start_index  Start index zum suchen (default 1 wenn v, length(vek) wennr)
% find_all     findet alle werte zu dieser Bedingung index ist dann ein
%              vektor (default 0)
% =========================================================================

if nargin < 1
   error('such_index_Error: Zuwenig Argumente min 1')
elseif nargin == 1
   wert     = 0;
   vorschrift = '>=';
   richtung = 'v';
   toleranz = 1e-3;
   start_index  = 1;
   find_all     = 0;
elseif nargin == 2
   vorschrift = '>=';
   richtung = 'v';
   toleranz = 1e-3;
   start_index  = 1;
   find_all     = 0;
elseif nargin == 3
   richtung = 'v';
   toleranz = 1e-3;
   start_index  = 1;
   find_all     = 0;
elseif nargin == 4
   toleranz = 1e-3;
   if strncmp(richtung,'v',1) 
       start_index  = 1;
   else
       start_index = length(vek);
   end
   find_all     = 0;
elseif nargin == 5
   if strncmp(richtung,'v',1) 
       start_index  = 1;
   else
       start_index = length(vek);
   end
   find_all     = 0;
elseif nargin == 6
   find_all     = 0;
end

if( start_index < 1 )
  start_index = 1;
end

if strncmp(richtung,'v',1) || strncmp(richtung,'V',1)
    step = 1;
    end_index = length(vek);
else
    step = -1;
    end_index = 1;
end

index = cell(size(wert));
n     = length(wert);
toleranz = abs(toleranz);

for i=1:n
  index{i} = [];
end

if strncmp(vorschrift,'>>',2)
  
  for ii = 1:n
    vek0 = vek(start_index);
    for i=start_index+step:step:end_index,
        if( (vek(i) >= wert(ii)) && (vek0 < wert(ii)) )
            index{ii} = [index{ii};i];
            if( ~find_all )
              break
            end
        end
        vek0 = vek(i);
    end
  end
elseif strncmp(vorschrift,'<<',2)
  for ii = 1:n
    vek0 = vek(start_index);
    for i=start_index+step:step:end_index,
        if( (vek(i) <= wert(ii)) && (vek0 > wert(ii)) )
            index{ii} = [index{ii};i];
            if( ~find_all )
              break
            end
        end
        vek0 = vek(i);
    end
  end
elseif strncmp(vorschrift,'>=',2) 
  for ii = 1:n
    for i=start_index:step:end_index,
        if( vek(i) >= wert(ii) )
          index{ii} = [index{ii};i];
          if( ~find_all )
            break
          end
        end
    end
  end
elseif strncmp(vorschrift,'>',1)
  for ii = 1:n
    for i=start_index:step:end_index,
        if( vek(i) > wert(ii) )
          index{ii} = [index{ii};i];
          if( ~find_all )
            break
          end
        end
    end
  end
elseif strncmp(vorschrift,'<=',2)
  for ii = 1:n
    for i=start_index:step:end_index,
        if( vek(i) <= wert(ii) )
          index{ii} = [index{ii};i];
          if( ~find_all )
            break
          end
        end
    end
  end
elseif strncmp(vorschrift,'<',1)
  for ii = 1:n
    for i=start_index:step:end_index,
        if( vek(i) < wert(ii) )
          index{ii} = [index{ii};i];
          if( ~find_all )
            break
          end
        end
    end
  end
elseif strcmp(vorschrift,'==')
  for ii = 1:n
    for i=start_index:step:end_index,
        if( abs(vek(i) - wert(ii)) <= toleranz )
          index{ii} = [index{ii};i];
          if( ~find_all )
            break
          end
        end
    end
  end
elseif strcmp(vorschrift,'===')
  if( is_monoton_steigend(vek) )
    for ii=1:n
      ivec = [1:1:length(vek)]';
      index{ii} = interp1(vek,ivec,wert(ii),'linear','extrap');
    end
  else
    for ii = 1:n
      if( wert(ii) >= vek(start_index) )
        steig = 1;
      else
        steig = -1;
      end
      stopflag = 0;
      for i = start_index:step:end_index,
        if( vek(i) == wert(ii) )
          index{ii} = i;
          stopflag = 1;
        elseif( steig > 0 )
          if( vek(i) > wert(ii) )
            if( step > 0 )
              i0 = i-1;
              i1 = i;
              index{ii} =  i0 + (wert(ii)-vek(i0))/(vek(i1)-vek(i0));
            else
              i0 = i;
              i1 = i+1;
              index{ii} =  i0 + (vek(i0)-wert(ii))/(vek(i0)-vek(i1));
            end
            stopflag = 1;
          end
        else
          if( vek(i) <= wert(ii) )
            if( step > 0 )
              i0 = i-1;
              i1 = i;
              index{ii} =  i0 + (vek(i0)-wert(ii))/(vek(i0)-vek(i1));
            else
              i0 = i;
              i1 = i+1;
              index{ii} =  i0 + (wert(ii)-vek(i0))/(vek(i1)-vek(i0));
            end

            stopflag = 1;
          end
        end
        if( stopflag )
          break;
        end
      end
    end
  end
%   if strncmp(richtung,'v',1)
%     for ii = 1:n
% 
%       if( (wert(ii) < vek(start_index)) )
%         start_index = 1;
%       end
%       if( (wert(ii) < vek(start_index)) )
%         index(ii) =  1 + (wert(ii)-vek(1))/(vek(2)-vek(1));
%       elseif( (wert(ii) > vek(end_index)) )
%         index(ii) =  end_index + (wert(ii)-vek(end_index))/(vek(end_index)-vek(end_index-1));
%       else
%         for i=start_index:step:end_index-1,
%             if( ( (vek(i+1) > wert(ii)) && (wert(ii) >= vek(i)) ) ...
%               )
%                 index(ii) = i + (wert(ii)-vek(i))/(vek(i+1)-vek(i));
%                 break
%             end
%         end
%       end
%     end
%   else
%     for ii = 1:n
%       if( (wert(ii) > vek(start_index)) )
%         start_index = length(vek);
%       end
%       if( (wert(ii) < vek(end_index)) )
%         index(ii) =  1 + (wert(ii)-vek(1))/(vek(2)-vek(1));
%       elseif( (wert(ii) > vek(start_index)) )
%         index(ii) =  start_index + (wert(ii)-vek(start_index))/(vek(start_index)-vek(start_index-1));
%       else
%         for i=start_index-1:step:end_index,
%             if( ( (vek(i+1) > wert(ii)) && (wert(ii) >= vek(i)) ) )
%                 index(ii) = i + (wert(ii)-vek(i+1))/(vek(i)-vek(i+1));
%                 break
%             end
%         end
%       end
%     end
%   end        
else % '===='
  for ii = 1:n
    [v,index{ii}] = min(abs(vek - wert(ii)));
  end
end

if( length(index) == 1 )
  index = index{1};
  if( isempty(index) )
    index = 0;
  end
else
  for(i=1:n)
    if( isempty(index{i}) )
      index{i} = 0;
    end
  end
end
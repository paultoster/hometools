function    [vec,c_index_liste] = vec_peak_filter(vec,diff_min,npoints,maxpoints,type)
%
% [vec,c_index_liste] = vec_peak_filter(vec,diff_min,npoints,maxpoints,type)
%
% Sucht Peaks in Strukturliste von d, wenn Betrag der Differenz eines
% Vektors ausserhalb des Wertes diff_min liegt. Diese Stellen werden
% mit npoints vor und nachher interpoliert (type=0 linear, 1:spline, 2:cubic)
% 
% vec       vector (double)
% diff_min  (def=3.0) Faktor zur Festlegung des Bands
% all       (def=1) Flag ob all an einer gefunden peak-stelle gefiltert
%            werden

if( nargin < 2 )
    error('Zuwenige Parameter: 1. Parameter Vector, 2. Parameter diff_min ¸bergeben')
end

if( ~isnumeric(vec) )
  error('Falscher Typ: erster Parameter muss ein vekotor sein')
end

[n,m] =size(vec);
if( m > n )
  vec = vec';
  [n,m] =size(vec);
  trans_flag = 1;
else
  trans_flag = 0;
end

if( m > 1 )
  error('1. parameter ist kein Vektor sondern Matrix')
end
if( n < 3 )
  error('1. parameter: Vektor ist zu klein')
end

if( ~exist('npoints','var') )
  npoints = min(10,n/2);
end
if( ~exist('maxpoints','var') )
  maxpoints = min(10,n/2);
end
if( ~exist('type','var') )
  type = 0;
end
if( ~exist('all','var') )
  all = 1;
end

c_index_liste = {};

%[vec_av,nmit,ystd] = calc_mittelwert(vec,'gleit',maxpoints*3);
x   = [1:1:length(vec)]';
vec_av = pt1_filter(x,vec,maxpoints*6);
vecdiff = abs(vec - vec_av);

% figure
% plot(vec,'k-')
% hold on
% plot(vec_av,'r-')
% plot(vecdiff,'b-')
% hold off

state = 0;
vec_x  = [];
vec_y  = [];
i = 1;
while( i <= n )
  
  switch(state)
    case 0 % suchen nach schlechtem Zustand
      if( vecdiff(i) > diff_min )
        state = 1;
        jstart = max(1,i-npoints);
        jend   = i-1;
        kcount = 0;
        for j=jstart:jend
          kcount  = kcount+1;
          vec_x = [vec_x;j];
          vec_y = [vec_y;vec(j)];
        end
        nbadpoint = 1;
      end
    case 1 % solange suchen bis wiedre okay
      if( vecdiff(i) <= diff_min ) % Ende
        state   = 2;
        ncount  = 0;
        % Diesen Punkt noch nicht dazunehmen
        %kcount  = kcount+1;
        %vec_x = [vec_x;i];
        %vec_y = [vec_y;vec(i)];
      else
        nbadpoint = nbadpoint+1;
      end
%       if( nbadpoint > maxpoints )
%         figure
%         plot(vec);
%         figure
%         plot(vecdiff);
%         figure
%         plot(vec,'k-')
%         hold on
%         plot(vec_av,'r-')
%         hold off
%         [vec_av,nmit,ystd] = calc_mittelwert(vec,'gleit',maxpoints*10);
%         x   = [1:1:length(vec)]';
%         f_x = pt1_filter(x,vec,60);
%         warning('vec_peak_filter: mindestens  maxpoints Ausreiﬂer waren hintereinander bei index =%i',i);
%         state   = 2;
%         ncount  = 1;
%         kcount  = kcount+1;
%         vec_x = [vec_x;i];
%         vec_y = [vec_y;vec(i)];        
%       end
    case 2 % dann noch npoints - 1 suchen
      if( vecdiff(i) <= diff_min )
        ncount = ncount+1;
        kcount  = kcount+1;
        vec_x = [vec_x;i];
        vec_y = [vec_y;vec(i)];
      else
        state = 3;
      end
      if( ncount >= npoints )
        state = 3;
      end
  end
  if( state == 3 ) % Interpolieren
    xin = [min(vec_x):1:max(vec_x)]';
    if( type < 1.5 )
      yout = interp1(vec_x,vec_y,xin,'linear','extrap');
    elseif( type < 2.5 )
      yout = interp1(vec_x,vec_y,xin,'spline','extrap');
    else
      yout = interp1(vec_x,vec_y,xin,'cubic','extrap');
    end
    for j=1:length(xin)
      vec(xin(j)) = yout(j);
    end
    c_index_liste{length(c_index_liste)+1} = vec_x;
    vec_x = [];
    vec_y = [];
    state = 0;
    i     = max(1,i - npoints);
  end
  
  i = i+1;

end  

if( ~isempty(vec_x) )
    xin = [min(vec_x):1:max(vec_x)]';
    if( type < 1.5 )
      yout = interp1(vec_x,vec_y,xin,'linear','extrap');
    elseif( type < 2.5 )
      yout = interp1(vec_x,vec_y,xin,'spline','extrap');
    else
      yout = interp1(vec_x,vec_y,xin,'cubic','extrap');
    end
    for j=1:length(xin)
      vec(xin(j)) = yout(j);
    end
    c_index_liste{length(c_index_liste)+1} = vec_x;
end

if( trans_flag )
  vec = vec';
end
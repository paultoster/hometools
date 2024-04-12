function s = vec_find_values(varargin)
%
% s = vec_find_values('type','const','vec',vec,'delta',delta,'nlimmin',nlimmin,'sorting',1)
% s = vec_find_values('type','equal','vec',vec,'val',val,'tol',tol,'nlimmin',nlimmin)
% s = vec_find_values('type','gt','vec',vec,'val',val,'nlimmin',nlimmin,'sorting',1)
% s = vec_find_values('type','lt','vec',vec,'val',val,'nlimmin',nlimmin,'sorting',1)
% s = vec_find_values('type','==','vec',vec,'val',val,'tol',tol,'nlimmin',nlimmin)
% s = vec_find_values('type','>,'vec',vec,'val',val,'nlimmin',nlimmin,'sorting',1)
% s = vec_find_values('type','<,'vec',vec,'val',val,'nlimmin',nlimmin,'sorting',1)
% s = vec_find_values('type','last','vec',vec,'val',val,'tol',tol)
%
% Sucht im Vektor nach bestimmten Werten in Abschnitten
%
% Stücke mit Konstantwerten suchen
%
% type  = 'const'    Stücke mit Konstantwerten
% vec                Vektor mit Werten
% delta              (delta = eps) delta-Wert um Konstantwert zu erkennen
% nlimmin            (default: 3) Mindestanzahl von Punkten hintereinander, um
%                    konstant-Wert zu bestimmen
%
% Werte gleich dem val
%
% type  = 'equal' or '==' Stücke mit Konstantwerten
% vec                Vektor mit Werten
% val                (val = 0.0) Vergleichswert
% tol               (default: eps) Toleranz
% s(i).i0            gefundener erster Index 
% s(i).i1            gefundener erster Index
% s(i).val           Wert
%
% Stücke größer als einen Wert suchen
%
% type  = 'gt' or '>'      Stücke mit Konstantwerten
% vec                Vektor mit Werten
% val                (val = 0.0) Vergleichswert
% nlimmin            (default: 3) Mindestanzahl von Punkten hintereinander
% s(i).i0            erster Index
% s(i).i1            letzter Index
% s(i).val           Wert
%
% Stücke kleiner als einen Wert suchen
%
% type  = 'lt' or '<'      Stücke mit Konstantwerten
% vec                Vektor mit Werten
% val                (val = 0.0) Vergleichswert
% nlimmin            (default: 3) Mindestanzahl von Punkten hintereinander
% s(i).i0            erster Index
% s(i).i1            letzter Index
% s(i).val           Wert
%
% letzter Wert mit einem bestimmten Wert
%
% type  = 'last'     letzter Wert
% vec                Vektor mit Werten
% val                Vergleichswert
% tol               (default: eps) Toleranz
%
% s.i0               Index
% s.i1               Index
% s.ivec
% s.val              Wert


  type    = '';
  vec     = [];
  delta   = eps;
  nlimmin = 3;
  sorting    = 0;
  val     = 0.0;
  tol     = eps;
  i = 1;
  while( i+1 <= length(varargin) )

      switch lower(varargin{i})
          case 'type'
              type = varargin{i+1};
          case 'vec'
              vec = round(varargin{i+1});
          case 'delta'
              delta = varargin{i+1};
          case 'nlimmin'
              nlimmin = varargin{i+1};
          case 'sorting'
              sorting = varargin{i+1};
          case 'val'
              val = varargin{i+1};
          case 'tol'
              tol = varargin{i+1};
          otherwise
              tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,varargin{i},type);
              error(tdum);

      end
      i = i+2;
  end
  
  [n,m] = size(vec);
  
  if( m > n )
    vec = vec';
  end
  
  if( ~isnumeric(vec)  )
    error('%s: vec not Vektor',mfilename)
  end
  
  n = length(vec);
  
  s       = [];
  istruct = 0;
  
  if( isempty(vec) )
    return
  end
  switch(type)
    %======================================================================
    case 'const'
    %======================================================================
      state  = 0;
      val    = vec(i);
      ncount = 0;
      i0     = 0;
      for i=2:n
        switch(state)
          case 0 % Start
            if( abs(vec(i)-val) < delta )
              state  = 1;
              ncount = 1;
              i0     = i;
              i1     = i;
            else
              val = vec(i);
            end
          case 1
            if( abs(vec(i)-val) < delta )
              ncount = ncount + 1;
              i1     = i;
            else
              if( ncount >= nlimmin )
                istruct = length(s);
                if( istruct == 0 )
                  s.i0  = i0;
                  s.i1  = i1;
                  s.val = val;
                else
                  istruct = istruct+1;
                  s(istruct).i0  = i0;
                  s(istruct).i1  = i1;
                  s(istruct).val = val;
                end
              end
              state  = 0;
              val    = vec(i);
            end
        end
      end
      if( state == 1 )
        if( ncount >= nlimmin )
          istruct = length(s);
          if( istruct == 0 )
            s.i0  = i0;
            s.i1  = i1;
            s.val = val;
          else
            istruct = istruct+1;
            s(istruct).i0  = i0;
            s(istruct).i1  = i1;
            s(istruct).val = val;
          end
        end
      end
      if( sorting )
        nvec = zeros(length(s),1);
        for i=1:length(s)
          nvec(i)   = s(i).i1 - s(i).i0;
        end
        [~,isort] = sort(nvec,'descend');
        s         = s(isort);
      end
      
    %======================================================================
    case {'equal','=='}
    %======================================================================
      state  = 0;
      ncount = 0;
      i0     = 0;
      for i=1:n
        switch(state)
          case 0 % Start
            if( abs(vec(i) - val) < tol )
              state  = 1;
              ncount = 1;
              i0     = i;
              i1     = i;
            end
          case 1
            if( abs(vec(i) - val) >= tol )
              ncount = ncount + 1;
              i1     = i-1;
            else
              if( ncount >= nlimmin )
                istruct = length(s);
                if( istruct == 0 )
                  s.i0  = i0;
                  s.i1  = i1;
                  s.val = val;
                else
                  istruct = istruct+1;
                  s(istruct).i0  = i0;
                  s(istruct).i1  = i1;
                  s(istruct).val = val;
                end
              end
              state  = 0;
            end
        end
      end
      if( state == 1 )
        if( ncount >= nlimmin )
          istruct = length(s);
          if( istruct == 0 )
            s.i0  = i0;
            s.i1  = i1;
            s.val = val;
          else
            istruct = istruct+1;
            s(istruct).i0  = i0;
            s(istruct).i1  = i1;
            s(istruct).val = val;
          end
        end
      end
      if( sorting )
        nvec = zeros(length(s),1);
        for i=1:length(s)
          nvec(i)   = s(i).i1 - s(i).i0;
        end
        [~,isort] = sort(nvec,'descend');
        s         = s(isort);
      end
      
    %======================================================================
    case {'gt','>'}
    %===============================      
      state  = 0;
      ncount = 0;
      i0     = 0;
      for i=1:n
        switch(state)
          case 0 % Start
            if( vec(i) > val )
              state  = 1;
              ncount = 1;
              i0     = i;
              i1     = i;
            end
          case 1
            if( vec(i) > val )
              ncount = ncount + 1;
              i1     = i;
            else
              if( ncount >= nlimmin )
                istruct = length(s);
                if( istruct == 0 )
                  s.i0  = i0;
                  s.i1  = i1;
                  s.val = val;
                else
                  istruct = istruct+1;
                  s(istruct).i0  = i0;
                  s(istruct).i1  = i1;
                  s(istruct).val = val;
                end
              end
              state  = 0;
            end
        end
      end
      if( state == 1 )
        if( ncount >= nlimmin )
          istruct = length(s);
          if( istruct == 0 )
            s.i0  = i0;
            s.i1  = i1;
            s.val = val;
          else
            istruct = istruct+1;
            s(istruct).i0  = i0;
            s(istruct).i1  = i1;
            s(istruct).val = val;
          end
        end
      end
      if( sorting )
        nvec = zeros(length(s),1);
        for i=1:length(s)
          nvec(i)   = s(i).i1 - s(i).i0;
        end
        [~,isort] = sort(nvec,'descend');
        s         = s(isort);
      end
    %======================================================================
    case {'lt','<'}
    %===============================      
      state  = 0;
      ncount = 0;
      i0     = 0;
      for i=1:n
        switch(state)
          case 0 % Start
            if( vec(i) < val )
              state  = 1;
              ncount = 1;
              i0     = i;
              i1     = i;
            end
          case 1
            if( vec(i) < val )
              ncount = ncount + 1;
              i1     = i;
            else
              if( ncount >= nlimmin )
                istruct = length(s);
                if( istruct == 0 )
                  s.i0  = i0;
                  s.i1  = i1;
                  s.val = val;
                else
                  istruct = istruct+1;
                  s(istruct).i0  = i0;
                  s(istruct).i1  = i1;
                  s(istruct).val = val;
                end
              end
              state  = 0;
            end
        end
      end
      if( state == 1 )
        if( ncount >= nlimmin )
          istruct = length(s);
          if( istruct == 0 )
            s.i0  = i0;
            s.i1  = i1;
            s.val = val;
          else
            istruct = istruct+1;
            s(istruct).i0  = i0;
            s(istruct).i1  = i1;
            s(istruct).val = val;
          end
        end
      end
      if( sorting )
        nvec = zeros(length(s),1);
        for i=1:length(s)
          nvec(i)   = s(i).i1 - s(i).i0;
        end
        [~,isort] = sort(nvec,'descend');
        s         = s(isort);
      end
    %======================================================================
    case 'last'
    %======================================================================
    for i=n:-1:1
      
      if( abs(vec(i)-val) < tol )
        s.i0  = i;
        s.i1  = i;
        s.val = vec(i);
        break;
      end
    end
    otherwise
      error('%s: type : <%s> not implemented',mfilename,type)
  end
 end

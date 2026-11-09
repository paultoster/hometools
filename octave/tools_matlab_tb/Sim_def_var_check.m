function s = Sim_def_var_check(s,pre_name,type)
%
% s = Sim_def_var_check(s,pre_name,type)
%
% pre_name      char            Wenn gesetzt, wird 
%                               s(i).name = [pre_name,s(i).name];
% type      = 'i'
%
% Checkt Input/Output-Variablenbeschreibung
%
%      s(i).name     = 'b';         no         Name in Simulationsumgebung
%      s(i).unit     = 'm';         '-'        Einheit in Simulationsumgebung gilt aber nur für float
%                                              und double
%-----------------------------------------------------------------
%      s(i).type      = 'single';   'single'   'single','mBuffer'
%
%      s(i).varname   = 's.b';                                 Variablenname in C, kann auch Struktur sein
%      s(i).varformat = {'float','unsigned char'};  'float'    welcher C-Format-Typ paßt dazu
%      s(i).vartype   = 'C';        'C'                        Type der Code 'C' oder 'C++'
%      s(i).varinc    = 'fxy.h';    ''                         Includedatei mit Definition
%      s(i).varunit   = 'm';        s(i).unit                  Einheit dieser Variable
%      s(i).comment   = 'Test b';   ''         Kommentar
%
%      s(i).id        = 560;        0          CAN-ID für Ausgabe genau mit EInlesen
%                                              von dieser Botschaft (ansonsten 0)
%      s(i).channel   = 1;                     dazugehöriger channel gezählt von 1
%-----------------------------------------------------------------
%      s(i).type      = 'mBuffer';   'single'   'single','mBuffer'
%
%      s(i).varunit  = {'m','enum'};
%      s(i).length   = 200;
%      s(i).vecnames = {'length','dir'};
%                                               #define N_S_B_LENGTH 200
%                                               float s.b_length[N_S_B_LENGTH];
%                                               float s.b_dir[N_S_B_LENGTH];
%                                                 
%                                               Variablename in Matlab:b_mBuffer_0_length, ..., b_mBuffer_199_length 
% type      = 'o'     (default)
%
% Checkt Input/Output-Variablenbeschreibung
%
%      s(i).name     = 'b';         no         Name in Simulationsumgebung
%      s(i).unit     = 'm';         '-'        Einheit in Simulationsumgebung gilt aber nur für float
%                                              und double
%-----------------------------------------------------------------
%      s(i).type      = 'single';   'single','mBuffer','vector','char'
%
%      s(i).varname   = 's.b';                                 Variablenname in C, kann auch Struktur sein
%      s(i).varformat = {'float','unsigned char'};  'float'    welcher C-Format-Typ paßt dazu
%      s(i).vartype   = 'C';        'C'                        Type der Code 'C' oder 'C++'
%      s(i).varinc    = 'fxy.h';    ''                         Includedatei mit Definition
%      s(i).varunit   = 'm';        s(i).unit                  Einheit dieser Variable
%      s(i).comment   = 'Test b';   ''         Kommentar
%
%      s(i).id        = 560;        0          CAN-ID für Ausgabe genau mit EInlesen
%                                              von dieser Botschaft (ansonsten 0)
%      s(i).channel   = 1;                     dazugehöriger channel gezählt von 1
%-----------------------------------------------------------------
%      s(i).type      = 'char';   
%      s(i).length    = 200;
%      s(i).varname   = 's.b';                                 Variablenname in C, kann auch Struktur sein
%      s(i).vartype   = 'C';        'C'                        Type der Code 'C' oder 'C++'
%      s(i).varinc    = 'fxy.h';    ''                         Includedatei mit Definition
%      s(i).comment   = 'Test b';   ''         Kommentar
%-----------------------------------------------------------------
%      s(i).type      = 'string';                              type std::string
%      s(i).varname   = 's.b';                                 Variablenname in C, kann auch Struktur sein
%      s(i).vartype   = 'C';        'C'                        Type der Code 'C' oder 'C++'
%      s(i).varinc    = 'fxy.h';    ''                         Includedatei mit Definition
%      s(i).comment   = 'Test b';   ''         Kommentar
%-----------------------------------------------------------------
%      s(i).type      = 'mBuffer'; 'single','mBuffer','vector','char','string'
%
%      s(i).varunit  = {'m','enum'};
%      s(i).length   = 200;
%      s(i).vecnames = {'length','dir'};
%                                               #define N_S_B_LENGTH 200
%                                               float s.b_length[N_S_B_LENGTH];
%                                               float s.b_dir[N_S_B_LENGTH];
%                                                 
%                                               Variablename in Matlab:b_mBuffer_0_length, ..., b_mBuffer_199_length 
%                                               Variablename in Matlab:b_mBuffer_0_length, ..., b_mBuffer_199_length 
%-----------------------------------------------------------------
%      s(i).type      = 'vector';   'single'   'single','mBuffer','vector'
%      s(i).varname    = 'AD2POutput.Path_TrajInp_x(AD2POutput.Path_TrajInp_n)';
%      s(i).varformat  = 'float(unsigned int)';
%      s(i).varunit    = 'm';
%      s(i).type       = 'vector';
%      s(i).name       = 'SAD2P_Path_TrajInp_x';
%      s(i).unit       = '';
%      s(i).comment    = 'Input Path Trajectory x';
%
%  Im Code wird die Variable 
%     float        AD2POutput.Path_TrajInp_x[]; und
%     unsigned int AD2POutput.Path_TrajInp_n; 
%  benötigt zum einlesen.
%
% type      = 'p' 
%
% Checkt Parameter-Variablenbeschreibung
%
% s(i).type      'single'     Es werden loopweise Werte von
%                             aussen zugewiese
%                'perm'       Es wird ein konstanter Wert
%                             von aussen Loopweise zugewiesen
%                'init0'      Es wird ein konstanter Wert
%                             vor Ausführung Init von aussen zugewiesen
%                'init1'      Es wird ein konstanter Wert
%                             nach Ausführung Init von aussen zugewiesen
%                'cperm'      Es wird ein konstnter Wert (Wert steht in
%                             p.id) zugewiesen Loopweise zugewiesen, kein
%                             Wert von aussen
%                'cinit0'     Es wird ein konstanter Wert (Wert steht in
%                             p-id) vor Ausführung Init zugewiesen, kein
%                             Wert von aussen
%                'cinit1'     Es wird ein konstanter Wert (Wert steht in in
%                             p.id) nach Ausführung Init zugewiesen, kein
%                             Wert von aussen
%
% s(i).type = 'cperm',cinit0',cinit1'
% Wertzuweisung entweder im Namen s(i).name = 'Name=Wert' oder seperat ein
% Wert s(i).varval = 'Wert', sollte in char sein
%==========================================================================
% s(i).type = 'single'
%                Zuordnung wie Input als Vektor 
% s(i).name      Simulationsname
% s(i).unit      Einheit in der Simulation
% s(i).varname   vollständiger C-Name
% s(i).varinc    include-Datei für die Variable z.B. 'abc.h'
% s(i).vartype   'C' oder 'C++', default 'C' für include
% s(i).varformat C-Format von varname float, ...
% s(i).varunit   Einheit für varname
%==========================================================================
% s(i).type = 'perm', 'init0', 'init1' 
%                Zuordnung wie Input als Konstante
% s(i).name      Simulationsname
% s(i).unit      Einheit in der Simulation
% s(i).varname   vollständiger C-Name
% s(i).varinc    include-Datei für die Variable z.B. 'abc.h'
% s(i).vartype   'C' oder 'C++', default 'C' für include
% s(i).varformat C-Format von varname float, ...
% s(i).varunit   Einheit für varname
%==========================================================================
% s(i).type = 'cperm', 'cinit0', 'cinit1' 
%                Zuordnung direkt konstante Vorgabe im Code
% s(i).name      Simulationsname, kannn Zuordnung enthalten mit '='
%                (z.B. s(i).name = 'abc=101.01') oder es wird ein string in 
%                s(i).varval abgelegt (s(i).varval = '101.01')
% s(i).unit      Einheit in der Simulation
% s(i).varname   vollständiger C-Name
% s(i).varinc    include-Datei für die Variable z.B. 'abc.h'
% s(i).vartype   'C' oder 'C++', default 'C' für include
% s(i).varformat C-Format von varname float, ...
% s(i).varunit   Einheit für varname
% s(i).varval    string mit Wert, wenn nicht im Namen s(i).name

  if( exist('pre_name','var') && ischar(pre_name) && ~isempty(pre_name) )
    pre_flag = 1;
  else
    pre_flag = 0;
  end
  n = length(s);
  
  if( ~exist('type','var') )
    type = 'o';
  end
  TYPE_INP = 1;
  TYPE_OUT = 2;
  TYPE_PAR = 3;
  if( (type(1) == 'i') || (type(1) == 'I') )
    type_sw = TYPE_INP;
  elseif( (type(1) == 'o') || (type(1) == 'O') )
    type_sw = TYPE_OUT;
  elseif( (type(1) == 'p') || (type(1) == 'P') )
    type_sw = TYPE_PAR;
  else
    error('%s_error: type %s kann nicht zugeordnet werden',mfilename,type)
  end
  
   
  for i=1:n
    % s(i).type
    if( ~check_val_in_struct(s(i),'type','char',1) )
      s(i).type = 'single';
    end
    if(  strcmp(s(i).type,'single') ...
      || (  strcmp(s(i).type,'perm')||strcmp(s(i).type,'init0')||strcmp(s(i).type,'init1') ...
         || ( strcmp(s(i).type,'cperm')||strcmp(s(i).type,'cinit0')||strcmp(s(i).type,'cinit1') ...
            ) ...
            && (type_sw == TYPE_PAR) ...
         ) ...
      )

      % s(i).name
      if( ~check_val_in_struct(s(i),'name','char',1) )
        error('%s_errror: s(%i).name leer oder nicht definiert !!!',mfilename,i);
      end
      % beiParameter und cperm, cinit0 und cint1 kann der Wert hinter dem
      % Namen stehen name=Wert, hier wird danach gesucht
      %
      if(  (type_sw == TYPE_PAR) ...
        && (strcmp(s(i).type,'cperm')||strcmp(s(i).type,'cinit0')||strcmp(s(i).type,'cinit1')) ...      
        )
        i0 = str_find_f(s(i).name,'=');
        if( i0 > 0 )
          c = str_split(s(i).name,'=');
          s(i).varval = c{2};
        end
      end
      
      % s(i).varval
      if( ~check_val_in_struct(s(i),'varval','char',1) )
        s(i).varval = 'Keinen Wert als string zugewiesen, z.B. ''1.0'' ';
      end
      % s(i).unit
      if( ~check_val_in_struct(s(i),'unit','char',1) )
        if( check_val_in_struct(s(i),'varunit','char',1) )
          s(i).unit = s(i).varunit;
        else
          s(i).unit = '-';
        end
      end
      % s(i).varname
      if( ~check_val_in_struct(s(i),'varname','char',1) )
        s(i).varname = s(i).name;
      end
      % s(i).varformat
      if( ~check_val_in_struct(s(i),'varformat','char',1) )
        s(i).varformat = 'float';
      end   
      % s(i).varinc
      if( ~check_val_in_struct(s(i),'varinc','char',1) )
        s(i).varinc = '';
      end
      % s(i).vartype
      if( ~check_val_in_struct(s(i),'vartype','char',1) )
        s(i).vartype = 'C';
      end
      % s(i).varunit
      if( ~check_val_in_struct(s(i),'varunit','char',1) )
        s(i).varunit = s(i).unit;
      end
      % s(i).comment
      if( ~check_val_in_struct(s(i),'comment','char',1) )
        s(i).comment = '';
      end
      % s(i).id
      if( ~check_val_in_struct(s(i),'id','num',1) )
        s(i).id = 0;
      end
      % s(i).channel
      if( ~check_val_in_struct(s(i),'channel','num',1) )
        s(i).channel = 0;
      end
    elseif( strcmp(s(i).type,'mBuffer') && ((type_sw == TYPE_INP) || (type_sw == TYPE_OUT)) )
            % s(i).name
      if( ~check_val_in_struct(s(i),'name','char',1) )
        error('%s_errror: s(%i).name leer oder nicht definiert !!!',mfilename,i);
      end
      % s(i).varname
      if( ~check_val_in_struct(s(i),'varname','char',1) )
        s(i).varname = s(i).name;
      end
      % s(i).unit
      if(check_val_in_struct(s(i),'unit','char',1))
        s(i).unit = {s(i).unit};
      elseif( ~check_val_in_struct(s(i),'unit','cell',1) )
        if( check_val_in_struct(s(i),'varunit','cell',1) )
          s(i).unit = s(i).varunit;
        else
          s(i).unit = {'-'};
        end
      end
      % s(i).varformat
      if(check_val_in_struct(s(i),'varformat','char',1))
        s(i).varformat = {s(i).varformat};
      elseif( ~check_val_in_struct(s(i),'varformat','cell',1) )
        s(i).varformat = {'float'};
      end   
      % s(i).varinc
      if( ~check_val_in_struct(s(i),'varinc','char',1) )
        s(i).varinc = '';
      end
      % s(i).varunit
      if( check_val_in_struct(s(i),'varunit','char',1) )
        s(i).varunit = {s(i).varunit};
      elseif( ~check_val_in_struct(s(i),'varunit','cell',1) )
        s(i).varunit = s(i).unit;
      end
      % s(i).comment
      if( ~check_val_in_struct(s(i),'comment','char',1) )
        s(i).comment = '';
      end
      % s(i).id
      if( ~check_val_in_struct(s(i),'id','num',1) )
        s(i).id = 0;
      end
      % s(i).channel
      if( ~check_val_in_struct(s(i),'channel','num',1) )
        s(i).channel = 0;
      end
      % s(i).length
      if( ~check_val_in_struct(s(i),'length','num',1) )
        s(i).length = 1;
      end

      % s(i).vecnames
      if( check_val_in_struct(s(i),'vecnames','char',1) )
        s(i).vecnames = {s(i).vecnames};
      elseif( ~check_val_in_struct(s(i),'vecnames','cell',1) )
        error('%s_error: s(%i).vecnames = {''a'',...} nicht bestimmt',mfilename,i) 
      end

      n = length(s(i).vecnames);
      if( length(s(i).unit) ~= n )
        error('%s_error: s(i).name=''%s'', s(i).unit muss %i Elemente haben (length(s(i).vecnames)',mfilename,s(i).name,n);
      end
      if( length(s(i).varunit) ~= n )
        error('%s_error: s(i).name=''%s'', s(i).varunit muss %i Elemente haben (length(s(i).vecnames)',mfilename,s(i).name,n);
      end
      if( length(s(i).varformat) ~= n )
        error('%s_error: s(i).name=''%s'', s(i).varformat muss %i Elemente haben (length(s(i).vecnames)',mfilename,s(i).name,n);
      end
    elseif( strcmp(s(i).type,'vector') && (type_sw == TYPE_OUT) ) 
            % s(i).name
      if( ~check_val_in_struct(s(i),'name','char',1) )
        error('%s_errror: s(%i).name leer oder nicht definiert !!!',mfilename,i);
      end
      % s(i).unit
      if( ~check_val_in_struct(s(i),'unit','char',1) )
        if( check_val_in_struct(s(i),'varunit','char',1) )
          s(i).unit = s(i).varunit;
        else
          s(i).unit = '-';
        end
      end
      % s(i).varname
      if( ~check_val_in_struct(s(i),'varname','char',1) )
         error('%s_errror: s(%i).varname leer oder nicht definiert (s.varname=''vecname(nname)'')!!!',mfilename,i);
      else
        c_text = str_get_quot_f(s(i).varname,'(',')','i');
        if( isempty(c_text))
          error('%s_errror: s(%i).varname lnicht richtig definiert (s.varname=''vec_name(nvec_name)'')!!!',mfilename,i);
        end
        ifound = str_find_f(s(i).varname,'(','vs');
        if( ifound == 1 )
        end
      end
      % s(i).varformat
      if( ~check_val_in_struct(s(i),'varformat','char',1) )
         error('%s_errror: s(%i).varformat leer oder nicht definiert (s.varformat=''frmt_vec(frmt_nvec)'' z.B. ''float(int)'')!!!',mfilename,i);
      else
        c_text = str_get_quot_f(s(i).varformat,'(',')','i');
        if( isempty(c_text) )
          error('%s_errror: s(%i).varformat nicht richtig definiert (s.varformat=''frmt_vec(frmt_nvec)'' z.B. ''float(int)'')!!!',mfilename,i);
        end
        ifound = str_find_f(s(i).varformat,'(','vs');
        if( ifound == 1 )
          error('%s_errror: s(%i).varformat nicht richtig definiert (s.varformat=''frmt_vec(frmt_nvec)'' z.B. ''float(int)'')!!!',mfilename,i);
        end
      end   
      % s(i).varinc
      if( ~check_val_in_struct(s(i),'varinc','char',1) )
        s(i).varinc = '';
      end
      % s(i).vartype
      if( ~check_val_in_struct(s(i),'vartype','char',1) )
        s(i).vartype = 'C';
      end
      % s(i).varunit
      if( ~check_val_in_struct(s(i),'varunit','char',1) )
        s(i).varunit = s(i).unit;
      end
      % s(i).comment
      if( ~check_val_in_struct(s(i),'comment','char',1) )
        s(i).comment = '';
      end
      % s(i).id
      if( ~check_val_in_struct(s(i),'id','num',1) )
        s(i).id = 0;
      end
      % s(i).channel
      if( ~check_val_in_struct(s(i),'channel','num',1) )
        s(i).channel = 0;
      end
    elseif( strcmp(s(i).type,'char') && ((type_sw == TYPE_INP)) ) 
     % s(i).name
      if( ~check_val_in_struct(s(i),'name','char',1) )
        error('%s_errror: s(%i).name leer oder nicht definiert !!!',mfilename,i);
      end
      % s(i).unit
      if( ~check_val_in_struct(s(i),'unit','char',1) )
        if( check_val_in_struct(s(i),'varunit','char',1) )
          s(i).unit = s(i).varunit;
        else
          s(i).unit = '-';
        end
      end
      % s(i).varname
      if( ~check_val_in_struct(s(i),'varname','char',1) )
        error('%s_errror: s(%i).varname leer oder nicht definiert !!!',mfilename,i);
      end
      % s(i).length
      if( ~check_val_in_struct(s(i),'length','num',1) )
        error('%s_errror: s(%i).length leer oder nicht definiert !!!',mfilename,i);
      end
      % s(i).varinc
      if( ~check_val_in_struct(s(i),'varinc','char',1) )
        s(i).varinc = '';
      end
      % s(i).vartype
      if( ~check_val_in_struct(s(i),'vartype','char',1) )
        s(i).vartype = 'C';
      end
      % s(i).varunit
      if( ~check_val_in_struct(s(i),'varunit','char',1) )
        s(i).varunit = s(i).unit;
      end
      % s(i).comment
      if( ~check_val_in_struct(s(i),'comment','char',1) )
        s(i).comment = '';
      end
      % s(i).id
      if( ~check_val_in_struct(s(i),'id','num',1) )
        s(i).id = 0;
      end
      % s(i).channel
      if( ~check_val_in_struct(s(i),'channel','num',1) )
        s(i).channel = 0;
      end
    elseif( strcmp(s(i).type,'string') && ((type_sw == TYPE_INP)) ) 
     % s(i).name
      if( ~check_val_in_struct(s(i),'name','char',1) )
        error('%s_errror: s(%i).name leer oder nicht definiert !!!',mfilename,i);
      end
      % s(i).unit
      if( ~check_val_in_struct(s(i),'unit','char',1) )
        if( check_val_in_struct(s(i),'varunit','char',1) )
          s(i).unit = s(i).varunit;
        else
          s(i).unit = '-';
        end
      end
      % s(i).varname
      if( ~check_val_in_struct(s(i),'varname','char',1) )
        error('%s_errror: s(%i).varname leer oder nicht definiert !!!',mfilename,i);
      end
      % s(i).varinc
      if( ~check_val_in_struct(s(i),'varinc','char',1) )
        s(i).varinc = '';
      end
      % s(i).vartype
      if( ~check_val_in_struct(s(i),'vartype','char',1) )
        s(i).vartype = 'C';
      end
      % s(i).varunit
      if( ~check_val_in_struct(s(i),'varunit','char',1) )
        s(i).varunit = s(i).unit;
      end
      % s(i).comment
      if( ~check_val_in_struct(s(i),'comment','char',1) )
        s(i).comment = '';
      end
      % s(i).id
      if( ~check_val_in_struct(s(i),'id','num',1) )
        s(i).id = 0;
      end
      % s(i).channel
      if( ~check_val_in_struct(s(i),'channel','num',1) )
        s(i).channel = 0;
      end
    elseif( (strcmp(s(i).type,'const')||strcmp(s(i).type,'init0')||strcmp(s(i).type,'init1')) && (type_sw == TYPE_PAR) )


    % s(i).varname   vollständiger C-Name mit Zuordnung z.B. 'a.abc=12;
      if( ~check_val_in_struct(s(i),'varname','char',1) )
        error('%s: varname muss für s(%i) mit type = ''%s'' angegeben sein',mfilename,i,s(i).type);
      end
      % s(i).varinc    include-Datei für die Variable z.B. 'abc.h'
      if( ~check_val_in_struct(s(i),'varinc','char',1) )
        s(i).varinc = '';
      end
      % s(i).vartype   'C' oder 'C++', default 'C' für include
      if( ~check_val_in_struct(s(i),'vartype','char',1) )
        s(i).vartype = 'C';
      end
      if( ~check_val_in_struct(s(i),'name','char',1) )
        i1 = str_find_f(s(i).varname,'=');
        if( i1 == 0 )
          s(i).name = s(i).varname;
        else
          tt = s(i).varname(1:max(i1-1,1));
          s(i).name = str_cut_ae_f(tt,' ');
        end
      end

    else
      error('%s_error: type=''%s'' nicht bekannt',mfilename,s(i).type)
    end
    if( pre_flag )
      if( str_find_f(s(i).name,pre_name,'vs') ~= 1 ) % Nicht am Anfang gefunden
        s(i).name = [pre_name,s(i).name];
      end
    end
  end
end
function okay = ds_write_par(par,varargin)
%
% okay = ds_write_par(par,'word',1,'ascii',1,'filename','name_ohne_ext')
%
% par           struct          Parameterstrucktur
% 'word'        char            Ausgabe in Wordfile
% 'ascii'       char            Ausgabe in Ascii-File

  w_flag  = 0;
  a_flag  = 0;
  filename = 'Parameter';
  i = 1;
  while( i+1 <= length(varargin) )

      c = lower(varargin{i});
      switch c
          case 'word'
              if( varargin{i+1} )
                  w_flag = 1;
              end
          case 'ascii'
              ascii_file = varargin{i+1};
              if( varargin{i+1} )
                  a_flag = 1;
              end
          case 'filename'
              filename = varargin{i+1};
          otherwise

              error('%s: Attribut <%s> nicht okay',mfilename,varargin{i})
      end
      i = i+2;
  end

  okay = 1;

  if( w_flag || a_flag ) 

      [okay,s_a] = ausgabe_aw('init' ...
                             ,'name',    filename ...
                             ,'ascii',   a_flag ...
                             ,'word',    w_flag ...  
                             ,'ncol1',   50 ...
                             ,'ncol2',   10 ...
                             ,'ncol3',   10 ...
                             ,'visible', 1 ...
                             );

      if( ~okay )
          return;
      end
  else
      return;
  end

  [okay,s_a] = ausgabe_aw('head',s_a,'text','DS-Parameterbeschreibung','char','=');

  cfields = fieldnames(par);

  structname = 'par';

  for i=1:length(cfields)


      if( ds_write_par_is_var(par.(cfields{i})) )

          okay = ds_write_var(s_a,par.(cfields{i}),cfields{i},structname);
      else
          oaky = ds_write_group(s_a,par.(cfields{i}),cfields{i},structname);
      end
      if( ~okay )
          break;
      end
  end


  % Beenden
  %========
  [okay,s_a] = ausgabe_aw('save',s_a);

  if( a_flag  )
      command = ['edit ''',s_a.ascii_file,''';'];
      eval(command)
  end
end
function flag = ds_write_par_is_var(p)

  flag = 0;
  if( isstruct(p) )
      if( struct_find_f(p,'v') && struct_find_f(p,'t') )

          flag = 1;   
      elseif( struct_find_f(p,'xv') && struct_find_f(p,'yv') && struct_find_f(p,'t') )
          flag = 1;
      end
  end
end
function okay = ds_write_var(s_a,p,name,structname)

  okay = 1;

  if( ~strcmp(name,'gcomment') )

    if( struct_find_f(p,'c') )
      comment = sprintf('%s',p.c);
    else
      comment = sprintf('%s','');
    end

    switch(p.t)

        case 'single'

            if( struct_find_f(p,'u') )

                unit = p.u;
            else
                unit = '?';
            end
            [okay,s_a] = ausgabe_aw('res',  s_a ...
                                   ,'com',  name ...
                                   ,'unit', unit ...
                                   ,'val',  p.v ...
                                   );
            [okay,s_a] = ausgabe_aw('title',s_a ...
                                   ,'text',['c: ',comment,' (',structname,'.',name,')'] ...
                                   ,'pos','left' ...
                                   );

        case '1dtable'
            
            tt = sprintf('1Dim-Tabelle: %s',[comment,' (',structname,'.',name,')']);
            [okay,s_a] = ausgabe_aw('title',  s_a ...
                                   ,'text',  tt ...
                                   );
            if( struct_find_f(p,'xu') )

                xunit = p.xu;
            else
                xunit = '?';
            end
            tt = sprintf('x-Vektor: %s [%s] <%s>',p.xn,xunit,p.xc);
            [okay,s_a] = ausgabe_aw('title',  s_a ...
                                   ,'text',  tt ...
                                   );

            if( length(p.xv) < 50 )
                if( strcmp(p.xn,'vol') )
                    test = 1;
                end
                [okay,s_a] = ausgabe_aw('vector',  s_a ...
                                       ,'val',  p.xv ...
                                       ,'nvalline', 10 ...
                                       );
            else
                [okay,s_a] = ausgabe_aw('title',  s_a ...
                                       ,'text',   'n > 50' ...
                                       );
            end
            if( struct_find_f(p,'yu') )

                yunit = p.yu;
            else
                yunit = '?';
            end
            tt = sprintf('y-Vektor: %s [%s] <%s>',p.yn,yunit,p.yc);
            [okay,s_a] = ausgabe_aw('title',  s_a ...
                                   ,'text',  tt ...
                                   );

            if( length(p.xv) < 50 )
                [okay,s_a] = ausgabe_aw('vector',  s_a ...
                                   ,'val',  p.yv ...
                                   ,'nvalline', 10 ...
                                   );
            else
                [okay,s_a] = ausgabe_aw('title',  s_a ...
                                       ,'text',   'n > 50' ...
                                       );
            end
            
            if( s_a.word )
                
                id = figure;
                if( p.lin )                    
                    plot(p.xv,p.yv,'k-')
                else
                    plot(p.xv,p.yv,'ko')
                end
                grid on
                xlabel([p.xn,' [',xunit,']'])
                ylabel([p.yn,' [',yunit,']'])
                [okay,s_a] = ausgabe_aw('figure',s_a,'handle',id);
                
                close(id);
            end
                    
        case 'string'

            [okay,s_a] = ausgabe_aw('res',  s_a ...
                                   ,'com',  name ...
                                   ,'val',  p.v ...
                                   );
            [okay,s_a] = ausgabe_aw('title',s_a ...
                                   ,'text',['c: ',comment,' (',structname,'.',name,')'] ...
                                   ,'pos','left' ...
                                   );
      otherwise
            [okay,s_a] = ausgabe_aw('vector',   s_a ...
                                   ,'val',      p.v ...
                                   ,'nvalline', 10 ...
                                   );

           % error('Typ: %s noch nicht programmiert',p.t)
    end
    if( okay )
      [okay,s_a] = ausgabe_aw('line',s_a,'char','-','newline',0);
    end
  end
end

function okay = ds_write_group(s_a,p,name,structname)

  okay = 1;

  [okay,s_a] = ausgabe_aw('line',s_a,'char','=','newline',0);
%  [okay,s_a] = ausgabe_aw('newline',s_a);
  [okay,s_a] = ausgabe_aw('title',s_a ...
                         ,'text',['Untergruppe : ',name,' (',structname,'.',name,')'] ...
                         ,'pos','right' ...
                         );
  if( okay ) 

      if( struct_find_f(p,'gcomment') && struct_find_f(p.('gcomment'),'v') )

          [okay,s_a] = ausgabe_aw('title',s_a ...
                                 ,'text',p.gcomment.v ...
                                 ,'pos','left' ...
                                 );
      end
      [okay,s_a] = ausgabe_aw('line',s_a,'char','=','newline',0);


      cfields = fieldnames(p);
      structname = [structname,'.',name];

      for i=1:length(cfields)


          if( ds_write_par_is_var(p.(cfields{i})) )


              okay = ds_write_var(s_a,p.(cfields{i}),cfields{i},structname);
          else
              okay = ds_write_group(s_a,p.(cfields{i}),cfields{i},structname);
          end
          if( ~okay )
              return;
          end
      end

  end
  
end    

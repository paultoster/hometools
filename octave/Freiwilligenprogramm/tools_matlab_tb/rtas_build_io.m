function rtas_build_io(q)
%
% rtas_build_io(q)
%
% q.outputfile            Name der Ausgabedatei
%
% Inputdefinition
% q.input.cstructname     c-structname for Inputs 
%
% q.input.scalefuncname   c-Funcname for unit scale
% q.input.var(i).type     'single','mBuffer'
%
% type = 'single'
% q.input.var(i).cname    Name in c-Code
% q.input.var(i).cformat  format 'unsigned char','float', 'double' etc
% q.input.var(i).cunit    Einheit in C-Code (default '')
% q.input.var(i).name     rtas-Name;
% q.input.var(i).comment  Kommentar (default '');
% q.input.var(i).unit     Einheit rtas aus von Aussen (default q.input.var(i).cunit);
%
% type = 'mBuffer'
%
% Der rtas-Name eines Vektors wird in n-Signale gespeichert
% "name_mBuffer_i_vecname"  name: Basisname, i: Zähler 0,1,2, vecname:
%  Vektorname
% q.input.var(i).length   Anzahl der mBuffer-Wert (also inizes, die einzeln
%                         als Signal kommen)
% q.input.var(i).cname    Basisname in c-Code
% q.input.var(i).cformat  format 'unsigned char','float', 'double' etc
% q.input.var(i).cunit    Einheit in C-Code (default '')
% q.input.var(i).name     rtas-Basisname;
% q.input.var(i).vecnames Vekotosnamen;
% q.input.var(i).comment  Kommentar (default '');
% q.input.var(i).unit     Einheit rtas aus von Aussen (default q.input.var(i).cunit);
%
% gleiches gilt für q.output

  input_flag = 0;
  input_mBuffer_flag = 0;
  output_flag = 0;
  output_mBuffer_flag = 0;

  if( ~struct_find_f(q,'outputfile',1) )
    q.outputfile = 'Ausgabe.dat';
  end

  % Inputdefinition
  if( isfield(q,'input') )
    input_flag = 1;

    if( ~struct_find_f(q.input,'cstructname',1) )
      error('Keine Input-Strukturnname q.input.cstructname defniert')
    end
    if( ~struct_find_f(q.input,'scalefuncname',1) )
      q.input.scalefuncname = [q.input.cstructname,'ScaleUnit'];
    end
    
    if( ~struct_find_f(q.input,'var',1) )
      error('Keine Inputvariablen q.input.var(i) defniert')
    end

    for i = 1:length(q.input.var)

      if( ~struct_find_f(q.input.var(i),'cname',1) )
        error('Keine Input-Variablenname für C q.input.var(%i).cname defniert',i)
      end
      if( ~struct_find_f(q.input.var(i),'cformat',1) )
        error('Keine Input-Strukturvariablenname q.input.var(%i).cformat defniert',i)
      end    
      if( ~struct_find_f(q.input.var(i),'cunit',1) )
        q.input.var(i).cunit = '';
      end    
      if( ~struct_find_f(q.input.var(i),'type',1) )
        error('Keinen Input-Strukturvariablentype q.input.var(%i).type defniert (''single'',''mBuffer''',i)
      end
      if( ~struct_find_f(q.input.var(i),'name',1) )
        error('Keine Input-Variablenname für Rtas q.input.var(%i).name defniert',i)
      end
      if( ~struct_find_f(q.input.var(i),'comment',1) )
        q.input.var(i).comment = '';
      end
      if( ~struct_find_f(q.input.var(i),'unit',1) )
        q.input.var(i).unit = q.input.var(i).cunit;
      end
      
      if( strcmpi(q.input.var(i).type,'mBuffer') )
        input_mBuffer_flag = 1;
        
        if( ~struct_find_f(q.input.var(i),'length',1) )
          error('Keine Länge für mBuffer-Signakl q.input.var(%i).length',i)
        end
        if( ~struct_find_f(q.input.var(i),'vecnames',1) )
          error('Keine Vektorname für mBuffer-Signal q.input.var(%i).vecnames',i)
        end
        if( ~iscell(q.input.var(i).vecnames) )
          error('q.input.var(%i).vecnames muss cellarray sein z.B. {''x'',''y''}',i)
        end
        if( ~iscell(q.input.var(i).cunit) )
          error('q.input.var(%i).cunit muss cellarray sein z.B. {''m'',''m''}',i)
        end
        if( ~iscell(q.input.var(i).unit) )
          error('q.input.var(%i).unit muss cellarray sein z.B. {''m'',''m''}',i)
        end
      end
    end

  end
  % Outputdefinition
  if( isfield(q,'output') )
    output_flag = 1;

    if( ~struct_find_f(q.output,'cstructname',1) )
      error('Keine Input-Strukturnname q.output.cstructname defniert')
    end
    if( ~struct_find_f(q.output,'scalefuncname',1) )
      q.output.scalefuncname = [q.output.cstructname,'ScaleUnit'];
    end
    
    if( ~struct_find_f(q.output,'var',1) )
      error('Keine Inputvariablen q.output.var(i) defniert')
    end

    for i = 1:length(q.output.var)

      if( ~struct_find_f(q.output.var(i),'cname',1) )
        error('Keine Input-Variablenname für C q.output.var(%i).cname defniert',i)
      end
      if( ~struct_find_f(q.output.var(i),'cformat',1) )
        error('Keine Input-Strukturvariablenname q.output.var(%i).cformat defniert',i)
      end    
      if( ~struct_find_f(q.output.var(i),'cunit',1) )
        q.output.var(i).cunit = '';
      end    
      if( ~struct_find_f(q.output.var(i),'type',1) )
        error('Keinen Input-Strukturvariablentype q.output.var(%i).type defniert (''single'',''mBuffer''',i)
      end
      if( ~struct_find_f(q.output.var(i),'name',1) )
        error('Keine Input-Variablenname für Rtas q.output.var(%i).name defniert',i)
      end
      if( ~struct_find_f(q.output.var(i),'comment',1) )
        q.output.var(i).comment = '';
      end
      if( ~struct_find_f(q.output.var(i),'unit',1) )
        q.output.var(i).unit = q.output.var(i).cunit;
      end
      
      if( strcmpi(q.output.var(i).type,'mBuffer') )
        output_mBuffer_flag = 1;
        
        if( ~struct_find_f(q.output.var(i),'length',1) )
          error('Keine Länge für mBuffer-Signakl q.output.var(%i).length',i)
        end
        if( ~struct_find_f(q.output.var(i),'vecnames',1) )
          error('Keine Vektorname für mBuffer-Signal q.output.var(%i).vecnames',i)
        end
        if( ~iscell(q.output.var(i).vecnames) )
          error('q.output.var(%i).vecnames muss cellarray sein z.B. {''x'',''y''}',i)
        end
        if( ~iscell(q.output.var(i).cunit) )
          error('q.output.var(%i).cunit muss cellarray sein z.B. {''m'',''m''}',i)
        end
        if( ~iscell(q.output.var(i).unit) )
          error('q.output.var(%i).unit muss cellarray sein z.B. {''m'',''m''}',i)
        end
      end
    end

  end
  
  % Ausgabedatei
  q.fid = fopen(q.outputfile,'w');
  if( q.fid < 0 )
    error('Datei %s konnte nicht geöffnet werden',d.outputfile);
  end

  if( input_flag )
    
    % Überschrift
    fprintf(q.fid,'############################\n');
    fprintf(q.fid,'# rtamodul h-File Input    #\n');
    fprintf(q.fid,'############################\n\n');
    
    % struktur beginnen
    fprintf(q.fid,'struct S%s\n{\n',q.input.cstructname);
    
    for i=1:length(q.input.var)
      
      if( strcmpi(q.input.var(i).type,'single') )
        [okay,errtext,tt] = rtas_build_io_input_single('h',2,q.input,i);
        fprintf(q.fid,tt);
      elseif( strcmpi(q.input.var(i).type,'mBuffer') )
        [okay,errtext,tt] = rtas_build_io_input_mBuffer('h',2,q.input,i);
        fprintf(q.fid,tt);
      else
        fclose(q.fid);
        error('Type der Inputvariable q.input.var(%i).type = %s falsch (''single'',''mBuffer'')',i);
      end
    end
    % function beenden
    fprintf(q.fid,'};\nextern	struct S%s %s;',q.input.cstructname,q.input.cstructname);
    

    % Überschrift
    fprintf(q.fid,'\n##############################\n');
    fprintf(q.fid,'# rtamodul c-file Input scale#\n');
    fprintf(q.fid,'##############################\n\n');
    
    % struktur beginnen
    fprintf(q.fid,'void %s(void)\n{\n',q.input.scalefuncname);

    if( input_mBuffer_flag )
      fprintf(q.fid,'  int i;\n',q.input.scalefuncname);
    end   
    for i=1:length(q.input.var)

      if( strcmpi(q.input.var(i).type,'single') )
        [okay,errtext,tt] = rtas_build_io_input_single('u',2,q.input,i);
        fprintf(q.fid,tt);
      elseif( strcmpi(q.input.var(i).type,'mBuffer') )
        [okay,errtext,tt] = rtas_build_io_input_mBuffer('u',2,q.input,i);
        fprintf(q.fid,tt);
      else
        fclose(q.fid);
        error('Type der Inputvariable q.input.var(%i).type = %s falsch (''single'',''mBuffer'')',i);
      end
      
    end
    
    % function beenden
    fprintf(q.fid,'};\n');
  
    
  end 
    
  if( output_flag )
    
    % Überschrift
    fprintf(q.fid,'############################\n');
    fprintf(q.fid,'# rtamodul h-File Output    #\n');
    fprintf(q.fid,'############################\n\n');
    
    % struktur beginnen
    fprintf(q.fid,'struct S%s\n{\n',q.output.cstructname);
    
    for i=1:length(q.output.var)
      
      if( strcmpi(q.output.var(i).type,'single') )
        [okay,errtext,tt] = rtas_build_io_output_single('h',2,q.output,i);
        fprintf(q.fid,tt);
      elseif( strcmpi(q.output.var(i).type,'mBuffer') )
        [okay,errtext,tt] = rtas_build_io_output_mBuffer('h',2,q.output,i);
        fprintf(q.fid,tt);
      else
        fclose(q.fid);
        error('Type der Inputvariable q.output.var(%i).type = %s falsch (''single'',''mBuffer'')',i);
      end
    end
    
    fprintf(q.fid,'};\nextern	struct S%s %s;',q.output.cstructname,q.output.cstructname);
    
    % Überschrift
    fprintf(q.fid,'\n##############################\n');
    fprintf(q.fid,'# rtamodul c-file Output scale#\n');
    fprintf(q.fid,'##############################\n\n');
    
    % struktur beginnen
    fprintf(q.fid,'void %s(void)\n{\n',q.output.scalefuncname);

    if( output_mBuffer_flag )
      fprintf(q.fid,'  int i;\n',q.output.scalefuncname);
    end   
    for i=1:length(q.output.var)

      if( strcmpi(q.output.var(i).type,'single') )
        [okay,errtext,tt] = rtas_build_io_output_single('u',2,q.output,i);
        fprintf(q.fid,tt);
      elseif( strcmpi(q.output.var(i).type,'mBuffer') )
        [okay,errtext,tt] = rtas_build_io_output_mBuffer('u',2,q.output,i);
        fprintf(q.fid,tt);
      else
        fclose(q.fid);
        error('Type der Inputvariable q.output.var(%i).type = %s falsch (''single'',''mBuffer'')',i);
      end
      
    end
    
    % function beenden
    fprintf(q.fid,'};\n');
  
    % Überschrift
    fprintf(q.fid,'\n#########################################\n');
    fprintf(q.fid,'# m-Filr set_u in dem unit gesetzt wird #\n');
    fprintf(q.fid,'#########################################\n\n');
    
    
    for i=1:length(q.output.var)

      if( strcmpi(q.output.var(i).type,'single') )
        [okay,errtext,tt] = rtas_build_io_output_single('mu',0,q.output,i);
        fprintf(q.fid,tt);
      elseif( strcmpi(q.output.var(i).type,'mBuffer') )
        [okay,errtext,tt] = rtas_build_io_output_mBuffer('mu',0,q.output,i);
        fprintf(q.fid,tt);
      else
        fclose(q.fid);
        error('Type der Inputvariable q.output.var(%i).type = %s falsch (''single'',''mBuffer'')',i);
      end
      
    end
    
    
  end

  % Ende
  fprintf(q.fid,'\n############################\n');
  fprintf(q.fid,'# Ende                     #\n');
  fprintf(q.fid,'############################\n');
  fclose(q.fid);
  fprintf('Ausgabedatei: %s erstellt -------------------------\n',q.outputfile);
end
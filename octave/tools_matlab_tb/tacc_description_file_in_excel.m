function tacc_description_file_in_excel
%
% tacc_description_file_in_excel
%
  org_path = cd;
  s_frage = [];
  s_frage.comment   = 'Pfad mit allen auszuwertenden Messungen (sucht description.txt)';
  if( exist('w:\','file') )
      s_frage.start_dir = 'w:\';
  else
      s_frage.start_dir = 'd:\';
  end

  [okay,c_dirname] = o_abfragen_dir_f(s_frage);


  if( okay )
      cd(c_dirname{1});

      c_files = suche_files_f(c_dirname{1},'txt',1);
      
      desc_files = {};
      idesc = 0;
      for i=1:length(c_files)
        if( strcmp(c_files(i).body,'description') )
          idesc = idesc + 1;
          desc_files{idesc} = c_files(i).full_name;
        end
      end
      
      % excel-Datei öffnen
      [okay,s_e] = ausgabe_excel('init','visible',1,'font_name','Arial','font_size',12);
      
      if( ~okay )
        return
      end
      
      [okay,s_e] = ausgabe_excel('val',s_e,'col',1,'row',1,'val',  'Date' );
      [okay,s_e] = ausgabe_excel('val',s_e,'col',2,'row',1,'val',  'Time' );
      [okay,s_e] = ausgabe_excel('val',s_e,'col',3,'row',1,'val',  'measurement' );
      [okay,s_e] = ausgabe_excel('val',s_e,'col',4,'row',1,'val',  'comment' );
      [okay,s_e] = ausgabe_excel('val',s_e,'col',5,'row',1,'val',  'MaxSpeed' );
      [okay,s_e] = ausgabe_excel('val',s_e,'col',6,'row',1,'val',  'Driver' );
      [okay,s_e] = ausgabe_excel('val',s_e,'col',7,'row',1,'val',  'Car' );
      [okay,s_e] = ausgabe_excel('val',s_e,'col',8,'row',1,'val',  'Scenario' );
      [okay,s_e] = ausgabe_excel('val',s_e,'col',9,'row',1,'val',  'path' );
      [okay,s_e] = ausgabe_excel('val',s_e,'col',10,'row',1,'val',  'tasks' );
      
      [okay,s_e] = ausgabe_excel('format',s_e,'font_size',10)
      for i=1:length(desc_files)
        
        S =  tacc_description_file_in_excel_help_string(desc_files{i});
        izeile = i+1;
        [okay,s_e] = ausgabe_excel('val',s_e,'col',1,'row',izeile,'val',  S.date );
        [okay,s_e] = ausgabe_excel('val',s_e,'col',2,'row',izeile,'val',  S.time );
        [okay,s_e] = ausgabe_excel('val',s_e,'col',3,'row',izeile,'val',  S.measurement );
        [okay,s_e] = ausgabe_excel('val',s_e,'col',4,'row',izeile,'val',  S.comment );
        [okay,s_e] = ausgabe_excel('val',s_e,'col',5,'row',izeile,'val',  S.maxspeed );
        [okay,s_e] = ausgabe_excel('val',s_e,'col',6,'row',izeile,'val',  S.driver );
        [okay,s_e] = ausgabe_excel('val',s_e,'col',7,'row',izeile,'val',  S.car );
        [okay,s_e] = ausgabe_excel('val',s_e,'col',8,'row',izeile,'val',  S.scenario );
        [okay,s_e] = ausgabe_excel('val',s_e,'col',9,'row',izeile,'val',  desc_files{i} );
        [okay,s_e] = ausgabe_excel('val',s_e,'col',10,'row',izeile,'val',  S.tasks );
      end
      [okay,s_e] = ausgabe_excel('format',s_e,'col',[1:10],'row',[1:izeile] ...
                          ,'col_width','auto','row_height','auto','border','all');
                        
      

      [okay,s_e] = ausgabe_excel('save',s_e,'name','tacc_description');
      cd(org_path);

  end

end
function S =  tacc_description_file_in_excel_help_string(file_name) 
  S.measurement = '';
  S.car         = '';
  S.scenario = '';
  S.location = '';
  S.driver = '';
  S.maxspeed = '';
  S.date = '';
  S.time = '';
  S.tasks = '';
  S.comment = '';
  [okay,c_lines,nzeilen] = read_ascii_file(file_name);
  if( okay )
    for i=1:nzeilen
      
      i0 = str_find_f(c_lines{i},'measurement:','vs');
      if( i0 > 0 )
        i0 = i0 + length('measurement:');
        name = c_lines{i}(i0:length(c_lines{i}));
        S.measurement=str_cut_ae_f(name,' ');
      end
      i0 = str_find_f(c_lines{i},'Car:','vs');
      if( i0 == 1 )
        i0 = i0 + length('Car:');
        name = c_lines{i}(i0:length(c_lines{i}));
        S.car=str_cut_ae_f(name,' ');
      end
      i0 = str_find_f(c_lines{i},'Scenario:','vs');
      if( i0 == 1 )
        i0 = i0 + length('Scenario:');
        name = c_lines{i}(i0:length(c_lines{i}));
        S.scenario=str_cut_ae_f(name,' ');
      end
      i0 = str_find_f(c_lines{i},'Location:','vs');
      if( i0 == 1 )
        i0 = i0 + length('Location:');
        name = c_lines{i}(i0:length(c_lines{i}));
        S.location=str_cut_ae_f(name,' ');
      end
      i0 = str_find_f(c_lines{i},'Driver:','vs');
      if( i0 == 1 )
        i0 = i0 + length('Driver:');
        name = c_lines{i}(i0:length(c_lines{i}));
        S.driver=str_cut_ae_f(name,' ');
      end
      i0 = str_find_f(c_lines{i},'MaxSpeed:','vs');
      if( i0 == 1 )
        i0 = i0 + length('MaxSpeed:');
        name = c_lines{i}(i0:length(c_lines{i}));
        S.maxspeed=str_cut_ae_f(name,' ');
      end
      i0 = str_find_f(c_lines{i},'Date:','vs');
      if( i0 == 1 )
        i0 = i0 + length('Date:');
        textin = c_lines{i}(i0:length(c_lines{i}));
        [c_names,icount] = str_split(textin,'_');
        if( icount > 0 )
          S.date=str_cut_ae_f(c_names{1},' ');
        end
        if( icount > 1 )
          S.time=str_cut_ae_f(c_names{2},' ');
        end
      end
      i0 = str_find_f(c_lines{i},'Tasks:','vs');
      if( i0 == 1 )
        i0 = i0 + length('Tasks:');
        name = c_lines{i}(i0:length(c_lines{i}));
        S.tasks=str_cut_ae_f(name,' ');
      end
      i0 = str_find_f(c_lines{i},'---- comment ----','vs');
      if( i0 > 0 )
        comment = '';
        for j=i+1:nzeilen
          comment = [comment,str_cut_ae_f(c_lines{j},' ')];
          comment = [comment,'/'];
        end
        S.comment=str_cut_ae_f(comment,' ');
        break;
      end
    end
  end
end
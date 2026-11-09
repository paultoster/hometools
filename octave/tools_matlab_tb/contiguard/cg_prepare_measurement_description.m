function S =  cg_prepare_measurement_description(file_name)
%
% S =  cg_prepare_measurement_description(file_name)
%
% Liest Daten aus description-file aus
%
%   S.measurement
%   S.car        
%   S.scenario 
%   S.location 
%   S.driver
%   S.maxspeed
%   S.date
%   S.time
%   S.tasks
%   S.comment

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

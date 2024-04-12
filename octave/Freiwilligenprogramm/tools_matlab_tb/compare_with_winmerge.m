function compare_with_winmerge(base_path_1,file_list_1,base_path_2,file_list_2,prog_file)
%
% CompareWithWinMerge(base_path_1,file_list_1,base_path_2,file_list_2,prog_file)
%
% compares file_list_1(cell) and  base_path_1(char) with file_list_2(cell) and  base_path_2(char)
% using prog_file
% with '~', use same filename
%
% f.e:
% base_path_1 = 'D:\Grid\Grid_trunk\src\TrainParkLearn';
% file_list_1 = { 'caf2AlgoTPL.cpp' ...
%                , 'visuOpenGL.cpp' ...
%               , 'algo\trainParkLearnRecordAndTrigger.cpp' ...
%               };
% base_path_2 = 'D:\Grid\Grid_trunk\src\TParkhouseLearn';
% file_list_2 = { 'caf2AlgoTPHL.cpp' ...
%                , '~' ...
%               , 'algo\trainParkhouseLearnRecordAndTrigger.cpp' ...
%               };
% prog_file = 'C:\Program Files (x86)\WinMerge\WinMergeU.exe';
%
  n1 = length(file_list_1);           
  n2 = length(file_list_2);
  n  = min(n1,n2);
  
  for i=1:n
    if( strcmp(file_list_1{i},'~') && ~strcmp(file_list_2{i},'~') )
      file_list_1{i} = file_list_2{i};
    end
    if( strcmp(file_list_2{i},'~') && ~strcmp(file_list_1{i},'~') )
      file_list_2{i} = file_list_1{i};
    end
  end
  

  for i=1:n

    file1 = fullfile(base_path_1,file_list_1{i});
    file2 = fullfile(base_path_2,file_list_2{i});
    sfile1 = str_get_pfe_f(file1);
    sfile2 = str_get_pfe_f(file2);

    if( ~exist(file1,'file') && exist(file2,'file') )
      if( ~exist(sfile1.dir,'dir') )
        mkdir(sfile1.dir);
      end
      [okay,message] = copy_file(file2,file1,0);
      if( ~okay )
        error('%s: %s ',mfilename,message);
      end
    elseif( exist(file1,'file') && ~exist(file2,'file') )
      if( ~exist(sfile2.dir,'dir') )
        mkdir(sfile2.dir);
      end
      [okay,message] = copy_file(file1,file2,0);
      if( ~okay )
        error('%s: %s ',mfilename,message);
      end
    elseif( ~exist(file1,'file') && ~exist(file2,'file') )
      error('%s: file1(%i) = ''%s'' and file2(%i) = ''%s''  does not exist',i,file1,i,file2);
    end

  end
  s_frage.c_liste = cell(n+1,1);
  for i=1:n
    s_frage.c_liste{i} = [file_list_1{i},' / ',file_list_2{i}];
  end
  s_frage.c_liste{n+1} = 'ende';
  s_frage.frage  = 'Welche beiden Dateie vergleichen';
  s_frage.single = 1;

  selection = 0;

  while( selection(1)  ~= n+1 )
    [okay,selection] = o_abfragen_listbox_f(s_frage);
    if( okay && (selection(1)  ~= n+1) )

      file1 = fullfile(base_path_1,file_list_1{selection(1)});
      file2 = fullfile(base_path_2,file_list_2{selection(1)});

      command  = ['"',prog_file,'"' ...
                 ,' "',file1,'"' ...
                 ,' "',file2,'"' ...
                 ];
      [status,result] = dos(command);
    else
      selection(1)  = n+1;
    end
  end

  fprintf('--- Ende -----\n');
end






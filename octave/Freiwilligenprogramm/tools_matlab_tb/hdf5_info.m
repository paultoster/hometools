function hdf5_info(hdf5file)
%
% hdf5_info(hdf5file)
% Schreibt alle Infos in ein execel-File
%
if( ~exist('hdf5file','var') )
  s_frage.comment='HDF5-Datei (*.hdf5)';
  s_frage.file_spec='*.hdf5';
  s_frage.file_number=1;
                            
  [okay,c_filenames] = o_abfragen_files_f(s_frage);
  
  if( okay )
    hdf5file = c_filenames{1};
  else
    hdf5file = '';
  end
end

try
  fi = hdf5info(hdf5file);
catch
  error('Datei <%s> konnte nicht eingelesen werden !!',hdf5file)
end

ndset = length(fi.GroupHierarchy.Datasets);

CName = cell(ndset,1);
CClass = cell(ndset,1);
CRead = cell(ndset,1);
Csize = cell(ndset,1);
CMatClass = cell(ndset,1);


for i=1:ndset
  
  CName{i}   = fi.GroupHierarchy.Datasets(i).Name;
  CClass{i}  = fi.GroupHierarchy.Datasets(i).Datatype.Class;
  
  try
    dset = hdf5read(fi.GroupHierarchy.Datasets(i));
    Cread{i} = 1;
  catch
    Cread{i} = 0;
  end
  a=whos('dset');
  
  Csize{i} = num2str(a.size);
  CMatClass{i} = a.class;
  
  
end


okay = o_ausgabe_tabelle_f('vec_list',{CName,CClass,Cread,Csize,CMatClass} ...
                           ,'name_list',{'Name','class','read','size','matclass'} ...
                           ,'title',fi.GroupHierarchy.Filename ...
                           ,'screen_flag',0 ...
                           ,'excel_file','hdf5Output')
  
  
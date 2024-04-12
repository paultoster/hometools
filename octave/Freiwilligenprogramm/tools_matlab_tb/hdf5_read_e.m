function e = hdf5_read_e(hdf5file,change_name_list)
%
% e = hdf5_read_e(hdf5file)
% e = hdf5_read_e(hdf5file,change_name_list)
%
% hdf5file         char   hdf5-Datei
% change_name_list cell   Liste mit Orginalnamen und Änderungen (  Matlab
%                         nimmt nur Namen bis 63 Zeichen )
%                         change_name_list{i}{1} => Orginalname
%                         change_name_list{i}{2} => Eintauschname
%                         {{'abcdef','ab_de'},{'BlaBalBal','BBB'}, ...}
%                     
% e.(name).time    double Vektor mit Zeit
% e.(name).vec     double Vektor mit Werten
% e.(name).unit    char   Einheit aus Dbc

  if( ~exist('hdf5file','var') )
    
    s_frage.comment   = 'hdf5file aussuchen';
    s_frage.file_spec = '*.hdf5';
    if( qlast_exist(1) )
      s_frage.start_dir      = qlast_get(1);
    else
      s_frage.start_dir      = 'D:\mess';
    end
    s_frage.file_number      = 1;

    [okay,c_filenames] = o_abfragen_files_f(s_frage);
    if( okay )
      s_file   = str_get_pfe_f(c_filenames{1});
      hdf5file = s_file.fullfile;
      qlast_set(1,s_file.dir);
    else
      error('hdf5file Name nicht vorhanden')
    end
    
  end
  if( exist('change_name_list','var') )
    use_change_name_list = 1;
    n_change_name_list   = length(change_name_list);
  else
    use_change_name_list = 0;
  end
  try
    fi = hdf5info(hdf5file);
  catch
    error('Datei <%s> konnte nicht eingelesen werden !!',hdf5file)
  end

  e = struct;
  ie = 0;

  ndset = length(fi.GroupHierarchy.Datasets);

  name_liste = cell(ndset,1);

  for i=1:ndset

    name          = fi.GroupHierarchy.Datasets(i).Name;
    
    name          = str_cut_a_f(name,'/');
    name          = str_change_f(name,' ','_');
    name          = str_change_f(name,'(','_');
    name          = str_change_f(name,')','_');
    name_liste{i} = str_change_f(name,'.','_');

  end

  S = hdf5_read_e_name_groups(name_liste,ndset);

  for i=1:length(S)
    
    if( strcmp(S(i).name,'HAPSVehDsrdTraj_speed_mBuffer_1_direction') )
      a = 0;
    end
      
    try
      dset_t = hdf5read(fi.GroupHierarchy.Datasets(S(i).index(1)));
      dset_v = hdf5read(fi.GroupHierarchy.Datasets(S(i).index(2)));
      flag = 1;
    catch
      flag = 0;
    end
  
    [nt,mt] = size(dset_t);
    if( nt < mt )
      a = nt;
      nt = mt;
      mt = a;
      dset_t = dset_t';
    end
    [nv,mv] = size(dset_v);
    if( nv < mv )
      a = nv;
      nv = mv;
      mv = a;
      dset_v = dset_v';
    end
    n = min(nt,nv);
    m = 1;
    
    if( flag )
      if( use_change_name_list ) 
        for j=1:n_change_name_list
          newname = str_change_f(S(i).name,change_name_list{j}{1},change_name_list{j}{2});
          if( ~strcmp(S(i).name,newname) )
            break;
          end
        end
      else
        newname = S(i).name;
      end
      e.(newname).time = dset_t(1:n,1);
      e.(newname).vec  = dset_v(1:n,1);
      e.(newname).unit = '';
    end
      
  end
end
function S = hdf5_read_e_name_groups(name_liste,ndset)
  S = struct;
  iS = 0;
  for i=1:ndset

    name = name_liste{i};


    ifound = length(name)-str_find_f(name,'_time','rs');
    if( ifound ~= 4 )
      if( strcmp([name,'_time'],name_liste{min(ndset,i+1)}) )
        ifound = i+1;
      else
        ifound = cell_find_f(name_liste,[name,'_time'],'f');
      end
      if( ifound )
        iS = iS+1;
        S(iS).name = name;
        S(iS).index = [ifound,i];
      end
    end
  end
end
    
  
  


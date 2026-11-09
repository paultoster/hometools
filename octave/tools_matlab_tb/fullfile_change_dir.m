function new_fullfilename = fullfile_change_dir(fullfilename,new_dir,old_dir)
%
% new_fullfilename = fullfile_change_dir(fullfilename,new_dir)
% oder
% new_fullfilename = fullfile_change_dir(fullfilename,new_dir,old_dir)
%
% Wechselt directory aus dem vollen Filenamen aus
% oder
% Wechselt aus fullfilename old_dir mit new_dir 
% z.B.  fullfile_change_dir('D:\VPU\matlab\sonst\input.dat','D:\MODUL\matlab','D:\VPU\matlab')
%
  s_file = str_get_pfe_f(fullfilename);
  if( ~exist('old_dir','var') )
    new_fullfilename = fullfile(new_dir,[s_file.name,'.',s_file.ext]);
  else
    c0 = str_split(s_file.dir,filesep);
    c1 = str_split(old_dir,filesep);
    
    n0 = length(c0);
    n1 = length(c1);
    for i=1:n1
        if( ~strcmpi(c0{i},c1{i}) )
            for j=i:n0
                new_dir = fullfile(new_dir,c0{j});
            end
            break;
        elseif( i == n1 )
            for j=i+1:n0
                new_dir = fullfile(new_dir,c0{j});
            end
            break;
        end
    end
    new_fullfilename = fullfile(new_dir,[s_file.name,'.',s_file.ext]);
  end
end

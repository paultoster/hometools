function s_files = suche_files_ext(c_dir,ext_name,c_neg_liste)
%
% s_files = suche_files_ext(c_dir,ext_name,c_neg_liste)
%
% c_dir             cellarray mit allen zu durchsuchenden Pfaden
% ext_name          extension, die zu suchen ist
% c_neg_liste       cellarray mit ausnahmen (muß nicht gesetzt werden)
%
% Ergebnis:
% s_files(i).dir    Verzeichnis zB 'D:\messungen\abc'
% s_files(i).name   DAteiname   zB 'mess0001'
% s_files(i).ext    Extension   zB 'dat'
% s_files(i).fullname
len = 0;

if( ~exist('c_neg_liste','var') )
    c_neg_liste = {};
elseif( ischar(c_neg_liste) )
    c_neg_liste = {c_neg_liste};
end

if( ischar(c_dir) )
    c_dir = {c_dir};
end

if( iscell(ext_name) )
    ext_name = ext_name{1};
end
ext_name  = str_cut_ae_f(ext_name,' ');
if( ext_name(1) == '.' )
    ext_name = ext_name(2:length(ext_name));
end
for i=1:length(c_dir)

    liste = dir(c_dir{i});
    
    for j=1:length(liste) 
      s_file = str_get_pfe_f(liste(j).name);
      name   = s_file.name;
      ext    = s_file.ext;
        
      if( ~liste(j).isdir && (strcmpi(ext,ext_name) || strcmp(ext_name,'*')) )
          len = len+1;
          s_files(len).dir      = char(c_dir{i});
          s_files(len).name     = name;
          s_files(len).ext      = ext_name;
          s_files(len).fullname = [char(c_dir{i}),'\',name,'.',ext_name];
      end
    end
end

if( ~exist('s_files') )
    s_files=[];
end

if( length(c_neg_liste) > 0 )

    iss = 0;
    s_files1 = [];
    for i=1:length(s_files)
        
        flag = 1;
        
        for j=1:length(c_neg_liste) 
            
            if(  strcmp(s_files(i).dir,c_neg_liste{j}) ...
              || strcmp(s_files(i).name,c_neg_liste{j}) ...
              || strcmp(s_files(i).fullname,c_neg_liste{j}) ...
              )
                flag = 0;
                break;
            end
        end
        if( flag )
            iss = iss+1;
            if( iss == 1 )
              s_files1 = s_files(i);
            else
              s_files1(iss) = s_files(i);
            end
        end
    end
    s_files = s_files1;
end
    
    

    


function c_sub = s_subpathes_f(c_dir_list)
%
% c_sub = s_subpathes_f(c_dir_list)
% 
% c_dir_list      cell/char     Verzeichnisliste
% c_sub            cell         alle Unterverzeichnisse
%
%

if( ischar(c_dir_list) )
    c_dir_list = {c_dir_list};
end
c_sub = {};
for i=1:length(c_dir_list)
    c_sub1 = subdir(c_dir_list{i},'paths');
    len = length(c_sub);
    for j=1:length(c_sub1)
        len = len+1;
        c_sub{len} = c_sub1{j};
    end
end
double_flag = zeros(length(c_sub),1);
for i=1:length(c_sub)
    for j=i+1:length(c_sub)
        if( strcmp(c_sub(i),c_sub(j)) )
            double_flag(j) = 1;
        end
    end
end
if( max(double_flag) > 0 )
	c_sub1 = c_sub;
	c_sub = {};
	j = 0;
	for i=1:length(c_sub1)
        if( ~double_flag(i) )
            j = j+1;
            c_sub{j} = c_sub1{i};
        end
	end
end            
function sub = subdir (pth,para,sub)
% SUBDIR List all subdirectorys and/or files under given folder
%    
% EXAMPLES:
%    D = SUBDIR
%        returns all subfolder and all files under current path.
%
%    D = SUBDIR('directory_name') 
%        returns the results in an structure with the fields: 
%           paths  --  all subfolder
%           files  --  all files in all subfolders
%
%    D = SUBDIR('directory_name','files') 
%        returns only files in all subfolder.  
%        use sort([D{:}]) to get sorted list of output
% 
%    D = SUBDIR('directory_name','paths')  
%        returns subfolder only.
%        use sort([D{:}]) to get sorted list of output
 %
% author:  Elmar Tarajan [MCommander@gmx.de]
% version: 1.0 
% date:    06-Mar-2002
% 
switch nargin
case 0
   sub = subdir (cd,'filespaths');
    
case 1 
   sub = subdir (pth,'filespaths');
   
case 2
   sub = '';
   pth = char(pth);
   switch para
   case {'filespaths' 'files' 'paths'}
      if exist(pth)==7
         sub.paths = {pth};
         sub.files = '';
         sub = subdir (pth,para,sub);
         if ~strcmp(para,'filespaths')
            eval(['sub = sub.' para ';']);
         end% if
      else
         disp('Name is nonexistent or not a directory');
      end% if
   otherwise
      disp('Wrong input parameter');
   end% switch
   
case 3
   a = dir(pth);
   b = a([a.isdir]);
   if findstr(para,'files')
      c = a(~[a.isdir]);
      sub.files{end+1} = {c.name};
   end% if
   for i=1 : length(b)
      if ~strcmp(b(i).name,'.') & ~strcmp(b(i).name,'..')
         sub.paths{end+1} = [pth filesep b(i).name];
         sub = subdir ([pth filesep b(i).name],para,sub);
      end% if
   end% for
  
end% switch   


function okay = diasave(d,u,f,t)
%   okay = diasave(d,[u,f,t])
%   d data structure    z.B. d.xvec = [1:1:100]'; 
%   u unit structure    z.B. u.xvec = 's';
%   f filename          z.B. f = 'output_xvec';
%   t typ 'asc' 'bin'   z.B. t = 'bin';

fprintf('\ndiasave Version 1.0 Start ...\n')

if( nargin==0 )
    fprintf('\diasave(d,u,f,t) or diasave(d,u,f) or diasave(d,f) or diasave(d)\n');
    fprintf('d data structure\n');
    fprintf('u unit structure\n');
    fprintf('f filename\n');
    fprintf('t type ''bin'' or ''ascii''\n');
    fprintf('\n example:\n');
    fprintf(' d.x=[0:0.1:10]'';\n');
    fprintf(' u.x=''sec'';\n');
    fprintf(' f=''output_a'';\n\n');
    return;
end
if( nargin < 2 )

    c_names = fieldnames(d);
    for i=1:length(c_names)
        u.(c_names{i}) = '-';
    end
end
if( nargin < 3 )
    
    f = 'dia_save.dat';
end

if( nargin < 4 )
    
    t = 'bin';
end

if( strcmp(t,'bin') || strcmp(t,'dia') ) % dia ist irgendeine alte Bezeichnung
    
    okay  =  save_dia_mat(d,u,f);
else
    i0 = strfind(f,'.');
    if( ~isempty(i0) )
        i0 = max(i0);
        f = f(1:max(1,i0-1));
    end
    mexSaveDiaAsc(d,u,f);
end

fprintf('\n... End diasave\n')

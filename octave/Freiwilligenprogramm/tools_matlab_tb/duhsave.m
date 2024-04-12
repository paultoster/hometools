function okay = duhsave(d,u,h,f)
%
%   okay = duhsave(d,u,f) oder diasave(d,u,f) or diasave(d,f) or diasave(d)
%
%   d data structure    z.B. d.xvec = [1:1:100]'; 
%   u unit structure    z.B. u.xvec = 's';
%   h header cellarray  z.B. h = {'erstellt mit porgram xy'};
%   f filename          z.B. f = 'output_xvec';

if( ~exist('d','var' ) )
    error('Keine Daten-Struktur übergeben');
elseif( ~isstruct(d) )
    error('Keine d ist keine Daten-Struktur d.a,d.b etc');
end

if( ~exist('u','var') )
    
    cs = filednames(d);
    
    for i=1:length(cs)
        u.(cs{i}) = '';
    end
end
if( ~exist('h','var') )
    h = {};
end    
if( ~exist('h','var') )
    f = '';
end

if( length(f) == 0 )
    	    s_frage.comment        = 'mat-File für duh-Datenformat  (z.B. duh_xyz.mat)';
			s_frage.file_spec      = '*.mat';
			s_frage.file_number    = 1;
            s_frage.put_file       = 1;

  			okay = o_abfragen_files_f(s_frage);
            
            if( ~okay )
                
                error('Irgendaws ging schief mit dem Dateiname wählen')
            end
end

s_data.d = d;
s_data.u = u;
s_data.h = h;
okay = duh_daten_speichern_format(s_data,f,'duh');


function fout = OpenOutFiles(pname)
% fout = OpenOutFiles(pname) opens output file
% pname.out 

filename = [pname '.' 'out'];
eval(['diary ' filename]); 
type setSpecs; diary off;

[fout,message] = fopen(filename,'a');
if fout == -1 
     fprintf([filename,': ', message, '\n'])
end

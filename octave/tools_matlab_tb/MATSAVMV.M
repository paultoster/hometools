%matsavmv.m Multiple Vektor

% TZB/BFR Berthold 3052 4/97

[fid, message] = fopen('test.saa','w');

if fid <= 2
   disp(message)
   return
else
  matsav(fid,'xvek',xvek,1);
  matsav(fid,'yvek',xvek,0);
  matsav(fid,'zvek',xvek,0);
end   
   
fclose(fid);


function flag = dircmpi(dir1,dir2)
%
% flag = dircmpi(dir1,dir2)
%
% Vergleich die Verzeichnisse case unabh‰ngig (groﬂ/klein)
%
  dir1 = str_change_f(dir1,'/','\');
  dir2 = str_change_f(dir2,'/','\');
  flag = strcmpi(dir1,dir2);
end
  
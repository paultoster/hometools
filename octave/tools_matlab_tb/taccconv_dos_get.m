function p = taccconv_dos_get
%
% path = taccconv_dos_get
% 
% get echo %TACCCONV% in dos
%

  % TaccConv-Verzeichnis aus Umgebungsvariable auslesen
  %----------------------------------------------------  
  [status,result]=dos('echo %TACCCONV%');
  if( strcmp(str_cut_e_f(result,char(10)),'%TACCCONV%') )
    error('dos-Befehl dos(''echo %TACCCONV%'') konnt nicht abgesetzt werden')
  end
  ll = length(result);
  if( round(double(result(ll))) == 10 ) % das return-Zeichen rausnehmen
    result = result(1:max(1,ll-1));
  end
  if( strcmp(result,'%TACCCONV%') )
    error('TACCCONV-Envrionment-Variable kann nicht gelesen werden\nDie Umgebungsvariable TACCCONV mit dem Verzeichnis des installierten TaccConv-Programm muss gesetzt werden \n(C:\>reg add HKCU\Environment /v TACCONV /d "C:\Program Files (x86)\TaccConv" /f')
  else
    p = fullfile(result);
  end

end
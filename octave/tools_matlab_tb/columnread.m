function [okay, csignals, message] = columnread( file_name,cformat,delim)
%
% [okay, csignals, message] = columnread( file_name[,cformat,delim])
% [okay, csignals]          = columnread( file_name[,cformat,delim])
%
% file_name              char     nodefault     Dateiname
% cformat                cell     {'char',...}  Gibt an welches Format und
%                                               über die Länge wieviel
%                                               {frmtcol1,frmtcol2,....}
%                                               frmt = 'num' Numerisch
%                                                    = 'char' string
%                                                    = '%20.1f' format
% delim                  char     ' '           begrenzung zwischen den
%                                               Spalten
%
% okay                   0/1      war nicht/war okay
% csignals               cell     cellarray mit den Signalen vec = csignals{i}
%
  okay = 1;
  message = '';
  csignals = {};
  
  if( ~exist('delim','var') )
    delim = ' ';
  end
  delimdelim = [delim,delim];
  
  if( ~exist('cformat','var') )
    nofrmt = 1;
  else
    ncformat = length(cformat);
    nofrmt   = 0;
  end
  
  [ okay,c_lines,nzeilen ] = read_ascii_file( file_name );
  if( ~okay )
    message = sprintf('%s: Die Datei <%s> konnte nicht eingelesen werden',mfilename,file_name);
    return
  end
  
  if( nofrmt )
      text_new = str_change_f(c_lines{1},delimdelim,delim,'a');
      text_new = str_cut_ae_f(text_new,delim);
      [c_names,ncformat] = str_split(text_new,delim);
      cformat            = cell(1,ncformat);
      for i=1:ncformat
        cformat{i} = 'char';
      end
  end
  
  csignals = cell(1,ncformat);
  
  for i=1:nzeilen
    text_new = c_lines{i};
    if( strcmp(delim,' ') )
      text_new = str_change_f(text_new,sprintf('\t'),delim,'a');  
    end
    text_new = str_change_f(text_new,delimdelim,delim,'a');
    text_new = str_cut_ae_f(text_new,delim);
    [cin,n] = str_split(text_new,delim);
    
    if( n == ncformat )
      for j=1:ncformat
        
        if( strcmpi(cformat{j},'num') )
         try
            csignals{j}(i) = str2double(cin{j});
         catch exeption
            throw(exception)
         end
        elseif( cformat{j}(1) == '%' )
         try
            csignals{j}(i) = sprintf(cformat{j},cin{j});
         catch exeption
            throw(exception)
         end
        else % char
         csignals{j}(i) = cin{j};
        end
      end
    end
  end
          
    
      
  
  
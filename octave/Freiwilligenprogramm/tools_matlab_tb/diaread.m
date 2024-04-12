function [d,u,f,h]=diaread(filename,com_flag,mexRead)
% DIAREAD Einlesen der von RTAS im DIA-Format geschriebenen Daten
%  <c> 2001 by Continental Teves AG & Co. oHG
%
%      Normaler Aufruf:
%        d=diaread
%        d=diaread(filename)
%
%      Mit zusätzlichen Ausgabeargumenten:
%        [d,u]=diaread(filename)
%        [d,u,f]=diaread(filename)
%        [d,u,f,h]=diaread(filename)
%
%      Eingabeargument: filename (optional)
%         Es ist hier der Name des '.dat'-Files anzugeben.
%         Das Argument kann weggelassen werden, der Filename wird dann mit einem 
%         Dialogfenster erfragt.
%
%      Ausgabeargumente 
%         d: struct mit allen im Datenfile gefundenen Kanälen
%         u: dazugehörige Einheiten
%         f: verwendeter Dateiname
%         h: alle Header-Informationen
%
%       Das DIA-Format wird mit dieser Routine nicht vollständig
%       abgedeckt, aber alles was von RTAS kommt (int16 oder int32).
%       und auch von ITT-DAS, wenn Kanal 1 implizit z.B. die Zeit darstellt
%       Motorola oder Intel Format

% E. Kloppenburg, ITK-Consulting, Sep-1999 V1.0
% Andreas Neu, ITK-Consulting, Juni-2000 V1.1
% Thomas Alban, Teves, TZS, Juni-2000 V1.2:  (Änderungen gekennzeichnet durch %###)
%        1) implizite Datenkanäle werden berechnet ! Korrektheit prüfen
%        2) Kanalnamen mit Umlauten o.ä. werden umbenannt
%        3) fclose des Datenfiles
% Andreas Neu, ITK-Consulting, Juli 2000 V1.3
%        Bei der Verwendung von LocalGetValue wird der Erfolg geprüft und ggf 
%        offene Dateien geschlossen und diaread beendet
% TBert 25.8.00 V1.4
%        Umorganisiert: Formate INT16,INT32,REAL32,REAL64,ASCII
%                               BLOCK,CHANNNEL,
%                               IMPLIZIT,EXPLIZIT
%                       können gelesen werden
%                       Blockweise in ascii einzulesen deuert exterm lange
% TBert 21.11.00 V1.41
%        Da es Probleme mit dem Token 221 gegeben hat (Er sollte nicht null
%        sein, da die Posistion und kein Offset verlangt wird, wird dies abgefabgen
%
% J. Leideck 12.03.01 V1.42
%        Diaread mußte immer im Verzeichnis der einzulesenden Daten stehen.
%        Dieser Nachteil wurde behoben.
%
% TBert 12.11.01 V1.43
%       Dateiname, Header anzeigen
% TBert 28.05.02 V1.44
%       Dateiname, Header anzeigen

if( nargin < 2 )
   com_flag = 1;
end

if( nargin < 3 )
   mexRead = 0;
end


% '.dat'-Datei wählen, wenn kein Eingabeargument
if( com_flag )
    fprintf('\ndiaread Version 1.44 Start ...')
    fprintf('\n[d,u,f,h]=diaread(filename)')
    fprintf('\nd: struct mit allen im Datenfile gefundenen Kanälen')
    fprintf('\nu: dazugehörige Einheiten')
    fprintf('\nf: verwendeter Dateiname')
    fprintf('\nh: alle Header-Informationen')
end

d={};
u={};
lastfile_bb = ' ';
dataread_bb = 0;
lastfile_ba = ' ';
dataread_ba = 0;
lastfile_ka = ' ';
dataread_ka = 0;
lastfile_first = ' ';
dataread_first = 0;
first_offset = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dat-Datei auswählen und öffnen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
OriginalPathName = cd;
if nargin==0 | (nargin>=1 & isempty(remblank(filename)))
   [file,path]=uigetfile('*.dat','Datei auswählen');
   if file==0
     d = 0;
     u = 0;
     f = 0;
     h = {};
     return
   end
   filename=[path, file];
else
    path = extract_path(filename);
end
if( com_flag )
    fprintf('\ncd(%s)',path);
end
cd (path);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if nargout>2
   f=filename;
end

hfilename=extract_file(filename);

% '.dat'-Datei öffnen
if( com_flag )
    fprintf('\n[d,u,f,h]=diaread(''%s'')',hfilename);
end

% mit neuer dll einlesen
%========================
if( mexRead )

		[d0,u0,f0,h0] = mexReadData(1,f);

		if( nargout>0 )
			d = d0;
		end
		if( nargout>1 )
			u = u0;
		end
		if( nargout>2 )
			f = f0;
		end
		if( nargout>3 )
			h = h0;
		end
		return
end
		
[fid,message]=fopen(hfilename,'rt');
if fid==-1
   error(message)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% globalen Header auswerten
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Anfang des globalen Headers suchen 
line = fgetl(fid);
while ~LocalCheckLine(line,'#BEGINGLOBALHEADER');
   line = fgetl(fid);
end

% Globalen Header einlesen
headers.global=LocalReadHeader(fid,'#ENDGLOBALHEADER');

[header_info, success] = LocalGetVal(headers.global,'101');
if success & com_flag 
    fprintf('\n                 Header Info: %s\n\n',header_info)
end

% ABS-Funktion Automatic Byte Swapping %an/ITK 15.5.2000
[bs, success] = LocalGetVal(headers.global,'112');% ByteSex
if success == 0
   fclose(fid);
   error(['Kann token: >112< nicht in -.dat Datei finden'])
end
if ~isempty(findstr(bs,'Low -> High'))				% ByteSexCharacter
   bsc='b';
elseif ~isempty(findstr(bs,'High -> Low'))
	bsc='l';   
else
   fprintf('Warning: Unbekannter ByteSex:  %s, Fahre fort mit Big Endian - Motorola\n',bs)
   bsc='b';
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Alle Channelheader einlesen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i=0;
while isstr(line)
   % Solange noch nicht Fileende
   
   % Anfang suchen (eigentlich nicht nötig, da immer in der nächsten Zeile)
   line = fgetl(fid);
   while isstr(line) & ~LocalCheckLine(line,'#BEGINCHANNELHEADER');
      line = fgetl(fid);
   end
   
   if isstr(line)
      % nicht EOF
      i=i+1;
      % headers.channel ist ein cell-array, dessen Elemente wieder cell-arrays sind
      headers.channel{i}=LocalReadHeader(fid,'#ENDCHANNELHEADER');
      % oder h.channel{i}.h=... -- egal
   end
      
end

nchannel = i;

% '.dat'-Datei wieder schließen
fclose(fid);

if nargout>3
   h=headers;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Alle Channels einlesen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:nchannel
   
   %
   % Name suchen
   %
   [name, success] = LocalGetVal(headers.channel{i},'200');
   %name=sscanf(name,'%s',1);
   name=remblank(name);
   if (success == 0)
		if exist('dfid','var'),fclose(dfid);end;
      disp(sprintf('Error_diaread: Kanal %i ',i))
	   error(['Kann token: >200< nicht in -.dat Datei finden'])
   end
   
   % Test if the name is o.k for Matlab struct   
   if (~is_channelname_ok(name)),
         disp(sprintf('* name of channel %i (%s) changed to Ch%i', i, name, i));
         name = ['Ch' num2str(i)];
	end      
   
   %
   % Einheit suchen
   %
   [einheit, success]       = LocalGetVal(headers.channel{i},'202');
   if success == 0
		if exist('dfid','var'),fclose(dfid);end;
      disp(sprintf('Warning_diaread: Kanal %i, kann keine Einheit finden, setze  unbekannt ',i));
	   einheit = 'unbekannt';
	end
   
   %
   % Explizit oder Implizit ?
   %
   is_implizit = 0;
	implizit = LocalGetVal(headers.channel{i}, '210');
   if ~isempty(findstr(implizit,'IMPLIZIT')) | ~isempty(findstr(implizit,'IMPLICIT'))
      is_implizit = 1;
   end
   
   %%%%%%%%%%%%%%%%%%%%%%
   % Implizite Berechnung
   %%%%%%%%%%%%%%%%%%%%%%
   if is_implizit == 1
      
      %
      % Startwert
      %
      [str, success]=LocalGetVal(headers.channel{i},'240');
      if success == 0
         disp(sprintf('Error_diaread: Kanal %i ',i))
         error(['Kann token: >240< nicht in -.dat Datei finden'])
      end
      val0  = str2num(str);
      %
      % Schrittweite
      %
      [str, success]=LocalGetVal(headers.channel{i},'241');
      if success == 0
         disp(sprintf('Error_diaread: Kanal %i ',i))
         error(['Kann token: >241< nicht in -.dat Datei finden'])
      end
      del_val = str2num(str);
      %
      % Anzahl der Werte
      %
      [str, success]=LocalGetVal(headers.channel{i},'220');
      if success == 0
         disp(sprintf('Error_diaread: Kanal %i ',i))
         error(['Kann token: >220< nicht in -.dat Datei finden'])
      end
      nval = str2num(str);
      
      %
      % lokaler Vektor erstellen
      %
      val=[0:1:nval-1]';
      val=val*del_val+val0;
      
   %%%%%%%%%%%%%%%%%%%%%%
   % Explizite Berechnung
   %%%%%%%%%%%%%%%%%%%%%%
	else
      
      %
      % Datenformat bestimmen
      %
      [dformat, success]=LocalGetVal(headers.channel{i},'214');
      if success == 0
  		   if exist('dfid','var'),fclose(dfid);end;
         disp(sprintf('Error_diaread: Kanal %i ',i))
         error(['Kann token: >214< nicht in -.dat Datei finden'])
      end

      is_ascii=0;
      if strcmp(dformat,'INT16')
         readformat='int16';
	      BytesPerValue = 2;   
      elseif strcmp(dformat,'INT32')
         readformat='int32';
         BytesPerValue = 4;
      elseif strcmp(dformat,'WORD8')
         readformat='uint8';
         BytesPerValue = 1;
      elseif strcmp(dformat,'REAL32')
         readformat='float32';
         BytesPerValue = 4;
      elseif strcmp(dformat,'REAL64')
         readformat='float64';
         BytesPerValue = 8;
      elseif strcmp(dformat,'ASCII')
         is_ascii = 1;
         readformat=' ';
         BytesPerValue = 8;
      else
  		   if exist('dfid','var'),fclose(dfid);end;
         disp(sprintf('Error_diaread: Kanal %i ',i))
         error(['Unbekanntes Datenformat: ', dformat])
      end
      
      %
      % Block oder Channel orientierung?
      %
      [BlockOrChannel,succes]  = LocalGetVal(headers.channel{i}, '213');
      if success == 0
  		   if exist('dfid','var'),fclose(dfid);end;
         disp(sprintf('Error_diaread: Kanal %i ',i))
         error(['Kann token: >213< nicht in -.dat Datei finden'])
      end
      is_block = 0;
      if ~isempty(findstr(BlockOrChannel, 'BLOCK'))
         is_block = 1;
      end
      
      %
      % Name des Datenfiles: 
      %
      [dfilename, success]=LocalGetVal(headers.channel{i},'211');
      if success == 0
         disp(sprintf('Error_diaread: Kanal %i ',i))
         error(['Kann token: >211< nicht in -.dat Datei finden'])
      end
      
      %
      % Datenfile öffnen (little or big endian, bsc)
      %
      if is_ascii == 1
         [dfid,message]=fopen(dfilename,'r');
      else
          [dfid,message]=fopen(dfilename,'r',bsc);
      end

      if dfid==-1
        disp(sprintf('Error_diaread: Öffnen des Datenfiles: '))
        disp(dfilename)
        error(message)
      end
     
      
      %
      % Offset bestimmen
      %
      [str, success] =LocalGetVal(headers.channel{i},'240');
      if success == 0
			if exist('dfid','var'),fclose(dfid);end;
         disp(sprintf('Error_diaread: Kanal %i ',i))
		   error(['Kann token: >240< nicht in -.dat Datei finden'])
		end
      offset = str2num(str);
      
      %
      % Skalierung bestimmen
      %
      [str, success]   =LocalGetVal(headers.channel{i},'241');
      if success == 0
			if exist('dfid','var'),fclose(dfid);end;
         disp(sprintf('Error_diaread: Kanal %i ',i))
		   error(['Kann token: >241< nicht in -.dat Datei finden'])
		end
      skal = str2num(str);
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%
      % Explizit + Block einlese%
      %%%%%%%%%%%%%%%%%%%%%%%%%%%
      if is_block == 1
         
         %
         % Anzahll Werte bestimmen
         %
         [str,succes]  = LocalGetVal(headers.channel{i}, '220');
         if success == 0
  		      if exist('dfid','var'),fclose(dfid);end;
            disp(sprintf('Error_diaread: Kanal %i ',i))
            error(['Kann token: >220< nicht in -.dat Datei finden'])
         end
         nval = str2num(str);
         
         %
         % erster Wert bestimmen
         %
         [str,succes]  = LocalGetVal(headers.channel{i}, '221');
         if success == 0
  		      if exist('dfid','var'),fclose(dfid);end;
            disp(sprintf('Error_diaread: Kanal %i ',i))
            error(['Kann token: >221< nicht in -.dat Datei finden'])
         end
         first = str2num(str);
         
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         % Explizit + Block + ascii einlese%
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         if is_ascii == 1
            
            %
            % Blockspalte bestimmen
            %
            [str,succes]  = LocalGetVal(headers.channel{i}, '223');
            if success == 0
  		         if exist('dfid','var'),fclose(dfid);end;
               disp(sprintf('Error_diaread: Kanal %i ',i))
               error(['Kann token: >223< nicht in -.dat Datei finden'])
            end
            blockl = str2num(str);
            
            %
            % Seperator bestimmen
            %
            [str,succes]  = LocalGetVal(headers.channel{i}, '230');
            if success == 0
  		         if exist('dfid','var'),fclose(dfid);end;
               disp(sprintf('Error_diaread: Kanal %i ',i))
               error(['Kann token: >230< nicht in -.dat Datei finden'])
            end
            seperator=char(str2num(str));
            
            %
            % Blockdaten einlesen
            %
            if ~(strcmp(lastfile_ba,dfilename) & dataread_ba == 1)
               
               disp('Einlesen Block ascii, kann dauern !!!')
               lastfile_ba=dfilename;
               dataread_ba=1;
               cellstr=textread(dfilename,'%s','delimiter','\n','whitespace','');
               
               if length(cellstr) < nval
                  disp(sprintf('Error_diaread: Kanal %i ',i))
                  disp(sprintf('Datenfile: %s',dfilename))
                  disp(sprintf('geforderte Werte: %i',nval))
                  disp(sprintf('eingelesene Werte: %i',length(cellstr)))
			         if exist('dfid','var'),fclose(dfid);end;
     	            error('nicht genug Daten gelesen, beim Lesen eines Kanales');
               end
               
               clear daten_ab
               str = cell2struct(cellstr(1),'t',1);
               str = sprintf('%s%s%s',seperator,str.t,seperator);
               icount = 0;
               for j=1:length(str)
                  if str(j) == seperator
                     icount = icount +1;
                  end
               end
               
               n1=length(cellstr);
               m1=icount-1;
               daten_ab=zeros(n1,m1);
               
               if m1 < blockl
 	               disp(sprintf('Error_diaread: Kanal %i ',i))
                  disp(sprintf('Datenfile: %s',dfilename))
                  disp(sprintf('geforderte Spalte: %i',blockl))
                  disp(sprintf('eingelesene Spalten: %i',m1))
			         if exist('dfid','var'),fclose(dfid);end;
     	            error('nicht genug Spalten gelesen, beim Lesen des Blockes');
               end
               
               for j=1:length(cellstr)
                  str = cell2struct(cellstr(j),'t',1);
                  str = sprintf('%s%s%s',seperator,str.t,seperator);
                  
                  istart = 1;
                  icount = 0;
                  for k=2:length(str)
                     if str(k) == seperator
                        iend = k;
                        icount = icount+1;
                        if icount > m1
 	                         disp(sprintf('Error_diaread: Kanal %i ',i))
                            disp(sprintf('Datenfile: %s',dfilename))
                            disp(sprintf('Ascii Blockeinlesen Spalte %i von Zeile %i',icount,j))
                            disp(sprintf('ist größer Spalte %i der 1. Zeile',m1))
			                   if exist('dfid','var'),fclose(dfid);end;
     	                      error('Problem');
                        end
                           
                        daten_ab(j,icount)=str2num(str(istart+1:iend-1));
%                        disp(sprintf('j:%i,k:%i,%f',j,icount,daten_ab(j,icount)))
%                        disp(sprintf('j:%i/%i,    k:%i/%i',j,length(cellstr),icount,m1))
                        istart = iend;
                     end
                  end
               end
               
               clear cellstr str
            end
            
            
            %
            % Spalte aus Block auslesen und lokal speichern
            %
%            clear val
%           val=[];
%            for j=1:nval
%               str = cell2struct(cellstr(j),'t',1);
%               str = sprintf('%s%s%s',seperator,str.t,seperator);
%               
%                  disp(sprintf('ch: %i/%i,nval: %i/%i',i,nchannel,j,nval))
%               icount = 0;
%               istart = 0;
%               iend = 0;
%               for k=1:length(str)
%                  if str(k) == seperator   
%                     icount = icount+1;
%                     if icount == blockl
%                        istart = k+1;
%                     elseif icount == blockl+1
%                        iend = k-1;
%                        break;
%                     end
%                  end                  
%               end
%               if istart == 0 | iend == 0
% 	               disp(sprintf('Error_diaread: Kanal %i ',i))
%                  disp(sprintf('geforderte Blockspalte: %i',blockl))
%                  disp(sprintf('gefundene Blockspalten: %i',icount-1))
%			         if exist('dfid','var'),fclose(dfid);end;
%     	            error('Block ist zu klein');
%               end   
%               val = [val,str2num(str(istart:iend))];
%            end
            
%            val=val';
            
             val = daten_ab(:,blockl);

         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         % Explizit + Block + binaer einlese%
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         else
            
            %
            % Blockoffset bestimmen
            %
            [str,succes]  = LocalGetVal(headers.channel{i}, '222');
            if success == 0
  		         if exist('dfid','var'),fclose(dfid);end;
               disp(sprintf('Error_diaread: Kanal %i ',i))
               error(['Kann token: >222< nicht in -.dat Datei finden'])
            end
            blockl = str2num(str);
            
            %
            % Blockdaten einlesen
            %
            if ~(lastfile_bb == dfilename & dataread_bb == 1)
            
               lastfile_bb=dfilename;
               dataread_bb=1;
               daten_bb=fread(dfid,[inf],readformat);
            end
            
            %
            % Blockspalte auslesen in lokale Variable
            %
            val = daten_bb(first:blockl:length(daten_bb));         
         end
         
         %
         % lokale Variable skalieren
         %
         val = val*skal+offset;
         
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % Explizit + Kanalweise einlesen
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      else
         
         %
         % Start Kanal
         %
         [str, success] = LocalGetVal(headers.channel{i},'221');
         if success == 0
   			if exist('dfid','var'),fclose(dfid);end;
            disp(sprintf('Error_diaread: Kanal %i ',i))
				error(['Kann token: >221< nicht in -.dat Datei finden'])
         end
         
         if is_ascii == 1
            first = str2num(str);
         else
            if dataread_first == 0 & ~strcmp(lastfile_first,dfilename)
               dataread_first = 1;
               lastfile_first = dfilename;
               if str2num(str) <= 0
                  first_offset = 0;
               else
                  first_offset = 1;
               end
               
            end
            
            first = (str2num(str) - first_offset) * BytesPerValue;
         end
         
         %
         % Länge Kanal
         %
	      [str, success]=LocalGetVal(headers.channel{i},'220');
         if success == 0
     			if exist('dfid','var'),fclose(dfid);end;

	         disp(sprintf('Error_diaread: Kanal %i ',i))
		      error(['Kann token: >220< nicht in -.dat Datei finden'])
			end
         lkanal = str2num(str);

         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         % Explizit + Kanalweise + ascii
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         if( is_ascii == 1 )
            
            %
            % daten einlesen
            %
            if ~(strcmp(lastfile_ka,dfilename) & dataread_ka == 1)
            
               lastfile_ka=dfilename;
               dataread_ka=1;
               [daten_ka,count] = fscanf(dfid,'%g',[inf]);
               if count < first+lkanal-1
 	               disp(sprintf('Error_diaread: Kanal %i ',i))
                  disp(sprintf('geforderte Werte: %i',first+lkanal-1))
                  disp(sprintf('eingelesene Werte: %i',count))
			         if exist('dfid','var'),fclose(dfid);end;
     	            error('nicht genug Daten gelesen, beim Lesen eines Kanales');
               end
            end
            
            %
            % lokaler Vektor
            %
    
            val = daten_ka(first:1:first+lkanal-1);
            
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         % Explizit + Kanalweise + binaer
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         else
            
            %
            % Set File ptr relativ to begin of file
            %
      	   success = fseek(dfid,first,'bof');
	         if success == -1
				   if exist('dfid','var'),fclose(dfid);end;
 	            disp(sprintf('Error_diaread: Kanal %i ',i))
               error(ferror(dfid));
            end
          
            %
            % Lese Kanal in lokalen Vektor
            %
   	      [val, count] = fread(dfid, lkanal, readformat);
            if count < lkanal
 	            disp(sprintf('Error_diaread: Kanal %i ',i))
               disp(sprintf('geforderte Werte: %i',lkanal))
               disp(sprintf('eingelesene Werte: %i',count))
			      if exist('dfid','var'),fclose(dfid);end;
     	         error('nicht genug Daten gelesen, beim Lesen eines Kanales');
	         end
         end
         
         %
         % lokalen Vaktor skalieren
         %
         val = val*skal+offset;		
         
      end
      
      if exist('dfid','var')
         fclose(dfid);
      end;
      clear dfid;
   end

   
   %
   % lokaler Vektor und Einheit Struktur übergeben
   %
   d=setfield(d,name,val);
  	u=setfield(u,name,einheit);

end

cd(OriginalPathName);
if( com_flag )
    fprintf(' Ende\n')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function match=LocalCheckLine(line,checkstring)
% Überprüfen, ob line mit checkstring beginnt. Es wird nicht strcmp verwendet, 
% da manchmal ein Blank hinter dem gesuchten String ist.
match=~isempty(strmatch(checkstring,line));


%%%%%%%%
function h=LocalReadHeader(fid,endstring)
% Header-Block als Tabelle (Cell-Array) von Strings einlesen.
% Das erste Element jeder Zeile ist das, was vor dem ersten Komma steht (also die
% Nummer als String).
% Das zweite Element ist der Rest hinter dem ersten Komma.

h={};
line = fgetl(fid);
while ~LocalCheckLine(line,endstring);
   [nr,val]=strtok(line,',');
   h=[h; {nr, val(2:length(val))}]; 
   line = fgetl(fid);
end

%%%%%%%%
function [val,success]=LocalGetVal(tab,token)
% In der Tabelle tab die Zeile mit token in der ersten Spalte suchen
% und den Wert der zweiten Spalte zurückgeben.
% (Ist wohl so wie eine hash-Tabelle.)
linenr=find(strcmp(tab(:,1),token));
if isempty (linenr)
  success = 0;
  val = 0;
%   error(['Kann token: ',token,' nicht in -.dat Datei finden'])
else
  success = 1;
  val=tab{linenr,2};
end


%### begin
%%%%%%%%
function h=is_channelname_ok(str)
% Testet, ob der Kanalname im DIA-File als Feldname in Matlab gültig ist.
h=1;
if (length(str)<1),
   h=0;
elseif (~isletter(str(1))),
   h=0;
else
   for i=1:length(str),
      if	 ( (str(i)<48)             )|...    
          ( (str(i)>57)&(str(i)<65) )|...
          ( (str(i)>90)&(str(i)<95) )|...
          ( (str(i)>95)&(str(i)<97) )|...
          ( (str(i)>122) ),
   	   h=0;
   	end
   end
end
%### end

function h=remblank(str)
%Entfernt saemtliche Leerzeichen des Strings
h='';
for i=1:length(str)
   if (str(i) ~= 32)
      h=strcat(h,str(i));
   end
end

%Extrahiere den Pfadname
function p=extract_path(str)

pos=strfind(str,'\');
if( isempty(pos) )
    p = '.\';
else
    pos=max(pos);
    p=str(1:pos);
end
%Extrahiere den Pfadname
function f=extract_file(str)

str = char(str);
pos=strfind(str,'\');
if( isempty(pos) )
    f = str;
else
    pos=max(pos);
    f=str(pos+1:length(str));
end

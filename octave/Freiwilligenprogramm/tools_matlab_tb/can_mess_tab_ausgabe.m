function can_mess_tab_ausgabe(cal,ctl);
%
% Gibt die bearbeitetete CAN-Messung cal in Datei tab_file aus
% cal:
% cal(i).tline          char            Orginalbotschat
%       .zeit           double          Zeit
%       .ident          double          Identifier
%       .identhex       char            Identifier Hex
%       .name           char            Botschaftsname Name
%       .nsig           double          Anzahl erkannter Signale
%       .sig(j).name    char            Signalname
%              .startbit double
%              .bitlength double
%              .valdec  double          Rohwert
%              .val     double          skalierter Wert
%              .einheit char            Einheit
%              .valcom  char            kommentierter Wert
%
% tab_file              char            Ausgabedatei
%
% tab.tline             double          =1 tline (Orginal) wird mit ausgedruckt
% tab.botschaft

tab = ctl.tab;
fid = fopen(ctl.tab_file,'w');

 % Bezeichnung
if( tab.tline )
  fprintf(fid,'Zeit   C Idt RT dlc byte_0 - byte_dlc\n');
end
if( tab.botschaft )
  fprintf(fid,'Zeit    Idt0x  Name            Sender     byte_0 - byte_dlc      \n');
end
if( tab.signal )
  fprintf(fid,'-Nr.(sb|bl) Name                 Wert       Einheit     komment. Wert      [Rohwert   ]\n');
end

for ical = 1:length(cal)
    
    if( tab.tline )
    
        fprintf(fid,'%s\n',cal(ical).tline);
    end
    if( tab.botschaft )
        
        fprintf(fid,'%8.4f',cal(ical).zeit);
        fprintf(fid,' %4s',cal(ical).identhex);
        fprintf(fid,' %16s',cal(ical).name);
        fprintf(fid,' %15s',cal(ical).sender);
        
        for ibyte=1:cal(ical).dlc
            
            fprintf(fid,' %2s',cal(ical).valhex{ibyte});
        end
        
        
        fprintf(fid,'\n');
        
        if( tab.signal )
            fprintf(fid,'-----------------------------------------------------------------------------------------\n');
            for isig=1:length(cal(ical).sig)

                fprintf(fid,'-%2i.(%2i|%2i)',cal(ical).sig(isig).nr,cal(ical).sig(isig).startbit,cal(ical).sig(isig).bitlength);
                fprintf(fid,' %1s',cal(ical).sig(isig).mtyp);
                fprintf(fid,' %20s',cal(ical).sig(isig).name);
                
                fprintf(fid,' %10s',num2str(cal(ical).sig(isig).val));
                fprintf(fid,' %10s',cal(ical).sig(isig).einheit);
                fprintf(fid,' %20s',cal(ical).sig(isig).valcom);
                fprintf(fid,'[%10s]',num2str(cal(ical).sig(isig).valdec));
                
                
                fprintf(fid,'\n');
            end
            fprintf(fid,'-----------------------------------------------------------------------------------------\n');
        end
    end
end

fclose(fid);
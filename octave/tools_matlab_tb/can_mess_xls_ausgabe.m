function can_mess_xls_ausgabe(pbot,ctl)
% Ausgabe in xls
% cal              struct   ausgewertete und gefilterte Messung
%

xls = ctl.xls;
nsig_glob = 0;

d{1,1} = 'Nr. (Signr.)';
d{1,2} = 'Kommentar';
d{1,3} = 'Signal';
d{1,4} = 'Erklärung';
d{1,5} = 'startbit';
d{1,6} = 'bitlength';
d{1,7} = 'typ';
d{1,8} = 'einheit';
d{1,9} = 'faktor';
d{1,10} = 'offset';
d{1,11} = 'empfänger';
id = 1;


for ipbot=1:length(pbot)
    
    id = id+1;
    d{id,1} = sprintf('Botschaft: %s  ident:0x%s  sender:%s  dt:%g ms',pbot(ipbot).name,pbot(ipbot).identhex,pbot(ipbot).sender,mean(diff(pbot(ipbot).time))*1000);
    
    for isig=1:length(pbot(ipbot).sig)
        
        id = id+1;
        nsig_glob = nsig_glob + 1;

        d{id,1} = sprintf('%s. (%s.)',num2str(nsig_glob),num2str(isig));
        d{id,2} = '';
        d{id,3} = pbot(ipbot).sig(isig).name;
        
        
        d{id,4} = can_mess_xls_ausgabe_nzeilen(pbot(ipbot).sig(isig).comment,xls.width);
                
        d{id,5} = pbot(ipbot).sig(isig).startbit;
        d{id,6} = pbot(ipbot).sig(isig).bitlength;

        d{id,7} = pbot(ipbot).sig(isig).mtyp;
        d{id,8} = pbot(ipbot).sig(isig).einheit;
        d{id,9} = pbot(ipbot).sig(isig).faktor;
        d{id,10} = pbot(ipbot).sig(isig).offset;
        d{id,11} = can_mess_xls_ausgabe_nzeilen(pbot(ipbot).sig(isig).empfang,xls.width);
        
        
    end
end

xlswrite(ctl.xls_file, d);
 
function  comment = can_mess_xls_ausgabe_nzeilen(text,width);
        
    if( iscell(text) )
        ctext = text;
        text  = '';
        for i=1:length(ctext)
            text = [text,' ',ctext{i}];
        end
    end
    n = ceil(length(text)/max(1,width));

    comment = '';
    for i=1:n
        i0 = (i-1)*max(1,width)+1;
        i1 = min(i*max(1,width),length(text));
        if( i < n )
            comment = [comment,sprintf('%s\n',text(i0:i1))];
        else
            comment = [comment,sprintf('%s',text(i0:i1))];
        end
    end

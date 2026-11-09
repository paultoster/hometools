function can_mess_bot_dt_ausgabe(mess,pbot,ctl)
% Ausgabe in xls
% cal              struct   ausgewertete und gefilterte Messung
%

bot_identhex = ctl.bot_dt.identhex;
bot_ident    = hex2dec(bot_identhex);
bot_dt       = ctl.bot_dt.dt;

% Suche bot_ident in mess
%========================
bot_imess = 0;
bot_t0    = 0.0;
for imess = 1:length(mess)
    
    if( mess(imess).ident == bot_ident )
        bot_imess = imess;
        bot_t0    = mess(imess).zeit;
        break;
    end
end

% delta_t bilden
%===============
for imess = 1:length(mess)

    mess(imess).zeit = mess(imess).zeit - bot_t0;
end

% Datei öffnen
%=============
dat_file  = fullfile(ctl.save_dir,[ctl.name,'_',bot_identhex,'.dat']);
fid = fopen(dat_file,'w');

% Ausgabe mess, wenn innerhalb dt
%================================
for imess = 1:length(mess)
    
    if( abs(mess(imess).zeit) < bot_dt )
        
        ipbot = can_mess_bot_dt_dt_ausgabe_find_ipbot(mess(imess).ident,pbot);
        if( ipbot == 0 )
            error('Konnte mess(imess).ident nicht finden, Kann eigentlich nicht sein');
        end
        
        fprintf(fid,'%8.4f',mess(imess).zeit);
        fprintf(fid,' %4s',mess(imess).identhex);
        fprintf(fid,' %16s',pbot(ipbot).name);
        fprintf(fid,' %15s',pbot(ipbot).sender);
        
        for ibyte=1:mess(imess).dlc
            
            fprintf(fid,' %2s',mess(imess).valhex{ibyte});
        end
        fprintf(fid,'\n');
    end
end

% Datei schliessen
%=================
fclose(fid);
        
function ipbot_r = can_mess_bot_dt_dt_ausgabe_find_ipbot(ident,pbot)

ipbot_r = 0;

for ipbot=1:length(pbot)
    
    if( pbot(ipbot).ident == ident )
        
        ipbot_r = ipbot;
        return
    end
end

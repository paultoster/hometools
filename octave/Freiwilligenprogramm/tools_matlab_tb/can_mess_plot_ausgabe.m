function can_mess_plot_ausgabe(c_pbot,ctl)
% Plotausgabe
% cal              struct   ausgewertete und gefilterte Messung
%
% ctl.plt.typ          char     = 'botschaft'   Plotfiguren nach Botschaften sortiert
%    .nsubplot     double   Anzahl Plots pro Figure
% ctl.plt.dina4    = 1;              % Format dina4 längs:1, quer:2, normal:0
%
% pbot(i).name
ctl.plt.fig_num = 0;
if( ~isfield(ctl.plt,'dina4') )
    ctl.plt.dina4    = 1;
end
close all

if( length(strfind(lower(ctl.plt.typ),'bot')) > 0 ) % Botschaften plotten
    
    for i=1:length(c_pbot)
        ctl = can_mess_plot_ausgabe_plot_botschaft(c_pbot{i},ctl);
    end
elseif( length(strfind(lower(ctl.plt.typ),'ver')) > 0 ) % vergleichend  plotten
        ctl = can_mess_plot_ausgabe_plot_vergleich(c_pbot,ctl);
end

if( ~isempty(get_fig_numbers) )
    % Zoom all figures setzen
    zaf('set')
    % Figueren menü
    figmen
end

%==========================================================================
%==========================================================================
function     ctl = can_mess_plot_ausgabe_plot_botschaft(pbot,ctl)

for ipbot=1:length(pbot)

    nfig = ceil(length(pbot(ipbot).sig)/ctl.plt.nsubplot);
    isig = 0;
    for ifig=1:nfig
     
        if( nfig == 1 )
            plot_name = ['0x',pbot(ipbot).identhex];
        else
            plot_name = ['0x',pbot(ipbot).identhex,'_',num2str(ifig)];
        end
        ctl.plt.fig_num = p_figure(ctl.plt.fig_num+1,ctl.plt.dina4,plot_name);
        
        nsub = min(ctl.plt.nsubplot,length(pbot(ipbot).sig)-(ifig-1)*ctl.plt.nsubplot);
        
        for isub=1:nsub
            
            isig = min(isig+1,length(pbot(ipbot).sig));
            
            subplot(nsub,1,isub)
            
            plot(pbot(ipbot).time,pbot(ipbot).sig(isig).vec,'LineWidth',2)
            grid on
            
            comment = [num2str(pbot(ipbot).sig(isig).nr),'. sig: ', ...
                       pbot(ipbot).sig(isig).name,'(',pbot(ipbot).sig(isig).mtyp, ...
                       '|',num2str(pbot(ipbot).sig(isig).startbit),'|',num2str(pbot(ipbot).sig(isig).bitlength), ...
                       ') bot: (0x',pbot(ipbot).identhex,') ',pbot(ipbot).name];
                   
            comment2 = [' s:',pbot(ipbot).sender,' e:'];
%             for i=1:length(pbot(ipbot).sig(isig).empfang)
%                 
%                 for j=1:length(ctl.plt.empfang_liste)
%                     
%                     if( length(strfind(pbot(ipbot).sig(isig).empfang{i},ctl.plt.empfang_liste{j})) > 0 )                
%                         comment2 = [comment2,',',pbot(ipbot).sig(isig).empfang{i}];
%                         break;
%                     end
%                     
%                 end
%             end
            
            comment  = str_change_f(comment,'_',' ','a');
            comment2 = str_change_f(comment2,'_',' ','a');
            
            title(sprintf('%s %s',comment,comment2));
            
            ylabel(str_change_f(pbot(ipbot).sig(isig).einheit,'_',' ','a'))
            
        end
        
        % crosshair
        chs('set')
        if( ctl.plt.save_fig )
        
            hgsave([ctl.save_dir,ctl.name,'_',plot_name,'_',pbot(ipbot).name])
        end
        if( ~ctl.plt.display )
            close(ctl.plt.fig_num);
            ctl.plt.fig_num = ctl.plt.fig_num - 1;
        end
    end
end
%==========================================================================
%==========================================================================
function     ctl = can_mess_plot_ausgabe_plot_vergleich(c_pbot,ctl)

set_plot_standards

for ipbot=1:length(c_pbot{1})

    pbot = c_pbot{1};
    nfig = ceil(length(pbot(ipbot).sig)/ctl.plt.nsubplot);
    isig = 0;
    for ifig=1:nfig
     
        if( nfig == 1 )
            plot_name = ['0x',pbot(ipbot).identhex];
        else
            plot_name = ['0x',pbot(ipbot).identhex,'_',num2str(ifig)];
        end
        ctl.plt.fig_num = p_figure(ctl.plt.fig_num+1,ctl.plt.dina4,plot_name);
        
        nsub = min(ctl.plt.nsubplot,length(pbot(ipbot).sig)-(ifig-1)*ctl.plt.nsubplot);
        
        for isub=1:nsub
            
            isig = min(isig+1,length(pbot(ipbot).sig));
            
            subplot(nsub,1,isub)
            
            plot(pbot(ipbot).time,pbot(ipbot).sig(isig).vec,'LineWidth',2)
            
            % vergleich
            for ic = 2:length(c_pbot)
                hold on
                pbot1 = c_pbot{ic};
                if( length(pbot1) >= ipbot & length(pbot1(ipbot).sig) >= isig )
                    plot(pbot1(ipbot).time,pbot1(ipbot).sig(isig).vec,'LineWidth',2,'Color',PlotStandards.Farbe{ic})
                end
            end
            hold off
            grid on
            
            comment = [num2str(pbot(ipbot).sig(isig).nr),'. sig: ', ...
                       pbot(ipbot).sig(isig).name,'(',pbot(ipbot).sig(isig).mtyp, ...
                       '|',num2str(pbot(ipbot).sig(isig).startbit),'|',num2str(pbot(ipbot).sig(isig).bitlength), ...
                       ') bot: (0x',pbot(ipbot).identhex,') ',pbot(ipbot).name];
                   
            comment2 = [' s:',pbot(ipbot).sender,' e:'];
%             for i=1:length(pbot(ipbot).sig(isig).empfang)
%                 
%                 for j=1:length(ctl.plt.empfang_liste)
%                     
%                     if( length(strfind(pbot(ipbot).sig(isig).empfang{i},ctl.plt.empfang_liste{j})) > 0 )                
%                         comment2 = [comment2,',',pbot(ipbot).sig(isig).empfang{i}];
%                         break;
%                     end
%                     
%                 end
%             end
            
            comment  = str_change_f(comment,'_',' ','a');
            comment2 = str_change_f(comment2,'_',' ','a');
            
            title(sprintf('%s %s',comment,comment2));
            
            ylabel(str_change_f(pbot(ipbot).sig(isig).einheit,'_',' ','a'))
            
            if( length(c_pbot) > 1 )
                
                for ic=1:length(c_pbot)
                    
                    if( isfield(ctl.plt,'legend') & length(ctl.plt.legend) >= ic )
                        c_text{ic} = ctl.plt.legend{ic};
                    else
                        c_text{ic} = num2str(ic);
                    end
                end
                legend(c_text,'Location','Best')
            end
            
        end
        
        % crosshair
        chs('set')
        if( ctl.plt.save_fig )
        
            hgsave([ctl.save_dir,ctl.name,'_',plot_name,'_',pbot(ipbot).name])
        end
        if( ~ctl.plt.display )
            close(ctl.plt.fig_num);
            ctl.plt.fig_num = ctl.plt.fig_num - 1;
        end
    end
end
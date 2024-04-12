function zoom_all(option)

hf_act = gcf;
ha_act = gca; 

hf_all = get_fig_numbers;

for i=1:length(hf_all)
    
    fprintf('\n fig handle(%i) = %g',i,hf_all(i));
    
    
end
fprintf('\n actual fig handle = %g',hf_act);
fprintf('\n actual axis handle = %g',ha_act);

x_lim = get(gca,'XLim');

fprintf('\n Xlim_min = %g Xlim_max = %g',x_lim(1),x_lim(2));

parants = get_fig_numbers;
for (p=1:size(parants,1))
    childs = get(parants(p),'children');
    for (ch=1:size(childs,1))
        if ((strcmp( get(childs(ch),'type'),'axes') == 1) & (strcmp(get(childs(ch),'Tag'), 'legend') == 0))
            set(childs(ch),'Xlim',x_lim);
        end
    end
end

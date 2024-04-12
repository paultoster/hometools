% set_plot_standards.m
if( ~exist('PlotStandards','var') | PlotStandards.set ~= 1 )


PlotStandards.set =1;

PlotStandards.legend_choice = {'none','varname','varname+unit','filename'};
PlotStandards.format_default = 0;
PlotStandards.format_portrait = 1;
PlotStandards.format_landscape = 2;
PlotStandards.format_names = {'format_default','format_portrait','format_landscape'};
PlotStandards.bot_title_names = {'none','file_name'};
PlotStandards.Fleft = 1;
PlotStandards.Frear = 2;
PlotStandards.Rleft = 3;
PlotStandards.Rright= 4;
PlotStandards.Faxle = 5;
PlotStandards.Raxle = 6;
PlotStandards.Vehicle = 7;
PlotStandards.nFarbe = 0;

%Schwarz,Grau
PlotStandards.color_names = {'Mschwarz','Mrot','Mgruen','Mblau','Mgelb' ...
                            ,'Morange','Mlila','Mgrau','Mbraun','Merde' ...
                            ,'Mgras','Msand','Hgrau','Dgrau','Hrot'...
                            ,'Drot','Hgruen','Dgruen','Hblau','Dblau' ...
                            ,'Hgelb','Dgelb','Horange','Dorange','Hlila' ...
                            ,'Dlila','Hbraun','Dbraun','Herde' ...
                            ,'Mschwarz','Mrot','Mgruen','Mblau','Mgelb' ...
                            ,'Morange','Mlila','Mgrau','Mbraun','Merde' ...
                            ,'Mgras','Msand','Hgrau','Dgrau','Hrot'...
                            ,'Drot','Hgruen','Dgruen','Hblau','Dblau' ...
                            ,'Hgelb','Dgelb','Horange','Dorange','Hlila' ...
                            ,'Dlila','Hbraun','Dbraun','Herde' ...
                            ,'Mschwarz','Mrot','Mgruen','Mblau','Mgelb' ...
                            ,'Morange','Mlila','Mgrau','Mbraun','Merde' ...
                            ,'Mgras','Msand','Hgrau','Dgrau','Hrot'...
                            ,'Drot','Hgruen','Dgruen','Hblau','Dblau' ...
                            ,'Hgelb','Dgelb','Horange','Dorange','Hlila' ...
                            ,'Dlila','Hbraun','Dbraun','Herde' ...
                            ,'Mschwarz','Mrot','Mgruen','Mblau','Mgelb' ...
                            ,'Morange','Mlila','Mgrau','Mbraun','Merde' ...
                            ,'Mgras','Msand','Hgrau','Dgrau','Hrot'...
                            ,'Drot','Hgruen','Dgruen','Hblau','Dblau' ...
                            ,'Hgelb','Dgelb','Horange','Dorange','Hlila' ...
                            ,'Dlila','Hbraun','Dbraun','Herde' ...
                            ,'Mschwarz','Mrot','Mgruen','Mblau','Mgelb' ...
                            ,'Morange','Mlila','Mgrau','Mbraun','Merde' ...
                            ,'Mgras','Msand','Hgrau','Dgrau','Hrot'...
                            ,'Drot','Hgruen','Dgruen','Hblau','Dblau' ...
                            ,'Hgelb','Dgelb','Horange','Dorange','Hlila' ...
                            ,'Dlila','Hbraun','Dbraun','Herde' ...
                            ,'Mschwarz','Mrot','Mgruen','Mblau','Mgelb' ...
                            ,'Morange','Mlila','Mgrau','Mbraun','Merde' ...
                            ,'Mgras','Msand','Hgrau','Dgrau','Hrot'...
                            ,'Drot','Hgruen','Dgruen','Hblau','Dblau' ...
                            ,'Hgelb','Dgelb','Horange','Dorange','Hlila' ...
                            ,'Dlila','Hbraun','Dbraun','Herde' ...
                            ,'Mmagenta','Dmagenta','Hmagenta' ...
                            ,'Maqua','Daqua','Haqua' ...
                            };
PlotStandards.Mschwarz = [0,0,0];
PlotStandards.Mgrau = [0.8,0.8,0.8];
PlotStandards.Hgrau = [0.4,0.4,0.4];
PlotStandards.Dgrau = [0,0,0];

PlotStandards.nFarbe = PlotStandards.nFarbe + 1;
PlotStandards.Mfarbe{PlotStandards.nFarbe}=PlotStandards.Mschwarz;
PlotStandards.Hfarbe{PlotStandards.nFarbe}=PlotStandards.Hgrau;
PlotStandards.Dfarbe{PlotStandards.nFarbe}=PlotStandards.Dgrau;

%Mittelrot,Hellrot,Dunkelrot
PlotStandards.Mrot = [1,0,0];
PlotStandards.Hrot = [1,0.4,0.4];
PlotStandards.Drot = [0.651,0,0];

PlotStandards.nFarbe = PlotStandards.nFarbe + 1;
PlotStandards.Mfarbe{PlotStandards.nFarbe}=PlotStandards.Mrot;
PlotStandards.Hfarbe{PlotStandards.nFarbe}=PlotStandards.Hrot;
PlotStandards.Dfarbe{PlotStandards.nFarbe}=PlotStandards.Drot;

%Mittelgruen,Hellgruen,Dunkelgruen
PlotStandards.Mgruen = [0,185/255,0];
PlotStandards.Hgruen = [26/255,1,26/255];
PlotStandards.Dgruen = [0,102/255,0];

PlotStandards.nFarbe = PlotStandards.nFarbe + 1;
PlotStandards.Mfarbe{PlotStandards.nFarbe}=PlotStandards.Mgruen;
PlotStandards.Hfarbe{PlotStandards.nFarbe}=PlotStandards.Hgruen;
PlotStandards.Dfarbe{PlotStandards.nFarbe}=PlotStandards.Dgruen;

%Mittelblau,Hellblau,Dunkelblau
PlotStandards.Mblau = [0,0,1];
PlotStandards.Hblau = [136/255,136/255,1];
PlotStandards.Dblau = [0,0,94/255];

PlotStandards.nFarbe = PlotStandards.nFarbe + 1;
PlotStandards.Mfarbe{PlotStandards.nFarbe}=PlotStandards.Mblau;
PlotStandards.Hfarbe{PlotStandards.nFarbe}=PlotStandards.Hblau;
PlotStandards.Dfarbe{PlotStandards.nFarbe}=PlotStandards.Dblau;

%Mittelgelb,Hellgelb,Dunkelgelb
PlotStandards.Mgelb = [221/255,221/255,0];
PlotStandards.Hgelb = [1,1,0];
PlotStandards.Dgelb = [155/255,155/255,0];

PlotStandards.nFarbe = PlotStandards.nFarbe + 1;
PlotStandards.Mfarbe{PlotStandards.nFarbe}=PlotStandards.Mgelb;
PlotStandards.Hfarbe{PlotStandards.nFarbe}=PlotStandards.Hgelb;
PlotStandards.Dfarbe{PlotStandards.nFarbe}=PlotStandards.Dgelb;

%
PlotStandards.Mlila = [1,0,1];
PlotStandards.Hlila = [1,136/255,1];
PlotStandards.Dlila = [128/255,0,128/255];

PlotStandards.nFarbe = PlotStandards.nFarbe + 1;
PlotStandards.Mfarbe{PlotStandards.nFarbe}=PlotStandards.Mlila;
PlotStandards.Hfarbe{PlotStandards.nFarbe}=PlotStandards.Hlila;
PlotStandards.Dfarbe{PlotStandards.nFarbe}=PlotStandards.Dlila;

PlotStandards.Mbraun = [149/255,109/255,43/255];
PlotStandards.Hbraun = [218/255,183/255,124/255];
PlotStandards.Dbraun = [80/255,58/255,22/255];

PlotStandards.nFarbe = PlotStandards.nFarbe + 1;
PlotStandards.Mfarbe{PlotStandards.nFarbe}=PlotStandards.Mbraun;
PlotStandards.Hfarbe{PlotStandards.nFarbe}=PlotStandards.Hbraun;
PlotStandards.Dfarbe{PlotStandards.nFarbe}=PlotStandards.Dbraun;

%
PlotStandards.Morange = [1,0.5,0];
PlotStandards.Horange = [1,187/255,119/255];
PlotStandards.Dorange = [166/255,83/255,0];

PlotStandards.nFarbe = PlotStandards.nFarbe + 1;
PlotStandards.Mfarbe{PlotStandards.nFarbe}=PlotStandards.Morange;
PlotStandards.Hfarbe{PlotStandards.nFarbe}=PlotStandards.Horange;
PlotStandards.Dfarbe{PlotStandards.nFarbe}=PlotStandards.Dorange;

%Spezielle Farben
PlotStandards.Merde = [128/255,64/255,0];
PlotStandards.Herde = [202/255,103/255,3/255];
PlotStandards.Derde = [64/255,32/255,0/255];

PlotStandards.nFarbe = PlotStandards.nFarbe + 1;
PlotStandards.Mfarbe{PlotStandards.nFarbe}=PlotStandards.Merde;
PlotStandards.Hfarbe{PlotStandards.nFarbe}=PlotStandards.Herde;
PlotStandards.Dfarbe{PlotStandards.nFarbe}=PlotStandards.Derde;

PlotStandards.Mgras = [39/255,142/255,44/255];
PlotStandards.Hgras = [73/255,205/255,80/255];
PlotStandards.Dgras = [19/255,70/255,21/255];

PlotStandards.nFarbe = PlotStandards.nFarbe + 1;
PlotStandards.Mfarbe{PlotStandards.nFarbe}=PlotStandards.Mgras;
PlotStandards.Hfarbe{PlotStandards.nFarbe}=PlotStandards.Hgras;
PlotStandards.Dfarbe{PlotStandards.nFarbe}=PlotStandards.Dgras;

PlotStandards.Msand = [255/255,222/255,100/255];
PlotStandards.Hsand = [255/255,241/255,196/255];
PlotStandards.Dsand = [128/255,99/255,0/255];

PlotStandards.nFarbe = PlotStandards.nFarbe + 1;
PlotStandards.Mfarbe{PlotStandards.nFarbe}=PlotStandards.Msand;
PlotStandards.Hfarbe{PlotStandards.nFarbe}=PlotStandards.Hsand;
PlotStandards.Dfarbe{PlotStandards.nFarbe}=PlotStandards.Dsand;

% Magenta
PlotStandards.Mmagenta = [1,0,1];
PlotStandards.Hmagenta = [1,193/255,1];
PlotStandards.Dmagenta = [108/255,0,108/255];

PlotStandards.nFarbe = PlotStandards.nFarbe + 1;
PlotStandards.Mfarbe{PlotStandards.nFarbe}=PlotStandards.Mmagenta;
PlotStandards.Hfarbe{PlotStandards.nFarbe}=PlotStandards.Hmagenta;
PlotStandards.Dfarbe{PlotStandards.nFarbe}=PlotStandards.Dmagenta;

% Magenta
PlotStandards.Maqua = [0,1,1];
PlotStandards.Haqua = [179/255,1,1];
PlotStandards.Daqua = [0,132/255,132/255];

PlotStandards.nFarbe = PlotStandards.nFarbe + 1;
PlotStandards.Mfarbe{PlotStandards.nFarbe}=PlotStandards.Maqua;
PlotStandards.Hfarbe{PlotStandards.nFarbe}=PlotStandards.Haqua;
PlotStandards.Dfarbe{PlotStandards.nFarbe}=PlotStandards.Daqua;

PlotStandards.nMfarbe = PlotStandards.nFarbe;
PlotStandards.nHfarbe = PlotStandards.nFarbe;
PlotStandards.nDfarbe = PlotStandards.nFarbe;

PlotStandards.nFarbe = 500;
iplotstandvalue = 0;
while iplotstandvalue<PlotStandards.nFarbe
    
    for jplotstandvalue=1:PlotStandards.nMfarbe
        
        iplotstandvalue = iplotstandvalue+1;
        PlotStandards.Farbe{iplotstandvalue} = PlotStandards.Mfarbe{jplotstandvalue};
        if( iplotstandvalue >= PlotStandards.nFarbe )
            break;
        end
    end
        
    if( iplotstandvalue >= PlotStandards.nFarbe )
        break;
    end
    
    for jplotstandvalue=1:PlotStandards.nHfarbe
        
        iplotstandvalue = iplotstandvalue+1;
        PlotStandards.Farbe{iplotstandvalue} = PlotStandards.Hfarbe{jplotstandvalue};
        if( iplotstandvalue >= PlotStandards.nFarbe )
            break;
        end
    end
        
    if( iplotstandvalue >= PlotStandards.nFarbe )
        break;
    end
    for jplotstandvalue=1:PlotStandards.nDfarbe
        
        iplotstandvalue = iplotstandvalue+1;
        PlotStandards.Farbe{iplotstandvalue} = PlotStandards.Dfarbe{jplotstandvalue};
        if( iplotstandvalue >= PlotStandards.nFarbe )
            break;
        end
    end
        
    if( iplotstandvalue >= PlotStandards.nFarbe )
        break;
    end
end

dv = 0.2;
nplot_standards  = floor(1.0/dv)+1;
PlotStandards.Farbe2 = {};
for i1=1:nplot_standards
  v1 = dv*(i1-1);
  for i2=1:nplot_standards
    v2 = dv*(i2-1);
    for i3=1:nplot_standards
      v3 = dv*(i3-1);
      PlotStandards.Farbe2 = cell_add(PlotStandards.Farbe2,[v3,v1,v2]);
    end
  end
end
PlotStandards.nFarbe2 = nplot_standards*nplot_standards*nplot_standards;


PlotStandards.Ltype0 = 'none';
PlotStandards.Ltype1 ='-';
PlotStandards.Ltype2 =':';
PlotStandards.Ltype3 ='--';
PlotStandards.Ltype4 ='-.';

PlotStandards.Ltype_diff_max = 4;

PlotStandards.Ltype{1}  = PlotStandards.Ltype1 ;
PlotStandards.Ltype{2}  = PlotStandards.Ltype2 ;
PlotStandards.Ltype{3}  = PlotStandards.Ltype3 ;
PlotStandards.Ltype{4}  = PlotStandards.Ltype4 ;
PlotStandards.Ltype{5}  = PlotStandards.Ltype1 ;
PlotStandards.Ltype{6}  = PlotStandards.Ltype2 ;
PlotStandards.Ltype{7}  = PlotStandards.Ltype3 ;
PlotStandards.Ltype{8}  = PlotStandards.Ltype4 ;
PlotStandards.Ltype{9}  = PlotStandards.Ltype1 ;
PlotStandards.Ltype{10} = PlotStandards.Ltype2 ;
PlotStandards.Ltype{11} = PlotStandards.Ltype3 ;
PlotStandards.Ltype{12} = PlotStandards.Ltype4 ;
PlotStandards.Ltype{13} = PlotStandards.Ltype1 ;
PlotStandards.Ltype{14} = PlotStandards.Ltype2 ;
PlotStandards.Ltype{15} = PlotStandards.Ltype3 ;
PlotStandards.Ltype{16} = PlotStandards.Ltype4 ;
PlotStandards.Ltype{17} = PlotStandards.Ltype1 ;
PlotStandards.Ltype{18} = PlotStandards.Ltype2 ;
PlotStandards.Ltype{19} = PlotStandards.Ltype3 ;
PlotStandards.Ltype{20} = PlotStandards.Ltype4 ;
PlotStandards.Ltype{21} = PlotStandards.Ltype1 ;
PlotStandards.Ltype{22} = PlotStandards.Ltype2 ;
PlotStandards.Ltype{23} = PlotStandards.Ltype3 ;
PlotStandards.Ltype{24} = PlotStandards.Ltype4 ;
PlotStandards.Ltype{25}  = PlotStandards.Ltype1 ;
PlotStandards.Ltype{26}  = PlotStandards.Ltype2 ;
PlotStandards.Ltype{27}  = PlotStandards.Ltype3 ;
PlotStandards.Ltype{28}  = PlotStandards.Ltype4 ;
PlotStandards.Ltype{29}  = PlotStandards.Ltype1 ;
PlotStandards.Ltype{30}  = PlotStandards.Ltype2 ;
PlotStandards.Ltype{31}  = PlotStandards.Ltype3 ;
PlotStandards.Ltype{32}  = PlotStandards.Ltype4 ;
PlotStandards.Ltype{33}  = PlotStandards.Ltype1 ;
PlotStandards.Ltype{34} = PlotStandards.Ltype2 ;
PlotStandards.Ltype{35} = PlotStandards.Ltype3 ;
PlotStandards.Ltype{36} = PlotStandards.Ltype4 ;
PlotStandards.Ltype{37} = PlotStandards.Ltype1 ;
PlotStandards.Ltype{38} = PlotStandards.Ltype2 ;
PlotStandards.Ltype{39} = PlotStandards.Ltype3 ;
PlotStandards.Ltype{40} = PlotStandards.Ltype4 ;
PlotStandards.Ltype{41} = PlotStandards.Ltype1 ;
PlotStandards.Ltype{42} = PlotStandards.Ltype2 ;
PlotStandards.Ltype{43} = PlotStandards.Ltype3 ;
PlotStandards.Ltype{44} = PlotStandards.Ltype4 ;
PlotStandards.Ltype{45} = PlotStandards.Ltype1 ;
PlotStandards.Ltype{46} = PlotStandards.Ltype2 ;
PlotStandards.Ltype{47} = PlotStandards.Ltype3 ;
PlotStandards.Ltype{48} = PlotStandards.Ltype4 ;


PlotStandards.Lsize1 = 0.5;
PlotStandards.Lsize2 = 1.5;
PlotStandards.Lsize3 = 2;
PlotStandards.Lsize4 = 2.5;
PlotStandards.Lsize5 = 3;
PlotStandards.Lsize6 = 3.5;

PlotStandards.Lsize{1} = PlotStandards.Lsize1;
PlotStandards.Lsize{2} = PlotStandards.Lsize2;
PlotStandards.Lsize{3} = PlotStandards.Lsize3;
PlotStandards.Lsize{4} = PlotStandards.Lsize4;
PlotStandards.Lsize{5} = PlotStandards.Lsize5;
PlotStandards.Lsize{6} = PlotStandards.Lsize6;

PlotStandards.Mtype0 = 'none';
PlotStandards.Mtype1 = '+';
PlotStandards.Mtype2 = 'o';
PlotStandards.Mtype3 = '*';
PlotStandards.Mtype4 = '.';
PlotStandards.Mtype5 = 'x';
PlotStandards.Mtype6 = 's';
PlotStandards.Mtype7 = 'd';
PlotStandards.Mtype8 = '^';
PlotStandards.Mtype9 = 'v';
PlotStandards.Mtype10 = '>';
PlotStandards.Mtype11 = '<';
PlotStandards.Mtype12 = 'p';

PlotStandards.Mtype{1} = PlotStandards.Mtype1;
PlotStandards.Mtype{2} = PlotStandards.Mtype2;
PlotStandards.Mtype{3} = PlotStandards.Mtype3;
PlotStandards.Mtype{4} = PlotStandards.Mtype4;
PlotStandards.Mtype{5} = PlotStandards.Mtype5;
PlotStandards.Mtype{6} = PlotStandards.Mtype6;
PlotStandards.Mtype{7} = PlotStandards.Mtype7;
PlotStandards.Mtype{8} = PlotStandards.Mtype8;
PlotStandards.Mtype{9} = PlotStandards.Mtype9;
PlotStandards.Mtype{10} = PlotStandards.Mtype10;
PlotStandards.Mtype{11} = PlotStandards.Mtype11;
PlotStandards.Mtype{12} = PlotStandards.Mtype12;
PlotStandards.nMtype    = 12;

PlotStandards.nMarker = 500;
iplotstandvalue = 1;
while iplotstandvalue <= PlotStandards.nMarker
  if( iplotstandvalue == 1 )
    PlotStandards.Marker{iplotstandvalue} = PlotStandards.Mtype0;
  else
    PlotStandards.Marker{iplotstandvalue} = PlotStandards.Mtype{rem(iplotstandvalue-2,PlotStandards.nMtype)+1};
  end
  iplotstandvalue = iplotstandvalue+1;  
end
PlotStandards.Msize1 = 1.0;
PlotStandards.Msize2 = 2.0;
PlotStandards.Msize3 = 3.0;
PlotStandards.Msize4 = 4.0;
PlotStandards.Msize5 = 5.0;
PlotStandards.Msize6 = 6.0;

PlotStandards.Msize{1} = PlotStandards.Msize1;
PlotStandards.Msize{2} = PlotStandards.Msize2;
PlotStandards.Msize{3} = PlotStandards.Msize3;
PlotStandards.Msize{4} = PlotStandards.Msize4;
PlotStandards.Msize{5} = PlotStandards.Msize5;
PlotStandards.Msize{6} = PlotStandards.Msize6;

PlotStandards.Nformat = 0;
PlotStandards.Lformat = 1;
PlotStandards.Hformat = 1;
PlotStandards.Qformat = 2;

end
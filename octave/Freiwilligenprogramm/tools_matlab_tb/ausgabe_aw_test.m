% test_ausgabe_aw

Path = pwd;
[okay,s_a] = ausgabe_aw('init' ...
                       ,'name','test_ausgabe' ...
                       ,'path',Path ...
                       ,'ascii',1 ...
                       ,'word',1 ...
                       ,'ncol1',55 ...
                       ,'ncol2',10 ...
                       ,'ncol3',10 ...
                       );
                   

[okay,s_a] = ausgabe_aw('head',s_a ...
                       ,'text','Das soll der Text seinDas soll der Text seinDas soll der Text seinDas soll der Text seinDas soll der Text sein' ...
                       ,'newpage',0 ...
                       ,'char','=' ...
                       );                       
[okay,s_a] = ausgabe_aw('newline',s_a);
[okay,s_a] = ausgabe_aw('res',s_a, ...
                        'com','Geschwindigkeit' ...
                        ,'unit','[m/s]' ...
                        ,'val',50 ...
                        );
[okay,s_a] = ausgabe_aw('title',s_a ...
                       ,'text','Unter�berschrift' ...
                       ,'pos','right' ...
                       ,'uline','-' ...
                       );

                   
                       
x=[1:0.1:10]';
y=x.^2+20;
h=figure(1);
plot(x,y)
[okay,s_a] = ausgabe_aw('figure',s_a ...
                       ,'handle',h ...
                       );

[okay,s_a] = ausgabe_aw('res',s_a, ...
                        'com','Geschwindigkeit' ...
                        ,'unit','[m/s]' ...
                        ,'val',50 ...
                        );

[okay]     = ausgabe_aw('save',s_a);          
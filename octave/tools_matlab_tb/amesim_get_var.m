function [d,u] = amesim_get_var(var_file,R)
%
% [d,u] = amesim_get_var(var_file,R)
%
% var_file          Name des mat-Files ohne Endung, gespeichert wird:
%                   cliste(i).var         Variablenname AmeSim
%                   cliste(i).model       Modelname AmeSim
%                   cliste(i).unit        Einheit
%                   cliste(i).matname     Variablenname Matlab
%                   cliste(i).ipos        Position von 1 losgezählt
% R                 Ergebnis-Matrix von Amesim

if( exist([var_file,'.mat'],'file') )
    load(var_file);
else
    error('Mat-File %s.mat nicht geööfnet oder vorhanden',var_file);
end

d = [];
u = [];

for i=1:length(cliste)
    
    if( ~isempty(cliste(i).matname) )
        
        d.(cliste(i).matname) = R(cliste(i).ipos,:)';
        u.(cliste(i).matname) = cliste(i).unit;
    end
end



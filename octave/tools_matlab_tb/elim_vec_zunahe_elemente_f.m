function [a_out,i_out] = elim_vec_zunahe_elemente_f(a_in,del_a)
%
% [vec_out,i_out] = elim_vec_zunahe_elemente_f(vec_in,del_a);
%
% vec_in  Vektor input
% del_a Differenz der Abfrage
% vec_out  Vektor output
% i_out Indexliste die eliminiert wurde

del_a = abs(del_a);

[a, iliste] = sort(a_in);
i2liste = iliste;
i_out = [];
such_flag = 1;
while( such_flag )
    such_flag = 0;
    for i = 2:length(a)
        
        if( abs(a(i)-a(i-1)) < del_a )
            a      = elim_vec_element_f(a,i);
            i_out  = [i_out;i2liste(i)];
            iliste = elim_vec_element_f(iliste,i);
            i2liste = elim_vec_element_f(i2liste,i);
            for j=1:length(iliste)
                if( iliste(j) > i )
                    iliste(j) = iliste(j) - 1;
                end
            end
            such_flag = 1;
            break
        end
    end
end
a_out = a;
for i=1:length(iliste)
    
    a_out(iliste(i)) = a(i);
end
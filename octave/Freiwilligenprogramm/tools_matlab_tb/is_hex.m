function okay = is_hex(text)
% Prüft, ob wert (char) ein hexadecimalzahl ist

if( ~strcmp(class(text),'char') )
    okay = 0;
    return
end
text = str_cut_ae_f(lower(text),' ');
nc = 0;
for i=1:length(text)
    
    if( (text(i) >= '0' & text(i) <= '9') | ...
        (text(i) >= 'a' & text(i) <= 'f') )
        
        nc = nc +1;
    end
end

if nc == length(text)
    
    okay = 1;
else
    okay = 0;
        
    
end
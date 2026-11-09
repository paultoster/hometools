function     [jcell,jpos,str] = cell_find_nearest_from_ipos(c,icell,ipos,cstr,type)
%
% [jcell,jpos,str] = cell_find_nearest_from_ipos(carray,icell,ipos,cstr,type)
%
% Sucht von carr{icell}(ipos) bis an das Ende nach cstr(cellarray) den nächst gelegenen,
% wenn gefunden wird jcell > 0 und jpos > 0 zurückgegeben
%
% type = 'for':    forward
%        'back':   backward
% cstr =           cellarray mit den zu suchenden strings oder ein string
%
    
    jcell = 0;
    jpos  = 0;
    str   = '';
    if( ischar(cstr) )
      cstr = {cstr};
    end
    ncstr  = length(cstr);
    for istr = 1:ncstr
      [jc,jp] = cell_find_from_ipos(c,icell,ipos,cstr{istr},type);
      if( jc ~= 0 )
        if( jcell == 0 )
          jcell = jc;
          jpos  = jp;
          str   = cstr{istr};
        else
          if( strcmpi(type(1),'f') ) % forward
            if( (jcell <= jc) && (jpos <= jp) )
              jcell = jc;
              jpos  = jp;
              str   = cstr{istr};
            end
          else % backward
            if( (jcell >= jc) && (jpos >= jp) )
              jcell = jc;
              jpos  = jp;
              str   = cstr{istr};
            end
          end
        end
      end
    end
end
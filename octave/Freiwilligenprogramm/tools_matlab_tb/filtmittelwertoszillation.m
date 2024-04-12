function S = filtmittelwertoszillation(S,valraw)
%
%

    if( S.init == 1)
        S.init  = 2;
        S.dir   = 0;
        S.fval  = valraw;
        S.sumpos  = 0.;
        S.nsumpos = 0;
        S.sumneg  = 0.;
        S.nsumneg = 0;
    elseif( S.init == 2 )
        S.init = 0;
        if( valraw >= S.vlast )
            S.dir = 1;
            S.sumpos  = valraw+S.vlast;
            S.nsumpos = 2;
        else
            S.dir = -1;
            S.sumneg  = valraw+S.vlast;
            S.nsumneg = 2;
        end
    else
        if( S.dir > 0 )
            if( valraw < S.vlast )
              S.dir  = -1;
              S.fval = (S.sumneg+S.sumpos)/(S.nsumneg+S.nsumpos);
              S.sumneg  = valraw;
              S.nsumneg  = 1;
            else
              S.sumpos  = S.sumpos+valraw;
              S.nsumpos = S.nsumpos + 1;
            end
        else
            if( valraw >= S.vlast )
              S.dir  = 1;
              S.fval = (S.sumneg+S.sumpos)/(S.nsumneg+S.nsumpos);
              S.sumpos  = valraw;
              S.nsumpos  = 1;
            else
              S.sumneg  = S.sumneg+valraw;
              S.nsumneg = S.nsumneg + 1;
            end
        end
    end
    S.vlast = valraw;
end    
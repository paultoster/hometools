function istheir = figure_exist_figure(fignum)
%
% istheir = figure_exist_figure(fignum)
%
% fignum        figure - number or struct (ab R2004b) z.B. mit fignum = figure()
%               or fignum = plot() etc.    
% istheir       1: exist
%               0: does not exist
  istheir = 0;
  if( isobject(fignum) ) % ab R2014b 8.4.0
    i0 = figure_get_number(fignum);
    s = get(0,'children');
    for i=1:length(s)
      i1 = s(i).Number;
      if( i0 == i1 )
        istheir = 1;
        break;
      end
    end
  else % bis R2014b 8.3.0
    nnn     = get(0,'children')-fignum;
    istheir = ~isempty(find(nnn==0));

  end
end


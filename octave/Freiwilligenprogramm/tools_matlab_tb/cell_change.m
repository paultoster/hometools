function cin = cell_change(cin,such_item,replace_item)
%
% cin = cell_change(cin,such_item,replace_item)
%
% Ersetzt in Celle, wenn such_item gefunden mit replace_item
% such_item und replace_item können text oder numerisch sein
% oder 
% such_item ist Text und replace_item ist cell-Array mit Text
%
%
  ncin = length(cin);
  is_text = 0;
  if( ischar(such_item) )
    is_text = 1;
    if( iscell(replace_item) )
      is_text = 2;
    elseif( ~ischar(replace_item) )
      error('such_item und replace_item muessen beide gleich(Text) sein');
    end
  end
  if( ~is_text && ( ~isnumeric(such_item) || ~isnumeric(replace_item) ) )
    error('such_item und replace_item muessen beide gleich(numerisch oder Text) sein');
  end

  if( is_text == 2 )
    cout = {};
    nout = 0;
    for i=1:ncin
      if( ischar(cin{i}) )
        n  = length(cin{i});
        i0 = str_find_f(cin{i},such_item);
        i1 = i0+length(such_item)-1;
        if( i0 > 0 )
          cc  = {};
          ncc = 0;
          if( i0 > 1 )
            ncc = ncc+1;
            cc{ncc} = cin{i}(1:i0-1);
          end
          if( i1 < n )
            tt = cin{i}(i1+1:n);
          else
            tt = '';
          end
          cc = cell_add(cc,replace_item);
          ncc = length(cc);
          if( ~isempty(tt) )
            ncc = ncc+1;
            cc{ncc} = tt;
          end
          cout = cell_add(cout,cc);
          nout = length(cout);          
        else
          nout = nout+1;
          cout{nout} = cin{i};
        end
      else
        nout = nout+1;
        cout{nout} = cin{i};
      end
    end
    cin = cout;
  elseif( is_text == 1 )
    for i=1:ncin
      if( ischar(cin{i}) )
        cin{i} = str_change_f(cin{i},such_item,replace_item);
      end
    end
  else
    for i=1:ncin
      if( isnumeric(cin{i}) )
        [n1,m1] = size(cin{i});
        for j=1:n1
          for k=1:m1
            if( cin{i}(j,k) == such_item(1) )
              cin{i}(j,k) = replace_item(1);
            end
          end
        end
      end
    end
  end
end
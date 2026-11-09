function cc = add_to_cell_c_function(c_lines,function_name)
%
% 
%

  cc = {};
  cc = cell_add(cc,sprintf('void %s(void)',function_name));
  cc = cell_add(cc,'{');


  [jcell,jpos] =  cell_find_from_ipos(c_lines,1,1,'------','for');

  if( jcell > 0 )
    c_lines = cell_delete(c_lines,1,jcell);
  end

  for j=1:length(c_lines)
    c_lines{j} = str_cut_ae_f(c_lines{j},' ');
    if( str_find_f(c_lines{j},'FctParam.','vs') )
      i0 = str_find_f(c_lines{j},'=','vs');
      if( i0 )
        if( str_find_f(c_lines{j}(i0+1:end),'.','vs') )
          c_lines{j} = [c_lines{j},'f;'];
        else
          c_lines{j} = [c_lines{j},';'];
        end
      end
    end
  end

  cc = cell_add(cc,c_lines);
  cc = cell_add(cc,'}');

end
  
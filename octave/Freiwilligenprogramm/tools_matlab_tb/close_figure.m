function closed = close_figure(fig_num)
%
% closed = close_figure(fig_num)
%
% Löscht figure mit close()
%
  if( find_val_in_vec(get_fig_numbers,fig_num,0.1) > 0.5 )
    close(fig_num)
    closed = 1;
  else
    closed = 0;
  end
end

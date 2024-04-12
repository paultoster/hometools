set_plot_standards



c_names = fieldnames(PlotStandards);
icount = 0;
for i=1:length(c_names)
    
  if(  isnumeric(PlotStandards.(c_names{i})) ...
    && (length(PlotStandards.(c_names{i})) == 3) ...
    )
    icount = icount+1;
    fprintf('Farbe(%i):%20s\n',icount,c_names{i});
  end
end


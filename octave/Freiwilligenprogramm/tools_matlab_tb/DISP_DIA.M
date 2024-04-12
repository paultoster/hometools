function [var, names, lengths, dims, coms] = disp_dia(filename, dataSelectNr, selectedChannels)
if exist ('dataSelectNr') == 0
  dataSelectNr = 1;
end
if exist ('selectedChannels') == 0
  selectedChannels = '';
end
[var, names, lengths, dims, coms] = diaload(filename, dataSelectNr, selectedChannels);
if exist('var') == 1
  var_dim = size(var);
  i = 1;
  while (i < var_dim(1))
    plot(var(i,1:lengths(i)))
    if dims ~= []
      text('String',dims(i,:),'Color',[1.0,0.2,1.0],'HorizontalAlignment','right','VerticalAlignment','bottom','Rotation',90,'Position',[-0.13 1],'Units','normalized')
    end
    if names ~= []
      text('String',names(i,:),'Color',[1.0,1.0,0.2],'HorizontalAlignment','center','VerticalAlignment','bottom','Rotation',0,'Position',[0.45 1.03],'Units','normalized')
    end
    if coms ~= []
      text('String',coms(i,:),'Color',[0.2,1.0,1.0],'HorizontalAlignment','center','VerticalAlignment','bottom','Rotation',0,'Position',[0.45 -0.13],'Units','normalized')
    end
%    answer=input('Continue ? [Y/N] ','s');
%    if answer == 'N', break, end
%    if answer == 'n', break, end
    answer=menu('DIA-DAGO Data Display','Next Plot','Previous Plot','Quit');
    if answer == 1, i=i+1;, end
    if i > 1
      if answer == 2, i=i-1;, end
    end
    if answer == 3, break, end
  end
end

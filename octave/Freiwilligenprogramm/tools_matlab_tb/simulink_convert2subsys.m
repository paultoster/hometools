function simulink_convert2subsys(sys)
  blocks = find_system(sys, 'SearchDepth', 1);
  bh = [];
  for i = 2:length(blocks)
    bh = [bh get_param(blocks{i}, 'handle')];
  end
  Simulink.BlockDiagram.createSubSystem(bh);
end

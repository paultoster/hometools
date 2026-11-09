function flag = figmen_is_active
%FIGMEN  
% flag = figmen_is_active
%
% if figmen is active flag == 1

 flag = 0;
 numbers = get_fig_numbers;
 
 for i=1:length(numbers)
   
   h = figure(numbers(i));
   
   if( strcmp(h.Name,'figmen') )
     flag = 1;
     break;
   end
 end
end

function str = get_date_time_string(type)
%
% str = get_date_time_string(type)
% 0: yyyy_mm_dd
% 1: yyyy_mm_dd_MM
% 2: yyyy_mm_dd_MM_SS
% 
if( ~exist('type','var') )
  type = 1;
end
DateVec = datevec(datetime('now'));

str = [num2str(DateVec(1)),'_',num2str(DateVec(2)),'_',num2str(DateVec(3))];

if( type > 0 )
  str = [str,'_',num2str(DateVec(4))];
end

if( type > 1 )
  str = [str,'_',num2str(DateVec(5))];
end

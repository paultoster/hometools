function f_close(fig_num)
%
% f_close(fig_num)
% schiesst, wenn vorhandne
if( ~exist('fig_num','var') )
    fig_num = get_fig_numbers;
end

nums = get_fig_numbers;
for ifnum = 1:length(fig_num)
    for i=1:length(nums)
    
        if( nums(i) == fig_num(ifnum) )
            close(nums(i));
            break;
        end
    end
end
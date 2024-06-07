%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Space and time average function to calculate time and space average
 %  coded by ginn 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [sp_time_avg] = sp_time_avg(raw_u,group_loc)
% prerequisite is the raw_u must have the first dimension of locations and
% the second dimension of time otherwise the function will give you a wrong
% solution
temp_sp_avg            = mean(raw_u(group_loc,:),2);
sp_time_avg            = mean(temp_sp_avg);
end
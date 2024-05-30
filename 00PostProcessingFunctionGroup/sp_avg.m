%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Space and time average function to calculate time and space average
 %  coded by ginn 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [sp_avg] = sp_avg(raw_u,group_loc)
% prerequisite is the raw_u must have the first dimension of locations and
% the second dimension of time otherwise the function will give you a wrong
% solution
sp_avg            = mean(raw_u(group_loc,:),1);
end
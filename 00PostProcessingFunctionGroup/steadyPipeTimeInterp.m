%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is for find the left and right t for steady pipe to interpolate
 %  coded by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [t_left,t_right,decomposed_t,t_left_ind,t_right_ind] = steadyPipeTimeInterp(timePeriod,actual_t)
t_left      = zeros();
t_right     = zeros();

for i = 1:length(actual_t)
    %  find the intepolation left t and right t
    temp_t_left               = timePeriod(timePeriod < actual_t(i));
    [~,loc_l]                 = min(abs(temp_t_left - actual_t(i)));
    t_left(i)                 = temp_t_left(loc_l);
    temp_t_right              = timePeriod(timePeriod >= actual_t(i));
    [~,loc_r]                 = min(abs(temp_t_right - actual_t(i)));
    t_right(i)                = temp_t_right(loc_r);
end

%% this is all time step we would read
decomposed_t  =  unique(cat(2,t_left,t_right));

%% find the indx of t_left and t_right in the uniqued decomposed t
t_left_ind    = zeros(1,length(t_left));
t_right_ind   = zeros(1,length(t_right));
for i = 1:length(t_left)
    [~,t_left_ind(i)]  = min(abs(decomposed_t - t_left(i)));
    [~,t_right_ind(i)] = min(abs(decomposed_t - t_right(i)));
end
end
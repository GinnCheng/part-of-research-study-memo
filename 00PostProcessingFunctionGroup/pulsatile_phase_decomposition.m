%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Pulsatile pressure decomposition
 %  coded by Ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [actual_t,t_left,t_right,decomposed_t,t_left_ind,t_right_ind] = pulsatile_phase_decomposition(original_t_range,omega,phase,numOfPhases,numOfCycles)
%% note the second dimension of original u must be time & the period should be started at 0,0 and should be intact
% decomposed_t_left and right is the min delta t less and larger than the
% actual phase t
% num_period           =  round((t_end-t_start)*f);
time_per_period      =  2*pi/omega;
first_phase_time     =  phase*(time_per_period/numOfPhases); % +(time_per_period/4) not needed, we are selecting phase based on pressure grad
% first_phase_time     =  phase*(time_per_period/numOfPhases)+(time_per_period/4);

%% find time location
t_left       = zeros();
t_right      = zeros();
actual_t     = zeros();
% selected_loc = zeros();
numOfTimeLeft  = 1;       % how many time step we picked up
numOfTimeRight = 1;
numOfPeriod    = 1;
numOfActualT   = 1;
% phase time
pointingTime = first_phase_time + time_per_period.*(numOfPeriod - 1);


while(pointingTime <= original_t_range(end))    
    if (pointingTime >= original_t_range(1))
        %% find the left t for each phase time
         temp_original_t_range_left      = original_t_range(original_t_range < pointingTime);
         [~,selected_loc]                = min(abs(temp_original_t_range_left-pointingTime));
         t_left(numOfTimeLeft)           = temp_original_t_range_left(selected_loc);
         numOfTimeLeft = numOfTimeLeft + 1;
        %% find the right t for each phase time
         temp_original_t_range_right     = original_t_range(original_t_range >= pointingTime);
         [~,selected_loc]                = min(abs(temp_original_t_range_right-pointingTime));
         t_right(numOfTimeRight)         = temp_original_t_range_right(selected_loc);
         numOfTimeRight = numOfTimeRight + 1;
         %% record actual t
         actual_t(numOfActualT) = pointingTime; % record the actual t that we want
         numOfActualT = numOfActualT+1;
    end   
    numOfPeriod  = numOfPeriod+1;
    pointingTime = first_phase_time + time_per_period.*(numOfPeriod - 1);
end

%% pick up number of cycles that we want
if (numOfCycles > length(actual_t))
    error('WARNING! The number of actual cycles is less that required')
else
    actual_t    = actual_t(1:numOfCycles);
    t_left      = t_left(1:numOfCycles);
    t_right     = t_right(1:numOfCycles);
%     t_left_ind  = t_left_ind(1:numOfCycles);
%     t_right_ind = t_right_ind(1:numOfCycles);
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


% decomposed_t_loc    =  selected_loc;
end
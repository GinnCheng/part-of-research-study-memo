%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% This is for interpolate the right phase time for the U and p
 %%%  it depends on the to close time points
  %   coded by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is motivated by the difference of the actual phase time and
% output time steps, the difference has large impact on turbulence 
% intensity and Reynolds stress. This code could try best to interpolant
% the actual flow field in actual phase time
function U_est = phase_time_interpolant(omega,phi,t_left,t_right,actual_t,t_left_ind,t_right_ind,U,U_mean)
% amp is amplitude of the sinusoidal wave
% omega is the pressure pulsation frequencies 
% phi is the phase shift between pressure grad and velocity, normally is
% pi/2
% original_t is the actual phase time we should have
% decomposed t is the close
%% determine the t_left and t_right
U_est  = zeros(size(U_mean,1),length(actual_t));
for i = 1:length(actual_t)
    %% the estimate function
    %%% if Delta_U is not close to zero, we use sin wave interpolation
    if (abs(sin(omega.*actual_t(i)+phi)) >= 0.5)
        U_est_1 = sin(omega.*actual_t(i)+phi)./sin(omega.*t_left(i) +phi).*(U(:,t_left_ind(i))  - U_mean);
        U_est_2 = sin(omega.*actual_t(i)+phi)./sin(omega.*t_right(i)+phi).*(U(:,t_right_ind(i)) - U_mean);
        t_interval   = abs(t_right(i) - t_left(i));
        t_interval_1 = abs(t_right(i) - actual_t(i));
        t_interval_2 = abs(t_left(i)  - actual_t(i));

        U_est(:,i) = t_interval_1./t_interval.*U_est_1 + t_interval_2./t_interval.*U_est_2 + U_mean;
    else
        %%% if Delta_U is close to zero, we need to use linear
        %%% interpolation
        t_interval   = t_right(i) - t_left(i);
        t_interval_1 = t_right(i) - actual_t(i);
        t_interval_2 = -t_left(i) + actual_t(i);
        U_est(:,i) = t_interval_1./t_interval.*U(:,t_left_ind(i)) + t_interval_2./t_interval.*U(:,t_right_ind(i));
    end
    disp(['Finish interpolation for actual t = ',num2str(actual_t(i))])
end


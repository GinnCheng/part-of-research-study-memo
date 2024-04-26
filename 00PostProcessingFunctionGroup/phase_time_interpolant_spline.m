%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% This is for interpolate the right phase time for the U and p
 %%%  it depends on the to close time points
  %   coded by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is motivated by the difference of the actual phase time and
% output time steps, the difference has large impact on turbulence 
% intensity and Reynolds stress. This code could try best to interpolant
% the actual flow field in actual phase time
% NOTE: THIS IS LINEAR INTERPOLATION
function U_est = phase_time_interpolant_spline(omega,phi,t_left,t_right,actual_t,t_left_ind,t_right_ind,U)
% amp is amplitude of the sinusoidal wave
% omega is the pressure pulsation frequencies 
% phi is the phase shift between pressure grad and velocity, normally is
% pi/2
% original_t is the actual phase time we should have
% decomposed t is the close
%% determine the t_left and t_right
U_est  = zeros(size(U,1),length(actual_t));
for i = 1:length(actual_t)
    %% the estimate function
    %%% using spline intepolation
    t_neighbour        = [t_left(i),t_right(i)];
    y_neighbour        = [mean(U(:,t_left_ind(i))),mean(U(:,t_right_ind(i)))];
    slope_ends         = omega.*[cos(omega.*t_left(i)+phi),cos(omega.*t_right(i)+phi)];
    coeff_est          = spline(t_neighbour,[slope_ends(1),y_neighbour,slope_ends(2)]);
    %%% estimate the actual_t 
    y_est              = ppval(coeff_est,actual_t(i));
    t_interval         = t_right(i) - t_left(i);
    t_interval_1       = t_right(i) - actual_t(i);
    t_interval_2       = -t_left(i) + actual_t(i);

    U_est(:,i) = t_interval_1./t_interval.*U(:,t_left_ind(i)) .*(y_est./y_neighbour(1))...
               + t_interval_2./t_interval.*U(:,t_right_ind(i)).*(y_est./y_neighbour(2));
    
    disp(['Finish linear interpolation for actual t = ',num2str(actual_t(i))])
end
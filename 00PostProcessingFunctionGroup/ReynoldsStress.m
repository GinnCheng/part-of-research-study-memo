%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Root mean square function to calculate time and space average
 %  coded by ginn 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [uv_prime_mean] = ReynoldsStress(u,v,u_mean,v_mean)
u_prime       = u - u_mean;
v_prime       = v - v_mean;
uv_prime_mean = mean2(u_prime.*v_prime);
end
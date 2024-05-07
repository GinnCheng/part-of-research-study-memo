%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Root mean square function to calculate time and space average
 %  coded by ginn 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function u_rms = rootMeanSquare(u,u_mean)
    u_rms  = sqrt(mean2((u-u_mean).^2));
end
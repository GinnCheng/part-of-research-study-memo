%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is a function to do correlation
 %  coded by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function R = fluctuation_correlation(up,us)
% if (isempty(up)+isempty(us) ~= 0)
%     R = 0;
% else
% mean value
Up = mean(up,1);
Us = mean(us,1);
% fluctuation
for i = 1:length(Up)
up_prime = up(:,i)-Up(i);
us_prime = us(:,i)-Us(i);
end
% standard deviation
std_p = sqrt(mean(up_prime.^2,1));
std_s = sqrt(mean(us_prime.^2,1));
% correlation
R = mean(mean(up_prime.*us_prime,1)./(std_p.*std_s),2);
% end
end
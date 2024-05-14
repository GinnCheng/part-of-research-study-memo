%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This a function to divide skewness into positive and negative
 %  coded by Ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [S,pos_S,neg_S] = skewness_decomposition(X,X_mean)
% disp('start skewness calculation')
% find X'
X_prime = X-X_mean;
% find the total skewness
sigma = sqrt(mean2(X_prime.^2));
S = mean2(X_prime.^3)./(sigma.^3);

% find positive skewness
pos_X_prime = X_prime;
pos_X_prime(pos_X_prime <= 0) = 0;
pos_S = mean2(pos_X_prime.^3)./(sigma.^3);

% find negative skewness
neg_X_prime = X_prime;
neg_X_prime(neg_X_prime >= 0) = 0;
neg_S = mean2(neg_X_prime.^3)./(sigma.^3);

if abs(pos_S + neg_S - S) > 1e-4
    error('skewness sum is not equal')
end
% disp('finish skewness calculation')
end
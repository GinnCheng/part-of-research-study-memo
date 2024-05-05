%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is a function for quadrant analysis
 %  coded by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [uv_q1_bar,uv_q2_bar,uv_q3_bar,uv_q4_bar] = quadrantAnalysis(u,v,u_mean,v_mean)
%% find u' v'
u_prime = u-u_mean;
v_prime = v-v_mean;
% disp('start quadrant decomposition')
%% classify location of u' v' into four quadrant
loc_u_pos = u_prime;
loc_u_pos(loc_u_pos < 0) = 0;
loc_u_pos(loc_u_pos > 0) = 1;
loc_u_nag = u_prime;
loc_u_nag(loc_u_nag > 0) = 0;
loc_u_nag(loc_u_nag < 0) = 1;
loc_v_pos = v_prime;
loc_v_pos(loc_v_pos < 0) = 0;
loc_v_pos(loc_v_pos > 0) = 1;
loc_v_nag = v_prime;
loc_v_nag(loc_v_nag > 0) = 0;
loc_v_nag(loc_v_nag < 0) = 1;

%% find quadrant locations
loc_q1 = loc_u_pos.*loc_v_pos;
loc_q2 = loc_u_nag.*loc_v_pos;
loc_q3 = loc_u_nag.*loc_v_nag;
loc_q4 = loc_u_pos.*loc_v_nag; 

% %% pick up uq' vq' pos and nag
% mean_u_q1 = sum(u.*loc_q1)./sum(loc_q1);
% mean_u_q2 = sum(u.*loc_q2)./sum(loc_q2);
% mean_u_q3 = sum(u.*loc_q3)./sum(loc_q3);
% mean_u_q4 = sum(u.*loc_q4)./sum(loc_q4);
% 
% mean_v_q1 = sum(v.*loc_q1)./sum(loc_q1);
% mean_v_q2 = sum(v.*loc_q2)./sum(loc_q2);
% mean_v_q3 = sum(v.*loc_q3)./sum(loc_q3);
% mean_v_q4 = sum(v.*loc_q4)./sum(loc_q4);

%% classify four quadrant
% uv_q1 = u_prime.*loc_q1;
% uv_q2 = u_prime.*loc_q2;
% uv_q3 = u_prime.*loc_q3;
% uv_q4 = u_prime.*loc_q4;

% temp_v_q1 = v_prime.*loc_q1;
% temp_v_q2 = v_prime.*loc_q2;
% temp_v_q3 = v_prime.*loc_q3;
% temp_v_q4 = v_prime.*loc_q4;

% %% remove noughts
% u_q1 = temp_u_q1(loc_q1 ==1);
% u_q2 = temp_u_q2(loc_q2 ==1);
% u_q3 = temp_u_q3(loc_q3 ==1);
% u_q4 = temp_u_q4(loc_q4 ==1);
% 
% v_q1 = temp_v_q1(loc_q1 ==1);
% v_q2 = temp_v_q2(loc_q2 ==1);
% v_q3 = temp_v_q3(loc_q3 ==1);
% v_q4 = temp_v_q4(loc_q4 ==1);

% %% four quadrant mean
% uv_q1 = (u_q1 - mean(u_q1)).*(v_q1 - mean(v_q1));
% uv_q2 = (u_q2 - mean(u_q2)).*(v_q2 - mean(v_q2));
% uv_q3 = (u_q3 - mean(u_q3)).*(v_q3 - mean(v_q3));
% uv_q4 = (u_q4 - mean(u_q4)).*(v_q4 - mean(v_q4));

%% calculate the average
uv_q1_bar = mean2(u_prime.*v_prime.*loc_q1);
uv_q2_bar = mean2(u_prime.*v_prime.*loc_q2);
uv_q3_bar = mean2(u_prime.*v_prime.*loc_q3);
uv_q4_bar = mean2(u_prime.*v_prime.*loc_q4);
% disp('finish quadrant decomposition')
end

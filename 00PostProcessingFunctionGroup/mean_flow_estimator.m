%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% This is a code to estimate Umean by phase velocity
 %%%  Using just several phase flow field to estimate mean flow field
  %   coded by Ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function U_mean_est = mean_flow_estimator(omega,phi,U_selected,t_selected,loc_r_group)
temp_U_mean = zeros(size(U_selected,1),size(U_selected,2)-1);
%% first we need to mean the velocity field in the same radius bin location
for i = 1:length(loc_r_group)
    temp_loc = cell2mat(loc_r_group(i));
    for j = 1:length(temp_loc)
        U_selected(temp_loc(j),:) = mean(U_selected(temp_loc,:),1);
    end
end
%% now we can estimate the mean flow field
for i = 1:length(t_selected)-1
    A = sin(omega.*t_selected(i)+phi)./sin(omega.*t_selected(i+1)+phi);
    temp_U_mean(:,i) = (A.*U_selected(:,i+1)-U_selected(:,i))./(A-1);
end
U_mean_est         = mean(temp_U_mean,2);
end
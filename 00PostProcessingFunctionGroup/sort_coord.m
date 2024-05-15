%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Function for sort polar coordinate points of a cylinder mesh
 %  so that each cylinder surface with same radius can be recorded
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [avg_R,avg_theta,avg_z,loc_r_group,loc_theta_group,loc_z_group,numOfCells,indxOfSelectedCells] = sort_coord(rCoord,theta,zCoord,selected_r,selected_theta,selected_z,diff_ratio)
%% first parameters
unique_r         = unique(rCoord);
unique_theta     = unique(theta);
unique_z         = unique(zCoord);
%% select the closest radius
avg_R            = zeros();
avg_theta        = zeros();
avg_z            = zeros();
% avg_R            = selected_r;
% avg_theta        = selected_theta;
% avg_z            = selected_z;
for n = 1:length(selected_r)
    [~,indd]     = min(abs(unique_r - selected_r(n)));
    avg_R(n)     = unique_r(indd);
end
for n = 1:length(selected_theta)
    [~,indd]     = min(abs(unique_theta - selected_theta(n)));
    avg_theta(n) = unique_theta(indd);
end
for n = 1:length(selected_z)
    [~,indd]     = min(abs(unique_z - selected_z(n)));
    avg_z(n)     = unique_z(indd);
end
avg_R          = unique(avg_R);
avg_theta      = unique(avg_theta);
avg_z          = unique(avg_z);
selected_r     = avg_R;
selected_theta = avg_theta;
selected_z     = avg_z;
disp('finish select r theta and z')

loc_r_group      = cell(1,length(selected_r));
loc_theta_group  = cell(1,length(selected_theta));
loc_z_group      = cell(1,length(selected_z));

%% set varying allowable_loc_diff
allowable_loc_diff_r        = zeros(1,length(selected_r));
allowable_loc_diff_r(2:end) = diff_ratio.*(selected_r(2:end)-selected_r(1:end-1));
allowable_loc_diff_r(1)     = 0.5*allowable_loc_diff_r(2);

allowable_loc_diff_theta        = zeros(1,length(selected_theta));
allowable_loc_diff_theta(2:end) = diff_ratio.*(selected_theta(2:end)-selected_theta(1:end-1));
allowable_loc_diff_theta(1)     = 0.5*allowable_loc_diff_theta(2);

allowable_loc_diff_z        = zeros(1,length(selected_z));
allowable_loc_diff_z(2:end) = diff_ratio.*(selected_z(2:end)-selected_z(1:end-1));
allowable_loc_diff_z(1)     = 0.5*allowable_loc_diff_z(2);

%% find the radius close to the selected radius
disp('Start bin method selection')
indx_selected_r     = [];
indx_selected_theta = [];
indx_selected_z     = [];
%  find the theta and z that we want especially for roughness phase
for j = 1:length(selected_theta)
    [indx_theta,~,~]    = find(abs(theta  - selected_theta(j)) <= allowable_loc_diff_theta(j));
    indx_selected_theta = cat(1,indx_selected_theta,indx_theta);
    loc_theta_group{j}  = indx_theta;
end
for k = 1:length(selected_z)
    [indx_z,~,~]        = find(abs(zCoord - selected_z(k)) <= allowable_loc_diff_z(k));
    indx_selected_z     = cat(1,indx_selected_z,indx_z);
    loc_z_group{k}      = indx_z;
end
indx_theta_z            = intersect(indx_selected_theta,indx_selected_z);
% find the radius that we want
for i = 1:length(selected_r)
    [indx_r,~,~]        = find(abs(rCoord - selected_r(i)) <= allowable_loc_diff_r(i));
    % overlap the radius with the theta and z that we want
    indx_rr             = intersect(indx_theta_z,indx_r);
    indx_selected_r     = cat(1,indx_selected_r,indx_rr);   
    loc_r_group{i}      = indx_rr;
end
numOfCells          = length(indx_selected_r);
indxOfSelectedCells = indx_selected_r;

disp('Finish bin method selection')

end

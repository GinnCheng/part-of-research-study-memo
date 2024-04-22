%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Function to find probes location so that we can create probe files
 %  coded by Ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [probe_coord, z_pick] = findProbesLocation(vill_loc,avg_R,num_of_radius_points,cylinderOrNot,channelOrNot)
% pick only the vills in the middle of the pipe
% the first column is z locaiton
% the seconsd column is theta location
%% first pick up z locations in the middle of the pipe
z_pick  =  vill_loc(:,1);
z_pick  =  unique(z_pick);
z_pick  =  [z_pick(round(0.5*length(z_pick))),z_pick(round(0.5*length(z_pick))+1)];
%  justify whether the roughness is array-like or crisscross
[loc_r,~,~]     = find(vill_loc(:,1) == z_pick(1));
theta_pick_1    = vill_loc(loc_r,2);
[loc_r,~,~]     = find(vill_loc(:,1) == z_pick(2));
theta_pick_2    = vill_loc(loc_r,2);
%  justify whether the roughness is array-like or crisscross
if (max(abs(theta_pick_1-theta_pick_2)) < (1/3)*max(abs(theta_pick_1(2:end)-theta_pick_1(1:end-1))))
    % the roughness is array-like
    % so we only need the first
    disp('Roughness is array-like')
    % find the coordinates of probes
    disp('Note the radius location is decreasing with the third dimension')
    probe_coord = zeros(length(theta_pick_1),3,num_of_radius_points);
    if (cylinderOrNot == 1)
    for i = 1:num_of_radius_points
        temp_x              = avg_R(end-i).*cos(theta_pick_1);
        temp_y              = avg_R(end-i).*sin(theta_pick_1);
        probe_coord(:,:,i)  = [temp_x,temp_y,z_pick(1).*ones(size(temp_x))];
    end
    end
    
    if (channelOrNot == 1)
    for i = 1:num_of_radius_points
        temp_x              = theta_pick_1;
        temp_y              = avg_R(end-i).*ones(size(temp_x));
        probe_coord(:,:,i)  = [temp_x,temp_y,z_pick(1).*ones(size(temp_x))];
    end
    end
    
else
    % the roughness is cross-like
    % so we only need both
    disp('Roughness is array-like')
    % find the coordinates of probes
    disp('Note the radius location is decreasing with the third dimension')
    probe_coord = zeros((length(theta_pick_1)+length(theta_pick_2)),3,num_of_radius_points);
    
    if (cylinderOrNot == 1)
    for i = 1:num_of_radius_points
        temp_x              = [avg_R(end-i).*cos(theta_pick_1);avg_R(end-i).*cos(theta_pick_2)];
        temp_y              = [avg_R(end-i).*sin(theta_pick_1);avg_R(end-i).*sin(theta_pick_2)];
        temp_z              = [z_pick(1).*ones(size(theta_pick_1));z_pick(2).*ones(size(theta_pick_2))];
        probe_coord(:,:,i)  = [temp_x,temp_y,temp_z];
    end 
    end
    
    if (channelOrNot == 1)
    for i = 1:num_of_radius_points
        temp_x              = [theta_pick_1;theta_pick_2];
        temp_y              = [avg_R(end-i).*ones(size(theta_pick_1));avg_R(end-i).*ones(size(theta_pick_2))];
        temp_z              = [z_pick(1).*ones(size(theta_pick_1));z_pick(2).*ones(size(theta_pick_2))];
        probe_coord(:,:,i)  = [temp_x,temp_y,temp_z];
    end 
    end
    
end
end

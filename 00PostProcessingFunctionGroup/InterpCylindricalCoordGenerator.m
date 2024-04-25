%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is for new cylindrical coord for post processing
 %  coded by Ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function new_coord = InterpCylindricalCoordGenerator(r,theta,z)
% global roughWallOrNot lambda_over_R R_over_h Re_tau R
% if roughWallOrNot == 0
%% create new coord
mesh_r  = zeros(length(r)*length(theta)*length(z),1);
mesh_th = zeros(length(r)*length(theta)*length(z),1);
mesh_z  = zeros(length(r)*length(theta)*length(z),1);
%% Create a mesh with ordered streamwise location
if size(theta,1) == 1
    temp_theta  = theta;
else
    temp_theta  = theta';
end
temp_theta   = ones(length(z),1)*temp_theta;
temp_theta   = reshape(temp_theta,[length(theta)*length(z),1]);
if size(z,1) == 1
    temp_z     = z';
else
    temp_z     = z;
end
temp_z = temp_z*ones(1,length(r)*length(theta));
mesh_z = reshape(temp_z,[length(mesh_z),1]);

for i = 1:length(r)
    mesh_r(1+(i-1)*length(theta)*length(z):i*length(theta)*length(z),1)     = r(i);
    mesh_th(1+(i-1)*length(theta)*length(z):i*length(theta)*length(z),1)    = temp_theta;
end



%% get the index of the cylindrical mesh


% end
%% create new coord
new_coord                                        = zeros(size(mesh_r,1),3);
[new_coord(:,1),new_coord(:,2),new_coord(:,3)]   = pol2cart(mesh_th,mesh_r,mesh_z);
end
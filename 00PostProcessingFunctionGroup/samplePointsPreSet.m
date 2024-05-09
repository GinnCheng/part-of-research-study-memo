%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is a function to create sample coord
 %  coded by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [sample_r,sample_theta,sample_z,dr,d_theta,dz] = samplePointsPreSet(wallNormal_points,num_theta_points,num_z_points)
global R pipeLength viscous_unit
%% convert non-dimensional quantity
wallNormal_points  = wallNormal_points*viscous_unit;

% z_1                = pipeLength./(num_z_points); % this is the inlet cells z location
% z_end              = pipeLength - pipeLength./(num_z_points); % this is the outlet cells z location

%% start processing
all_r        = R - wallNormal_points;
all_r(all_r < 1e-9) = 1e-9;
all_r        = unique(all_r);
sample_r     = sort(all_r,'ascend');

sample_theta = linspace(-pi,pi,num_theta_points+1);
sample_theta = sample_theta(1:end-1);
sample_z     = linspace(0,pipeLength,num_z_points);
% sample_z     = linspace(z_1,z_end,num_z_points);
% sample_z     = unique([0,sample_z,pipeLength]);

dr           = min(abs(sample_r(2:end) - sample_r(1:end-1)));
dz           = min(abs(sample_z(2:end) - sample_z(1:end-1)));
d_theta      = min(abs(sample_theta(2:end) - sample_theta(1:end-1)));

%% Attention !!!
% this code still need to be upgraded for qudraple decomposition

end
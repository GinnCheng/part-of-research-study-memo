%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is to extended mesh grid coordinate so that the out side points
 %  can be covered
 %  coded by Ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [extended_old_coord,extended_indx] = DelaunayMeshCoordExtender(old_coord,num_of_z)
%% Attention! This is only for periodic boundary conditions of inlet/outlet pipe flow
%% first we need to find dz
disp('start expand the old coordinate');
[uniq_z,~,indx_uniq_z] = uniquetol(old_coord(:,3),0.2./num_of_z);    
if length(uniq_z) ~= num_of_z
    disp(['We have ',num2str(length(uniq_z)),' z points']);
    error(['but we expected ',num2str(num_of_z),' z points']);
else
    disp(['We have ',num2str(length(uniq_z)),' z points, as expected']);
end

%% the grid size of the end of the pipe
dz_inlet  = abs(uniq_z(end) - uniq_z(end-1));
dz_outlet = abs(uniq_z(2) - uniq_z(1));
    
%% find indx of the inlet and outlet extended part which should be 1 and end
indx_ext_inlet  = find(indx_uniq_z == num_of_z);
indx_ext_outlet = find(indx_uniq_z == 1);

%% extend the coord
inlet_ext_old_coord  = old_coord(indx_ext_inlet,:);
outlet_ext_old_coord = old_coord(indx_ext_outlet,:);
%  modify the coord
inlet_ext_old_coord(:,3)  = uniq_z(1)   - dz_inlet;
outlet_ext_old_coord(:,3) = uniq_z(end) + dz_outlet;

disp(['we have extended ',num2str(length(indx_ext_inlet)),' points for inlet']);
disp(['we have extended ',num2str(length(indx_ext_outlet)),' points for outlet']);

extended_old_coord = cat(1,old_coord,inlet_ext_old_coord,outlet_ext_old_coord);
extended_indx      = cat(1,[1:size(old_coord,1)]',indx_ext_inlet,indx_ext_outlet);
disp('finish the old coord expansion')
end

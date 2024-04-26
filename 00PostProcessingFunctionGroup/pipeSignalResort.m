%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is for pipe velocity resort
 %  coded by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function resortedCoord = pipeSignalResort(loc_r_group,loc_theta_group,loc_z_group)
% set up a resorted Coord based just on radial location
resortedCoord = cell(1,length(loc_r_group));

temp_coord    = [];

disp('start sorting')
for i = 1:length(loc_r_group)
    for j = 1:length(loc_theta_group)
        for k = 1:length(loc_z_group)
            temp_loc_1 = intersect(cell2mat(loc_z_group(k)),cell2mat(loc_theta_group(j)));
            temp_loc_2 = intersect(cell2mat(loc_r_group(i)),temp_loc_1);
            temp_coord    = cat(2,temp_coord,temp_loc_2);
        end        
    end
    resortedCoord(i) = {temp_coord};
    temp_coord    = [];
    disp(['finish ',num2str(i/length(loc_r_group)*100),'% of resorting'])
end
disp('end sorting')
end